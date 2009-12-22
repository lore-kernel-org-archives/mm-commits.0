From: akpm@linux-foundation.org
Subject: + tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch added to -mm tree
Date: Tue, 22 Dec 2009 13:58:27 -0800
Message-ID: <200912222158.nBMLwSfI026793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbZLVV7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 16:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ananth@in.ibm.com, andi@firstfloor.org, fche@redhat.com, hch@infradead.org, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     tracehooks: check PT_PTRACED before reporting the single-step
has been added to the -mm tree.  Its filename is
     tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch

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
Subject: tracehooks: check PT_PTRACED before reporting the single-step
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for utrace-ptrace.

tracehook_report_syscall_exit() and tracehook_signal_handler() assume that
only ptrace can set TIF_SINGLESTEP.  Currently this is true but we are
going to change this, the stepping logic will be moved into utrace layer.

Change this code to check PT_PTRACED, ptrace-utrace doesn't set it.

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

 include/linux/tracehook.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/tracehook.h~tracehooks-check-pt_ptraced-before-reporting-the-single-step include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehooks-check-pt_ptraced-before-reporting-the-single-step
+++ a/include/linux/tracehook.h
@@ -134,7 +134,7 @@ static inline __must_check int tracehook
  */
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
-	if (step) {
+	if (step && (task_ptrace(current) & PT_PTRACED)) {
 		siginfo_t info;
 		user_single_step_siginfo(current, regs, &info);
 		force_sig_info(SIGTRAP, &info, current);
@@ -386,7 +386,7 @@ static inline void tracehook_signal_hand
 					    const struct k_sigaction *ka,
 					    struct pt_regs *regs, int stepping)
 {
-	if (stepping)
+	if (stepping && (task_ptrace(current) & PT_PTRACED))
 		ptrace_notify(SIGTRAP);
 }
 
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

