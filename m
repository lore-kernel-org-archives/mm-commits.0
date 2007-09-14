From: akpm@linux-foundation.org
Subject: + uml-remove-unused-file.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:57:15 -0700
Message-ID: <200709141057.l8EAvF42001415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXINK5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove unused file
has been added to the -mm tree.  Its filename is
     uml-remove-unused-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove unused file
From: Jeff Dike <jdike@addtoit.com>

arch/um/os-Linux/tt.c is no longer used.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/tt.c |  195 ----------------------------------------
 1 file changed, 195 deletions(-)

diff -puN arch/um/os-Linux/tt.c~uml-remove-unused-file /dev/null
--- a/arch/um/os-Linux/tt.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdio.h>
-#include <unistd.h>
-#include <signal.h>
-#include <sched.h>
-#include <errno.h>
-#include <stdarg.h>
-#include <stdlib.h>
-#include <sys/time.h>
-#include <sys/ptrace.h>
-#include <linux/ptrace.h>
-#include <sys/wait.h>
-#include <sys/mman.h>
-#include <asm/ptrace.h>
-#include <asm/unistd.h>
-#include "kern_util.h"
-#include "user.h"
-#include "signal_kern.h"
-#include "sysdep/ptrace.h"
-#include "sysdep/sigcontext.h"
-#include "irq_user.h"
-#include "ptrace_user.h"
-#include "init.h"
-#include "os.h"
-#include "uml-config.h"
-#include "choose-mode.h"
-#include "mode.h"
-#include "tempfile.h"
-#include "kern_constants.h"
-
-int protect_memory(unsigned long addr, unsigned long len, int r, int w, int x,
-		   int must_succeed)
-{
-	int err;
-
-	err = os_protect_memory((void *) addr, len, r, w, x);
-	if(err < 0){
-                if(must_succeed)
-			panic("protect failed, err = %d", -err);
-		else return(err);
-	}
-	return(0);
-}
-
-void kill_child_dead(int pid)
-{
-	kill(pid, SIGKILL);
-	kill(pid, SIGCONT);
-	do {
-		int n;
-		CATCH_EINTR(n = waitpid(pid, NULL, 0));
-		if (n > 0)
-			kill(pid, SIGCONT);
-		else
-			break;
-	} while(1);
-}
-
-void stop(void)
-{
-	while(1) sleep(1000000);
-}
-
-int wait_for_stop(int pid, int sig, int cont_type, void *relay)
-{
-	sigset_t *relay_signals = relay;
-	int status, ret;
-
-	while(1){
-		CATCH_EINTR(ret = waitpid(pid, &status, WUNTRACED));
-		if((ret < 0) ||
-		   !WIFSTOPPED(status) || (WSTOPSIG(status) != sig)){
-			if(ret < 0){
-				printk("wait failed, errno = %d\n",
-				       errno);
-			}
-			else if(WIFEXITED(status))
-				printk("process %d exited with status %d\n",
-				       pid, WEXITSTATUS(status));
-			else if(WIFSIGNALED(status))
-				printk("process %d exited with signal %d\n",
-				       pid, WTERMSIG(status));
-			else if((WSTOPSIG(status) == SIGVTALRM) ||
-				(WSTOPSIG(status) == SIGALRM) ||
-				(WSTOPSIG(status) == SIGIO) ||
-				(WSTOPSIG(status) == SIGPROF) ||
-				(WSTOPSIG(status) == SIGCHLD) ||
-				(WSTOPSIG(status) == SIGWINCH) ||
-				(WSTOPSIG(status) == SIGINT)){
-				ptrace(cont_type, pid, 0, WSTOPSIG(status));
-				continue;
-			}
-			else if((relay_signals != NULL) &&
-				sigismember(relay_signals, WSTOPSIG(status))){
-				ptrace(cont_type, pid, 0, WSTOPSIG(status));
-				continue;
-			}
-			else printk("process %d stopped with signal %d\n",
-				    pid, WSTOPSIG(status));
-			panic("wait_for_stop failed to wait for %d to stop "
-			      "with %d\n", pid, sig);
-		}
-		return(status);
-	}
-}
-
-void forward_ipi(int fd, int pid)
-{
-	int err;
-
-	err = os_set_owner(fd, pid);
-	if(err < 0)
-		printk("forward_ipi: set_owner failed, fd = %d, me = %d, "
-		       "target = %d, err = %d\n", fd, os_getpid(), pid, -err);
-}
-
-/*
- *-------------------------
- * only for tt mode (will be deleted in future...)
- *-------------------------
- */
-
-struct tramp {
-	int (*tramp)(void *);
-	void *tramp_data;
-	unsigned long temp_stack;
-	int flags;
-	int pid;
-};
-
-/* See above for why sigkill is here */
-
-int sigkill = SIGKILL;
-
-int outer_tramp(void *arg)
-{
-	struct tramp *t;
-	int sig = sigkill;
-
-	t = arg;
-	t->pid = clone(t->tramp, (void *) t->temp_stack + UM_KERN_PAGE_SIZE/2,
-		       t->flags, t->tramp_data);
-	if(t->pid > 0) wait_for_stop(t->pid, SIGSTOP, PTRACE_CONT, NULL);
-	kill(os_getpid(), sig);
-	_exit(0);
-}
-
-int start_fork_tramp(void *thread_arg, unsigned long temp_stack,
-		     int clone_flags, int (*tramp)(void *))
-{
-	struct tramp arg;
-	unsigned long sp;
-	int new_pid, status, err;
-
-	/* The trampoline will run on the temporary stack */
-	sp = stack_sp(temp_stack);
-
-	clone_flags |= CLONE_FILES | SIGCHLD;
-
-	arg.tramp = tramp;
-	arg.tramp_data = thread_arg;
-	arg.temp_stack = temp_stack;
-	arg.flags = clone_flags;
-
-	/* Start the process and wait for it to kill itself */
-	new_pid = clone(outer_tramp, (void *) sp, clone_flags, &arg);
-	if(new_pid < 0)
-		return(new_pid);
-
-	CATCH_EINTR(err = waitpid(new_pid, &status, 0));
-	if(err < 0)
-		panic("Waiting for outer trampoline failed - errno = %d",
-		      errno);
-
-	if(!WIFSIGNALED(status) || (WTERMSIG(status) != SIGKILL))
-		panic("outer trampoline didn't exit with SIGKILL, "
-		      "status = %d", status);
-
-	return(arg.pid);
-}
-
-void forward_pending_sigio(int target)
-{
-	sigset_t sigs;
-
-	if(sigpending(&sigs))
-		panic("forward_pending_sigio : sigpending failed");
-	if(sigismember(&sigs, SIGIO))
-		kill(target, SIGIO);
-}
-
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-use-correct-type-in-blkgetsize-ioctl.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unneeded-void-cast.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
bitops-introduce-lock-ops.patch
