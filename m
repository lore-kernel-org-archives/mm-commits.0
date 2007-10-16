From: akpm@linux-foundation.org
Subject: - uml-replace-clone-with-fork.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:55 -0700
Message-ID: <200710162037.l9GKbtcn015326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964941AbXJPVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: replace clone with fork
has been removed from the -mm tree.  Its filename was
     uml-replace-clone-with-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: replace clone with fork
From: Jeff Dike <jdike@addtoit.com>

Convert the boot-time host ptrace testing from clone to fork.  They were
essentially doing fork anyway.  This cleans up the code a bit, and makes
valgrind a bit happier about grinding it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   55 ++++++++++++----------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-replace-clone-with-fork arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-replace-clone-with-fork
+++ a/arch/um/os-Linux/start_up.c
@@ -25,7 +25,7 @@
 #include "registers.h"
 #include "skas_ptrace.h"
 
-static int ptrace_child(void *arg)
+static int ptrace_child(void)
 {
 	int ret;
 	int pid = os_getpid(), ppid = getppid();
@@ -90,31 +90,23 @@ static void non_fatal(char *fmt, ...)
 	fflush(stdout);
 }
 
-static int start_ptraced_child(void **stack_out)
+static int start_ptraced_child(void)
 {
-	void *stack;
-	unsigned long sp;
 	int pid, n, status;
 
-	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
-		     PROT_READ | PROT_WRITE | PROT_EXEC,
-		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (stack == MAP_FAILED)
-		fatal_perror("check_ptrace : mmap failed");
-
-	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
-	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
-	if (pid < 0)
-		fatal_perror("start_ptraced_child : clone failed");
+	pid = fork();
+	if (pid == 0)
+		ptrace_child();
+	else if (pid < 0)
+		fatal_perror("start_ptraced_child : fork failed");
 
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 	if (n < 0)
-		fatal_perror("check_ptrace : clone failed");
+		fatal_perror("check_ptrace : waitpid failed");
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
 		fatal("check_ptrace : expected SIGSTOP, got status = %d",
 		      status);
 
-	*stack_out = stack;
 	return pid;
 }
 
@@ -124,8 +116,7 @@ static int start_ptraced_child(void **st
  * So only for SYSEMU features we test mustpanic, while normal host features
  * must work anyway!
  */
-static int stop_ptraced_child(int pid, void *stack, int exitcode,
-			      int mustexit)
+static int stop_ptraced_child(int pid, int exitcode, int mustexit)
 {
 	int status, n, ret = 0;
 
@@ -145,8 +136,6 @@ static int stop_ptraced_child(int pid, v
 		ret = -1;
 	}
 
-	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0)
-		fatal_perror("check_ptrace : munmap failed");
 	return ret;
 }
 
@@ -198,13 +187,12 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 
 static void __init check_sysemu(void)
 {
-	void *stack;
 	unsigned long regs[MAX_REG_NR];
 	int pid, n, status, count=0;
 
 	non_fatal("Checking syscall emulation patch for ptrace...");
 	sysemu_supported = 0;
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if (ptrace(PTRACE_SYSEMU, pid, 0, 0) < 0)
 		goto fail;
@@ -231,7 +219,7 @@ static void __init check_sysemu(void)
 		goto fail;
 	}
 
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
+	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 1;
@@ -239,7 +227,7 @@ static void __init check_sysemu(void)
 	set_using_sysemu(!force_sysemu_disabled);
 
 	non_fatal("Checking advanced syscall emulation patch for ptrace...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
@@ -271,7 +259,7 @@ static void __init check_sysemu(void)
 			fatal("check_ptrace : expected SIGTRAP or "
 			      "(SIGTRAP | 0x80), got status = %d", status);
 	}
-	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
+	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 2;
@@ -282,18 +270,17 @@ static void __init check_sysemu(void)
 	return;
 
 fail:
-	stop_ptraced_child(pid, stack, 1, 0);
+	stop_ptraced_child(pid, 1, 0);
 fail_stopped:
 	non_fatal("missing\n");
 }
 
 static void __init check_ptrace(void)
 {
-	void *stack;
 	int pid, syscall, n, status;
 
 	non_fatal("Checking that ptrace can change system call numbers...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
@@ -323,7 +310,7 @@ static void __init check_ptrace(void)
 			break;
 		}
 	}
-	stop_ptraced_child(pid, stack, 0, 1);
+	stop_ptraced_child(pid, 0, 1);
 	non_fatal("OK\n");
 	check_sysemu();
 }
@@ -403,11 +390,10 @@ __uml_setup("noptraceldt", noptraceldt_c
 static inline void check_skas3_ptrace_faultinfo(void)
 {
 	struct ptrace_faultinfo fi;
-	void *stack;
 	int pid, n;
 
 	non_fatal("  - PTRACE_FAULTINFO...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
 	if (n < 0) {
@@ -425,13 +411,12 @@ static inline void check_skas3_ptrace_fa
 	}
 
 	init_registers(pid);
-	stop_ptraced_child(pid, stack, 1, 1);
+	stop_ptraced_child(pid, 1, 1);
 }
 
 static inline void check_skas3_ptrace_ldt(void)
 {
 #ifdef PTRACE_LDT
-	void *stack;
 	int pid, n;
 	unsigned char ldtbuf[40];
 	struct ptrace_ldt ldt_op = (struct ptrace_ldt) {
@@ -440,7 +425,7 @@ static inline void check_skas3_ptrace_ld
 		.bytecount = sizeof(ldtbuf)};
 
 	non_fatal("  - PTRACE_LDT...");
-	pid = start_ptraced_child(&stack);
+	pid = start_ptraced_child();
 
 	n = ptrace(PTRACE_LDT, pid, 0, (unsigned long) &ldt_op);
 	if (n < 0) {
@@ -458,7 +443,7 @@ static inline void check_skas3_ptrace_ld
 			non_fatal("found, but use is disabled\n");
 	}
 
-	stop_ptraced_child(pid, stack, 1, 1);
+	stop_ptraced_child(pid, 1, 1);
 #else
 	/* PTRACE_LDT might be disabled via cmdline option.
 	 * We want to override this, else we might use the stub
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
