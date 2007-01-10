From: akpm@osdl.org
Subject: - convert-i386-pda-code-to-use-%fs.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:02 -0800
Message-ID: <200701102302.l0AN22a5010709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXAJXDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Ian.Campbell@XenSource.com, andi@muc.de, dada1@cosmosbay.com, frederik.deweerdt@gmail.com, jeremy@XenSource.com, mingo@elte.hu, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Convert i386 PDA code to use %fs
has been removed from the -mm tree.  Its filename was
     convert-i386-pda-code-to-use-%fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Convert i386 PDA code to use %fs
From: Jeremy Fitzhardinge <jeremy@goop.org>

Convert the PDA code to use %fs rather than %gs as the segment for
per-processor data.  This is because some processors show a small but
measurable performance gain for reloading a NULL segment selector (as %fs
generally is in user-space) versus a non-NULL one (as %gs generally is).

On modern processors the difference is very small, perhaps undetectable. 
Some old AMD "K6 3D+" processors are noticably slower when %fs is used
rather than %gs; I have no idea why this might be, but I think they're
sufficiently rare that it doesn't matter much.

This patch also fixes the math emulator, which had not been adjusted to
match the changed struct pt_regs.

[frederik.deweerdt@gmail.com: fixit with gdb]
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ian Campbell <Ian.Campbell@XenSource.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@muc.de>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/asm-offsets.c   |    2 -
 arch/i386/kernel/cpu/common.c    |   14 ++++++------
 arch/i386/kernel/entry.S         |   32 ++++++++++++++--------------
 arch/i386/kernel/head.S          |    6 ++---
 arch/i386/kernel/kprobes.c       |    4 +--
 arch/i386/kernel/process.c       |   24 +++++++++------------
 arch/i386/kernel/ptrace.c        |   16 +++++++-------
 arch/i386/kernel/signal.c        |   10 ++++----
 arch/i386/kernel/traps.c         |    7 +++---
 arch/i386/kernel/vm86.c          |   33 ++++++++++++++---------------
 arch/i386/math-emu/get_address.c |   14 ++++--------
 include/asm-i386/elf.h           |    4 +--
 include/asm-i386/mmu_context.h   |    2 -
 include/asm-i386/pda.h           |   12 +++++-----
 include/asm-i386/processor.h     |    6 ++---
 include/asm-i386/ptrace.h        |    4 +--
 16 files changed, 93 insertions(+), 97 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/asm-offsets.c
@@ -72,7 +72,7 @@ void foo(void)
 	OFFSET(PT_EAX, pt_regs, eax);
 	OFFSET(PT_DS,  pt_regs, xds);
 	OFFSET(PT_ES,  pt_regs, xes);
-	OFFSET(PT_GS,  pt_regs, xgs);
+	OFFSET(PT_FS,  pt_regs, xfs);
 	OFFSET(PT_ORIG_EAX, pt_regs, orig_eax);
 	OFFSET(PT_EIP, pt_regs, eip);
 	OFFSET(PT_CS,  pt_regs, xcs);
diff -puN arch/i386/kernel/cpu/common.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/cpu/common.c
@@ -605,7 +605,7 @@ void __init early_cpu_init(void)
 struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
-	regs->xgs = __KERNEL_PDA;
+	regs->xfs = __KERNEL_PDA;
 	return regs;
 }
 
@@ -662,12 +662,12 @@ struct i386_pda boot_pda = {
 	.pcurrent = &init_task,
 };
 
-static inline void set_kernel_gs(void)
+static inline void set_kernel_fs(void)
 {
-	/* Set %gs for this CPU's PDA.  Memory clobber is to create a
+	/* Set %fs for this CPU's PDA.  Memory clobber is to create a
 	   barrier with respect to any PDA operations, so the compiler
 	   doesn't move any before here. */
-	asm volatile ("mov %0, %%gs" : : "r" (__KERNEL_PDA) : "memory");
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 }
 
 /* Initialize the CPU's GDT and PDA.  The boot CPU does this for
@@ -721,7 +721,7 @@ static void __cpuinit _cpu_init(int cpu,
 	   the boot CPU, this will transition from the boot gdt+pda to
 	   the real ones). */
 	load_gdt(cpu_gdt_descr);
-	set_kernel_gs();
+	set_kernel_fs();
 
 	if (cpu_test_and_set(cpu, cpu_initialized)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
@@ -760,8 +760,8 @@ static void __cpuinit _cpu_init(int cpu,
 	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
 #endif
 
-	/* Clear %fs. */
-	asm volatile ("mov %0, %%fs" : : "r" (0));
+	/* Clear %gs. */
+	asm volatile ("mov %0, %%gs" : : "r" (0));
 
 	/* Clear all 6 debug registers: */
 	set_debugreg(0, 0);
diff -puN arch/i386/kernel/entry.S~convert-i386-pda-code-to-use-%fs arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/entry.S
@@ -30,7 +30,7 @@
  *	18(%esp) - %eax
  *	1C(%esp) - %ds
  *	20(%esp) - %es
- *	24(%esp) - %gs
+ *	24(%esp) - %fs
  *	28(%esp) - orig_eax
  *	2C(%esp) - %eip
  *	30(%esp) - %cs
@@ -99,9 +99,9 @@ VM_MASK		= 0x00020000
 
 #define SAVE_ALL \
 	cld; \
-	pushl %gs; \
+	pushl %fs; \
 	CFI_ADJUST_CFA_OFFSET 4;\
-	/*CFI_REL_OFFSET gs, 0;*/\
+	/*CFI_REL_OFFSET fs, 0;*/\
 	pushl %es; \
 	CFI_ADJUST_CFA_OFFSET 4;\
 	/*CFI_REL_OFFSET es, 0;*/\
@@ -133,7 +133,7 @@ VM_MASK		= 0x00020000
 	movl %edx, %ds; \
 	movl %edx, %es; \
 	movl $(__KERNEL_PDA), %edx; \
-	movl %edx, %gs
+	movl %edx, %fs
 
 #define RESTORE_INT_REGS \
 	popl %ebx;	\
@@ -166,9 +166,9 @@ VM_MASK		= 0x00020000
 2:	popl %es;	\
 	CFI_ADJUST_CFA_OFFSET -4;\
 	/*CFI_RESTORE es;*/\
-3:	popl %gs;	\
+3:	popl %fs;	\
 	CFI_ADJUST_CFA_OFFSET -4;\
-	/*CFI_RESTORE gs;*/\
+	/*CFI_RESTORE fs;*/\
 .pushsection .fixup,"ax";	\
 4:	movl $0,(%esp);	\
 	jmp 1b;		\
@@ -345,11 +345,11 @@ sysenter_past_esp:
 	movl PT_OLDESP(%esp), %ecx
 	xorl %ebp,%ebp
 	TRACE_IRQS_ON
-1:	mov  PT_GS(%esp), %gs
+1:	mov  PT_FS(%esp), %fs
 	ENABLE_INTERRUPTS_SYSEXIT
 	CFI_ENDPROC
 .pushsection .fixup,"ax"
-2:	movl $0,PT_GS(%esp)
+2:	movl $0,PT_FS(%esp)
 	jmp 1b
 .section __ex_table,"a"
 	.align 4
@@ -546,7 +546,7 @@ syscall_badsys:
 
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
-	movl %gs:PDA_cpu, %ebx; \
+	movl %fs:PDA_cpu, %ebx; \
 	PER_CPU(cpu_gdt_descr, %ebx); \
 	movl GDS_address(%ebx), %ebx; \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
@@ -628,7 +628,7 @@ KPROBE_ENTRY(page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	ALIGN
 error_code:
-	/* the function address is in %gs's slot on the stack */
+	/* the function address is in %fs's slot on the stack */
 	pushl %es
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET es, 0*/
@@ -657,20 +657,20 @@ error_code:
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ebx, 0
 	cld
-	pushl %gs
+	pushl %fs
 	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET gs, 0*/
+	/*CFI_REL_OFFSET fs, 0*/
 	movl $(__KERNEL_PDA), %ecx
-	movl %ecx, %gs
+	movl %ecx, %fs
 	UNWIND_ESPFIX_STACK
 	popl %ecx
 	CFI_ADJUST_CFA_OFFSET -4
 	/*CFI_REGISTER es, ecx*/
-	movl PT_GS(%esp), %edi		# get the function address
+	movl PT_FS(%esp), %edi		# get the function address
 	movl PT_ORIG_EAX(%esp), %edx	# get the error code
 	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
-	mov  %ecx, PT_GS(%esp)
-	/*CFI_REL_OFFSET gs, ES*/
+	mov  %ecx, PT_FS(%esp)
+	/*CFI_REL_OFFSET fs, ES*/
 	movl $(__USER_DS), %ecx
 	movl %ecx, %ds
 	movl %ecx, %es
diff -puN arch/i386/kernel/head.S~convert-i386-pda-code-to-use-%fs arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/head.S
@@ -319,12 +319,12 @@ is386:	movl $2,%ecx		# set MP
 	movl %eax,%ds
 	movl %eax,%es
 
-	xorl %eax,%eax			# Clear FS and LDT
-	movl %eax,%fs
+	xorl %eax,%eax			# Clear GS and LDT
+	movl %eax,%gs
 	lldt %ax
 
 	movl $(__KERNEL_PDA),%eax
-	mov  %eax,%gs
+	mov  %eax,%fs
 
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
diff -puN arch/i386/kernel/kprobes.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/kprobes.c
@@ -363,7 +363,7 @@ no_kprobe:
 			"	pushf\n"
 			/* skip cs, eip, orig_eax */
 			"	subl $12, %esp\n"
-			"	pushl %gs\n"
+			"	pushl %fs\n"
 			"	pushl %ds\n"
 			"	pushl %es\n"
 			"	pushl %eax\n"
@@ -387,7 +387,7 @@ no_kprobe:
 			"	popl %edi\n"
 			"	popl %ebp\n"
 			"	popl %eax\n"
-			/* skip eip, orig_eax, es, ds, gs */
+			/* skip eip, orig_eax, es, ds, fs */
 			"	addl $20, %esp\n"
 			"	popf\n"
 			"	ret\n");
diff -puN arch/i386/kernel/process.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/process.c
@@ -308,8 +308,8 @@ void show_regs(struct pt_regs * regs)
 		regs->eax,regs->ebx,regs->ecx,regs->edx);
 	printk("ESI: %08lx EDI: %08lx EBP: %08lx",
 		regs->esi, regs->edi, regs->ebp);
-	printk(" DS: %04x ES: %04x GS: %04x\n",
-	       0xffff & regs->xds,0xffff & regs->xes, 0xffff & regs->xgs);
+	printk(" DS: %04x ES: %04x FS: %04x\n",
+	       0xffff & regs->xds,0xffff & regs->xes, 0xffff & regs->xfs);
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
@@ -340,7 +340,7 @@ int kernel_thread(int (*fn)(void *), voi
 
 	regs.xds = __USER_DS;
 	regs.xes = __USER_DS;
-	regs.xgs = __KERNEL_PDA;
+	regs.xfs = __KERNEL_PDA;
 	regs.orig_eax = -1;
 	regs.eip = (unsigned long) kernel_thread_helper;
 	regs.xcs = __KERNEL_CS | get_kernel_rpl();
@@ -425,7 +425,7 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread.eip = (unsigned long) ret_from_fork;
 
-	savesegment(fs,p->thread.fs);
+	savesegment(gs,p->thread.gs);
 
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
@@ -501,8 +501,8 @@ void dump_thread(struct pt_regs * regs, 
 	dump->regs.eax = regs->eax;
 	dump->regs.ds = regs->xds;
 	dump->regs.es = regs->xes;
-	savesegment(fs,dump->regs.fs);
-	dump->regs.gs = regs->xgs;
+	dump->regs.fs = regs->xfs;
+	savesegment(gs,dump->regs.gs);
 	dump->regs.orig_eax = regs->orig_eax;
 	dump->regs.eip = regs->eip;
 	dump->regs.cs = regs->xcs;
@@ -653,7 +653,7 @@ struct task_struct fastcall * __switch_t
 	load_esp0(tss, next);
 
 	/*
-	 * Save away %fs. No need to save %gs, as it was saved on the
+	 * Save away %gs. No need to save %fs, as it was saved on the
 	 * stack on entry.  No need to save %es and %ds, as those are
 	 * always kernel segments while inside the kernel.  Doing this
 	 * before setting the new TLS descriptors avoids the situation
@@ -662,7 +662,7 @@ struct task_struct fastcall * __switch_t
 	 * used %fs or %gs (it does not today), or if the kernel is
 	 * running inside of a hypervisor layer.
 	 */
-	savesegment(fs, prev->fs);
+	savesegment(gs, prev->gs);
 
 	/*
 	 * Load the per-thread Thread-Local Storage descriptor.
@@ -670,12 +670,10 @@ struct task_struct fastcall * __switch_t
 	load_TLS(next, cpu);
 
 	/*
-	 * Restore %fs if needed.
-	 *
-	 * Glibc normally makes %fs be zero.
+	 * Restore %gs if needed (which is common)
 	 */
-	if (unlikely(prev->fs | next->fs))
-		loadsegment(fs, next->fs);
+	if (prev->gs | next->gs)
+		loadsegment(gs, next->gs);
 
 	write_pda(pcurrent, next_p);
 
diff -puN arch/i386/kernel/ptrace.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/ptrace.c
@@ -89,14 +89,14 @@ static int putreg(struct task_struct *ch
 	unsigned long regno, unsigned long value)
 {
 	switch (regno >> 2) {
-		case FS:
+		case GS:
 			if (value && (value & 3) != 3)
 				return -EIO;
-			child->thread.fs = value;
+			child->thread.gs = value;
 			return 0;
 		case DS:
 		case ES:
-		case GS:
+		case FS:
 			if (value && (value & 3) != 3)
 				return -EIO;
 			value &= 0xffff;
@@ -112,7 +112,7 @@ static int putreg(struct task_struct *ch
 			value |= get_stack_long(child, EFL_OFFSET) & ~FLAG_MASK;
 			break;
 	}
-	if (regno > ES*4)
+	if (regno > FS*4)
 		regno -= 1*4;
 	put_stack_long(child, regno, value);
 	return 0;
@@ -124,18 +124,18 @@ static unsigned long getreg(struct task_
 	unsigned long retval = ~0UL;
 
 	switch (regno >> 2) {
-		case FS:
-			retval = child->thread.fs;
+		case GS:
+			retval = child->thread.gs;
 			break;
 		case DS:
 		case ES:
-		case GS:
+		case FS:
 		case SS:
 		case CS:
 			retval = 0xffff;
 			/* fall through */
 		default:
-			if (regno > ES*4)
+			if (regno > FS*4)
 				regno -= 1*4;
 			retval &= get_stack_long(child, regno);
 	}
diff -puN arch/i386/kernel/signal.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/signal.c
@@ -128,8 +128,8 @@ restore_sigcontext(struct pt_regs *regs,
 			 X86_EFLAGS_TF | X86_EFLAGS_SF | X86_EFLAGS_ZF | \
 			 X86_EFLAGS_AF | X86_EFLAGS_PF | X86_EFLAGS_CF)
 
-	COPY_SEG(gs);
-	GET_SEG(fs);
+	GET_SEG(gs);
+	COPY_SEG(fs);
 	COPY_SEG(es);
 	COPY_SEG(ds);
 	COPY(edi);
@@ -244,9 +244,9 @@ setup_sigcontext(struct sigcontext __use
 {
 	int tmp, err = 0;
 
-	err |= __put_user(regs->xgs, (unsigned int __user *)&sc->gs);
-	savesegment(fs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->fs);
+	err |= __put_user(regs->xfs, (unsigned int __user *)&sc->fs);
+	savesegment(gs, tmp);
+	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
 
 	err |= __put_user(regs->xes, (unsigned int __user *)&sc->es);
 	err |= __put_user(regs->xds, (unsigned int __user *)&sc->ds);
diff -puN arch/i386/kernel/traps.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/traps.c
@@ -291,10 +291,11 @@ void show_registers(struct pt_regs *regs
 	int i;
 	int in_kernel = 1;
 	unsigned long esp;
-	unsigned short ss;
+	unsigned short ss, gs;
 
 	esp = (unsigned long) (&regs->esp);
 	savesegment(ss, ss);
+	savesegment(gs, gs);
 	if (user_mode_vm(regs)) {
 		in_kernel = 0;
 		esp = regs->esp;
@@ -313,8 +314,8 @@ void show_registers(struct pt_regs *regs
 		regs->eax, regs->ebx, regs->ecx, regs->edx);
 	printk(KERN_EMERG "esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
 		regs->esi, regs->edi, regs->ebp, esp);
-	printk(KERN_EMERG "ds: %04x   es: %04x   ss: %04x\n",
-		regs->xds & 0xffff, regs->xes & 0xffff, ss);
+	printk(KERN_EMERG "ds: %04x   es: %04x   fs: %04x  gs: %04x  ss: %04x\n",
+	       regs->xds & 0xffff, regs->xes & 0xffff, regs->xfs & 0xffff, gs, ss);
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, current->pid,
 		current_thread_info(), current, current->thread_info);
diff -puN arch/i386/kernel/vm86.c~convert-i386-pda-code-to-use-%fs arch/i386/kernel/vm86.c
--- a/arch/i386/kernel/vm86.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/kernel/vm86.c
@@ -96,12 +96,12 @@ static int copy_vm86_regs_to_user(struct
 {
 	int ret = 0;
 
-	/* kernel_vm86_regs is missing xfs, so copy everything up to
-	   (but not including) xgs, and then rest after xgs. */
-	ret += copy_to_user(user, regs, offsetof(struct kernel_vm86_regs, pt.xgs));
-	ret += copy_to_user(&user->__null_gs, &regs->pt.xgs,
+	/* kernel_vm86_regs is missing xgs, so copy everything up to
+	   (but not including) orig_eax, and then rest including orig_eax. */
+	ret += copy_to_user(user, regs, offsetof(struct kernel_vm86_regs, pt.orig_eax));
+	ret += copy_to_user(&user->orig_eax, &regs->pt.orig_eax,
 			    sizeof(struct kernel_vm86_regs) -
-			    offsetof(struct kernel_vm86_regs, pt.xgs));
+			    offsetof(struct kernel_vm86_regs, pt.orig_eax));
 
 	return ret;
 }
@@ -113,12 +113,13 @@ static int copy_vm86_regs_from_user(stru
 {
 	int ret = 0;
 
-	ret += copy_from_user(regs, user, offsetof(struct kernel_vm86_regs, pt.xgs));
-	ret += copy_from_user(&regs->pt.xgs, &user->__null_gs,
+	/* copy eax-xfs inclusive */
+	ret += copy_from_user(regs, user, offsetof(struct kernel_vm86_regs, pt.orig_eax));
+	/* copy orig_eax-__gsh+extra */
+	ret += copy_from_user(&regs->pt.orig_eax, &user->orig_eax,
 			      sizeof(struct kernel_vm86_regs) -
-			      offsetof(struct kernel_vm86_regs, pt.xgs) +
+			      offsetof(struct kernel_vm86_regs, pt.orig_eax) +
 			      extra);
-
 	return ret;
 }
 
@@ -157,8 +158,8 @@ struct pt_regs * fastcall save_v86_state
 
 	ret = KVM86->regs32;
 
-	loadsegment(fs, current->thread.saved_fs);
-	ret->xgs = current->thread.saved_gs;
+	ret->xfs = current->thread.saved_fs;
+	loadsegment(gs, current->thread.saved_gs);
 
 	return ret;
 }
@@ -285,9 +286,9 @@ static void do_sys_vm86(struct kernel_vm
  */
 	info->regs.pt.xds = 0;
 	info->regs.pt.xes = 0;
-	info->regs.pt.xgs = 0;
+	info->regs.pt.xfs = 0;
 
-/* we are clearing fs later just before "jmp resume_userspace",
+/* we are clearing gs later just before "jmp resume_userspace",
  * because it is not saved/restored.
  */
 
@@ -321,8 +322,8 @@ static void do_sys_vm86(struct kernel_vm
  */
 	info->regs32->eax = 0;
 	tsk->thread.saved_esp0 = tsk->thread.esp0;
-	savesegment(fs, tsk->thread.saved_fs);
-	tsk->thread.saved_gs = info->regs32->xgs;
+	tsk->thread.saved_fs = info->regs32->xfs;
+	savesegment(gs, tsk->thread.saved_gs);
 
 	tss = &per_cpu(init_tss, get_cpu());
 	tsk->thread.esp0 = (unsigned long) &info->VM86_TSS_ESP0;
@@ -342,7 +343,7 @@ static void do_sys_vm86(struct kernel_vm
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
-		"mov  %2, %%fs\n\t"
+		"mov  %2, %%gs\n\t"
 		"jmp resume_userspace"
 		: /* no outputs */
 		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));
diff -puN arch/i386/math-emu/get_address.c~convert-i386-pda-code-to-use-%fs arch/i386/math-emu/get_address.c
--- a/arch/i386/math-emu/get_address.c~convert-i386-pda-code-to-use-%fs
+++ a/arch/i386/math-emu/get_address.c
@@ -56,15 +56,14 @@ static int reg_offset_vm86[] = {
 #define VM86_REG_(x) (*(unsigned short *) \
 		      (reg_offset_vm86[((unsigned)x)]+(u_char *) FPU_info))
 
-/* These are dummy, fs and gs are not saved on the stack. */
-#define ___FS ___ds
+/* This dummy, gs is not saved on the stack. */
 #define ___GS ___ds
 
 static int reg_offset_pm[] = {
 	offsetof(struct info,___cs),
 	offsetof(struct info,___ds),
 	offsetof(struct info,___es),
-	offsetof(struct info,___FS),
+	offsetof(struct info,___fs),
 	offsetof(struct info,___GS),
 	offsetof(struct info,___ss),
 	offsetof(struct info,___ds)
@@ -169,13 +168,10 @@ static long pm_address(u_char FPU_modrm,
 
   switch ( segment )
     {
-      /* fs and gs aren't used by the kernel, so they still have their
-	 user-space values. */
-    case PREFIX_FS_-1:
-      /* N.B. - movl %seg, mem is a 2 byte write regardless of prefix */
-      savesegment(fs, addr->selector);
-      break;
+      /* gs isn't used by the kernel, so it still has its
+	 user-space value. */
     case PREFIX_GS_-1:
+      /* N.B. - movl %seg, mem is a 2 byte write regardless of prefix */
       savesegment(gs, addr->selector);
       break;
     default:
diff -puN include/asm-i386/elf.h~convert-i386-pda-code-to-use-%fs include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~convert-i386-pda-code-to-use-%fs
+++ a/include/asm-i386/elf.h
@@ -90,8 +90,8 @@ typedef struct user_fxsr_struct elf_fpxr
 	pr_reg[6] = regs->eax;				\
 	pr_reg[7] = regs->xds;				\
 	pr_reg[8] = regs->xes;				\
-	savesegment(fs,pr_reg[9]);			\
-	pr_reg[10] = regs->xgs;				\
+	pr_reg[9] = regs->xfs;				\
+	savesegment(gs,pr_reg[10]);			\
 	pr_reg[11] = regs->orig_eax;			\
 	pr_reg[12] = regs->eip;				\
 	pr_reg[13] = regs->xcs;				\
diff -puN include/asm-i386/mmu_context.h~convert-i386-pda-code-to-use-%fs include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~convert-i386-pda-code-to-use-%fs
+++ a/include/asm-i386/mmu_context.h
@@ -63,7 +63,7 @@ static inline void switch_mm(struct mm_s
 }
 
 #define deactivate_mm(tsk, mm)			\
-	asm("movl %0,%%fs": :"r" (0));
+	asm("movl %0,%%gs": :"r" (0));
 
 #define activate_mm(prev, next) \
 	switch_mm((prev),(next),NULL)
diff -puN include/asm-i386/pda.h~convert-i386-pda-code-to-use-%fs include/asm-i386/pda.h
--- a/include/asm-i386/pda.h~convert-i386-pda-code-to-use-%fs
+++ a/include/asm-i386/pda.h
@@ -39,19 +39,19 @@ extern struct i386_pda _proxy_pda;
 		if (0) { T__ tmp__; tmp__ = (val); }			\
 		switch (sizeof(_proxy_pda.field)) {			\
 		case 1:							\
-			asm(op "b %1,%%gs:%c2"				\
+			asm(op "b %1,%%fs:%c2"				\
 			    : "+m" (_proxy_pda.field)			\
 			    :"ri" ((T__)val),				\
 			     "i"(pda_offset(field)));			\
 			break;						\
 		case 2:							\
-			asm(op "w %1,%%gs:%c2"				\
+			asm(op "w %1,%%fs:%c2"				\
 			    : "+m" (_proxy_pda.field)			\
 			    :"ri" ((T__)val),				\
 			     "i"(pda_offset(field)));			\
 			break;						\
 		case 4:							\
-			asm(op "l %1,%%gs:%c2"				\
+			asm(op "l %1,%%fs:%c2"				\
 			    : "+m" (_proxy_pda.field)			\
 			    :"ri" ((T__)val),				\
 			     "i"(pda_offset(field)));			\
@@ -65,19 +65,19 @@ extern struct i386_pda _proxy_pda;
 		typeof(_proxy_pda.field) ret__;				\
 		switch (sizeof(_proxy_pda.field)) {			\
 		case 1:							\
-			asm(op "b %%gs:%c1,%0"				\
+			asm(op "b %%fs:%c1,%0"				\
 			    : "=r" (ret__)				\
 			    : "i" (pda_offset(field)),			\
 			      "m" (_proxy_pda.field));			\
 			break;						\
 		case 2:							\
-			asm(op "w %%gs:%c1,%0"				\
+			asm(op "w %%fs:%c1,%0"				\
 			    : "=r" (ret__)				\
 			    : "i" (pda_offset(field)),			\
 			      "m" (_proxy_pda.field));			\
 			break;						\
 		case 4:							\
-			asm(op "l %%gs:%c1,%0"				\
+			asm(op "l %%fs:%c1,%0"				\
 			    : "=r" (ret__)				\
 			    : "i" (pda_offset(field)),			\
 			      "m" (_proxy_pda.field));			\
diff -puN include/asm-i386/processor.h~convert-i386-pda-code-to-use-%fs include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~convert-i386-pda-code-to-use-%fs
+++ a/include/asm-i386/processor.h
@@ -424,7 +424,7 @@ struct thread_struct {
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
-	.gs = __KERNEL_PDA,						\
+	.fs = __KERNEL_PDA,						\
 }
 
 /*
@@ -442,8 +442,8 @@ struct thread_struct {
 }
 
 #define start_thread(regs, new_eip, new_esp) do {		\
-	__asm__("movl %0,%%fs": :"r" (0));			\
-	regs->xgs = 0;						\
+	__asm__("movl %0,%%gs": :"r" (0));			\
+	regs->xfs = 0;						\
 	set_fs(USER_DS);					\
 	regs->xds = __USER_DS;					\
 	regs->xes = __USER_DS;					\
diff -puN include/asm-i386/ptrace.h~convert-i386-pda-code-to-use-%fs include/asm-i386/ptrace.h
--- a/include/asm-i386/ptrace.h~convert-i386-pda-code-to-use-%fs
+++ a/include/asm-i386/ptrace.h
@@ -16,8 +16,8 @@ struct pt_regs {
 	long eax;
 	int  xds;
 	int  xes;
-	/* int  xfs; */
-	int  xgs;
+	int  xfs;
+	/* int  xgs; */
 	long orig_eax;
 	long eip;
 	int  xcs;
_

Patches currently in -mm which might be from jeremy@goop.org are

gtod-uninline-jiffiesh.patch
