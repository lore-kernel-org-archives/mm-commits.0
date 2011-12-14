From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-new-cancel_attach_task-subsystem-callback.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:25 -0800
Message-ID: <20111214200626.124F91E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54510 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:27 -0500
Received: by mail-yx0-f202.google.com with SMTP id m5so135066yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: new cancel_attach_task() subsystem callback
has been removed from the -mm tree.  Its filename was
     cgroups-new-cancel_attach_task-subsystem-callback.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: new cancel_attach_task() subsystem callback

To cancel a process attachment on a subsystem, we only call the
cancel_attach() callback once on the leader but we have no way to cancel
the attachment individually for each member of the process group.

This is going to be needed for the max number of tasks susbystem that is
coming.

To prepare for this integration, call a new cancel_attach_task() callback
on each task of the group until we reach the member that failed to attach.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    7 +++++++
 include/linux/cgroup.h            |    2 ++
 kernel/cgroup.c                   |   24 ++++++++++++++++++++----
 3 files changed, 29 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-new-cancel_attach_task-subsystem-callback Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-new-cancel_attach_task-subsystem-callback
+++ a/Documentation/cgroups/cgroups.txt
@@ -623,6 +623,13 @@ function, so that the subsystem can impl
 This will be called only about subsystems whose can_attach() operation have
 succeeded.
 
+void cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+(cgroup_mutex held by caller)
+
+As cancel_attach, but for operations that must be cancelled once per
+task that wanted to be attached. This typically revert the effect of
+can_attach_task().
+
 void pre_attach(struct cgroup *cgrp);
 (cgroup_mutex held by caller)
 
diff -puN include/linux/cgroup.h~cgroups-new-cancel_attach_task-subsystem-callback include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-new-cancel_attach_task-subsystem-callback
+++ a/include/linux/cgroup.h
@@ -472,6 +472,8 @@ struct cgroup_subsys {
 			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
+	void (*cancel_attach_task)(struct cgroup *cgrp,
+				   struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 			    struct task_struct *tsk);
diff -puN kernel/cgroup.c~cgroups-new-cancel_attach_task-subsystem-callback kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-new-cancel_attach_task-subsystem-callback
+++ a/kernel/cgroup.c
@@ -1883,6 +1883,9 @@ out:
 				 * remaining subsystems.
 				 */
 				break;
+
+			if (ss->cancel_attach_task)
+				ss->cancel_attach_task(cgrp, tsk);
 			if (ss->cancel_attach)
 				ss->cancel_attach(ss, cgrp, tsk);
 		}
@@ -1992,7 +1995,7 @@ int cgroup_attach_proc(struct cgroup *cg
 {
 	int retval, i, group_size;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
-	bool cancel_failed_ss = false;
+	struct task_struct *failed_task = NULL;
 	/* guaranteed to be initialized later, but the compiler needs this */
 	struct cgroup *oldcgrp = NULL;
 	struct css_set *oldcg;
@@ -2081,7 +2084,7 @@ int cgroup_attach_proc(struct cgroup *cg
 							     oldcgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
-					cancel_failed_ss = true;
+					failed_task = tsk;
 					goto out_cancel_attach;
 				}
 			}
@@ -2146,8 +2149,11 @@ int cgroup_attach_proc(struct cgroup *cg
 				if (ss->attach_task)
 					ss->attach_task(cgrp, oldcgrp, tsk);
 			}
+		} else if (retval == -ESRCH) {
+			if (ss->cancel_attach_task)
+				ss->cancel_attach_task(cgrp, tsk);
 		} else {
-			BUG_ON(retval != -ESRCH);
+			BUG_ON(1);
 		}
 	}
 	/* nothing is sensitive to fork() after this point. */
@@ -2179,8 +2185,18 @@ out_cancel_attach:
 	/* same deal as in cgroup_attach_task */
 	if (retval) {
 		for_each_subsys(root, ss) {
+			if (ss->cancel_attach_task && (ss != failed_ss ||
+						       failed_task)) {
+				for (i = 0; i < group_size; i++) {
+					tsk = flex_array_get_ptr(group, i);
+					if (tsk == failed_task)
+						break;
+					ss->cancel_attach_task(cgrp, tsk);
+				}
+			}
+
 			if (ss == failed_ss) {
-				if (cancel_failed_ss && ss->cancel_attach)
+				if (failed_task && ss->cancel_attach)
 					ss->cancel_attach(ss, cgrp, leader);
 				break;
 			}
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

