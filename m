From: akpm@linux-foundation.org
Subject: + export-__ptrace_detach-and-do_notify_parent_cldstop.patch added to -mm tree
Date: Tue, 22 Dec 2009 13:58:33 -0800
Message-ID: <200912222158.nBMLwXj7026799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbZLVV7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 16:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ananth@in.ibm.com, andi@firstfloor.org, fche@redhat.com, hch@infradead.org, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     export __ptrace_detach() and do_notify_parent_cldstop()
has been added to the -mm tree.  Its filename is
     export-__ptrace_detach-and-do_notify_parent_cldstop.patch

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
Subject: export __ptrace_detach() and do_notify_parent_cldstop()
From: Oleg Nesterov <oleg@redhat.com>

Export __ptrace_detach() and do_notify_parent_cldstop() for ptrace-utrace.

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

 include/linux/ptrace.h |    1 +
 include/linux/sched.h  |    1 +
 kernel/ptrace.c        |    2 +-
 kernel/signal.c        |    2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~export-__ptrace_detach-and-do_notify_parent_cldstop include/linux/ptrace.h
--- a/include/linux/ptrace.h~export-__ptrace_detach-and-do_notify_parent_cldstop
+++ a/include/linux/ptrace.h
@@ -85,6 +85,7 @@ extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern int ptrace_attach(struct task_struct *tsk);
+extern bool __ptrace_detach(struct task_struct *tracer, struct task_struct *tracee);
 extern int ptrace_detach(struct task_struct *, unsigned int);
 extern void ptrace_disable(struct task_struct *);
 extern int ptrace_check_attach(struct task_struct *task, int kill);
diff -puN include/linux/sched.h~export-__ptrace_detach-and-do_notify_parent_cldstop include/linux/sched.h
--- a/include/linux/sched.h~export-__ptrace_detach-and-do_notify_parent_cldstop
+++ a/include/linux/sched.h
@@ -2034,6 +2034,7 @@ extern int kill_pgrp(struct pid *pid, in
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void do_notify_parent_cldstop(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff -puN kernel/ptrace.c~export-__ptrace_detach-and-do_notify_parent_cldstop kernel/ptrace.c
--- a/kernel/ptrace.c~export-__ptrace_detach-and-do_notify_parent_cldstop
+++ a/kernel/ptrace.c
@@ -271,7 +271,7 @@ static int ignoring_children(struct sigh
  * reap it now, in that case we must also wake up sub-threads sleeping in
  * do_wait().
  */
-static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 {
 	__ptrace_unlink(p);
 
diff -puN kernel/signal.c~export-__ptrace_detach-and-do_notify_parent_cldstop kernel/signal.c
--- a/kernel/signal.c~export-__ptrace_detach-and-do_notify_parent_cldstop
+++ a/kernel/signal.c
@@ -1497,7 +1497,7 @@ int do_notify_parent(struct task_struct 
 	return ret;
 }
 
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
+void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
 	unsigned long flags;
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

