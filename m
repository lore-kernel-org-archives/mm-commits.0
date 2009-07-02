From: akpm@linux-foundation.org
Subject: + wait_consider_task-kill-parent-argument.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:31:51 -0700
Message-ID: <200907022131.n62LVp2o027219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbZGBVcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     wait_consider_task: kill "parent" argument
has been added to the -mm tree.  Its filename is
     wait_consider_task-kill-parent-argument.patch

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
Subject: wait_consider_task: kill "parent" argument
From: Oleg Nesterov <oleg@redhat.com>

Kill the unused "parent" argument in wait_consider_task(), it was never used.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~wait_consider_task-kill-parent-argument kernel/exit.c
--- a/kernel/exit.c~wait_consider_task-kill-parent-argument
+++ a/kernel/exit.c
@@ -1479,8 +1479,8 @@ static int wait_task_continued(struct wa
  * then ->notask_error is 0 if @p is an eligible child,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int wait_consider_task(struct wait_opts *wo, struct task_struct *parent,
-				int ptrace, struct task_struct *p)
+static int wait_consider_task(struct wait_opts *wo, int ptrace,
+				struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
 	if (!ret)
@@ -1544,7 +1544,7 @@ static int do_wait_thread(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(wo, tsk, 0, p);
+		int ret = wait_consider_task(wo, 0, p);
 		if (ret)
 			return ret;
 	}
@@ -1557,7 +1557,7 @@ static int ptrace_do_wait(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, tsk, 1, p);
+		int ret = wait_consider_task(wo, 1, p);
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

