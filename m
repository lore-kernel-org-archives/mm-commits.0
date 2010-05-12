From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-css_id-rcu-locking-for-real.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:36 -0400
Message-ID: <201005121800.o4CI041l011559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab0ELSAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix css_id() RCU locking for real
has been removed from the -mm tree.  Its filename was
     memcg-fix-css_id-rcu-locking-for-real.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix css_id() RCU locking for real
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Commit ad4ba375373937817404fd92239ef4cadbded23b ("memcg: css_id() must be
called under rcu_read_lock()") modifies memcontol.c for fixing RCU check
message.  But Andrew Morton pointed out that the fix doesn't seems sane
and it was just for hidining lockdep messages.

This is a patch for do proper things.  Checking again, all places,
accessing without rcu_read_lock, that commit fixies was intentional.... 
all callers of css_id() has reference count on it.  So, it's not necessary
to be under rcu_read_lock().

Considering again, we can use rcu_dereference_check for css_id().  We know
css->id is valid if css->refcnt > 0.  (css->id never changes and freed
after css->refcnt going to be 0.)

This patch makes use of rcu_dereference_check() in css_id/depth and remove
unnecessary rcu-read-lock added by the commit.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   15 +++++++++++++--
 mm/memcontrol.c |   19 +++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff -puN kernel/cgroup.c~memcg-fix-css_id-rcu-locking-for-real kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-fix-css_id-rcu-locking-for-real
+++ a/kernel/cgroup.c
@@ -4435,7 +4435,15 @@ __setup("cgroup_disable=", cgroup_disabl
  */
 unsigned short css_id(struct cgroup_subsys_state *css)
 {
-	struct css_id *cssid = rcu_dereference(css->id);
+	struct css_id *cssid;
+
+	/*
+	 * This css_id() can return correct value when somone has refcnt
+	 * on this or this is under rcu_read_lock(). Once css->id is allocated,
+	 * it's unchanged until freed.
+	 */
+	cssid = rcu_dereference_check(css->id,
+			rcu_read_lock_held() || atomic_read(&css->refcnt));
 
 	if (cssid)
 		return cssid->id;
@@ -4445,7 +4453,10 @@ EXPORT_SYMBOL_GPL(css_id);
 
 unsigned short css_depth(struct cgroup_subsys_state *css)
 {
-	struct css_id *cssid = rcu_dereference(css->id);
+	struct css_id *cssid;
+
+	cssid = rcu_dereference_check(css->id,
+			rcu_read_lock_held() || atomic_read(&css->refcnt));
 
 	if (cssid)
 		return cssid->depth;
diff -puN mm/memcontrol.c~memcg-fix-css_id-rcu-locking-for-real mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-css_id-rcu-locking-for-real
+++ a/mm/memcontrol.c
@@ -2314,9 +2314,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
-		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
-		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2373,10 +2371,8 @@ static int mem_cgroup_move_swap_account(
 {
 	unsigned short old_id, new_id;
 
-	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
-	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4044,16 +4040,11 @@ static int is_target_pte_for_mc(struct v
 			put_page(page);
 	}
 	/* throught */
-	if (ent.val && do_swap_account && !ret) {
-		unsigned short id;
-		rcu_read_lock();
-		id = css_id(&mc.from->css);
-		rcu_read_unlock();
-		if (id == lookup_swap_cgroup(ent)) {
-			ret = MC_TARGET_SWAP;
-			if (target)
-				target->ent = ent;
-		}
+	if (ent.val && do_swap_account && !ret &&
+			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
+		ret = MC_TARGET_SWAP;
+		if (target)
+			target->ent = ent;
 	}
 	return ret;
 }
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

