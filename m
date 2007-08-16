From: akpm@linux-foundation.org
Subject: + uml-remove-code-made-redundant-by-choose_mode-removal.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:22 -0700
Message-ID: <200708162114.l7GLENU9007089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758573AbXHPVOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove code made redundant by CHOOSE_MODE removal
has been added to the -mm tree.  Its filename is
     uml-remove-code-made-redundant-by-choose_mode-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove code made redundant by CHOOSE_MODE removal
From: Jeff Dike <jdike@addtoit.com>

This patch makes a number of simplifications enabled by the removal of
CHOOSE_MODE.  There were lots of functions that looked like

	int foo(args){
		foo_skas(args);
	}

The bodies of foo_skas are now folded into foo, and their declarations (and
sometimes entire header files) are deleted.

In addition, the union uml_pt_regs, which was a union between the tt and skas
register formats, is now a struct, with the tt-mode arm of the union being
removed.

It turns out that usr2_handler was unused, so it is gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_user.c         |    1 
 arch/um/include/arch.h                 |    4 
 arch/um/include/as-layout.h            |    2 
 arch/um/include/irq_user.h             |    2 
 arch/um/include/kern_util.h            |   19 +-
 arch/um/include/mconsole.h             |    2 
 arch/um/include/mode.h                 |   11 -
 arch/um/include/mode_kern.h            |   11 -
 arch/um/include/os.h                   |    6 
 arch/um/include/registers.h            |    6 
 arch/um/include/skas/mmu-skas.h        |    2 
 arch/um/include/skas/mode_kern_skas.h  |   42 -----
 arch/um/include/skas/skas.h            |    2 
 arch/um/include/sysdep-i386/ptrace.h   |   59 +++-----
 arch/um/include/sysdep-x86_64/ptrace.h |   88 +++++-------
 arch/um/include/task.h                 |    2 
 arch/um/kernel/exec.c                  |   20 ++
 arch/um/kernel/irq.c                   |    4 
 arch/um/kernel/physmem.c               |    4 
 arch/um/kernel/process.c               |  120 +++++++++++++---
 arch/um/kernel/ptrace.c                |    6 
 arch/um/kernel/reboot.c                |   21 ++
 arch/um/kernel/signal.c                |    1 
 arch/um/kernel/skas/Makefile           |    2 
 arch/um/kernel/skas/exec.c             |   40 -----
 arch/um/kernel/skas/mem.c              |   22 ---
 arch/um/kernel/skas/mmu.c              |    4 
 arch/um/kernel/skas/process.c          |  158 +---------------------
 arch/um/kernel/skas/syscall.c          |    4 
 arch/um/kernel/skas/tlb.c              |  164 -----------------------
 arch/um/kernel/syscall.c               |    1 
 arch/um/kernel/time.c                  |    7 
 arch/um/kernel/tlb.c                   |  134 ++++++++++++++++++
 arch/um/kernel/trap.c                  |   10 -
 arch/um/kernel/um_arch.c               |   22 ++-
 arch/um/os-Linux/aio.c                 |    1 
 arch/um/os-Linux/main.c                |    1 
 arch/um/os-Linux/process.c             |    3 
 arch/um/os-Linux/registers.c           |   12 -
 arch/um/os-Linux/signal.c              |    5 
 arch/um/os-Linux/skas/mem.c            |    4 
 arch/um/os-Linux/skas/process.c        |   24 +--
 arch/um/os-Linux/skas/trap.c           |   14 -
 arch/um/os-Linux/start_up.c            |    1 
 arch/um/os-Linux/trap.c                |    8 -
 arch/um/os-Linux/umid.c                |    1 
 arch/um/sys-i386/bugs.c                |    2 
 arch/um/sys-i386/fault.c               |    2 
 arch/um/sys-i386/ldt.c                 |    7 
 arch/um/sys-i386/ptrace.c              |   10 -
 arch/um/sys-i386/signal.c              |   86 +++++-------
 arch/um/sys-i386/tls.c                 |    4 
 arch/um/sys-x86_64/bugs.c              |    2 
 arch/um/sys-x86_64/fault.c             |    2 
 arch/um/sys-x86_64/signal.c            |   35 +---
 arch/um/sys-x86_64/syscalls.c          |    9 -
 arch/um/sys-x86_64/tls.c               |    2 
 include/asm-um/mmu_context.h           |   20 --
 include/asm-um/processor-generic.h     |   16 --
 include/asm-um/ptrace-generic.h        |    4 
 include/asm-um/ptrace-i386.h           |   17 --
 include/asm-um/ptrace-x86_64.h         |   13 -
 include/asm-um/tlbflush.h              |   13 -
 63 files changed, 512 insertions(+), 809 deletions(-)

diff -puN arch/um/drivers/harddog_user.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/drivers/harddog_user.c
@@ -9,7 +9,6 @@
 #include "user.h"
 #include "mconsole.h"
 #include "os.h"
-#include "mode.h"
 
 struct dog_data {
 	int stdin;
diff -puN arch/um/include/arch.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/arch.h
--- a/arch/um/include/arch.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/arch.h
@@ -9,7 +9,7 @@
 #include "sysdep/ptrace.h"
 
 extern void arch_check_bugs(void);
-extern int arch_fixup(unsigned long address, union uml_pt_regs *regs);
-extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
+extern int arch_fixup(unsigned long address, struct uml_pt_regs *regs);
+extern int arch_handle_signal(int sig, struct uml_pt_regs *regs);
 
 #endif
diff -puN arch/um/include/as-layout.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/as-layout.h
@@ -29,6 +29,6 @@ extern unsigned long brk_start;
 
 extern int linux_main(int argc, char **argv);
 
-extern void (*sig_info[])(int, union uml_pt_regs *);
+extern void (*sig_info[])(int, struct uml_pt_regs *);
 
 #endif
diff -puN arch/um/include/irq_user.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/irq_user.h
--- a/arch/um/include/irq_user.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/irq_user.h
@@ -21,7 +21,7 @@ struct irq_fd {
 
 enum { IRQ_READ, IRQ_WRITE };
 
-extern void sigio_handler(int sig, union uml_pt_regs *regs);
+extern void sigio_handler(int sig, struct uml_pt_regs *regs);
 extern int activate_fd(int irq, int fd, int type, void *dev_id);
 extern void free_irq_by_irq_and_dev(unsigned int irq, void *dev_id);
 extern void free_irq_by_fd(int fd);
diff -puN arch/um/include/kern_util.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/kern_util.h
@@ -10,7 +10,7 @@
 #include "sysdep/faultinfo.h"
 #include "uml-config.h"
 
-typedef void (*kern_hndl)(int, union uml_pt_regs *);
+typedef void (*kern_hndl)(int, struct uml_pt_regs *);
 
 struct kern_handlers {
 	kern_hndl relay_signal;
@@ -41,7 +41,7 @@ extern unsigned long alloc_stack(int ord
 extern int do_signal(void);
 extern int is_stack_fault(unsigned long sp);
 extern unsigned long segv(struct faultinfo fi, unsigned long ip,
-			  int is_user, union uml_pt_regs *regs);
+			  int is_user, struct uml_pt_regs *regs);
 extern int handle_page_fault(unsigned long address, unsigned long ip,
 			     int is_write, int is_user, int *code_out);
 extern void syscall_ready(void);
@@ -54,7 +54,7 @@ extern int need_finish_fork(void);
 extern void free_stack(unsigned long stack, int order);
 extern void add_input_request(int op, void (*proc)(int), void *arg);
 extern char *current_cmd(void);
-extern void timer_handler(int sig, union uml_pt_regs *regs);
+extern void timer_handler(int sig, struct uml_pt_regs *regs);
 extern int set_signals(int enable);
 extern int pid_to_processor_id(int pid);
 extern void deliver_signals(void *t);
@@ -64,9 +64,9 @@ extern void finish_fork(void);
 extern void paging_init(void);
 extern void init_flush_vm(void);
 extern void *syscall_sp(void *t);
-extern void syscall_trace(union uml_pt_regs *regs, int entryexit);
+extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
 extern int hz(void);
-extern unsigned int do_IRQ(int irq, union uml_pt_regs *regs);
+extern unsigned int do_IRQ(int irq, struct uml_pt_regs *regs);
 extern void interrupt_end(void);
 extern void initial_thread_cb(void (*proc)(void *), void *arg);
 extern int debugger_signal(int status, int pid);
@@ -76,9 +76,9 @@ extern int init_ptrace_proxy(int idle_pi
 extern int init_parent_proxy(int pid);
 extern int singlestepping(void *t);
 extern void check_stack_overflow(void *ptr);
-extern void relay_signal(int sig, union uml_pt_regs *regs);
+extern void relay_signal(int sig, struct uml_pt_regs *regs);
 extern int user_context(unsigned long sp);
-extern void timer_irq(union uml_pt_regs *regs);
+extern void timer_irq(struct uml_pt_regs *regs);
 extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
@@ -109,11 +109,12 @@ extern void time_init_kern(void);
 
 /* Are we disallowed to sleep? Used to choose between GFP_KERNEL and GFP_ATOMIC. */
 extern int __cant_sleep(void);
-extern void sigio_handler(int sig, union uml_pt_regs *regs);
+extern void sigio_handler(int sig, struct uml_pt_regs *regs);
 
-extern void copy_sc(union uml_pt_regs *regs, void *from);
+extern void copy_sc(struct uml_pt_regs *regs, void *from);
 
 unsigned long to_irq_stack(int sig, unsigned long *mask_out);
 unsigned long from_irq_stack(int nested);
 
+extern int start_uml(void);
 #endif
diff -puN arch/um/include/mconsole.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/mconsole.h
--- a/arch/um/include/mconsole.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/mconsole.h
@@ -63,7 +63,7 @@ struct mc_request
 
 	struct mconsole_request request;
 	struct mconsole_command *cmd;
-	union uml_pt_regs regs;
+	struct uml_pt_regs regs;
 };
 
 extern char mconsole_socket_name[];
diff -puN arch/um/include/mode.h~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/include/mode.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_H__
-#define __MODE_H__
-
-#include "mode-skas.h"
-
-#endif
diff -puN arch/um/include/mode_kern.h~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/include/mode_kern.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_KERN_H__
-#define __MODE_KERN_H__
-
-#include "mode_kern_skas.h"
-
-#endif
diff -puN arch/um/include/os.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/os.h
--- a/arch/um/include/os.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/os.h
@@ -281,9 +281,9 @@ extern int protect(struct mm_id * mm_idp
 extern int is_skas_winch(int pid, int fd, void *data);
 extern int start_userspace(unsigned long stub_stack);
 extern int copy_context_skas0(unsigned long stack, int pid);
-extern void save_registers(int pid, union uml_pt_regs *regs);
-extern void restore_registers(int pid, union uml_pt_regs *regs);
-extern void userspace(union uml_pt_regs *regs);
+extern void save_registers(int pid, struct uml_pt_regs *regs);
+extern void restore_registers(int pid, struct uml_pt_regs *regs);
+extern void userspace(struct uml_pt_regs *regs);
 extern void map_stub_pages(int fd, unsigned long code,
 			   unsigned long data, unsigned long stack);
 extern void new_thread(void *stack, jmp_buf *buf, void (*handler)(void));
diff -puN arch/um/include/registers.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/registers.h
--- a/arch/um/include/registers.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/registers.h
@@ -9,11 +9,11 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/archsetjmp.h"
 
-extern void init_thread_registers(union uml_pt_regs *to);
+extern void init_thread_registers(struct uml_pt_regs *to);
 extern int save_fp_registers(int pid, unsigned long *fp_regs);
 extern int restore_fp_registers(int pid, unsigned long *fp_regs);
-extern void save_registers(int pid, union uml_pt_regs *regs);
-extern void restore_registers(int pid, union uml_pt_regs *regs);
+extern void save_registers(int pid, struct uml_pt_regs *regs);
+extern void restore_registers(int pid, struct uml_pt_regs *regs);
 extern void init_registers(int pid);
 extern void get_safe_registers(unsigned long *regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
diff -puN arch/um/include/skas/mmu-skas.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/skas/mmu-skas.h
--- a/arch/um/include/skas/mmu-skas.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/skas/mmu-skas.h
@@ -18,6 +18,6 @@ struct mmu_context_skas {
 	uml_ldt_t ldt;
 };
 
-extern void switch_mm_skas(struct mm_id * mm_idp);
+extern void __switch_mm(struct mm_id * mm_idp);
 
 #endif
diff -puN arch/um/include/skas/mode_kern_skas.h~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/include/skas/mode_kern_skas.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
- * Licensed under the GPL
- */
-
-#ifndef __SKAS_MODE_KERN_H__
-#define __SKAS_MODE_KERN_H__
-
-#include "linux/sched.h"
-#include "asm/page.h"
-#include "asm/ptrace.h"
-#include "mem_user.h"
-
-extern void flush_thread_skas(void);
-extern void switch_to_skas(void *prev, void *next);
-extern void start_thread_skas(struct pt_regs *regs, unsigned long eip,
-			      unsigned long esp);
-extern int copy_thread_skas(int nr, unsigned long clone_flags,
-			    unsigned long sp, unsigned long stack_top,
-			    struct task_struct *p, struct pt_regs *regs);
-extern void release_thread_skas(struct task_struct *task);
-extern void init_idle_skas(void);
-extern void flush_tlb_kernel_range_skas(unsigned long start,
-					unsigned long end);
-extern void flush_tlb_kernel_vm_skas(void);
-extern void __flush_tlb_one_skas(unsigned long addr);
-extern void flush_tlb_range_skas(struct vm_area_struct *vma,
-				 unsigned long start, unsigned long end);
-extern void flush_tlb_mm_skas(struct mm_struct *mm);
-extern void force_flush_all_skas(void);
-extern long execute_syscall_skas(void *r);
-extern void before_mem_skas(unsigned long unused);
-extern unsigned long set_task_sizes_skas(unsigned long *task_size_out);
-extern int start_uml_skas(void);
-extern int external_pid_skas(struct task_struct *task);
-extern int thread_pid_skas(struct task_struct *task);
-extern void flush_tlb_page_skas(struct vm_area_struct *vma,
-				unsigned long address);
-
-#define kmem_end_skas (host_task_size - 1024 * 1024)
-
-#endif
diff -puN arch/um/include/skas/skas.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/skas/skas.h
--- a/arch/um/include/skas/skas.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/skas/skas.h
@@ -15,7 +15,7 @@ extern int skas_needs_stub;
 
 extern int user_thread(unsigned long stack, int flags);
 extern void new_thread_handler(void);
-extern void handle_syscall(union uml_pt_regs *regs);
+extern void handle_syscall(struct uml_pt_regs *regs);
 extern int new_mm(unsigned long stack);
 extern void get_skas_faultinfo(int pid, struct faultinfo * fi);
 extern long execute_syscall_skas(void *r);
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -52,37 +52,34 @@ extern int sysemu_supported;
 #define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
-union uml_pt_regs {
-	struct skas_regs {
-		unsigned long regs[MAX_REG_NR];
-		unsigned long fp[HOST_FP_SIZE];
-		unsigned long xfp[HOST_XFP_SIZE];
-                struct faultinfo faultinfo;
-		long syscall;
-		int is_user;
-	} skas;
+struct uml_pt_regs {
+	unsigned long regs[MAX_REG_NR];
+	unsigned long fp[HOST_FP_SIZE];
+	unsigned long xfp[HOST_XFP_SIZE];
+	struct faultinfo faultinfo;
+	long syscall;
+	int is_user;
 };
 
 #define EMPTY_UML_PT_REGS { }
 
-#define UPT_SC(r) ((r)->tt.sc)
-#define UPT_IP(r) REGS_IP((r)->skas.regs)
-#define UPT_SP(r) REGS_SP((r)->skas.regs)
-#define UPT_EFLAGS(r) REGS_EFLAGS((r)->skas.regs)
-#define UPT_EAX(r) REGS_EAX((r)->skas.regs)
-#define UPT_EBX(r) REGS_EBX((r)->skas.regs)
-#define UPT_ECX(r) REGS_ECX((r)->skas.regs)
-#define UPT_EDX(r) REGS_EDX((r)->skas.regs)
-#define UPT_ESI(r) REGS_ESI((r)->skas.regs)
-#define UPT_EDI(r) REGS_EDI((r)->skas.regs)
-#define UPT_EBP(r) REGS_EBP((r)->skas.regs)
-#define UPT_ORIG_EAX(r) ((r)->skas.syscall)
-#define UPT_CS(r) REGS_CS((r)->skas.regs)
-#define UPT_SS(r) REGS_SS((r)->skas.regs)
-#define UPT_DS(r) REGS_DS((r)->skas.regs)
-#define UPT_ES(r) REGS_ES((r)->skas.regs)
-#define UPT_FS(r) REGS_FS((r)->skas.regs)
-#define UPT_GS(r) REGS_GS((r)->skas.regs)
+#define UPT_IP(r) REGS_IP((r)->regs)
+#define UPT_SP(r) REGS_SP((r)->regs)
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->regs)
+#define UPT_EAX(r) REGS_EAX((r)->regs)
+#define UPT_EBX(r) REGS_EBX((r)->regs)
+#define UPT_ECX(r) REGS_ECX((r)->regs)
+#define UPT_EDX(r) REGS_EDX((r)->regs)
+#define UPT_ESI(r) REGS_ESI((r)->regs)
+#define UPT_EDI(r) REGS_EDI((r)->regs)
+#define UPT_EBP(r) REGS_EBP((r)->regs)
+#define UPT_ORIG_EAX(r) ((r)->syscall)
+#define UPT_CS(r) REGS_CS((r)->regs)
+#define UPT_SS(r) REGS_SS((r)->regs)
+#define UPT_DS(r) REGS_DS((r)->regs)
+#define UPT_ES(r) REGS_ES((r)->regs)
+#define UPT_FS(r) REGS_FS((r)->regs)
+#define UPT_GS(r) REGS_GS((r)->regs)
 
 #define UPT_SYSCALL_ARG1(r) UPT_EBX(r)
 #define UPT_SYSCALL_ARG2(r) UPT_ECX(r)
@@ -93,7 +90,7 @@ union uml_pt_regs {
 
 extern int user_context(unsigned long sp);
 
-#define UPT_IS_USER(r) ((r)->skas.is_user)
+#define UPT_IS_USER(r) ((r)->is_user)
 
 struct syscall_args {
 	unsigned long args[6];
@@ -162,14 +159,14 @@ struct syscall_args {
 	} while (0)
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res))
+	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
-#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->skas.regs)
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->regs)
 
 #define UPT_ORIG_SYSCALL(r) UPT_EAX(r)
 #define UPT_SYSCALL_NR(r) UPT_ORIG_EAX(r)
 #define UPT_SYSCALL_RET(r) UPT_EAX(r)
 
-#define UPT_FAULTINFO(r) (&(r)->skas.faultinfo)
+#define UPT_FAULTINFO(r) (&(r)->faultinfo)
 
 #endif
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -84,58 +84,52 @@
 
 #define REGS_ERR(r) ((r)->fault_type)
 
-/* XXX */
-union uml_pt_regs {
-	struct skas_regs {
-		unsigned long regs[MAX_REG_NR];
-		unsigned long fp[HOST_FP_SIZE];
-                struct faultinfo faultinfo;
-		long syscall;
-		int is_user;
-	} skas;
+struct uml_pt_regs {
+	unsigned long regs[MAX_REG_NR];
+	unsigned long fp[HOST_FP_SIZE];
+	struct faultinfo faultinfo;
+	long syscall;
+	int is_user;
 };
 
 #define EMPTY_UML_PT_REGS { }
 
-#define UPT_RBX(r) REGS_RBX((r)->skas.regs)
-#define UPT_RCX(r) REGS_RCX((r)->skas.regs)
-#define UPT_RDX(r) REGS_RDX((r)->skas.regs)
-#define UPT_RSI(r) REGS_RSI((r)->skas.regs)
-#define UPT_RDI(r) REGS_RDI((r)->skas.regs)
-#define UPT_RBP(r) REGS_RBP((r)->skas.regs)
-#define UPT_RAX(r) REGS_RAX((r)->skas.regs)
-#define UPT_R8(r) REGS_R8((r)->skas.regs)
-#define UPT_R9(r) REGS_R9((r)->skas.regs)
-#define UPT_R10(r) REGS_R10((r)->skas.regs)
-#define UPT_R11(r) REGS_R11((r)->skas.regs)
-#define UPT_R12(r) REGS_R12((r)->skas.regs)
-#define UPT_R13(r) REGS_R13((r)->skas.regs)
-#define UPT_R14(r) REGS_R14((r)->skas.regs)
-#define UPT_R15(r) REGS_R15((r)->skas.regs)
-#define UPT_CS(r) REGS_CS((r)->skas.regs)
-#define UPT_FS_BASE(r) \
-	REGS_FS_BASE((r)->skas.regs)
-#define UPT_FS(r) REGS_FS((r)->skas.regs)
-#define UPT_GS_BASE(r) \
-	REGS_GS_BASE((r)->skas.regs)
-#define UPT_GS(r) REGS_GS((r)->skas.regs)
-#define UPT_DS(r) REGS_DS((r)->skas.regs)
-#define UPT_ES(r) REGS_ES((r)->skas.regs)
-#define UPT_CS(r) REGS_CS((r)->skas.regs)
-#define UPT_SS(r) REGS_SS((r)->skas.regs)
-#define UPT_ORIG_RAX(r) REGS_ORIG_RAX((r)->skas.regs)
-
-#define UPT_IP(r) REGS_IP((r)->skas.regs)
-#define UPT_SP(r) REGS_SP((r)->skas.regs)
-
-#define UPT_EFLAGS(r) REGS_EFLAGS((r)->skas.regs)
-#define UPT_SC(r) ((r)->tt.sc)
-#define UPT_SYSCALL_NR(r) ((r)->skas.syscall)
+#define UPT_RBX(r) REGS_RBX((r)->regs)
+#define UPT_RCX(r) REGS_RCX((r)->regs)
+#define UPT_RDX(r) REGS_RDX((r)->regs)
+#define UPT_RSI(r) REGS_RSI((r)->regs)
+#define UPT_RDI(r) REGS_RDI((r)->regs)
+#define UPT_RBP(r) REGS_RBP((r)->regs)
+#define UPT_RAX(r) REGS_RAX((r)->regs)
+#define UPT_R8(r) REGS_R8((r)->regs)
+#define UPT_R9(r) REGS_R9((r)->regs)
+#define UPT_R10(r) REGS_R10((r)->regs)
+#define UPT_R11(r) REGS_R11((r)->regs)
+#define UPT_R12(r) REGS_R12((r)->regs)
+#define UPT_R13(r) REGS_R13((r)->regs)
+#define UPT_R14(r) REGS_R14((r)->regs)
+#define UPT_R15(r) REGS_R15((r)->regs)
+#define UPT_CS(r) REGS_CS((r)->regs)
+#define UPT_FS_BASE(r) REGS_FS_BASE((r)->regs)
+#define UPT_FS(r) REGS_FS((r)->regs)
+#define UPT_GS_BASE(r) REGS_GS_BASE((r)->regs)
+#define UPT_GS(r) REGS_GS((r)->regs)
+#define UPT_DS(r) REGS_DS((r)->regs)
+#define UPT_ES(r) REGS_ES((r)->regs)
+#define UPT_CS(r) REGS_CS((r)->regs)
+#define UPT_SS(r) REGS_SS((r)->regs)
+#define UPT_ORIG_RAX(r) REGS_ORIG_RAX((r)->regs)
+
+#define UPT_IP(r) REGS_IP((r)->regs)
+#define UPT_SP(r) REGS_SP((r)->regs)
+
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->regs)
+#define UPT_SYSCALL_NR(r) ((r)->syscall)
 #define UPT_SYSCALL_RET(r) UPT_RAX(r)
 
 extern int user_context(unsigned long sp);
 
-#define UPT_IS_USER(r) ((r)->skas.is_user)
+#define UPT_IS_USER(r) ((r)->is_user)
 
 #define UPT_SYSCALL_ARG1(r) UPT_RDI(r)
 #define UPT_SYSCALL_ARG2(r) UPT_RSI(r)
@@ -232,12 +226,12 @@ struct syscall_args {
         })
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res))
+	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
-#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->skas.regs)
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->regs)
 
 #define UPT_SEGV_IS_FIXABLE(r) REGS_SEGV_IS_FIXABLE(&r->skas)
 
-#define UPT_FAULTINFO(r) (&(r)->skas.faultinfo)
+#define UPT_FAULTINFO(r) (&(r)->faultinfo)
 
 #endif
diff -puN arch/um/include/task.h~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/include/task.h
--- a/arch/um/include/task.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/include/task.h
@@ -3,7 +3,7 @@
 
 #include <kern_constants.h>
 
-#define TASK_REGS(task) ((union uml_pt_regs *) &(((char *) (task))[HOST_TASK_REGS]))
+#define TASK_REGS(task) ((struct uml_pt_regs *) &(((char *) (task))[HOST_TASK_REGS]))
 #define TASK_PID(task) *((int *) &(((char *) (task))[HOST_TASK_PID]))
 
 #endif
diff -puN arch/um/kernel/exec.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/exec.c
@@ -18,17 +18,31 @@
 #include "irq_user.h"
 #include "tlb.h"
 #include "os.h"
-#include "mode_kern.h"
+#include "skas/skas.h"
 
 void flush_thread(void)
 {
+	void *data = NULL;
+	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
+	int ret;
+
 	arch_flush_thread(&current->thread.arch);
-	flush_thread_skas();
+
+	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
+	if(ret){
+		printk("flush_thread - clearing address space failed, "
+		       "err = %d\n", ret);
+		force_sig(SIGKILL, current);
+	}
+
+	__switch_mm(&current->mm->context.skas.id);
 }
 
 void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 {
-	start_thread_skas(regs, eip, esp);
+	set_fs(USER_DS);
+	PT_REGS_IP(regs) = eip;
+	PT_REGS_SP(regs) = esp;
 }
 
 #ifdef CONFIG_TTY_LOG
diff -puN arch/um/kernel/irq.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/irq.c
@@ -91,7 +91,7 @@ static struct irq_fd **last_irq_ptr = &a
 
 extern void free_irqs(void);
 
-void sigio_handler(int sig, union uml_pt_regs *regs)
+void sigio_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct irq_fd *irq_fd;
 	int n;
@@ -344,7 +344,7 @@ int deactivate_all_fds(void)
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-unsigned int do_IRQ(int irq, union uml_pt_regs *regs)
+unsigned int do_IRQ(int irq, struct uml_pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
diff -puN arch/um/kernel/physmem.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/physmem.c
@@ -10,7 +10,7 @@
 #include "as-layout.h"
 #include "init.h"
 #include "kern.h"
-#include "mode_kern.h"
+#include "mem_user.h"
 #include "os.h"
 
 static int physmem_fd = -1;
@@ -61,7 +61,7 @@ static unsigned long kmem_top = 0;
 unsigned long get_kmem_end(void)
 {
 	if (kmem_top == 0)
-		kmem_top = kmem_end_skas;
+		kmem_top = host_task_size - 1024 * 1024;
 	return kmem_top;
 }
 
diff -puN arch/um/kernel/process.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/process.c
@@ -43,8 +43,7 @@
 #include "frame_kern.h"
 #include "sigcontext.h"
 #include "os.h"
-#include "mode.h"
-#include "mode_kern.h"
+#include "skas.h"
 
 /* This is a per-cpu array.  A processor only modifies its entry and it only
  * cares about its entry, so it's OK if another processor is modifying its
@@ -54,7 +53,8 @@ struct cpu_task cpu_tasks[NR_CPUS] = { [
 
 static inline int external_pid(struct task_struct *task)
 {
-	return external_pid_skas(task);
+	/* FIXME: Need to look up userspace_pid by cpu */
+	return(userspace_pid[0]);
 }
 
 int pid_to_processor_id(int pid)
@@ -104,6 +104,8 @@ static inline void set_current(struct ta
 		{ external_pid(task), task });
 }
 
+extern void arch_switch_to(struct task_struct *from, struct task_struct *to);
+
 void *_switch_to(void *prev, void *next, void *last)
 {
 	struct task_struct *from = prev;
@@ -114,7 +116,19 @@ void *_switch_to(void *prev, void *next,
 
 	do {
 		current->thread.saved_task = NULL;
-		switch_to_skas(prev, next);
+
+		/* XXX need to check runqueues[cpu].idle */
+		if(current->pid == 0)
+			switch_timers(0);
+
+		switch_threads(&from->thread.switch_buf,
+			       &to->thread.switch_buf);
+
+		arch_switch_to(current->thread.prev_sched, current);
+
+		if(current->pid == 0)
+			switch_timers(1);
+
 		if(current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
@@ -133,11 +147,6 @@ void interrupt_end(void)
 		do_signal();
 }
 
-void release_thread(struct task_struct *task)
-{
-	release_thread_skas(task);
-}
-
 void exit_thread(void)
 {
 }
@@ -147,27 +156,95 @@ void *get_current(void)
 	return current;
 }
 
+extern void schedule_tail(struct task_struct *prev);
+
+/* This is called magically, by its address being stuffed in a jmp_buf
+ * and being longjmp-d to.
+ */
+void new_thread_handler(void)
+{
+	int (*fn)(void *), n;
+	void *arg;
+
+	if(current->thread.prev_sched != NULL)
+		schedule_tail(current->thread.prev_sched);
+	current->thread.prev_sched = NULL;
+
+	fn = current->thread.request.u.thread.proc;
+	arg = current->thread.request.u.thread.arg;
+
+	/* The return value is 1 if the kernel thread execs a process,
+	 * 0 if it just exits
+	 */
+	n = run_kernel_thread(fn, arg, &current->thread.exec_buf);
+	if(n == 1){
+		/* Handle any immediate reschedules or signals */
+		interrupt_end();
+		userspace(&current->thread.regs.regs);
+	}
+	else do_exit(0);
+}
+
+/* Called magically, see new_thread_handler above */
+void fork_handler(void)
+{
+	force_flush_all();
+	if(current->thread.prev_sched == NULL)
+		panic("blech");
+
+	schedule_tail(current->thread.prev_sched);
+
+	/* XXX: if interrupt_end() calls schedule, this call to
+	 * arch_switch_to isn't needed. We could want to apply this to
+	 * improve performance. -bb */
+	arch_switch_to(current->thread.prev_sched, current);
+
+	current->thread.prev_sched = NULL;
+
+	/* Handle any immediate reschedules or signals */
+	interrupt_end();
+
+	userspace(&current->thread.regs.regs);
+}
+
 int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 		unsigned long stack_top, struct task_struct * p,
 		struct pt_regs *regs)
 {
-	int ret;
+	void (*handler)(void);
+	int ret = 0;
 
 	p->thread = (struct thread_struct) INIT_THREAD;
-	ret = copy_thread_skas(nr, clone_flags, sp, stack_top, p, regs);
 
-	if (ret || !current->thread.forking)
-		goto out;
+	if(current->thread.forking){
+	  	memcpy(&p->thread.regs.regs, &regs->regs,
+		       sizeof(p->thread.regs.regs));
+		REGS_SET_SYSCALL_RETURN(p->thread.regs.regs.regs, 0);
+		if(sp != 0)
+			REGS_SP(p->thread.regs.regs.regs) = sp;
 
-	clear_flushed_tls(p);
+		handler = fork_handler;
 
-	/*
-	 * Set a new TLS for the child thread?
-	 */
-	if (clone_flags & CLONE_SETTLS)
-		ret = arch_copy_tls(p);
+		arch_copy_thread(&current->thread.arch, &p->thread.arch);
+	}
+	else {
+		init_thread_registers(&p->thread.regs.regs);
+		p->thread.request.u.thread = current->thread.request.u.thread;
+		handler = new_thread_handler;
+	}
+
+	new_thread(task_stack_page(p), &p->thread.switch_buf, handler);
+
+	if (current->thread.forking) {
+		clear_flushed_tls(p);
+
+		/*
+		 * Set a new TLS for the child thread?
+		 */
+		if (clone_flags & CLONE_SETTLS)
+			ret = arch_copy_tls(p);
+	}
 
-out:
 	return ret;
 }
 
@@ -198,7 +275,8 @@ void default_idle(void)
 
 void cpu_idle(void)
 {
-	init_idle_skas();
+	cpu_tasks[current_thread->cpu].pid = os_getpid();
+	default_idle();
 }
 
 void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
diff -puN arch/um/kernel/ptrace.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/ptrace.c
@@ -228,7 +228,7 @@ long arch_ptrace(struct task_struct *chi
 #ifdef PTRACE_ARCH_PRCTL
         case PTRACE_ARCH_PRCTL:
                 /* XXX Calls ptrace on the host - needs some SMP thinking */
-                ret = arch_prctl_skas(child, data, (void *) addr);
+                ret = arch_prctl(child, data, (void *) addr);
                 break;
 #endif
 	default:
@@ -239,7 +239,7 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-void send_sigtrap(struct task_struct *tsk, union uml_pt_regs *regs,
+void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
 		  int error_code)
 {
 	struct siginfo info;
@@ -258,7 +258,7 @@ void send_sigtrap(struct task_struct *ts
 /* XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
  * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
  */
-void syscall_trace(union uml_pt_regs *regs, int entryexit)
+void syscall_trace(struct uml_pt_regs *regs, int entryexit)
 {
 	int is_singlestep = (current->ptrace & PT_DTRACE) && entryexit;
 	int tracesysgood;
diff -puN arch/um/kernel/reboot.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/reboot.c
@@ -9,13 +9,30 @@
 #include "kern_util.h"
 #include "kern.h"
 #include "os.h"
-#include "mode.h"
+#include "skas.h"
 
 void (*pm_power_off)(void);
 
 static void kill_off_processes(void)
 {
-	kill_off_processes_skas();
+	if(proc_mm)
+		/*
+		 * FIXME: need to loop over userspace_pids
+		 */
+		os_kill_ptraced_process(userspace_pid[0], 1);
+	else {
+		struct task_struct *p;
+		int pid, me;
+
+		me = os_getpid();
+		for_each_process(p){
+			if(p->mm == NULL)
+				continue;
+
+			pid = p->mm->context.skas.id.u.pid;
+			os_kill_ptraced_process(pid, 1);
+		}
+	}
 }
 
 void uml_cleanup(void)
diff -puN arch/um/kernel/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/signal.c
--- a/arch/um/kernel/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/signal.c
@@ -23,7 +23,6 @@
 #include "kern.h"
 #include "frame_kern.h"
 #include "sigcontext.h"
-#include "mode.h"
 
 EXPORT_SYMBOL(block_signals);
 EXPORT_SYMBOL(unblock_signals);
diff -puN arch/um/kernel/skas/Makefile~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/skas/Makefile
--- a/arch/um/kernel/skas/Makefile~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/skas/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y := clone.o exec.o mem.o mmu.o process.o syscall.o tlb.o uaccess.o
+obj-y := clone.o mmu.o process.o syscall.o uaccess.o
 
 # clone.o is in the stub, so it can't be built with profiling
 # GCC hardened also auto-enables -fpic, but we need %ebx so it can't work ->
diff -puN arch/um/kernel/skas/exec.c~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/kernel/skas/exec.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/kernel.h"
-#include "asm/current.h"
-#include "asm/page.h"
-#include "asm/signal.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-#include "asm/mmu_context.h"
-#include "tlb.h"
-#include "skas.h"
-#include "um_mmu.h"
-#include "os.h"
-
-void flush_thread_skas(void)
-{
-	void *data = NULL;
-	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
-	int ret;
-
-	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
-	if(ret){
-		printk("flush_thread_skas - clearing address space failed, "
-		       "err = %d\n", ret);
-		force_sig(SIGKILL, current);
-	}
-
-	switch_mm_skas(&current->mm->context.skas.id);
-}
-
-void start_thread_skas(struct pt_regs *regs, unsigned long eip,
-		       unsigned long esp)
-{
-	set_fs(USER_DS);
-	PT_REGS_IP(regs) = eip;
-	PT_REGS_SP(regs) = esp;
-}
diff -puN arch/um/kernel/skas/mem.c~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/kernel/skas/mem.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/mm.h"
-#include "asm/pgtable.h"
-#include "mem_user.h"
-#include "skas.h"
-
-unsigned long set_task_sizes_skas(unsigned long *task_size_out)
-{
-	/* Round up to the nearest 4M */
-	unsigned long host_task_size = ROUND_4M((unsigned long)
-						&host_task_size);
-
-	if (!skas_needs_stub)
-		*task_size_out = host_task_size;
-	else *task_size_out = CONFIG_STUB_START & PGDIR_MASK;
-
-	return host_task_size;
-}
diff -puN arch/um/kernel/skas/mmu.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/skas/mmu.c
@@ -71,7 +71,7 @@ static int init_stub_pte(struct mm_struc
 	return(-ENOMEM);
 }
 
-int init_new_context_skas(struct task_struct *task, struct mm_struct *mm)
+int init_new_context(struct task_struct *task, struct mm_struct *mm)
 {
  	struct mmu_context_skas *from_mm = NULL;
 	struct mmu_context_skas *to_mm = &mm->context.skas;
@@ -137,7 +137,7 @@ int init_new_context_skas(struct task_st
 	return ret;
 }
 
-void destroy_context_skas(struct mm_struct *mm)
+void destroy_context(struct mm_struct *mm)
 {
 	struct mmu_context_skas *mmu = &mm->context.skas;
 
diff -puN arch/um/kernel/skas/process.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/skas/process.c
@@ -18,129 +18,22 @@
 #include "os.h"
 #include "tlb.h"
 #include "kern.h"
-#include "mode.h"
 #include "registers.h"
 
-void switch_to_skas(void *prev, void *next)
-{
-	struct task_struct *from, *to;
-
-	from = prev;
-	to = next;
-
-	/* XXX need to check runqueues[cpu].idle */
-	if(current->pid == 0)
-		switch_timers(0);
-
-	switch_threads(&from->thread.mode.skas.switch_buf,
-		       &to->thread.mode.skas.switch_buf);
-
-	arch_switch_to_skas(current->thread.prev_sched, current);
-
-	if(current->pid == 0)
-		switch_timers(1);
-}
-
 extern void schedule_tail(struct task_struct *prev);
 
-/* This is called magically, by its address being stuffed in a jmp_buf
- * and being longjmp-d to.
- */
-void new_thread_handler(void)
-{
-	int (*fn)(void *), n;
-	void *arg;
-
-	if(current->thread.prev_sched != NULL)
-		schedule_tail(current->thread.prev_sched);
-	current->thread.prev_sched = NULL;
-
-	fn = current->thread.request.u.thread.proc;
-	arg = current->thread.request.u.thread.arg;
-
-	/* The return value is 1 if the kernel thread execs a process,
-	 * 0 if it just exits
-	 */
-	n = run_kernel_thread(fn, arg, &current->thread.exec_buf);
-	if(n == 1){
-		/* Handle any immediate reschedules or signals */
-		interrupt_end();
-		userspace(&current->thread.regs.regs);
-	}
-	else do_exit(0);
-}
-
-void release_thread_skas(struct task_struct *task)
-{
-}
-
-/* Called magically, see new_thread_handler above */
-void fork_handler(void)
-{
-	force_flush_all();
-	if(current->thread.prev_sched == NULL)
-		panic("blech");
-
-	schedule_tail(current->thread.prev_sched);
-
-	/* XXX: if interrupt_end() calls schedule, this call to
-	 * arch_switch_to_skas isn't needed. We could want to apply this to
-	 * improve performance. -bb */
-	arch_switch_to_skas(current->thread.prev_sched, current);
-
-	current->thread.prev_sched = NULL;
-
-/* Handle any immediate reschedules or signals */
-	interrupt_end();
-
-	userspace(&current->thread.regs.regs);
-}
-
-int copy_thread_skas(int nr, unsigned long clone_flags, unsigned long sp,
-		     unsigned long stack_top, struct task_struct * p,
-		     struct pt_regs *regs)
-{
-	void (*handler)(void);
-
-	if(current->thread.forking){
-	  	memcpy(&p->thread.regs.regs.skas, &regs->regs.skas,
-		       sizeof(p->thread.regs.regs.skas));
-		REGS_SET_SYSCALL_RETURN(p->thread.regs.regs.skas.regs, 0);
-		if(sp != 0) REGS_SP(p->thread.regs.regs.skas.regs) = sp;
-
-		handler = fork_handler;
-
-		arch_copy_thread(&current->thread.arch, &p->thread.arch);
-	}
-	else {
-		init_thread_registers(&p->thread.regs.regs);
-		p->thread.request.u.thread = current->thread.request.u.thread;
-		handler = new_thread_handler;
-	}
-
-	new_thread(task_stack_page(p), &p->thread.mode.skas.switch_buf,
-		   handler);
-	return(0);
-}
-
 int new_mm(unsigned long stack)
 {
 	int fd;
 
 	fd = os_open_file("/proc/mm", of_cloexec(of_write(OPENFLAGS())), 0);
 	if(fd < 0)
-		return(fd);
+		return fd;
 
 	if(skas_needs_stub)
 		map_stub_pages(fd, CONFIG_STUB_CODE, CONFIG_STUB_DATA, stack);
 
-	return(fd);
-}
-
-void init_idle_skas(void)
-{
-	cpu_tasks[current_thread->cpu].pid = os_getpid();
-	default_idle();
+	return fd;
 }
 
 extern void start_kernel(void);
@@ -158,14 +51,14 @@ static int __init start_kernel_proc(void
 	cpu_online_map = cpumask_of_cpu(0);
 #endif
 	start_kernel();
-	return(0);
+	return 0;
 }
 
 extern int userspace_pid[];
 
 extern char cpu0_irqstack[];
 
-int __init start_uml_skas(void)
+int __init start_uml(void)
 {
 	stack_protections((unsigned long) &cpu0_irqstack);
 	set_sigstack(cpu0_irqstack, THREAD_SIZE);
@@ -176,49 +69,14 @@ int __init start_uml_skas(void)
 
 	init_task.thread.request.u.thread.proc = start_kernel_proc;
 	init_task.thread.request.u.thread.arg = NULL;
-	return(start_idle_thread(task_stack_page(&init_task),
-				 &init_task.thread.mode.skas.switch_buf));
-}
-
-int external_pid_skas(struct task_struct *task)
-{
-	/* FIXME: Need to look up userspace_pid by cpu */
-	return(userspace_pid[0]);
-}
-
-int thread_pid_skas(struct task_struct *task)
-{
-	/* FIXME: Need to look up userspace_pid by cpu */
-	return(userspace_pid[0]);
-}
-
-void kill_off_processes_skas(void)
-{
-	if(proc_mm)
-		/*
-		 * FIXME: need to loop over userspace_pids in
-		 * kill_off_processes_skas
-		 */
-		os_kill_ptraced_process(userspace_pid[0], 1);
-	else {
-		struct task_struct *p;
-		int pid, me;
-
-		me = os_getpid();
-		for_each_process(p){
-			if(p->mm == NULL)
-				continue;
-
-			pid = p->mm->context.skas.id.u.pid;
-			os_kill_ptraced_process(pid, 1);
-		}
-	}
+	return start_idle_thread(task_stack_page(&init_task),
+				 &init_task.thread.switch_buf);
 }
 
 unsigned long current_stub_stack(void)
 {
 	if(current->mm == NULL)
-		return(0);
+		return 0;
 
-	return(current->mm->context.skas.id.stack);
+	return current->mm->context.skas.id.stack;
 }
diff -puN arch/um/kernel/skas/syscall.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/skas/syscall.c
@@ -13,7 +13,7 @@
 #include "kern_util.h"
 #include "syscall.h"
 
-void handle_syscall(union uml_pt_regs *r)
+void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
 	long result;
@@ -37,7 +37,7 @@ void handle_syscall(union uml_pt_regs *r
 		result = -ENOSYS;
 	else result = EXECUTE_SYSCALL(syscall, regs);
 
-	REGS_SET_SYSCALL_RETURN(r->skas.regs, result);
+	REGS_SET_SYSCALL_RETURN(r->regs, result);
 
 	syscall_trace(r, 1);
 }
diff -puN arch/um/kernel/skas/tlb.c~uml-remove-code-made-redundant-by-choose_mode-removal /dev/null
--- a/arch/um/kernel/skas/tlb.c
+++ /dev/null
@@ -1,164 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Copyright 2003 PathScale, Inc.
- * Licensed under the GPL
- */
-
-#include "linux/stddef.h"
-#include "linux/sched.h"
-#include "linux/mm.h"
-#include "asm/page.h"
-#include "asm/pgtable.h"
-#include "asm/mmu.h"
-#include "mem_user.h"
-#include "mem.h"
-#include "skas.h"
-#include "os.h"
-#include "tlb.h"
-
-static int do_ops(union mm_context *mmu, struct host_vm_op *ops, int last,
-		  int finished, void **flush)
-{
-	struct host_vm_op *op;
-        int i, ret = 0;
-
-        for(i = 0; i <= last && !ret; i++){
-		op = &ops[i];
-		switch(op->type){
-		case MMAP:
-			ret = map(&mmu->skas.id, op->u.mmap.addr,
-				  op->u.mmap.len, op->u.mmap.prot,
-				  op->u.mmap.fd, op->u.mmap.offset, finished,
-				  flush);
-			break;
-		case MUNMAP:
-			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
-				    op->u.munmap.len, finished, flush);
-			break;
-		case MPROTECT:
-			ret = protect(&mmu->skas.id, op->u.mprotect.addr,
-				      op->u.mprotect.len, op->u.mprotect.prot,
-				      finished, flush);
-			break;
-		default:
-			printk("Unknown op type %d in do_ops\n", op->type);
-			break;
-		}
-	}
-
-	return ret;
-}
-
-extern int proc_mm;
-
-static void fix_range(struct mm_struct *mm, unsigned long start_addr,
-		      unsigned long end_addr, int force)
-{
-        if(!proc_mm && (end_addr > CONFIG_STUB_START))
-                end_addr = CONFIG_STUB_START;
-
-        fix_range_common(mm, start_addr, end_addr, force, do_ops);
-}
-
-void __flush_tlb_one_skas(unsigned long addr)
-{
-        flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
-}
-
-void flush_tlb_range_skas(struct vm_area_struct *vma, unsigned long start, 
-		     unsigned long end)
-{
-        if(vma->vm_mm == NULL)
-                flush_tlb_kernel_range_common(start, end);
-        else fix_range(vma->vm_mm, start, end, 0);
-}
-
-void flush_tlb_mm_skas(struct mm_struct *mm)
-{
-	unsigned long end;
-
-	/* Don't bother flushing if this address space is about to be
-         * destroyed.
-         */
-        if(atomic_read(&mm->mm_users) == 0)
-                return;
-
-	end = proc_mm ? task_size : CONFIG_STUB_START;
-        fix_range(mm, 0, end, 0);
-}
-
-void force_flush_all_skas(void)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = mm->mmap;
-
-	while(vma != NULL) {
-		fix_range(mm, vma->vm_start, vma->vm_end, 1);
-		vma = vma->vm_next;
-	}
-}
-
-void flush_tlb_page_skas(struct vm_area_struct *vma, unsigned long address)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	struct mm_struct *mm = vma->vm_mm;
-	void *flush = NULL;
-	int r, w, x, prot, err = 0;
-	struct mm_id *mm_id;
-
-	pgd = pgd_offset(mm, address);
-	if(!pgd_present(*pgd))
-		goto kill;
-
-	pud = pud_offset(pgd, address);
-	if(!pud_present(*pud))
-		goto kill;
-
-	pmd = pmd_offset(pud, address);
-	if(!pmd_present(*pmd))
-		goto kill;
-
-	pte = pte_offset_kernel(pmd, address);
-
-	r = pte_read(*pte);
-	w = pte_write(*pte);
-	x = pte_exec(*pte);
-	if (!pte_young(*pte)) {
-		r = 0;
-		w = 0;
-	} else if (!pte_dirty(*pte)) {
-		w = 0;
-	}
-
-	mm_id = &mm->context.skas.id;
-	prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
-		(x ? UM_PROT_EXEC : 0));
-	if(pte_newpage(*pte)){
-		if(pte_present(*pte)){
-			unsigned long long offset;
-			int fd;
-
-			fd = phys_mapping(pte_val(*pte) & PAGE_MASK, &offset);
-			err = map(mm_id, address, PAGE_SIZE, prot, fd, offset,
-				  1, &flush);
-		}
-		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
-	}
-	else if(pte_newprot(*pte))
-		err = protect(mm_id, address, PAGE_SIZE, prot, 1, &flush);
-
-	if(err)
-		goto kill;
-
-	*pte = pte_mkuptodate(*pte);
-
-	return;
-
-kill:
-	printk("Failed to flush page for address 0x%lx\n", address);
-	force_sig(SIGKILL, current);
-}
-
diff -puN arch/um/kernel/syscall.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/syscall.c
@@ -20,7 +20,6 @@
 #include "asm/uaccess.h"
 #include "kern_util.h"
 #include "sysdep/syscalls.h"
-#include "mode_kern.h"
 
 /*  Unlocked, I don't care if this is a bit off */
 int nsyscalls = 0;
diff -puN arch/um/kernel/time.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/time.c
@@ -18,7 +18,6 @@
 #include "asm/param.h"
 #include "asm/current.h"
 #include "kern_util.h"
-#include "mode.h"
 #include "os.h"
 
 int hz(void)
@@ -39,7 +38,7 @@ static unsigned long long prev_nsecs[NR_
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
-void timer_irq(union uml_pt_regs *regs)
+void timer_irq(struct uml_pt_regs *regs)
 {
 	unsigned long long ticks = 0;
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
@@ -175,13 +174,13 @@ int do_settimeofday(struct timespec *tv)
 	return 0;
 }
 
-void timer_handler(int sig, union uml_pt_regs *regs)
+void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	if(current_thread->cpu == 0)
 		timer_irq(regs);
 	local_irq_disable();
 	irq_enter();
-	update_process_times((regs)->skas.is_user);
+	update_process_times(regs->is_user);
 	irq_exit();
 	local_irq_enable();
 }
diff -puN arch/um/kernel/tlb.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/tlb.c
@@ -8,12 +8,12 @@
 #include "asm/pgalloc.h"
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
-#include "mode_kern.h"
 #include "as-layout.h"
 #include "tlb.h"
 #include "mem.h"
 #include "mem_user.h"
 #include "os.h"
+#include "skas.h"
 
 static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
 		    unsigned int prot, struct host_vm_op *ops, int *index,
@@ -341,6 +341,71 @@ int flush_tlb_kernel_range_common(unsign
 	return(updated);
 }
 
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	struct mm_struct *mm = vma->vm_mm;
+	void *flush = NULL;
+	int r, w, x, prot, err = 0;
+	struct mm_id *mm_id;
+
+	address &= PAGE_MASK;
+	pgd = pgd_offset(mm, address);
+	if(!pgd_present(*pgd))
+		goto kill;
+
+	pud = pud_offset(pgd, address);
+	if(!pud_present(*pud))
+		goto kill;
+
+	pmd = pmd_offset(pud, address);
+	if(!pmd_present(*pmd))
+		goto kill;
+
+	pte = pte_offset_kernel(pmd, address);
+
+	r = pte_read(*pte);
+	w = pte_write(*pte);
+	x = pte_exec(*pte);
+	if (!pte_young(*pte)) {
+		r = 0;
+		w = 0;
+	} else if (!pte_dirty(*pte)) {
+		w = 0;
+	}
+
+	mm_id = &mm->context.skas.id;
+	prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
+		(x ? UM_PROT_EXEC : 0));
+	if(pte_newpage(*pte)){
+		if(pte_present(*pte)){
+			unsigned long long offset;
+			int fd;
+
+			fd = phys_mapping(pte_val(*pte) & PAGE_MASK, &offset);
+			err = map(mm_id, address, PAGE_SIZE, prot, fd, offset,
+				  1, &flush);
+		}
+		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
+	}
+	else if(pte_newprot(*pte))
+		err = protect(mm_id, address, PAGE_SIZE, prot, 1, &flush);
+
+	if(err)
+		goto kill;
+
+	*pte = pte_mkuptodate(*pte);
+
+	return;
+
+kill:
+	printk("Failed to flush page for address 0x%lx\n", address);
+	force_sig(SIGKILL, current);
+}
+
 pgd_t *pgd_offset_proc(struct mm_struct *mm, unsigned long address)
 {
 	return(pgd_offset(mm, address));
@@ -387,21 +452,80 @@ void flush_tlb_kernel_vm(void)
 
 void __flush_tlb_one(unsigned long addr)
 {
-	__flush_tlb_one_skas(addr);
+        flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
+}
+
+static int do_ops(union mm_context *mmu, struct host_vm_op *ops, int last,
+		  int finished, void **flush)
+{
+	struct host_vm_op *op;
+        int i, ret = 0;
+
+        for(i = 0; i <= last && !ret; i++){
+		op = &ops[i];
+		switch(op->type){
+		case MMAP:
+			ret = map(&mmu->skas.id, op->u.mmap.addr,
+				  op->u.mmap.len, op->u.mmap.prot,
+				  op->u.mmap.fd, op->u.mmap.offset, finished,
+				  flush);
+			break;
+		case MUNMAP:
+			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
+				    op->u.munmap.len, finished, flush);
+			break;
+		case MPROTECT:
+			ret = protect(&mmu->skas.id, op->u.mprotect.addr,
+				      op->u.mprotect.len, op->u.mprotect.prot,
+				      finished, flush);
+			break;
+		default:
+			printk("Unknown op type %d in do_ops\n", op->type);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void fix_range(struct mm_struct *mm, unsigned long start_addr,
+		      unsigned long end_addr, int force)
+{
+        if(!proc_mm && (end_addr > CONFIG_STUB_START))
+                end_addr = CONFIG_STUB_START;
+
+        fix_range_common(mm, start_addr, end_addr, force, do_ops);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end)
 {
-	flush_tlb_range_skas(vma, start, end);
+        if(vma->vm_mm == NULL)
+                flush_tlb_kernel_range_common(start, end);
+        else fix_range(vma->vm_mm, start, end, 0);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	flush_tlb_mm_skas(mm);
+	unsigned long end;
+
+	/* Don't bother flushing if this address space is about to be
+         * destroyed.
+         */
+        if(atomic_read(&mm->mm_users) == 0)
+                return;
+
+	end = proc_mm ? task_size : CONFIG_STUB_START;
+        fix_range(mm, 0, end, 0);
 }
 
 void force_flush_all(void)
 {
-	force_flush_all_skas();
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = mm->mmap;
+
+	while(vma != NULL) {
+		fix_range(mm, vma->vm_start, vma->vm_end, 1);
+		vma = vma->vm_next;
+	}
 }
diff -puN arch/um/kernel/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/trap.c
@@ -128,7 +128,7 @@ static void bad_segv(struct faultinfo fi
 	force_sig_info(SIGSEGV, &si, current);
 }
 
-static void segv_handler(int sig, union uml_pt_regs *regs)
+static void segv_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
@@ -146,7 +146,7 @@ static void segv_handler(int sig, union 
  * give us bad data!
  */
 unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
-		   union uml_pt_regs *regs)
+		   struct uml_pt_regs *regs)
 {
 	struct siginfo si;
 	void *catcher;
@@ -214,7 +214,7 @@ unsigned long segv(struct faultinfo fi, 
 	return 0;
 }
 
-void relay_signal(int sig, union uml_pt_regs *regs)
+void relay_signal(int sig, struct uml_pt_regs *regs)
 {
 	if (arch_handle_signal(sig, regs))
 		return;
@@ -230,14 +230,14 @@ void relay_signal(int sig, union uml_pt_
 	force_sig(sig, current);
 }
 
-static void bus_handler(int sig, union uml_pt_regs *regs)
+static void bus_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current->thread.fault_catcher != NULL)
 		do_longjmp(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
 
-static void winch(int sig, union uml_pt_regs *regs)
+static void winch(int sig, struct uml_pt_regs *regs)
 {
 	do_IRQ(WINCH_IRQ, regs);
 }
diff -puN arch/um/kernel/um_arch.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/kernel/um_arch.c
@@ -35,8 +35,6 @@
 #include "initrd.h"
 #include "init.h"
 #include "os.h"
-#include "mode_kern.h"
-#include "mode.h"
 #include "skas.h"
 
 #define DEFAULT_COMMAND_LINE "root=98:0"
@@ -67,7 +65,8 @@ struct cpuinfo_um boot_cpu_data = {
 
 unsigned long thread_saved_pc(struct task_struct *task)
 {
-	return os_process_pc(thread_pid_skas(task));
+	/* FIXME: Need to look up userspace_pid by cpu */
+	return os_process_pc(userspace_pid[0]);
 }
 
 /* Changed in setup_arch, which is called in early boot */
@@ -253,6 +252,19 @@ EXPORT_SYMBOL(end_iomem);
 
 extern char __binary_start;
 
+static unsigned long set_task_sizes_skas(unsigned long *task_size_out)
+{
+	/* Round up to the nearest 4M */
+	unsigned long host_task_size = ROUND_4M((unsigned long)
+						&host_task_size);
+
+	if (!skas_needs_stub)
+		*task_size_out = host_task_size;
+	else *task_size_out = CONFIG_STUB_START & PGDIR_MASK;
+
+	return host_task_size;
+}
+
 int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
@@ -289,7 +301,7 @@ int __init linux_main(int argc, char **a
 	os_fill_handlinfo(handlinfo_kern);
 
 	brk_start = (unsigned long) sbrk(0);
-	before_mem_skas(brk_start);
+
 	/* Increase physical memory size for exec-shield users
 	so they actually get what they asked for. This should
 	add zero for non-exec shield users */
@@ -354,7 +366,7 @@ int __init linux_main(int argc, char **a
 	stack_protections((unsigned long) &init_thread_info);
 	os_flush_stdout();
 
-	return start_uml_skas();
+	return start_uml();
 }
 
 extern int uml_exitcode;
diff -puN arch/um/os-Linux/aio.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/aio.c
@@ -13,7 +13,6 @@
 #include "aio.h"
 #include "init.h"
 #include "user.h"
-#include "mode.h"
 #include "kern_constants.h"
 
 struct aio_thread_req {
diff -puN arch/um/os-Linux/main.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/main.c
@@ -18,7 +18,6 @@
 #include "irq_user.h"
 #include "user.h"
 #include "init.h"
-#include "mode.h"
 #include "uml-config.h"
 #include "os.h"
 #include "um_malloc.h"
diff -puN arch/um/os-Linux/process.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/process.c
@@ -244,9 +244,6 @@ void init_new_thread_signals(void)
 		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
 	set_handler(SIGBUS, (__sighandler_t) sig_handler, SA_ONSTACK,
 		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
-	set_handler(SIGUSR2, (__sighandler_t) sig_handler,
-		    SA_ONSTACK, SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM,
-		    -1);
 	signal(SIGHUP, SIG_IGN);
 
 	init_irq_signals(1);
diff -puN arch/um/os-Linux/registers.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/registers.c
@@ -13,26 +13,26 @@
 
 static unsigned long exec_regs[MAX_REG_NR];
 
-void init_thread_registers(union uml_pt_regs *to)
+void init_thread_registers(struct uml_pt_regs *to)
 {
-	memcpy(to->skas.regs, exec_regs, sizeof(to->skas.regs));
+	memcpy(to->regs, exec_regs, sizeof(to->regs));
 }
 
-void save_registers(int pid, union uml_pt_regs *regs)
+void save_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
-	err = ptrace(PTRACE_GETREGS, pid, 0, regs->skas.regs);
+	err = ptrace(PTRACE_GETREGS, pid, 0, regs->regs);
 	if(err < 0)
 		panic("save_registers - saving registers failed, errno = %d\n",
 		      errno);
 }
 
-void restore_registers(int pid, union uml_pt_regs *regs)
+void restore_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
-	err = ptrace(PTRACE_SETREGS, pid, 0, regs->skas.regs);
+	err = ptrace(PTRACE_SETREGS, pid, 0, regs->regs);
 	if(err < 0)
 		panic("restore_registers - saving registers failed, "
 		      "errno = %d\n", errno);
diff -puN arch/um/os-Linux/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/signal.c
@@ -16,7 +16,6 @@
 #include "sysdep/sigcontext.h"
 #include "sysdep/barrier.h"
 #include "sigcontext.h"
-#include "mode.h"
 #include "os.h"
 
 /* These are the asynchronous signals.  SIGVTALRM and SIGARLM are handled
@@ -60,14 +59,14 @@ void sig_handler(int sig, struct sigcont
 
 static void real_alarm_handler(int sig, struct sigcontext *sc)
 {
-	union uml_pt_regs regs;
+	struct uml_pt_regs regs;
 
 	if(sig == SIGALRM)
 		switch_timers(0);
 
 	if(sc != NULL)
 		copy_sc(&regs, sc);
-	regs.skas.is_user = 0;
+	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(sig, &regs);
 
diff -puN arch/um/os-Linux/skas/mem.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/skas/mem.c
@@ -294,7 +294,3 @@ int protect(struct mm_id * mm_idp, unsig
 
 	return ret;
 }
-
-void before_mem_skas(unsigned long unused)
-{
-}
diff -puN arch/um/os-Linux/skas/process.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/skas/process.c
@@ -131,19 +131,19 @@ void get_skas_faultinfo(int pid, struct 
 	}
 }
 
-static void handle_segv(int pid, union uml_pt_regs * regs)
+static void handle_segv(int pid, struct uml_pt_regs * regs)
 {
-	get_skas_faultinfo(pid, &regs->skas.faultinfo);
-	segv(regs->skas.faultinfo, 0, 1, NULL);
+	get_skas_faultinfo(pid, &regs->faultinfo);
+	segv(regs->faultinfo, 0, 1, NULL);
 }
 
 /*To use the same value of using_sysemu as the caller, ask it that value (in local_using_sysemu)*/
-static void handle_trap(int pid, union uml_pt_regs *regs, int local_using_sysemu)
+static void handle_trap(int pid, struct uml_pt_regs *regs, int local_using_sysemu)
 {
 	int err, status;
 
 	/* Mark this as a syscall */
-	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->skas.regs);
+	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->regs);
 
 	if (!local_using_sysemu)
 	{
@@ -286,7 +286,7 @@ int start_userspace(unsigned long stub_s
 	return(pid);
 }
 
-void userspace(union uml_pt_regs *regs)
+void userspace(struct uml_pt_regs *regs)
 {
 	int err, status, op, pid = userspace_pid[0];
 	/* To prevent races if using_sysemu changes under us.*/
@@ -312,7 +312,7 @@ void userspace(union uml_pt_regs *regs)
 			panic("userspace - waitpid failed, errno = %d\n",
 			      errno);
 
-		regs->skas.is_user = 1;
+		regs->is_user = 1;
 		save_registers(pid, regs);
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
@@ -321,7 +321,7 @@ void userspace(union uml_pt_regs *regs)
 		  	switch(sig){
 			case SIGSEGV:
 				if(PTRACE_FULL_FAULTINFO || !ptrace_faultinfo){
-					get_skas_faultinfo(pid, &regs->skas.faultinfo);
+					get_skas_faultinfo(pid, &regs->faultinfo);
 					(*sig_info[SIGSEGV])(SIGSEGV, regs);
 				}
 				else handle_segv(pid, regs);
@@ -351,7 +351,7 @@ void userspace(union uml_pt_regs *regs)
 
 			/* Avoid -ERESTARTSYS handling in host */
 			if(PT_SYSCALL_NR_OFFSET != PT_SYSCALL_RET_OFFSET)
-				PT_SYSCALL_NR(regs->skas.regs) = -1;
+				PT_SYSCALL_NR(regs->regs) = -1;
 		}
 	}
 }
@@ -578,16 +578,16 @@ void reboot_skas(void)
 	UML_LONGJMP(&initial_jmpbuf, INIT_JMP_REBOOT);
 }
 
-void switch_mm_skas(struct mm_id *mm_idp)
+void __switch_mm(struct mm_id *mm_idp)
 {
 	int err;
 
-	/* FIXME: need cpu pid in switch_mm_skas */
+	/* FIXME: need cpu pid in __switch_mm */
 	if(proc_mm){
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
 		if(err)
-			panic("switch_mm_skas - PTRACE_SWITCH_MM failed, "
+			panic("__switch_mm - PTRACE_SWITCH_MM failed, "
 			      "errno = %d\n", errno);
 	}
 	else userspace_pid[0] = mm_idp->u.pid;
diff -puN arch/um/os-Linux/skas/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/skas/trap.c
@@ -15,13 +15,13 @@
 #include "sysdep/ptrace_user.h"
 #include "os.h"
 
-static union uml_pt_regs ksig_regs[UM_NR_CPUS];
+static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
 
 void sig_handler_common_skas(int sig, void *sc_ptr)
 {
 	struct sigcontext *sc = sc_ptr;
-	union uml_pt_regs *r;
-	void (*handler)(int, union uml_pt_regs *);
+	struct uml_pt_regs *r;
+	void (*handler)(int, struct uml_pt_regs *);
 	int save_user, save_errno = errno;
 
 	/* This is done because to allow SIGSEGV to be delivered inside a SEGV
@@ -42,12 +42,12 @@ void sig_handler_common_skas(int sig, vo
 	}
 	else r = TASK_REGS(get_current());
 
-	save_user = r->skas.is_user;
-	r->skas.is_user = 0;
+	save_user = r->is_user;
+	r->is_user = 0;
 	if ( sig == SIGFPE || sig == SIGSEGV ||
 	     sig == SIGBUS || sig == SIGILL ||
 	     sig == SIGTRAP ) {
-		GET_FAULTINFO_FROM_SC(r->skas.faultinfo, sc);
+		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
 	}
 
 	change_sig(SIGUSR1, 1);
@@ -62,5 +62,5 @@ void sig_handler_common_skas(int sig, vo
 	handler(sig, r);
 
 	errno = save_errno;
-	r->skas.is_user = save_user;
+	r->is_user = save_user;
 }
diff -puN arch/um/os-Linux/start_up.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/start_up.c
@@ -31,7 +31,6 @@
 #include "init.h"
 #include "os.h"
 #include "uml-config.h"
-#include "mode.h"
 #include "tempfile.h"
 #include "kern_constants.h"
 #include "skas.h"
diff -puN arch/um/os-Linux/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/trap.c
@@ -7,15 +7,10 @@
 #include <signal.h>
 #include "kern_util.h"
 #include "os.h"
-#include "mode.h"
 #include "longjmp.h"
 
-void usr2_handler(int sig, union uml_pt_regs *regs)
-{
-}
-
 /* Initialized from linux_main() */
-void (*sig_info[NSIG])(int, union uml_pt_regs *);
+void (*sig_info[NSIG])(int, struct uml_pt_regs *);
 
 void os_fill_handlinfo(struct kern_handlers h)
 {
@@ -28,7 +23,6 @@ void os_fill_handlinfo(struct kern_handl
 	sig_info[SIGIO] = h.sigio_handler;
 	sig_info[SIGVTALRM] = h.timer_handler;
 	sig_info[SIGALRM] = h.timer_handler;
-	sig_info[SIGUSR2] = usr2_handler;
 }
 
 void do_longjmp(void *b, int val)
diff -puN arch/um/os-Linux/umid.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/os-Linux/umid.c
--- a/arch/um/os-Linux/umid.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/os-Linux/umid.c
@@ -11,7 +11,6 @@
 #include "init.h"
 #include "os.h"
 #include "user.h"
-#include "mode.h"
 
 #define UML_DIR "~/.uml/"
 
diff -puN arch/um/sys-i386/bugs.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/bugs.c
@@ -162,7 +162,7 @@ void arch_check_bugs(void)
 		host_has_xmm = have_it;
 }
 
-int arch_handle_signal(int sig, union uml_pt_regs *regs)
+int arch_handle_signal(int sig, struct uml_pt_regs *regs)
 {
 	unsigned char tmp[2];
 
diff -puN arch/um/sys-i386/fault.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/fault.c
--- a/arch/um/sys-i386/fault.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/fault.c
@@ -15,7 +15,7 @@ struct exception_table_entry
 const struct exception_table_entry *search_exception_tables(unsigned long add);
 
 /* Compare this to arch/i386/mm/extable.c:fixup_exception() */
-int arch_fixup(unsigned long address, union uml_pt_regs *regs)
+int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
diff -puN arch/um/sys-i386/ldt.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/ldt.c
@@ -13,7 +13,6 @@
 #include "asm/ldt.h"
 #include "asm/unistd.h"
 #include "kern.h"
-#include "mode_kern.h"
 #include "os.h"
 
 extern int modify_ldt(int func, void *ptr, unsigned long bytecount);
@@ -33,7 +32,7 @@ long write_ldt_entry(struct mm_id * mm_i
 		 * modify isn't current->active_mm.
 		 * If this is called directly by modify_ldt,
 		 *     (current->active_mm->context.skas.u == mm_idp)
-		 * will be true. So no call to switch_mm_skas(mm_idp) is done.
+		 * will be true. So no call to __switch_mm(mm_idp) is done.
 		 * If this is called in case of init_new_ldt or PTRACE_LDT,
 		 * mm_idp won't belong to current->active_mm, but child->mm.
 		 * So we need to switch child's mm into our userspace, then
@@ -43,7 +42,7 @@ long write_ldt_entry(struct mm_id * mm_i
 		 */
 		if(!current->active_mm || current->active_mm == &init_mm ||
 		   mm_idp != &current->active_mm->context.skas.id)
-			switch_mm_skas(mm_idp);
+			__switch_mm(mm_idp);
 	}
 
 	if(ptrace_ldt) {
@@ -88,7 +87,7 @@ long write_ldt_entry(struct mm_id * mm_i
 		 */
 		if(current->active_mm && current->active_mm != &init_mm &&
 		   mm_idp != &current->active_mm->context.skas.id)
-			switch_mm_skas(&current->active_mm->context.skas.id);
+			__switch_mm(&current->active_mm->context.skas.id);
 	}
 
 	return res;
diff -puN arch/um/sys-i386/ptrace.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/ptrace.c
@@ -14,16 +14,18 @@
 #include "sysdep/sigcontext.h"
 #include "sysdep/sc.h"
 
-void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
+extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
+
+void arch_switch_to(struct task_struct *from, struct task_struct *to)
 {
-	int err = arch_switch_tls_skas(from, to);
+	int err = arch_switch_tls(from, to);
 	if (!err)
 		return;
 
 	if (err != -EINVAL)
-		printk(KERN_WARNING "arch_switch_tls_skas failed, errno %d, not EINVAL\n", -err);
+		printk(KERN_WARNING "arch_switch_tls failed, errno %d, not EINVAL\n", -err);
 	else
-		printk(KERN_WARNING "arch_switch_tls_skas failed, errno = EINVAL\n");
+		printk(KERN_WARNING "arch_switch_tls failed, errno = EINVAL\n");
 }
 
 int is_syscall(unsigned long addr)
diff -puN arch/um/sys-i386/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/signal.c
@@ -14,30 +14,30 @@
 #include "registers.h"
 #include "skas.h"
 
-void copy_sc(union uml_pt_regs *regs, void *from)
+void copy_sc(struct uml_pt_regs *regs, void *from)
 {
 	struct sigcontext *sc = from;
 
-	REGS_GS(regs->skas.regs) = sc->gs;
-	REGS_FS(regs->skas.regs) = sc->fs;
-	REGS_ES(regs->skas.regs) = sc->es;
-	REGS_DS(regs->skas.regs) = sc->ds;
-	REGS_EDI(regs->skas.regs) = sc->edi;
-	REGS_ESI(regs->skas.regs) = sc->esi;
-	REGS_EBP(regs->skas.regs) = sc->ebp;
-	REGS_SP(regs->skas.regs) = sc->esp;
-	REGS_EBX(regs->skas.regs) = sc->ebx;
-	REGS_EDX(regs->skas.regs) = sc->edx;
-	REGS_ECX(regs->skas.regs) = sc->ecx;
-	REGS_EAX(regs->skas.regs) = sc->eax;
-	REGS_IP(regs->skas.regs) = sc->eip;
-	REGS_CS(regs->skas.regs) = sc->cs;
-	REGS_EFLAGS(regs->skas.regs) = sc->eflags;
-	REGS_SS(regs->skas.regs) = sc->ss;
+	REGS_GS(regs->regs) = sc->gs;
+	REGS_FS(regs->regs) = sc->fs;
+	REGS_ES(regs->regs) = sc->es;
+	REGS_DS(regs->regs) = sc->ds;
+	REGS_EDI(regs->regs) = sc->edi;
+	REGS_ESI(regs->regs) = sc->esi;
+	REGS_EBP(regs->regs) = sc->ebp;
+	REGS_SP(regs->regs) = sc->esp;
+	REGS_EBX(regs->regs) = sc->ebx;
+	REGS_EDX(regs->regs) = sc->edx;
+	REGS_ECX(regs->regs) = sc->ecx;
+	REGS_EAX(regs->regs) = sc->eax;
+	REGS_IP(regs->regs) = sc->eip;
+	REGS_CS(regs->regs) = sc->cs;
+	REGS_EFLAGS(regs->regs) = sc->eflags;
+	REGS_SS(regs->regs) = sc->ss;
 }
 
-static int copy_sc_from_user_skas(struct pt_regs *regs,
-				  struct sigcontext __user *from)
+static int copy_sc_from_user(struct pt_regs *regs,
+			     struct sigcontext __user *from)
 {
   	struct sigcontext sc;
 	unsigned long fpregs[HOST_FP_SIZE];
@@ -60,31 +60,32 @@ static int copy_sc_from_user_skas(struct
 	return 0;
 }
 
-int copy_sc_to_user_skas(struct sigcontext __user *to, struct _fpstate __user *to_fp,
-                         struct pt_regs *regs, unsigned long sp)
+static int copy_sc_to_user(struct sigcontext __user *to,
+			   struct _fpstate __user *to_fp, struct pt_regs *regs,
+			   unsigned long sp)
 {
   	struct sigcontext sc;
 	unsigned long fpregs[HOST_FP_SIZE];
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err;
 
-	sc.gs = REGS_GS(regs->regs.skas.regs);
-	sc.fs = REGS_FS(regs->regs.skas.regs);
-	sc.es = REGS_ES(regs->regs.skas.regs);
-	sc.ds = REGS_DS(regs->regs.skas.regs);
-	sc.edi = REGS_EDI(regs->regs.skas.regs);
-	sc.esi = REGS_ESI(regs->regs.skas.regs);
-	sc.ebp = REGS_EBP(regs->regs.skas.regs);
+	sc.gs = REGS_GS(regs->regs.regs);
+	sc.fs = REGS_FS(regs->regs.regs);
+	sc.es = REGS_ES(regs->regs.regs);
+	sc.ds = REGS_DS(regs->regs.regs);
+	sc.edi = REGS_EDI(regs->regs.regs);
+	sc.esi = REGS_ESI(regs->regs.regs);
+	sc.ebp = REGS_EBP(regs->regs.regs);
 	sc.esp = sp;
-	sc.ebx = REGS_EBX(regs->regs.skas.regs);
-	sc.edx = REGS_EDX(regs->regs.skas.regs);
-	sc.ecx = REGS_ECX(regs->regs.skas.regs);
-	sc.eax = REGS_EAX(regs->regs.skas.regs);
-	sc.eip = REGS_IP(regs->regs.skas.regs);
-	sc.cs = REGS_CS(regs->regs.skas.regs);
-	sc.eflags = REGS_EFLAGS(regs->regs.skas.regs);
-	sc.esp_at_signal = regs->regs.skas.regs[UESP];
-	sc.ss = regs->regs.skas.regs[SS];
+	sc.ebx = REGS_EBX(regs->regs.regs);
+	sc.edx = REGS_EDX(regs->regs.regs);
+	sc.ecx = REGS_ECX(regs->regs.regs);
+	sc.eax = REGS_EAX(regs->regs.regs);
+	sc.eip = REGS_IP(regs->regs.regs);
+	sc.cs = REGS_CS(regs->regs.regs);
+	sc.eflags = REGS_EFLAGS(regs->regs.regs);
+	sc.esp_at_signal = regs->regs.regs[UESP];
+	sc.ss = regs->regs.regs[SS];
         sc.cr2 = fi->cr2;
         sc.err = fi->error_code;
         sc.trapno = fi->trap_no;
@@ -105,17 +106,6 @@ int copy_sc_to_user_skas(struct sigconte
 	       copy_to_user(to_fp, fpregs, sizeof(fpregs));
 }
 
-static int copy_sc_from_user(struct pt_regs *to, void __user *from)
-{
-	return copy_sc_from_user_skas(to, from);
-}
-
-static int copy_sc_to_user(struct sigcontext __user *to, struct _fpstate __user *fp,
-			   struct pt_regs *from, unsigned long sp)
-{
-	return copy_sc_to_user_skas(to, fp, from, sp);
-}
-
 static int copy_ucontext_to_user(struct ucontext __user *uc, struct _fpstate __user *fp,
 				 sigset_t *set, unsigned long sp)
 {
diff -puN arch/um/sys-i386/tls.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-i386/tls.c
@@ -14,9 +14,7 @@
 #include "asm/desc.h"
 #include "kern.h"
 #include "kern_util.h"
-#include "mode_kern.h"
 #include "os.h"
-#include "mode.h"
 #include "skas.h"
 
 /*
@@ -167,7 +165,7 @@ void clear_flushed_tls(struct task_struc
  * And this will not need be used when (and if) we'll add support to the host
  * SKAS patch. */
 
-int arch_switch_tls_skas(struct task_struct *from, struct task_struct *to)
+int arch_switch_tls(struct task_struct *from, struct task_struct *to)
 {
 	if (!host_supports_tls)
 		return 0;
diff -puN arch/um/sys-x86_64/bugs.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-x86_64/bugs.c
--- a/arch/um/sys-x86_64/bugs.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-x86_64/bugs.c
@@ -14,7 +14,7 @@ void arch_check_bugs(void)
 {
 }
 
-int arch_handle_signal(int sig, union uml_pt_regs *regs)
+int arch_handle_signal(int sig, struct uml_pt_regs *regs)
 {
 	return 0;
 }
diff -puN arch/um/sys-x86_64/fault.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-x86_64/fault.c
--- a/arch/um/sys-x86_64/fault.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-x86_64/fault.c
@@ -14,7 +14,7 @@ struct exception_table_entry
 };
 
 const struct exception_table_entry *search_exception_tables(unsigned long add);
-int arch_fixup(unsigned long address, union uml_pt_regs *regs)
+int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
diff -puN arch/um/sys-x86_64/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-x86_64/signal.c
@@ -16,12 +16,12 @@
 #include "frame_kern.h"
 #include "skas.h"
 
-void copy_sc(union uml_pt_regs *regs, void *from)
+void copy_sc(struct uml_pt_regs *regs, void *from)
 {
 	struct sigcontext *sc = from;
 
 #define GETREG(regs, regno, sc, regname) \
-       (regs)->skas.regs[(regno) / sizeof(unsigned long)] = (sc)->regname
+       (regs)->regs[(regno) / sizeof(unsigned long)] = (sc)->regname
 
        GETREG(regs, R8, sc, r8);
        GETREG(regs, R9, sc, r9);
@@ -46,13 +46,13 @@ void copy_sc(union uml_pt_regs *regs, vo
 #undef GETREG
 }
 
-static int copy_sc_from_user_skas(struct pt_regs *regs,
-                                 struct sigcontext __user *from)
+static int copy_sc_from_user(struct pt_regs *regs,
+			     struct sigcontext __user *from)
 {
        int err = 0;
 
 #define GETREG(regs, regno, sc, regname) \
-       __get_user((regs)->regs.skas.regs[(regno) / sizeof(unsigned long)], \
+       __get_user((regs)->regs.regs[(regno) / sizeof(unsigned long)], \
                   &(sc)->regname)
 
        err |= GETREG(regs, R8, from, r8);
@@ -80,10 +80,9 @@ static int copy_sc_from_user_skas(struct
        return err;
 }
 
-int copy_sc_to_user_skas(struct sigcontext __user *to,
-			 struct _fpstate __user *to_fp,
-			 struct pt_regs *regs, unsigned long mask,
-			 unsigned long sp)
+static int copy_sc_to_user(struct sigcontext __user *to,
+			   struct _fpstate __user *to_fp, struct pt_regs *regs,
+			   unsigned long mask, unsigned long sp)
 {
         struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err = 0;
@@ -92,7 +91,7 @@ int copy_sc_to_user_skas(struct sigconte
 	err |= __put_user(0, &to->fs);
 
 #define PUTREG(regs, regno, sc, regname) \
-       __put_user((regs)->regs.skas.regs[(regno) / sizeof(unsigned long)], \
+       __put_user((regs)->regs.regs[(regno) / sizeof(unsigned long)], \
                   &(sc)->regname)
 
 	err |= PUTREG(regs, RDI, to, rdi);
@@ -130,22 +129,6 @@ int copy_sc_to_user_skas(struct sigconte
 	return(err);
 }
 
-static int copy_sc_from_user(struct pt_regs *to, void __user *from)
-{
-       int ret;
-
-       ret = copy_sc_from_user_skas(to, from);
-       return(ret);
-}
-
-static int copy_sc_to_user(struct sigcontext __user *to,
-			   struct _fpstate __user *fp,
-			   struct pt_regs *from, unsigned long mask,
-			   unsigned long sp)
-{
-       return copy_sc_to_user_skas(to, fp, from, mask, sp);
-}
-
 struct rt_sigframe
 {
        char __user *pretcode;
diff -puN arch/um/sys-x86_64/syscalls.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -28,8 +28,7 @@ asmlinkage long sys_uname64(struct new_u
 	return err ? -EFAULT : 0;
 }
 
-long arch_prctl_skas(struct task_struct *task, int code,
-                     unsigned long __user *addr)
+long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 {
         unsigned long *ptr = addr, tmp;
 	long ret;
@@ -91,7 +90,7 @@ long arch_prctl_skas(struct task_struct 
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
-	return arch_prctl_skas(current, code, (unsigned long __user *) addr);
+	return arch_prctl(current, code, (unsigned long __user *) addr);
 }
 
 long sys_clone(unsigned long clone_flags, unsigned long newsp,
@@ -108,10 +107,10 @@ long sys_clone(unsigned long clone_flags
 	return ret;
 }
 
-void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
+void arch_switch_to(struct task_struct *from, struct task_struct *to)
 {
         if((to->thread.arch.fs == 0) || (to->mm == NULL))
                 return;
 
-        arch_prctl_skas(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
+        arch_prctl(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
diff -puN arch/um/sys-x86_64/tls.c~uml-remove-code-made-redundant-by-choose_mode-removal arch/um/sys-x86_64/tls.c
--- a/arch/um/sys-x86_64/tls.c~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/arch/um/sys-x86_64/tls.c
@@ -11,7 +11,7 @@ int arch_copy_tls(struct task_struct *t)
 	 * (which is argument 5, child_tid, of clone) so it can be set
 	 * during context switches.
 	 */
-	t->thread.arch.fs = t->thread.regs.regs.skas.regs[R8 / sizeof(long)];
+	t->thread.arch.fs = t->thread.regs.regs.regs[R8 / sizeof(long)];
 
         return 0;
 }
diff -puN include/asm-um/mmu_context.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/mmu_context.h
@@ -29,7 +29,7 @@ static inline void activate_mm(struct mm
 	 * possible.
 	 */
 	if (old != new && (current->flags & PF_BORROWED_MM))
-		switch_mm_skas(&new->context.skas.id);
+		__switch_mm(&new->context.skas.id);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
@@ -41,7 +41,7 @@ static inline void switch_mm(struct mm_s
 		cpu_clear(cpu, prev->cpu_vm_mask);
 		cpu_set(cpu, next->cpu_vm_mask);
 		if(next != &init_mm)
-			switch_mm_skas(&next->context.skas.id);
+			__switch_mm(&next->context.skas.id);
 	}
 }
 
@@ -50,21 +50,9 @@ static inline void enter_lazy_tlb(struct
 {
 }
 
-extern int init_new_context_skas(struct task_struct *task, 
-				 struct mm_struct *mm);
+extern int init_new_context(struct task_struct *task, struct mm_struct *mm);
 
-static inline int init_new_context(struct task_struct *task, 
-				   struct mm_struct *mm)
-{
-	return(init_new_context_skas(task, mm));
-}
-
-extern void destroy_context_skas(struct mm_struct *mm);
-
-static inline void destroy_context(struct mm_struct *mm)
-{
-	destroy_context_skas(mm);
-}
+extern void destroy_context(struct mm_struct *mm);
 
 #endif
 
diff -puN include/asm-um/processor-generic.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/processor-generic.h
@@ -32,12 +32,8 @@ struct thread_struct {
 	unsigned long temp_stack;
 	void *exec_buf;
 	struct arch_thread arch;
-	union {
-		struct {
-			jmp_buf switch_buf;
-			int mm_count;
-		} skas;
-	} mode;
+	jmp_buf switch_buf;
+	int mm_count;
 	struct {
 		int op;
 		union {
@@ -75,7 +71,10 @@ typedef struct {
 
 extern struct task_struct *alloc_task_struct(void);
 
-extern void release_thread(struct task_struct *);
+static inline void release_thread(struct task_struct *task)
+{
+}
+
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 static inline void prepare_to_copy(struct task_struct *tsk)
@@ -125,8 +124,7 @@ extern struct cpuinfo_um cpu_data[];
 #endif
 
 
-#define KSTK_REG(tsk, reg) \
-	get_thread_reg(reg, &tsk->thread.mode.skas.switch_buf)
+#define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
 #define get_wchan(p) (0)
 
 #endif
diff -puN include/asm-um/ptrace-generic.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/ptrace-generic.h
--- a/include/asm-um/ptrace-generic.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/ptrace-generic.h
@@ -12,7 +12,7 @@
 #include "sysdep/ptrace.h"
 
 struct pt_regs {
-	union uml_pt_regs regs;
+	struct uml_pt_regs regs;
 };
 
 #define EMPTY_REGS { .regs = EMPTY_UML_PT_REGS }
@@ -44,7 +44,7 @@ extern int set_fpxregs(unsigned long buf
 
 extern void show_regs(struct pt_regs *regs);
 
-extern void send_sigtrap(struct task_struct *tsk, union uml_pt_regs *regs,
+extern void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
 			 int error_code);
 
 extern int arch_copy_tls(struct task_struct *new);
diff -puN include/asm-um/ptrace-i386.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/ptrace-i386.h
--- a/include/asm-um/ptrace-i386.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/ptrace-i386.h
@@ -46,21 +46,4 @@ extern int ptrace_get_thread_area(struct
 extern int ptrace_set_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
-extern int do_set_thread_area_skas(struct user_desc *info);
-extern int do_get_thread_area_skas(struct user_desc *info);
-
-extern int do_set_thread_area_tt(struct user_desc *info);
-extern int do_get_thread_area_tt(struct user_desc *info);
-
-extern int arch_switch_tls_skas(struct task_struct *from, struct task_struct *to);
-extern int arch_switch_tls_tt(struct task_struct *from, struct task_struct *to);
-
-extern void arch_switch_to_tt(struct task_struct *from, struct task_struct *to);
-extern void arch_switch_to_skas(struct task_struct *from, struct task_struct *to);
-
-extern int do_get_thread_area_skas(struct user_desc *info);
-extern int do_set_thread_area_skas(struct user_desc *info);
-
-struct task_struct;
-
 #endif
diff -puN include/asm-um/ptrace-x86_64.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/ptrace-x86_64.h
--- a/include/asm-um/ptrace-x86_64.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/ptrace-x86_64.h
@@ -76,15 +76,6 @@ static inline int ptrace_set_thread_area
         return -ENOSYS;
 }
 
-static inline void arch_switch_to_tt(struct task_struct *from,
-                                     struct task_struct *to)
-{
-}
-
-extern void arch_switch_to_skas(struct task_struct *from,
-				struct task_struct *to);
-
-extern long arch_prctl_skas(struct task_struct *task, int code,
-			    unsigned long __user *addr);
-
+extern long arch_prctl(struct task_struct *task, int code,
+		       unsigned long __user *addr);
 #endif
diff -puN include/asm-um/tlbflush.h~uml-remove-code-made-redundant-by-choose_mode-removal include/asm-um/tlbflush.h
--- a/include/asm-um/tlbflush.h~uml-remove-code-made-redundant-by-choose_mode-removal
+++ a/include/asm-um/tlbflush.h
@@ -24,18 +24,7 @@ extern void flush_tlb_all(void);
 extern void flush_tlb_mm(struct mm_struct *mm);
 extern void flush_tlb_range(struct vm_area_struct *vma, unsigned long start, 
 			    unsigned long end);
-extern void flush_tlb_page_skas(struct vm_area_struct *vma,
-				unsigned long address);
-
-static inline void flush_tlb_page(struct vm_area_struct *vma,
-				  unsigned long address)
-{
-	address &= PAGE_MASK;
-
-	flush_tlb_page_skas(vma, address);
-}
-
-extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
+extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long address);
 extern void flush_tlb_kernel_vm(void);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 extern void __flush_tlb_one(unsigned long addr);
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
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
