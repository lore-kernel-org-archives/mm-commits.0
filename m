From: akpm@linux-foundation.org
Subject: [merged] memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:06 -0700
Message-ID: <201107271926.p6RJQqci003151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1G0T1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: make oom_lock 0 and 1 based rather than counter
has been removed from the -mm tree.  Its filename was
     memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make oom_lock 0 and 1 based rather than counter
From: Michal Hocko <mhocko@suse.cz>

867578cb ("memcg: fix oom kill behavior") introduced oom_lock counter
which is incremented by mem_cgroup_oom_lock when we are about to handle
memcg OOM situation.  mem_cgroup_handle_oom falls back to a sleep if
oom_lock > 1 to prevent from multiple oom kills at the same time.  The
counter is then decremented by mem_cgroup_oom_unlock called from the same
function.

This works correctly but it can lead to serious starvations when we have
many processes triggering OOM and many CPUs available for them (I have
tested with 16 CPUs).

Consider a process (call it A) which gets the oom_lock (the first one that
got to mem_cgroup_handle_oom and grabbed memcg_oom_mutex) and other
processes that are blocked on the mutex.  While A releases the mutex and
calls mem_cgroup_out_of_memory others will wake up (one after another) and
increase the counter and fall into sleep (memcg_oom_waitq).

Once A finishes mem_cgroup_out_of_memory it takes the mutex again and
decreases oom_lock and wakes other tasks (if releasing memory by somebody
else - e.g.  killed process - hasn't done it yet).

Testcase would look like:
 Assume malloc XXX is a program allocating XXX Megabytes of memory
 which touches all allocated pages in a tight loop
 # swapoff SWAP_DEVICE
 # cgcreate -g memory:A
 # cgset -r memory.oom_control=0   A
 # cgset -r memory.limit_in_bytes= 200M
 # for i in `seq 100`
 # do
 #     cgexec -g memory:A   malloc 10 &
 # done

The main problem here is that all processes still race for the mutex and
there is no guarantee that we will get counter back to 0 for those that
got back to mem_cgroup_handle_oom.  In the end the whole convoy
in/decreases the counter but we do not get to 1 that would enable killing
so nothing useful can be done.  The time is basically unbounded because it
highly depends on scheduling and ordering on mutex (I have seen this
taking hours...).

This patch replaces the counter by a simple {un}lock semantic.  As
mem_cgroup_oom_{un}lock works on the a subtree of a hierarchy we have to
make sure that nobody else races with us which is guaranteed by the
memcg_oom_mutex.

We have to be careful while locking subtrees because we can encounter a
subtree which is already locked: hierarchy:

          A
        /   \
       B     \
      /\      \
     C  D     E

B - C - D tree might be already locked.  While we want to enable locking E
subtree because OOM situations cannot influence each other we definitely
do not want to allow locking A.

Therefore we have to refuse lock if any subtree is already locked and
clear up the lock for all nodes that have been set up to the failure
point.

On the other hand we have to make sure that the rest of the world will
recognize that a group is under OOM even though it doesn't have a lock. 
Therefore we have to introduce under_oom variable which is incremented and
decremented for the whole subtree when we enter resp.  leave
mem_cgroup_handle_oom.  under_oom, unlike oom_lock, doesn't need be
updated under memcg_oom_mutex because its users only check a single group
and they use atomic operations for that.

This can be checked easily by the following test case:

 # cgcreate -g memory:A
 # cgset -r memory.use_hierarchy=1 A
 # cgset -r memory.oom_control=1   A
 # cgset -r memory.limit_in_bytes= 100M
 # cgset -r memory.memsw.limit_in_bytes= 100M
 # cgcreate -g memory:A/B
 # cgset -r memory.oom_control=1 A/B
 # cgset -r memory.limit_in_bytes=20M
 # cgset -r memory.memsw.limit_in_bytes=20M
 # cgexec -g memory:A/B malloc 30  &    #->this will be blocked by OOM of group B
 # cgexec -g memory:A   malloc 80  &    #->this will be blocked by OOM of group A

While B gets oom_lock A will not get it.  Both of them go into sleep and
wait for an external action.  We can make the limit higher for A to
enforce waking it up

 # cgset -r memory.memsw.limit_in_bytes=300M A
 # cgset -r memory.limit_in_bytes=300M A

malloc in A has to wake up even though it doesn't have oom_lock.

Finally, the unlock path is very easy because we always unlock only the
subtree we have locked previously while we always decrement under_oom.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   88 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 71 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-oom_lock-0-and-1-based-rather-than-counter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-oom_lock-0-and-1-based-rather-than-counter
+++ a/mm/memcontrol.c
@@ -246,7 +246,10 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	atomic_t	oom_lock;
+
+	bool		oom_lock;
+	atomic_t	under_oom;
+
 	atomic_t	refcnt;
 
 	int	swappiness;
@@ -1722,37 +1725,83 @@ static int mem_cgroup_hierarchical_recla
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
+ * Has to be called with memcg_oom_mutex
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
-	int x, lock_count = 0;
-	struct mem_cgroup *iter;
-
-	for_each_mem_cgroup_tree(iter, mem) {
-		x = atomic_inc_return(&iter->oom_lock);
-		lock_count = max(x, lock_count);
+	int lock_count = -1;
+	struct mem_cgroup *iter, *failed = NULL;
+	bool cond = true;
+
+	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
+		bool locked = iter->oom_lock;
+
+		iter->oom_lock = true;
+		if (lock_count == -1)
+			lock_count = iter->oom_lock;
+		else if (lock_count != locked) {
+			/*
+			 * this subtree of our hierarchy is already locked
+			 * so we cannot give a lock.
+			 */
+			lock_count = 0;
+			failed = iter;
+			cond = false;
+		}
 	}
 
-	if (lock_count == 1)
-		return true;
-	return false;
+	if (!failed)
+		goto done;
+
+	/*
+	 * OK, we failed to lock the whole subtree so we have to clean up
+	 * what we set up to the failing subtree
+	 */
+	cond = true;
+	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
+		if (iter == failed) {
+			cond = false;
+			continue;
+		}
+		iter->oom_lock = false;
+	}
+done:
+	return lock_count;
 }
 
+/*
+ * Has to be called with memcg_oom_mutex
+ */
 static int mem_cgroup_oom_unlock(struct mem_cgroup *mem)
 {
 	struct mem_cgroup *iter;
 
+	for_each_mem_cgroup_tree(iter, mem)
+		iter->oom_lock = false;
+	return 0;
+}
+
+static void mem_cgroup_mark_under_oom(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, mem)
+		atomic_inc(&iter->under_oom);
+}
+
+static void mem_cgroup_unmark_under_oom(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *iter;
+
 	/*
 	 * When a new child is created while the hierarchy is under oom,
 	 * mem_cgroup_oom_lock() may not be called. We have to use
 	 * atomic_add_unless() here.
 	 */
 	for_each_mem_cgroup_tree(iter, mem)
-		atomic_add_unless(&iter->oom_lock, -1, 0);
-	return 0;
+		atomic_add_unless(&iter->under_oom, -1, 0);
 }
 
-
 static DEFINE_MUTEX(memcg_oom_mutex);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
@@ -1794,7 +1843,7 @@ static void memcg_wakeup_oom(struct mem_
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (mem && atomic_read(&mem->oom_lock))
+	if (mem && atomic_read(&mem->under_oom))
 		memcg_wakeup_oom(mem);
 }
 
@@ -1812,6 +1861,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	owait.wait.private = current;
 	INIT_LIST_HEAD(&owait.wait.task_list);
 	need_to_kill = true;
+	mem_cgroup_mark_under_oom(mem);
+
 	/* At first, try to OOM lock hierarchy under mem.*/
 	mutex_lock(&memcg_oom_mutex);
 	locked = mem_cgroup_oom_lock(mem);
@@ -1835,10 +1886,13 @@ bool mem_cgroup_handle_oom(struct mem_cg
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
 	mutex_lock(&memcg_oom_mutex);
-	mem_cgroup_oom_unlock(mem);
+	if (locked)
+		mem_cgroup_oom_unlock(mem);
 	memcg_wakeup_oom(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
+	mem_cgroup_unmark_under_oom(mem);
+
 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
 		return false;
 	/* Give chance to dying process */
@@ -4505,7 +4559,7 @@ static int mem_cgroup_oom_register_event
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-	if (atomic_read(&memcg->oom_lock))
+	if (atomic_read(&memcg->under_oom))
 		eventfd_signal(eventfd, 1);
 	mutex_unlock(&memcg_oom_mutex);
 
@@ -4540,7 +4594,7 @@ static int mem_cgroup_oom_control_read(s
 
 	cb->fill(cb, "oom_kill_disable", mem->oom_kill_disable);
 
-	if (atomic_read(&mem->oom_lock))
+	if (atomic_read(&mem->under_oom))
 		cb->fill(cb, "under_oom", 1);
 	else
 		cb->fill(cb, "under_oom", 0);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

