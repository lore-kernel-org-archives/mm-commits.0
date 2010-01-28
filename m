From: akpm@linux-foundation.org
Subject: + cgroups-fix-to-return-errno-in-a-failure-path.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:23:31 -0800
Message-ID: <201001280023.o0S0NVqs009285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab0A1AYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     cgroups: fix to return errno in a failure path
has been added to the -mm tree.  Its filename is
     cgroups-fix-to-return-errno-in-a-failure-path.patch

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
Subject: cgroups: fix to return errno in a failure path
From: Li Zefan <lizf@cn.fujitsu.com>

In cgroup_create(), if alloc_css_id() returns failure, the errno is not
propagated to userspace, so mkdir will fail silently.

To trigger this bug, we mount blkio (or memory subsystem), and create more
then 65534 cgroups.  (The number of cgroups is limited to 65535 if a
subsystem has use_id == 1)

 # mount -t cgroup -o blkio xxx /mnt
 # for ((i = 0; i < 65534; i++)); do mkdir /mnt/$i; done
 # mkdir /mnt/65534
 (should return ENOSPC)
 #

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c      |    7 ++++--
 kernel/cgroup.c.orig |   45 ++++++++---------------------------------
 2 files changed, 14 insertions(+), 38 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-to-return-errno-in-a-failure-path kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-to-return-errno-in-a-failure-path
+++ a/kernel/cgroup.c
@@ -2936,14 +2936,17 @@ static long cgroup_create(struct cgroup 
 
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
+
 		if (IS_ERR(css)) {
 			err = PTR_ERR(css);
 			goto err_destroy;
 		}
 		init_cgroup_css(css, ss, cgrp);
-		if (ss->use_id)
-			if (alloc_css_id(ss, parent, cgrp))
+		if (ss->use_id) {
+			err = alloc_css_id(ss, parent, cgrp);
+			if (err)
 				goto err_destroy;
+		}
 		/* At error, ->destroy() callback has to free assigned ID. */
 	}
 
diff -puN kernel/cgroup.c.orig~cgroups-fix-to-return-errno-in-a-failure-path kernel/cgroup.c.orig
--- a/kernel/cgroup.c.orig~cgroups-fix-to-return-errno-in-a-failure-path
+++ a/kernel/cgroup.c.orig
@@ -1539,7 +1539,7 @@ int cgroup_path(const struct cgroup *cgr
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	int retval = 0;
-	struct cgroup_subsys *ss, *failed_ss = NULL;
+	struct cgroup_subsys *ss;
 	struct cgroup *oldcgrp;
 	struct css_set *cg;
 	struct css_set *newcg;
@@ -1553,16 +1553,8 @@ int cgroup_attach_task(struct cgroup *cg
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
 			retval = ss->can_attach(ss, cgrp, tsk, false);
-			if (retval) {
-				/*
-				 * Remember on which subsystem the can_attach()
-				 * failed, so that we only call cancel_attach()
-				 * against the subsystems whose can_attach()
-				 * succeeded. (See below)
-				 */
-				failed_ss = ss;
-				goto out;
-			}
+			if (retval)
+				return retval;
 		}
 	}
 
@@ -1576,17 +1568,14 @@ int cgroup_attach_task(struct cgroup *cg
 	 */
 	newcg = find_css_set(cg, cgrp);
 	put_css_set(cg);
-	if (!newcg) {
-		retval = -ENOMEM;
-		goto out;
-	}
+	if (!newcg)
+		return -ENOMEM;
 
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
 		task_unlock(tsk);
 		put_css_set(newcg);
-		retval = -ESRCH;
-		goto out;
+		return -ESRCH;
 	}
 	rcu_assign_pointer(tsk->cgroups, newcg);
 	task_unlock(tsk);
@@ -1612,22 +1601,7 @@ int cgroup_attach_task(struct cgroup *cg
 	 * is no longer empty.
 	 */
 	cgroup_wakeup_rmdir_waiter(cgrp);
-out:
-	if (retval) {
-		for_each_subsys(root, ss) {
-			if (ss == failed_ss)
-				/*
-				 * This subsystem was the one that failed the
-				 * can_attach() check earlier, so we don't need
-				 * to call cancel_attach() against it or any
-				 * remaining subsystems.
-				 */
-				break;
-			if (ss->cancel_attach)
-				ss->cancel_attach(ss, cgrp, tsk, false);
-		}
-	}
-	return retval;
+	return 0;
 }
 
 /*
@@ -3728,13 +3702,12 @@ static void check_for_release(struct cgr
 	}
 }
 
-/* Caller must verify that the css is not for root cgroup */
-void __css_put(struct cgroup_subsys_state *css, int count)
+void __css_put(struct cgroup_subsys_state *css)
 {
 	struct cgroup *cgrp = css->cgroup;
 	int val;
 	rcu_read_lock();
-	val = atomic_sub_return(count, &css->refcnt);
+	val = atomic_dec_return(&css->refcnt);
 	if (val == 1) {
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cgroups-fix-to-return-errno-in-a-failure-path.patch
lib-stringc-simplify-strnstr.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch

