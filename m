From: akpm@linux-foundation.org
Subject: + tracehooks-kill-some-pt_ptraced-checks.patch added to -mm tree
Date: Tue, 22 Dec 2009 13:58:20 -0800
Message-ID: <200912222158.nBMLwLmf026786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbZLVV7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 16:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ananth@in.ibm.com, andi@firstfloor.org, fche@redhat.com, hch@infradead.org, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     tracehooks: kill some PT_PTRACED checks
has been added to the -mm tree.  Its filename is
     tracehooks-kill-some-pt_ptraced-checks.patch

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
Subject: tracehooks: kill some PT_PTRACED checks
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for utrace-ptrace.

task_ptrace() != 0 if and only if PT_PTRACED bit is set, kill some
PT_PTRACED checks in tracehook.h to ensure the result is the same with or
without utrace which doesn't set PT_PTRACED.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Tested-by: Ananth Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/tracehook.h~tracehooks-kill-some-pt_ptraced-checks include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehooks-kill-some-pt_ptraced-checks
+++ a/include/linux/tracehook.h
@@ -156,7 +156,7 @@ static inline int tracehook_unsafe_exec(
 {
 	int unsafe = 0;
 	int ptrace = task_ptrace(task);
-	if (ptrace & PT_PTRACED) {
+	if (ptrace) {
 		if (ptrace & PT_PTRACE_CAP)
 			unsafe |= LSM_UNSAFE_PTRACE_CAP;
 		else
@@ -178,7 +178,7 @@ static inline int tracehook_unsafe_exec(
  */
 static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 {
-	if (task_ptrace(tsk) & PT_PTRACED)
+	if (task_ptrace(tsk))
 		return rcu_dereference(tsk->parent);
 	return NULL;
 }
@@ -492,7 +492,7 @@ static inline int tracehook_get_signal(s
  */
 static inline int tracehook_notify_jctl(int notify, int why)
 {
-	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
+	return notify ?: task_ptrace(current) ? why : 0;
 }
 
 /**
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch

