From: akpm@linux-foundation.org
Subject: + debugobjects-scale-thresholds-with-of-cpus.patch added to -mm
 tree
Date: Thu, 05 Jan 2017 14:43:19 -0800
Message-ID: <586ecc07.sp/kyuR0XAvbee8p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763728AbdAEXGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:06:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: longman@redhat.com, borntraeger@de.ibm.com, changbin.du@intel.com, jstancek@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: scale thresholds with # of CPUs
has been added to the -mm tree.  Its filename is
     debugobjects-scale-thresholds-with-of-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjects-scale-thresholds-with-of-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjects-scale-thresholds-with-of-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: debugobjects: scale thresholds with # of CPUs

On a large SMP systems with hundreds of CPUs, the current thresholds for
allocating and freeing debug objects (256 and 1024 respectively) may not
work well.  This can cause a lot of needless calls to kmem_aloc() and
kmem_free() on those systems.

To alleviate this thrashing problem, the object freeing threshold is now
increased to "1024 + # of CPUs * 32".  Whereas the object allocation
threshold is increased to "256 + # of CPUs * 4".  That should make the
debug objects subsystem scale better with the number of CPUs available in
the system.

Link: http://lkml.kernel.org/r/1483647425-4135-3-git-send-email-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Du Changbin" <changbin.du@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-scale-thresholds-with-of-cpus lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-scale-thresholds-with-of-cpus
+++ a/lib/debugobjects.c
@@ -52,7 +52,10 @@ static int			debug_objects_fixups __read
 static int			debug_objects_warnings __read_mostly;
 static int			debug_objects_enabled __read_mostly
 				= CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT;
-
+static int			debug_objects_pool_size __read_mostly
+				= ODEBUG_POOL_SIZE;
+static int			debug_objects_pool_min_level __read_mostly
+				= ODEBUG_POOL_MIN_LEVEL;
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
 /*
@@ -94,13 +97,13 @@ static void fill_pool(void)
 	struct debug_obj *new;
 	unsigned long flags;
 
-	if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
+	if (likely(obj_pool_free >= debug_objects_pool_min_level))
 		return;
 
 	if (unlikely(!obj_cache))
 		return;
 
-	while (obj_pool_free < ODEBUG_POOL_MIN_LEVEL) {
+	while (obj_pool_free < debug_objects_pool_min_level) {
 
 		new = kmem_cache_zalloc(obj_cache, gfp);
 		if (!new)
@@ -176,7 +179,7 @@ static void free_obj_work(struct work_st
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&pool_lock, flags);
-	while (obj_pool_free > ODEBUG_POOL_SIZE) {
+	while (obj_pool_free > debug_objects_pool_size) {
 		obj = hlist_entry(obj_pool.first, typeof(*obj), node);
 		hlist_del(&obj->node);
 		obj_pool_free--;
@@ -206,7 +209,7 @@ static void free_object(struct debug_obj
 	 * schedule work when the pool is filled and the cache is
 	 * initialized:
 	 */
-	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
+	if (obj_pool_free > debug_objects_pool_size && obj_cache)
 		sched = 1;
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
@@ -1126,4 +1129,11 @@ void __init debug_objects_mem_init(void)
 		pr_warn("out of memory.\n");
 	} else
 		debug_objects_selftest();
+
+	/*
+	 * Increase the thresholds for allocating and freeing objects
+	 * according to the number of possible CPUs available in the system.
+	 */
+	debug_objects_pool_size += num_possible_cpus() * 32;
+	debug_objects_pool_min_level += num_possible_cpus() * 4;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch
debugobjects-scale-thresholds-with-of-cpus.patch
debugobjects-reduce-contention-on-the-global-pool_lock.patch

