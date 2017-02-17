From: akpm@linux-foundation.org
Subject: [alternative-merged]
 debugobjects-reduce-contention-on-the-global-pool_lock.patch removed from
 -mm tree
Date: Fri, 17 Feb 2017 12:32:24 -0800
Message-ID: <58a75dd8.WkfJOjACYRhIVLHy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934938AbdBQUch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2017 15:32:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: longman@redhat.com, borntraeger@de.ibm.com, changbin.du@intel.com, jstancek@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: reduce contention on the global pool_lock
has been removed from the -mm tree.  Its filename was
     debugobjects-reduce-contention-on-the-global-pool_lock.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: debugobjects: reduce contention on the global pool_lock

On a large SMP system with many CPUs, the global pool_lock may become a
performance bottleneck as all the CPUs that need to allocate or free debug
objects have to take the lock.  That can sometimes cause soft lockups
like:

 NMI watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [rcuos/1:21]
 ...
 RIP: 0010:[<ffffffff817c216b>]  [<ffffffff817c216b>]
	_raw_spin_unlock_irqrestore+0x3b/0x60
 ...
 Call Trace:
  [<ffffffff813f40d1>] free_object+0x81/0xb0
  [<ffffffff813f4f33>] debug_check_no_obj_freed+0x193/0x220
  [<ffffffff81101a59>] ? trace_hardirqs_on_caller+0xf9/0x1c0
  [<ffffffff81284996>] ? file_free_rcu+0x36/0x60
  [<ffffffff81251712>] kmem_cache_free+0xd2/0x380
  [<ffffffff81284960>] ? fput+0x90/0x90
  [<ffffffff81284996>] file_free_rcu+0x36/0x60
  [<ffffffff81124c23>] rcu_nocb_kthread+0x1b3/0x550
  [<ffffffff81124b71>] ? rcu_nocb_kthread+0x101/0x550
  [<ffffffff81124a70>] ? sync_exp_work_done.constprop.63+0x50/0x50
  [<ffffffff810c59d1>] kthread+0x101/0x120
  [<ffffffff81101a59>] ? trace_hardirqs_on_caller+0xf9/0x1c0
  [<ffffffff817c2d32>] ret_from_fork+0x22/0x50

To reduce the amount of contention on the pool_lock, the actual
kmem_cache_free() of the debug objects will be delayed if the pool_lock is
busy.  This will temporarily increase the amount of free objects available
at the free pool when the system is busy.  As a result, the number of
kmem_cache allocation and freeing should be reduced.

This patch also groups the freeing of debug objects in a batch of 4 to
reduce the total number of lock/unlock cycles.

Link: http://lkml.kernel.org/r/1483647425-4135-4-git-send-email-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Du Changbin" <changbin.du@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-reduce-contention-on-the-global-pool_lock lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-reduce-contention-on-the-global-pool_lock
+++ a/lib/debugobjects.c
@@ -172,25 +172,38 @@ alloc_object(void *addr, struct debug_bu
 
 /*
  * workqueue function to free objects.
+ *
+ * To reduce contention on the global pool_lock, the actual freeing of
+ * debug objects will be delayed if the pool_lock is busy. We also free
+ * the objects in a batch of 4 for each lock/unlock cycle.
  */
+#define ODEBUG_FREE_BATCH	4
 static void free_obj_work(struct work_struct *work)
 {
-	struct debug_obj *obj;
+	struct debug_obj *objs[ODEBUG_FREE_BATCH];
 	unsigned long flags;
+	int i;
 
-	raw_spin_lock_irqsave(&pool_lock, flags);
-	while (obj_pool_free > debug_objects_pool_size) {
-		obj = hlist_entry(obj_pool.first, typeof(*obj), node);
-		hlist_del(&obj->node);
-		obj_pool_free--;
-		debug_objects_freed++;
+	if (!raw_spin_trylock_irqsave(&pool_lock, flags))
+		return;
+	while (obj_pool_free >= debug_objects_pool_size + ODEBUG_FREE_BATCH) {
+		for (i = 0; i < ODEBUG_FREE_BATCH; i++) {
+			objs[i] = hlist_entry(obj_pool.first,
+					      typeof(*objs[0]), node);
+			hlist_del(&objs[i]->node);
+		}
+
+		obj_pool_free -= ODEBUG_FREE_BATCH;
+		debug_objects_freed += ODEBUG_FREE_BATCH;
 		/*
 		 * We release pool_lock across kmem_cache_free() to
 		 * avoid contention on pool_lock.
 		 */
 		raw_spin_unlock_irqrestore(&pool_lock, flags);
-		kmem_cache_free(obj_cache, obj);
-		raw_spin_lock_irqsave(&pool_lock, flags);
+		for (i = 0; i < ODEBUG_FREE_BATCH; i++)
+			kmem_cache_free(obj_cache, objs[i]);
+		if (!raw_spin_trylock_irqsave(&pool_lock, flags))
+			return;
 	}
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
 }
_

Patches currently in -mm which might be from longman@redhat.com are


