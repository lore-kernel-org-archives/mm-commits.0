From: akpm@linux-foundation.org
Subject: + kasan-fix-races-in-quarantine_remove_cache.patch added to -mm
 tree
Date: Wed, 08 Mar 2017 15:11:47 -0800
Message-ID: <58c08fb3.0L+vs+8ZELDC1rs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdCHXgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2017 18:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, gthelen@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix races in quarantine_remove_cache()
has been added to the -mm tree.  Its filename is
     kasan-fix-races-in-quarantine_remove_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-races-in-quarantine_remove_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-races-in-quarantine_remove_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: fix races in quarantine_remove_cache()

quarantine_remove_cache() frees all pending objects that belong to the
cache, before we destroy the cache itself.  However there are currently
two possibilities how it can fail to do so.

First, another thread can hold some of the objects from the cache in temp
list in quarantine_put().  quarantine_put() has a windows of enabled
interrupts, and on_each_cpu() in quarantine_remove_cache() can finish
right in that window.  These objects will be later freed into the
destroyed cache.

Then, quarantine_reduce() has the same problem.  It grabs a batch of
objects from the global quarantine, then unlocks quarantine_lock and then
frees the batch.  quarantine_remove_cache() can finish while some objects
from the cache are still in the local to_free list in quarantine_reduce().

Fix the race with quarantine_put() by disabling interrupts for the whole
duration of quarantine_put().  In combination with on_each_cpu() in
quarantine_remove_cache() it ensures that quarantine_remove_cache() either
sees the objects in the per-cpu list or in the global list.

Fix the race with quarantine_reduce() by protecting quarantine_reduce()
with srcu critical section and then doing synchronize_srcu() at the end of
quarantine_remove_cache().

Link: http://lkml.kernel.org/r/20170308151532.5070-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   42 ++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-fix-races-in-quarantine_remove_cache mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-fix-races-in-quarantine_remove_cache
+++ a/mm/kasan/quarantine.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/srcu.h>
 
 #include "../slab.h"
 #include "kasan.h"
@@ -103,6 +104,7 @@ static int quarantine_tail;
 /* Total size of all objects in global_quarantine across all batches. */
 static unsigned long quarantine_size;
 static DEFINE_SPINLOCK(quarantine_lock);
+DEFINE_STATIC_SRCU(remove_cache_srcu);
 
 /* Maximum size of the global queue. */
 static unsigned long quarantine_max_size;
@@ -173,17 +175,22 @@ void quarantine_put(struct kasan_free_me
 	struct qlist_head *q;
 	struct qlist_head temp = QLIST_INIT;
 
+	/*
+	 * Note: irq must be disabled until after we move the batch to the
+	 * global quarantine. Otherwise quarantine_remove_cache() can miss
+	 * some objects belonging to the cache if they are in our local temp
+	 * list. quarantine_remove_cache() executes on_each_cpu() at the
+	 * beginning which ensures that it either sees the objects in per-cpu
+	 * lists or in the global quarantine.
+	 */
 	local_irq_save(flags);
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	qlist_put(q, &info->quarantine_link, cache->size);
-	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE))
+	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE)) {
 		qlist_move_all(q, &temp);
 
-	local_irq_restore(flags);
-
-	if (unlikely(!qlist_empty(&temp))) {
-		spin_lock_irqsave(&quarantine_lock, flags);
+		spin_lock(&quarantine_lock);
 		WRITE_ONCE(quarantine_size, quarantine_size + temp.bytes);
 		qlist_move_all(&temp, &global_quarantine[quarantine_tail]);
 		if (global_quarantine[quarantine_tail].bytes >=
@@ -196,20 +203,33 @@ void quarantine_put(struct kasan_free_me
 			if (new_tail != quarantine_head)
 				quarantine_tail = new_tail;
 		}
-		spin_unlock_irqrestore(&quarantine_lock, flags);
+		spin_unlock(&quarantine_lock);
 	}
+
+	local_irq_restore(flags);
 }
 
 void quarantine_reduce(void)
 {
 	size_t total_size, new_quarantine_size, percpu_quarantines;
 	unsigned long flags;
+	int srcu_idx;
 	struct qlist_head to_free = QLIST_INIT;
 
 	if (likely(READ_ONCE(quarantine_size) <=
 		   READ_ONCE(quarantine_max_size)))
 		return;
 
+	/*
+	 * srcu critical section ensures that quarantine_remove_cache()
+	 * will not miss objects belonging to the cache while they are in our
+	 * local to_free list. srcu is chosen because (1) it gives us private
+	 * grace period domain that does not interfere with anything else,
+	 * and (2) it allows synchronize_srcu() to return without waiting
+	 * if there are no pending read critical sections (which is the
+	 * expected case).
+	 */
+	srcu_idx = srcu_read_lock(&remove_cache_srcu);
 	spin_lock_irqsave(&quarantine_lock, flags);
 
 	/*
@@ -237,6 +257,7 @@ void quarantine_reduce(void)
 	spin_unlock_irqrestore(&quarantine_lock, flags);
 
 	qlist_free_all(&to_free, NULL);
+	srcu_read_unlock(&remove_cache_srcu, srcu_idx);
 }
 
 static void qlist_move_cache(struct qlist_head *from,
@@ -280,6 +301,13 @@ void quarantine_remove_cache(struct kmem
 	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
 
+	/*
+	 * Must be careful to not miss any objects that are being moved from
+	 * per-cpu list to the global quarantine in quarantine_put(),
+	 * nor objects being freed in quarantine_reduce(). on_each_cpu()
+	 * achieves the first goal, while synchronize_srcu() achieves the
+	 * second.
+	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
 	spin_lock_irqsave(&quarantine_lock, flags);
@@ -295,4 +323,6 @@ void quarantine_remove_cache(struct kmem
 	spin_unlock_irqrestore(&quarantine_lock, flags);
 
 	qlist_free_all(&to_free, cache);
+
+	synchronize_srcu(&remove_cache_srcu);
 }
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-resched-in-quarantine_remove_cache.patch
kasan-fix-races-in-quarantine_remove_cache.patch

