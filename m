From: akpm@linux-foundation.org
Subject: - uml-definitively-kill-subprocesses-on-panic.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:14 -0700
Message-ID: <200710162039.l9GKdEg4015525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935896AbXJPVIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ytht.net@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: definitively kill subprocesses on panic
has been removed from the -mm tree.  Its filename was
     uml-definitively-kill-subprocesses-on-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: definitively kill subprocesses on panic
From: Lepton Wu <ytht.net@gmail.com>

In a stock 2.6.22.6 kernel, poweroff a user mode linux guest (2.6.22.6 running
in skas0 mode) will halt the host linux.  I think the reason is the kernel
thread abort because of a bug.  Then the sys_reboot in process of user mode
linux guest is not trapped by the user mode linux kernel and is executed by
host.  I think it is better to make sure all of our children process to quit
when user mode linux kernel abort.

[ jdike - the kernel process needs to ignore SIGTERM, plus the waitpid/kill
loop is needed to make sure that all of our children are dead before the
kernel exits ]

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |    2 -
 arch/um/os-Linux/util.c         |   38 ++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-definitively-kill-subprocesses-on-panic arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-definitively-kill-subprocesses-on-panic
+++ a/arch/um/os-Linux/skas/process.c
@@ -177,7 +177,7 @@ static int userspace_tramp(void *stack)
 
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
-	init_new_thread_signals();
+	signal(SIGTERM, SIG_DFL);
 	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
diff -puN arch/um/os-Linux/util.c~uml-definitively-kill-subprocesses-on-panic arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-definitively-kill-subprocesses-on-panic
+++ a/arch/um/os-Linux/util.c
@@ -105,6 +105,44 @@ int setjmp_wrapper(void (*proc)(void *, 
 
 void os_dump_core(void)
 {
+	int pid;
+
 	signal(SIGSEGV, SIG_DFL);
+
+	/*
+	 * We are about to SIGTERM this entire process group to ensure that
+	 * nothing is around to run after the kernel exits.  The
+	 * kernel wants to abort, not die through SIGTERM, so we
+	 * ignore it here.
+	 */
+
+	signal(SIGTERM, SIG_IGN);
+	kill(0, SIGTERM);
+	/*
+	 * Most of the other processes associated with this UML are
+	 * likely sTopped, so give them a SIGCONT so they see the
+	 * SIGTERM.
+	 */
+	kill(0, SIGCONT);
+
+	/*
+	 * Now, having sent signals to everyone but us, make sure they
+	 * die by ptrace.  Processes can survive what's been done to
+	 * them so far - the mechanism I understand is receiving a
+	 * SIGSEGV and segfaulting immediately upon return.  There is
+	 * always a SIGSEGV pending, and (I'm guessing) signals are
+	 * processed in numeric order so the SIGTERM (signal 15 vs
+	 * SIGSEGV being signal 11) is never handled.
+	 *
+	 * Run a waitpid loop until we get some kind of error.
+	 * Hopefully, it's ECHILD, but there's not a lot we can do if
+	 * it's something else.  Tell os_kill_ptraced_process not to
+	 * wait for the child to report its death because there's
+	 * nothing reasonable to do if that fails.
+	 */
+
+	while ((pid = waitpid(-1, NULL, WNOHANG)) > 0)
+		os_kill_ptraced_process(pid, 0);
+
 	abort();
 }
_

Patches currently in -mm which might be from ytht.net@gmail.com are

origin.patch
reiserfs-fix-kernel-panic-on-corrupted-directory.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
