From: akpm@linux-foundation.org
Subject: - consolidate-show_regs-and-show_registers-for-i386.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:54 -0700
Message-ID: <200708141914.l7EJEsrW016661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764943AbXHNTUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     i386: consolidate show_regs() and show_registers()
has been removed from the -mm tree.  Its filename was
     consolidate-show_regs-and-show_registers-for-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: consolidate show_regs() and show_registers()
From: Pavel Emelyanov <xemul@openvz.org>

Both functions printk the same information, except for CRx and debug
registers in the show_registers() one and a bit different manner.  So move
the common code into one place.  This is already done for x86_64, so I
think it's worth having the same on i386.

This saves 100 bytes of .rodata section :) ...
   but only 8 from .text :(

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c |   56 +++++++++++++++++++++++++----------
 arch/i386/kernel/traps.c   |   32 ++------------------
 include/asm-i386/system.h  |    1 
 3 files changed, 45 insertions(+), 44 deletions(-)

diff -puN arch/i386/kernel/process.c~consolidate-show_regs-and-show_registers-for-i386 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~consolidate-show_regs-and-show_registers-for-i386
+++ a/arch/i386/kernel/process.c
@@ -297,34 +297,52 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
-void show_regs(struct pt_regs * regs)
+void __show_registers(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
+	unsigned long esp;
+	unsigned short ss, gs;
+
+	if (user_mode_vm(regs)) {
+		esp = regs->esp;
+		ss = regs->xss & 0xffff;
+		savesegment(gs, gs);
+	} else {
+		esp = (unsigned long) (&regs->esp);
+		savesegment(ss, ss);
+		savesegment(gs, gs);
+	}
 
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", current->pid, current->comm);
-	printk("EIP: %04x:[<%08lx>] CPU: %d\n",0xffff & regs->xcs,regs->eip, smp_processor_id());
+	printk("Pid: %d, comm: %.*s %s (%s %.*s)\n",
+			current->pid, TASK_COMM_LEN, current->comm,
+			print_tainted(), init_utsname()->release,
+			(int)strcspn(init_utsname()->version, " "),
+			init_utsname()->version);
+
+	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
+			0xffff & regs->xcs, regs->eip, regs->eflags,
+			smp_processor_id());
 	print_symbol("EIP is at %s\n", regs->eip);
 
-	if (user_mode_vm(regs))
-		printk(" ESP: %04x:%08lx",0xffff & regs->xss,regs->esp);
-	printk(" EFLAGS: %08lx    %s  (%s %.*s)\n",
-	       regs->eflags, print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
 	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
-		regs->eax,regs->ebx,regs->ecx,regs->edx);
-	printk("ESI: %08lx EDI: %08lx EBP: %08lx",
-		regs->esi, regs->edi, regs->ebp);
-	printk(" DS: %04x ES: %04x FS: %04x\n",
-	       0xffff & regs->xds,0xffff & regs->xes, 0xffff & regs->xfs);
+		regs->eax, regs->ebx, regs->ecx, regs->edx);
+	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
+		regs->esi, regs->edi, regs->ebp, esp);
+	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
+	       regs->xds & 0xffff, regs->xes & 0xffff,
+	       regs->xfs & 0xffff, gs, ss);
+
+	if (!all)
+		return;
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
-	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
+	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
+			cr0, cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
@@ -332,10 +350,16 @@ void show_regs(struct pt_regs * regs)
 	get_debugreg(d3, 3);
 	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
 			d0, d1, d2, d3);
+
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
-	printk("DR6: %08lx DR7: %08lx\n", d6, d7);
+	printk("DR6: %08lx DR7: %08lx\n",
+			d6, d7);
+}
 
+void show_regs(struct pt_regs * regs)
+{
+	__show_registers(regs, 1);
 	show_trace(NULL, regs, &regs->esp);
 }
 
diff -puN arch/i386/kernel/traps.c~consolidate-show_regs-and-show_registers-for-i386 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~consolidate-show_regs-and-show_registers-for-i386
+++ a/arch/i386/kernel/traps.c
@@ -281,33 +281,9 @@ EXPORT_SYMBOL(dump_stack);
 void show_registers(struct pt_regs *regs)
 {
 	int i;
-	int in_kernel = 1;
-	unsigned long esp;
-	unsigned short ss, gs;
-
-	esp = (unsigned long) (&regs->esp);
-	savesegment(ss, ss);
-	savesegment(gs, gs);
-	if (user_mode_vm(regs)) {
-		in_kernel = 0;
-		esp = regs->esp;
-		ss = regs->xss & 0xffff;
-	}
+
 	print_modules();
-	printk(KERN_EMERG "CPU:    %d\n"
-		KERN_EMERG "EIP:    %04x:[<%08lx>]    %s VLI\n"
-		KERN_EMERG "EFLAGS: %08lx   (%s %.*s)\n",
-		smp_processor_id(), 0xffff & regs->xcs, regs->eip,
-		print_tainted(), regs->eflags, init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	print_symbol(KERN_EMERG "EIP is at %s\n", regs->eip);
-	printk(KERN_EMERG "eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
-		regs->eax, regs->ebx, regs->ecx, regs->edx);
-	printk(KERN_EMERG "esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
-		regs->esi, regs->edi, regs->ebp, esp);
-	printk(KERN_EMERG "ds: %04x   es: %04x   fs: %04x  gs: %04x  ss: %04x\n",
-	       regs->xds & 0xffff, regs->xes & 0xffff, regs->xfs & 0xffff, gs, ss);
+	__show_registers(regs, 0);
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, current->pid,
 		current_thread_info(), current, task_thread_info(current));
@@ -315,14 +291,14 @@ void show_registers(struct pt_regs *regs
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
 	 */
-	if (in_kernel) {
+	if (!user_mode_vm(regs)) {
 		u8 *eip;
 		unsigned int code_prologue = code_bytes * 43 / 64;
 		unsigned int code_len = code_bytes;
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, (unsigned long *)esp, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->esp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff -puN include/asm-i386/system.h~consolidate-show_regs-and-show_registers-for-i386 include/asm-i386/system.h
--- a/include/asm-i386/system.h~consolidate-show_regs-and-show_registers-for-i386
+++ a/include/asm-i386/system.h
@@ -314,5 +314,6 @@ extern unsigned long arch_align_stack(un
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
 void default_idle(void);
+void __show_registers(struct pt_regs *, int all);
 
 #endif
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
