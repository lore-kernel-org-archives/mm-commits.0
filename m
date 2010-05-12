From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-css_is_ancestor-rcu-locking.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:39 -0400
Message-ID: <201005121800.o4CI07iR011564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab0ELSAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix css_is_ancestor() RCU locking
has been removed from the -mm tree.  Its filename was
     memcg-fix-css_is_ancestor-rcu-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix css_is_ancestor() RCU locking
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some callers (in memcontrol.c) calls css_is_ancestor() without
rcu_read_lock.  Because css_is_ancestor() has to access RCU protected
data, it should be under rcu_read_lock().

This makes css_is_ancestor() itself does safe access to RCU protected
area.  (At least, "root" can have refcnt==0 if it's not an ancestor of
"child".  So, we need rcu_read_lock().)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   31 ++++++++++++++++++++++++++-----
 mm/memcontrol.c |    4 ----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN kernel/cgroup.c~memcg-fix-css_is_ancestor-rcu-locking kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-fix-css_is_ancestor-rcu-locking
+++ a/kernel/cgroup.c
@@ -4464,15 +4464,36 @@ unsigned short css_depth(struct cgroup_s
 }
 EXPORT_SYMBOL_GPL(css_depth);
 
+/**
+ *  css_is_ancestor - test "root" css is an ancestor of "child"
+ * @child: the css to be tested.
+ * @root: the css supporsed to be an ancestor of the child.
+ *
+ * Returns true if "root" is an ancestor of "child" in its hierarchy. Because
+ * this function reads css->id, this use rcu_dereference() and rcu_read_lock().
+ * But, considering usual usage, the csses should be valid objects after test.
+ * Assuming that the caller will do some action to the child if this returns
+ * returns true, the caller must take "child";s reference count.
+ * If "child" is valid object and this returns true, "root" is valid, too.
+ */
+
 bool css_is_ancestor(struct cgroup_subsys_state *child,
 		    const struct cgroup_subsys_state *root)
 {
-	struct css_id *child_id = rcu_dereference(child->id);
-	struct css_id *root_id = rcu_dereference(root->id);
+	struct css_id *child_id;
+	struct css_id *root_id;
+	bool ret = true;
 
-	if (!child_id || !root_id || (child_id->depth < root_id->depth))
-		return false;
-	return child_id->stack[root_id->depth] == root_id->id;
+	rcu_read_lock();
+	child_id  = rcu_dereference(child->id);
+	root_id = rcu_dereference(root->id);
+	if (!child_id
+	    || !root_id
+	    || (child_id->depth < root_id->depth)
+	    || (child_id->stack[root_id->depth] != root_id->id))
+		ret = false;
+	rcu_read_unlock();
+	return ret;
 }
 
 static void __free_css_id_cb(struct rcu_head *head)
diff -puN mm/memcontrol.c~memcg-fix-css_is_ancestor-rcu-locking mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-css_is_ancestor-rcu-locking
+++ a/mm/memcontrol.c
@@ -811,12 +811,10 @@ int task_in_mem_cgroup(struct task_struc
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
-	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
-	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -1603,7 +1601,6 @@ static int __mem_cgroup_try_charge(struc
 			 * There is a small race that "from" or "to" can be
 			 * freed by rmdir, so we use css_tryget().
 			 */
-			rcu_read_lock();
 			from = mc.from;
 			to = mc.to;
 			if (from && css_tryget(&from->css)) {
@@ -1624,7 +1621,6 @@ static int __mem_cgroup_try_charge(struc
 					do_continue = (to == mem_over_limit);
 				css_put(&to->css);
 			}
-			rcu_read_unlock();
 			if (do_continue) {
 				DEFINE_WAIT(wait);
 				prepare_to_wait(&mc.waitq, &wait,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-avoid-divide-by-zero.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-move-charge-of-file-pages-fix-4.patch
memcg-update-documentation-v8.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch
mm-remove-unnecessary-use-of-atomic.patch
mm-memcontrol-uninitialised-return-value.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch

