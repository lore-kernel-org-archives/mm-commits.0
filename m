From: akpm@linux-foundation.org
Subject: + ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch added to -mm tree
Date: Tue, 22 Dec 2009 13:58:30 -0800
Message-ID: <200912222158.nBMLwVQa026796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZLVV7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 16:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ananth@in.ibm.com, andi@firstfloor.org, fche@redhat.com, hch@infradead.org, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     ptrace_signal: check PT_PTRACED before reporting a signal
has been added to the -mm tree.  Its filename is
     ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch

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
Subject: ptrace_signal: check PT_PTRACED before reporting a signal
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for utrace-ptrace.

Change ptrace_signal() to check PT_PTRACED instead of task_ptrace() != 0. 
Currently this is the same, PT_PTRACED must be always set if the task is
ptraced.

This change is needed to make sure ptrace_signal() does nothing if ptrace
is implemented on top of utrace, eventually this code will be removed
completely.

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

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~ptrace_signal-check-pt_ptraced-before-reporting-a-signal kernel/signal.c
--- a/kernel/signal.c~ptrace_signal-check-pt_ptraced-before-reporting-a-signal
+++ a/kernel/signal.c
@@ -1767,7 +1767,7 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!task_ptrace(current))
+	if (!(task_ptrace(current) & PT_PTRACED))
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);
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

