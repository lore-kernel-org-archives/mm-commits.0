From: akpm@linux-foundation.org
Subject: - uml-style-fixes-pass-3.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:36 -0700
Message-ID: <200710162037.l9GKbal5015305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966215AbXJPVtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: style fixes pass 3
has been removed from the -mm tree.  Its filename was
     uml-style-fixes-pass-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: style fixes pass 3
From: Jeff Dike <jdike@addtoit.com>

Formatting changes in the files which have been changed in the course
of folding foo_skas functions into their callers.  These include:
	copyright updates
	header file trimming
	style fixes
	adding severity to printks

These changes should be entirely non-functional.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/irq_user.h           |    4 
 arch/um/include/kern_util.h          |    3 
 arch/um/include/os.h                 |   16 -
 arch/um/include/skas/skas.h          |    3 
 arch/um/include/sysdep-i386/ptrace.h |   12 -
 arch/um/kernel/exec.c                |   41 +---
 arch/um/kernel/irq.c                 |   85 ++++-----
 arch/um/kernel/physmem.c             |    9 
 arch/um/kernel/process.c             |  110 +++++-------
 arch/um/kernel/ptrace.c              |  114 ++++++------
 arch/um/kernel/reboot.c              |   12 -
 arch/um/kernel/signal.c              |   58 ++----
 arch/um/kernel/skas/Makefile         |    2 
 arch/um/kernel/skas/mmu.c            |   64 +++---
 arch/um/kernel/skas/process.c        |   27 --
 arch/um/kernel/skas/syscall.c        |   17 -
 arch/um/kernel/syscall.c             |   38 +---
 arch/um/kernel/time.c                |   32 +--
 arch/um/kernel/tlb.c                 |  158 ++++++++---------
 arch/um/kernel/um_arch.c             |   74 +++-----
 arch/um/os-Linux/aio.c               |  112 ++++++------
 arch/um/os-Linux/file.c              |    4 
 arch/um/os-Linux/main.c              |   80 ++++----
 arch/um/os-Linux/process.c           |  100 +++++-----
 arch/um/os-Linux/registers.c         |    9 
 arch/um/os-Linux/signal.c            |   96 +++++-----
 arch/um/os-Linux/skas/mem.c          |   94 +++++-----
 arch/um/os-Linux/skas/process.c      |  229 ++++++++++++-------------
 arch/um/os-Linux/skas/trap.c         |   32 +--
 arch/um/os-Linux/start_up.c          |  153 ++++++++--------
 arch/um/os-Linux/trap.c              |    6 
 arch/um/os-Linux/umid.c              |  136 ++++++++------
 arch/um/sys-i386/bugs.c              |  106 ++++++-----
 arch/um/sys-i386/fault.c             |    8 
 arch/um/sys-i386/ldt.c               |  217 +++++++++++------------
 arch/um/sys-i386/ptrace.c            |  107 +++++------
 arch/um/sys-i386/signal.c            |   62 +++---
 arch/um/sys-i386/tls.c               |   74 ++++----
 arch/um/sys-x86_64/fault.c           |    7 
 arch/um/sys-x86_64/signal.c          |  145 +++++++--------
 arch/um/sys-x86_64/syscalls.c        |   68 +++----
 arch/um/sys-x86_64/tls.c             |    2 
 include/asm-um/mmu_context.h         |   13 -
 include/asm-um/processor-generic.h   |   13 -
 include/asm-um/ptrace-generic.h      |    2 
 include/asm-um/ptrace-i386.h         |   11 -
 46 files changed, 1338 insertions(+), 1427 deletions(-)

diff -puN arch/um/include/irq_user.h~uml-style-fixes-pass-3 arch/um/include/irq_user.h
--- a/arch/um/include/irq_user.h~uml-style-fixes-pass-3
+++ a/arch/um/include/irq_user.h
@@ -1,12 +1,12 @@
 /*
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __IRQ_USER_H__
 #define __IRQ_USER_H__
 
-#include "uml-config.h"
+#include "sysdep/ptrace.h"
 
 struct irq_fd {
 	struct irq_fd *next;
diff -puN arch/um/include/kern_util.h~uml-style-fixes-pass-3 arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-style-fixes-pass-3
+++ a/arch/um/include/kern_util.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -8,7 +8,6 @@
 
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
-#include "uml-config.h"
 
 typedef void (*kern_hndl)(int, struct uml_pt_regs *);
 
diff -puN arch/um/include/os.h~uml-style-fixes-pass-3 arch/um/include/os.h
--- a/arch/um/include/os.h~uml-style-fixes-pass-3
+++ a/arch/um/include/os.h
@@ -1,20 +1,18 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __OS_H__
 #define __OS_H__
 
-#include "uml-config.h"
-#include "asm/types.h"
-#include "../os/include/file.h"
-#include "sysdep/ptrace.h"
-#include "kern_util.h"
-#include "skas/mm_id.h"
+#include <stdarg.h>
 #include "irq_user.h"
+#include "kern_util.h"
+#include "longjmp.h"
+#include "mm_id.h"
 #include "sysdep/tls.h"
-#include "sysdep/archsetjmp.h"
+#include "../os/include/file.h"
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 
@@ -140,7 +138,7 @@ extern int os_set_slip(int fd);
 extern int os_set_owner(int fd, int pid);
 extern int os_mode_fd(int fd, int mode);
 
-extern int os_seek_file(int fd, __u64 offset);
+extern int os_seek_file(int fd, unsigned long long offset);
 extern int os_open_file(char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
diff -puN arch/um/include/skas/skas.h~uml-style-fixes-pass-3 arch/um/include/skas/skas.h
--- a/arch/um/include/skas/skas.h~uml-style-fixes-pass-3
+++ a/arch/um/include/skas/skas.h
@@ -1,12 +1,11 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __SKAS_H
 #define __SKAS_H
 
-#include "mm_id.h"
 #include "sysdep/ptrace.h"
 
 extern int userspace_pid[];
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-style-fixes-pass-3 arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-style-fixes-pass-3
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -97,12 +97,12 @@ struct syscall_args {
 };
 
 #define SYSCALL_ARGS(r) ((struct syscall_args) \
-                        { .args = { UPT_SYSCALL_ARG1(r), \
-                                    UPT_SYSCALL_ARG2(r), \
- 			            UPT_SYSCALL_ARG3(r), \
-                                    UPT_SYSCALL_ARG4(r), \
-		                    UPT_SYSCALL_ARG5(r), \
-                                    UPT_SYSCALL_ARG6(r) } } )
+			 { .args = { UPT_SYSCALL_ARG1(r),	\
+				     UPT_SYSCALL_ARG2(r),	\
+				     UPT_SYSCALL_ARG3(r),	\
+				     UPT_SYSCALL_ARG4(r),	\
+				     UPT_SYSCALL_ARG5(r),	\
+				     UPT_SYSCALL_ARG6(r) } } )
 
 #define UPT_REG(regs, reg) \
 	({	unsigned long val; \
diff -puN arch/um/kernel/exec.c~uml-style-fixes-pass-3 arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/exec.c
@@ -1,24 +1,19 @@
 /*
- * Copyright (C) 2000, 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/slab.h"
+#include "linux/stddef.h"
+#include "linux/fs.h"
 #include "linux/smp_lock.h"
 #include "linux/ptrace.h"
-#include "linux/fs.h"
-#include "asm/ptrace.h"
-#include "asm/pgtable.h"
-#include "asm/tlbflush.h"
+#include "linux/sched.h"
+#include "asm/current.h"
+#include "asm/processor.h"
 #include "asm/uaccess.h"
-#include "kern_util.h"
-#include "as-layout.h"
 #include "mem_user.h"
-#include "kern.h"
-#include "irq_user.h"
-#include "tlb.h"
+#include "skas.h"
 #include "os.h"
-#include "skas/skas.h"
 
 void flush_thread(void)
 {
@@ -29,8 +24,8 @@ void flush_thread(void)
 	arch_flush_thread(&current->thread.arch);
 
 	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
-	if(ret){
-		printk("flush_thread - clearing address space failed, "
+	if (ret) {
+		printk(KERN_ERR "flush_thread - clearing address space failed, "
 		       "err = %d\n", ret);
 		force_sig(SIGKILL, current);
 	}
@@ -52,7 +47,7 @@ extern void log_exec(char **argv, void *
 static long execve1(char *file, char __user * __user *argv,
 		    char __user *__user *env)
 {
-        long error;
+	long error;
 #ifdef CONFIG_TTY_LOG
 	struct tty_struct *tty;
 
@@ -62,16 +57,16 @@ static long execve1(char *file, char __u
 		log_exec(argv, tty);
 	mutex_unlock(&tty_mutex);
 #endif
-        error = do_execve(file, argv, env, &current->thread.regs);
-        if (error == 0){
+	error = do_execve(file, argv, env, &current->thread.regs);
+	if (error == 0) {
 		task_lock(current);
-                current->ptrace &= ~PT_DTRACE;
+		current->ptrace &= ~PT_DTRACE;
 #ifdef SUBARCH_EXECVE1
 		SUBARCH_EXECVE1(&current->thread.regs.regs);
 #endif
 		task_unlock(current);
-        }
-        return(error);
+	}
+	return error;
 }
 
 long um_execve(char *file, char __user *__user *argv, char __user *__user *env)
@@ -79,9 +74,9 @@ long um_execve(char *file, char __user *
 	long err;
 
 	err = execve1(file, argv, env);
-	if(!err)
+	if (!err)
 		do_longjmp(current->thread.exec_buf, 1);
-	return(err);
+	return err;
 }
 
 long sys_execve(char __user *file, char __user *__user *argv,
@@ -98,5 +93,5 @@ long sys_execve(char __user *file, char 
 	putname(filename);
  out:
 	unlock_kernel();
-	return(error);
+	return error;
 }
diff -puN arch/um/kernel/irq.c~uml-style-fixes-pass-3 arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/irq.c
@@ -1,37 +1,19 @@
 /*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  * Derived (i.e. mostly copied) from arch/i386/kernel/irq.c:
  *	Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  */
 
-#include "linux/kernel.h"
-#include "linux/module.h"
-#include "linux/smp.h"
-#include "linux/kernel_stat.h"
+#include "linux/cpumask.h"
+#include "linux/hardirq.h"
 #include "linux/interrupt.h"
-#include "linux/random.h"
-#include "linux/slab.h"
-#include "linux/file.h"
-#include "linux/proc_fs.h"
-#include "linux/init.h"
+#include "linux/kernel_stat.h"
+#include "linux/module.h"
 #include "linux/seq_file.h"
-#include "linux/profile.h"
-#include "linux/hardirq.h"
-#include "asm/irq.h"
-#include "asm/hw_irq.h"
-#include "asm/atomic.h"
-#include "asm/signal.h"
-#include "asm/system.h"
-#include "asm/errno.h"
-#include "asm/uaccess.h"
+#include "as-layout.h"
 #include "kern_util.h"
-#include "irq_user.h"
-#include "irq_kern.h"
 #include "os.h"
-#include "sigio.h"
-#include "misc_constants.h"
-#include "as-layout.h"
 
 /*
  * Generic, controller-independent functions:
@@ -71,9 +53,8 @@ int show_interrupts(struct seq_file *p, 
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
-	}
 
 	return 0;
 }
@@ -102,11 +83,13 @@ void sigio_handler(int sig, struct uml_p
 	while (1) {
 		n = os_waiting_for_events(active_fds);
 		if (n <= 0) {
-			if(n == -EINTR) continue;
+			if (n == -EINTR)
+				continue;
 			else break;
 		}
 
-		for (irq_fd = active_fds; irq_fd != NULL; irq_fd = irq_fd->next) {
+		for (irq_fd = active_fds; irq_fd != NULL;
+		     irq_fd = irq_fd->next) {
 			if (irq_fd->current_events != 0) {
 				irq_fd->current_events = 0;
 				do_IRQ(irq_fd->irq, regs);
@@ -138,8 +121,7 @@ int activate_fd(int irq, int fd, int typ
 
 	if (type == IRQ_READ)
 		events = UM_POLLIN | UM_POLLPRI;
-	else
-		events = UM_POLLOUT;
+	else events = UM_POLLOUT;
 	*new_fd = ((struct irq_fd) { .next  		= NULL,
 				     .id 		= dev_id,
 				     .fd 		= fd,
@@ -153,9 +135,10 @@ int activate_fd(int irq, int fd, int typ
 	spin_lock_irqsave(&irq_lock, flags);
 	for (irq_fd = active_fds; irq_fd != NULL; irq_fd = irq_fd->next) {
 		if ((irq_fd->fd == fd) && (irq_fd->type == type)) {
-			printk("Registering fd %d twice\n", fd);
-			printk("Irqs : %d, %d\n", irq_fd->irq, irq);
-			printk("Ids : 0x%p, 0x%p\n", irq_fd->id, dev_id);
+			printk(KERN_ERR "Registering fd %d twice\n", fd);
+			printk(KERN_ERR "Irqs : %d, %d\n", irq_fd->irq, irq);
+			printk(KERN_ERR "Ids : 0x%p, 0x%p\n", irq_fd->id,
+			       dev_id);
 			goto out_unlock;
 		}
 	}
@@ -171,7 +154,8 @@ int activate_fd(int irq, int fd, int typ
 		if (n == 0)
 			break;
 
-		/* n > 0
+		/*
+		 * n > 0
 		 * It means we couldn't put new pollfd to current pollfds
 		 * and tmp_fds is NULL or too small for new pollfds array.
 		 * Needed size is equal to n as minimum.
@@ -197,7 +181,8 @@ int activate_fd(int irq, int fd, int typ
 
 	spin_unlock_irqrestore(&irq_lock, flags);
 
-	/* This calls activate_fd, so it has to be outside the critical
+	/*
+	 * This calls activate_fd, so it has to be outside the critical
 	 * section.
 	 */
 	maybe_sigio_broken(fd, (type == IRQ_READ));
@@ -264,13 +249,14 @@ static struct irq_fd *find_irq_by_fd(int
 		i++;
 	}
 	if (irq == NULL) {
-		printk("find_irq_by_fd doesn't have descriptor %d\n", fd);
+		printk(KERN_ERR "find_irq_by_fd doesn't have descriptor %d\n",
+		       fd);
 		goto out;
 	}
 	fdi = os_get_pollfd(i);
 	if ((fdi != -1) && (fdi != fd)) {
-		printk("find_irq_by_fd - mismatch between active_fds and "
-		       "pollfds, fd %d vs %d, need %d\n", irq->fd,
+		printk(KERN_ERR "find_irq_by_fd - mismatch between active_fds "
+		       "and pollfds, fd %d vs %d, need %d\n", irq->fd,
 		       fdi, fd);
 		irq = NULL;
 		goto out;
@@ -306,7 +292,7 @@ void deactivate_fd(int fd, int irqnum)
 
 	spin_lock_irqsave(&irq_lock, flags);
 	irq = find_irq_by_fd(fd, irqnum, &i);
-	if(irq == NULL){
+	if (irq == NULL) {
 		spin_unlock_irqrestore(&irq_lock, flags);
 		return;
 	}
@@ -372,8 +358,10 @@ int um_request_irq(unsigned int irq, int
 EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
-/* hw_interrupt_type must define (startup || enable) &&
- * (shutdown || disable) && end */
+/*
+ * hw_interrupt_type must define (startup || enable) &&
+ * (shutdown || disable) && end
+ */
 static void dummy(unsigned int irq)
 {
 }
@@ -422,7 +410,8 @@ int init_aio_irq(int irq, char *name, ir
 
 	err = os_pipe(fds, 1, 1);
 	if (err) {
-		printk("init_aio_irq - os_pipe failed, err = %d\n", -err);
+		printk(KERN_ERR "init_aio_irq - os_pipe failed, err = %d\n",
+		       -err);
 		goto out;
 	}
 
@@ -430,7 +419,8 @@ int init_aio_irq(int irq, char *name, ir
 			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, name,
 			     (void *) (long) fds[0]);
 	if (err) {
-		printk("init_aio_irq - : um_request_irq failed, err = %d\n",
+		printk(KERN_ERR "init_aio_irq - : um_request_irq failed, "
+		       "err = %d\n",
 		       err);
 		goto out_close;
 	}
@@ -501,8 +491,9 @@ unsigned long to_irq_stack(unsigned long
 	int nested;
 
 	mask = xchg(&pending_mask, *mask_out);
-	if(mask != 0){
-		/* If any interrupts come in at this point, we want to
+	if (mask != 0) {
+		/*
+		 * If any interrupts come in at this point, we want to
 		 * make sure that their bits aren't lost by our
 		 * putting our bit in.  So, this loop accumulates bits
 		 * until xchg returns the same value that we put in.
@@ -514,13 +505,13 @@ unsigned long to_irq_stack(unsigned long
 		do {
 			old |= mask;
 			mask = xchg(&pending_mask, old);
-		} while(mask != old);
+		} while (mask != old);
 		return 1;
 	}
 
 	ti = current_thread_info();
 	nested = (ti->real_thread != NULL);
-	if(!nested){
+	if (!nested) {
 		struct task_struct *task;
 		struct thread_info *tti;
 
diff -puN arch/um/kernel/physmem.c~uml-style-fixes-pass-3 arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/physmem.c
@@ -75,7 +75,7 @@ void map_memory(unsigned long virt, unsi
 	err = os_map_memory((void *) virt, fd, offset, len, r, w, x);
 	if (err) {
 		if (err == -ENOMEM)
-			printk("try increasing the host's "
+			printk(KERN_ERR "try increasing the host's "
 			       "/proc/sys/vm/max_map_count to <physical "
 			       "memory size>/4096\n");
 		panic("map_memory(0x%lx, %d, 0x%llx, %ld, %d, %d, %d) failed, "
@@ -103,7 +103,8 @@ void __init setup_physmem(unsigned long 
 		exit(1);
 	}
 
-	/* Special kludge - This page will be mapped in to userspace processes
+	/*
+	 * Special kludge - This page will be mapped in to userspace processes
 	 * from physmem_fd, so it needs to be written out there.
 	 */
 	os_seek_file(physmem_fd, __pa(&__syscall_stub_start));
@@ -202,8 +203,8 @@ int setup_iomem(void)
 		err = os_map_memory((void *) iomem_start, region->fd, 0,
 				    region->size, 1, 1, 0);
 		if (err)
-			printk("Mapping iomem region for driver '%s' failed, "
-			       "errno = %d\n", region->driver, -err);
+			printk(KERN_ERR "Mapping iomem region for driver '%s' "
+			       "failed, errno = %d\n", region->driver, -err);
 		else {
 			region->virt = iomem_start;
 			region->phys = __pa(region->virt);
diff -puN arch/um/kernel/process.c~uml-style-fixes-pass-3 arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/process.c
@@ -1,51 +1,29 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright 2003 PathScale, Inc.
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/sched.h"
-#include "linux/interrupt.h"
-#include "linux/string.h"
+#include "linux/stddef.h"
+#include "linux/err.h"
+#include "linux/hardirq.h"
 #include "linux/mm.h"
-#include "linux/slab.h"
-#include "linux/utsname.h"
-#include "linux/fs.h"
-#include "linux/utime.h"
-#include "linux/smp_lock.h"
-#include "linux/module.h"
-#include "linux/init.h"
-#include "linux/capability.h"
-#include "linux/vmalloc.h"
-#include "linux/spinlock.h"
+#include "linux/personality.h"
 #include "linux/proc_fs.h"
 #include "linux/ptrace.h"
 #include "linux/random.h"
-#include "linux/personality.h"
-#include "asm/unistd.h"
-#include "asm/mman.h"
-#include "asm/segment.h"
-#include "asm/stat.h"
+#include "linux/sched.h"
+#include "linux/threads.h"
 #include "asm/pgtable.h"
-#include "asm/processor.h"
-#include "asm/tlbflush.h"
 #include "asm/uaccess.h"
-#include "asm/user.h"
-#include "kern_util.h"
 #include "as-layout.h"
-#include "kern.h"
-#include "signal_kern.h"
-#include "init.h"
-#include "irq_user.h"
-#include "mem_user.h"
-#include "tlb.h"
-#include "frame_kern.h"
-#include "sigcontext.h"
+#include "kern_util.h"
 #include "os.h"
 #include "skas.h"
+#include "tlb.h"
 
-/* This is a per-cpu array.  A processor only modifies its entry and it only
+/*
+ * This is a per-cpu array.  A processor only modifies its entry and it only
  * cares about its entry, so it's OK if another processor is modifying its
  * entry.
  */
@@ -54,15 +32,15 @@ struct cpu_task cpu_tasks[NR_CPUS] = { [
 static inline int external_pid(struct task_struct *task)
 {
 	/* FIXME: Need to look up userspace_pid by cpu */
-	return(userspace_pid[0]);
+	return userspace_pid[0];
 }
 
 int pid_to_processor_id(int pid)
 {
 	int i;
 
-	for(i = 0; i < ncpus; i++){
-		if(cpu_tasks[i].pid == pid)
+	for(i = 0; i < ncpus; i++) {
+		if (cpu_tasks[i].pid == pid)
 			return i;
 	}
 	return -1;
@@ -118,7 +96,7 @@ void *_switch_to(void *prev, void *next,
 		current->thread.saved_task = NULL;
 
 		/* XXX need to check runqueues[cpu].idle */
-		if(current->pid == 0)
+		if (current->pid == 0)
 			switch_timers(0);
 
 		switch_threads(&from->thread.switch_buf,
@@ -126,10 +104,10 @@ void *_switch_to(void *prev, void *next,
 
 		arch_switch_to(current->thread.prev_sched, current);
 
-		if(current->pid == 0)
+		if (current->pid == 0)
 			switch_timers(1);
 
-		if(current->thread.saved_task)
+		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
 		prev= current;
@@ -141,9 +119,9 @@ void *_switch_to(void *prev, void *next,
 
 void interrupt_end(void)
 {
-	if(need_resched())
+	if (need_resched())
 		schedule();
-	if(test_tsk_thread_flag(current, TIF_SIGPENDING))
+	if (test_tsk_thread_flag(current, TIF_SIGPENDING))
 		do_signal();
 }
 
@@ -158,7 +136,8 @@ void *get_current(void)
 
 extern void schedule_tail(struct task_struct *prev);
 
-/* This is called magically, by its address being stuffed in a jmp_buf
+/*
+ * This is called magically, by its address being stuffed in a jmp_buf
  * and being longjmp-d to.
  */
 void new_thread_handler(void)
@@ -166,18 +145,19 @@ void new_thread_handler(void)
 	int (*fn)(void *), n;
 	void *arg;
 
-	if(current->thread.prev_sched != NULL)
+	if (current->thread.prev_sched != NULL)
 		schedule_tail(current->thread.prev_sched);
 	current->thread.prev_sched = NULL;
 
 	fn = current->thread.request.u.thread.proc;
 	arg = current->thread.request.u.thread.arg;
 
-	/* The return value is 1 if the kernel thread execs a process,
+	/*
+	 * The return value is 1 if the kernel thread execs a process,
 	 * 0 if it just exits
 	 */
 	n = run_kernel_thread(fn, arg, &current->thread.exec_buf);
-	if(n == 1){
+	if (n == 1) {
 		/* Handle any immediate reschedules or signals */
 		interrupt_end();
 		userspace(&current->thread.regs.regs);
@@ -189,14 +169,16 @@ void new_thread_handler(void)
 void fork_handler(void)
 {
 	force_flush_all();
-	if(current->thread.prev_sched == NULL)
+	if (current->thread.prev_sched == NULL)
 		panic("blech");
 
 	schedule_tail(current->thread.prev_sched);
 
-	/* XXX: if interrupt_end() calls schedule, this call to
+	/*
+	 * XXX: if interrupt_end() calls schedule, this call to
 	 * arch_switch_to isn't needed. We could want to apply this to
-	 * improve performance. -bb */
+	 * improve performance. -bb
+	 */
 	arch_switch_to(current->thread.prev_sched, current);
 
 	current->thread.prev_sched = NULL;
@@ -216,11 +198,11 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread = (struct thread_struct) INIT_THREAD;
 
-	if(current->thread.forking){
+	if (current->thread.forking) {
 	  	memcpy(&p->thread.regs.regs, &regs->regs,
 		       sizeof(p->thread.regs.regs));
 		REGS_SET_SYSCALL_RETURN(p->thread.regs.regs.regs, 0);
-		if(sp != 0)
+		if (sp != 0)
 			REGS_SP(p->thread.regs.regs.regs) = sp;
 
 		handler = fork_handler;
@@ -259,14 +241,14 @@ void initial_thread_cb(void (*proc)(void
 
 void default_idle(void)
 {
-	while(1){
+	while(1) {
 		/* endless idle loop with no priority at all */
 
 		/*
 		 * although we are an idle CPU, we do not want to
 		 * get into the scheduler unnecessarily.
 		 */
-		if(need_resched())
+		if (need_resched())
 			schedule();
 
 		idle_sleep(10);
@@ -288,26 +270,26 @@ void *um_virt_to_phys(struct task_struct
 	pte_t *pte;
 	pte_t ptent;
 
-	if(task->mm == NULL)
+	if (task->mm == NULL)
 		return ERR_PTR(-EINVAL);
 	pgd = pgd_offset(task->mm, addr);
-	if(!pgd_present(*pgd))
+	if (!pgd_present(*pgd))
 		return ERR_PTR(-EINVAL);
 
 	pud = pud_offset(pgd, addr);
-	if(!pud_present(*pud))
+	if (!pud_present(*pud))
 		return ERR_PTR(-EINVAL);
 
 	pmd = pmd_offset(pud, addr);
-	if(!pmd_present(*pmd))
+	if (!pmd_present(*pmd))
 		return ERR_PTR(-EINVAL);
 
 	pte = pte_offset_kernel(pmd, addr);
 	ptent = *pte;
-	if(!pte_present(ptent))
+	if (!pte_present(ptent))
 		return ERR_PTR(-EINVAL);
 
-	if(pte_out != NULL)
+	if (pte_out != NULL)
 		*pte_out = ptent;
 	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
 }
@@ -380,7 +362,7 @@ int smp_sigio_handler(void)
 #ifdef CONFIG_SMP
 	int cpu = current_thread->cpu;
 	IPI_handler(cpu);
-	if(cpu != 0)
+	if (cpu != 0)
 		return 1;
 #endif
 	return 0;
@@ -408,7 +390,8 @@ int get_using_sysemu(void)
 
 static int proc_read_sysemu(char *buf, char **start, off_t offset, int size,int *eof, void *data)
 {
-	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size) /*No overflow*/
+	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size)
+		/* No overflow */
 		*eof = 1;
 
 	return strlen(buf);
@@ -423,7 +406,8 @@ static int proc_write_sysemu(struct file
 
 	if (tmp[0] >= '0' && tmp[0] <= '2')
 		set_using_sysemu(tmp[0] - '0');
-	return count; /*We use the first char, but pretend to write everything*/
+	/* We use the first char, but pretend to write everything */
+	return count;
 }
 
 int __init make_proc_sysemu(void)
@@ -453,10 +437,10 @@ int singlestepping(void * t)
 	struct task_struct *task = t ? t : current;
 
 	if ( ! (task->ptrace & PT_DTRACE) )
-		return(0);
+		return 0;
 
 	if (task->thread.singlestep_syscall)
-		return(1);
+		return 1;
 
 	return 2;
 }
diff -puN arch/um/kernel/ptrace.c~uml-style-fixes-pass-3 arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/ptrace.c
@@ -1,35 +1,27 @@
-/* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/mm.h"
-#include "linux/errno.h"
-#include "linux/smp_lock.h"
-#include "linux/security.h"
-#include "linux/ptrace.h"
 #include "linux/audit.h"
+#include "linux/ptrace.h"
+#include "linux/sched.h"
+#include "asm/uaccess.h"
 #ifdef CONFIG_PROC_MM
-#include "linux/proc_mm.h"
+#include "proc_mm.h"
 #endif
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-#include "kern_util.h"
 #include "skas_ptrace.h"
-#include "sysdep/ptrace.h"
-#include "os.h"
 
 static inline void set_singlestepping(struct task_struct *child, int on)
 {
-        if (on)
-                child->ptrace |= PT_DTRACE;
-        else
-                child->ptrace &= ~PT_DTRACE;
-        child->thread.singlestep_syscall = 0;
+	if (on)
+		child->ptrace |= PT_DTRACE;
+	else
+		child->ptrace &= ~PT_DTRACE;
+	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
-        SUBARCH_SET_SINGLESTEPPING(child, on);
+	SUBARCH_SET_SINGLESTEPPING(child, on);
 #endif
 }
 
@@ -37,8 +29,8 @@ static inline void set_singlestepping(st
  * Called by kernel/ptrace.c when detaching..
  */
 void ptrace_disable(struct task_struct *child)
-{ 
-        set_singlestepping(child,0);
+{
+	set_singlestepping(child,0);
 }
 
 extern int peek_user(struct task_struct * child, long addr, long data);
@@ -50,40 +42,40 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long __user *p = (void __user *)(unsigned long)data;
 
 	switch (request) {
-		/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
+	/* read word at location addr. */
+	case PTRACE_PEEKTEXT:
 	case PTRACE_PEEKDATA:
 		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
 
 	/* read the word at location addr in the USER area. */
-        case PTRACE_PEEKUSR:
-                ret = peek_user(child, addr, data);
-                break;
+	case PTRACE_PEEKUSR:
+		ret = peek_user(child, addr, data);
+		break;
 
-	/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
+	/* write the word at location addr. */
+	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
 		ret = generic_ptrace_pokedata(child, addr, data);
 		break;
 
-	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-                ret = poke_user(child, addr, data);
-                break;
+	/* write the word at location addr in the USER area */
+	case PTRACE_POKEUSR:
+		ret = poke_user(child, addr, data);
+		break;
 
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: { /* restart after signal. */
+	/* continue and stop at next (return from) syscall */
+	case PTRACE_SYSCALL:
+	/* restart after signal. */
+	case PTRACE_CONT: {
 		ret = -EIO;
 		if (!valid_signal(data))
 			break;
 
-                set_singlestepping(child, 0);
-		if (request == PTRACE_SYSCALL) {
+		set_singlestepping(child, 0);
+		if (request == PTRACE_SYSCALL)
 			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
+		else clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 		child->exit_code = data;
 		wake_up_process(child);
 		ret = 0;
@@ -91,8 +83,8 @@ long arch_ptrace(struct task_struct *chi
 	}
 
 /*
- * make the child exit.  Best I can do is send it a sigkill. 
- * perhaps it should be put in the status that it wants to 
+ * make the child exit.  Best I can do is send it a sigkill.
+ * perhaps it should be put in the status that it wants to
  * exit.
  */
 	case PTRACE_KILL: {
@@ -100,7 +92,7 @@ long arch_ptrace(struct task_struct *chi
 		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
 			break;
 
-                set_singlestepping(child, 0);
+		set_singlestepping(child, 0);
 		child->exit_code = SIGKILL;
 		wake_up_process(child);
 		break;
@@ -111,7 +103,7 @@ long arch_ptrace(struct task_struct *chi
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-                set_singlestepping(child, 1);
+		set_singlestepping(child, 1);
 		child->exit_code = data;
 		/* give it a chance to run. */
 		wake_up_process(child);
@@ -180,13 +172,14 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_FAULTINFO: {
-		/* Take the info from thread->arch->faultinfo,
+		/*
+		 * Take the info from thread->arch->faultinfo,
 		 * but transfer max. sizeof(struct ptrace_faultinfo).
 		 * On i386, ptrace_faultinfo is smaller!
 		 */
 		ret = copy_to_user(p, &child->thread.arch.faultinfo,
 				   sizeof(struct ptrace_faultinfo));
-		if(ret)
+		if (ret)
 			break;
 		break;
 	}
@@ -195,12 +188,13 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_LDT: {
 		struct ptrace_ldt ldt;
 
-		if(copy_from_user(&ldt, p, sizeof(ldt))){
+		if (copy_from_user(&ldt, p, sizeof(ldt))) {
 			ret = -EIO;
 			break;
 		}
 
-		/* This one is confusing, so just punt and return -EIO for 
+		/*
+		 * This one is confusing, so just punt and return -EIO for
 		 * now
 		 */
 		ret = -EIO;
@@ -212,7 +206,7 @@ long arch_ptrace(struct task_struct *chi
 		struct mm_struct *old = child->mm;
 		struct mm_struct *new = proc_mm_get_mm(data);
 
-		if(IS_ERR(new)){
+		if (IS_ERR(new)) {
 			ret = PTR_ERR(new);
 			break;
 		}
@@ -226,10 +220,10 @@ long arch_ptrace(struct task_struct *chi
 	}
 #endif
 #ifdef PTRACE_ARCH_PRCTL
-        case PTRACE_ARCH_PRCTL:
-                /* XXX Calls ptrace on the host - needs some SMP thinking */
-                ret = arch_prctl(child, data, (void *) addr);
-                break;
+	case PTRACE_ARCH_PRCTL:
+		/* XXX Calls ptrace on the host - needs some SMP thinking */
+		ret = arch_prctl(child, data, (void *) addr);
+		break;
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
@@ -255,7 +249,8 @@ void send_sigtrap(struct task_struct *ts
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-/* XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
+/*
+ * XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
  * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
  */
 void syscall_trace(struct uml_pt_regs *regs, int entryexit)
@@ -272,7 +267,7 @@ void syscall_trace(struct uml_pt_regs *r
 					    UPT_SYSCALL_ARG3(regs),
 					    UPT_SYSCALL_ARG4(regs));
 		else audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(regs)),
-                                        UPT_SYSCALL_RET(regs));
+					UPT_SYSCALL_RET(regs));
 	}
 
 	/* Fake a debug trap */
@@ -285,15 +280,18 @@ void syscall_trace(struct uml_pt_regs *r
 	if (!(current->ptrace & PT_PTRACED))
 		return;
 
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
+	/*
+	 * the 0x80 provides a way for the tracing parent to distinguish
+	 * between a syscall stop and SIGTRAP delivery
+	 */
 	tracesysgood = (current->ptrace & PT_TRACESYSGOOD);
 	ptrace_notify(SIGTRAP | (tracesysgood ? 0x80 : 0));
 
 	if (entryexit) /* force do_signal() --> is_syscall() */
 		set_thread_flag(TIF_SIGPENDING);
 
-	/* this isn't the same as continuing with a signal, but it will do
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
 	 * for normal use.  strace only continues with a signal if the
 	 * stopping signal is not SIGTRAP.  -brl
 	 */
diff -puN arch/um/kernel/reboot.c~uml-style-fixes-pass-3 arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/reboot.c
@@ -1,13 +1,9 @@
 /* 
- * Copyright (C) 2000, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/module.h"
 #include "linux/sched.h"
-#include "asm/smp.h"
-#include "kern_util.h"
-#include "kern.h"
 #include "os.h"
 #include "skas.h"
 
@@ -37,20 +33,20 @@ static void kill_off_processes(void)
 
 void uml_cleanup(void)
 {
-        kmalloc_ok = 0;
+	kmalloc_ok = 0;
 	do_uml_exitcalls();
 	kill_off_processes();
 }
 
 void machine_restart(char * __unused)
 {
-        uml_cleanup();
+	uml_cleanup();
 	reboot_skas();
 }
 
 void machine_power_off(void)
 {
-        uml_cleanup();
+	uml_cleanup();
 	halt_skas();
 }
 
diff -puN arch/um/kernel/signal.c~uml-style-fixes-pass-3 arch/um/kernel/signal.c
--- a/arch/um/kernel/signal.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/signal.c
@@ -1,27 +1,16 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/sys.h"
-#include "linux/sched.h"
-#include "linux/wait.h"
-#include "linux/kernel.h"
-#include "linux/smp_lock.h"
 #include "linux/module.h"
-#include "linux/slab.h"
-#include "linux/tty.h"
-#include "linux/binfmts.h"
 #include "linux/ptrace.h"
+#include "linux/sched.h"
+#include "asm/siginfo.h"
 #include "asm/signal.h"
-#include "asm/uaccess.h"
 #include "asm/unistd.h"
-#include "asm/ucontext.h"
-#include "kern_util.h"
-#include "signal_kern.h"
-#include "kern.h"
 #include "frame_kern.h"
+#include "kern_util.h"
 #include "sigcontext.h"
 
 EXPORT_SYMBOL(block_signals);
@@ -45,9 +34,9 @@ static int handle_signal(struct pt_regs 
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
 	/* Did we come from a system call? */
-	if(PT_REGS_SYSCALL_NR(regs) >= 0){
+	if (PT_REGS_SYSCALL_NR(regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch(PT_REGS_SYSCALL_RET(regs)){
+		switch(PT_REGS_SYSCALL_RET(regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			PT_REGS_SYSCALL_RET(regs) = -EINTR;
@@ -67,17 +56,17 @@ static int handle_signal(struct pt_regs 
 	}
 
 	sp = PT_REGS_SP(regs);
-	if((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) == 0))
+	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) == 0))
 		sp = current->sas_ss_sp + current->sas_ss_size;
 
 #ifdef CONFIG_ARCH_HAS_SC_SIGNALS
-	if(!(ka->sa.sa_flags & SA_SIGINFO))
+	if (!(ka->sa.sa_flags & SA_SIGINFO))
 		err = setup_signal_stack_sc(sp, signr, ka, regs, oldset);
 	else
 #endif
 		err = setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
 
-	if(err){
+	if (err) {
 		spin_lock_irq(&current->sighand->siglock);
 		current->blocked = *oldset;
 		recalc_sigpending();
@@ -87,7 +76,7 @@ static int handle_signal(struct pt_regs 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked,
 			  &ka->sa.sa_mask);
-		 if(!(ka->sa.sa_flags & SA_NODEFER))
+		if (!(ka->sa.sa_flags & SA_NODEFER))
 			sigaddset(&current->blocked, signr);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
@@ -108,14 +97,16 @@ static int kern_do_signal(struct pt_regs
 	else
 		oldset = &current->blocked;
 
-	while((sig = get_signal_to_deliver(&info, &ka_copy, regs, NULL)) > 0){
+	while ((sig = get_signal_to_deliver(&info, &ka_copy, regs, NULL)) > 0) {
 		handled_sig = 1;
 		/* Whee!  Actually deliver the signal.  */
-		if(!handle_signal(regs, sig, &ka_copy, &info, oldset)){
-			/* a signal was successfully delivered; the saved
+		if (!handle_signal(regs, sig, &ka_copy, &info, oldset)) {
+			/*
+			 * a signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
 			 * and will be restored by sigreturn, so we can simply
-			 * clear the TIF_RESTORE_SIGMASK flag */
+			 * clear the TIF_RESTORE_SIGMASK flag
+			 */
 			if (test_thread_flag(TIF_RESTORE_SIGMASK))
 				clear_thread_flag(TIF_RESTORE_SIGMASK);
 			break;
@@ -123,9 +114,9 @@ static int kern_do_signal(struct pt_regs
 	}
 
 	/* Did we come from a system call? */
-	if(!handled_sig && (PT_REGS_SYSCALL_NR(regs) >= 0)){
+	if (!handled_sig && (PT_REGS_SYSCALL_NR(regs) >= 0)) {
 		/* Restart the system call - no handlers present */
-		switch(PT_REGS_SYSCALL_RET(regs)){
+		switch(PT_REGS_SYSCALL_RET(regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
@@ -136,22 +127,25 @@ static int kern_do_signal(struct pt_regs
 			PT_REGS_ORIG_SYSCALL(regs) = __NR_restart_syscall;
 			PT_REGS_RESTART_SYSCALL(regs);
 			break;
- 		}
+		}
 	}
 
-	/* This closes a way to execute a system call on the host.  If
+	/*
+	 * This closes a way to execute a system call on the host.  If
 	 * you set a breakpoint on a system call instruction and singlestep
 	 * from it, the tracing thread used to PTRACE_SINGLESTEP the process
 	 * rather than PTRACE_SYSCALL it, allowing the system call to execute
 	 * on the host.  The tracing thread will check this flag and
 	 * PTRACE_SYSCALL if necessary.
 	 */
-	if(current->ptrace & PT_DTRACE)
+	if (current->ptrace & PT_DTRACE)
 		current->thread.singlestep_syscall =
 			is_syscall(PT_REGS_IP(&current->thread.regs));
 
-	/* if there's no signal to deliver, we just put the saved sigmask
-	 * back */
+	/*
+	 * if there's no signal to deliver, we just put the saved sigmask
+	 * back
+	 */
 	if (!handled_sig && test_thread_flag(TIF_RESTORE_SIGMASK)) {
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
diff -puN arch/um/kernel/skas/Makefile~uml-style-fixes-pass-3 arch/um/kernel/skas/Makefile
--- a/arch/um/kernel/skas/Makefile~uml-style-fixes-pass-3
+++ a/arch/um/kernel/skas/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2002 - 2004 Jeff Dike (jdike@addtoit.com)
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
 # Licensed under the GPL
 #
 
diff -puN arch/um/kernel/skas/mmu.c~uml-style-fixes-pass-3 arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/skas/mmu.c
@@ -1,20 +1,12 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/list.h"
-#include "linux/spinlock.h"
-#include "linux/slab.h"
-#include "linux/errno.h"
 #include "linux/mm.h"
-#include "asm/current.h"
-#include "asm/segment.h"
-#include "asm/mmu.h"
+#include "linux/sched.h"
 #include "asm/pgalloc.h"
 #include "asm/pgtable.h"
-#include "asm/ldt.h"
 #include "os.h"
 #include "skas.h"
 
@@ -41,10 +33,11 @@ static int init_stub_pte(struct mm_struc
 	if (!pte)
 		goto out_pte;
 
-	/* There's an interaction between the skas0 stub pages, stack
+	/*
+	 * There's an interaction between the skas0 stub pages, stack
 	 * randomization, and the BUG at the end of exit_mmap.  exit_mmap
-         * checks that the number of page tables freed is the same as had
-         * been allocated.  If the stack is on the last page table page,
+	 * checks that the number of page tables freed is the same as had
+	 * been allocated.  If the stack is on the last page table page,
 	 * then the stack pte page will be freed, and if not, it won't.  To
 	 * avoid having to know where the stack is, or if the process mapped
 	 * something at the top of its address space for some other reason,
@@ -54,36 +47,37 @@ static int init_stub_pte(struct mm_struc
 	 * destroy_context_skas.
 	 */
 
-        mm->context.skas.last_page_table = pmd_page_vaddr(*pmd);
+	mm->context.skas.last_page_table = pmd_page_vaddr(*pmd);
 #ifdef CONFIG_3_LEVEL_PGTABLES
-        mm->context.skas.last_pmd = (unsigned long) __va(pud_val(*pud));
+	mm->context.skas.last_pmd = (unsigned long) __va(pud_val(*pud));
 #endif
 
 	*pte = mk_pte(virt_to_page(kernel), __pgprot(_PAGE_PRESENT));
 	*pte = pte_mkread(*pte);
-	return(0);
+	return 0;
 
  out_pmd:
 	pud_free(pud);
  out_pte:
 	pmd_free(pmd);
  out:
-	return(-ENOMEM);
+	return -ENOMEM;
 }
 
 int init_new_context(struct task_struct *task, struct mm_struct *mm)
 {
- 	struct mmu_context_skas *from_mm = NULL;
+	struct mmu_context_skas *from_mm = NULL;
 	struct mmu_context_skas *to_mm = &mm->context.skas;
 	unsigned long stack = 0;
 	int ret = -ENOMEM;
 
-	if(skas_needs_stub){
+	if (skas_needs_stub) {
 		stack = get_zeroed_page(GFP_KERNEL);
-		if(stack == 0)
+		if (stack == 0)
 			goto out;
 
-		/* This zeros the entry that pgd_alloc didn't, needed since
+		/*
+		 * This zeros the entry that pgd_alloc didn't, needed since
 		 * we are about to reinitialize it, and want mm.nr_ptes to
 		 * be accurate.
 		 */
@@ -91,39 +85,39 @@ int init_new_context(struct task_struct 
 
 		ret = init_stub_pte(mm, CONFIG_STUB_CODE,
 				    (unsigned long) &__syscall_stub_start);
-		if(ret)
+		if (ret)
 			goto out_free;
 
 		ret = init_stub_pte(mm, CONFIG_STUB_DATA, stack);
-		if(ret)
+		if (ret)
 			goto out_free;
 
 		mm->nr_ptes--;
 	}
 
 	to_mm->id.stack = stack;
-	if(current->mm != NULL && current->mm != &init_mm)
+	if (current->mm != NULL && current->mm != &init_mm)
 		from_mm = &current->mm->context.skas;
 
-	if(proc_mm){
+	if (proc_mm) {
 		ret = new_mm(stack);
-		if(ret < 0){
-			printk("init_new_context_skas - new_mm failed, "
-			       "errno = %d\n", ret);
+		if (ret < 0) {
+			printk(KERN_ERR "init_new_context_skas - "
+			       "new_mm failed, errno = %d\n", ret);
 			goto out_free;
 		}
 		to_mm->id.u.mm_fd = ret;
 	}
 	else {
-		if(from_mm)
+		if (from_mm)
 			to_mm->id.u.pid = copy_context_skas0(stack,
 							     from_mm->id.u.pid);
 		else to_mm->id.u.pid = start_userspace(stack);
 	}
 
 	ret = init_new_ldt(to_mm, from_mm);
-	if(ret < 0){
-		printk("init_new_context_skas - init_ldt"
+	if (ret < 0) {
+		printk(KERN_ERR "init_new_context_skas - init_ldt"
 		       " failed, errno = %d\n", ret);
 		goto out_free;
 	}
@@ -131,7 +125,7 @@ int init_new_context(struct task_struct 
 	return 0;
 
  out_free:
-	if(to_mm->id.stack != 0)
+	if (to_mm->id.stack != 0)
 		free_page(to_mm->id.stack);
  out:
 	return ret;
@@ -141,12 +135,12 @@ void destroy_context(struct mm_struct *m
 {
 	struct mmu_context_skas *mmu = &mm->context.skas;
 
-	if(proc_mm)
+	if (proc_mm)
 		os_close_file(mmu->id.u.mm_fd);
 	else
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
 
-	if(!proc_mm || !ptrace_faultinfo){
+	if (!proc_mm || !ptrace_faultinfo) {
 		free_page(mmu->id.stack);
 		pte_lock_deinit(virt_to_page(mmu->last_page_table));
 		pte_free_kernel((pte_t *) mmu->last_page_table);
diff -puN arch/um/kernel/skas/process.c~uml-style-fixes-pass-3 arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/skas/process.c
@@ -1,36 +1,23 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/slab.h"
-#include "linux/ptrace.h"
-#include "linux/proc_fs.h"
-#include "linux/file.h"
-#include "linux/errno.h"
 #include "linux/init.h"
-#include "asm/uaccess.h"
-#include "asm/atomic.h"
-#include "kern_util.h"
+#include "linux/sched.h"
 #include "as-layout.h"
-#include "skas.h"
 #include "os.h"
-#include "tlb.h"
-#include "kern.h"
-#include "registers.h"
-
-extern void schedule_tail(struct task_struct *prev);
+#include "skas.h"
 
 int new_mm(unsigned long stack)
 {
 	int fd;
 
 	fd = os_open_file("/proc/mm", of_cloexec(of_write(OPENFLAGS())), 0);
-	if(fd < 0)
+	if (fd < 0)
 		return fd;
 
-	if(skas_needs_stub)
+	if (skas_needs_stub)
 		map_stub_pages(fd, CONFIG_STUB_CODE, CONFIG_STUB_DATA, stack);
 
 	return fd;
@@ -62,7 +49,7 @@ int __init start_uml(void)
 {
 	stack_protections((unsigned long) &cpu0_irqstack);
 	set_sigstack(cpu0_irqstack, THREAD_SIZE);
-	if(proc_mm)
+	if (proc_mm)
 		userspace_pid[0] = start_userspace(0);
 
 	init_new_thread_signals();
@@ -75,7 +62,7 @@ int __init start_uml(void)
 
 unsigned long current_stub_stack(void)
 {
-	if(current->mm == NULL)
+	if (current->mm == NULL)
 		return 0;
 
 	return current->mm->context.skas.id.stack;
diff -puN arch/um/kernel/skas/syscall.c~uml-style-fixes-pass-3 arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/skas/syscall.c
@@ -1,17 +1,13 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sys.h"
+#include "linux/kernel.h"
 #include "linux/ptrace.h"
-#include "asm/errno.h"
-#include "asm/unistd.h"
-#include "asm/ptrace.h"
-#include "asm/current.h"
-#include "sysdep/syscalls.h"
 #include "kern_util.h"
-#include "syscall.h"
+#include "sysdep/ptrace.h"
+#include "sysdep/syscalls.h"
 
 void handle_syscall(struct uml_pt_regs *r)
 {
@@ -24,7 +20,8 @@ void handle_syscall(struct uml_pt_regs *
 	current->thread.nsyscalls++;
 	nsyscalls++;
 
-	/* This should go in the declaration of syscall, but when I do that,
+	/*
+	 * This should go in the declaration of syscall, but when I do that,
 	 * strace -f -c bash -c 'ls ; ls' breaks, sometimes not tracing
 	 * children at all, sometimes hanging when bash doesn't see the first
 	 * ls exit.
@@ -33,7 +30,7 @@ void handle_syscall(struct uml_pt_regs *
 	 * in case it's a compiler bug.
 	 */
 	syscall = UPT_SYSCALL_NR(r);
-	if((syscall >= NR_syscalls) || (syscall < 0))
+	if ((syscall >= NR_syscalls) || (syscall < 0))
 		result = -ENOSYS;
 	else result = EXECUTE_SYSCALL(syscall, regs);
 
diff -puN arch/um/kernel/syscall.c~uml-style-fixes-pass-3 arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/syscall.c
@@ -1,25 +1,17 @@
 /*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
 #include "linux/file.h"
-#include "linux/smp_lock.h"
-#include "linux/mm.h"
 #include "linux/fs.h"
+#include "linux/mm.h"
+#include "linux/sched.h"
 #include "linux/utsname.h"
-#include "linux/msg.h"
-#include "linux/shm.h"
-#include "linux/sys.h"
-#include "linux/syscalls.h"
-#include "linux/unistd.h"
-#include "linux/slab.h"
-#include "linux/utime.h"
+#include "asm/current.h"
 #include "asm/mman.h"
 #include "asm/uaccess.h"
-#include "kern_util.h"
-#include "sysdep/syscalls.h"
+#include "asm/unistd.h"
 
 /*  Unlocked, I don't care if this is a bit off */
 int nsyscalls = 0;
@@ -32,7 +24,7 @@ long sys_fork(void)
 	ret = do_fork(SIGCHLD, UPT_SP(&current->thread.regs.regs),
 		      &current->thread.regs, 0, NULL, NULL);
 	current->thread.forking = 0;
-	return(ret);
+	return ret;
 }
 
 long sys_vfork(void)
@@ -44,7 +36,7 @@ long sys_vfork(void)
 		      UPT_SP(&current->thread.regs.regs),
 		      &current->thread.regs, 0, NULL, NULL);
 	current->thread.forking = 0;
-	return(ret);
+	return ret;
 }
 
 /* common code for old and new mmaps */
@@ -90,15 +82,15 @@ long old_mmap(unsigned long addr, unsign
  */
 long sys_pipe(unsigned long __user * fildes)
 {
-        int fd[2];
-        long error;
+	int fd[2];
+	long error;
 
-        error = do_pipe(fd);
-        if (!error) {
+	error = do_pipe(fd);
+	if (!error) {
 		if (copy_to_user(fildes, fd, sizeof(fd)))
-                        error = -EFAULT;
-        }
-        return error;
+			error = -EFAULT;
+	}
+	return error;
 }
 
 
@@ -122,7 +114,7 @@ long sys_olduname(struct oldold_utsname 
 	if (!access_ok(VERIFY_WRITE,name,sizeof(struct oldold_utsname)))
 		return -EFAULT;
 
-  	down_read(&uts_sem);
+	down_read(&uts_sem);
 
 	error = __copy_to_user(&name->sysname, &utsname()->sysname,
 			       __OLD_UTS_LEN);
diff -puN arch/um/kernel/time.c~uml-style-fixes-pass-3 arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/time.c
@@ -1,28 +1,19 @@
 /*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/module.h"
-#include "linux/unistd.h"
-#include "linux/stddef.h"
-#include "linux/spinlock.h"
-#include "linux/time.h"
-#include "linux/sched.h"
 #include "linux/interrupt.h"
-#include "linux/init.h"
-#include "linux/delay.h"
-#include "linux/hrtimer.h"
+#include "linux/jiffies.h"
+#include "linux/threads.h"
 #include "asm/irq.h"
 #include "asm/param.h"
-#include "asm/current.h"
 #include "kern_util.h"
 #include "os.h"
 
 int hz(void)
 {
-	return(HZ);
+	return HZ;
 }
 
 /*
@@ -43,7 +34,7 @@ void timer_irq(struct uml_pt_regs *regs)
 	unsigned long long ticks = 0;
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
 	int c = cpu();
-	if(prev_nsecs[c]){
+	if (prev_nsecs[c]) {
 		/* We've had 1 tick */
 		unsigned long long nsecs = os_nsecs();
 
@@ -51,7 +42,7 @@ void timer_irq(struct uml_pt_regs *regs)
 		prev_nsecs[c] = nsecs;
 
 		/* Protect against the host clock being set backwards */
-		if(delta[c] < 0)
+		if (delta[c] < 0)
 			delta[c] = 0;
 
 		ticks += (delta[c] * HZ) / BILLION;
@@ -61,7 +52,7 @@ void timer_irq(struct uml_pt_regs *regs)
 #else
 	ticks = 1;
 #endif
-	while(ticks > 0){
+	while (ticks > 0) {
 		do_IRQ(TIMER_IRQ, regs);
 		ticks--;
 	}
@@ -112,12 +103,12 @@ static void register_timer(void)
 	int err;
 
 	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
-	if(err != 0)
+	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
 	err = set_interval(1);
-	if(err != 0)
+	if (err != 0)
 		printk(KERN_ERR "register_timer : set_interval failed - "
 		       "errno = %d\n", -err);
 }
@@ -144,7 +135,8 @@ void do_gettimeofday(struct timeval *tv)
 		xtime.tv_nsec;
 #endif
 	tv->tv_sec = nsecs / NSEC_PER_SEC;
-	/* Careful about calculations here - this was originally done as
+	/*
+	 * Careful about calculations here - this was originally done as
 	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
 	 * which gave bogus (> 1000000) values.  Dunno why, suspect gcc
 	 * (4.0.0) miscompiled it, or there's a subtle 64/32-bit conversion
@@ -176,7 +168,7 @@ int do_settimeofday(struct timespec *tv)
 
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
-	if(current_thread->cpu == 0)
+	if (current_thread->cpu == 0)
 		timer_irq(regs);
 	local_irq_disable();
 	irq_enter();
diff -puN arch/um/kernel/tlb.c~uml-style-fixes-pass-3 arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/tlb.c
@@ -1,19 +1,16 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include "linux/mm.h"
-#include "asm/page.h"
-#include "asm/pgalloc.h"
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
 #include "as-layout.h"
-#include "tlb.h"
-#include "mem.h"
 #include "mem_user.h"
 #include "os.h"
 #include "skas.h"
+#include "tlb.h"
 
 static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
 		    unsigned int prot, struct host_vm_op *ops, int *index,
@@ -26,18 +23,18 @@ static int add_mmap(unsigned long virt, 
 	int fd, ret = 0;
 
 	fd = phys_mapping(phys, &offset);
-	if(*index != -1){
+	if (*index != -1) {
 		last = &ops[*index];
-		if((last->type == MMAP) &&
+		if ((last->type == MMAP) &&
 		   (last->u.mmap.addr + last->u.mmap.len == virt) &&
 		   (last->u.mmap.prot == prot) && (last->u.mmap.fd == fd) &&
-		   (last->u.mmap.offset + last->u.mmap.len == offset)){
+		   (last->u.mmap.offset + last->u.mmap.len == offset)) {
 			last->u.mmap.len += len;
 			return 0;
 		}
 	}
 
-	if(*index == last_filled){
+	if (*index == last_filled) {
 		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
 		*index = -1;
 	}
@@ -62,16 +59,16 @@ static int add_munmap(unsigned long addr
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if(*index != -1){
+	if (*index != -1) {
 		last = &ops[*index];
-		if((last->type == MUNMAP) &&
-		   (last->u.munmap.addr + last->u.mmap.len == addr)){
+		if ((last->type == MUNMAP) &&
+		   (last->u.munmap.addr + last->u.mmap.len == addr)) {
 			last->u.munmap.len += len;
 			return 0;
 		}
 	}
 
-	if(*index == last_filled){
+	if (*index == last_filled) {
 		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
 		*index = -1;
 	}
@@ -92,17 +89,17 @@ static int add_mprotect(unsigned long ad
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if(*index != -1){
+	if (*index != -1) {
 		last = &ops[*index];
-		if((last->type == MPROTECT) &&
+		if ((last->type == MPROTECT) &&
 		   (last->u.mprotect.addr + last->u.mprotect.len == addr) &&
-		   (last->u.mprotect.prot == prot)){
+		   (last->u.mprotect.prot == prot)) {
 			last->u.mprotect.len += len;
 			return 0;
 		}
 	}
 
-	if(*index == last_filled){
+	if (*index == last_filled) {
 		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
 		*index = -1;
 	}
@@ -141,15 +138,15 @@ static inline int update_pte_range(pmd_t
 		}
 		prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
 			(x ? UM_PROT_EXEC : 0));
-		if(force || pte_newpage(*pte)){
-			if(pte_present(*pte))
+		if (force || pte_newpage(*pte)) {
+			if (pte_present(*pte))
 				ret = add_mmap(addr, pte_val(*pte) & PAGE_MASK,
 					       PAGE_SIZE, prot, ops, op_index,
 					       last_op, mmu, flush, do_ops);
 			else ret = add_munmap(addr, PAGE_SIZE, ops, op_index,
 					      last_op, mmu, flush, do_ops);
 		}
-		else if(pte_newprot(*pte))
+		else if (pte_newprot(*pte))
 			ret = add_mprotect(addr, PAGE_SIZE, prot, ops, op_index,
 					   last_op, mmu, flush, do_ops);
 		*pte = pte_mkuptodate(*pte);
@@ -172,8 +169,8 @@ static inline int update_pmd_range(pud_t
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if(!pmd_present(*pmd)){
-			if(force || pmd_newpage(*pmd)){
+		if (!pmd_present(*pmd)) {
+			if (force || pmd_newpage(*pmd)) {
 				ret = add_munmap(addr, next - addr, ops,
 						 op_index, last_op, mmu,
 						 flush, do_ops);
@@ -202,8 +199,8 @@ static inline int update_pud_range(pgd_t
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
-		if(!pud_present(*pud)){
-			if(force || pud_newpage(*pud)){
+		if (!pud_present(*pud)) {
+			if (force || pud_newpage(*pud)) {
 				ret = add_munmap(addr, next - addr, ops,
 						 op_index, last_op, mmu,
 						 flush, do_ops);
@@ -233,8 +230,8 @@ void fix_range_common(struct mm_struct *
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end_addr);
-		if(!pgd_present(*pgd)){
-			if (force || pgd_newpage(*pgd)){
+		if (!pgd_present(*pgd)) {
+			if (force || pgd_newpage(*pgd)) {
 				ret = add_munmap(addr, next - addr, ops,
 						 &op_index, last_op, mmu,
 						 &flush, do_ops);
@@ -246,12 +243,13 @@ void fix_range_common(struct mm_struct *
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
 
-	if(!ret)
+	if (!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
 
 	/* This is not an else because ret is modified above */
-	if(ret) {
-		printk("fix_range_common: failed, killing current process\n");
+	if (ret) {
+		printk(KERN_ERR "fix_range_common: failed, killing current "
+		       "process\n");
 		force_sig(SIGKILL, current);
 	}
 }
@@ -267,17 +265,17 @@ int flush_tlb_kernel_range_common(unsign
 	int updated = 0, err;
 
 	mm = &init_mm;
-	for(addr = start; addr < end;){
+	for (addr = start; addr < end;) {
 		pgd = pgd_offset(mm, addr);
-		if(!pgd_present(*pgd)){
+		if (!pgd_present(*pgd)) {
 			last = ADD_ROUND(addr, PGDIR_SIZE);
-			if(last > end)
+			if (last > end)
 				last = end;
-			if(pgd_newpage(*pgd)){
+			if (pgd_newpage(*pgd)) {
 				updated = 1;
 				err = os_unmap_memory((void *) addr,
 						      last - addr);
-				if(err < 0)
+				if (err < 0)
 					panic("munmap failed, errno = %d\n",
 					      -err);
 			}
@@ -286,15 +284,15 @@ int flush_tlb_kernel_range_common(unsign
 		}
 
 		pud = pud_offset(pgd, addr);
-		if(!pud_present(*pud)){
+		if (!pud_present(*pud)) {
 			last = ADD_ROUND(addr, PUD_SIZE);
-			if(last > end)
+			if (last > end)
 				last = end;
-			if(pud_newpage(*pud)){
+			if (pud_newpage(*pud)) {
 				updated = 1;
 				err = os_unmap_memory((void *) addr,
 						      last - addr);
-				if(err < 0)
+				if (err < 0)
 					panic("munmap failed, errno = %d\n",
 					      -err);
 			}
@@ -303,15 +301,15 @@ int flush_tlb_kernel_range_common(unsign
 		}
 
 		pmd = pmd_offset(pud, addr);
-		if(!pmd_present(*pmd)){
+		if (!pmd_present(*pmd)) {
 			last = ADD_ROUND(addr, PMD_SIZE);
-			if(last > end)
+			if (last > end)
 				last = end;
-			if(pmd_newpage(*pmd)){
+			if (pmd_newpage(*pmd)) {
 				updated = 1;
 				err = os_unmap_memory((void *) addr,
 						      last - addr);
-				if(err < 0)
+				if (err < 0)
 					panic("munmap failed, errno = %d\n",
 					      -err);
 			}
@@ -320,25 +318,25 @@ int flush_tlb_kernel_range_common(unsign
 		}
 
 		pte = pte_offset_kernel(pmd, addr);
-		if(!pte_present(*pte) || pte_newpage(*pte)){
+		if (!pte_present(*pte) || pte_newpage(*pte)) {
 			updated = 1;
 			err = os_unmap_memory((void *) addr,
 					      PAGE_SIZE);
-			if(err < 0)
+			if (err < 0)
 				panic("munmap failed, errno = %d\n",
 				      -err);
-			if(pte_present(*pte))
+			if (pte_present(*pte))
 				map_memory(addr,
 					   pte_val(*pte) & PAGE_MASK,
 					   PAGE_SIZE, 1, 1, 1);
 		}
-		else if(pte_newprot(*pte)){
+		else if (pte_newprot(*pte)) {
 			updated = 1;
 			os_protect_memory((void *) addr, PAGE_SIZE, 1, 1, 1);
 		}
 		addr += PAGE_SIZE;
 	}
-	return(updated);
+	return updated;
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
@@ -354,15 +352,15 @@ void flush_tlb_page(struct vm_area_struc
 
 	address &= PAGE_MASK;
 	pgd = pgd_offset(mm, address);
-	if(!pgd_present(*pgd))
+	if (!pgd_present(*pgd))
 		goto kill;
 
 	pud = pud_offset(pgd, address);
-	if(!pud_present(*pud))
+	if (!pud_present(*pud))
 		goto kill;
 
 	pmd = pmd_offset(pud, address);
-	if(!pmd_present(*pmd))
+	if (!pmd_present(*pmd))
 		goto kill;
 
 	pte = pte_offset_kernel(pmd, address);
@@ -380,8 +378,8 @@ void flush_tlb_page(struct vm_area_struc
 	mm_id = &mm->context.skas.id;
 	prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
 		(x ? UM_PROT_EXEC : 0));
-	if(pte_newpage(*pte)){
-		if(pte_present(*pte)){
+	if (pte_newpage(*pte)) {
+		if (pte_present(*pte)) {
 			unsigned long long offset;
 			int fd;
 
@@ -391,10 +389,10 @@ void flush_tlb_page(struct vm_area_struc
 		}
 		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
 	}
-	else if(pte_newprot(*pte))
+	else if (pte_newprot(*pte))
 		err = protect(mm_id, address, PAGE_SIZE, prot, 1, &flush);
 
-	if(err)
+	if (err)
 		goto kill;
 
 	*pte = pte_mkuptodate(*pte);
@@ -402,28 +400,28 @@ void flush_tlb_page(struct vm_area_struc
 	return;
 
 kill:
-	printk("Failed to flush page for address 0x%lx\n", address);
+	printk(KERN_ERR "Failed to flush page for address 0x%lx\n", address);
 	force_sig(SIGKILL, current);
 }
 
 pgd_t *pgd_offset_proc(struct mm_struct *mm, unsigned long address)
 {
-	return(pgd_offset(mm, address));
+	return pgd_offset(mm, address);
 }
 
 pud_t *pud_offset_proc(pgd_t *pgd, unsigned long address)
 {
-	return(pud_offset(pgd, address));
+	return pud_offset(pgd, address);
 }
 
 pmd_t *pmd_offset_proc(pud_t *pud, unsigned long address)
 {
-	return(pmd_offset(pud, address));
+	return pmd_offset(pud, address);
 }
 
 pte_t *pte_offset_proc(pmd_t *pmd, unsigned long address)
 {
-	return(pte_offset_kernel(pmd, address));
+	return pte_offset_kernel(pmd, address);
 }
 
 pte_t *addr_pte(struct task_struct *task, unsigned long addr)
@@ -432,7 +430,7 @@ pte_t *addr_pte(struct task_struct *task
 	pud_t *pud = pud_offset(pgd, addr);
 	pmd_t *pmd = pmd_offset(pud, addr);
 
-	return(pte_offset_map(pmd, addr));
+	return pte_offset_map(pmd, addr);
 }
 
 void flush_tlb_all(void)
@@ -452,18 +450,18 @@ void flush_tlb_kernel_vm(void)
 
 void __flush_tlb_one(unsigned long addr)
 {
-        flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
+	flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
 }
 
 static int do_ops(union mm_context *mmu, struct host_vm_op *ops, int last,
 		  int finished, void **flush)
 {
 	struct host_vm_op *op;
-        int i, ret = 0;
+	int i, ret = 0;
 
-        for(i = 0; i <= last && !ret; i++){
-		op = &ops[i];
-		switch(op->type){
+	for (i = 0; i <= last && !ret; i++) {
+	op = &ops[i];
+		switch(op->type) {
 		case MMAP:
 			ret = map(&mmu->skas.id, op->u.mmap.addr,
 				  op->u.mmap.len, op->u.mmap.prot,
@@ -480,7 +478,8 @@ static int do_ops(union mm_context *mmu,
 				      finished, flush);
 			break;
 		default:
-			printk("Unknown op type %d in do_ops\n", op->type);
+			printk(KERN_ERR "Unknown op type %d in do_ops\n",
+			       op->type);
 			break;
 		}
 	}
@@ -491,32 +490,33 @@ static int do_ops(union mm_context *mmu,
 static void fix_range(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force)
 {
-        if(!proc_mm && (end_addr > CONFIG_STUB_START))
-                end_addr = CONFIG_STUB_START;
+	if (!proc_mm && (end_addr > CONFIG_STUB_START))
+		end_addr = CONFIG_STUB_START;
 
-        fix_range_common(mm, start_addr, end_addr, force, do_ops);
+	fix_range_common(mm, start_addr, end_addr, force, do_ops);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end)
 {
-        if(vma->vm_mm == NULL)
-                flush_tlb_kernel_range_common(start, end);
-        else fix_range(vma->vm_mm, start, end, 0);
+	if (vma->vm_mm == NULL)
+		flush_tlb_kernel_range_common(start, end);
+	else fix_range(vma->vm_mm, start, end, 0);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
 	unsigned long end;
 
-	/* Don't bother flushing if this address space is about to be
-         * destroyed.
-         */
-        if(atomic_read(&mm->mm_users) == 0)
-                return;
+	/*
+	 * Don't bother flushing if this address space is about to be
+	 * destroyed.
+	 */
+	if (atomic_read(&mm->mm_users) == 0)
+		return;
 
 	end = proc_mm ? task_size : CONFIG_STUB_START;
-        fix_range(mm, 0, end, 0);
+	fix_range(mm, 0, end, 0);
 }
 
 void force_flush_all(void)
@@ -524,7 +524,7 @@ void force_flush_all(void)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = mm->mmap;
 
-	while(vma != NULL) {
+	while (vma != NULL) {
 		fix_range(mm, vma->vm_start, vma->vm_end, 1);
 		vma = vma->vm_next;
 	}
diff -puN arch/um/kernel/um_arch.c~uml-style-fixes-pass-3 arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-style-fixes-pass-3
+++ a/arch/um/kernel/um_arch.c
@@ -1,39 +1,22 @@
 /*
- * Copyright (C) 2000, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/sched.h"
-#include "linux/notifier.h"
-#include "linux/mm.h"
-#include "linux/types.h"
-#include "linux/tty.h"
-#include "linux/init.h"
-#include "linux/bootmem.h"
-#include "linux/spinlock.h"
-#include "linux/utsname.h"
-#include "linux/sysrq.h"
-#include "linux/seq_file.h"
 #include "linux/delay.h"
+#include "linux/mm.h"
 #include "linux/module.h"
+#include "linux/seq_file.h"
+#include "linux/string.h"
 #include "linux/utsname.h"
-#include "asm/page.h"
 #include "asm/pgtable.h"
-#include "asm/ptrace.h"
-#include "asm/elf.h"
-#include "asm/user.h"
+#include "asm/processor.h"
 #include "asm/setup.h"
-#include "ubd_user.h"
-#include "asm/current.h"
-#include "kern_util.h"
-#include "as-layout.h"
 #include "arch.h"
+#include "as-layout.h"
+#include "init.h"
 #include "kern.h"
 #include "mem_user.h"
-#include "mem.h"
-#include "initrd.h"
-#include "init.h"
 #include "os.h"
 #include "skas.h"
 
@@ -48,7 +31,7 @@ static void __init add_arg(char *arg)
 		printf("add_arg: Too many command line arguments!\n");
 		exit(1);
 	}
-	if(strlen(command_line) > 0)
+	if (strlen(command_line) > 0)
 		strcat(command_line, " ");
 	strcat(command_line, arg);
 }
@@ -133,7 +116,7 @@ static int have_root __initdata = 0;
 /* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
-static char *usage_string = 
+static char *usage_string =
 "User Mode Linux v%s\n"
 "	available at http://user-mode-linux.sourceforge.net/\n\n";
 
@@ -191,7 +174,7 @@ static int __init uml_ncpus_setup(char *
 
 __uml_setup("ncpus=", uml_ncpus_setup,
 "ncpus=<# of desired CPUs>\n"
-"    This tells an SMP kernel how many virtual processors to start.\n\n" 
+"    This tells an SMP kernel how many virtual processors to start.\n\n"
 );
 #endif
 
@@ -223,9 +206,8 @@ static int __init uml_checksetup(char *l
 		int n;
 
 		n = strlen(p->str);
-		if(!strncmp(line, p->str, n)){
-			if (p->setup_func(line + n, add)) return 1;
-		}
+		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
+			return 1;
 		p++;
 	}
 	return 0;
@@ -236,7 +218,7 @@ static void __init uml_postsetup(void)
 	initcall_t *p;
 
 	p = &__uml_postsetup_start;
-	while(p < &__uml_postsetup_end){
+	while(p < &__uml_postsetup_end) {
 		(*p)();
 		p++;
 	}
@@ -272,16 +254,18 @@ int __init linux_main(int argc, char **a
 	unsigned int i, add;
 	char * mode;
 
-	for (i = 1; i < argc; i++){
-		if((i == 1) && (argv[i][0] == ' ')) continue;
+	for (i = 1; i < argc; i++) {
+		if ((i == 1) && (argv[i][0] == ' '))
+			continue;
 		add = 1;
 		uml_checksetup(argv[i], &add);
 		if (add)
 			add_arg(argv[i]);
 	}
-	if(have_root == 0)
+	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
+	/* OS sanity checks that need to happen before the kernel runs */
 	os_early_checks();
 
 	can_do_skas();
@@ -302,12 +286,14 @@ int __init linux_main(int argc, char **a
 
 	brk_start = (unsigned long) sbrk(0);
 
-	/* Increase physical memory size for exec-shield users
-	so they actually get what they asked for. This should
-	add zero for non-exec shield users */
+	/*
+	 * Increase physical memory size for exec-shield users
+	 * so they actually get what they asked for. This should
+	 * add zero for non-exec shield users
+	 */
 
 	diff = UML_ROUND_UP(brk_start) - UML_ROUND_UP(&_end);
-	if(diff > 1024 * 1024){
+	if (diff > 1024 * 1024) {
 		printf("Adding %ld bytes to physical memory to account for "
 		       "exec-shield gap\n", diff);
 		physmem_size += UML_ROUND_UP(brk_start) - UML_ROUND_UP(&_end);
@@ -324,11 +310,12 @@ int __init linux_main(int argc, char **a
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
 	max_physmem = get_kmem_end() - uml_physmem - iomem_size - MIN_VMALLOC;
 
-	/* Zones have to begin on a 1 << MAX_ORDER page boundary,
+	/*
+	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
 	 * so this makes sure that's true for highmem
 	 */
 	max_physmem &= ~((1 << (PAGE_SHIFT + MAX_ORDER)) - 1);
-	if(physmem_size + iomem_size > max_physmem){
+	if (physmem_size + iomem_size > max_physmem) {
 		highmem = physmem_size + iomem_size - max_physmem;
 		physmem_size -= highmem;
 #ifndef CONFIG_HIGHMEM
@@ -345,7 +332,7 @@ int __init linux_main(int argc, char **a
 	start_vm = VMALLOC_START;
 
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
-	if(init_maps(physmem_size, iomem_size, highmem)){
+	if (init_maps(physmem_size, iomem_size, highmem)) {
 		printf("Failed to allocate mem_map for %Lu bytes of physical "
 		       "memory and %Lu bytes of highmem\n", physmem_size,
 		       highmem);
@@ -354,10 +341,11 @@ int __init linux_main(int argc, char **a
 
 	virtmem_size = physmem_size;
 	avail = get_kmem_end() - start_vm;
-	if(physmem_size > avail) virtmem_size = avail;
+	if (physmem_size > avail)
+		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
 
-	if(virtmem_size < physmem_size)
+	if (virtmem_size < physmem_size)
 		printf("Kernel virtual memory size shrunk to %lu bytes\n",
 		       virtmem_size);
 
diff -puN arch/um/os-Linux/aio.c~uml-style-fixes-pass-3 arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/aio.c
@@ -1,19 +1,19 @@
 /*
- * Copyright (C) 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdlib.h>
 #include <unistd.h>
+#include <sched.h>
 #include <signal.h>
 #include <errno.h>
-#include <sched.h>
-#include <sys/syscall.h>
-#include "os.h"
+#include <sys/time.h>
+#include <asm/unistd.h>
 #include "aio.h"
 #include "init.h"
-#include "user.h"
 #include "kern_constants.h"
+#include "os.h"
+#include "user.h"
 
 struct aio_thread_req {
 	enum aio_type type;
@@ -27,7 +27,8 @@ struct aio_thread_req {
 #if defined(HAVE_AIO_ABI)
 #include <linux/aio_abi.h>
 
-/* If we have the headers, we are going to build with AIO enabled.
+/*
+ * If we have the headers, we are going to build with AIO enabled.
  * If we don't have aio in libc, we define the necessary stubs here.
  */
 
@@ -51,7 +52,8 @@ static long io_getevents(aio_context_t c
 
 #endif
 
-/* The AIO_MMAP cases force the mmapped page into memory here
+/*
+ * The AIO_MMAP cases force the mmapped page into memory here
  * rather than in whatever place first touches the data.  I used
  * to do this by touching the page, but that's delicate because
  * gcc is prone to optimizing that away.  So, what's done here
@@ -105,12 +107,12 @@ static int aio_thread(void *arg)
 
 	signal(SIGWINCH, SIG_IGN);
 
-	while(1){
+	while (1) {
 		n = io_getevents(ctx, 1, 1, &event, NULL);
-		if(n < 0){
-			if(errno == EINTR)
+		if (n < 0) {
+			if (errno == EINTR)
 				continue;
-			printk("aio_thread - io_getevents failed, "
+			printk(UM_KERN_ERR "aio_thread - io_getevents failed, "
 			       "errno = %d\n", errno);
 		}
 		else {
@@ -119,9 +121,9 @@ static int aio_thread(void *arg)
 						.err	= event.res });
 			reply_fd = ((struct aio_context *) reply.data)->reply_fd;
 			err = write(reply_fd, &reply, sizeof(reply));
-			if(err != sizeof(reply))
-				printk("aio_thread - write failed, fd = %d, "
-				       "err = %d\n", reply_fd, errno);
+			if (err != sizeof(reply))
+				printk(UM_KERN_ERR "aio_thread - write failed, "
+				       "fd = %d, err = %d\n", reply_fd, errno);
 		}
 	}
 	return 0;
@@ -136,10 +138,10 @@ static int do_not_aio(struct aio_thread_
 	int n;
 
 	actual = lseek64(req->io_fd, req->offset, SEEK_SET);
-	if(actual != req->offset)
+	if (actual != req->offset)
 		return -errno;
 
-	switch(req->type){
+	switch(req->type) {
 	case AIO_READ:
 		n = read(req->io_fd, req->buf, req->len);
 		break;
@@ -150,11 +152,12 @@ static int do_not_aio(struct aio_thread_
 		n = read(req->io_fd, &c, sizeof(c));
 		break;
 	default:
-		printk("do_not_aio - bad request type : %d\n", req->type);
+		printk(UM_KERN_ERR "do_not_aio - bad request type : %d\n",
+		       req->type);
 		return -EINVAL;
 	}
 
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 	return 0;
 }
@@ -172,16 +175,18 @@ static int not_aio_thread(void *arg)
 	int err;
 
 	signal(SIGWINCH, SIG_IGN);
-	while(1){
+	while (1) {
 		err = read(aio_req_fd_r, &req, sizeof(req));
-		if(err != sizeof(req)){
-			if(err < 0)
-				printk("not_aio_thread - read failed, "
-				       "fd = %d, err = %d\n", aio_req_fd_r,
+		if (err != sizeof(req)) {
+			if (err < 0)
+				printk(UM_KERN_ERR "not_aio_thread - "
+				       "read failed, fd = %d, err = %d\n",
+				       aio_req_fd_r,
 				       errno);
 			else {
-				printk("not_aio_thread - short read, fd = %d, "
-				       "length = %d\n", aio_req_fd_r, err);
+				printk(UM_KERN_ERR "not_aio_thread - short "
+				       "read, fd = %d, length = %d\n",
+				       aio_req_fd_r, err);
 			}
 			continue;
 		}
@@ -189,9 +194,9 @@ static int not_aio_thread(void *arg)
 		reply = ((struct aio_thread_reply) { .data 	= req.aio,
 						     .err	= err });
 		err = write(req.aio->reply_fd, &reply, sizeof(reply));
-		if(err != sizeof(reply))
-			printk("not_aio_thread - write failed, fd = %d, "
-			       "err = %d\n", req.aio->reply_fd, errno);
+		if (err != sizeof(reply))
+			printk(UM_KERN_ERR "not_aio_thread - write failed, "
+			       "fd = %d, err = %d\n", req.aio->reply_fd, errno);
 	}
 
 	return 0;
@@ -202,19 +207,19 @@ static int init_aio_24(void)
 	int fds[2], err;
 
 	err = os_pipe(fds, 1, 1);
-	if(err)
+	if (err)
 		goto out;
 
 	aio_req_fd_w = fds[0];
 	aio_req_fd_r = fds[1];
 
 	err = os_set_fd_block(aio_req_fd_w, 0);
-	if(err)
+	if (err)
 		goto out_close_pipe;
 
 	err = run_helper_thread(not_aio_thread, NULL,
 				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
-	if(err < 0)
+	if (err < 0)
 		goto out_close_pipe;
 
 	aio_pid = err;
@@ -227,10 +232,11 @@ out_close_pipe:
 	aio_req_fd_r = -1;
 out:
 #ifndef HAVE_AIO_ABI
-	printk("/usr/include/linux/aio_abi.h not present during build\n");
+	printk(UM_KERN_INFO "/usr/include/linux/aio_abi.h not present during "
+	       "build\n");
 #endif
-	printk("2.6 host AIO support not used - falling back to I/O "
-	       "thread\n");
+	printk(UM_KERN_INFO "2.6 host AIO support not used - falling back to "
+	       "I/O thread\n");
 	return 0;
 }
 
@@ -240,21 +246,21 @@ static int init_aio_26(void)
 {
 	int err;
 
-	if(io_setup(256, &ctx)){
+	if (io_setup(256, &ctx)) {
 		err = -errno;
-		printk("aio_thread failed to initialize context, err = %d\n",
-		       errno);
+		printk(UM_KERN_ERR "aio_thread failed to initialize context, "
+		       "err = %d\n", errno);
 		return err;
 	}
 
 	err = run_helper_thread(aio_thread, NULL,
 				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
-	if(err < 0)
+	if (err < 0)
 		return err;
 
 	aio_pid = err;
 
-	printk("Using 2.6 host AIO\n");
+	printk(UM_KERN_INFO "Using 2.6 host AIO\n");
 	return 0;
 }
 
@@ -265,13 +271,13 @@ static int submit_aio_26(enum aio_type t
 	int err;
 
 	err = do_aio(ctx, type, io_fd, buf, len, offset, aio);
-	if(err){
+	if (err) {
 		reply = ((struct aio_thread_reply) { .data = aio,
 					 .err  = err });
 		err = write(aio->reply_fd, &reply, sizeof(reply));
-		if(err != sizeof(reply)){
+		if (err != sizeof(reply)) {
 			err = -errno;
-			printk("submit_aio_26 - write failed, "
+			printk(UM_KERN_ERR "submit_aio_26 - write failed, "
 			       "fd = %d, err = %d\n", aio->reply_fd, -err);
 		}
 		else err = 0;
@@ -319,23 +325,24 @@ static int init_aio(void)
 {
 	int err;
 
-	if(!aio_24){
+	if (!aio_24) {
 		err = init_aio_26();
-		if(err && (errno == ENOSYS)){
-			printk("2.6 AIO not supported on the host - "
-			       "reverting to 2.4 AIO\n");
+		if (err && (errno == ENOSYS)) {
+			printk(UM_KERN_INFO "2.6 AIO not supported on the "
+			       "host - reverting to 2.4 AIO\n");
 			aio_24 = 1;
 		}
 		else return err;
 	}
 
-	if(aio_24)
+	if (aio_24)
 		return init_aio_24();
 
 	return 0;
 }
 
-/* The reason for the __initcall/__uml_exitcall asymmetry is that init_aio
+/*
+ * The reason for the __initcall/__uml_exitcall asymmetry is that init_aio
  * needs to be called when the kernel is running because it calls run_helper,
  * which needs get_free_page.  exit_aio is a __uml_exitcall because the generic
  * kernel does not run __exitcalls on shutdown, and can't because many of them
@@ -366,7 +373,7 @@ static int submit_aio_24(enum aio_type t
 	int err;
 
 	err = write(aio_req_fd_w, &req, sizeof(req));
-	if(err == sizeof(req))
+	if (err == sizeof(req))
 		err = 0;
 	else err = -errno;
 
@@ -378,9 +385,8 @@ int submit_aio(enum aio_type type, int i
 	       struct aio_context *aio)
 {
 	aio->reply_fd = reply_fd;
-	if(aio_24)
+	if (aio_24)
 		return submit_aio_24(type, io_fd, buf, len, offset, aio);
-	else {
+	else
 		return submit_aio_26(type, io_fd, buf, len, offset, aio);
-	}
 }
diff -puN arch/um/os-Linux/file.c~uml-style-fixes-pass-3 arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/file.c
@@ -267,9 +267,9 @@ void os_close_file(int fd)
 	close(fd);
 }
 
-int os_seek_file(int fd, __u64 offset)
+int os_seek_file(int fd, unsigned long long offset)
 {
-	__u64 actual;
+	unsigned long long actual;
 
 	actual = lseek64(fd, offset, SEEK_SET);
 	if(actual != offset)
diff -puN arch/um/os-Linux/main.c~uml-style-fixes-pass-3 arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/main.c
@@ -1,27 +1,21 @@
 /*
- * Copyright (C) 2000, 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <string.h>
-#include <signal.h>
+#include <unistd.h>
 #include <errno.h>
+#include <signal.h>
+#include <string.h>
 #include <sys/resource.h>
-#include <sys/mman.h>
-#include <sys/user.h>
-#include "kern_util.h"
 #include "as-layout.h"
-#include "mem_user.h"
-#include "irq_user.h"
-#include "user.h"
 #include "init.h"
-#include "uml-config.h"
+#include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "kern_constants.h"
 
 #define PGD_BOUND (4 * 1024 * 1024)
 #define STACKSIZE (8 * 1024 * 1024)
@@ -31,13 +25,13 @@ static void set_stklim(void)
 {
 	struct rlimit lim;
 
-	if(getrlimit(RLIMIT_STACK, &lim) < 0){
+	if (getrlimit(RLIMIT_STACK, &lim) < 0) {
 		perror("getrlimit");
 		exit(1);
 	}
-	if((lim.rlim_cur == RLIM_INFINITY) || (lim.rlim_cur > STACKSIZE)){
+	if ((lim.rlim_cur == RLIM_INFINITY) || (lim.rlim_cur > STACKSIZE)) {
 		lim.rlim_cur = STACKSIZE;
-		if(setrlimit(RLIMIT_STACK, &lim) < 0){
+		if (setrlimit(RLIMIT_STACK, &lim) < 0) {
 			perror("setrlimit");
 			exit(1);
 		}
@@ -49,7 +43,7 @@ static __init void do_uml_initcalls(void
 	initcall_t *call;
 
 	call = &__uml_initcall_start;
-	while (call < &__uml_initcall_end){
+	while (call < &__uml_initcall_end) {
 		(*call)();
 		call++;
 	}
@@ -68,7 +62,8 @@ static void install_fatal_handler(int si
 	/* All signals are enabled in this handler ... */
 	sigemptyset(&action.sa_mask);
 
-	/* ... including the signal being handled, plus we want the
+	/*
+	 * ... including the signal being handled, plus we want the
 	 * handler reset to the default behavior, so that if an exit
 	 * handler is hanging for some reason, the UML will just die
 	 * after this signal is sent a second time.
@@ -76,7 +71,7 @@ static void install_fatal_handler(int si
 	action.sa_flags = SA_RESETHAND | SA_NODEFER;
 	action.sa_restorer = NULL;
 	action.sa_handler = last_ditch_exit;
-	if(sigaction(sig, &action, NULL) < 0){
+	if (sigaction(sig, &action, NULL) < 0) {
 		printf("failed to install handler for signal %d - errno = %d\n",
 		       errno);
 		exit(1);
@@ -92,7 +87,8 @@ static void setup_env_path(void)
 	int path_len = 0;
 
 	old_path = getenv("PATH");
-	/* if no PATH variable is set or it has an empty value
+	/*
+	 * if no PATH variable is set or it has an empty value
 	 * just use the default + /usr/lib/uml
 	 */
 	if (!old_path || (path_len = strlen(old_path)) == 0) {
@@ -125,38 +121,41 @@ int __init main(int argc, char **argv, c
 	setup_env_path();
 
 	new_argv = malloc((argc + 1) * sizeof(char *));
-	if(new_argv == NULL){
+	if (new_argv == NULL) {
 		perror("Mallocing argv");
 		exit(1);
 	}
-	for(i=0;i<argc;i++){
+	for (i = 0; i < argc; i++) {
 		new_argv[i] = strdup(argv[i]);
-		if(new_argv[i] == NULL){
+		if (new_argv[i] == NULL) {
 			perror("Mallocing an arg");
 			exit(1);
 		}
 	}
 	new_argv[argc] = NULL;
 
-	/* Allow these signals to bring down a UML if all other
+	/*
+	 * Allow these signals to bring down a UML if all other
 	 * methods of control fail.
 	 */
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
 	install_fatal_handler(SIGHUP);
 
-	scan_elf_aux( envp);
+	scan_elf_aux(envp);
 
 	do_uml_initcalls();
 	ret = linux_main(argc, argv);
 
-	/* Disable SIGPROF - I have no idea why libc doesn't do this or turn
+	/*
+	 * Disable SIGPROF - I have no idea why libc doesn't do this or turn
 	 * off the profiling time, but UML dies with a SIGPROF just before
 	 * exiting when profiling is active.
 	 */
 	change_sig(SIGPROF, 0);
 
-	/* This signal stuff used to be in the reboot case.  However,
+	/*
+	 * This signal stuff used to be in the reboot case.  However,
 	 * sometimes a SIGVTALRM can come in when we're halting (reproducably
 	 * when writing out gcov information, presumably because that takes
 	 * some time) and cause a segfault.
@@ -167,17 +166,18 @@ int __init main(int argc, char **argv, c
 
 	/* disable SIGIO for the fds and set SIGIO to be ignored */
 	err = deactivate_all_fds();
-	if(err)
+	if (err)
 		printf("deactivate_all_fds failed, errno = %d\n", -err);
 
-	/* Let any pending signals fire now.  This ensures
+	/*
+	 * Let any pending signals fire now.  This ensures
 	 * that they won't be delivered after the exec, when
 	 * they are definitely not expected.
 	 */
 	unblock_signals();
 
 	/* Reboot */
-	if(ret){
+	if (ret) {
 		printf("\n");
 		execvp(new_argv[0], new_argv);
 		perror("Failed to exec kernel");
@@ -193,17 +193,18 @@ void *__wrap_malloc(int size)
 {
 	void *ret;
 
-	if(!kmalloc_ok)
+	if (!kmalloc_ok)
 		return __real_malloc(size);
-	else if(size <= UM_KERN_PAGE_SIZE)
+	else if (size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
 		ret = kmalloc(size, UM_GFP_KERNEL);
 	else ret = vmalloc(size);
 
-	/* glibc people insist that if malloc fails, errno should be
+	/*
+	 * glibc people insist that if malloc fails, errno should be
 	 * set by malloc as well. So we do.
 	 */
-	if(ret == NULL)
+	if (ret == NULL)
 		errno = ENOMEM;
 
 	return ret;
@@ -213,7 +214,7 @@ void *__wrap_calloc(int n, int size)
 {
 	void *ptr = __wrap_malloc(n * size);
 
-	if(ptr == NULL)
+	if (ptr == NULL)
 		return NULL;
 	memset(ptr, 0, n * size);
 	return ptr;
@@ -227,7 +228,8 @@ void __wrap_free(void *ptr)
 {
 	unsigned long addr = (unsigned long) ptr;
 
-	/* We need to know how the allocation happened, so it can be correctly
+	/*
+	 * We need to know how the allocation happened, so it can be correctly
 	 * freed.  This is done by seeing what region of memory the pointer is
 	 * in -
 	 * 	physical memory - kmalloc/kfree
@@ -245,12 +247,12 @@ void __wrap_free(void *ptr)
 	 * there is a possibility for memory leaks.
 	 */
 
-	if((addr >= uml_physmem) && (addr < high_physmem)){
-		if(kmalloc_ok)
+	if ((addr >= uml_physmem) && (addr < high_physmem)) {
+		if (kmalloc_ok)
 			kfree(ptr);
 	}
-	else if((addr >= start_vm) && (addr < end_vm)){
-		if(kmalloc_ok)
+	else if ((addr >= start_vm) && (addr < end_vm)) {
+		if (kmalloc_ok)
 			vfree(ptr);
 	}
 	else __real_free(ptr);
diff -puN arch/um/os-Linux/process.c~uml-style-fixes-pass-3 arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/process.c
@@ -1,27 +1,23 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@addtoit.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <unistd.h>
 #include <stdio.h>
+#include <unistd.h>
 #include <errno.h>
 #include <signal.h>
 #include <sys/mman.h>
+#include <sys/ptrace.h>
 #include <sys/wait.h>
-#include <sys/mman.h>
-#include <sys/syscall.h>
-#include "ptrace_user.h"
+#include <asm/unistd.h>
+#include "init.h"
+#include "kern_constants.h"
+#include "longjmp.h"
 #include "os.h"
-#include "user.h"
 #include "process.h"
-#include "irq_user.h"
-#include "kern_util.h"
-#include "longjmp.h"
 #include "skas_ptrace.h"
-#include "kern_constants.h"
-#include "uml-config.h"
-#include "init.h"
+#include "user.h"
 
 #define ARBITRARY_ADDR -1
 #define FAILURE_PID    -1
@@ -37,24 +33,25 @@ unsigned long os_process_pc(int pid)
 
 	sprintf(proc_stat, "/proc/%d/stat", pid);
 	fd = os_open_file(proc_stat, of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("os_process_pc - couldn't open '%s', err = %d\n",
-		       proc_stat, -fd);
+	if (fd < 0) {
+		printk(UM_KERN_ERR "os_process_pc - couldn't open '%s', "
+		       "err = %d\n", proc_stat, -fd);
 		return ARBITRARY_ADDR;
 	}
 	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
-	if(err < 0){
-		printk("os_process_pc - couldn't read '%s', err = %d\n",
-		       proc_stat, errno);
+	if (err < 0) {
+		printk(UM_KERN_ERR "os_process_pc - couldn't read '%s', "
+		       "err = %d\n", proc_stat, errno);
 		os_close_file(fd);
 		return ARBITRARY_ADDR;
 	}
 	os_close_file(fd);
 	pc = ARBITRARY_ADDR;
-	if(sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
+	if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
 		  "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
-		  "%*d %*d %*d %*d %*d %lu", &pc) != 1){
-		printk("os_process_pc - couldn't find pc in '%s'\n", buf);
+		  "%*d %*d %*d %*d %*d %lu", &pc) != 1) {
+		printk(UM_KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
+		       buf);
 	}
 	return pc;
 }
@@ -65,28 +62,29 @@ int os_process_parent(int pid)
 	char data[256];
 	int parent, n, fd;
 
-	if(pid == -1)
+	if (pid == -1)
 		return -1;
 
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
 	fd = os_open_file(stat, of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open '%s', err = %d\n", stat, -fd);
+	if (fd < 0) {
+		printk(UM_KERN_ERR "Couldn't open '%s', err = %d\n", stat, -fd);
 		return FAILURE_PID;
 	}
 
 	CATCH_EINTR(n = read(fd, data, sizeof(data)));
 	os_close_file(fd);
 
-	if(n < 0){
-		printk("Couldn't read '%s', err = %d\n", stat, errno);
+	if (n < 0) {
+		printk(UM_KERN_ERR "Couldn't read '%s', err = %d\n", stat,
+		       errno);
 		return FAILURE_PID;
 	}
 
 	parent = FAILURE_PID;
 	n = sscanf(data, "%*d " COMM_SCANF " %*c %d", &parent);
-	if(n != 1)
-		printk("Failed to scan '%s'\n", data);
+	if (n != 1)
+		printk(UM_KERN_ERR "Failed to scan '%s'\n", data);
 
 	return parent;
 }
@@ -99,9 +97,8 @@ void os_stop_process(int pid)
 void os_kill_process(int pid, int reap_child)
 {
 	kill(pid, SIGKILL);
-	if(reap_child)
+	if (reap_child)
 		CATCH_EINTR(waitpid(pid, NULL, 0));
-		
 }
 
 /* This is here uniquely to have access to the userspace errno, i.e. the one
@@ -129,7 +126,7 @@ void os_kill_ptraced_process(int pid, in
 	kill(pid, SIGKILL);
 	ptrace(PTRACE_KILL, pid);
 	ptrace(PTRACE_CONT, pid);
-	if(reap_child)
+	if (reap_child)
 		CATCH_EINTR(waitpid(pid, NULL, 0));
 }
 
@@ -153,34 +150,35 @@ int os_map_memory(void *virt, int fd, un
 	void *loc;
 	int prot;
 
-	prot = (r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) | 
+	prot = (r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) |
 		(x ? PROT_EXEC : 0);
 
 	loc = mmap64((void *) virt, len, prot, MAP_SHARED | MAP_FIXED,
 		     fd, off);
-	if(loc == MAP_FAILED)
+	if (loc == MAP_FAILED)
 		return -errno;
 	return 0;
 }
 
 int os_protect_memory(void *addr, unsigned long len, int r, int w, int x)
 {
-        int prot = ((r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) | 
+	int prot = ((r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) |
 		    (x ? PROT_EXEC : 0));
 
-        if(mprotect(addr, len, prot) < 0)
+	if (mprotect(addr, len, prot) < 0)
 		return -errno;
-        return 0;
+
+	return 0;
 }
 
 int os_unmap_memory(void *addr, int len)
 {
-        int err;
+	int err;
 
-        err = munmap(addr, len);
-	if(err < 0)
+	err = munmap(addr, len);
+	if (err < 0)
 		return -errno;
-        return 0;
+	return 0;
 }
 
 #ifndef MADV_REMOVE
@@ -192,7 +190,7 @@ int os_drop_memory(void *addr, int lengt
 	int err;
 
 	err = madvise(addr, length, MADV_REMOVE);
-	if(err < 0)
+	if (err < 0)
 		err = -errno;
 	return err;
 }
@@ -202,22 +200,24 @@ int __init can_drop_memory(void)
 	void *addr;
 	int fd, ok = 0;
 
-	printk("Checking host MADV_REMOVE support...");
+	printk(UM_KERN_INFO "Checking host MADV_REMOVE support...");
 	fd = create_mem_file(UM_KERN_PAGE_SIZE);
-	if(fd < 0){
-		printk("Creating test memory file failed, err = %d\n", -fd);
+	if (fd < 0) {
+		printk(UM_KERN_ERR "Creating test memory file failed, "
+		       "err = %d\n", -fd);
 		goto out;
 	}
 
 	addr = mmap64(NULL, UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 		      MAP_SHARED, fd, 0);
-	if(addr == MAP_FAILED){
-		printk("Mapping test memory file failed, err = %d\n", -errno);
+	if (addr == MAP_FAILED) {
+		printk(UM_KERN_ERR "Mapping test memory file failed, "
+		       "err = %d\n", -errno);
 		goto out_close;
 	}
 
-	if(madvise(addr, UM_KERN_PAGE_SIZE, MADV_REMOVE) != 0){
-		printk("MADV_REMOVE failed, err = %d\n", -errno);
+	if (madvise(addr, UM_KERN_PAGE_SIZE, MADV_REMOVE) != 0) {
+		printk(UM_KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
 		goto out_unmap;
 	}
 
@@ -256,7 +256,7 @@ int run_kernel_thread(int (*fn)(void *),
 
 	*jmp_ptr = &buf;
 	n = UML_SETJMP(&buf);
-	if(n != 0)
+	if (n != 0)
 		return n;
 	(*fn)(arg);
 	return 0;
diff -puN arch/um/os-Linux/registers.c~uml-style-fixes-pass-3 arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/registers.c
@@ -1,13 +1,14 @@
 /*
  * Copyright (C) 2004 PathScale, Inc
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <errno.h>
 #include <string.h>
 #include <sys/ptrace.h>
-#include "user.h"
 #include "sysdep/ptrace.h"
+#include "user.h"
 
 /* This is set once at boot time and not changed thereafter */
 
@@ -23,7 +24,7 @@ void save_registers(int pid, struct uml_
 	int err;
 
 	err = ptrace(PTRACE_GETREGS, pid, 0, regs->regs);
-	if(err < 0)
+	if (err < 0)
 		panic("save_registers - saving registers failed, errno = %d\n",
 		      errno);
 }
@@ -33,7 +34,7 @@ void restore_registers(int pid, struct u
 	int err;
 
 	err = ptrace(PTRACE_SETREGS, pid, 0, regs->regs);
-	if(err < 0)
+	if (err < 0)
 		panic("restore_registers - saving registers failed, "
 		      "errno = %d\n", errno);
 }
@@ -43,7 +44,7 @@ void init_registers(int pid)
 	int err;
 
 	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
-	if(err)
+	if (err)
 		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
 		      errno);
 }
diff -puN arch/um/os-Linux/signal.c~uml-style-fixes-pass-3 arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/signal.c
@@ -1,24 +1,21 @@
 /*
  * Copyright (C) 2004 PathScale, Inc
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <signal.h>
-#include <stdio.h>
-#include <unistd.h>
 #include <stdlib.h>
-#include <errno.h>
 #include <stdarg.h>
-#include <string.h>
-#include <sys/mman.h>
-#include "user.h"
-#include "signal_kern.h"
-#include "sysdep/sigcontext.h"
-#include "sysdep/barrier.h"
-#include "sigcontext.h"
+#include <errno.h>
+#include <signal.h>
+#include <strings.h>
 #include "os.h"
+#include "sysdep/barrier.h"
+#include "sysdep/sigcontext.h"
+#include "user.h"
 
-/* These are the asynchronous signals.  SIGVTALRM and SIGARLM are handled
+/*
+ * These are the asynchronous signals.  SIGVTALRM and SIGARLM are handled
  * together under SIGVTALRM_BIT.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
  * profiling is not thread-safe, then that is not my problem.  We can disable
@@ -33,7 +30,8 @@
 #define SIGALRM_BIT 2
 #define SIGALRM_MASK (1 << SIGALRM_BIT)
 
-/* These are used by both the signal handlers and
+/*
+ * These are used by both the signal handlers and
  * block/unblock_signals.  I don't want modifications cached in a
  * register - they must go straight to memory.
  */
@@ -45,7 +43,7 @@ void sig_handler(int sig, struct sigcont
 	int enabled;
 
 	enabled = signals_enabled;
-	if(!enabled && (sig == SIGIO)){
+	if (!enabled && (sig == SIGIO)) {
 		pending |= SIGIO_MASK;
 		return;
 	}
@@ -61,16 +59,16 @@ static void real_alarm_handler(int sig, 
 {
 	struct uml_pt_regs regs;
 
-	if(sig == SIGALRM)
+	if (sig == SIGALRM)
 		switch_timers(0);
 
-	if(sc != NULL)
+	if (sc != NULL)
 		copy_sc(&regs, sc);
 	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(sig, &regs);
 
-	if(sig == SIGALRM)
+	if (sig == SIGALRM)
 		switch_timers(1);
 }
 
@@ -79,8 +77,8 @@ void alarm_handler(int sig, struct sigco
 	int enabled;
 
 	enabled = signals_enabled;
-	if(!signals_enabled){
-		if(sig == SIGVTALRM)
+	if (!signals_enabled) {
+		if (sig == SIGVTALRM)
 			pending |= SIGVTALRM_MASK;
 		else pending |= SIGALRM_MASK;
 
@@ -99,7 +97,7 @@ void set_sigstack(void *sig_stack, int s
 				     .ss_sp	= (__ptr_t) sig_stack,
 				     .ss_size 	= size - sizeof(void *) });
 
-	if(sigaltstack(&stack, NULL) != 0)
+	if (sigaltstack(&stack, NULL) != 0)
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
@@ -109,7 +107,7 @@ void remove_sigstack(void)
 				     .ss_sp	= NULL,
 				     .ss_size	= 0 });
 
-	if(sigaltstack(&stack, NULL) != 0)
+	if (sigaltstack(&stack, NULL) != 0)
 		panic("disabling signal stack failed, errno = %d\n", errno);
 }
 
@@ -133,26 +131,27 @@ void handle_signal(int sig, struct sigco
 		 * with this interrupt.
 		 */
 		bail = to_irq_stack(&pending);
-		if(bail)
+		if (bail)
 			return;
 
 		nested = pending & 1;
 		pending &= ~1;
 
-		while((sig = ffs(pending)) != 0){
+		while ((sig = ffs(pending)) != 0){
 			sig--;
 			pending &= ~(1 << sig);
 			(*handlers[sig])(sig, sc);
 		}
 
-		/* Again, pending comes back with a mask of signals
+		/*
+		 * Again, pending comes back with a mask of signals
 		 * that arrived while tearing down the stack.  If this
 		 * is non-zero, we just go back, set up the stack
 		 * again, and handle the new interrupts.
 		 */
-		if(!nested)
+		if (!nested)
 			pending = from_irq_stack(nested);
-	} while(pending);
+	} while (pending);
 }
 
 extern void hard_handler(int sig);
@@ -170,18 +169,18 @@ void set_handler(int sig, void (*handler
 	sigemptyset(&action.sa_mask);
 
 	va_start(ap, flags);
-	while((mask = va_arg(ap, int)) != -1)
+	while ((mask = va_arg(ap, int)) != -1)
 		sigaddset(&action.sa_mask, mask);
 	va_end(ap);
 
 	action.sa_flags = flags;
 	action.sa_restorer = NULL;
-	if(sigaction(sig, &action, NULL) < 0)
+	if (sigaction(sig, &action, NULL) < 0)
 		panic("sigaction failed - errno = %d\n", errno);
 
 	sigemptyset(&sig_mask);
 	sigaddset(&sig_mask, sig);
-	if(sigprocmask(SIG_UNBLOCK, &sig_mask, NULL) < 0)
+	if (sigprocmask(SIG_UNBLOCK, &sig_mask, NULL) < 0)
 		panic("sigprocmask failed - errno = %d\n", errno);
 }
 
@@ -192,13 +191,14 @@ int change_sig(int signal, int on)
 	sigemptyset(&sigset);
 	sigaddset(&sigset, signal);
 	sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old);
-	return(!sigismember(&old, signal));
+	return !sigismember(&old, signal);
 }
 
 void block_signals(void)
 {
 	signals_enabled = 0;
-	/* This must return with signals disabled, so this barrier
+	/*
+	 * This must return with signals disabled, so this barrier
 	 * ensures that writes are flushed out before the return.
 	 * This might matter if gcc figures out how to inline this and
 	 * decides to shuffle this code into the caller.
@@ -210,27 +210,31 @@ void unblock_signals(void)
 {
 	int save_pending;
 
-	if(signals_enabled == 1)
+	if (signals_enabled == 1)
 		return;
 
-	/* We loop because the IRQ handler returns with interrupts off.  So,
+	/*
+	 * We loop because the IRQ handler returns with interrupts off.  So,
 	 * interrupts may have arrived and we need to re-enable them and
 	 * recheck pending.
 	 */
-	while(1){
-		/* Save and reset save_pending after enabling signals.  This
+	while(1) {
+		/*
+		 * Save and reset save_pending after enabling signals.  This
 		 * way, pending won't be changed while we're reading it.
 		 */
 		signals_enabled = 1;
 
-		/* Setting signals_enabled and reading pending must
+		/*
+		 * Setting signals_enabled and reading pending must
 		 * happen in this order.
 		 */
 		mb();
 
 		save_pending = pending;
-		if(save_pending == 0){
-			/* This must return with signals enabled, so
+		if (save_pending == 0) {
+			/*
+			 * This must return with signals enabled, so
 			 * this barrier ensures that writes are
 			 * flushed out before the return.  This might
 			 * matter if gcc figures out how to inline
@@ -243,24 +247,26 @@ void unblock_signals(void)
 
 		pending = 0;
 
-		/* We have pending interrupts, so disable signals, as the
+		/*
+		 * We have pending interrupts, so disable signals, as the
 		 * handlers expect them off when they are called.  They will
 		 * be enabled again above.
 		 */
 
 		signals_enabled = 0;
 
-		/* Deal with SIGIO first because the alarm handler might
+		/*
+		 * Deal with SIGIO first because the alarm handler might
 		 * schedule, leaving the pending SIGIO stranded until we come
 		 * back here.
 		 */
-		if(save_pending & SIGIO_MASK)
+		if (save_pending & SIGIO_MASK)
 			sig_handler_common_skas(SIGIO, NULL);
 
-		if(save_pending & SIGALRM_MASK)
+		if (save_pending & SIGALRM_MASK)
 			real_alarm_handler(SIGALRM, NULL);
 
-		if(save_pending & SIGVTALRM_MASK)
+		if (save_pending & SIGVTALRM_MASK)
 			real_alarm_handler(SIGVTALRM, NULL);
 	}
 }
@@ -273,11 +279,11 @@ int get_signals(void)
 int set_signals(int enable)
 {
 	int ret;
-	if(signals_enabled == enable)
+	if (signals_enabled == enable)
 		return enable;
 
 	ret = signals_enabled;
-	if(enable)
+	if (enable)
 		unblock_signals();
 	else block_signals();
 
diff -puN arch/um/os-Linux/skas/mem.c~uml-style-fixes-pass-3 arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/skas/mem.c
@@ -1,30 +1,25 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <signal.h>
+#include <stddef.h>
+#include <unistd.h>
 #include <errno.h>
 #include <string.h>
-#include <unistd.h>
 #include <sys/mman.h>
-#include <sys/wait.h>
-#include <asm/unistd.h>
-#include "mem_user.h"
-#include "mem.h"
-#include "skas.h"
-#include "user.h"
+#include "init.h"
+#include "kern_constants.h"
+#include "mm_id.h"
 #include "os.h"
 #include "proc_mm.h"
 #include "ptrace_user.h"
-#include "kern_util.h"
-#include "task.h"
 #include "registers.h"
-#include "uml-config.h"
+#include "skas.h"
+#include "user.h"
 #include "sysdep/ptrace.h"
 #include "sysdep/stub.h"
-#include "init.h"
-#include "kern_constants.h"
+#include "uml-config.h"
 
 extern unsigned long batch_syscall_stub, __syscall_stub_start;
 
@@ -33,7 +28,7 @@ extern void wait_stub_done(int pid);
 static inline unsigned long *check_init_stack(struct mm_id * mm_idp,
 					      unsigned long *stack)
 {
-	if(stack == NULL) {
+	if (stack == NULL) {
 		stack = (unsigned long *) mm_idp->stack + 2;
 		*stack = 0;
 	}
@@ -67,29 +62,30 @@ static inline long do_syscall_stub(struc
 	unsigned long * syscall;
 	int err, pid = mm_idp->u.pid;
 
-	if(proc_mm)
+	if (proc_mm)
 		/* FIXME: Need to look up userspace_pid by cpu */
 		pid = userspace_pid[0];
 
 	multi_count++;
 
 	n = ptrace_setregs(pid, syscall_regs);
-	if(n < 0){
-		printk("Registers - \n");
-		for(i = 0; i < MAX_REG_NR; i++)
-			printk("\t%d\t0x%lx\n", i, syscall_regs[i]);
+	if (n < 0) {
+		printk(UM_KERN_ERR "Registers - \n");
+		for (i = 0; i < MAX_REG_NR; i++)
+			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
 		      -n);
 	}
 
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if(err)
+	if (err)
 		panic("Failed to continue stub, pid = %d, errno = %d\n", pid,
 		      errno);
 
 	wait_stub_done(pid);
 
-	/* When the stub stops, we find the following values on the
+	/*
+	 * When the stub stops, we find the following values on the
 	 * beginning of the stack:
 	 * (long )return_value
 	 * (long )offset to failed sycall-data (0, if no error)
@@ -99,24 +95,25 @@ static inline long do_syscall_stub(struc
 	if (offset) {
 		data = (unsigned long *)(mm_idp->stack +
 					 offset - UML_CONFIG_STUB_DATA);
-		printk("do_syscall_stub : ret = %ld, offset = %ld, "
+		printk(UM_KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
 		       "data = %p\n", ret, offset, data);
 		syscall = (unsigned long *)((unsigned long)data + data[0]);
-		printk("do_syscall_stub: syscall %ld failed, return value = "
-		       "0x%lx, expected return value = 0x%lx\n",
+		printk(UM_KERN_ERR "do_syscall_stub: syscall %ld failed, "
+		       "return value = 0x%lx, expected return value = 0x%lx\n",
 		       syscall[0], ret, syscall[7]);
-		printk("    syscall parameters: "
+		printk(UM_KERN_ERR "    syscall parameters: "
 		       "0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       syscall[1], syscall[2], syscall[3],
 		       syscall[4], syscall[5], syscall[6]);
-		for(n = 1; n < data[0]/sizeof(long); n++) {
-			if(n == 1)
-				printk("    additional syscall data:");
-			if(n % 4 == 1)
-				printk("\n      ");
+		for (n = 1; n < data[0]/sizeof(long); n++) {
+			if (n == 1)
+				printk(UM_KERN_ERR "    additional syscall "
+				       "data:");
+			if (n % 4 == 1)
+				printk("\n" UM_KERN_ERR "      ");
 			printk("  0x%lx", data[n]);
 		}
-		if(n > 1)
+		if (n > 1)
 			printk("\n");
 	}
 	else ret = 0;
@@ -132,7 +129,7 @@ long run_syscall_stub(struct mm_id * mm_
 {
 	unsigned long *stack = check_init_stack(mm_idp, *addr);
 
-	if(done && *addr == NULL)
+	if (done && *addr == NULL)
 		single_count++;
 
 	*stack += sizeof(long);
@@ -149,8 +146,8 @@ long run_syscall_stub(struct mm_id * mm_
 	*stack = 0;
 	multi_op_count++;
 
-	if(!done && ((((unsigned long) stack) & ~UM_KERN_PAGE_MASK) <
-		     UM_KERN_PAGE_SIZE - 10 * sizeof(long))){
+	if (!done && ((((unsigned long) stack) & ~UM_KERN_PAGE_MASK) <
+		     UM_KERN_PAGE_SIZE - 10 * sizeof(long))) {
 		*addr = stack;
 		return 0;
 	}
@@ -165,14 +162,15 @@ long syscall_stub_data(struct mm_id * mm
 	unsigned long *stack;
 	int ret = 0;
 
-	/* If *addr still is uninitialized, it *must* contain NULL.
+	/*
+	 * If *addr still is uninitialized, it *must* contain NULL.
 	 * Thus in this case do_syscall_stub correctly won't be called.
 	 */
-	if((((unsigned long) *addr) & ~UM_KERN_PAGE_MASK) >=
+	if ((((unsigned long) *addr) & ~UM_KERN_PAGE_MASK) >=
 	   UM_KERN_PAGE_SIZE - (10 + data_count) * sizeof(long)) {
 		ret = do_syscall_stub(mm_idp, addr);
 		/* in case of error, don't overwrite data on stack */
-		if(ret)
+		if (ret)
 			return ret;
 	}
 
@@ -194,7 +192,7 @@ int map(struct mm_id * mm_idp, unsigned 
 {
 	int ret;
 
-	if(proc_mm){
+	if (proc_mm) {
 		struct proc_mm_op map;
 		int fd = mm_idp->u.mm_fd;
 
@@ -210,9 +208,10 @@ int map(struct mm_id * mm_idp, unsigned 
 					   .offset= offset
 					 } } } );
 		CATCH_EINTR(ret = write(fd, &map, sizeof(map)));
-		if(ret != sizeof(map)){
+		if (ret != sizeof(map)) {
 			ret = -errno;
-			printk("map : /proc/mm map failed, err = %d\n", -ret);
+			printk(UM_KERN_ERR "map : /proc/mm map failed, "
+			       "err = %d\n", -ret);
 		}
 		else ret = 0;
 	}
@@ -233,7 +232,7 @@ int unmap(struct mm_id * mm_idp, unsigne
 {
 	int ret;
 
-	if(proc_mm){
+	if (proc_mm) {
 		struct proc_mm_op unmap;
 		int fd = mm_idp->u.mm_fd;
 
@@ -244,9 +243,10 @@ int unmap(struct mm_id * mm_idp, unsigne
 					     (unsigned long) addr,
 					     .len		= len } } } );
 		CATCH_EINTR(ret = write(fd, &unmap, sizeof(unmap)));
-		if(ret != sizeof(unmap)){
+		if (ret != sizeof(unmap)) {
 			ret = -errno;
-			printk("unmap - proc_mm write returned %d\n", ret);
+			printk(UM_KERN_ERR "unmap - proc_mm write returned "
+			       "%d\n", ret);
 		}
 		else ret = 0;
 	}
@@ -267,7 +267,7 @@ int protect(struct mm_id * mm_idp, unsig
 	struct proc_mm_op protect;
 	int ret;
 
-	if(proc_mm){
+	if (proc_mm) {
 		int fd = mm_idp->u.mm_fd;
 
 		protect = ((struct proc_mm_op) { .op	= MM_MPROTECT,
@@ -279,9 +279,9 @@ int protect(struct mm_id * mm_idp, unsig
 					       .prot	= prot } } } );
 
 		CATCH_EINTR(ret = write(fd, &protect, sizeof(protect)));
-		if(ret != sizeof(protect)){
+		if (ret != sizeof(protect)) {
 			ret = -errno;
-			printk("protect failed, err = %d", -ret);
+			printk(UM_KERN_ERR "protect failed, err = %d", -ret);
 		}
 		else ret = 0;
 	}
diff -puN arch/um/os-Linux/skas/process.c~uml-style-fixes-pass-3 arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/skas/process.c
@@ -1,48 +1,38 @@
 /*
- * Copyright (C) 2002- 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002- 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
-#include <errno.h>
-#include <signal.h>
 #include <sched.h>
-#include "ptrace_user.h"
-#include <sys/wait.h>
+#include <errno.h>
+#include <string.h>
 #include <sys/mman.h>
-#include <sys/user.h>
-#include <sys/time.h>
-#include <sys/syscall.h>
-#include <asm/types.h>
-#include "user.h"
-#include "sysdep/ptrace.h"
-#include "kern_util.h"
-#include "skas.h"
-#include "stub-data.h"
-#include "mm_id.h"
-#include "sysdep/sigcontext.h"
-#include "sysdep/stub.h"
-#include "os.h"
-#include "proc_mm.h"
-#include "skas_ptrace.h"
+#include <sys/ptrace.h>
+#include <sys/wait.h>
+#include <asm/unistd.h>
+#include "as-layout.h"
 #include "chan_user.h"
-#include "registers.h"
+#include "kern_constants.h"
 #include "mem.h"
-#include "uml-config.h"
+#include "os.h"
 #include "process.h"
-#include "longjmp.h"
-#include "kern_constants.h"
-#include "as-layout.h"
+#include "proc_mm.h"
+#include "ptrace_user.h"
+#include "registers.h"
+#include "skas.h"
+#include "skas_ptrace.h"
+#include "user.h"
+#include "sysdep/stub.h"
 
 int is_skas_winch(int pid, int fd, void *data)
 {
-	if(pid != os_getpgrp())
-		return(0);
+	if (pid != os_getpgrp())
+		return 0;
 
 	register_winch_irq(-1, fd, -1, data, 0);
-	return(1);
+	return 1;
 }
 
 static int ptrace_dump_regs(int pid)
@@ -50,13 +40,12 @@ static int ptrace_dump_regs(int pid)
         unsigned long regs[MAX_REG_NR];
         int i;
 
-        if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+        if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
                 return -errno;
-        else {
-                printk("Stub registers -\n");
-                for(i = 0; i < ARRAY_SIZE(regs); i++)
-                        printk("\t%d - %lx\n", i, regs[i]);
-        }
+
+	printk(UM_KERN_ERR "Stub registers -\n");
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		printk(UM_KERN_ERR "\t%d - %lx\n", i, regs[i]);
 
         return 0;
 }
@@ -74,27 +63,28 @@ void wait_stub_done(int pid)
 {
 	int n, status, err;
 
-	while(1){
+	while (1) {
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if((n < 0) || !WIFSTOPPED(status))
+		if ((n < 0) || !WIFSTOPPED(status))
 			goto bad_wait;
 
-		if(((1 << WSTOPSIG(status)) & STUB_SIG_MASK) == 0)
+		if (((1 << WSTOPSIG(status)) & STUB_SIG_MASK) == 0)
 			break;
 
 		err = ptrace(PTRACE_CONT, pid, 0, 0);
-		if(err)
+		if (err)
 			panic("wait_stub_done : continue failed, errno = %d\n",
 			      errno);
 	}
 
-	if(((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
+	if (((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
 		return;
 
 bad_wait:
 	err = ptrace_dump_regs(pid);
-	if(err)
-		printk("Failed to get registers from stub, errno = %d\n", -err);
+	if (err)
+		printk(UM_KERN_ERR "Failed to get registers from stub, "
+		       "errno = %d\n", -err);
 	panic("wait_stub_done : failed to wait for SIGUSR1/SIGTRAP, pid = %d, "
 	      "n = %d, errno = %d, status = 0x%x\n", pid, n, errno, status);
 }
@@ -105,9 +95,9 @@ void get_skas_faultinfo(int pid, struct 
 {
 	int err;
 
-	if(ptrace_faultinfo){
+	if (ptrace_faultinfo) {
 		err = ptrace(PTRACE_FAULTINFO, pid, 0, fi);
-		if(err)
+		if (err)
 			panic("get_skas_faultinfo - PTRACE_FAULTINFO failed, "
 			      "errno = %d\n", errno);
 
@@ -119,12 +109,13 @@ void get_skas_faultinfo(int pid, struct 
 	}
 	else {
 		err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
-		if(err)
+		if (err)
 			panic("Failed to continue stub, pid = %d, errno = %d\n",
 			      pid, errno);
 		wait_stub_done(pid);
 
-		/* faultinfo is prepared by the stub-segv-handler at start of
+		/*
+		 * faultinfo is prepared by the stub-segv-handler at start of
 		 * the stub stack page. We just have to copy it.
 		 */
 		memcpy(fi, (void *)current_stub_stack(), sizeof(*fi));
@@ -137,8 +128,12 @@ static void handle_segv(int pid, struct 
 	segv(regs->faultinfo, 0, 1, NULL);
 }
 
-/*To use the same value of using_sysemu as the caller, ask it that value (in local_using_sysemu)*/
-static void handle_trap(int pid, struct uml_pt_regs *regs, int local_using_sysemu)
+/*
+ * To use the same value of using_sysemu as the caller, ask it that value
+ * (in local_using_sysemu
+ */
+static void handle_trap(int pid, struct uml_pt_regs *regs,
+			int local_using_sysemu)
 {
 	int err, status;
 
@@ -149,22 +144,22 @@ static void handle_trap(int pid, struct 
 	{
 		err = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
-		if(err < 0)
-			panic("handle_trap - nullifying syscall failed errno = %d\n",
-			      errno);
+		if (err < 0)
+			panic("handle_trap - nullifying syscall failed, "
+			      "errno = %d\n", errno);
 
 		err = ptrace(PTRACE_SYSCALL, pid, 0, 0);
-		if(err < 0)
-			panic("handle_trap - continuing to end of syscall failed, "
-			      "errno = %d\n", errno);
+		if (err < 0)
+			panic("handle_trap - continuing to end of syscall "
+			      "failed, errno = %d\n", errno);
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
-		if((err < 0) || !WIFSTOPPED(status) ||
-		   (WSTOPSIG(status) != SIGTRAP + 0x80)){
+		if ((err < 0) || !WIFSTOPPED(status) ||
+		   (WSTOPSIG(status) != SIGTRAP + 0x80)) {
                         err = ptrace_dump_regs(pid);
-                        if(err)
-                                printk("Failed to get registers from process, "
-                                       "errno = %d\n", -err);
+                        if (err)
+                                printk(UM_KERN_ERR "Failed to get registers "
+				       "from process, errno = %d\n", -err);
 			panic("handle_trap - failed to wait at end of syscall, "
 			      "errno = %d, status = %d\n", errno, status);
                 }
@@ -184,38 +179,39 @@ static int userspace_tramp(void *stack)
 
 	init_new_thread_signals();
 	err = set_interval(1);
-	if(err)
+	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
 		      err);
 
-	if(!proc_mm){
-		/* This has a pte, but it can't be mapped in with the usual
+	if (!proc_mm) {
+		/*
+		 * This has a pte, but it can't be mapped in with the usual
 		 * tlb_flush mechanism because this is part of that mechanism
 		 */
 		int fd;
-		__u64 offset;
+		unsigned long long offset;
 		fd = phys_mapping(to_phys(&__syscall_stub_start), &offset);
 		addr = mmap64((void *) UML_CONFIG_STUB_CODE, UM_KERN_PAGE_SIZE,
 			      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
-		if(addr == MAP_FAILED){
-			printk("mapping mmap stub failed, errno = %d\n",
-			       errno);
+		if (addr == MAP_FAILED) {
+			printk(UM_KERN_ERR "mapping mmap stub failed, "
+			       "errno = %d\n", errno);
 			exit(1);
 		}
 
-		if(stack != NULL){
+		if (stack != NULL) {
 			fd = phys_mapping(to_phys(stack), &offset);
 			addr = mmap((void *) UML_CONFIG_STUB_DATA,
 				    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 				    MAP_FIXED | MAP_SHARED, fd, offset);
-			if(addr == MAP_FAILED){
-				printk("mapping segfault stack failed, "
-				       "errno = %d\n", errno);
+			if (addr == MAP_FAILED) {
+				printk(UM_KERN_ERR "mapping segfault stack "
+				       "failed, errno = %d\n", errno);
 				exit(1);
 			}
 		}
 	}
-	if(!ptrace_faultinfo && (stack != NULL)){
+	if (!ptrace_faultinfo && (stack != NULL)) {
 		struct sigaction sa;
 
 		unsigned long v = UML_CONFIG_STUB_CODE +
@@ -232,13 +228,13 @@ static int userspace_tramp(void *stack)
 		sa.sa_flags = SA_ONSTACK;
 		sa.sa_handler = (void *) v;
 		sa.sa_restorer = NULL;
-		if(sigaction(SIGSEGV, &sa, NULL) < 0)
+		if (sigaction(SIGSEGV, &sa, NULL) < 0)
 			panic("userspace_tramp - setting SIGSEGV handler "
 			      "failed - errno = %d\n", errno);
 	}
 
 	os_stop_process(os_getpid());
-	return(0);
+	return 0;
 }
 
 /* Each element set once, and only accessed by a single processor anyway */
@@ -255,35 +251,38 @@ int start_userspace(unsigned long stub_s
 	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
 		     PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if(stack == MAP_FAILED)
+	if (stack == MAP_FAILED)
 		panic("start_userspace : mmap failed, errno = %d", errno);
 	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 
 	flags = CLONE_FILES | SIGCHLD;
-	if(proc_mm) flags |= CLONE_VM;
+	if (proc_mm)
+		flags |= CLONE_VM;
+
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
-	if(pid < 0)
+	if (pid < 0)
 		panic("start_userspace : clone failed, errno = %d", errno);
 
 	do {
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if(n < 0)
+		if (n < 0)
 			panic("start_userspace : wait failed, errno = %d",
 			      errno);
-	} while(WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
+	} while (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
 
-	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
+	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
 		panic("start_userspace : expected SIGSTOP, got status = %d",
 		      status);
 
-	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL, (void *)PTRACE_O_TRACESYSGOOD) < 0)
-		panic("start_userspace : PTRACE_OLDSETOPTIONS failed, errno=%d\n",
-		      errno);
+	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
+		   (void *) PTRACE_O_TRACESYSGOOD) < 0)
+		panic("start_userspace : PTRACE_OLDSETOPTIONS failed, "
+		      "errno = %d\n", errno);
 
-	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
+	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0)
 		panic("start_userspace : munmap failed, errno = %d\n", errno);
 
-	return(pid);
+	return pid;
 }
 
 void userspace(struct uml_pt_regs *regs)
@@ -292,7 +291,7 @@ void userspace(struct uml_pt_regs *regs)
 	/* To prevent races if using_sysemu changes under us.*/
 	int local_using_sysemu;
 
-	while(1){
+	while (1) {
 		restore_registers(pid, regs);
 
 		/* Now we set local_using_sysemu to be used for one loop */
@@ -302,13 +301,13 @@ void userspace(struct uml_pt_regs *regs)
 					     singlestepping(NULL));
 
 		err = ptrace(op, pid, 0, 0);
-		if(err)
+		if (err)
 			panic("userspace - could not resume userspace process, "
 			      "pid=%d, ptrace operation = %d, errno = %d\n",
 			      pid, op, errno);
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
-		if(err < 0)
+		if (err < 0)
 			panic("userspace - waitpid failed, errno = %d\n",
 			      errno);
 
@@ -316,12 +315,14 @@ void userspace(struct uml_pt_regs *regs)
 		save_registers(pid, regs);
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
-		if(WIFSTOPPED(status)){
+		if (WIFSTOPPED(status)) {
 			int sig = WSTOPSIG(status);
-		  	switch(sig){
+		  	switch(sig) {
 			case SIGSEGV:
-				if(PTRACE_FULL_FAULTINFO || !ptrace_faultinfo){
-					get_skas_faultinfo(pid, &regs->faultinfo);
+				if (PTRACE_FULL_FAULTINFO ||
+				    !ptrace_faultinfo) {
+					get_skas_faultinfo(pid,
+							   &regs->faultinfo);
 					(*sig_info[SIGSEGV])(SIGSEGV, regs);
 				}
 				else handle_segv(pid, regs);
@@ -343,14 +344,14 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-			        printk("userspace - child stopped with signal "
-				       "%d\n", sig);
+			        printk(UM_KERN_ERR "userspace - child stopped "
+				       "with signal %d\n", sig);
 			}
 			pid = userspace_pid[0];
 			interrupt_end();
 
 			/* Avoid -ERESTARTSYS handling in host */
-			if(PT_SYSCALL_NR_OFFSET != PT_SYSCALL_RET_OFFSET)
+			if (PT_SYSCALL_NR_OFFSET != PT_SYSCALL_RET_OFFSET)
 				PT_SYSCALL_NR(regs->regs) = -1;
 		}
 	}
@@ -384,7 +385,8 @@ int copy_context_skas0(unsigned long new
 	__u64 new_offset;
 	int new_fd = phys_mapping(to_phys((void *)new_stack), &new_offset);
 
-	/* prepare offset and fd of child's stack as argument for parent's
+	/*
+	 * prepare offset and fd of child's stack as argument for parent's
 	 * and child's mmap2 calls
 	 */
 	*data = ((struct stub_data) { .offset	= MMAP_OFFSET(new_offset),
@@ -393,28 +395,30 @@ int copy_context_skas0(unsigned long new
 					            { { 0, 1000000 / hz() },
 						      { 0, 1000000 / hz() }})});
 	err = ptrace_setregs(pid, thread_regs);
-	if(err < 0)
+	if (err < 0)
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
 		      "pid = %d, errno = %d\n", pid, -err);
 
 	/* set a well known return code for detection of child write failure */
 	child_data->err = 12345678;
 
-	/* Wait, until parent has finished its work: read child's pid from
+	/*
+	 * Wait, until parent has finished its work: read child's pid from
 	 * parent's stack, and check, if bad result.
 	 */
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if(err)
+	if (err)
 		panic("Failed to continue new process, pid = %d, "
 		      "errno = %d\n", pid, errno);
 	wait_stub_done(pid);
 
 	pid = data->err;
-	if(pid < 0)
+	if (pid < 0)
 		panic("copy_context_skas0 - stub-parent reports error %d\n",
 		      -pid);
 
-	/* Wait, until child has finished too: read child's result from
+	/*
+	 * Wait, until child has finished too: read child's result from
 	 * child's stack and check it.
 	 */
 	wait_stub_done(pid);
@@ -455,15 +459,16 @@ void map_stub_pages(int fd, unsigned lon
 					  .offset  = code_offset
 	} } });
 	CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
-	if(n != sizeof(mmop)){
+	if (n != sizeof(mmop)) {
 		n = errno;
-		printk("mmap args - addr = 0x%lx, fd = %d, offset = %llx\n",
-		       code, code_fd, (unsigned long long) code_offset);
+		printk(UM_KERN_ERR "mmap args - addr = 0x%lx, fd = %d, "
+		       "offset = %llx\n", code, code_fd,
+		       (unsigned long long) code_offset);
 		panic("map_stub_pages : /proc/mm map for code failed, "
 		      "err = %d\n", n);
 	}
 
-	if ( stack ) {
+	if (stack) {
 		__u64 map_offset;
 		int map_fd = phys_mapping(to_phys((void *)stack), &map_offset);
 		mmop = ((struct proc_mm_op)
@@ -478,7 +483,7 @@ void map_stub_pages(int fd, unsigned lon
 				      .offset  = map_offset
 		} } });
 		CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
-		if(n != sizeof(mmop))
+		if (n != sizeof(mmop))
 			panic("map_stub_pages : /proc/mm map for data failed, "
 			      "err = %d\n", errno);
 	}
@@ -498,7 +503,7 @@ void new_thread(void *stack, jmp_buf *bu
 
 void switch_threads(jmp_buf *me, jmp_buf *you)
 {
-	if(UML_SETJMP(me) == 0)
+	if (UML_SETJMP(me) == 0)
 		UML_LONGJMP(you, 1);
 }
 
@@ -526,7 +531,7 @@ int start_idle_thread(void *stack, jmp_b
 	 * after returning to the jumper.
 	 */
 	n = setjmp(initial_jmpbuf);
-	switch(n){
+	switch(n) {
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
 		(*switch_buf)[0].JB_SP = (unsigned long) stack +
@@ -538,10 +543,10 @@ int start_idle_thread(void *stack, jmp_b
 		break;
 	case INIT_JMP_HALT:
 		kmalloc_ok = 0;
-		return(0);
+		return 0;
 	case INIT_JMP_REBOOT:
 		kmalloc_ok = 0;
-		return(1);
+		return 1;
 	default:
 		panic("Bad sigsetjmp return in start_idle_thread - %d\n", n);
 	}
@@ -557,7 +562,7 @@ void initial_thread_cb_skas(void (*proc)
 	cb_back = &here;
 
 	block_signals();
-	if(UML_SETJMP(&here) == 0)
+	if (UML_SETJMP(&here) == 0)
 		UML_LONGJMP(&initial_jmpbuf, INIT_JMP_CALLBACK);
 	unblock_signals();
 
@@ -583,10 +588,10 @@ void __switch_mm(struct mm_id *mm_idp)
 	int err;
 
 	/* FIXME: need cpu pid in __switch_mm */
-	if(proc_mm){
+	if (proc_mm) {
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
-		if(err)
+		if (err)
 			panic("__switch_mm - PTRACE_SWITCH_MM failed, "
 			      "errno = %d\n", errno);
 	}
diff -puN arch/um/os-Linux/skas/trap.c~uml-style-fixes-pass-3 arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/skas/trap.c
@@ -1,19 +1,23 @@
 /*
- * Copyright (C) 2002 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <signal.h>
-#include <errno.h>
+#if 0
 #include "kern_util.h"
-#include "as-layout.h"
-#include "task.h"
-#include "sigcontext.h"
 #include "skas.h"
 #include "ptrace_user.h"
-#include "sysdep/ptrace.h"
 #include "sysdep/ptrace_user.h"
+#endif
+
+#include <errno.h>
+#include <signal.h>
+#include "sysdep/ptrace.h"
+#include "kern_constants.h"
+#include "as-layout.h"
 #include "os.h"
+#include "sigcontext.h"
+#include "task.h"
 
 static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
 
@@ -24,14 +28,16 @@ void sig_handler_common_skas(int sig, vo
 	void (*handler)(int, struct uml_pt_regs *);
 	int save_user, save_errno = errno;
 
-	/* This is done because to allow SIGSEGV to be delivered inside a SEGV
+	/*
+	 * This is done because to allow SIGSEGV to be delivered inside a SEGV
 	 * handler.  This can happen in copy_user, and if SEGV is disabled,
 	 * the process will die.
 	 * XXX Figure out why this is better than SA_NODEFER
 	 */
-	if(sig == SIGSEGV) {
+	if (sig == SIGSEGV) {
 		change_sig(SIGSEGV, 1);
-		/* For segfaults, we want the data from the
+		/*
+		 * For segfaults, we want the data from the
 		 * sigcontext.  In this case, we don't want to mangle
 		 * the process registers, so use a static set of
 		 * registers.  For other signals, the process
@@ -44,11 +50,9 @@ void sig_handler_common_skas(int sig, vo
 
 	save_user = r->is_user;
 	r->is_user = 0;
-	if ( sig == SIGFPE || sig == SIGSEGV ||
-	     sig == SIGBUS || sig == SIGILL ||
-	     sig == SIGTRAP ) {
+	if ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
+	    (sig == SIGILL) || (sig == SIGTRAP))
 		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
-	}
 
 	change_sig(SIGUSR1, 1);
 
diff -puN arch/um/os-Linux/start_up.c~uml-style-fixes-pass-3 arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/start_up.c
@@ -1,41 +1,29 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <pty.h>
 #include <stdio.h>
-#include <stddef.h>
-#include <stdarg.h>
 #include <stdlib.h>
-#include <string.h>
+#include <stdarg.h>
 #include <unistd.h>
-#include <signal.h>
-#include <sched.h>
-#include <fcntl.h>
 #include <errno.h>
-#include <sys/time.h>
-#include <sys/wait.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
+#include <string.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
+#include <sys/ptrace.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
 #include <asm/unistd.h>
-#include <sys/types.h>
-#include "kern_util.h"
-#include "user.h"
-#include "signal_kern.h"
-#include "sysdep/ptrace.h"
-#include "sysdep/sigcontext.h"
-#include "irq_user.h"
-#include "ptrace_user.h"
-#include "mem_user.h"
 #include "init.h"
-#include "os.h"
-#include "uml-config.h"
-#include "tempfile.h"
 #include "kern_constants.h"
-#include "skas.h"
-#include "skas_ptrace.h"
+#include "os.h"
+#include "mem_user.h"
+#include "ptrace_user.h"
 #include "registers.h"
+#include "skas_ptrace.h"
 
 static int ptrace_child(void *arg)
 {
@@ -44,26 +32,33 @@ static int ptrace_child(void *arg)
 	int sc_result;
 
 	change_sig(SIGWINCH, 0);
-	if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
+	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
 		perror("ptrace");
 		os_kill_process(pid, 0);
 	}
 	kill(pid, SIGSTOP);
 
-	/*This syscall will be intercepted by the parent. Don't call more than
-	 * once, please.*/
+	/*
+	 * This syscall will be intercepted by the parent. Don't call more than
+	 * once, please.
+	 */
 	sc_result = os_getpid();
 
 	if (sc_result == pid)
-		ret = 1; /*Nothing modified by the parent, we are running
-			   normally.*/
+		/* Nothing modified by the parent, we are running normally. */
+		ret = 1;
 	else if (sc_result == ppid)
-		ret = 0; /*Expected in check_ptrace and check_sysemu when they
-			   succeed in modifying the stack frame*/
+		/*
+		 * Expected in check_ptrace and check_sysemu when they succeed
+		 * in modifying the stack frame
+		 */
+		ret = 0;
 	else
-		ret = 2; /*Serious trouble! This could be caused by a bug in
-			   host 2.6 SKAS3/2.6 patch before release -V6, together
-			   with a bug in the UML code itself.*/
+		/* Serious trouble! This could be caused by a bug in host 2.6
+		 * SKAS3/2.6 patch before release -V6, together with a bug in
+		 * the UML code itself.
+		 */
+		ret = 2;
 	_exit(ret);
 }
 
@@ -104,16 +99,18 @@ static int start_ptraced_child(void **st
 	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
 		     PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if(stack == MAP_FAILED)
+	if (stack == MAP_FAILED)
 		fatal_perror("check_ptrace : mmap failed");
+
 	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
-	if(pid < 0)
+	if (pid < 0)
 		fatal_perror("start_ptraced_child : clone failed");
+
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-	if(n < 0)
+	if (n < 0)
 		fatal_perror("check_ptrace : clone failed");
-	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
+	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
 		fatal("check_ptrace : expected SIGSTOP, got status = %d",
 		      status);
 
@@ -132,10 +129,10 @@ static int stop_ptraced_child(int pid, v
 {
 	int status, n, ret = 0;
 
-	if(ptrace(PTRACE_CONT, pid, 0, 0) < 0)
+	if (ptrace(PTRACE_CONT, pid, 0, 0) < 0)
 		fatal_perror("stop_ptraced_child : ptrace failed");
 	CATCH_EINTR(n = waitpid(pid, &status, 0));
-	if(!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
+	if (!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
 		int exit_with = WEXITSTATUS(status);
 		if (exit_with == 2)
 			non_fatal("check_ptrace : child exited with status 2. "
@@ -148,7 +145,7 @@ static int stop_ptraced_child(int pid, v
 		ret = -1;
 	}
 
-	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
+	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0)
 		fatal_perror("check_ptrace : munmap failed");
 	return ret;
 }
@@ -209,26 +206,26 @@ static void __init check_sysemu(void)
 	sysemu_supported = 0;
 	pid = start_ptraced_child(&stack);
 
-	if(ptrace(PTRACE_SYSEMU, pid, 0, 0) < 0)
+	if (ptrace(PTRACE_SYSEMU, pid, 0, 0) < 0)
 		goto fail;
 
 	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 	if (n < 0)
 		fatal_perror("check_sysemu : wait failed");
-	if(!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
+	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
 		fatal("check_sysemu : expected SIGTRAP, got status = %d",
 		      status);
 
-	if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 		fatal_perror("check_sysemu : PTRACE_GETREGS failed");
-	if(PT_SYSCALL_NR(regs) != __NR_getpid){
+	if (PT_SYSCALL_NR(regs) != __NR_getpid) {
 		non_fatal("check_sysemu got system call number %d, "
 			  "expected %d...", PT_SYSCALL_NR(regs), __NR_getpid);
 		goto fail;
 	}
 
 	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
-	if(n < 0){
+	if (n < 0) {
 		non_fatal("check_sysemu : failed to modify system call "
 			  "return");
 		goto fail;
@@ -244,30 +241,31 @@ static void __init check_sysemu(void)
 	non_fatal("Checking advanced syscall emulation patch for ptrace...");
 	pid = start_ptraced_child(&stack);
 
-	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
+	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
 		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
 
-	while(1){
+	while (1) {
 		count++;
-		if(ptrace(PTRACE_SYSEMU_SINGLESTEP, pid, 0, 0) < 0)
+		if (ptrace(PTRACE_SYSEMU_SINGLESTEP, pid, 0, 0) < 0)
 			goto fail;
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if(n < 0)
+		if (n < 0)
 			fatal_perror("check_ptrace : wait failed");
 
-		if(WIFSTOPPED(status) && (WSTOPSIG(status) == (SIGTRAP|0x80))){
+		if (WIFSTOPPED(status) &&
+		    (WSTOPSIG(status) == (SIGTRAP|0x80))) {
 			if (!count)
 				fatal("check_ptrace : SYSEMU_SINGLESTEP "
 				      "doesn't singlestep");
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
 				   os_getpid());
-			if(n < 0)
+			if (n < 0)
 				fatal_perror("check_sysemu : failed to modify "
 					     "system call return");
 			break;
 		}
-		else if(WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
+		else if (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
 		else
 			fatal("check_ptrace : expected SIGTRAP or "
@@ -279,7 +277,7 @@ static void __init check_sysemu(void)
 	sysemu_supported = 2;
 	non_fatal("OK\n");
 
-	if ( !force_sysemu_disabled )
+	if (!force_sysemu_disabled)
 		set_using_sysemu(sysemu_supported);
 	return;
 
@@ -297,29 +295,29 @@ static void __init check_ptrace(void)
 	non_fatal("Checking that ptrace can change system call numbers...");
 	pid = start_ptraced_child(&stack);
 
-	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
+	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
 		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
 
-	while(1){
-		if(ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
+	while (1) {
+		if (ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
 			fatal_perror("check_ptrace : ptrace failed");
 
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-		if(n < 0)
+		if (n < 0)
 			fatal_perror("check_ptrace : wait failed");
 
-		if(!WIFSTOPPED(status) ||
+		if (!WIFSTOPPED(status) ||
 		   (WSTOPSIG(status) != (SIGTRAP | 0x80)))
 			fatal("check_ptrace : expected (SIGTRAP|0x80), "
 			       "got status = %d", status);
 
 		syscall = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_NR_OFFSET,
 				 0);
-		if(syscall == __NR_getpid){
+		if (syscall == __NR_getpid) {
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
 				   __NR_getppid);
-			if(n < 0)
+			if (n < 0)
 				fatal_perror("check_ptrace : failed to modify "
 					     "system call");
 			break;
@@ -337,18 +335,18 @@ static void __init check_coredump_limit(
 	struct rlimit lim;
 	int err = getrlimit(RLIMIT_CORE, &lim);
 
-	if(err){
+	if (err) {
 		perror("Getting core dump limit");
 		return;
 	}
 
 	printf("Core dump limits :\n\tsoft - ");
-	if(lim.rlim_cur == RLIM_INFINITY)
+	if (lim.rlim_cur == RLIM_INFINITY)
 		printf("NONE\n");
 	else printf("%lu\n", lim.rlim_cur);
 
 	printf("\thard - ");
-	if(lim.rlim_max == RLIM_INFINITY)
+	if (lim.rlim_max == RLIM_INFINITY)
 		printf("NONE\n");
 	else printf("%lu\n", lim.rlim_max);
 }
@@ -414,7 +412,7 @@ static inline void check_skas3_ptrace_fa
 	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
 	if (n < 0) {
 		ptrace_faultinfo = 0;
-		if(errno == EIO)
+		if (errno == EIO)
 			non_fatal("not found\n");
 		else
 			perror("not found");
@@ -446,7 +444,7 @@ static inline void check_skas3_ptrace_ld
 
 	n = ptrace(PTRACE_LDT, pid, 0, (unsigned long) &ldt_op);
 	if (n < 0) {
-		if(errno == EIO)
+		if (errno == EIO)
 			non_fatal("not found\n");
 		else {
 			perror("not found");
@@ -454,7 +452,7 @@ static inline void check_skas3_ptrace_ld
 		ptrace_ldt = 0;
 	}
 	else {
-		if(ptrace_ldt)
+		if (ptrace_ldt)
 			non_fatal("found\n");
 		else
 			non_fatal("found, but use is disabled\n");
@@ -477,12 +475,9 @@ static inline void check_skas3_proc_mm(v
 		proc_mm = 0;
 		perror("not found");
 	}
-	else {
-		if (!proc_mm)
-			non_fatal("found but disabled on command line\n");
-		else
-			non_fatal("found\n");
-	}
+	else if (!proc_mm)
+		non_fatal("found but disabled on command line\n");
+	else non_fatal("found\n");
 }
 
 int can_do_skas(void)
@@ -493,7 +488,7 @@ int can_do_skas(void)
 	check_skas3_ptrace_faultinfo();
 	check_skas3_ptrace_ldt();
 
-	if(!proc_mm || !ptrace_faultinfo || !ptrace_ldt)
+	if (!proc_mm || !ptrace_faultinfo || !ptrace_ldt)
 		skas_needs_stub = 1;
 
 	return 1;
@@ -508,25 +503,25 @@ int __init parse_iomem(char *str, int *a
 
 	driver = str;
 	file = strchr(str,',');
-	if(file == NULL){
+	if (file == NULL) {
 		printf("parse_iomem : failed to parse iomem\n");
 		goto out;
 	}
 	*file = '\0';
 	file++;
 	fd = open(file, O_RDWR, 0);
-	if(fd < 0){
+	if (fd < 0) {
 		os_print_error(fd, "parse_iomem - Couldn't open io file");
 		goto out;
 	}
 
-	if(fstat64(fd, &buf) < 0){
+	if (fstat64(fd, &buf) < 0) {
 		perror("parse_iomem - cannot stat_fd file");
 		goto out_close;
 	}
 
 	new = malloc(sizeof(*new));
-	if(new == NULL){
+	if (new == NULL) {
 		perror("Couldn't allocate iomem_region struct");
 		goto out_close;
 	}
diff -puN arch/um/os-Linux/trap.c~uml-style-fixes-pass-3 arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/trap.c
@@ -1,13 +1,11 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdlib.h>
 #include <signal.h>
-#include "kern_util.h"
 #include "os.h"
-#include "longjmp.h"
+#include "sysdep/ptrace.h"
 
 /* Initialized from linux_main() */
 void (*sig_info[NSIG])(int, struct uml_pt_regs *);
diff -puN arch/um/os-Linux/umid.c~uml-style-fixes-pass-3 arch/um/os-Linux/umid.c
--- a/arch/um/os-Linux/umid.c~uml-style-fixes-pass-3
+++ a/arch/um/os-Linux/umid.c
@@ -1,14 +1,19 @@
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
 #include <stdio.h>
-#include <unistd.h>
 #include <stdlib.h>
-#include <string.h>
+#include <dirent.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <signal.h>
-#include <dirent.h>
-#include <sys/fcntl.h>
+#include <string.h>
+#include <unistd.h>
 #include <sys/stat.h>
-#include <sys/param.h>
 #include "init.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "user.h"
 
@@ -27,13 +32,13 @@ static int __init make_uml_dir(void)
 	char dir[512] = { '\0' };
 	int len, err;
 
-	if(*uml_dir == '~'){
+	if (*uml_dir == '~') {
 		char *home = getenv("HOME");
 
 		err = -ENOENT;
-		if(home == NULL){
-			printk("make_uml_dir : no value in environment for "
-			       "$HOME\n");
+		if (home == NULL) {
+			printk(UM_KERN_ERR "make_uml_dir : no value in "
+			       "environment for $HOME\n");
 			goto err;
 		}
 		strlcpy(dir, home, sizeof(dir));
@@ -52,7 +57,7 @@ static int __init make_uml_dir(void)
 	}
 	strcpy(uml_dir, dir);
 
-	if((mkdir(uml_dir, 0777) < 0) && (errno != EEXIST)){
+	if ((mkdir(uml_dir, 0777) < 0) && (errno != EEXIST)) {
 	        printf("Failed to mkdir '%s': %s\n", uml_dir, strerror(errno));
 		err = -errno;
 		goto err_free;
@@ -69,8 +74,8 @@ err:
 /*
  * Unlinks the files contained in @dir and then removes @dir.
  * Doesn't handle directory trees, so it's not like rm -rf, but almost such. We
- * ignore ENOENT errors for anything (they happen, strangely enough - possibly due
- * to races between multiple dying UML threads).
+ * ignore ENOENT errors for anything (they happen, strangely enough - possibly
+ * due to races between multiple dying UML threads).
  */
 static int remove_files_and_dir(char *dir)
 {
@@ -115,7 +120,8 @@ out:
 	return ret;
 }
 
-/* This says that there isn't already a user of the specified directory even if
+/*
+ * This says that there isn't already a user of the specified directory even if
  * there are errors during the checking.  This is because if these errors
  * happen, the directory is unusable by the pre-existing UML, so we might as
  * well take it over.  This could happen either by
@@ -133,44 +139,45 @@ static inline int is_umdir_used(char *di
 	int dead, fd, p, n, err;
 
 	n = snprintf(file, sizeof(file), "%s/pid", dir);
-	if(n >= sizeof(file)){
-		printk("is_umdir_used - pid filename too long\n");
+	if (n >= sizeof(file)) {
+		printk(UM_KERN_ERR "is_umdir_used - pid filename too long\n");
 		err = -E2BIG;
 		goto out;
 	}
 
 	dead = 0;
 	fd = open(file, O_RDONLY);
-	if(fd < 0) {
+	if (fd < 0) {
 		fd = -errno;
-		if(fd != -ENOENT){
-			printk("is_umdir_used : couldn't open pid file '%s', "
-			       "err = %d\n", file, -fd);
+		if (fd != -ENOENT) {
+			printk(UM_KERN_ERR "is_umdir_used : couldn't open pid "
+			       "file '%s', err = %d\n", file, -fd);
 		}
 		goto out;
 	}
 
 	err = 0;
 	n = read(fd, pid, sizeof(pid));
-	if(n < 0){
-		printk("is_umdir_used : couldn't read pid file '%s', "
-		       "err = %d\n", file, errno);
+	if (n < 0) {
+		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		       "'%s', err = %d\n", file, errno);
 		goto out_close;
-	} else if(n == 0){
-		printk("is_umdir_used : couldn't read pid file '%s', "
-		       "0-byte read\n", file);
+	} else if (n == 0) {
+		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		       "'%s', 0-byte read\n", file);
 		goto out_close;
 	}
 
 	p = strtoul(pid, &end, 0);
-	if(end == pid){
-		printk("is_umdir_used : couldn't parse pid file '%s', "
-		       "errno = %d\n", file, errno);
+	if (end == pid) {
+		printk(UM_KERN_ERR "is_umdir_used : couldn't parse pid file "
+		       "'%s', errno = %d\n", file, errno);
 		goto out_close;
 	}
 
-	if((kill(p, 0) == 0) || (errno != ESRCH)){
-		printk("umid \"%s\" is already in use by pid %d\n", umid, p);
+	if ((kill(p, 0) == 0) || (errno != ESRCH)) {
+		printk(UM_KERN_ERR "umid \"%s\" is already in use by pid %d\n",
+		       umid, p);
 		return 1;
 	}
 
@@ -194,8 +201,8 @@ static int umdir_take_if_dead(char *dir)
 
 	ret = remove_files_and_dir(dir);
 	if (ret) {
-		printk("is_umdir_used - remove_files_and_dir failed with "
-		       "err = %d\n", ret);
+		printk(UM_KERN_ERR "is_umdir_used - remove_files_and_dir "
+		       "failed with err = %d\n", ret);
 	}
 	return ret;
 }
@@ -206,27 +213,28 @@ static void __init create_pid_file(void)
 	char pid[sizeof("nnnnn\0")];
 	int fd, n;
 
-	if(umid_file_name("pid", file, sizeof(file)))
+	if (umid_file_name("pid", file, sizeof(file)))
 		return;
 
 	fd = open(file, O_RDWR | O_CREAT | O_EXCL, 0644);
-	if(fd < 0){
-		printk("Open of machine pid file \"%s\" failed: %s\n",
-		       file, strerror(errno));
+	if (fd < 0) {
+		printk(UM_KERN_ERR "Open of machine pid file \"%s\" failed: "
+		       "%s\n", file, strerror(errno));
 		return;
 	}
 
 	snprintf(pid, sizeof(pid), "%d\n", getpid());
 	n = write(fd, pid, strlen(pid));
-	if(n != strlen(pid))
-		printk("Write of pid file failed - err = %d\n", errno);
+	if (n != strlen(pid))
+		printk(UM_KERN_ERR "Write of pid file failed - err = %d\n",
+		       errno);
 
 	close(fd);
 }
 
 int __init set_umid(char *name)
 {
-	if(strlen(name) > UMID_LEN - 1)
+	if (strlen(name) > UMID_LEN - 1)
 		return -E2BIG;
 
 	strlcpy(umid, name, sizeof(umid));
@@ -242,18 +250,18 @@ int __init make_umid(void)
 	int fd, err;
 	char tmp[256];
 
-	if(umid_setup)
+	if (umid_setup)
 		return 0;
 
 	make_uml_dir();
 
-	if(*umid == '\0'){
+	if (*umid == '\0') {
 		strlcpy(tmp, uml_dir, sizeof(tmp));
 		strlcat(tmp, "XXXXXX", sizeof(tmp));
 		fd = mkstemp(tmp);
-		if(fd < 0){
-			printk("make_umid - mkstemp(%s) failed: %s\n",
-			       tmp, strerror(errno));
+		if (fd < 0) {
+			printk(UM_KERN_ERR "make_umid - mkstemp(%s) failed: "
+			       "%s\n", tmp, strerror(errno));
 			err = -errno;
 			goto err;
 		}
@@ -262,11 +270,12 @@ int __init make_umid(void)
 
 		set_umid(&tmp[strlen(uml_dir)]);
 
-		/* There's a nice tiny little race between this unlink and
+		/*
+		 * There's a nice tiny little race between this unlink and
 		 * the mkdir below.  It'd be nice if there were a mkstemp
 		 * for directories.
 		 */
-		if(unlink(tmp)){
+		if (unlink(tmp)) {
 			err = -errno;
 			goto err;
 		}
@@ -274,9 +283,9 @@ int __init make_umid(void)
 
 	snprintf(tmp, sizeof(tmp), "%s%s", uml_dir, umid);
 	err = mkdir(tmp, 0777);
-	if(err < 0){
+	if (err < 0) {
 		err = -errno;
-		if(err != -EEXIST)
+		if (err != -EEXIST)
 			goto err;
 
 		if (umdir_take_if_dead(tmp) < 0)
@@ -284,9 +293,10 @@ int __init make_umid(void)
 
 		err = mkdir(tmp, 0777);
 	}
-	if(err){
+	if (err) {
 		err = -errno;
-		printk("Failed to create '%s' - err = %d\n", umid, -errno);
+		printk(UM_KERN_ERR "Failed to create '%s' - err = %d\n", umid,
+		       errno);
 		goto err;
 	}
 
@@ -301,14 +311,15 @@ int __init make_umid(void)
 
 static int __init make_umid_init(void)
 {
-	if(!make_umid())
+	if (!make_umid())
 		return 0;
 
-	/* If initializing with the given umid failed, then try again with
+	/*
+	 * If initializing with the given umid failed, then try again with
 	 * a random one.
 	 */
-	printk("Failed to initialize umid \"%s\", trying with a random umid\n",
-	       umid);
+	printk(UM_KERN_ERR "Failed to initialize umid \"%s\", trying with a "
+	       "random umid\n", umid);
 	*umid = '\0';
 	make_umid();
 
@@ -322,12 +333,12 @@ int __init umid_file_name(char *name, ch
 	int n, err;
 
 	err = make_umid();
-	if(err)
+	if (err)
 		return err;
 
 	n = snprintf(buf, len, "%s%s/%s", uml_dir, umid, name);
-	if(n >= len){
-		printk("umid_file_name : buffer too short\n");
+	if (n >= len) {
+		printk(UM_KERN_ERR "umid_file_name : buffer too short\n");
 		return -E2BIG;
 	}
 
@@ -341,21 +352,22 @@ char *get_umid(void)
 
 static int __init set_uml_dir(char *name, int *add)
 {
-	if(*name == '\0'){
+	if (*name == '\0') {
 		printf("uml_dir can't be an empty string\n");
 		return 0;
 	}
 
-	if(name[strlen(name) - 1] == '/'){
+	if (name[strlen(name) - 1] == '/') {
 		uml_dir = name;
 		return 0;
 	}
 
 	uml_dir = malloc(strlen(name) + 2);
-	if(uml_dir == NULL){
+	if (uml_dir == NULL) {
 		printf("Failed to malloc uml_dir - error = %d\n", errno);
 
-		/* Return 0 here because do_initcalls doesn't look at
+		/*
+		 * Return 0 here because do_initcalls doesn't look at
 		 * the return value.
 		 */
 		return 0;
@@ -376,7 +388,7 @@ static void remove_umid_dir(void)
 
 	sprintf(dir, "%s%s", uml_dir, umid);
 	err = remove_files_and_dir(dir);
-	if(err)
+	if (err)
 		printf("remove_umid_dir - remove_files_and_dir failed with "
 		       "err = %d\n", err);
 }
diff -puN arch/um/sys-i386/bugs.c~uml-style-fixes-pass-3 arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/bugs.c
@@ -1,18 +1,15 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <unistd.h>
 #include <errno.h>
+#include <signal.h>
 #include <string.h>
-#include <sys/signal.h>
-#include <asm/ldt.h>
-#include "kern_util.h"
-#include "user.h"
-#include "sysdep/ptrace.h"
-#include "task.h"
+#include "kern_constants.h"
 #include "os.h"
+#include "task.h"
+#include "user.h"
 
 #define MAXTOKEN 64
 
@@ -30,18 +27,20 @@ static char token(int fd, char *buf, int
 	do {
 		n = os_read_file(fd, ptr, sizeof(*ptr));
 		c = *ptr++;
-		if(n != sizeof(*ptr)){
-			if(n == 0)
+		if (n != sizeof(*ptr)) {
+			if (n == 0)
 				return 0;
-			printk("Reading /proc/cpuinfo failed, err = %d\n", -n);
-			if(n < 0)
+			printk(UM_KERN_ERR "Reading /proc/cpuinfo failed, "
+			       "err = %d\n", -n);
+			if (n < 0)
 				return n;
 			else return -EIO;
 		}
-	} while((c != '\n') && (c != stop) && (ptr < end));
+	} while ((c != '\n') && (c != stop) && (ptr < end));
 
-	if(ptr == end){
-		printk("Failed to find '%c' in /proc/cpuinfo\n", stop);
+	if (ptr == end) {
+		printk(UM_KERN_ERR "Failed to find '%c' in /proc/cpuinfo\n",
+		       stop);
 		return -1;
 	}
 	*(ptr - 1) = '\0';
@@ -54,26 +53,27 @@ static int find_cpuinfo_line(int fd, cha
 	char c;
 
 	scratch[len - 1] = '\0';
-	while(1){
+	while (1) {
 		c = token(fd, scratch, len - 1, ':');
-		if(c <= 0)
+		if (c <= 0)
 			return 0;
-		else if(c != ':'){
-			printk("Failed to find ':' in /proc/cpuinfo\n");
+		else if (c != ':') {
+			printk(UM_KERN_ERR "Failed to find ':' in "
+			       "/proc/cpuinfo\n");
 			return 0;
 		}
 
-		if(!strncmp(scratch, key, strlen(key)))
+		if (!strncmp(scratch, key, strlen(key)))
 			return 1;
 
 		do {
 			n = os_read_file(fd, &c, sizeof(c));
-			if(n != sizeof(c)){
-				printk("Failed to find newline in "
+			if (n != sizeof(c)) {
+				printk(UM_KERN_ERR "Failed to find newline in "
 				       "/proc/cpuinfo, err = %d\n", -n);
 				return 0;
 			}
-		} while(c != '\n');
+		} while (c != '\n');
 	}
 	return 0;
 }
@@ -83,46 +83,50 @@ static int check_cpu_flag(char *feature,
 	char buf[MAXTOKEN], c;
 	int fd, len = ARRAY_SIZE(buf);
 
-	printk("Checking for host processor %s support...", feature);
+	printk(UM_KERN_INFO "Checking for host processor %s support...",
+	       feature);
 	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open /proc/cpuinfo, err = %d\n", -fd);
+	if (fd < 0) {
+		printk(UM_KERN_ERR "Couldn't open /proc/cpuinfo, err = %d\n",
+		       -fd);
 		return 0;
 	}
 
 	*have_it = 0;
-	if(!find_cpuinfo_line(fd, "flags", buf, ARRAY_SIZE(buf)))
+	if (!find_cpuinfo_line(fd, "flags", buf, ARRAY_SIZE(buf)))
 		goto out;
 
 	c = token(fd, buf, len - 1, ' ');
-	if(c < 0)
+	if (c < 0)
 		goto out;
-	else if(c != ' '){
-		printk("Failed to find ' ' in /proc/cpuinfo\n");
+	else if (c != ' ') {
+		printk(UM_KERN_ERR "Failed to find ' ' in /proc/cpuinfo\n");
 		goto out;
 	}
 
-	while(1){
+	while (1) {
 		c = token(fd, buf, len - 1, ' ');
-		if(c < 0)
+		if (c < 0)
 			goto out;
-		else if(c == '\n') break;
+		else if (c == '\n')
+			break;
 
-		if(!strcmp(buf, feature)){
+		if (!strcmp(buf, feature)) {
 			*have_it = 1;
 			goto out;
 		}
 	}
  out:
-	if(*have_it == 0)
+	if (*have_it == 0)
 		printk("No\n");
-	else if(*have_it == 1)
+	else if (*have_it == 1)
 		printk("Yes\n");
 	os_close_file(fd);
 	return 1;
 }
 
-#if 0 /* This doesn't work in tt mode, plus it's causing compilation problems
+#if 0 /*
+       * This doesn't work in tt mode, plus it's causing compilation problems
        * for some people.
        */
 static void disable_lcall(void)
@@ -135,8 +139,9 @@ static void disable_lcall(void)
 	ldt.base_addr = 0;
 	ldt.limit = 0;
 	err = modify_ldt(1, &ldt, sizeof(ldt));
-	if(err)
-		printk("Failed to disable lcall7 - errno = %d\n", errno);
+	if (err)
+		printk(UM_KERN_ERR "Failed to disable lcall7 - errno = %d\n",
+		       errno);
 }
 #endif
 
@@ -151,14 +156,14 @@ void arch_check_bugs(void)
 {
 	int have_it;
 
-	if(os_access("/proc/cpuinfo", OS_ACC_R_OK) < 0){
-		printk("/proc/cpuinfo not available - skipping CPU capability "
-		       "checks\n");
+	if (os_access("/proc/cpuinfo", OS_ACC_R_OK) < 0) {
+		printk(UM_KERN_ERR "/proc/cpuinfo not available - skipping CPU "
+		       "capability checks\n");
 		return;
 	}
-	if(check_cpu_flag("cmov", &have_it))
+	if (check_cpu_flag("cmov", &have_it))
 		host_has_cmov = have_it;
-	if(check_cpu_flag("xmm", &have_it))
+	if (check_cpu_flag("xmm", &have_it))
 		host_has_xmm = have_it;
 }
 
@@ -166,25 +171,26 @@ int arch_handle_signal(int sig, struct u
 {
 	unsigned char tmp[2];
 
-	/* This is testing for a cmov (0x0f 0x4x) instruction causing a
+	/*
+	 * This is testing for a cmov (0x0f 0x4x) instruction causing a
 	 * SIGILL in init.
 	 */
-	if((sig != SIGILL) || (TASK_PID(get_current()) != 1))
+	if ((sig != SIGILL) || (TASK_PID(get_current()) != 1))
 		return 0;
 
 	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2))
 		panic("SIGILL in init, could not read instructions!\n");
-	if((tmp[0] != 0x0f) || ((tmp[1] & 0xf0) != 0x40))
+	if ((tmp[0] != 0x0f) || ((tmp[1] & 0xf0) != 0x40))
 		return 0;
 
-	if(host_has_cmov == 0)
+	if (host_has_cmov == 0)
 		panic("SIGILL caused by cmov, which this processor doesn't "
 		      "implement, boot a filesystem compiled for older "
 		      "processors");
-	else if(host_has_cmov == 1)
+	else if (host_has_cmov == 1)
 		panic("SIGILL caused by cmov, which this processor claims to "
 		      "implement");
-	else if(host_has_cmov == -1)
+	else if (host_has_cmov == -1)
 		panic("SIGILL caused by cmov, couldn't tell if this processor "
 		      "implements it, boot a filesystem compiled for older "
 		      "processors");
diff -puN arch/um/sys-i386/fault.c~uml-style-fixes-pass-3 arch/um/sys-i386/fault.c
--- a/arch/um/sys-i386/fault.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/fault.c
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2002 - 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -20,9 +20,9 @@ int arch_fixup(unsigned long address, st
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if(fixup != 0){
+	if (fixup != 0) {
 		UPT_IP(regs) = fixup->fixup;
-		return(1);
+		return 1;
 	}
-	return(0);
+	return 0;
 }
diff -puN arch/um/sys-i386/ldt.c~uml-style-fixes-pass-3 arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/ldt.c
@@ -1,34 +1,26 @@
 /*
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/slab.h"
-#include "linux/types.h"
-#include "linux/errno.h"
-#include "linux/spinlock.h"
-#include "asm/uaccess.h"
-#include "asm/smp.h"
-#include "asm/ldt.h"
+#include "linux/mm.h"
 #include "asm/unistd.h"
-#include "kern.h"
 #include "os.h"
-
-extern int modify_ldt(int func, void *ptr, unsigned long bytecount);
-
+#include "proc_mm.h"
 #include "skas.h"
 #include "skas_ptrace.h"
-#include "asm/mmu_context.h"
-#include "proc_mm.h"
+#include "sysdep/tls.h"
+
+extern int modify_ldt(int func, void *ptr, unsigned long bytecount);
 
 long write_ldt_entry(struct mm_id * mm_idp, int func, struct user_desc * desc,
 		     void **addr, int done)
 {
 	long res;
 
-	if(proc_mm){
-		/* This is a special handling for the case, that the mm to
+	if (proc_mm) {
+		/*
+		 * This is a special handling for the case, that the mm to
 		 * modify isn't current->active_mm.
 		 * If this is called directly by modify_ldt,
 		 *     (current->active_mm->context.skas.u == mm_idp)
@@ -40,12 +32,12 @@ long write_ldt_entry(struct mm_id * mm_i
 		 *
 		 * Note: I'm unsure: should interrupts be disabled here?
 		 */
-		if(!current->active_mm || current->active_mm == &init_mm ||
-		   mm_idp != &current->active_mm->context.skas.id)
+		if (!current->active_mm || current->active_mm == &init_mm ||
+		    mm_idp != &current->active_mm->context.skas.id)
 			__switch_mm(mm_idp);
 	}
 
-	if(ptrace_ldt) {
+	if (ptrace_ldt) {
 		struct ptrace_ldt ldt_op = (struct ptrace_ldt) {
 			.func = func,
 			.ptr = desc,
@@ -53,7 +45,7 @@ long write_ldt_entry(struct mm_id * mm_i
 		u32 cpu;
 		int pid;
 
-		if(!proc_mm)
+		if (!proc_mm)
 			pid = mm_idp->u.pid;
 		else {
 			cpu = get_cpu();
@@ -62,7 +54,7 @@ long write_ldt_entry(struct mm_id * mm_i
 
 		res = os_ptrace_ldt(pid, 0, (unsigned long) &ldt_op);
 
-		if(proc_mm)
+		if (proc_mm)
 			put_cpu();
 	}
 	else {
@@ -71,7 +63,7 @@ long write_ldt_entry(struct mm_id * mm_i
 					(sizeof(*desc) + sizeof(long) - 1) &
 					    ~(sizeof(long) - 1),
 					addr, &stub_addr);
-		if(!res){
+		if (!res) {
 			unsigned long args[] = { func,
 						 (unsigned long)stub_addr,
 						 sizeof(*desc),
@@ -81,12 +73,13 @@ long write_ldt_entry(struct mm_id * mm_i
 		}
 	}
 
-	if(proc_mm){
-		/* This is the second part of special handling, that makes
+	if (proc_mm) {
+		/*
+		 * This is the second part of special handling, that makes
 		 * PTRACE_LDT possible to implement.
 		 */
-		if(current->active_mm && current->active_mm != &init_mm &&
-		   mm_idp != &current->active_mm->context.skas.id)
+		if (current->active_mm && current->active_mm != &init_mm &&
+		    mm_idp != &current->active_mm->context.skas.id)
 			__switch_mm(&current->active_mm->context.skas.id);
 	}
 
@@ -102,21 +95,22 @@ static long read_ldt_from_host(void __us
 			.ptr = kmalloc(bytecount, GFP_KERNEL)};
 	u32 cpu;
 
-	if(ptrace_ldt.ptr == NULL)
+	if (ptrace_ldt.ptr == NULL)
 		return -ENOMEM;
 
-	/* This is called from sys_modify_ldt only, so userspace_pid gives
+	/*
+	 * This is called from sys_modify_ldt only, so userspace_pid gives
 	 * us the right number
 	 */
 
 	cpu = get_cpu();
 	res = os_ptrace_ldt(userspace_pid[cpu], 0, (unsigned long) &ptrace_ldt);
 	put_cpu();
-	if(res < 0)
+	if (res < 0)
 		goto out;
 
 	n = copy_to_user(ptr, ptrace_ldt.ptr, res);
-	if(n != 0)
+	if (n != 0)
 		res = -EFAULT;
 
   out:
@@ -143,33 +137,32 @@ static int read_ldt(void __user * ptr, u
 	unsigned long size;
 	uml_ldt_t * ldt = &current->mm->context.skas.ldt;
 
-	if(!ldt->entry_count)
+	if (!ldt->entry_count)
 		goto out;
-	if(bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
+	if (bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
 		bytecount = LDT_ENTRY_SIZE*LDT_ENTRIES;
 	err = bytecount;
 
-	if(ptrace_ldt){
+	if (ptrace_ldt)
 		return read_ldt_from_host(ptr, bytecount);
-	}
 
 	down(&ldt->semaphore);
-	if(ldt->entry_count <= LDT_DIRECT_ENTRIES){
+	if (ldt->entry_count <= LDT_DIRECT_ENTRIES) {
 		size = LDT_ENTRY_SIZE*LDT_DIRECT_ENTRIES;
-		if(size > bytecount)
+		if (size > bytecount)
 			size = bytecount;
-		if(copy_to_user(ptr, ldt->u.entries, size))
+		if (copy_to_user(ptr, ldt->u.entries, size))
 			err = -EFAULT;
 		bytecount -= size;
 		ptr += size;
 	}
 	else {
-		for(i=0; i<ldt->entry_count/LDT_ENTRIES_PER_PAGE && bytecount;
-			 i++){
+		for (i=0; i<ldt->entry_count/LDT_ENTRIES_PER_PAGE && bytecount;
+		     i++) {
 			size = PAGE_SIZE;
-			if(size > bytecount)
+			if (size > bytecount)
 				size = bytecount;
-			if(copy_to_user(ptr, ldt->u.pages[i], size)){
+			if (copy_to_user(ptr, ldt->u.pages[i], size)) {
 				err = -EFAULT;
 				break;
 			}
@@ -179,10 +172,10 @@ static int read_ldt(void __user * ptr, u
 	}
 	up(&ldt->semaphore);
 
-	if(bytecount == 0 || err == -EFAULT)
+	if (bytecount == 0 || err == -EFAULT)
 		goto out;
 
-	if(clear_user(ptr, bytecount))
+	if (clear_user(ptr, bytecount))
 		err = -EFAULT;
 
 out:
@@ -193,15 +186,16 @@ static int read_default_ldt(void __user 
 {
 	int err;
 
-	if(bytecount > 5*LDT_ENTRY_SIZE)
+	if (bytecount > 5*LDT_ENTRY_SIZE)
 		bytecount = 5*LDT_ENTRY_SIZE;
 
 	err = bytecount;
-	/* UML doesn't support lcall7 and lcall27.
+	/*
+	 * UML doesn't support lcall7 and lcall27.
 	 * So, we don't really have a default ldt, but emulate
 	 * an empty ldt of common host default ldt size.
 	 */
-	if(clear_user(ptr, bytecount))
+	if (clear_user(ptr, bytecount))
 		err = -EFAULT;
 
 	return err;
@@ -217,52 +211,52 @@ static int write_ldt(void __user * ptr, 
 	void *addr = NULL;
 
 	err = -EINVAL;
-	if(bytecount != sizeof(ldt_info))
+	if (bytecount != sizeof(ldt_info))
 		goto out;
 	err = -EFAULT;
-	if(copy_from_user(&ldt_info, ptr, sizeof(ldt_info)))
+	if (copy_from_user(&ldt_info, ptr, sizeof(ldt_info)))
 		goto out;
 
 	err = -EINVAL;
-	if(ldt_info.entry_number >= LDT_ENTRIES)
+	if (ldt_info.entry_number >= LDT_ENTRIES)
 		goto out;
-	if(ldt_info.contents == 3){
+	if (ldt_info.contents == 3) {
 		if (func == 1)
 			goto out;
 		if (ldt_info.seg_not_present == 0)
 			goto out;
 	}
 
-        if(!ptrace_ldt)
-                down(&ldt->semaphore);
+	if (!ptrace_ldt)
+		down(&ldt->semaphore);
 
 	err = write_ldt_entry(mm_idp, func, &ldt_info, &addr, 1);
-	if(err)
+	if (err)
 		goto out_unlock;
-        else if(ptrace_ldt) {
-	/* With PTRACE_LDT available, this is used as a flag only */
-                ldt->entry_count = 1;
-                goto out;
-        }
-
-	if(ldt_info.entry_number >= ldt->entry_count &&
-	   ldt_info.entry_number >= LDT_DIRECT_ENTRIES){
-		for(i=ldt->entry_count/LDT_ENTRIES_PER_PAGE;
-		    i*LDT_ENTRIES_PER_PAGE <= ldt_info.entry_number;
-		    i++){
-			if(i == 0)
+	else if (ptrace_ldt) {
+		/* With PTRACE_LDT available, this is used as a flag only */
+		ldt->entry_count = 1;
+		goto out;
+	}
+
+	if (ldt_info.entry_number >= ldt->entry_count &&
+	    ldt_info.entry_number >= LDT_DIRECT_ENTRIES) {
+		for (i=ldt->entry_count/LDT_ENTRIES_PER_PAGE;
+		     i*LDT_ENTRIES_PER_PAGE <= ldt_info.entry_number;
+		     i++) {
+			if (i == 0)
 				memcpy(&entry0, ldt->u.entries,
 				       sizeof(entry0));
 			ldt->u.pages[i] = (struct ldt_entry *)
 				__get_free_page(GFP_KERNEL|__GFP_ZERO);
-			if(!ldt->u.pages[i]){
+			if (!ldt->u.pages[i]) {
 				err = -ENOMEM;
 				/* Undo the change in host */
 				memset(&ldt_info, 0, sizeof(ldt_info));
 				write_ldt_entry(mm_idp, 1, &ldt_info, &addr, 1);
 				goto out_unlock;
 			}
-			if(i == 0) {
+			if (i == 0) {
 				memcpy(ldt->u.pages[0], &entry0,
 				       sizeof(entry0));
 				memcpy(ldt->u.pages[0]+1, ldt->u.entries+1,
@@ -271,17 +265,17 @@ static int write_ldt(void __user * ptr, 
 			ldt->entry_count = (i + 1) * LDT_ENTRIES_PER_PAGE;
 		}
 	}
-	if(ldt->entry_count <= ldt_info.entry_number)
+	if (ldt->entry_count <= ldt_info.entry_number)
 		ldt->entry_count = ldt_info.entry_number + 1;
 
-	if(ldt->entry_count <= LDT_DIRECT_ENTRIES)
+	if (ldt->entry_count <= LDT_DIRECT_ENTRIES)
 		ldt_p = ldt->u.entries + ldt_info.entry_number;
 	else
 		ldt_p = ldt->u.pages[ldt_info.entry_number/LDT_ENTRIES_PER_PAGE] +
 			ldt_info.entry_number%LDT_ENTRIES_PER_PAGE;
 
-	if(ldt_info.base_addr == 0 && ldt_info.limit == 0 &&
-	   (func == 1 || LDT_empty(&ldt_info))){
+	if (ldt_info.base_addr == 0 && ldt_info.limit == 0 &&
+	   (func == 1 || LDT_empty(&ldt_info))) {
 		ldt_p->a = 0;
 		ldt_p->b = 0;
 	}
@@ -332,7 +326,7 @@ static void ldt_get_host_info(void)
 
 	spin_lock(&host_ldt_lock);
 
-	if(host_ldt_entries != NULL){
+	if (host_ldt_entries != NULL) {
 		spin_unlock(&host_ldt_lock);
 		return;
 	}
@@ -340,49 +334,49 @@ static void ldt_get_host_info(void)
 
 	spin_unlock(&host_ldt_lock);
 
-	for(i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++);
+	for (i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++)
+		;
 
 	ldt = (struct ldt_entry *)
 	      __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
-	if(ldt == NULL) {
-		printk("ldt_get_host_info: couldn't allocate buffer for host "
-		       "ldt\n");
+	if (ldt == NULL) {
+		printk(KERN_ERR "ldt_get_host_info: couldn't allocate buffer "
+		       "for host ldt\n");
 		return;
 	}
 
 	ret = modify_ldt(0, ldt, (1<<order)*PAGE_SIZE);
-	if(ret < 0) {
-		printk("ldt_get_host_info: couldn't read host ldt\n");
+	if (ret < 0) {
+		printk(KERN_ERR "ldt_get_host_info: couldn't read host ldt\n");
 		goto out_free;
 	}
-	if(ret == 0) {
+	if (ret == 0) {
 		/* default_ldt is active, simply write an empty entry 0 */
 		host_ldt_entries = dummy_list;
 		goto out_free;
 	}
 
-	for(i=0, size=0; i<ret/LDT_ENTRY_SIZE; i++){
-		if(ldt[i].a != 0 || ldt[i].b != 0)
+	for (i=0, size=0; i<ret/LDT_ENTRY_SIZE; i++) {
+		if (ldt[i].a != 0 || ldt[i].b != 0)
 			size++;
 	}
 
-	if(size < ARRAY_SIZE(dummy_list))
+	if (size < ARRAY_SIZE(dummy_list))
 		host_ldt_entries = dummy_list;
 	else {
 		size = (size + 1) * sizeof(dummy_list[0]);
 		tmp = kmalloc(size, GFP_KERNEL);
-		if(tmp == NULL) {
-			printk("ldt_get_host_info: couldn't allocate host ldt "
-			       "list\n");
+		if (tmp == NULL) {
+			printk(KERN_ERR "ldt_get_host_info: couldn't allocate "
+			       "host ldt list\n");
 			goto out_free;
 		}
 		host_ldt_entries = tmp;
 	}
 
-	for(i=0, k=0; i<ret/LDT_ENTRY_SIZE; i++){
-		if(ldt[i].a != 0 || ldt[i].b != 0) {
+	for (i=0, k=0; i<ret/LDT_ENTRY_SIZE; i++) {
+		if (ldt[i].a != 0 || ldt[i].b != 0)
 			host_ldt_entries[k++] = i;
-		}
 	}
 	host_ldt_entries[k] = -1;
 
@@ -401,15 +395,15 @@ long init_new_ldt(struct mmu_context_ska
 	struct proc_mm_op copy;
 
 
-	if(!ptrace_ldt)
+	if (!ptrace_ldt)
 		init_MUTEX(&new_mm->ldt.semaphore);
 
-	if(!from_mm){
+	if (!from_mm) {
 		memset(&desc, 0, sizeof(desc));
 		/*
 		 * We have to initialize a clean ldt.
 		 */
-		if(proc_mm) {
+		if (proc_mm) {
 			/*
 			 * If the new mm was created using proc_mm, host's
 			 * default-ldt currently is assigned, which normally
@@ -417,8 +411,7 @@ long init_new_ldt(struct mmu_context_ska
 			 * To remove these gates, we simply write an empty
 			 * entry as number 0 to the host.
 			 */
-			err = write_ldt_entry(&new_mm->id, 1, &desc,
-					      &addr, 1);
+			err = write_ldt_entry(&new_mm->id, 1, &desc, &addr, 1);
 		}
 		else{
 			/*
@@ -427,11 +420,11 @@ long init_new_ldt(struct mmu_context_ska
 			 * will be reset in the following loop
 			 */
 			ldt_get_host_info();
-			for(num_p=host_ldt_entries; *num_p != -1; num_p++){
+			for (num_p=host_ldt_entries; *num_p != -1; num_p++) {
 				desc.entry_number = *num_p;
 				err = write_ldt_entry(&new_mm->id, 1, &desc,
 						      &addr, *(num_p + 1) == -1);
-				if(err)
+				if (err)
 					break;
 			}
 		}
@@ -440,8 +433,9 @@ long init_new_ldt(struct mmu_context_ska
 		goto out;
 	}
 
-	if(proc_mm){
-		/* We have a valid from_mm, so we now have to copy the LDT of
+	if (proc_mm) {
+		/*
+		 * We have a valid from_mm, so we now have to copy the LDT of
 		 * from_mm to new_mm, because using proc_mm an new mm with
 		 * an empty/default LDT was created in new_mm()
 		 */
@@ -450,27 +444,27 @@ long init_new_ldt(struct mmu_context_ska
 					      { .copy_segments =
 							from_mm->id.u.mm_fd } } );
 		i = os_write_file(new_mm->id.u.mm_fd, &copy, sizeof(copy));
-		if(i != sizeof(copy))
-			printk("new_mm : /proc/mm copy_segments failed, "
-			       "err = %d\n", -i);
+		if (i != sizeof(copy))
+			printk(KERN_ERR "new_mm : /proc/mm copy_segments "
+			       "failed, err = %d\n", -i);
 	}
 
-	if(!ptrace_ldt) {
-		/* Our local LDT is used to supply the data for
+	if (!ptrace_ldt) {
+		/*
+		 * Our local LDT is used to supply the data for
 		 * modify_ldt(READLDT), if PTRACE_LDT isn't available,
 		 * i.e., we have to use the stub for modify_ldt, which
 		 * can't handle the big read buffer of up to 64kB.
 		 */
 		down(&from_mm->ldt.semaphore);
-		if(from_mm->ldt.entry_count <= LDT_DIRECT_ENTRIES){
+		if (from_mm->ldt.entry_count <= LDT_DIRECT_ENTRIES)
 			memcpy(new_mm->ldt.u.entries, from_mm->ldt.u.entries,
 			       sizeof(new_mm->ldt.u.entries));
-		}
-		else{
+		else {
 			i = from_mm->ldt.entry_count / LDT_ENTRIES_PER_PAGE;
-			while(i-->0){
+			while (i-->0) {
 				page = __get_free_page(GFP_KERNEL|__GFP_ZERO);
-				if (!page){
+				if (!page) {
 					err = -ENOMEM;
 					break;
 				}
@@ -493,11 +487,10 @@ void free_ldt(struct mmu_context_skas * 
 {
 	int i;
 
-	if(!ptrace_ldt && mm->ldt.entry_count > LDT_DIRECT_ENTRIES){
+	if (!ptrace_ldt && mm->ldt.entry_count > LDT_DIRECT_ENTRIES) {
 		i = mm->ldt.entry_count / LDT_ENTRIES_PER_PAGE;
-		while(i-- > 0){
-			free_page((long )mm->ldt.u.pages[i]);
-		}
+		while (i-- > 0)
+			free_page((long) mm->ldt.u.pages[i]);
 	}
 	mm->ldt.entry_count = 0;
 }
diff -puN arch/um/sys-i386/ptrace.c~uml-style-fixes-pass-3 arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/ptrace.c
@@ -1,18 +1,11 @@
-/* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <linux/compiler.h>
-#include "linux/sched.h"
 #include "linux/mm.h"
-#include "asm/elf.h"
-#include "asm/ptrace.h"
+#include "linux/sched.h"
 #include "asm/uaccess.h"
-#include "asm/unistd.h"
-#include "sysdep/ptrace.h"
-#include "sysdep/sigcontext.h"
-#include "sysdep/sc.h"
 
 extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
 
@@ -23,7 +16,8 @@ void arch_switch_to(struct task_struct *
 		return;
 
 	if (err != -EINVAL)
-		printk(KERN_WARNING "arch_switch_tls failed, errno %d, not EINVAL\n", -err);
+		printk(KERN_WARNING "arch_switch_tls failed, errno %d, "
+		       "not EINVAL\n", -err);
 	else
 		printk(KERN_WARNING "arch_switch_tls failed, errno = EINVAL\n");
 }
@@ -34,21 +28,21 @@ int is_syscall(unsigned long addr)
 	int n;
 
 	n = copy_from_user(&instr, (void __user *) addr, sizeof(instr));
-	if(n){
+	if (n) {
 		/* access_process_vm() grants access to vsyscall and stub,
 		 * while copy_from_user doesn't. Maybe access_process_vm is
 		 * slow, but that doesn't matter, since it will be called only
 		 * in case of singlestepping, if copy_from_user failed.
 		 */
 		n = access_process_vm(current, addr, &instr, sizeof(instr), 0);
-		if(n != sizeof(instr)) {
-			printk("is_syscall : failed to read instruction from "
-			       "0x%lx\n", addr);
-			return(1);
+		if (n != sizeof(instr)) {
+			printk(KERN_ERR "is_syscall : failed to read "
+			       "instruction from 0x%lx\n", addr);
+			return 1;
 		}
 	}
 	/* int 0x80 or sysenter */
-	return((instr == 0x80cd) || (instr == 0x340f));
+	return (instr == 0x80cd) || (instr == 0x340f);
 }
 
 /* determines which flags the user has access to. */
@@ -92,21 +86,21 @@ int putreg(struct task_struct *child, in
 
 int poke_user(struct task_struct *child, long addr, long data)
 {
-        if ((addr & 3) || addr < 0)
-                return -EIO;
-
-        if (addr < MAX_REG_OFFSET)
-                return putreg(child, addr, data);
+	if ((addr & 3) || addr < 0)
+		return -EIO;
 
-        else if((addr >= offsetof(struct user, u_debugreg[0])) &&
-                (addr <= offsetof(struct user, u_debugreg[7]))){
-                addr -= offsetof(struct user, u_debugreg[0]);
-                addr = addr >> 2;
-                if((addr == 4) || (addr == 5)) return -EIO;
-                child->thread.arch.debugregs[addr] = data;
-                return 0;
-        }
-        return -EIO;
+	if (addr < MAX_REG_OFFSET)
+		return putreg(child, addr, data);
+	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
+		 (addr <= offsetof(struct user, u_debugreg[7]))) {
+		addr -= offsetof(struct user, u_debugreg[0]);
+		addr = addr >> 2;
+		if ((addr == 4) || (addr == 5))
+			return -EIO;
+		child->thread.arch.debugregs[addr] = data;
+		return 0;
+	}
+	return -EIO;
 }
 
 unsigned long getreg(struct task_struct *child, int regno)
@@ -129,20 +123,20 @@ unsigned long getreg(struct task_struct 
 	return retval;
 }
 
+/* read the word at location addr in the USER area. */
 int peek_user(struct task_struct *child, long addr, long data)
 {
-/* read the word at location addr in the USER area. */
 	unsigned long tmp;
 
 	if ((addr & 3) || addr < 0)
 		return -EIO;
 
 	tmp = 0;  /* Default return condition */
-	if(addr < MAX_REG_OFFSET){
+	if (addr < MAX_REG_OFFSET) {
 		tmp = getreg(child, addr);
 	}
-	else if((addr >= offsetof(struct user, u_debugreg[0])) &&
-		(addr <= offsetof(struct user, u_debugreg[7]))){
+	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
+		 (addr <= offsetof(struct user, u_debugreg[7]))) {
 		addr -= offsetof(struct user, u_debugreg[0]);
 		addr = addr >> 2;
 		tmp = child->thread.arch.debugregs[addr];
@@ -173,15 +167,15 @@ struct i387_fxsave_struct {
 static inline unsigned short twd_i387_to_fxsr( unsigned short twd )
 {
 	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
- 
+
 	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
-        tmp = ~twd;
-        tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
-        /* and move the valid bits to the lower byte. */
-        tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
-        tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
-        tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-        return tmp;
+	tmp = ~twd;
+	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
+	/* and move the valid bits to the lower byte. */
+	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
+	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
+	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
+	return tmp;
 }
 
 static inline unsigned long twd_fxsr_to_i387( struct i387_fxsave_struct *fxsave )
@@ -235,7 +229,7 @@ static inline int convert_fxsr_to_user(s
 	return 0;
 }
 
-static inline int convert_fxsr_from_user(struct pt_regs *regs, 
+static inline int convert_fxsr_from_user(struct pt_regs *regs,
 					 struct _fpstate __user *buf)
 {
 	return 0;
@@ -247,18 +241,20 @@ int get_fpregs(unsigned long buf, struct
 
 	err = convert_fxsr_to_user((struct _fpstate __user *) buf,
 				   &child->thread.regs);
-	if(err) return(-EFAULT);
-	else return(0);
+	if (err)
+		return -EFAULT;
+	return 0;
 }
 
 int set_fpregs(unsigned long buf, struct task_struct *child)
 {
 	int err;
 
-	err = convert_fxsr_from_user(&child->thread.regs, 
+	err = convert_fxsr_from_user(&child->thread.regs,
 				     (struct _fpstate __user *) buf);
-	if(err) return(-EFAULT);
-	else return(0);
+	if (err)
+		return -EFAULT;
+	return 0;
 }
 
 int get_fpxregs(unsigned long buf, struct task_struct *tsk)
@@ -284,7 +280,7 @@ int dump_fpu(struct pt_regs *regs, elf_f
 	fpu->fos = 0;
 	memcpy(fpu->st_space, (void *) SC_FP_ST(PT_REGS_SC(regs)),
 	       sizeof(fpu->st_space));
-	return(1);
+	return 1;
 }
 #endif
 
@@ -292,14 +288,3 @@ int dump_fpu(struct pt_regs *regs, elf_f
 {
 	return 1;
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
diff -puN arch/um/sys-i386/signal.c~uml-style-fixes-pass-3 arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/signal.c
@@ -1,17 +1,13 @@
 /*
- * Copyright (C) 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/signal.h"
 #include "linux/ptrace.h"
-#include "asm/current.h"
-#include "asm/ucontext.h"
-#include "asm/uaccess.h"
 #include "asm/unistd.h"
+#include "asm/uaccess.h"
+#include "asm/ucontext.h"
 #include "frame_kern.h"
-#include "sigcontext.h"
-#include "registers.h"
 #include "skas.h"
 
 void copy_sc(struct uml_pt_regs *regs, void *from)
@@ -39,21 +35,21 @@ void copy_sc(struct uml_pt_regs *regs, v
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
-  	struct sigcontext sc;
+ 	struct sigcontext sc;
 	unsigned long fpregs[HOST_FP_SIZE];
 	int err;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
 	err |= copy_from_user(fpregs, sc.fpstate, sizeof(fpregs));
-	if(err)
+	if (err)
 		return err;
 
 	copy_sc(&regs->regs, &sc);
 
 	err = restore_fp_registers(userspace_pid[0], fpregs);
-	if(err < 0) {
-	  	printk("copy_sc_from_user_skas - PTRACE_SETFPREGS failed, "
-		       "errno = %d\n", -err);
+	if (err < 0) {
+	  	printk(KERN_ERR "copy_sc_from_user_skas - PTRACE_SETFPREGS "
+		       "failed, errno = %d\n", -err);
 		return err;
 	}
 
@@ -64,7 +60,7 @@ static int copy_sc_to_user(struct sigcon
 			   struct _fpstate __user *to_fp, struct pt_regs *regs,
 			   unsigned long sp)
 {
-  	struct sigcontext sc;
+	struct sigcontext sc;
 	unsigned long fpregs[HOST_FP_SIZE];
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err;
@@ -86,28 +82,29 @@ static int copy_sc_to_user(struct sigcon
 	sc.eflags = REGS_EFLAGS(regs->regs.regs);
 	sc.esp_at_signal = regs->regs.regs[UESP];
 	sc.ss = regs->regs.regs[SS];
-        sc.cr2 = fi->cr2;
-        sc.err = fi->error_code;
-        sc.trapno = fi->trap_no;
+	sc.cr2 = fi->cr2;
+	sc.err = fi->error_code;
+	sc.trapno = fi->trap_no;
 
 	err = save_fp_registers(userspace_pid[0], fpregs);
-	if(err < 0){
-	  	printk("copy_sc_to_user_skas - PTRACE_GETFPREGS failed, "
-		       "errno = %d\n", err);
+	if (err < 0) {
+	  	printk(KERN_ERR "copy_sc_to_user_skas - PTRACE_GETFPREGS "
+		       "failed, errno = %d\n", err);
 		return 1;
 	}
 	to_fp = (to_fp ? to_fp : (struct _fpstate __user *) (to + 1));
 	sc.fpstate = to_fp;
 
-	if(err)
+	if (err)
 	  	return err;
 
 	return copy_to_user(to, &sc, sizeof(sc)) ||
 	       copy_to_user(to_fp, fpregs, sizeof(fpregs));
 }
 
-static int copy_ucontext_to_user(struct ucontext __user *uc, struct _fpstate __user *fp,
-				 sigset_t *set, unsigned long sp)
+static int copy_ucontext_to_user(struct ucontext __user *uc,
+				 struct _fpstate __user *fp, sigset_t *set,
+				 unsigned long sp)
 {
 	int err = 0;
 
@@ -157,7 +154,7 @@ int setup_signal_stack_sc(unsigned long 
 		return 1;
 
 	restorer = frame->retcode;
-	if(ka->sa.sa_flags & SA_RESTORER)
+	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
 	/* Update SP now because the page fault handler refuses to extend
@@ -189,7 +186,7 @@ int setup_signal_stack_sc(unsigned long 
 	err |= __put_user(__NR_sigreturn, (int __user *)(frame->retcode+2));
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
 
-	if(err)
+	if (err)
 		goto err;
 
 	PT_REGS_SP(regs) = (unsigned long) frame;
@@ -222,7 +219,7 @@ int setup_signal_stack_si(unsigned long 
 		return 1;
 
 	restorer = frame->retcode;
-	if(ka->sa.sa_flags & SA_RESTORER)
+	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
 	/* See comment above about why this is here */
@@ -247,7 +244,7 @@ int setup_signal_stack_si(unsigned long 
 	err |= __put_user(__NR_rt_sigreturn, (int __user *)(frame->retcode+1));
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
 
-	if(err)
+	if (err)
 		goto err;
 
 	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
@@ -274,8 +271,8 @@ long sys_sigreturn(struct pt_regs regs)
 	unsigned long __user *extramask = frame->extramask;
 	int sig_size = (_NSIG_WORDS - 1) * sizeof(unsigned long);
 
-	if(copy_from_user(&set.sig[0], oldmask, sizeof(set.sig[0])) ||
-	   copy_from_user(&set.sig[1], extramask, sig_size))
+	if (copy_from_user(&set.sig[0], oldmask, sizeof(set.sig[0])) ||
+	    copy_from_user(&set.sig[1], extramask, sig_size))
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
@@ -285,7 +282,7 @@ long sys_sigreturn(struct pt_regs regs)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if(copy_sc_from_user(&current->thread.regs, sc))
+	if (copy_sc_from_user(&current->thread.regs, sc))
 		goto segfault;
 
 	/* Avoid ERESTART handling */
@@ -300,12 +297,13 @@ long sys_sigreturn(struct pt_regs regs)
 long sys_rt_sigreturn(struct pt_regs regs)
 {
 	unsigned long sp = PT_REGS_SP(&current->thread.regs);
-	struct rt_sigframe __user *frame = (struct rt_sigframe __user *) (sp - 4);
+	struct rt_sigframe __user *frame =
+		(struct rt_sigframe __user *) (sp - 4);
 	sigset_t set;
 	struct ucontext __user *uc = &frame->uc;
 	int sig_size = _NSIG_WORDS * sizeof(unsigned long);
 
-	if(copy_from_user(&set, &uc->uc_sigmask, sig_size))
+	if (copy_from_user(&set, &uc->uc_sigmask, sig_size))
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
@@ -315,7 +313,7 @@ long sys_rt_sigreturn(struct pt_regs reg
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if(copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
+	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
 
 	/* Avoid ERESTART handling */
diff -puN arch/um/sys-i386/tls.c~uml-style-fixes-pass-3 arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-i386/tls.c
@@ -3,19 +3,12 @@
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
+#include "linux/percpu.h"
 #include "linux/sched.h"
-#include "linux/slab.h"
-#include "linux/types.h"
 #include "asm/uaccess.h"
-#include "asm/ptrace.h"
-#include "asm/segment.h"
-#include "asm/smp.h"
-#include "asm/desc.h"
-#include "kern.h"
-#include "kern_util.h"
 #include "os.h"
 #include "skas.h"
+#include "sysdep/tls.h"
 
 /*
  * If needed we can detect when it's uninitialized.
@@ -74,7 +67,8 @@ static inline void clear_user_desc(struc
 	/* Postcondition: LDT_empty(info) returns true. */
 	memset(info, 0, sizeof(*info));
 
-	/* Check the LDT_empty or the i386 sys_get_thread_area code - we obtain
+	/*
+	 * Check the LDT_empty or the i386 sys_get_thread_area code - we obtain
 	 * indeed an empty user_desc.
 	 */
 	info->read_exec_only = 1;
@@ -89,10 +83,13 @@ static int load_TLS(int flags, struct ta
 	int idx;
 
 	for (idx = GDT_ENTRY_TLS_MIN; idx < GDT_ENTRY_TLS_MAX; idx++) {
-		struct uml_tls_struct* curr = &to->thread.arch.tls_array[idx - GDT_ENTRY_TLS_MIN];
+		struct uml_tls_struct* curr =
+			&to->thread.arch.tls_array[idx - GDT_ENTRY_TLS_MIN];
 
-		/* Actually, now if it wasn't flushed it gets cleared and
-		 * flushed to the host, which will clear it.*/
+		/*
+		 * Actually, now if it wasn't flushed it gets cleared and
+		 * flushed to the host, which will clear it.
+		 */
 		if (!curr->present) {
 			if (!curr->flushed) {
 				clear_user_desc(&curr->tls);
@@ -116,7 +113,8 @@ out:
 	return ret;
 }
 
-/* Verify if we need to do a flush for the new process, i.e. if there are any
+/*
+ * Verify if we need to do a flush for the new process, i.e. if there are any
  * present desc's, only if they haven't been flushed.
  */
 static inline int needs_TLS_update(struct task_struct *task)
@@ -125,10 +123,13 @@ static inline int needs_TLS_update(struc
 	int ret = 0;
 
 	for (i = GDT_ENTRY_TLS_MIN; i < GDT_ENTRY_TLS_MAX; i++) {
-		struct uml_tls_struct* curr = &task->thread.arch.tls_array[i - GDT_ENTRY_TLS_MIN];
+		struct uml_tls_struct* curr =
+			&task->thread.arch.tls_array[i - GDT_ENTRY_TLS_MIN];
 
-		/* Can't test curr->present, we may need to clear a descriptor
-		 * which had a value. */
+		/*
+		 * Can't test curr->present, we may need to clear a descriptor
+		 * which had a value.
+		 */
 		if (curr->flushed)
 			continue;
 		ret = 1;
@@ -137,7 +138,8 @@ static inline int needs_TLS_update(struc
 	return ret;
 }
 
-/* On a newly forked process, the TLS descriptors haven't yet been flushed. So
+/*
+ * On a newly forked process, the TLS descriptors haven't yet been flushed. So
  * we mark them as such and the first switch_to will do the job.
  */
 void clear_flushed_tls(struct task_struct *task)
@@ -145,10 +147,13 @@ void clear_flushed_tls(struct task_struc
 	int i;
 
 	for (i = GDT_ENTRY_TLS_MIN; i < GDT_ENTRY_TLS_MAX; i++) {
-		struct uml_tls_struct* curr = &task->thread.arch.tls_array[i - GDT_ENTRY_TLS_MIN];
+		struct uml_tls_struct* curr =
+			&task->thread.arch.tls_array[i - GDT_ENTRY_TLS_MIN];
 
-		/* Still correct to do this, if it wasn't present on the host it
-		 * will remain as flushed as it was. */
+		/*
+		 * Still correct to do this, if it wasn't present on the host it
+		 * will remain as flushed as it was.
+		 */
 		if (!curr->present)
 			continue;
 
@@ -156,23 +161,27 @@ void clear_flushed_tls(struct task_struc
 	}
 }
 
-/* In SKAS0 mode, currently, multiple guest threads sharing the same ->mm have a
+/*
+ * In SKAS0 mode, currently, multiple guest threads sharing the same ->mm have a
  * common host process. So this is needed in SKAS0 too.
  *
  * However, if each thread had a different host process (and this was discussed
  * for SMP support) this won't be needed.
  *
  * And this will not need be used when (and if) we'll add support to the host
- * SKAS patch. */
+ * SKAS patch.
+ */
 
 int arch_switch_tls(struct task_struct *from, struct task_struct *to)
 {
 	if (!host_supports_tls)
 		return 0;
 
-	/* We have no need whatsoever to switch TLS for kernel threads; beyond
+	/*
+	 * We have no need whatsoever to switch TLS for kernel threads; beyond
 	 * that, that would also result in us calling os_set_thread_area with
-	 * userspace_pid[cpu] == 0, which gives an error. */
+	 * userspace_pid[cpu] == 0, which gives an error.
+	 */
 	if (likely(to->mm))
 		return load_TLS(O_FORCE, to);
 
@@ -232,17 +241,20 @@ static int get_tls_entry(struct task_str
 	*info = t->arch.tls_array[idx - GDT_ENTRY_TLS_MIN].tls;
 
 out:
-	/* Temporary debugging check, to make sure that things have been
+	/*
+	 * Temporary debugging check, to make sure that things have been
 	 * flushed. This could be triggered if load_TLS() failed.
 	 */
-	if (unlikely(task == current && !t->arch.tls_array[idx - GDT_ENTRY_TLS_MIN].flushed)) {
+	if (unlikely(task == current &&
+		     !t->arch.tls_array[idx - GDT_ENTRY_TLS_MIN].flushed)) {
 		printk(KERN_ERR "get_tls_entry: task with pid %d got here "
 				"without flushed TLS.", current->pid);
 	}
 
 	return 0;
 clear:
-	/* When the TLS entry has not been set, the values read to user in the
+	/*
+	 * When the TLS entry has not been set, the values read to user in the
 	 * tls_array are 0 (because it's cleared at boot, see
 	 * arch/i386/kernel/head.S:cpu_gdt_table). Emulate that.
 	 */
@@ -344,8 +356,10 @@ out:
 }
 
 
-/* XXX: This part is probably common to i386 and x86-64. Don't create a common
- * file for now, do that when implementing x86-64 support.*/
+/*
+ * XXX: This part is probably common to i386 and x86-64. Don't create a common
+ * file for now, do that when implementing x86-64 support.
+ */
 static int __init __setup_host_supports_tls(void)
 {
 	check_host_supports_tls(&host_supports_tls, &host_gdt_entry_tls_min);
diff -puN arch/um/sys-x86_64/fault.c~uml-style-fixes-pass-3 arch/um/sys-x86_64/fault.c
--- a/arch/um/sys-x86_64/fault.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-x86_64/fault.c
@@ -14,14 +14,15 @@ struct exception_table_entry
 };
 
 const struct exception_table_entry *search_exception_tables(unsigned long add);
+
 int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if(fixup != 0){
+	if (fixup != 0) {
 		UPT_IP(regs) = fixup->fixup;
-		return(1);
+		return 1;
 	}
-	return(0);
+	return 0;
 }
diff -puN arch/um/sys-x86_64/signal.c~uml-style-fixes-pass-3 arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-x86_64/signal.c
@@ -3,16 +3,11 @@
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/errno.h"
 #include "linux/personality.h"
 #include "linux/ptrace.h"
-#include "asm/current.h"
+#include "asm/unistd.h"
 #include "asm/uaccess.h"
-#include "asm/sigcontext.h"
-#include "asm/ptrace.h"
-#include "asm/arch/ucontext.h"
-#include "sysdep/ptrace.h"
+#include "asm/ucontext.h"
 #include "frame_kern.h"
 #include "skas.h"
 
@@ -20,28 +15,28 @@ void copy_sc(struct uml_pt_regs *regs, v
 {
 	struct sigcontext *sc = from;
 
-#define GETREG(regs, regno, sc, regname) \
-       (regs)->regs[(regno) / sizeof(unsigned long)] = (sc)->regname
+#define GETREG(regs, regno, sc, regname)				\
+	(regs)->regs[(regno) / sizeof(unsigned long)] = (sc)->regname
 
-       GETREG(regs, R8, sc, r8);
-       GETREG(regs, R9, sc, r9);
-       GETREG(regs, R10, sc, r10);
-       GETREG(regs, R11, sc, r11);
-       GETREG(regs, R12, sc, r12);
-       GETREG(regs, R13, sc, r13);
-       GETREG(regs, R14, sc, r14);
-       GETREG(regs, R15, sc, r15);
-       GETREG(regs, RDI, sc, rdi);
-       GETREG(regs, RSI, sc, rsi);
-       GETREG(regs, RBP, sc, rbp);
-       GETREG(regs, RBX, sc, rbx);
-       GETREG(regs, RDX, sc, rdx);
-       GETREG(regs, RAX, sc, rax);
-       GETREG(regs, RCX, sc, rcx);
-       GETREG(regs, RSP, sc, rsp);
-       GETREG(regs, RIP, sc, rip);
-       GETREG(regs, EFLAGS, sc, eflags);
-       GETREG(regs, CS, sc, cs);
+	GETREG(regs, R8, sc, r8);
+	GETREG(regs, R9, sc, r9);
+	GETREG(regs, R10, sc, r10);
+	GETREG(regs, R11, sc, r11);
+	GETREG(regs, R12, sc, r12);
+	GETREG(regs, R13, sc, r13);
+	GETREG(regs, R14, sc, r14);
+	GETREG(regs, R15, sc, r15);
+	GETREG(regs, RDI, sc, rdi);
+	GETREG(regs, RSI, sc, rsi);
+	GETREG(regs, RBP, sc, rbp);
+	GETREG(regs, RBX, sc, rbx);
+	GETREG(regs, RDX, sc, rdx);
+	GETREG(regs, RAX, sc, rax);
+	GETREG(regs, RCX, sc, rcx);
+	GETREG(regs, RSP, sc, rsp);
+	GETREG(regs, RIP, sc, rip);
+	GETREG(regs, EFLAGS, sc, eflags);
+	GETREG(regs, CS, sc, cs);
 
 #undef GETREG
 }
@@ -49,58 +44,58 @@ void copy_sc(struct uml_pt_regs *regs, v
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
-       int err = 0;
+	int err = 0;
 
-#define GETREG(regs, regno, sc, regname) \
-       __get_user((regs)->regs.regs[(regno) / sizeof(unsigned long)], \
-                  &(sc)->regname)
-
-       err |= GETREG(regs, R8, from, r8);
-       err |= GETREG(regs, R9, from, r9);
-       err |= GETREG(regs, R10, from, r10);
-       err |= GETREG(regs, R11, from, r11);
-       err |= GETREG(regs, R12, from, r12);
-       err |= GETREG(regs, R13, from, r13);
-       err |= GETREG(regs, R14, from, r14);
-       err |= GETREG(regs, R15, from, r15);
-       err |= GETREG(regs, RDI, from, rdi);
-       err |= GETREG(regs, RSI, from, rsi);
-       err |= GETREG(regs, RBP, from, rbp);
-       err |= GETREG(regs, RBX, from, rbx);
-       err |= GETREG(regs, RDX, from, rdx);
-       err |= GETREG(regs, RAX, from, rax);
-       err |= GETREG(regs, RCX, from, rcx);
-       err |= GETREG(regs, RSP, from, rsp);
-       err |= GETREG(regs, RIP, from, rip);
-       err |= GETREG(regs, EFLAGS, from, eflags);
-       err |= GETREG(regs, CS, from, cs);
+#define GETREG(regs, regno, sc, regname)				\
+	__get_user((regs)->regs.regs[(regno) / sizeof(unsigned long)],	\
+		   &(sc)->regname)
+
+	err |= GETREG(regs, R8, from, r8);
+	err |= GETREG(regs, R9, from, r9);
+	err |= GETREG(regs, R10, from, r10);
+	err |= GETREG(regs, R11, from, r11);
+	err |= GETREG(regs, R12, from, r12);
+	err |= GETREG(regs, R13, from, r13);
+	err |= GETREG(regs, R14, from, r14);
+	err |= GETREG(regs, R15, from, r15);
+	err |= GETREG(regs, RDI, from, rdi);
+	err |= GETREG(regs, RSI, from, rsi);
+	err |= GETREG(regs, RBP, from, rbp);
+	err |= GETREG(regs, RBX, from, rbx);
+	err |= GETREG(regs, RDX, from, rdx);
+	err |= GETREG(regs, RAX, from, rax);
+	err |= GETREG(regs, RCX, from, rcx);
+	err |= GETREG(regs, RSP, from, rsp);
+	err |= GETREG(regs, RIP, from, rip);
+	err |= GETREG(regs, EFLAGS, from, eflags);
+	err |= GETREG(regs, CS, from, cs);
 
 #undef GETREG
 
-       return err;
+	return err;
 }
 
 static int copy_sc_to_user(struct sigcontext __user *to,
 			   struct _fpstate __user *to_fp, struct pt_regs *regs,
 			   unsigned long mask, unsigned long sp)
 {
-        struct faultinfo * fi = &current->thread.arch.faultinfo;
+	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err = 0;
 
 	err |= __put_user(0, &to->gs);
 	err |= __put_user(0, &to->fs);
 
-#define PUTREG(regs, regno, sc, regname) \
-       __put_user((regs)->regs.regs[(regno) / sizeof(unsigned long)], \
-                  &(sc)->regname)
+#define PUTREG(regs, regno, sc, regname)				\
+	__put_user((regs)->regs.regs[(regno) / sizeof(unsigned long)],	\
+		   &(sc)->regname)
 
 	err |= PUTREG(regs, RDI, to, rdi);
 	err |= PUTREG(regs, RSI, to, rsi);
 	err |= PUTREG(regs, RBP, to, rbp);
-        /* Must use orignal RSP, which is passed in, rather than what's in
-         * the pt_regs, because that's already been updated to point at the
-         * signal frame.
-         */
+	/* Must use orignal RSP, which is passed in, rather than what's in
+	 * the pt_regs, because that's already been updated to point at the
+	 * signal frame.
+	 */
 	err |= __put_user(sp, &to->rsp);
 	err |= PUTREG(regs, RBX, to, rbx);
 	err |= PUTREG(regs, RDX, to, rdx);
@@ -116,9 +111,9 @@ static int copy_sc_to_user(struct sigcon
 	err |= PUTREG(regs, R15, to, r15);
 	err |= PUTREG(regs, CS, to, cs); /* XXX x86_64 doesn't do this */
 
-        err |= __put_user(fi->cr2, &to->cr2);
-        err |= __put_user(fi->error_code, &to->err);
-        err |= __put_user(fi->trap_no, &to->trapno);
+	err |= __put_user(fi->cr2, &to->cr2);
+	err |= __put_user(fi->error_code, &to->err);
+	err |= __put_user(fi->trap_no, &to->trapno);
 
 	err |= PUTREG(regs, RIP, to, rip);
 	err |= PUTREG(regs, EFLAGS, to, eflags);
@@ -131,9 +126,9 @@ static int copy_sc_to_user(struct sigcon
 
 struct rt_sigframe
 {
-       char __user *pretcode;
-       struct ucontext uc;
-       struct siginfo info;
+	char __user *pretcode;
+	struct ucontext uc;
+	struct siginfo info;
 };
 
 #define round_down(m, n) (((m) / (n)) * (n))
@@ -151,7 +146,7 @@ int setup_signal_stack_si(unsigned long 
 	frame = (struct rt_sigframe __user *)
 		round_down(stack_top - sizeof(struct rt_sigframe), 16);
 	/* Subtract 128 for a red zone and 8 for proper alignment */
-        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
+	frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
 
 	if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 		goto out;
@@ -241,7 +236,7 @@ long sys_rt_sigreturn(struct pt_regs *re
 	struct ucontext __user *uc = &frame->uc;
 	sigset_t set;
 
-	if(copy_from_user(&set, &uc->uc_sigmask, sizeof(set)))
+	if (copy_from_user(&set, &uc->uc_sigmask, sizeof(set)))
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
@@ -251,7 +246,7 @@ long sys_rt_sigreturn(struct pt_regs *re
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if(copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
+	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
 
 	/* Avoid ERESTART handling */
@@ -262,13 +257,3 @@ long sys_rt_sigreturn(struct pt_regs *re
 	force_sig(SIGSEGV, current);
 	return 0;
 }
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
diff -puN arch/um/sys-x86_64/syscalls.c~uml-style-fixes-pass-3 arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -1,36 +1,34 @@
 /*
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright 2003 PathScale, Inc.
  *
  * Licensed under the GPL
  */
 
 #include "linux/linkage.h"
-#include "linux/slab.h"
-#include "linux/shm.h"
-#include "linux/utsname.h"
 #include "linux/personality.h"
-#include "asm/uaccess.h"
-#define __FRAME_OFFSETS
-#include "asm/ptrace.h"
-#include "asm/unistd.h"
+#include "linux/utsname.h"
 #include "asm/prctl.h" /* XXX This should get the constants from libc */
-#include "kern.h"
+#include "asm/uaccess.h"
 #include "os.h"
 
 asmlinkage long sys_uname64(struct new_utsname __user * name)
 {
 	int err;
+
 	down_read(&uts_sem);
 	err = copy_to_user(name, utsname(), sizeof (*name));
 	up_read(&uts_sem);
+
 	if (personality(current->personality) == PER_LINUX32)
 		err |= copy_to_user(&name->machine, "i686", 5);
+
 	return err ? -EFAULT : 0;
 }
 
 long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 {
-        unsigned long *ptr = addr, tmp;
+	unsigned long *ptr = addr, tmp;
 	long ret;
 	int pid = task->mm->context.skas.id.u.pid;
 
@@ -47,42 +45,42 @@ long arch_prctl(struct task_struct *task
 	 * arch_prctl is run on the host, then the registers are read
 	 * back.
 	 */
-	switch(code){
+	switch (code) {
 	case ARCH_SET_FS:
 	case ARCH_SET_GS:
-                restore_registers(pid, &current->thread.regs.regs);
-                break;
-        case ARCH_GET_FS:
-        case ARCH_GET_GS:
-                /*
-                 * With these two, we read to a local pointer and
-                 * put_user it to the userspace pointer that we were
-                 * given.  If addr isn't valid (because it hasn't been
-                 * faulted in or is just bogus), we want put_user to
-                 * fault it in (or return -EFAULT) instead of having
-                 * the host return -EFAULT.
-                 */
-                ptr = &tmp;
-        }
-
-        ret = os_arch_prctl(pid, code, ptr);
-        if(ret)
-                return ret;
+		restore_registers(pid, &current->thread.regs.regs);
+		break;
+	case ARCH_GET_FS:
+	case ARCH_GET_GS:
+		/*
+		 * With these two, we read to a local pointer and
+		 * put_user it to the userspace pointer that we were
+		 * given.  If addr isn't valid (because it hasn't been
+		 * faulted in or is just bogus), we want put_user to
+		 * fault it in (or return -EFAULT) instead of having
+		 * the host return -EFAULT.
+		 */
+		ptr = &tmp;
+	}
+
+	ret = os_arch_prctl(pid, code, ptr);
+	if (ret)
+		return ret;
 
-        switch(code){
+	switch (code) {
 	case ARCH_SET_FS:
 		current->thread.arch.fs = (unsigned long) ptr;
 		save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_SET_GS:
-                save_registers(pid, &current->thread.regs.regs);
+		save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_GET_FS:
 		ret = put_user(tmp, addr);
-	        break;
+		break;
 	case ARCH_GET_GS:
 		ret = put_user(tmp, addr);
-	        break;
+		break;
 	}
 
 	return ret;
@@ -109,8 +107,8 @@ long sys_clone(unsigned long clone_flags
 
 void arch_switch_to(struct task_struct *from, struct task_struct *to)
 {
-        if((to->thread.arch.fs == 0) || (to->mm == NULL))
-                return;
+	if ((to->thread.arch.fs == 0) || (to->mm == NULL))
+		return;
 
-        arch_prctl(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
+	arch_prctl(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
diff -puN arch/um/sys-x86_64/tls.c~uml-style-fixes-pass-3 arch/um/sys-x86_64/tls.c
--- a/arch/um/sys-x86_64/tls.c~uml-style-fixes-pass-3
+++ a/arch/um/sys-x86_64/tls.c
@@ -13,5 +13,5 @@ int arch_copy_tls(struct task_struct *t)
 	 */
 	t->thread.arch.fs = t->thread.regs.regs.regs[R8 / sizeof(long)];
 
-        return 0;
+	return 0;
 }
diff -puN include/asm-um/mmu_context.h~uml-style-fixes-pass-3 include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-style-fixes-pass-3
+++ a/include/asm-um/mmu_context.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -55,14 +55,3 @@ extern int init_new_context(struct task_
 extern void destroy_context(struct mm_struct *mm);
 
 #endif
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
diff -puN include/asm-um/processor-generic.h~uml-style-fixes-pass-3 include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-style-fixes-pass-3
+++ a/include/asm-um/processor-generic.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -17,11 +17,14 @@ struct task_struct;
 struct mm_struct;
 
 struct thread_struct {
-	/* This flag is set to 1 before calling do_fork (and analyzed in
+	struct task_struct *saved_task;
+	/*
+	 * This flag is set to 1 before calling do_fork (and analyzed in
 	 * copy_thread) to mark that we are begin called from userspace (fork /
 	 * vfork / clone), and reset to 0 after. It is left to 0 when called
-	 * from kernelspace (i.e. kernel_thread() or fork_idle(), as of 2.6.11). */
-	struct task_struct *saved_task;
+	 * from kernelspace (i.e. kernel_thread() or fork_idle(),
+	 * as of 2.6.11).
+	 */
 	int forking;
 	int nsyscalls;
 	struct pt_regs regs;
@@ -56,7 +59,7 @@ struct thread_struct {
 { \
 	.forking		= 0, \
 	.nsyscalls		= 0, \
-        .regs		   	= EMPTY_REGS, \
+	.regs		   	= EMPTY_REGS,	\
 	.fault_addr		= NULL, \
 	.prev_sched		= NULL, \
 	.temp_stack		= 0, \
diff -puN include/asm-um/ptrace-generic.h~uml-style-fixes-pass-3 include/asm-um/ptrace-generic.h
--- a/include/asm-um/ptrace-generic.h~uml-style-fixes-pass-3
+++ a/include/asm-um/ptrace-generic.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
diff -puN include/asm-um/ptrace-i386.h~uml-style-fixes-pass-3 include/asm-um/ptrace-i386.h
--- a/include/asm-um/ptrace-i386.h~uml-style-fixes-pass-3
+++ a/include/asm-um/ptrace-i386.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -9,9 +9,8 @@
 #define HOST_AUDIT_ARCH AUDIT_ARCH_I386
 
 #include "linux/compiler.h"
-#include "sysdep/ptrace.h"
 #include "asm/ptrace-generic.h"
-#include "asm/host_ldt.h"
+#include "sysdep/ptrace.h"
 
 #define PT_REGS_EAX(r) UPT_EAX(&(r)->regs)
 #define PT_REGS_EBX(r) UPT_EBX(&(r)->regs)
@@ -40,6 +39,12 @@
 
 #define user_mode(r) UPT_IS_USER(&(r)->regs)
 
+/*
+ * Forward declaration to avoid including sysdep/tls.h, which causes a
+ * circular include, and compilation failures.
+ */
+struct user_desc;
+
 extern int ptrace_get_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
