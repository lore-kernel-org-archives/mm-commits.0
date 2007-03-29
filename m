From: akpm@linux-foundation.org
Subject: - lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:44 -0700
Message-ID: <200703292314.l2TNEigj014719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934371AbXC2XSF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     lguest: Optimize away copy in and out of per-cpu guest pages
has been removed from the -mm tree.  Its filename was
     lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: Optimize away copy in and out of per-cpu guest pages
From: Rusty Russell <rusty@rustcorp.com.au>

Rather than copy in IDT, GDT and TSS every time, we only need do it when
something has changed (ie.  guest IDT/GDT/TSS has changed, or guest has
changed CPU, or CPU has just run another guest).

For the registers, we simply allocate them an entire page and map that over
the stack page in the guest.

This restores context switch speed to be comparable to the old segment-using
lguest.

[bunk@stusta.de: check_bug_kill() is no longer used]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/core.c                 |   46 ++++++++++------------
 arch/i386/lguest/hypervisor.S           |   15 ++-----
 arch/i386/lguest/interrupts_and_traps.c |   30 --------------
 arch/i386/lguest/lg.h                   |   15 +++++--
 arch/i386/lguest/lguest_user.c          |   14 +++++-
 arch/i386/lguest/page_tables.c          |   12 +++--
 arch/i386/lguest/segments.c             |   20 +++++----
 7 files changed, 72 insertions(+), 80 deletions(-)

diff -puN arch/i386/lguest/core.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/core.c
@@ -37,6 +37,7 @@ static struct {
 	unsigned short segment;
 } lguest_entry __attribute_used__;
 DEFINE_MUTEX(lguest_lock);
+static DEFINE_PER_CPU(struct lguest *, last_guest);
 
 /* FIXME: Make dynamic. */
 #define MAX_LGUEST_GUESTS 16
@@ -144,10 +145,10 @@ static int emulate_insn(struct lguest *l
 {
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
-	unsigned long physaddr = guest_pa(lg, lg->regs.eip);
+	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
 
 	/* This only works for addresses in linear mapping... */
-	if (lg->regs.eip < lg->page_offset)
+	if (lg->regs->eip < lg->page_offset)
 		return 0;
 	lhread(lg, &insn, physaddr, 1);
 
@@ -180,11 +181,11 @@ static int emulate_insn(struct lguest *l
 	if (in) {
 		/* Lower bit tells is whether it's a 16 or 32 bit access */
 		if (insn & 0x1)
-			lg->regs.eax = 0xFFFFFFFF;
+			lg->regs->eax = 0xFFFFFFFF;
 		else
-			lg->regs.eax |= (0xFFFF << shift);
+			lg->regs->eax |= (0xFFFF << shift);
 	}
-	lg->regs.eip += insnlen;
+	lg->regs->eip += insnlen;
 	return 1;
 }
 
@@ -260,36 +261,35 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
-static void copy_in_guest_info(struct lguest_pages *pages,
-			       struct lguest *lg)
+static void copy_in_guest_info(struct lguest_pages *pages, struct lguest *lg)
 {
-	/* Copy in regs. */
-	pages->regs = lg->regs;
+	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
+		__get_cpu_var(last_guest) = lg;
+		lg->last_pages = pages;
+		lg->changed = CHANGED_ALL;
+	}
 
-	/* TSS entries for direct traps. */
+	/* These are pretty cheap, so we do them unconditionally. */
+	pages->state.host_cr3 = __pa(current->mm->pgd);
+	map_hypervisor_in_guest(lg, pages);
 	pages->state.guest_tss.esp1 = lg->esp1;
 	pages->state.guest_tss.ss1 = lg->ss1;
 
-	/* CR3 */
-	pages->state.host_cr3 = __pa(current->mm->pgd);
-
 	/* Copy direct trap entries. */
-	copy_traps(lg, pages->state.guest_idt, lguest_default_idt_entries());
+	if (lg->changed & CHANGED_IDT)
+		copy_traps(lg, pages->state.guest_idt,
+			   lguest_default_idt_entries());
 
 	/* Copy all GDT entries but the TSS. */
-	copy_gdt(lg, pages->state.guest_gdt);
-}
+	if (lg->changed & CHANGED_GDT)
+		copy_gdt(lg, pages->state.guest_gdt);
 
-static void copy_out_guest_info(struct lguest *lg,
-				const struct lguest_pages *pages)
-{
-	/* We just want the regs back. */
-	lg->regs = pages->regs;
+	lg->changed = 0;
 }
 
 int run_guest(struct lguest *lg, char *__user user)
 {
-	struct lguest_regs *regs = &lg->regs;
+	struct lguest_regs *regs = lg->regs;
 
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
@@ -327,10 +327,8 @@ int run_guest(struct lguest *lg, char *_
 		set_ts(lg->ts);
 
 		pages = lguest_pages(raw_smp_processor_id());
-		map_hypervisor_in_guest(lg);
 		copy_in_guest_info(pages, lg);
 		run_guest_once(lg, pages);
-		copy_out_guest_info(lg, pages);
 
 		/* Save cr2 now if we page-faulted. */
 		if (regs->trapnum == 14)
diff -puN arch/i386/lguest/hypervisor.S~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/hypervisor.S
@@ -76,6 +76,8 @@ switch_to_guest:
 	/* Figure out where we are, based on stack (at top of regs). */	\
 	movl	%esp, %eax;						\
 	subl	$LGUEST_PAGES_regs, %eax;				\
+	/* Put trap number in %ebx before we switch cr3 and lose it. */ \
+	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
 	/* Switch to host page tables (host GDT, IDT and stack are in host   \
 	   mem, so need this first) */					\
 	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
@@ -104,24 +106,16 @@ return_to_host:
 
 deliver_to_host:
 	SWITCH_TO_HOST
-decode_idt_and_jmp:
 	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
 	 * will return to run_guest_once.  This is a feature. */
 	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
-	movl	LGUEST_PAGES_regs_trapnum(%eax), %eax
-	leal	(%edx,%eax,8), %eax
+	leal	(%edx,%ebx,8), %eax
 	movzwl	(%eax),%edx
 	movl	4(%eax), %eax
 	xorw	%ax, %ax
 	orl	%eax, %edx
 	jmp	*%edx
 
-/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
-deliver_to_host_with_errcode:
-	SWITCH_TO_HOST
-	pushl	LGUEST_PAGES_regs_errcode(%eax)
-	jmp decode_idt_and_jmp
-
 /* Real hardware interrupts are delivered straight to the host.  Others
    cause us to return to run_guest_once so it can decide what to do.  Note
    that some of these are overridden by the guest to deliver directly, and
@@ -154,7 +148,8 @@ irq_stubs:
 default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
-	IRQ_STUB 2 deliver_to_host_with_errcode	/* NMI */
+/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
+	IRQ_STUB 2 deliver_to_host		/* NMI */
 	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
 	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
 	IRQ_STUB 128 return_to_host		/* System call (overridden) */
diff -puN arch/i386/lguest/interrupts_and_traps.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/interrupts_and_traps.c
@@ -25,7 +25,7 @@ static void reflect_trap(struct lguest *
 {
 	u32 __user *gstack;
 	u32 eflags, ss, irq_enable;
-	struct lguest_regs *regs = &lg->regs;
+	struct lguest_regs *regs = lg->regs;
 
 	/* If they want a ring change, we use new stack and push old ss/esp */
 	if ((regs->ss&0x3) != GUEST_DPL) {
@@ -118,33 +118,6 @@ int deliver_trap(struct lguest *lg, unsi
 	return 1;
 }
 
-void check_bug_kill(struct lguest *lg)
-{
-#ifdef CONFIG_BUG
-	u32 eip = lg->regs.eip - PAGE_OFFSET;
-	u16 insn;
-
-	/* This only works for addresses in linear mapping... */
-	if (lg->regs.eip < PAGE_OFFSET)
-		return;
-	lhread(lg, &insn, eip, sizeof(insn));
-	if (insn == 0x0b0f) {
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-		u16 l;
-		u32 f;
-		char file[128];
-		lhread(lg, &l, eip+sizeof(insn), sizeof(l));
-		lhread(lg, &f, eip+sizeof(insn)+sizeof(l), sizeof(f));
-		lhread(lg, file, f - PAGE_OFFSET, sizeof(file));
-		file[sizeof(file)-1] = 0;
-		kill_guest(lg, "BUG() at %#x %s:%u", eip, file, l);
-#else
-		kill_guest(lg, "BUG() at %#x", eip);
-#endif	/* CONFIG_DEBUG_BUGVERBOSE */
-	}
-#endif	/* CONFIG_BUG */
-}
-
 static int direct_trap(const struct lguest *lg,
 		       const struct desc_struct *trap,
 		       unsigned int num)
@@ -219,6 +192,7 @@ void load_guest_idt_entry(struct lguest 
 	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
 		return;
 
+	lg->changed |= CHANGED_IDT;
 	if (num < ARRAY_SIZE(lg->idt))
 		set_trap(lg, &lg->idt[num], num, lo, hi);
 	else if (num == SYSCALL_VECTOR)
diff -puN arch/i386/lguest/lg.h~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/lg.h
@@ -118,10 +118,16 @@ struct lguest_pages
 	struct lguest_ro_state state;
 } __attribute__((aligned(PAGE_SIZE)));
 
+#define CHANGED_IDT		1
+#define CHANGED_GDT		2
+#define CHANGED_ALL	        3
+
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
-	struct lguest_regs regs;
+	/* At end of a page shared mapped over lguest_pages in guest.  */
+	unsigned long regs_page;
+	struct lguest_regs *regs;
 	struct lguest_data __user *lguest_data;
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
@@ -138,6 +144,10 @@ struct lguest
 	u32 esp1;
 	u8 ss1;
 
+	/* Bitmap of what has changed: see CHANGED_* above. */
+	int changed;
+	struct lguest_pages *last_pages;
+
 	/* We keep a small number of these. */
 	u32 pgdidx;
 	struct pgdir pgdirs[4];
@@ -185,7 +195,6 @@ int find_free_guest(void);
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest *lg);
 int deliver_trap(struct lguest *lg, unsigned int num);
-void check_bug_kill(struct lguest *lg);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void pin_stack_pages(struct lguest *lg);
 void pin_trap_pages(struct lguest *lg);
@@ -210,7 +219,7 @@ void guest_pagetable_clear_all(struct lg
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long cr3,
 		   unsigned long vaddr, u32 val);
-void map_hypervisor_in_guest(struct lguest *lg);
+void map_hypervisor_in_guest(struct lguest *lg, struct lguest_pages *pages);
 int demand_page(struct lguest *info, u32 cr2, int write);
 void pin_page(struct lguest *lg, u32 addr);
 
diff -puN arch/i386/lguest/lguest_user.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/lguest_user.c
--- a/arch/i386/lguest/lguest_user.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/lguest_user.c
@@ -100,19 +100,28 @@ static int initialize(struct file *file,
 	lg->guestid = i;
 	lg->pfn_limit = args[0];
 	lg->page_offset = args[3];
+	lg->regs_page = get_zeroed_page(GFP_KERNEL);
+	if (!lg->regs_page) {
+		err = -ENOMEM;
+		goto release_guest;
+	}
+	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
 
 	err = init_guest_pagetable(lg, args[1]);
 	if (err)
-		goto release_guest;
+		goto free_regs;
 
-	setup_regs(&lg->regs, args[2]);
+	setup_regs(lg->regs, args[2]);
 	lg->tsk = current;
 	lg->mm = get_task_mm(current);
+	lg->last_pages = NULL;
 	mutex_unlock(&lguest_lock);
 
 	file->private_data = lg;
 	return sizeof(args);
 
+free_regs:
+	free_page(lg->regs_page);
 release_guest:
 	memset(lg, 0, sizeof(*lg));
 unlock:
@@ -160,6 +169,7 @@ static int close(struct inode *inode, st
 	mmput(lg->mm);
 	if (lg->dead != (void *)1)
 		kfree(lg->dead);
+	free_page(lg->regs_page);
 	memset(lg, 0, sizeof(*lg));
 	mutex_unlock(&lguest_lock);
 	return 0;
diff -puN arch/i386/lguest/page_tables.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/page_tables.c
@@ -99,7 +99,7 @@ static u32 get_pte(struct lguest *lg, u3
    swapped.  It'd be nice to have a callback when Linux wants to swap out. */
 
 /* We fault pages in, which allows us to update accessed/dirty bits.
- * Return NULL or the pte page. */
+ * Return true if we got page. */
 static int page_in(struct lguest *lg, u32 vaddr, unsigned flags)
 {
 	u32 gtop, gpte;
@@ -323,13 +323,17 @@ void free_guest_pagetable(struct lguest 
 }
 
 /* Caller must be preempt-safe */
-void map_hypervisor_in_guest(struct lguest *lg)
+void map_hypervisor_in_guest(struct lguest *lg, struct lguest_pages *pages)
 {
-	int cpu = smp_processor_id();
+	u32 *hype_pte_page = __get_cpu_var(hypervisor_pte_pages);
 
 	/* Since hypervisor less that 4MB, we simply mug top pte page. */
 	lg->pgdirs[lg->pgdidx].pgdir[HYPERVISOR_PGD_ENTRY] =
-		(__pa(hypervisor_pte_page(cpu))| _PAGE_KERNEL);
+		(__pa(hype_pte_page) | _PAGE_KERNEL);
+
+	/* Map our regs page over stack page. */
+	hype_pte_page[(unsigned long)pages / PAGE_SIZE % PTES_PER_PAGE]
+		= (__pa(lg->regs_page) | _PAGE_KERNEL);
 }
 
 static void free_hypervisor_pte_pages(void)
diff -puN arch/i386/lguest/segments.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages arch/i386/lguest/segments.c
--- a/arch/i386/lguest/segments.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages
+++ a/arch/i386/lguest/segments.c
@@ -24,15 +24,15 @@ static int ignored_gdt(unsigned int num)
 /* We don't allow removal of CS, DS or SS; it doesn't make sense. */
 static void check_segment_use(struct lguest *lg, unsigned int desc)
 {
-	if (lg->regs.gs / 8 == desc)
-		lg->regs.gs = 0;
-	if (lg->regs.fs / 8 == desc)
-		lg->regs.fs = 0;
-	if (lg->regs.es / 8 == desc)
-		lg->regs.es = 0;
-	if (lg->regs.ds / 8 == desc
-	    || lg->regs.cs / 8 == desc
-	    || lg->regs.ss / 8 == desc)
+	if (lg->regs->gs / 8 == desc)
+		lg->regs->gs = 0;
+	if (lg->regs->fs / 8 == desc)
+		lg->regs->fs = 0;
+	if (lg->regs->es / 8 == desc)
+		lg->regs->es = 0;
+	if (lg->regs->ds / 8 == desc
+	    || lg->regs->cs / 8 == desc
+	    || lg->regs->ss / 8 == desc)
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
@@ -103,6 +103,7 @@ void load_guest_gdt(struct lguest *lg, u
 
 	lhread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
 	fixup_gdt_table(lg);
+	lg->changed |= CHANGED_GDT;
 }
 
 void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
@@ -111,4 +112,5 @@ void guest_load_tls(struct lguest *lg, c
 
 	lhread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
 	fixup_gdt_table(lg);
+	lg->changed |= CHANGED_GDT;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
ignore-vgacon-if-hardware-not-present.patch
