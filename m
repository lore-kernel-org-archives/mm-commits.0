From: akpm@linux-foundation.org
Subject: + uml-tidy-kern_utilh.patch added to -mm tree
Date: Wed, 07 Nov 2007 11:10:15 -0800
Message-ID: <200711071910.lA7JAHKr023529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXKGTKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 14:10:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: tidy kern_util.h
has been added to the -mm tree.  Its filename is
     uml-tidy-kern_utilh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: tidy kern_util.h
From: Jeff Dike <jdike@addtoit.com>

Tidy kern_util.h.  It turns out that most of the function declarations
aren't used, so they can go away.  os.h no longer includes
kern_util.h, so files which got it through os.h now need to include it
directly.  A number of other files never needed it, so these includes
are deleted.

The structure which was used to pass signal handlers from the kernel
side to the userspace side is gone.  Instead, the handlers are
declared here, and used directly from libc code.  This allows
arch/um/os-Linux/trap.c to be deleted, with its remnants being moved
to arch/um/os-Linux/skas/trap.c.

arch/um/os-Linux/tty.c had its inclusions changed, and it needed some
style attention, so it got tidied.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c                 |    1 
 arch/um/drivers/ssl.c                  |    1 
 arch/um/drivers/stdio_console.c        |    1 
 arch/um/drivers/ubd_kern.c             |    1 
 arch/um/drivers/ubd_user.c             |    1 
 arch/um/include/kern_util.h            |  118 ++++++-----------------
 arch/um/include/os.h                   |    4 
 arch/um/kernel/initrd.c                |    1 
 arch/um/kernel/reboot.c                |    1 
 arch/um/kernel/smp.c                   |    1 
 arch/um/kernel/trap.c                  |   15 --
 arch/um/kernel/um_arch.c               |    6 -
 arch/um/os-Linux/Makefile              |    4 
 arch/um/os-Linux/aio.c                 |    1 
 arch/um/os-Linux/drivers/tuntap_user.c |    1 
 arch/um/os-Linux/file.c                |    1 
 arch/um/os-Linux/irq.c                 |    1 
 arch/um/os-Linux/mem.c                 |    1 
 arch/um/os-Linux/signal.c              |    1 
 arch/um/os-Linux/skas/process.c        |    1 
 arch/um/os-Linux/skas/trap.c           |   18 ++-
 arch/um/os-Linux/trap.c                |   23 ----
 arch/um/os-Linux/tty.c                 |   55 +++++-----
 arch/um/os-Linux/tty_log.c             |    1 
 arch/um/sys-i386/bugs.c                |    1 
 25 files changed, 88 insertions(+), 172 deletions(-)

diff -puN arch/um/drivers/line.c~uml-tidy-kern_utilh arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-tidy-kern_utilh
+++ a/arch/um/drivers/line.c
@@ -8,6 +8,7 @@
 #include "chan_kern.h"
 #include "irq_kern.h"
 #include "irq_user.h"
+#include "kern_util.h"
 #include "os.h"
 
 #define LINE_BUFSIZE 4096
diff -puN arch/um/drivers/ssl.c~uml-tidy-kern_utilh arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-tidy-kern_utilh
+++ a/arch/um/drivers/ssl.c
@@ -15,7 +15,6 @@
 #include "line.h"
 #include "ssl.h"
 #include "chan_kern.h"
-#include "kern_util.h"
 #include "kern.h"
 #include "init.h"
 #include "irq_user.h"
diff -puN arch/um/drivers/stdio_console.c~uml-tidy-kern_utilh arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-tidy-kern_utilh
+++ a/arch/um/drivers/stdio_console.c
@@ -22,7 +22,6 @@
 #include "stdio_console.h"
 #include "line.h"
 #include "chan_kern.h"
-#include "kern_util.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
 #include "init.h"
diff -puN arch/um/drivers/ubd_kern.c~uml-tidy-kern_utilh arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-tidy-kern_utilh
+++ a/arch/um/drivers/ubd_kern.c
@@ -49,6 +49,7 @@
 #include "irq_user.h"
 #include "irq_kern.h"
 #include "ubd_user.h"
+#include "kern_util.h"
 #include "os.h"
 #include "mem.h"
 #include "mem_kern.h"
diff -puN arch/um/drivers/ubd_user.c~uml-tidy-kern_utilh arch/um/drivers/ubd_user.c
--- a/arch/um/drivers/ubd_user.c~uml-tidy-kern_utilh
+++ a/arch/um/drivers/ubd_user.c
@@ -16,7 +16,6 @@
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "asm/types.h"
-#include "kern_util.h"
 #include "user.h"
 #include "ubd_user.h"
 #include "os.h"
diff -puN arch/um/include/kern_util.h~uml-tidy-kern_utilh arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-tidy-kern_utilh
+++ a/arch/um/include/kern_util.h
@@ -9,107 +9,59 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
 
-typedef void (*kern_hndl)(int, struct uml_pt_regs *);
-
-struct kern_handlers {
-	kern_hndl relay_signal;
-	kern_hndl winch;
-	kern_hndl bus_handler;
-	kern_hndl page_fault;
-	kern_hndl sigio_handler;
-	kern_hndl timer_handler;
-};
-
-extern const struct kern_handlers handlinfo_kern;
-
 extern int ncpus;
-extern char *gdb_init;
 extern int kmalloc_ok;
-extern int jail;
 extern int nsyscalls;
 
-#define UML_ROUND_DOWN(addr) ((void *)(((unsigned long) addr) & PAGE_MASK))
 #define UML_ROUND_UP(addr) \
-	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
+	((((unsigned long) addr) + PAGE_SIZE - 1) & PAGE_MASK)
 
-extern int kernel_fork(unsigned long flags, int (*fn)(void *), void * arg);
-extern int kernel_thread_proc(void *data);
-extern void syscall_segv(int sig);
-extern int current_pid(void);
 extern unsigned long alloc_stack(int order, int atomic);
+extern void free_stack(unsigned long stack, int order);
+
 extern int do_signal(void);
-extern int is_stack_fault(unsigned long sp);
+extern void copy_sc(struct uml_pt_regs *regs, void *from);
+extern void interrupt_end(void);
+extern void relay_signal(int sig, struct uml_pt_regs *regs);
+
 extern unsigned long segv(struct faultinfo fi, unsigned long ip,
 			  int is_user, struct uml_pt_regs *regs);
 extern int handle_page_fault(unsigned long address, unsigned long ip,
 			     int is_write, int is_user, int *code_out);
-extern void syscall_ready(void);
-extern void set_tracing(void *t, int tracing);
-extern int is_tracing(void *task);
-extern int segv_syscall(void);
-extern void kern_finish_exec(void *task, int new_pid, unsigned long stack);
-extern unsigned long page_mask(void);
-extern int need_finish_fork(void);
-extern void free_stack(unsigned long stack, int order);
-extern void add_input_request(int op, void (*proc)(int), void *arg);
-extern char *current_cmd(void);
-extern void timer_handler(int sig, struct uml_pt_regs *regs);
-extern int set_signals(int enable);
-extern int pid_to_processor_id(int pid);
-extern void deliver_signals(void *t);
-extern int next_trap_index(int max);
-extern void default_idle(void);
-extern void finish_fork(void);
-extern void paging_init(void);
-extern void init_flush_vm(void);
-extern void *syscall_sp(void *t);
-extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
+
 extern unsigned int do_IRQ(int irq, struct uml_pt_regs *regs);
-extern void interrupt_end(void);
-extern void initial_thread_cb(void (*proc)(void *), void *arg);
-extern int debugger_signal(int status, int pid);
-extern void debugger_parent_signal(int status, int pid);
-extern void child_signal(int pid, int status);
-extern int init_ptrace_proxy(int idle_pid, int startup, int stop);
-extern int init_parent_proxy(int pid);
-extern int singlestepping(void *t);
-extern void check_stack_overflow(void *ptr);
-extern void relay_signal(int sig, struct uml_pt_regs *regs);
-extern int user_context(unsigned long sp);
-extern void timer_irq(struct uml_pt_regs *regs);
-extern void do_uml_exitcalls(void);
-extern int attach_debugger(int idle_pid, int pid, int stop);
-extern int config_gdb(char *str);
-extern int remove_gdb(void);
-extern char *uml_strdup(const char *string);
-extern void unprotect_kernel_mem(void);
-extern void protect_kernel_mem(void);
-extern void uml_cleanup(void);
-extern void lock_signalled_task(void *t);
-extern void IPI_handler(int cpu);
-extern int jail_setup(char *line, int *add);
-extern void *get_init_task(void);
-extern int clear_user_proc(void *buf, int size);
-extern int copy_to_user_proc(void *to, void *from, int size);
-extern int copy_from_user_proc(void *to, void *from, int size);
-extern int strlen_user_proc(char *str);
-extern long execute_syscall(void *r);
 extern int smp_sigio_handler(void);
-extern void *get_current(void);
-extern struct task_struct *get_task(int pid, int require);
-extern void machine_halt(void);
+extern void initial_thread_cb(void (*proc)(void *), void *arg);
 extern int is_syscall(unsigned long addr);
+extern void timer_handler(int sig, struct uml_pt_regs *regs);
 
-extern void free_irq(unsigned int, void *);
-extern int cpu(void);
+extern void timer_handler(int sig, struct uml_pt_regs *regs);
 
-extern void time_init_kern(void);
+extern int start_uml(void);
+extern void paging_init(void);
 
-/* Are we disallowed to sleep? Used to choose between GFP_KERNEL and GFP_ATOMIC. */
+extern void uml_cleanup(void);
+extern void do_uml_exitcalls(void);
+
+/*
+ * Are we disallowed to sleep? Used to choose between GFP_KERNEL and
+ * GFP_ATOMIC.
+ */
 extern int __cant_sleep(void);
-extern void sigio_handler(int sig, struct uml_pt_regs *regs);
-extern void copy_sc(struct uml_pt_regs *regs, void *from);
+extern void *get_current(void);
+extern int copy_from_user_proc(void *to, void *from, int size);
+extern int cpu(void);
+extern char *uml_strdup(const char *string);
+
 extern unsigned long to_irq_stack(unsigned long *mask_out);
-unsigned long from_irq_stack(int nested);
-extern int start_uml(void);
+extern unsigned long from_irq_stack(int nested);
+
+extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
+extern int singlestepping(void *t);
+
+extern void segv_handler(int sig, struct uml_pt_regs *regs);
+extern void bus_handler(int sig, struct uml_pt_regs *regs);
+extern void winch(int sig, struct uml_pt_regs *regs);
+
+
 #endif
diff -puN arch/um/include/os.h~uml-tidy-kern_utilh arch/um/include/os.h
--- a/arch/um/include/os.h~uml-tidy-kern_utilh
+++ a/arch/um/include/os.h
@@ -8,7 +8,6 @@
 
 #include <stdarg.h>
 #include "irq_user.h"
-#include "kern_util.h"
 #include "longjmp.h"
 #include "mm_id.h"
 #include "sysdep/tls.h"
@@ -237,9 +236,6 @@ extern void unblock_signals(void);
 extern int get_signals(void);
 extern int set_signals(int enable);
 
-/* trap.c */
-extern void os_fill_handlinfo(struct kern_handlers h);
-
 /* util.c */
 extern void stack_protections(unsigned long address);
 extern int raw(int fd);
diff -puN arch/um/kernel/initrd.c~uml-tidy-kern_utilh arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-tidy-kern_utilh
+++ a/arch/um/kernel/initrd.c
@@ -7,7 +7,6 @@
 #include "linux/bootmem.h"
 #include "linux/initrd.h"
 #include "asm/types.h"
-#include "kern_util.h"
 #include "initrd.h"
 #include "init.h"
 #include "os.h"
diff -puN arch/um/kernel/reboot.c~uml-tidy-kern_utilh arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-tidy-kern_utilh
+++ a/arch/um/kernel/reboot.c
@@ -4,6 +4,7 @@
  */
 
 #include "linux/sched.h"
+#include "kern_util.h"
 #include "os.h"
 #include "skas.h"
 
diff -puN arch/um/kernel/smp.c~uml-tidy-kern_utilh arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-tidy-kern_utilh
+++ a/arch/um/kernel/smp.c
@@ -21,7 +21,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 #include "asm/smp.h"
 #include "asm/processor.h"
 #include "asm/spinlock.h"
-#include "kern_util.h"
 #include "kern.h"
 #include "irq_user.h"
 #include "os.h"
diff -puN arch/um/kernel/trap.c~uml-tidy-kern_utilh arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-tidy-kern_utilh
+++ a/arch/um/kernel/trap.c
@@ -128,7 +128,7 @@ static void bad_segv(struct faultinfo fi
 	force_sig_info(SIGSEGV, &si, current);
 }
 
-static void segv_handler(int sig, struct uml_pt_regs *regs)
+void segv_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
@@ -229,27 +229,18 @@ void relay_signal(int sig, struct uml_pt
 	force_sig(sig, current);
 }
 
-static void bus_handler(int sig, struct uml_pt_regs *regs)
+void bus_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current->thread.fault_catcher != NULL)
 		UML_LONGJMP(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
 
-static void winch(int sig, struct uml_pt_regs *regs)
+void winch(int sig, struct uml_pt_regs *regs)
 {
 	do_IRQ(WINCH_IRQ, regs);
 }
 
-const struct kern_handlers handlinfo_kern = {
-	.relay_signal = relay_signal,
-	.winch = winch,
-	.bus_handler = bus_handler,
-	.page_fault = segv_handler,
-	.sigio_handler = sigio_handler,
-	.timer_handler = timer_handler
-};
-
 void trap_init(void)
 {
 }
diff -puN arch/um/kernel/um_arch.c~uml-tidy-kern_utilh arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-tidy-kern_utilh
+++ a/arch/um/kernel/um_arch.c
@@ -16,6 +16,7 @@
 #include "as-layout.h"
 #include "init.h"
 #include "kern.h"
+#include "kern_util.h"
 #include "mem_user.h"
 #include "os.h"
 #include "skas.h"
@@ -280,11 +281,6 @@ int __init linux_main(int argc, char **a
 
 	host_task_size = set_task_sizes_skas(&task_size);
 
-	/*
-	 * Setting up handlers to 'sig_info' struct
-	 */
-	os_fill_handlinfo(handlinfo_kern);
-
 	brk_start = (unsigned long) sbrk(0);
 
 	/*
diff -puN arch/um/os-Linux/Makefile~uml-tidy-kern_utilh arch/um/os-Linux/Makefile
--- a/arch/um/os-Linux/Makefile~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
-	registers.o sigio.o signal.o start_up.o time.o trap.o tty.o uaccess.o \
+	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
 	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
 obj-$(CONFIG_TTY_LOG) += tty_log.o
@@ -12,7 +12,7 @@ user-objs-$(CONFIG_TTY_LOG) += tty_log.o
 
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
-	trap.o tty.o tls.o uaccess.o umid.o util.o
+	tty.o tls.o uaccess.o umid.o util.o
 
 CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
 
diff -puN arch/um/os-Linux/aio.c~uml-tidy-kern_utilh arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/aio.c
@@ -12,6 +12,7 @@
 #include "aio.h"
 #include "init.h"
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
 #include "user.h"
 
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-tidy-kern_utilh arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -14,6 +14,7 @@
 #include <sys/wait.h>
 #include <sys/uio.h>
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
 #include "tuntap.h"
 #include "user.h"
diff -puN arch/um/os-Linux/file.c~uml-tidy-kern_utilh arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/file.c
@@ -17,7 +17,6 @@
 #include <sys/uio.h>
 #include "os.h"
 #include "user.h"
-#include "kern_util.h"
 
 static void copy_stat(struct uml_stat *dst, const struct stat64 *src)
 {
diff -puN arch/um/os-Linux/irq.c~uml-tidy-kern_utilh arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/irq.c
@@ -11,7 +11,6 @@
 #include <sys/poll.h>
 #include <sys/types.h>
 #include <sys/time.h>
-#include "kern_util.h"
 #include "user.h"
 #include "process.h"
 #include "sigio.h"
diff -puN arch/um/os-Linux/mem.c~uml-tidy-kern_utilh arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/mem.c
@@ -9,7 +9,6 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/statfs.h>
-#include "kern_util.h"
 #include "user.h"
 #include "mem_user.h"
 #include "init.h"
diff -puN arch/um/os-Linux/signal.c~uml-tidy-kern_utilh arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/signal.c
@@ -9,6 +9,7 @@
 #include <errno.h>
 #include <signal.h>
 #include <strings.h>
+#include "kern_util.h"
 #include "os.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
diff -puN arch/um/os-Linux/skas/process.c~uml-tidy-kern_utilh arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/skas/process.c
@@ -15,6 +15,7 @@
 #include "as-layout.h"
 #include "chan_user.h"
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "mem.h"
 #include "os.h"
 #include "process.h"
diff -puN arch/um/os-Linux/skas/trap.c~uml-tidy-kern_utilh arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/skas/trap.c
@@ -3,22 +3,26 @@
  * Licensed under the GPL
  */
 
-#if 0
-#include "kern_util.h"
-#include "skas.h"
-#include "ptrace_user.h"
-#include "sysdep/ptrace_user.h"
-#endif
-
 #include <errno.h>
 #include <signal.h>
 #include "sysdep/ptrace.h"
 #include "kern_constants.h"
 #include "as-layout.h"
+#include "kern_util.h"
 #include "os.h"
 #include "sigcontext.h"
 #include "task.h"
 
+void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
+	[SIGTRAP]	= relay_signal,
+	[SIGFPE]	= relay_signal,
+	[SIGILL]	= relay_signal,
+	[SIGWINCH]	= winch,
+	[SIGBUS]	= bus_handler,
+	[SIGSEGV]	= segv_handler,
+	[SIGIO]		= sigio_handler,
+	[SIGVTALRM]	= timer_handler };
+
 static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
 
 void sig_handler_common_skas(int sig, void *sc_ptr)
diff -puN arch/um/os-Linux/trap.c~uml-tidy-kern_utilh /dev/null
--- a/arch/um/os-Linux/trap.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <signal.h>
-#include "os.h"
-#include "sysdep/ptrace.h"
-
-/* Initialized from linux_main() */
-void (*sig_info[NSIG])(int, struct uml_pt_regs *);
-
-void os_fill_handlinfo(struct kern_handlers h)
-{
-	sig_info[SIGTRAP] = h.relay_signal;
-	sig_info[SIGFPE] = h.relay_signal;
-	sig_info[SIGILL] = h.relay_signal;
-	sig_info[SIGWINCH] = h.winch;
-	sig_info[SIGBUS] = h.bus_handler;
-	sig_info[SIGSEGV] = h.page_fault;
-	sig_info[SIGIO] = h.sigio_handler;
-	sig_info[SIGVTALRM] = h.timer_handler;
-}
diff -puN arch/um/os-Linux/tty.c~uml-tidy-kern_utilh arch/um/os-Linux/tty.c
--- a/arch/um/os-Linux/tty.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/tty.c
@@ -1,13 +1,16 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
+#include <fcntl.h>
+#include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
 #include "user.h"
-#include "kern_util.h"
 
 struct grantpt_info {
 	int fd;
@@ -26,36 +29,34 @@ static void grantpt_cb(void *arg)
 int get_pty(void)
 {
 	struct grantpt_info info;
-	int fd;
+	int fd, err;
 
-	fd = os_open_file("/dev/ptmx", of_rdwr(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("get_pty : Couldn't open /dev/ptmx - err = %d\n", -fd);
-		return(fd);
+	fd = open("/dev/ptmx", O_RDWR);
+	if (fd < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
+		       "err = %d\n", errno);
+		return err;
 	}
 
 	info.fd = fd;
 	initial_thread_cb(grantpt_cb, &info);
 
-	if(info.res < 0){
-		printk("get_pty : Couldn't grant pty - errno = %d\n", 
-		       -info.err);
-		return(-1);
+	if (info.res < 0) {
+		err = -info.err;
+		printk(UM_KERN_ERR "get_pty : Couldn't grant pty - "
+		       "errno = %d\n", -info.err);
+		goto out;
 	}
-	if(unlockpt(fd) < 0){
-		printk("get_pty : Couldn't unlock pty - errno = %d\n", errno);
-		return(-1);
+
+	if (unlockpt(fd) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "get_pty : Couldn't unlock pty - "
+		       "errno = %d\n", errno);
+		goto out;
 	}
-	return(fd);
+	return fd;
+out:
+	close(fd);
+	return err;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/os-Linux/tty_log.c~uml-tidy-kern_utilh arch/um/os-Linux/tty_log.c
--- a/arch/um/os-Linux/tty_log.c~uml-tidy-kern_utilh
+++ a/arch/um/os-Linux/tty_log.c
@@ -12,7 +12,6 @@
 #include <sys/time.h>
 #include "init.h"
 #include "user.h"
-#include "kern_util.h"
 #include "os.h"
 
 #define TTY_LOG_DIR "./"
diff -puN arch/um/sys-i386/bugs.c~uml-tidy-kern_utilh arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-tidy-kern_utilh
+++ a/arch/um/sys-i386/bugs.c
@@ -5,6 +5,7 @@
 
 #include <signal.h>
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "longjmp.h"
 #include "task.h"
 #include "user.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
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
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
