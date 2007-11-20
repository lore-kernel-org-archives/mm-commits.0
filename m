From: akpm@linux-foundation.org
Subject: + uml-kill-processes-instead-of-panicing-kernel.patch added to -mm tree
Date: Tue, 20 Nov 2007 13:25:23 -0800
Message-ID: <200711202125.lAKLPNsq024219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198AbXKTVZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 16:25:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: kill processes instead of panicing kernel
has been added to the -mm tree.  Its filename is
     uml-kill-processes-instead-of-panicing-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: kill processes instead of panicing kernel
From: Jeff Dike <jdike@addtoit.com>

UML was panicing in the case of failures of libc calls which shouldn't happen.
 This is an overreaction since a failure from libc doesn't normally mean that
kernel data structures are in an unknown state.  Instead, the current process
should just be killed if there is no way to recover.

The case that prompted this was a failure of PTRACE_SETREGS restoring the same
state that was read by PTRACE_GETREGS.  It appears that when a process tries
to load a bogus value into a segment register, it segfaults (as expected) and
the value is actually loaded and is seen by PTRACE_GETREGS (not expected).

This case is fixed by forcing a fatal SIGSEGV on the process so that it
immediately dies.  fatal_sigsegv was added for this purpose.  It was declared
as noreturn, so in order to pursuade gcc that it actually does not return, I
added a call to os_dump_core (and declared it noreturn) so that I get a core
file if somehow the process survives.

All other calls in arch/um/os-Linux/skas/process.c got the same treatment,
with failures causing the process to die instead of a kernel panic, with some
exceptions.

userspace_tramp exits with status 1 if anything goes wrong there.  That will
cause start_userspace to return an error.  copy_context_skas0 and
map_stub_pages also now return errors instead of panicing.  Callers of thes
functions were changed to check for errors and do something appropriate. 
Usually that's to return an error to their callers. 
check_skas3_ptrace_faultinfo just exits since that's too early to do anything
else.

save_registers, restore_registers, and init_registers now return status
instead of panicing on failure, with their callers doing something
appropriate.

There were also duplicate declarations of save_registers and restore_registers
in os.h - these are gone.

I noticed and fixed up some whitespace damage.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h     |    1 
 arch/um/include/os.h            |    8 
 arch/um/include/registers.h     |    6 
 arch/um/kernel/skas/mmu.c       |    5 
 arch/um/kernel/skas/process.c   |   20 +-
 arch/um/kernel/trap.c           |   12 +
 arch/um/os-Linux/registers.c    |   21 +-
 arch/um/os-Linux/skas/process.c |  265 +++++++++++++++++++-----------
 arch/um/os-Linux/start_up.c     |    4 
 arch/um/sys-x86_64/syscalls.c   |    8 
 10 files changed, 233 insertions(+), 117 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-kill-processes-instead-of-panicing-kernel arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/include/kern_util.h
@@ -62,6 +62,7 @@ extern int singlestepping(void *t);
 extern void segv_handler(int sig, struct uml_pt_regs *regs);
 extern void bus_handler(int sig, struct uml_pt_regs *regs);
 extern void winch(int sig, struct uml_pt_regs *regs);
+extern void fatal_sigsegv(void) __attribute__ ((noreturn));
 
 
 #endif
diff -puN arch/um/include/os.h~uml-kill-processes-instead-of-panicing-kernel arch/um/include/os.h
--- a/arch/um/include/os.h~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/include/os.h
@@ -238,7 +238,7 @@ extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
-extern void os_dump_core(void);
+extern void os_dump_core(void) __attribute__ ((noreturn));
 
 /* time.c */
 extern void idle_sleep(unsigned long long nsecs);
@@ -267,11 +267,9 @@ extern int protect(struct mm_id * mm_idp
 extern int is_skas_winch(int pid, int fd, void *data);
 extern int start_userspace(unsigned long stub_stack);
 extern int copy_context_skas0(unsigned long stack, int pid);
-extern void save_registers(int pid, struct uml_pt_regs *regs);
-extern void restore_registers(int pid, struct uml_pt_regs *regs);
 extern void userspace(struct uml_pt_regs *regs);
-extern void map_stub_pages(int fd, unsigned long code,
-			   unsigned long data, unsigned long stack);
+extern int map_stub_pages(int fd, unsigned long code, unsigned long data,
+			  unsigned long stack);
 extern void new_thread(void *stack, jmp_buf *buf, void (*handler)(void));
 extern void switch_threads(jmp_buf *me, jmp_buf *you);
 extern int start_idle_thread(void *stack, jmp_buf *switch_buf);
diff -puN arch/um/include/registers.h~uml-kill-processes-instead-of-panicing-kernel arch/um/include/registers.h
--- a/arch/um/include/registers.h~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/include/registers.h
@@ -13,9 +13,9 @@ extern int save_fp_registers(int pid, un
 extern int restore_fp_registers(int pid, unsigned long *fp_regs);
 extern int save_fpx_registers(int pid, unsigned long *fp_regs);
 extern int restore_fpx_registers(int pid, unsigned long *fp_regs);
-extern void save_registers(int pid, struct uml_pt_regs *regs);
-extern void restore_registers(int pid, struct uml_pt_regs *regs);
-extern void init_registers(int pid);
+extern int save_registers(int pid, struct uml_pt_regs *regs);
+extern int restore_registers(int pid, struct uml_pt_regs *regs);
+extern int init_registers(int pid);
 extern void get_safe_registers(unsigned long *regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
 
diff -puN arch/um/kernel/skas/mmu.c~uml-kill-processes-instead-of-panicing-kernel arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/kernel/skas/mmu.c
@@ -114,6 +114,11 @@ int init_new_context(struct task_struct 
 			to_mm->id.u.pid = copy_context_skas0(stack,
 							     from_mm->id.u.pid);
 		else to_mm->id.u.pid = start_userspace(stack);
+
+		if (to_mm->id.u.pid < 0) {
+			ret = to_mm->id.u.pid;
+			goto out_free;
+		}
 	}
 
 	ret = init_new_ldt(to_mm, from_mm);
diff -puN arch/um/kernel/skas/process.c~uml-kill-processes-instead-of-panicing-kernel arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/kernel/skas/process.c
@@ -6,19 +6,25 @@
 #include "linux/init.h"
 #include "linux/sched.h"
 #include "as-layout.h"
+#include "kern.h"
 #include "os.h"
 #include "skas.h"
 
 int new_mm(unsigned long stack)
 {
-	int fd;
+	int fd, err;
 
 	fd = os_open_file("/proc/mm", of_cloexec(of_write(OPENFLAGS())), 0);
 	if (fd < 0)
 		return fd;
 
-	if (skas_needs_stub)
-		map_stub_pages(fd, STUB_CODE, STUB_DATA, stack);
+	if (skas_needs_stub) {
+		err = map_stub_pages(fd, STUB_CODE, STUB_DATA, stack);
+		if (err) {
+			os_close_file(fd);
+			return err;
+		}
+	}
 
 	return fd;
 }
@@ -49,8 +55,14 @@ int __init start_uml(void)
 {
 	stack_protections((unsigned long) &cpu0_irqstack);
 	set_sigstack(cpu0_irqstack, THREAD_SIZE);
-	if (proc_mm)
+	if (proc_mm) {
 		userspace_pid[0] = start_userspace(0);
+		if (userspace_pid[0] < 0) {
+			printf("start_uml - start_userspace returned %d\n",
+			       userspace_pid[0]);
+			exit(1);
+		}
+	}
 
 	init_new_thread_signals();
 
diff -puN arch/um/kernel/trap.c~uml-kill-processes-instead-of-panicing-kernel arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/kernel/trap.c
@@ -129,6 +129,18 @@ static void bad_segv(struct faultinfo fi
 	force_sig_info(SIGSEGV, &si, current);
 }
 
+void fatal_sigsegv(void)
+{
+	force_sigsegv(SIGSEGV, current);
+	do_signal();
+	/*
+	 * This is to tell gcc that we're not returning - do_signal
+	 * can, in general, return, but in this case, it's not, since
+	 * we just got a fatal SIGSEGV queued.
+	 */
+	os_dump_core();
+}
+
 void segv_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
diff -puN arch/um/os-Linux/registers.c~uml-kill-processes-instead-of-panicing-kernel arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/os-Linux/registers.c
@@ -8,42 +8,41 @@
 #include <string.h>
 #include <sys/ptrace.h>
 #include "sysdep/ptrace.h"
-#include "user.h"
 
-void save_registers(int pid, struct uml_pt_regs *regs)
+int save_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
 	err = ptrace(PTRACE_GETREGS, pid, 0, regs->gp);
 	if (err < 0)
-		panic("save_registers - saving registers failed, errno = %d\n",
-		      errno);
+		return -errno;
+	return 0;
 }
 
-void restore_registers(int pid, struct uml_pt_regs *regs)
+int restore_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
 	err = ptrace(PTRACE_SETREGS, pid, 0, regs->gp);
 	if (err < 0)
-		panic("restore_registers - saving registers failed, "
-		      "errno = %d\n", errno);
+		return -errno;
+	return 0;
 }
 
 /* This is set once at boot time and not changed thereafter */
 
 static unsigned long exec_regs[MAX_REG_NR];
 
-void init_registers(int pid)
+int init_registers(int pid)
 {
 	int err;
 
 	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
-	if (err)
-		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
-		      errno);
+	if (err < 0)
+		return -errno;
 
 	arch_init_registers(pid);
+	return 0;
 }
 
 void get_safe_registers(unsigned long *regs)
diff -puN arch/um/os-Linux/skas/process.c~uml-kill-processes-instead-of-panicing-kernel arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/os-Linux/skas/process.c
@@ -38,17 +38,17 @@ int is_skas_winch(int pid, int fd, void 
 
 static int ptrace_dump_regs(int pid)
 {
-        unsigned long regs[MAX_REG_NR];
-        int i;
+	unsigned long regs[MAX_REG_NR];
+	int i;
 
-        if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
-                return -errno;
+	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+		return -errno;
 
 	printk(UM_KERN_ERR "Stub registers -\n");
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
 		printk(UM_KERN_ERR "\t%d - %lx\n", i, regs[i]);
 
-        return 0;
+	return 0;
 }
 
 /*
@@ -73,9 +73,11 @@ void wait_stub_done(int pid)
 			break;
 
 		err = ptrace(PTRACE_CONT, pid, 0, 0);
-		if (err)
-			panic("wait_stub_done : continue failed, errno = %d\n",
-			      errno);
+		if (err) {
+			printk(UM_KERN_ERR "wait_stub_done : continue failed, "
+			       "errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 	}
 
 	if (((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
@@ -86,8 +88,10 @@ bad_wait:
 	if (err)
 		printk(UM_KERN_ERR "Failed to get registers from stub, "
 		       "errno = %d\n", -err);
-	panic("wait_stub_done : failed to wait for SIGUSR1/SIGTRAP, pid = %d, "
-	      "n = %d, errno = %d, status = 0x%x\n", pid, n, errno, status);
+	printk(UM_KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
+	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
+	       status);
+	fatal_sigsegv();
 }
 
 extern unsigned long current_stub_stack(void);
@@ -98,9 +102,11 @@ void get_skas_faultinfo(int pid, struct 
 
 	if (ptrace_faultinfo) {
 		err = ptrace(PTRACE_FAULTINFO, pid, 0, fi);
-		if (err)
-			panic("get_skas_faultinfo - PTRACE_FAULTINFO failed, "
-			      "errno = %d\n", errno);
+		if (err) {
+			printk(UM_KERN_ERR "get_skas_faultinfo - "
+			       "PTRACE_FAULTINFO failed, errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 
 		/* Special handling for i386, which has different structs */
 		if (sizeof(struct ptrace_faultinfo) < sizeof(struct faultinfo))
@@ -110,9 +116,11 @@ void get_skas_faultinfo(int pid, struct 
 	}
 	else {
 		err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
-		if (err)
-			panic("Failed to continue stub, pid = %d, errno = %d\n",
-			      pid, errno);
+		if (err) {
+			printk(UM_KERN_ERR "Failed to continue stub, pid = %d, "
+			       "errno = %d\n", pid, errno);
+			fatal_sigsegv();
+		}
 		wait_stub_done(pid);
 
 		/*
@@ -145,25 +153,31 @@ static void handle_trap(int pid, struct 
 	{
 		err = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
-		if (err < 0)
-			panic("handle_trap - nullifying syscall failed, "
-			      "errno = %d\n", errno);
+		if (err < 0) {
+			printk(UM_KERN_ERR "handle_trap - nullifying syscall "
+			       "failed, errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 
 		err = ptrace(PTRACE_SYSCALL, pid, 0, 0);
-		if (err < 0)
-			panic("handle_trap - continuing to end of syscall "
-			      "failed, errno = %d\n", errno);
+		if (err < 0) {
+			printk(UM_KERN_ERR "handle_trap - continuing to end of "
+			       "syscall failed, errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
 		if ((err < 0) || !WIFSTOPPED(status) ||
-		   (WSTOPSIG(status) != SIGTRAP + 0x80)) {
-                        err = ptrace_dump_regs(pid);
-                        if (err)
-                                printk(UM_KERN_ERR "Failed to get registers "
+		    (WSTOPSIG(status) != SIGTRAP + 0x80)) {
+			err = ptrace_dump_regs(pid);
+			if (err)
+				printk(UM_KERN_ERR "Failed to get registers "
 				       "from process, errno = %d\n", -err);
-			panic("handle_trap - failed to wait at end of syscall, "
-			      "errno = %d, status = %d\n", errno, status);
-                }
+			printk(UM_KERN_ERR "handle_trap - failed to wait at "
+			       "end of syscall, errno = %d, status = %d\n",
+			       errno, status);
+			fatal_sigsegv();
+		}
 	}
 
 	handle_syscall(regs);
@@ -181,9 +195,11 @@ static int userspace_tramp(void *stack)
 	signal(SIGTERM, SIG_DFL);
 	signal(SIGWINCH, SIG_IGN);
 	err = set_interval();
-	if (err)
-		panic("userspace_tramp - setting timer failed, errno = %d\n",
-		      err);
+	if (err) {
+		printk(UM_KERN_ERR "userspace_tramp - setting timer failed, "
+		       "errno = %d\n", err);
+		exit(1);
+	}
 
 	if (!proc_mm) {
 		/*
@@ -226,9 +242,11 @@ static int userspace_tramp(void *stack)
 		sa.sa_flags = SA_ONSTACK | SA_NODEFER;
 		sa.sa_handler = (void *) v;
 		sa.sa_restorer = NULL;
-		if (sigaction(SIGSEGV, &sa, NULL) < 0)
-			panic("userspace_tramp - setting SIGSEGV handler "
-			      "failed - errno = %d\n", errno);
+		if (sigaction(SIGSEGV, &sa, NULL) < 0) {
+			printk(UM_KERN_ERR "userspace_tramp - setting SIGSEGV "
+			       "handler failed - errno = %d\n", errno);
+			exit(1);
+		}
 	}
 
 	kill(os_getpid(), SIGSTOP);
@@ -244,13 +262,18 @@ int start_userspace(unsigned long stub_s
 {
 	void *stack;
 	unsigned long sp;
-	int pid, status, n, flags;
+	int pid, status, n, flags, err;
 
 	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
 		     PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (stack == MAP_FAILED)
-		panic("start_userspace : mmap failed, errno = %d", errno);
+	if (stack == MAP_FAILED) {
+		err = -errno;
+		printk(UM_KERN_ERR "start_userspace : mmap failed, "
+		       "errno = %d", errno);
+		return err;
+	}
+
 	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 
 	flags = CLONE_FILES | SIGCHLD;
@@ -258,29 +281,50 @@ int start_userspace(unsigned long stub_s
 		flags |= CLONE_VM;
 
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
-	if (pid < 0)
-		panic("start_userspace : clone failed, errno = %d", errno);
+	if (pid < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "start_userspace : clone failed, "
+		       "errno = %d", errno);
+		return err;
+	}
 
 	do {
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if (n < 0)
-			panic("start_userspace : wait failed, errno = %d",
-			      errno);
+		if (n < 0) {
+			err = -errno;
+			printk(UM_KERN_ERR "start_userspace : wait failed, "
+			       "errno = %d", errno);
+			goto out_kill;
+		}
 	} while (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
 
-	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
-		panic("start_userspace : expected SIGSTOP, got status = %d",
-		      status);
+	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
+		err = -EINVAL;
+		printk(UM_KERN_ERR "start_userspace : expected SIGSTOP, got "
+		       "status = %d", status);
+		goto out_kill;
+	}
 
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
-		   (void *) PTRACE_O_TRACESYSGOOD) < 0)
-		panic("start_userspace : PTRACE_OLDSETOPTIONS failed, "
-		      "errno = %d\n", errno);
+		   (void *) PTRACE_O_TRACESYSGOOD) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
+		       "failed, errno = %d\n", errno);
+		goto out_kill;
+	}
 
-	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0)
-		panic("start_userspace : munmap failed, errno = %d\n", errno);
+	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "start_userspace : munmap failed, "
+		       "errno = %d\n", errno);
+		goto out_kill;
+	}
 
 	return pid;
+
+ out_kill:
+	os_kill_ptraced_process(pid, 1);
+	return err;
 }
 
 void userspace(struct uml_pt_regs *regs)
@@ -298,9 +342,16 @@ void userspace(struct uml_pt_regs *regs)
 	nsecs += os_nsecs();
 
 	while (1) {
+		/*
+		 * This can legitimately fail if the process loads a
+		 * bogus value into a segment register.  It will
+		 * segfault and PTRACE_GETREGS will read that value
+		 * out of the process.  However, PTRACE_SETREGS will
+		 * fail.  In this case, there is nothing to do but
+		 * just kill the process.
+		 */
 		if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
-			panic("userspace - PTRACE_SETREGS failed, "
-			      "errno = %d\n", errno);
+			fatal_sigsegv();
 
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
@@ -308,21 +359,25 @@ void userspace(struct uml_pt_regs *regs)
 		op = SELECT_PTRACE_OPERATION(local_using_sysemu,
 					     singlestepping(NULL));
 
-		err = ptrace(op, pid, 0, 0);
-		if (err)
-			panic("userspace - could not resume userspace process, "
-			      "pid=%d, ptrace operation = %d, errno = %d\n",
-			      pid, op, errno);
+		if (ptrace(op, pid, 0, 0)) {
+			printk(UM_KERN_ERR "userspace - ptrace continue "
+			       "failed, op = %d, errno = %d\n", op, errno);
+			fatal_sigsegv();
+		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
-		if (err < 0)
-			panic("userspace - waitpid failed, errno = %d\n",
-			      errno);
+		if (err < 0) {
+			printk(UM_KERN_ERR "userspace - wait failed, "
+			       "errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 
 		regs->is_user = 1;
-		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp))
-			panic("userspace - saving registers failed, "
-			      "errno = %d\n", errno);
+		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp)) {
+			printk(UM_KERN_ERR "userspace - PTRACE_GETREGS failed, "
+			       "errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
@@ -369,6 +424,7 @@ void userspace(struct uml_pt_regs *regs)
 			default:
 			        printk(UM_KERN_ERR "userspace - child stopped "
 				       "with signal %d\n", sig);
+				fatal_sigsegv();
 			}
 			pid = userspace_pid[0];
 			interrupt_end();
@@ -420,9 +476,12 @@ int copy_context_skas0(unsigned long new
 						     .it_interval = tv }) });
 
 	err = ptrace_setregs(pid, thread_regs);
-	if (err < 0)
-		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
-		      "pid = %d, errno = %d\n", pid, -err);
+	if (err < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
+		       "failed, pid = %d, errno = %d\n", pid, -err);
+		return err;
+	}
 
 	/* set a well known return code for detection of child write failure */
 	child_data->err = 12345678;
@@ -432,31 +491,47 @@ int copy_context_skas0(unsigned long new
 	 * parent's stack, and check, if bad result.
 	 */
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if (err)
-		panic("Failed to continue new process, pid = %d, "
-		      "errno = %d\n", pid, errno);
+	if (err) {
+		err = -errno;
+		printk(UM_KERN_ERR "Failed to continue new process, pid = %d, "
+		       "errno = %d\n", pid, errno);
+		return err;
+	}
+
 	wait_stub_done(pid);
 
 	pid = data->err;
-	if (pid < 0)
-		panic("copy_context_skas0 - stub-parent reports error %d\n",
-		      -pid);
+	if (pid < 0) {
+		printk(UM_KERN_ERR "copy_context_skas0 - stub-parent reports "
+		       "error %d\n", -pid);
+		return pid;
+	}
 
 	/*
 	 * Wait, until child has finished too: read child's result from
 	 * child's stack and check it.
 	 */
 	wait_stub_done(pid);
-	if (child_data->err != STUB_DATA)
-		panic("copy_context_skas0 - stub-child reports error %ld\n",
-		      child_data->err);
+	if (child_data->err != STUB_DATA) {
+		printk(UM_KERN_ERR "copy_context_skas0 - stub-child reports "
+		       "error %ld\n", child_data->err);
+		err = child_data->err;
+		goto out_kill;
+	}
 
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
-		   (void *)PTRACE_O_TRACESYSGOOD) < 0)
-		panic("copy_context_skas0 : PTRACE_OLDSETOPTIONS failed, "
-		      "errno = %d\n", errno);
+		   (void *)PTRACE_O_TRACESYSGOOD) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
+		       "failed, errno = %d\n", errno);
+		goto out_kill;
+	}
 
 	return pid;
+
+ out_kill:
+	os_kill_ptraced_process(pid, 1);
+	return err;
 }
 
 /*
@@ -464,8 +539,8 @@ int copy_context_skas0(unsigned long new
  * available. Opening /proc/mm creates a new mm_context, which lacks
  * the stub-pages. Thus, we map them using /proc/mm-fd
  */
-void map_stub_pages(int fd, unsigned long code,
-		    unsigned long data, unsigned long stack)
+int map_stub_pages(int fd, unsigned long code, unsigned long data,
+		   unsigned long stack)
 {
 	struct proc_mm_op mmop;
 	int n;
@@ -489,8 +564,9 @@ void map_stub_pages(int fd, unsigned lon
 		printk(UM_KERN_ERR "mmap args - addr = 0x%lx, fd = %d, "
 		       "offset = %llx\n", code, code_fd,
 		       (unsigned long long) code_offset);
-		panic("map_stub_pages : /proc/mm map for code failed, "
-		      "err = %d\n", n);
+		printk(UM_KERN_ERR "map_stub_pages : /proc/mm map for code "
+		       "failed, err = %d\n", n);
+		return -n;
 	}
 
 	if (stack) {
@@ -508,10 +584,15 @@ void map_stub_pages(int fd, unsigned lon
 				      .offset  = map_offset
 		} } });
 		CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
-		if (n != sizeof(mmop))
-			panic("map_stub_pages : /proc/mm map for data failed, "
-			      "err = %d\n", errno);
+		if (n != sizeof(mmop)) {
+			n = errno;
+			printk(UM_KERN_ERR "map_stub_pages : /proc/mm map for "
+			       "data failed, err = %d\n", n);
+			return -n;
+		}
 	}
+
+	return 0;
 }
 
 void new_thread(void *stack, jmp_buf *buf, void (*handler)(void))
@@ -572,7 +653,9 @@ int start_idle_thread(void *stack, jmp_b
 		kmalloc_ok = 0;
 		return 1;
 	default:
-		panic("Bad sigsetjmp return in start_idle_thread - %d\n", n);
+		printk(UM_KERN_ERR "Bad sigsetjmp return in "
+		       "start_idle_thread - %d\n", n);
+		fatal_sigsegv();
 	}
 	longjmp(*switch_buf, 1);
 }
@@ -615,9 +698,11 @@ void __switch_mm(struct mm_id *mm_idp)
 	if (proc_mm) {
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
-		if (err)
-			panic("__switch_mm - PTRACE_SWITCH_MM failed, "
-			      "errno = %d\n", errno);
+		if (err) {
+			printk(UM_KERN_ERR "__switch_mm - PTRACE_SWITCH_MM "
+			       "failed, errno = %d\n", errno);
+			fatal_sigsegv();
+		}
 	}
 	else userspace_pid[0] = mm_idp->u.pid;
 }
diff -puN arch/um/os-Linux/start_up.c~uml-kill-processes-instead-of-panicing-kernel arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/os-Linux/start_up.c
@@ -411,7 +411,9 @@ static inline void check_skas3_ptrace_fa
 			non_fatal("found\n");
 	}
 
-	init_registers(pid);
+	if (init_registers(pid))
+		fatal("Failed to initialize default registers");
+
 	stop_ptraced_child(pid, 1, 1);
 }
 
diff -puN arch/um/sys-x86_64/syscalls.c~uml-kill-processes-instead-of-panicing-kernel arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-kill-processes-instead-of-panicing-kernel
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -48,7 +48,9 @@ long arch_prctl(struct task_struct *task
 	switch (code) {
 	case ARCH_SET_FS:
 	case ARCH_SET_GS:
-		restore_registers(pid, &current->thread.regs.regs);
+		ret = restore_registers(pid, &current->thread.regs.regs);
+		if (ret)
+			return ret;
 		break;
 	case ARCH_GET_FS:
 	case ARCH_GET_GS:
@@ -70,10 +72,10 @@ long arch_prctl(struct task_struct *task
 	switch (code) {
 	case ARCH_SET_FS:
 		current->thread.arch.fs = (unsigned long) ptr;
-		save_registers(pid, &current->thread.regs.regs);
+		ret = save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_SET_GS:
-		save_registers(pid, &current->thread.regs.regs);
+		ret = save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_GET_FS:
 		ret = put_user(tmp, addr);
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
