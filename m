From: akpm@linux-foundation.org
Subject: + cgroup-avoid-permanent-sleep-at-rmdir-v7.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:14:03 -0700
Message-ID: <200907172314.n6HNE3j4015749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758045AbZGQXOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroup avoid permanent sleep at rmdir
has been added to the -mm tree.  Its filename is
     cgroup-avoid-permanent-sleep-at-rmdir-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -736,16 +736,28 @@ static void cgroup_d_remove_dir(struct d
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
@@ -1360,7 +1372,7 @@ int cgroup_attach_task(struct cgroup *cg
 	 * wake up rmdir() waiter. the rmdir should fail since the cgroup
 	 * is no longer empty.
 	 */
-	cgroup_wakeup_rmdir_waiters(cgrp);
+	cgroup_wakeup_rmdir_waiter(cgrp);
 	return 0;
 }
 
@@ -2745,33 +2757,42 @@ again:
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
@@ -3343,7 +3364,7 @@ void __css_put(struct cgroup_subsys_stat
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

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable-cleanup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch

