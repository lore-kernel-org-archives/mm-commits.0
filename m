From: akpm@linux-foundation.org
Subject: + kasan-eliminate-long-stalls-during-quarantine-reduction.patch
 added to -mm tree
Date: Tue, 15 Nov 2016 16:37:04 -0800
Message-ID: <582baa30.HMghd2234lj//vTJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934056AbcKPAhK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 19:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, andreyknvl@google.com, aryabinin@virtuozzo.com, edumazet@google.com, glider@google.com, gthelen@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: eliminate long stalls during quarantine reduction
has been added to the -mm tree.  Its filename is
     kasan-eliminate-long-stalls-during-quarantine-reduction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-eliminate-long-stalls-during-quarantine-reduction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-eliminate-long-stalls-during-quarantine-reduction.patch

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
Subject: kasan: eliminate long stalls during quarantine reduction

Currently we dedicate 1/32 of RAM for quarantine and then reduce it by 1/4
of total quarantine size.  This can be a significant amount of memory. 
For example, with 4GB of RAM total quarantine size is 128MB and it is
reduced by 32MB at a time.  With 128GB of RAM total quarantine size is 4GB
and it is reduced by 1GB.  This leads to several problems:

 - freeing 1GB can take tens of seconds, causes rcu stall warnings
   and just introduces unexpected long delays at random places
 - if kmalloc() is called under a mutex, other threads stall on that
   mutex while a thread reduces quarantine
 - threads wait on quarantine_lock while one thread grabs a large
   batch of objects to evict
 - we walk the uncached list of object to free twice which makes
   all of the above worse
 - when a thread frees objects, they are already not accounted against
   global_quarantine.bytes; as the result we can have quarantine_size
   bytes in quarantine + unbounded amount of memory in large batches
   in threads that are in process of freeing

Reduce size of quarantine in smaller batches to reduce the delays.  The
only reason to reduce it in batches is amortization of overheads, the new
batch size of 1MB should be well enough to amortize spinlock lock/unlock
and few function calls.

Plus organize quarantine as a FIFO array of batches.  This allows to not
walk the list in quarantine_reduce() under quarantine_lock, which in turn
reduces contention and is just faster.

This improves performance of heavy load (syzkaller fuzzing) by ~20% with 4
CPUs and 32GB of RAM.  Also this eliminates frequent (every 5 sec) drops
of CPU consumption from ~400% to ~100% (one thread reduces quarantine
while others are waiting on a mutex).

Some reference numbers:
1. Machine with 4 CPUs and 4GB of memory. Quarantine size 128MB.
   Currently we free 32MB at at time.
   With new code we free 1MB at a time (1024 batches, ~128 are used).
2. Machine with 32 CPUs and 128GB of memory. Quarantine size 4GB.
   Currently we free 1GB at at time.
   With new code we free 8MB at a time (1024 batches, ~512 are used).
3. Machine with 4096 CPUs and 1TB of memory. Quarantine size 32GB.
   Currently we free 8GB at at time.
   With new code we free 4MB at a time (16K batches, ~8K are used).

Link: http://lkml.kernel.org/r/1478756952-18695-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   94 ++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-eliminate-long-stalls-during-quarantine-reduction mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-eliminate-long-stalls-during-quarantine-reduction
+++ a/mm/kasan/quarantine.c
@@ -86,24 +86,9 @@ static void qlist_move_all(struct qlist_
 	qlist_init(from);
 }
 
-static void qlist_move(struct qlist_head *from, struct qlist_node *last,
-		struct qlist_head *to, size_t size)
-{
-	if (unlikely(last == from->tail)) {
-		qlist_move_all(from, to);
-		return;
-	}
-	if (qlist_empty(to))
-		to->head = from->head;
-	else
-		to->tail->next = from->head;
-	to->tail = last;
-	from->head = last->next;
-	last->next = NULL;
-	from->bytes -= size;
-	to->bytes += size;
-}
-
+#define QUARANTINE_PERCPU_SIZE (1 << 20)
+#define QUARANTINE_BATCHES \
+	(1024 > 4 * CONFIG_NR_CPUS ? 1024 : 4 * CONFIG_NR_CPUS)
 
 /*
  * The object quarantine consists of per-cpu queues and a global queue,
@@ -111,11 +96,22 @@ static void qlist_move(struct qlist_head
  */
 static DEFINE_PER_CPU(struct qlist_head, cpu_quarantine);
 
-static struct qlist_head global_quarantine;
+/* Round-robin FIFO array of batches. */
+static struct qlist_head global_quarantine[QUARANTINE_BATCHES];
+static int quarantine_head;
+static int quarantine_tail;
+/* Total size of all objects in global_quarantine across all batches. */
+static unsigned long quarantine_size;
 static DEFINE_SPINLOCK(quarantine_lock);
 
 /* Maximum size of the global queue. */
-static unsigned long quarantine_size;
+static unsigned long quarantine_max_size;
+
+/*
+ * Target size of a batch in global_quarantine.
+ * Usually equal to QUARANTINE_PERCPU_SIZE unless we have too much RAM.
+ */
+static unsigned long quarantine_batch_size;
 
 /*
  * The fraction of physical memory the quarantine is allowed to occupy.
@@ -124,9 +120,6 @@ static unsigned long quarantine_size;
  */
 #define QUARANTINE_FRACTION 32
 
-#define QUARANTINE_LOW_SIZE (READ_ONCE(quarantine_size) * 3 / 4)
-#define QUARANTINE_PERCPU_SIZE (1 << 20)
-
 static struct kmem_cache *qlink_to_cache(struct qlist_node *qlink)
 {
 	return virt_to_head_page(qlink)->slab_cache;
@@ -191,21 +184,30 @@ void quarantine_put(struct kasan_free_me
 
 	if (unlikely(!qlist_empty(&temp))) {
 		spin_lock_irqsave(&quarantine_lock, flags);
-		qlist_move_all(&temp, &global_quarantine);
+		WRITE_ONCE(quarantine_size, quarantine_size + temp.bytes);
+		qlist_move_all(&temp, &global_quarantine[quarantine_tail]);
+		if (global_quarantine[quarantine_tail].bytes >=
+				READ_ONCE(quarantine_batch_size)) {
+			int new_tail;
+
+			new_tail = quarantine_tail + 1;
+			if (new_tail == QUARANTINE_BATCHES)
+				new_tail = 0;
+			if (new_tail != quarantine_head)
+				quarantine_tail = new_tail;
+		}
 		spin_unlock_irqrestore(&quarantine_lock, flags);
 	}
 }
 
 void quarantine_reduce(void)
 {
-	size_t new_quarantine_size, percpu_quarantines;
+	size_t total_size, new_quarantine_size, percpu_quarantines;
 	unsigned long flags;
 	struct qlist_head to_free = QLIST_INIT;
-	size_t size_to_free = 0;
-	struct qlist_node *last;
 
-	if (likely(READ_ONCE(global_quarantine.bytes) <=
-		   READ_ONCE(quarantine_size)))
+	if (likely(READ_ONCE(quarantine_size) <=
+		   READ_ONCE(quarantine_max_size)))
 		return;
 
 	spin_lock_irqsave(&quarantine_lock, flags);
@@ -214,24 +216,23 @@ void quarantine_reduce(void)
 	 * Update quarantine size in case of hotplug. Allocate a fraction of
 	 * the installed memory to quarantine minus per-cpu queue limits.
 	 */
-	new_quarantine_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
+	total_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
 		QUARANTINE_FRACTION;
 	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
-	new_quarantine_size = (new_quarantine_size < percpu_quarantines) ?
-		0 : new_quarantine_size - percpu_quarantines;
-	WRITE_ONCE(quarantine_size, new_quarantine_size);
-
-	last = global_quarantine.head;
-	while (last) {
-		struct kmem_cache *cache = qlink_to_cache(last);
-
-		size_to_free += cache->size;
-		if (!last->next || size_to_free >
-		    global_quarantine.bytes - QUARANTINE_LOW_SIZE)
-			break;
-		last = last->next;
+	new_quarantine_size = (total_size < percpu_quarantines) ?
+		0 : total_size - percpu_quarantines;
+	WRITE_ONCE(quarantine_max_size, new_quarantine_size);
+	/* Aim at consuming at most 1/2 of slots in quarantine. */
+	WRITE_ONCE(quarantine_batch_size, max((size_t)QUARANTINE_PERCPU_SIZE,
+		2 * total_size / QUARANTINE_BATCHES));
+
+	if (likely(quarantine_size > quarantine_max_size)) {
+		qlist_move_all(&global_quarantine[quarantine_head], &to_free);
+		WRITE_ONCE(quarantine_size, quarantine_size - to_free.bytes);
+		quarantine_head++;
+		if (quarantine_head == QUARANTINE_BATCHES)
+			quarantine_head = 0;
 	}
-	qlist_move(&global_quarantine, last, &to_free, size_to_free);
 
 	spin_unlock_irqrestore(&quarantine_lock, flags);
 
@@ -275,13 +276,14 @@ static void per_cpu_remove_cache(void *a
 
 void quarantine_remove_cache(struct kmem_cache *cache)
 {
-	unsigned long flags;
+	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
 
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
 	spin_lock_irqsave(&quarantine_lock, flags);
-	qlist_move_cache(&global_quarantine, &to_free, cache);
+	for (i = 0; i < QUARANTINE_BATCHES; i++)
+		qlist_move_cache(&global_quarantine[i], &to_free, cache);
 	spin_unlock_irqrestore(&quarantine_lock, flags);
 
 	qlist_free_all(&to_free, cache);
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-support-panic_on_warn.patch
kasan-eliminate-long-stalls-during-quarantine-reduction.patch
kasan-update-kasan_global-for-gcc-7.patch
kasan-support-use-after-scope-detection.patch

