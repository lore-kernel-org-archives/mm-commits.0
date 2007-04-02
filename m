From: akpm@linux-foundation.org
Subject: + uml-tidy-processc.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:46:21 -0700
Message-ID: <200704022146.l32LkOiw010300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48376 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965972AbXDBVqc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: tidy process.c
has been added to the -mm tree.  Its filename is
     uml-tidy-processc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: tidy process.c
From: Jeff Dike <jdike@addtoit.com>

Clean up arch/um/kernel/process.c:

- lots of return(x); -> return x; conversions

- a number of the small functions are either unused, in which case they are
  gone, along any declarations in a header, or could be made static. 

- current_pid is ifdefed on CONFIG_MODE_TT and its declaration is ifdefed on
  both CONFIG_MODE_TT and UML_CONFIG_MODE_TT because we don't know whether
  it's being used in a userspace or kernel file.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h     |    6 -
 arch/um/include/tt/uaccess-tt.h |    2 
 arch/um/include/um_malloc.h     |    1 
 arch/um/kernel/process.c        |  118 ++++++++----------------------
 4 files changed, 37 insertions(+), 90 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-tidy-processc arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-tidy-processc
+++ a/arch/um/include/kern_util.h
@@ -33,7 +33,9 @@ extern int nsyscalls;
 	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
 
 extern int kernel_fork(unsigned long flags, int (*fn)(void *), void * arg);
+#if defined(CONFIG_MODE_TT) || defined(UML_CONFIG_MODE_TT)
 extern unsigned long stack_sp(unsigned long page);
+#endif
 extern int kernel_thread_proc(void *data);
 extern void syscall_segv(int sig);
 extern int current_pid(void);
@@ -57,7 +59,6 @@ extern void add_input_request(int op, vo
 extern char *current_cmd(void);
 extern void timer_handler(int sig, union uml_pt_regs *regs);
 extern int set_signals(int enable);
-extern void force_sigbus(void);
 extern int pid_to_processor_id(int pid);
 extern void deliver_signals(void *t);
 extern int next_trap_index(int max);
@@ -69,7 +70,6 @@ extern void *syscall_sp(void *t);
 extern void syscall_trace(union uml_pt_regs *regs, int entryexit);
 extern int hz(void);
 extern unsigned int do_IRQ(int irq, union uml_pt_regs *regs);
-extern int external_pid(void *t);
 extern void interrupt_end(void);
 extern void initial_thread_cb(void (*proc)(void *), void *arg);
 extern int debugger_signal(int status, int pid);
@@ -80,7 +80,6 @@ extern int init_parent_proxy(int pid);
 extern int singlestepping(void *t);
 extern void check_stack_overflow(void *ptr);
 extern void relay_signal(int sig, union uml_pt_regs *regs);
-extern void not_implemented(void);
 extern int user_context(unsigned long sp);
 extern void timer_irq(union uml_pt_regs *regs);
 extern void unprotect_stack(unsigned long stack);
@@ -92,7 +91,6 @@ extern char *uml_strdup(char *string);
 extern void unprotect_kernel_mem(void);
 extern void protect_kernel_mem(void);
 extern void uml_cleanup(void);
-extern void set_current(void *t);
 extern void lock_signalled_task(void *t);
 extern void IPI_handler(int cpu);
 extern int jail_setup(char *line, int *add);
diff -puN arch/um/include/tt/uaccess-tt.h~uml-tidy-processc arch/um/include/tt/uaccess-tt.h
--- a/arch/um/include/tt/uaccess-tt.h~uml-tidy-processc
+++ a/arch/um/include/tt/uaccess-tt.h
@@ -27,8 +27,6 @@ extern unsigned long uml_physmem;
 #define access_ok_tt(type, addr, size) \
 	(is_stack(addr, size))
 
-extern unsigned long get_fault_addr(void);
-
 extern int __do_copy_from_user(void *to, const void *from, int n,
 			       void **fault_addr, void **fault_catcher);
 extern int __do_strncpy_from_user(char *dst, const char *src, size_t n,
diff -puN arch/um/include/um_malloc.h~uml-tidy-processc arch/um/include/um_malloc.h
--- a/arch/um/include/um_malloc.h~uml-tidy-processc
+++ a/arch/um/include/um_malloc.h
@@ -11,7 +11,6 @@ extern void *um_kmalloc_atomic(int size)
 extern void kfree(const void *ptr);
 
 extern void *um_vmalloc(int size);
-extern void *um_vmalloc_atomic(int size);
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
diff -puN arch/um/kernel/process.c~uml-tidy-processc arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-tidy-processc
+++ a/arch/um/kernel/process.c
@@ -54,11 +54,9 @@
  */
 struct cpu_task cpu_tasks[NR_CPUS] = { [0 ... NR_CPUS - 1] = { -1, NULL } };
 
-int external_pid(void *t)
+static inline int external_pid(struct task_struct *task)
 {
-	struct task_struct *task = t ? t : current;
-
-	return(CHOOSE_MODE_PROC(external_pid_tt, external_pid_skas, task));
+	return CHOOSE_MODE_PROC(external_pid_tt, external_pid_skas, task);
 }
 
 int pid_to_processor_id(int pid)
@@ -66,9 +64,10 @@ int pid_to_processor_id(int pid)
 	int i;
 
 	for(i = 0; i < ncpus; i++){
-		if(cpu_tasks[i].pid == pid) return(i);
+		if(cpu_tasks[i].pid == pid)
+			return i;
 	}
-	return(-1);
+	return -1;
 }
 
 void free_stack(unsigned long stack, int order)
@@ -85,9 +84,9 @@ unsigned long alloc_stack(int order, int
 		flags = GFP_ATOMIC;
 	page = __get_free_pages(flags, order);
 	if(page == 0)
-		return(0);
+		return 0;
 	stack_protections(page);
-	return(page);
+	return page;
 }
 
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
@@ -100,13 +99,11 @@ int kernel_thread(int (*fn)(void *), voi
 		      &current->thread.regs, 0, NULL, NULL);
 	if(pid < 0)
 		panic("do_fork failed in kernel_thread, errno = %d", pid);
-	return(pid);
+	return pid;
 }
 
-void set_current(void *t)
+static inline void set_current(struct task_struct *task)
 {
-	struct task_struct *task = t;
-
 	cpu_tasks[task_thread_info(task)->cpu] = ((struct cpu_task)
 		{ external_pid(task), task });
 }
@@ -128,14 +125,16 @@ void *_switch_to(void *prev, void *next,
 		prev= current;
 	} while(current->thread.saved_task);
 
-	return(current->thread.prev_sched);
+	return current->thread.prev_sched;
 
 }
 
 void interrupt_end(void)
 {
-	if(need_resched()) schedule();
-	if(test_tsk_thread_flag(current, TIF_SIGPENDING)) do_signal();
+	if(need_resched())
+		schedule();
+	if(test_tsk_thread_flag(current, TIF_SIGPENDING))
+		do_signal();
 }
 
 void release_thread(struct task_struct *task)
@@ -150,7 +149,7 @@ void exit_thread(void)
 
 void *get_current(void)
 {
-	return(current);
+	return current;
 }
 
 int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
@@ -188,15 +187,12 @@ void initial_thread_cb(void (*proc)(void
 	kmalloc_ok = save_kmalloc_ok;
 }
 
+#ifdef CONFIG_MODE_TT
 unsigned long stack_sp(unsigned long page)
 {
-	return(page + PAGE_SIZE - sizeof(void *));
-}
-
-int current_pid(void)
-{
-	return(current->pid);
+	return page + PAGE_SIZE - sizeof(void *);
 }
+#endif
 
 void default_idle(void)
 {
@@ -223,7 +219,7 @@ void cpu_idle(void)
 
 int page_size(void)
 {
-	return(PAGE_SIZE);
+	return PAGE_SIZE;
 }
 
 void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
@@ -236,68 +232,43 @@ void *um_virt_to_phys(struct task_struct
 	pte_t ptent;
 
 	if(task->mm == NULL)
-		return(ERR_PTR(-EINVAL));
+		return ERR_PTR(-EINVAL);
 	pgd = pgd_offset(task->mm, addr);
 	if(!pgd_present(*pgd))
-		return(ERR_PTR(-EINVAL));
+		return ERR_PTR(-EINVAL);
 
 	pud = pud_offset(pgd, addr);
 	if(!pud_present(*pud))
-		return(ERR_PTR(-EINVAL));
+		return ERR_PTR(-EINVAL);
 
 	pmd = pmd_offset(pud, addr);
 	if(!pmd_present(*pmd))
-		return(ERR_PTR(-EINVAL));
+		return ERR_PTR(-EINVAL);
 
 	pte = pte_offset_kernel(pmd, addr);
 	ptent = *pte;
 	if(!pte_present(ptent))
-		return(ERR_PTR(-EINVAL));
+		return ERR_PTR(-EINVAL);
 
 	if(pte_out != NULL)
 		*pte_out = ptent;
-	return((void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK));
+	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
 }
 
 char *current_cmd(void)
 {
 #if defined(CONFIG_SMP) || defined(CONFIG_HIGHMEM)
-	return("(Unknown)");
+	return "(Unknown)";
 #else
 	void *addr = um_virt_to_phys(current, current->mm->arg_start, NULL);
 	return IS_ERR(addr) ? "(Unknown)": __va((unsigned long) addr);
 #endif
 }
 
-void force_sigbus(void)
-{
-	printk(KERN_ERR "Killing pid %d because of a lack of memory\n",
-	       current->pid);
-	lock_kernel();
-	sigaddset(&current->pending.signal, SIGBUS);
-	recalc_sigpending();
-	current->flags |= PF_SIGNALED;
-	do_exit(SIGBUS | 0x80);
-}
-
 void dump_thread(struct pt_regs *regs, struct user *u)
 {
 }
 
-void enable_hlt(void)
-{
-	panic("enable_hlt");
-}
-
-EXPORT_SYMBOL(enable_hlt);
-
-void disable_hlt(void)
-{
-	panic("disable_hlt");
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
 void *um_kmalloc(int size)
 {
 	return kmalloc(size, GFP_KERNEL);
@@ -313,36 +284,17 @@ void *um_vmalloc(int size)
 	return vmalloc(size);
 }
 
-void *um_vmalloc_atomic(int size)
-{
-	return __vmalloc(size, GFP_ATOMIC | __GFP_HIGHMEM, PAGE_KERNEL);
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
 }
 
-unsigned long get_fault_addr(void)
-{
-	return((unsigned long) current->thread.fault_addr);
-}
-
-EXPORT_SYMBOL(get_fault_addr);
-
-void not_implemented(void)
-{
-	printk(KERN_DEBUG "Something isn't implemented in here\n");
-}
-
-EXPORT_SYMBOL(not_implemented);
-
 int user_context(unsigned long sp)
 {
 	unsigned long stack;
 
 	stack = sp & (PAGE_MASK << CONFIG_KERNEL_STACK_ORDER);
-	return(stack != (unsigned long) current_thread);
+	return stack != (unsigned long) current_thread;
 }
 
 extern exitcall_t __uml_exitcall_begin, __uml_exitcall_end;
@@ -363,22 +315,22 @@ char *uml_strdup(char *string)
 
 int copy_to_user_proc(void __user *to, void *from, int size)
 {
-	return(copy_to_user(to, from, size));
+	return copy_to_user(to, from, size);
 }
 
 int copy_from_user_proc(void *to, void __user *from, int size)
 {
-	return(copy_from_user(to, from, size));
+	return copy_from_user(to, from, size);
 }
 
 int clear_user_proc(void __user *buf, int size)
 {
-	return(clear_user(buf, size));
+	return clear_user(buf, size);
 }
 
 int strlen_user_proc(char __user *str)
 {
-	return(strlen_user(str));
+	return strlen_user(str);
 }
 
 int smp_sigio_handler(void)
@@ -387,14 +339,14 @@ int smp_sigio_handler(void)
 	int cpu = current_thread->cpu;
 	IPI_handler(cpu);
 	if(cpu != 0)
-		return(1);
+		return 1;
 #endif
-	return(0);
+	return 0;
 }
 
 int cpu(void)
 {
-	return(current_thread->cpu);
+	return current_thread->cpu;
 }
 
 static atomic_t using_sysemu = ATOMIC_INIT(0);
@@ -443,7 +395,7 @@ int __init make_proc_sysemu(void)
 	if (ent == NULL)
 	{
 		printk(KERN_WARNING "Failed to register /proc/sysemu\n");
-		return(0);
+		return 0;
 	}
 
 	ent->read_proc  = proc_read_sysemu;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
