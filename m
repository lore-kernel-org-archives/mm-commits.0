From: akpm@linux-foundation.org
Subject: + uml-fix-error-output-during-early-boot.patch added to -mm tree
Date: Fri, 09 Feb 2007 02:24:29 -0800
Message-ID: <200702091024.l19AOTJL010651@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946311AbXBIKYf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 05:24:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: fix error output during early boot
has been added to the -mm tree.  Its filename is
     uml-fix-error-output-during-early-boot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix error output during early boot
From: Jeff Dike <jdike@addtoit.com>

The startup code panics a lot if anything goes wrong early on.  This is wrong
for several reasons, like the kernel isn't running, so you can't really be
calling into it yet, but the harm comes from useful error messages being
trapped in the printk ring where no one will ever see them.

This patch changes these panics to perror and printf in wrappers which also
exit.  Normal, informational, prints are also wrapped so that fflush(stdout)
is called after each one.  This is so the output appears in the correct
sequence in the event of an error.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |  154 ++++++++++++++++++++--------------
 1 file changed, 92 insertions(+), 62 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-fix-error-output-during-early-boot arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-fix-error-output-during-early-boot
+++ a/arch/um/os-Linux/start_up.c
@@ -73,6 +73,34 @@ static int ptrace_child(void *arg)
 	_exit(ret);
 }
 
+static void fatal_perror(char *str)
+{
+	perror(str);
+	exit(1);
+}
+
+static void fatal(char *fmt, ...)
+{
+	va_list list;
+
+	va_start(list, fmt);
+	vprintf(fmt, list);
+	va_end(list);
+	fflush(stdout);
+
+	exit(1);
+}
+
+static void non_fatal(char *fmt, ...)
+{
+	va_list list;
+
+	va_start(list, fmt);
+	vprintf(fmt, list);
+	va_end(list);
+	fflush(stdout);
+}
+
 static int start_ptraced_child(void **stack_out)
 {
 	void *stack;
@@ -82,16 +110,16 @@ static int start_ptraced_child(void **st
 	stack = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if(stack == MAP_FAILED)
-		panic("check_ptrace : mmap failed, errno = %d", errno);
+		fatal_perror("check_ptrace : mmap failed");
 	sp = (unsigned long) stack + PAGE_SIZE - sizeof(void *);
 	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
 	if(pid < 0)
-		panic("start_ptraced_child : clone failed, errno = %d", errno);
+		fatal_perror("start_ptraced_child : clone failed");
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 	if(n < 0)
-		panic("check_ptrace : clone failed, errno = %d", errno);
+		fatal_perror("check_ptrace : clone failed");
 	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
-		panic("check_ptrace : expected SIGSTOP, got status = %d",
+		fatal("check_ptrace : expected SIGSTOP, got status = %d",
 		      status);
 
 	*stack_out = stack;
@@ -105,31 +133,30 @@ static int start_ptraced_child(void **st
  * must work anyway!
  */
 static int stop_ptraced_child(int pid, void *stack, int exitcode,
-			      int mustpanic)
+			      int mustexit)
 {
 	int status, n, ret = 0;
 
 	if(ptrace(PTRACE_CONT, pid, 0, 0) < 0)
-		panic("check_ptrace : ptrace failed, errno = %d", errno);
+		fatal_perror("stop_ptraced_child : ptrace failed");
 	CATCH_EINTR(n = waitpid(pid, &status, 0));
 	if(!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
 		int exit_with = WEXITSTATUS(status);
 		if (exit_with == 2)
-			printf("check_ptrace : child exited with status 2. "
-			       "Serious trouble happening! Try updating your "
-			       "host skas patch!\nDisabling SYSEMU support.");
-		printf("check_ptrace : child exited with exitcode %d, while "
-		      "expecting %d; status 0x%x", exit_with,
-		      exitcode, status);
-		if (mustpanic)
-			panic("\n");
-		else
-			printf("\n");
+			non_fatal("check_ptrace : child exited with status 2. "
+				  "Serious trouble happening! Try updating "
+				  "your host skas patch!\nDisabling SYSEMU "
+				  "support.");
+		non_fatal("check_ptrace : child exited with exitcode %d, while "
+			  "expecting %d; status 0x%x\n", exit_with,
+			  exitcode, status);
+		if (mustexit)
+			exit(1);
 		ret = -1;
 	}
 
 	if(munmap(stack, PAGE_SIZE) < 0)
-		panic("check_ptrace : munmap failed, errno = %d", errno);
+		fatal_perror("check_ptrace : munmap failed");
 	return ret;
 }
 
@@ -184,7 +211,7 @@ static void __init check_sysemu(void)
 	void *stack;
 	int pid, n, status, count=0;
 
-	printf("Checking syscall emulation patch for ptrace...");
+	non_fatal("Checking syscall emulation patch for ptrace...");
 	sysemu_supported = 0;
 	pid = start_ptraced_child(&stack);
 
@@ -193,31 +220,30 @@ static void __init check_sysemu(void)
 
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 	if (n < 0)
-		panic("check_sysemu : wait failed, errno = %d", errno);
+		fatal_perror("check_sysemu : wait failed");
 	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
-		panic("check_sysemu : expected SIGTRAP, "
-		      "got status = %d", status);
+		fatal("check_sysemu : expected SIGTRAP, got status = %d",
+		      status);
 
 	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
 		   os_getpid());
 	if(n < 0)
-		panic("check_sysemu : failed to modify system "
-		      "call return, errno = %d", errno);
+		fatal_perror("check_sysemu : failed to modify system call "
+			     "return");
 
 	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 1;
-	printf("OK\n");
+	non_fatal("OK\n");
 	set_using_sysemu(!force_sysemu_disabled);
 
-	printf("Checking advanced syscall emulation patch for ptrace...");
+	non_fatal("Checking advanced syscall emulation patch for ptrace...");
 	pid = start_ptraced_child(&stack);
 
-	if(ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
-		  (void *) PTRACE_O_TRACESYSGOOD) < 0)
-		panic("check_ptrace: PTRACE_OLDSETOPTIONS failed, errno = %d",
-		      errno);
+	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
+		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
+		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
 
 	while(1){
 		count++;
@@ -225,29 +251,30 @@ static void __init check_sysemu(void)
 			goto fail;
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 		if(n < 0)
-			panic("check_ptrace : wait failed, errno = %d", errno);
+			fatal_perror("check_ptrace : wait failed");
+
 		if(WIFSTOPPED(status) && (WSTOPSIG(status) == (SIGTRAP|0x80))){
 			if (!count)
-				panic("check_ptrace : SYSEMU_SINGLESTEP "
+				fatal("check_ptrace : SYSEMU_SINGLESTEP "
 				      "doesn't singlestep");
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
 				   os_getpid());
 			if(n < 0)
-				panic("check_sysemu : failed to modify system "
-				      "call return, errno = %d", errno);
+				fatal_perror("check_sysemu : failed to modify "
+					     "system call return");
 			break;
 		}
 		else if(WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
 		else
-			panic("check_ptrace : expected SIGTRAP or "
-			      "(SIGTRAP|0x80), got status = %d", status);
+			fatal("check_ptrace : expected SIGTRAP or "
+			      "(SIGTRAP | 0x80), got status = %d", status);
 	}
 	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
 		goto fail_stopped;
 
 	sysemu_supported = 2;
-	printf("OK\n");
+	non_fatal("OK\n");
 
 	if ( !force_sysemu_disabled )
 		set_using_sysemu(sysemu_supported);
@@ -256,7 +283,7 @@ static void __init check_sysemu(void)
 fail:
 	stop_ptraced_child(pid, stack, 1, 0);
 fail_stopped:
-	printf("missing\n");
+	non_fatal("missing\n");
 }
 
 static void __init check_ptrace(void)
@@ -264,22 +291,25 @@ static void __init check_ptrace(void)
 	void *stack;
 	int pid, syscall, n, status;
 
-	printf("Checking that ptrace can change system call numbers...");
+	non_fatal("Checking that ptrace can change system call numbers...");
 	pid = start_ptraced_child(&stack);
 
-	if(ptrace(PTRACE_OLDSETOPTIONS, pid, 0, (void *)PTRACE_O_TRACESYSGOOD) < 0)
-		panic("check_ptrace: PTRACE_OLDSETOPTIONS failed, errno = %d", errno);
+	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
+		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
+		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
 
 	while(1){
 		if(ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
-			panic("check_ptrace : ptrace failed, errno = %d",
-			      errno);
+			fatal_perror("check_ptrace : ptrace failed");
+
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 		if(n < 0)
-			panic("check_ptrace : wait failed, errno = %d", errno);
-		if(!WIFSTOPPED(status) || (WSTOPSIG(status) != (SIGTRAP|0x80)))
-			panic("check_ptrace : expected (SIGTRAP|0x80), "
-			      "got status = %d", status);
+			fatal_perror("check_ptrace : wait failed");
+
+		if(!WIFSTOPPED(status) ||
+		   (WSTOPSIG(status) != (SIGTRAP | 0x80)))
+			fatal("check_ptrace : expected (SIGTRAP|0x80), "
+			       "got status = %d", status);
 
 		syscall = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_NR_OFFSET,
 				 0);
@@ -287,13 +317,13 @@ static void __init check_ptrace(void)
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
 				   __NR_getppid);
 			if(n < 0)
-				panic("check_ptrace : failed to modify system "
-				      "call, errno = %d", errno);
+				fatal_perror("check_ptrace : failed to modify "
+					     "system call");
 			break;
 		}
 	}
 	stop_ptraced_child(pid, stack, 0, 1);
-	printf("OK\n");
+	non_fatal("OK\n");
 	check_sysemu();
 }
 
@@ -352,22 +382,22 @@ static inline void check_skas3_ptrace_fa
 	void *stack;
 	int pid, n;
 
-	printf("  - PTRACE_FAULTINFO...");
+	non_fatal("  - PTRACE_FAULTINFO...");
 	pid = start_ptraced_child(&stack);
 
 	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
 	if (n < 0) {
 		ptrace_faultinfo = 0;
 		if(errno == EIO)
-			printf("not found\n");
+			non_fatal("not found\n");
 		else
 			perror("not found");
 	}
 	else {
 		if (!ptrace_faultinfo)
-			printf("found but disabled on command line\n");
+			non_fatal("found but disabled on command line\n");
 		else
-			printf("found\n");
+			non_fatal("found\n");
 	}
 
 	init_registers(pid);
@@ -385,13 +415,13 @@ static inline void check_skas3_ptrace_ld
 		.ptr = ldtbuf,
 		.bytecount = sizeof(ldtbuf)};
 
-	printf("  - PTRACE_LDT...");
+	non_fatal("  - PTRACE_LDT...");
 	pid = start_ptraced_child(&stack);
 
 	n = ptrace(PTRACE_LDT, pid, 0, (unsigned long) &ldt_op);
 	if (n < 0) {
 		if(errno == EIO)
-			printf("not found\n");
+			non_fatal("not found\n");
 		else {
 			perror("not found");
 		}
@@ -399,9 +429,9 @@ static inline void check_skas3_ptrace_ld
 	}
 	else {
 		if(ptrace_ldt)
-			printf("found\n");
+			non_fatal("found\n");
 		else
-			printf("found, but use is disabled\n");
+			non_fatal("found, but use is disabled\n");
 	}
 
 	stop_ptraced_child(pid, stack, 1, 1);
@@ -416,22 +446,22 @@ static inline void check_skas3_ptrace_ld
 
 static inline void check_skas3_proc_mm(void)
 {
-	printf("  - /proc/mm...");
+	non_fatal("  - /proc/mm...");
 	if (access("/proc/mm", W_OK) < 0) {
 		proc_mm = 0;
-		printf("not found\n");
+		perror("not found");
 	}
 	else {
 		if (!proc_mm)
-			printf("found but disabled on command line\n");
+			non_fatal("found but disabled on command line\n");
 		else
-			printf("found\n");
+			non_fatal("found\n");
 	}
 }
 
 int can_do_skas(void)
 {
-	printf("Checking for the skas3 patch in the host:\n");
+	non_fatal("Checking for the skas3 patch in the host:\n");
 
 	check_skas3_proc_mm();
 	check_skas3_ptrace_faultinfo();
_

Patches currently in -mm which might be from jdike@addtoit.com are

optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch
uml-fix-error-output-during-early-boot.patch
uml-x86_64-thread-fixes.patch
uml-x86_64-ptrace-fixes.patch
uml-fix-prototypes.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
