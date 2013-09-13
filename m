From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch removed from -mm
 tree
Date: Fri, 13 Sep 2013 13:02:30 -0700
Message-ID: <52336f56.430xsEkvfGOS6LNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: [merged] mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch removed from -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:30 -0700


The patch titled
     Subject: mm: memcg: rework and document OOM waiting and wakeup
has been removed from the -mm tree.  Its filename was
     mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: rework and document OOM waiting and wakeup

The memcg OOM handler open-codes a sleeping lock for OOM serialization
(trylock, wait, repeat) because the required locking is so specific to
memcg hierarchies.  However, it would be nice if this construct would be
clearly recognizable and not be as obfuscated as it is right now.  Clean
up as follows:

1. Remove the return value of mem_cgroup_oom_unlock()

2. Rename mem_cgroup_oom_lock() to mem_cgroup_oom_trylock().

3. Pull the prepare_to_wait() out of the memcg_oom_lock scope.  This
   makes it more obvious that the task has to be on the waitqueue
   before attempting to OOM-trylock the hierarchy, to not miss any
   wakeups before going to sleep.  It just didn't matter until now
   because it was all lumped together into the global memcg_oom_lock
   spinlock section.

4. Pull the mem_cgroup_oom_notify() out of the memcg_oom_lock scope.
   It is proctected by the hierarchical OOM-lock.

5. The memcg_oom_lock spinlock is only required to propagate the OOM
   lock in any given hierarchy atomically.  Restrict its scope to
   mem_cgroup_oom_(trylock|unlock).

6. Do not wake up the waitqueue unconditionally at the end of the
   function.  Only the lockholder has to wake up the next in line
   after releasing the lock.

   Note that the lockholder kicks off the OOM-killer, which in turn
   leads to wakeups from the uncharges of the exiting task.  But a
   contender is not guaranteed to see them if it enters the OOM path
   after the OOM kills but before the lockholder releases the lock.
   Thus there has to be an explicit wakeup after releasing the lock.

7. Put the OOM task on the waitqueue before marking the hierarchy as
   under OOM as that is the point where we start to receive wakeups.
   No point in listening before being on the waitqueue.

8. Likewise, unmark the hierarchy before finishing the sleep, for
   symmetry.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   83 +++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 37 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-rework-and-document-oom-waiting-and-wakeup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-rework-and-document-oom-waiting-and-wakeup
+++ a/mm/memcontrol.c
@@ -1916,15 +1916,18 @@ mem_cgroup_soft_reclaim_eligible(struct
 	return SKIP;
 }
 
+static DEFINE_SPINLOCK(memcg_oom_lock);
+
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
- * Has to be called with memcg_oom_lock
  */
-static bool mem_cgroup_oom_lock(struct mem_cgroup *memcg)
+static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter, *failed = NULL;
 
+	spin_lock(&memcg_oom_lock);
+
 	for_each_mem_cgroup_tree(iter, memcg) {
 		if (iter->oom_lock) {
 			/*
@@ -1938,33 +1941,33 @@ static bool mem_cgroup_oom_lock(struct m
 			iter->oom_lock = true;
 	}
 
-	if (!failed)
-		return true;
-
-	/*
-	 * OK, we failed to lock the whole subtree so we have to clean up
-	 * what we set up to the failing subtree
-	 */
-	for_each_mem_cgroup_tree(iter, memcg) {
-		if (iter == failed) {
-			mem_cgroup_iter_break(memcg, iter);
-			break;
+	if (failed) {
+		/*
+		 * OK, we failed to lock the whole subtree so we have
+		 * to clean up what we set up to the failing subtree
+		 */
+		for_each_mem_cgroup_tree(iter, memcg) {
+			if (iter == failed) {
+				mem_cgroup_iter_break(memcg, iter);
+				break;
+			}
+			iter->oom_lock = false;
 		}
-		iter->oom_lock = false;
 	}
-	return false;
+
+	spin_unlock(&memcg_oom_lock);
+
+	return !failed;
 }
 
-/*
- * Has to be called with memcg_oom_lock
- */
-static int mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
+static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter;
 
+	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
 		iter->oom_lock = false;
-	return 0;
+	spin_unlock(&memcg_oom_lock);
 }
 
 static void mem_cgroup_mark_under_oom(struct mem_cgroup *memcg)
@@ -1988,7 +1991,6 @@ static void mem_cgroup_unmark_under_oom(
 		atomic_add_unless(&iter->under_oom, -1, 0);
 }
 
-static DEFINE_SPINLOCK(memcg_oom_lock);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
 struct oom_wait_info {
@@ -2035,45 +2037,52 @@ static bool mem_cgroup_handle_oom(struct
 				  int order)
 {
 	struct oom_wait_info owait;
-	bool locked, need_to_kill;
+	bool locked;
 
 	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
 	owait.wait.private = current;
 	INIT_LIST_HEAD(&owait.wait.task_list);
-	need_to_kill = true;
-	mem_cgroup_mark_under_oom(memcg);
 
-	/* At first, try to OOM lock hierarchy under memcg.*/
-	spin_lock(&memcg_oom_lock);
-	locked = mem_cgroup_oom_lock(memcg);
 	/*
+	 * As with any blocking lock, a contender needs to start
+	 * listening for wakeups before attempting the trylock,
+	 * otherwise it can miss the wakeup from the unlock and sleep
+	 * indefinitely.  This is just open-coded because our locking
+	 * is so particular to memcg hierarchies.
+	 *
 	 * Even if signal_pending(), we can't quit charge() loop without
 	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
 	 * under OOM is always welcomed, use TASK_KILLABLE here.
 	 */
 	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
-	if (!locked || memcg->oom_kill_disable)
-		need_to_kill = false;
+	mem_cgroup_mark_under_oom(memcg);
+
+	locked = mem_cgroup_oom_trylock(memcg);
+
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
-	spin_unlock(&memcg_oom_lock);
 
-	if (need_to_kill) {
+	if (locked && !memcg->oom_kill_disable) {
+		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, mask, order);
 	} else {
 		schedule();
+		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
-	spin_lock(&memcg_oom_lock);
-	if (locked)
-		mem_cgroup_oom_unlock(memcg);
-	memcg_wakeup_oom(memcg);
-	spin_unlock(&memcg_oom_lock);
 
-	mem_cgroup_unmark_under_oom(memcg);
+	if (locked) {
+		mem_cgroup_oom_unlock(memcg);
+		/*
+		 * There is no guarantee that an OOM-lock contender
+		 * sees the wakeups triggered by the OOM kill
+		 * uncharges.  Wake any sleepers explicitely.
+		 */
+		memcg_oom_recover(memcg);
+	}
 
 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
 		return false;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

