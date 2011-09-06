From: akpm@linux-foundation.org
Subject: + cgroups-new-cancel_attach_task-subsystem-callback.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:10 -0700
Message-ID: <201109062242.p86MgB9f008283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab1IFWm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: new cancel_attach_task subsystem callback
has been added to the -mm tree.  Its filename is
     cgroups-new-cancel_attach_task-subsystem-callback.patch

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
Subject: cgroups: new cancel_attach_task subsystem callback
From: Frederic Weisbecker <fweisbec@gmail.com>

To cancel a process attachment on a subsystem, we only call the
cancel_attach() callback once on the leader but we have no way to cancel
the attachment individually for each member of the process group.

This is going to be needed for the max number of tasks susbystem
that is coming.

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
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    7 +++++++
 include/linux/cgroup.h            |    1 +
 kernel/cgroup.c                   |   23 +++++++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

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
@@ -472,6 +472,7 @@ struct cgroup_subsys {
 			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
+	void (*cancel_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
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
@@ -2080,7 +2083,7 @@ int cgroup_attach_proc(struct cgroup *cg
 				retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
-					cancel_failed_ss = true;
+					failed_task = tsk;
 					goto out_cancel_attach;
 				}
 			}
@@ -2145,8 +2148,11 @@ int cgroup_attach_proc(struct cgroup *cg
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
@@ -2178,8 +2184,17 @@ out_cancel_attach:
 	/* same deal as in cgroup_attach_task */
 	if (retval) {
 		for_each_subsys(root, ss) {
+			if (ss->cancel_attach_task && (ss != failed_ss || failed_task)) {
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
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-documentation-for-task-counter-subsystem.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

