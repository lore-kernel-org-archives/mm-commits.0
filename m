From: akpm@linux-foundation.org
Subject: [merged] cgroup-avoid-permanent-sleep-at-rmdir-v7.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:12 -0700
Message-ID: <200907302037.n6UKbCf0011064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZG3UhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     cgroup avoid permanent sleep at rmdir
has been removed from the -mm tree.  Its filename was
     cgroup-avoid-permanent-sleep-at-rmdir-v7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup avoid permanent sleep at rmdir
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

After commit ec64f51545fffbc4cb968f0cea56341a4b07e85a ("cgroup: fix
frequent -EBUSY at rmdir"), cgroup's rmdir (especially against memcg)
doesn't return -EBUSY by temporary ref counts.  That commit expects all
refs after pre_destroy() is temporary but...it wasn't.  Then, rmdir can
wait permanently.  This patch tries to fix that and change followings.

 - set CGRP_WAIT_ON_RMDIR flag before pre_destroy().
 - clear CGRP_WAIT_ON_RMDIR flag when the subsys finds racy case.
   if there are sleeping ones, wakes them up.
 - rmdir() sleeps only when CGRP_WAIT_ON_RMDIR flag is set.

Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Paul Menage <menage@google.com>
Acked-by: Balbir Sigh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   17 ++++++++++++
 kernel/cgroup.c        |   55 ++++++++++++++++++++++++++-------------
 mm/memcontrol.c        |   23 ++++++++++++++--
 3 files changed, 75 insertions(+), 20 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-avoid-permanent-sleep-at-rmdir-v7 include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-avoid-permanent-sleep-at-rmdir-v7
+++ a/include/linux/cgroup.h
@@ -363,6 +363,23 @@ int cgroup_task_count(const struct cgrou
 int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
 
 /*
+ * When the subsys has to access css and may add permanent refcnt to css,
+ * it should take care of racy conditions with rmdir(). Following set of
+ * functions, is for stop/restart rmdir if necessary.
+ * Because these will call css_get/put, "css" should be alive css.
+ *
+ *  cgroup_exclude_rmdir();
+ *  ...do some jobs which may access arbitrary empty cgroup
+ *  cgroup_release_and_wakeup_rmdir();
+ *
+ *  When someone removes a cgroup while cgroup_exclude_rmdir() holds it,
+ *  it sleeps and cgroup_release_and_wakeup_rmdir() will wake him up.
+ */
+
+void cgroup_exclude_rmdir(struct cgroup_subsys_state *css);
+void cgroup_release_and_wakeup_rmdir(struct cgroup_subsys_state *css);
+
+/*
  * Control Group subsystem type.
  * See Documentation/cgroups/cgroups.txt for details
  */
diff -puN kernel/cgroup.c~cgroup-avoid-permanent-sleep-at-rmdir-v7 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-avoid-permanent-sleep-at-rmdir-v7
+++ a/kernel/cgroup.c
@@ -735,16 +735,28 @@ static void cgroup_d_remove_dir(struct d
  * reference to css->refcnt. In general, this refcnt is expected to goes down
  * to zero, soon.
  *
- * CGRP_WAIT_ON_RMDIR flag is modified under cgroup's inode->i_mutex;
+ * CGRP_WAIT_ON_RMDIR flag is set under cgroup's inode->i_mutex;
  */
 DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
 
-static void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
+static void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
 {
-	if (unlikely(test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
+	if (unlikely(test_and_clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
 		wake_up_all(&cgroup_rmdir_waitq);
 }
 
+void cgroup_exclude_rmdir(struct cgroup_subsys_state *css)
+{
+	css_get(css);
+}
+
+void cgroup_release_and_wakeup_rmdir(struct cgroup_subsys_state *css)
+{
+	cgroup_wakeup_rmdir_waiter(css->cgroup);
+	css_put(css);
+}
+
+
 static int rebind_subsystems(struct cgroupfs_root *root,
 			      unsigned long final_bits)
 {
@@ -1359,7 +1371,7 @@ int cgroup_attach_task(struct cgroup *cg
 	 * wake up rmdir() waiter. the rmdir should fail since the cgroup
 	 * is no longer empty.
 	 */
-	cgroup_wakeup_rmdir_waiters(cgrp);
+	cgroup_wakeup_rmdir_waiter(cgrp);
 	return 0;
 }
 
@@ -2744,33 +2756,42 @@ again:
 	mutex_unlock(&cgroup_mutex);
 
 	/*
+	 * In general, subsystem has no css->refcnt after pre_destroy(). But
+	 * in racy cases, subsystem may have to get css->refcnt after
+	 * pre_destroy() and it makes rmdir return with -EBUSY. This sometimes
+	 * make rmdir return -EBUSY too often. To avoid that, we use waitqueue
+	 * for cgroup's rmdir. CGRP_WAIT_ON_RMDIR is for synchronizing rmdir
+	 * and subsystem's reference count handling. Please see css_get/put
+	 * and css_tryget() and cgroup_wakeup_rmdir_waiter() implementation.
+	 */
+	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+
+	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
 	 * that rmdir() request comes.
 	 */
 	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret)
+	if (ret) {
+		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		return ret;
+	}
 
 	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
+		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	/*
-	 * css_put/get is provided for subsys to grab refcnt to css. In typical
-	 * case, subsystem has no reference after pre_destroy(). But, under
-	 * hierarchy management, some *temporal* refcnt can be hold.
-	 * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
-	 * is really busy, it should return -EBUSY at pre_destroy(). wake_up
-	 * is called when css_put() is called and refcnt goes down to 0.
-	 */
-	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
-
 	if (!cgroup_clear_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
-		schedule();
+		/*
+		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
+		 * prepare_to_wait(), we need to check this flag.
+		 */
+		if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
+			schedule();
 		finish_wait(&cgroup_rmdir_waitq, &wait);
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		if (signal_pending(current))
@@ -3342,7 +3363,7 @@ void __css_put(struct cgroup_subsys_stat
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
-		cgroup_wakeup_rmdir_waiters(cgrp);
+		cgroup_wakeup_rmdir_waiter(cgrp);
 	}
 	rcu_read_unlock();
 }
diff -puN mm/memcontrol.c~cgroup-avoid-permanent-sleep-at-rmdir-v7 mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-avoid-permanent-sleep-at-rmdir-v7
+++ a/mm/memcontrol.c
@@ -1207,6 +1207,12 @@ static int mem_cgroup_move_account(struc
 	ret = 0;
 out:
 	unlock_page_cgroup(pc);
+	/*
+	 * We charges against "to" which may not have any tasks. Then, "to"
+	 * can be under rmdir(). But in current implementation, caller of
+	 * this function is just force_empty() and it's garanteed that
+	 * "to" is never removed. So, we don't check rmdir status here.
+	 */
 	return ret;
 }
 
@@ -1428,6 +1434,7 @@ __mem_cgroup_commit_charge_swapin(struct
 		return;
 	if (!ptr)
 		return;
+	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
 	__mem_cgroup_commit_charge(ptr, pc, ctype);
@@ -1457,8 +1464,12 @@ __mem_cgroup_commit_charge_swapin(struct
 		}
 		rcu_read_unlock();
 	}
-	/* add this page(page_cgroup) to the LRU we want. */
-
+	/*
+	 * At swapin, we may charge account against cgroup which has no tasks.
+	 * So, rmdir()->pre_destroy() can be called while we do this charge.
+	 * In that case, we need to call pre_destroy() again. check it here.
+	 */
+	cgroup_release_and_wakeup_rmdir(&ptr->css);
 }
 
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
@@ -1664,7 +1675,7 @@ void mem_cgroup_end_migration(struct mem
 
 	if (!mem)
 		return;
-
+	cgroup_exclude_rmdir(&mem->css);
 	/* at migration success, oldpage->mapping is NULL. */
 	if (oldpage->mapping) {
 		target = oldpage;
@@ -1704,6 +1715,12 @@ void mem_cgroup_end_migration(struct mem
 	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 		mem_cgroup_uncharge_page(target);
+	/*
+	 * At migration, we may charge account against cgroup which has no tasks
+	 * So, rmdir()->pre_destroy() can be called while we do this charge.
+	 * In that case, we need to call pre_destroy() again. check it here.
+	 */
+	cgroup_release_and_wakeup_rmdir(&mem->css);
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
kcore-fix-proc-kcores-statst_size.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

