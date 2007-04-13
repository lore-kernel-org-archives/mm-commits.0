From: akpm@linux-foundation.org
Subject: - paravirt_ops-add-common-patching-machinery.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:26 -0700
Message-ID: <200704132330.l3DNUQc7012738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161256AbXDMXak (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, anthony@codemonkey.ws, jeremy@xensource.com, mingo@elte.hu, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: add common patching machinery
has been removed from the -mm tree.  Its filename was
     paravirt_ops-add-common-patching-machinery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: add common patching machinery
From: Jeremy Fitzhardinge <jeremy@goop.org>

Implement the actual patching machinery.  paravirt_patch_default() contains
the logic to automatically patch a callsite based on a few simple rules:

 - if the paravirt_op function is paravirt_nop, then patch nops
 - if the paravirt_op function is a jmp target, then jmp to it
 - if the paravirt_op function is callable and doesn't clobber too much
    for the callsite, call it directly

paravirt_patch_default is suitable as a default implementation of
paravirt_ops.patch, will remove most of the expensive indirect calls in favour
of either a direct call or a pile of nops.

Backends may implement their own patcher, however.  There are several helper
functions to help with this:

paravirt_patch_nop	nop out a callsite
paravirt_patch_ignore	leave the callsite as-is
paravirt_patch_call	patch a call if the caller and callee
			have compatible clobbers
paravirt_patch_jmp	patch in a jmp
paravirt_patch_insns	patch some literal instructions over
			the callsite, if they fit

This patch also implements more direct patches for the native case, so
that when running on native hardware many common operations are
implemented inline.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    5 -
 arch/i386/kernel/paravirt.c    |  154 +++++++++++++++++++++++++------
 include/asm-i386/paravirt.h    |   12 ++
 3 files changed, 144 insertions(+), 27 deletions(-)

diff -puN arch/i386/kernel/alternative.c~paravirt_ops-add-common-patching-machinery arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~paravirt_ops-add-common-patching-machinery
+++ a/arch/i386/kernel/alternative.c
@@ -361,11 +361,14 @@ void apply_paravirt(struct paravirt_patc
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
 
+		BUG_ON(used > p->len);
+
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
 	}
 
-	/* Sync to be conservative, in case we patched following instructions */
+	/* Sync to be conservative, in case we patched following
+	   instructions */
 	sync_core();
 }
 extern struct paravirt_patch_site __start_parainstructions[],
diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-add-common-patching-machinery arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-add-common-patching-machinery
+++ a/arch/i386/kernel/paravirt.c
@@ -54,40 +54,142 @@ char *memory_setup(void)
 #define DEF_NATIVE(name, code)					\
 	extern const char start_##name[], end_##name[];		\
 	asm("start_" #name ": " code "; end_" #name ":")
-DEF_NATIVE(cli, "cli");
-DEF_NATIVE(sti, "sti");
-DEF_NATIVE(popf, "push %eax; popf");
-DEF_NATIVE(pushf, "pushf; pop %eax");
+
+DEF_NATIVE(irq_disable, "cli");
+DEF_NATIVE(irq_enable, "sti");
+DEF_NATIVE(restore_fl, "push %eax; popf");
+DEF_NATIVE(save_fl, "pushf; pop %eax");
 DEF_NATIVE(iret, "iret");
-DEF_NATIVE(sti_sysexit, "sti; sysexit");
+DEF_NATIVE(irq_enable_sysexit, "sti; sysexit");
+DEF_NATIVE(read_cr2, "mov %cr2, %eax");
+DEF_NATIVE(write_cr3, "mov %eax, %cr3");
+DEF_NATIVE(read_cr3, "mov %cr3, %eax");
+DEF_NATIVE(clts, "clts");
+DEF_NATIVE(read_tsc, "rdtsc");
 
-static const struct native_insns
-{
-	const char *start, *end;
-} native_insns[] = {
-	[PARAVIRT_PATCH(irq_disable)] = { start_cli, end_cli },
-	[PARAVIRT_PATCH(irq_enable)] = { start_sti, end_sti },
-	[PARAVIRT_PATCH(restore_fl)] = { start_popf, end_popf },
-	[PARAVIRT_PATCH(save_fl)] = { start_pushf, end_pushf },
-	[PARAVIRT_PATCH(iret)] = { start_iret, end_iret },
-	[PARAVIRT_PATCH(irq_enable_sysexit)] = { start_sti_sysexit, end_sti_sysexit },
-};
+DEF_NATIVE(ud2a, "ud2a");
 
 static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
 {
-	unsigned int insn_len;
+	const unsigned char *start, *end;
+	unsigned ret;
+
+	switch(type) {
+#define SITE(x)	case PARAVIRT_PATCH(x):	start = start_##x; end = end_##x; goto patch_site
+		SITE(irq_disable);
+		SITE(irq_enable);
+		SITE(restore_fl);
+		SITE(save_fl);
+		SITE(iret);
+		SITE(irq_enable_sysexit);
+		SITE(read_cr2);
+		SITE(read_cr3);
+		SITE(write_cr3);
+		SITE(clts);
+		SITE(read_tsc);
+#undef SITE
+
+	patch_site:
+		ret = paravirt_patch_insns(insns, len, start, end);
+		break;
+
+	case PARAVIRT_PATCH(make_pgd):
+	case PARAVIRT_PATCH(make_pte):
+	case PARAVIRT_PATCH(pgd_val):
+	case PARAVIRT_PATCH(pte_val):
+#ifdef CONFIG_X86_PAE
+	case PARAVIRT_PATCH(make_pmd):
+	case PARAVIRT_PATCH(pmd_val):
+#endif
+		/* These functions end up returning exactly what
+		   they're passed, in the same registers. */
+		ret = paravirt_patch_nop();
+		break;
+
+	default:
+		ret = paravirt_patch_default(type, clobbers, insns, len);
+		break;
+	}
+
+	return ret;
+}
+
+unsigned paravirt_patch_nop(void)
+{
+	return 0;
+}
+
+unsigned paravirt_patch_ignore(unsigned len)
+{
+	return len;
+}
+
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len)
+{
+	unsigned char *call = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
+
+	if (tgt_clobbers & ~site_clobbers)
+		return len;	/* target would clobber too much for this site */
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*call++ = 0xe8;		/* call */
+	*(unsigned long *)call = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len)
+{
+	unsigned char *jmp = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
+
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*jmp++ = 0xe9;		/* jmp */
+	*(unsigned long *)jmp = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len)
+{
+	void *opfunc = *((void **)&paravirt_ops + type);
+	unsigned ret;
+
+	if (opfunc == NULL)
+		/* If there's no function, patch it with a ud2a (BUG) */
+		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
+	else if (opfunc == paravirt_nop)
+		/* If the operation is a nop, then nop the callsite */
+		ret = paravirt_patch_nop();
+	else if (type == PARAVIRT_PATCH(iret) ||
+		 type == PARAVIRT_PATCH(irq_enable_sysexit))
+		/* If operation requires a jmp, then jmp */
+		ret = paravirt_patch_jmp(opfunc, site, len);
+	else
+		/* Otherwise call the function; assume target could
+		   clobber any caller-save reg */
+		ret = paravirt_patch_call(opfunc, CLBR_ANY,
+					  site, clobbers, len);
 
-	/* Don't touch it if we don't have a replacement */
-	if (type >= ARRAY_SIZE(native_insns) || !native_insns[type].start)
-		return len;
+	return ret;
+}
 
-	insn_len = native_insns[type].end - native_insns[type].start;
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end)
+{
+	unsigned insn_len = end - start;
 
-	/* Similarly if we can't fit replacement. */
-	if (len < insn_len)
-		return len;
+	if (insn_len > len || start == NULL)
+		insn_len = len;
+	else
+		memcpy(site, start, insn_len);
 
-	memcpy(insns, native_insns[type].start, insn_len);
 	return insn_len;
 }
 
@@ -110,7 +212,7 @@ static void native_flush_tlb_global(void
 	__native_flush_tlb_global();
 }
 
-static void native_flush_tlb_single(u32 addr)
+static void native_flush_tlb_single(unsigned long addr)
 {
 	__native_flush_tlb_single(addr);
 }
diff -puN include/asm-i386/paravirt.h~paravirt_ops-add-common-patching-machinery include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-add-common-patching-machinery
+++ a/include/asm-i386/paravirt.h
@@ -248,6 +248,18 @@ extern struct paravirt_ops paravirt_ops;
 #define paravirt_alt(insn_string)					\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
+unsigned paravirt_patch_nop(void);
+unsigned paravirt_patch_ignore(unsigned len);
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len);
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len);
+
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end);
+
+
 /*
  * This generates an indirect call based on the operation type number.
  * The type number, computed in PARAVIRT_PATCH, is derived from the
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
