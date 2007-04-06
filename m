From: akpm@linux-foundation.org
Subject: + paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:35 -0700
Message-ID: <200704062326.l36NQZC0022520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452AbXDFX0q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     paravirt_ops: Use patch site IDs computed from offset in paravirt_ops structure
has been added to the -mm tree.  Its filename is
     paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt_ops: Use patch site IDs computed from offset in paravirt_ops structure
From: Jeremy Fitzhardinge <jeremy@goop.org>

Use patch type identifiers derived from the offset of the operation in the
paravirt_ops structure.  This avoids having to maintain a separate enum for
patch site types.

Also, since the identifier is derived from the offset into paravirt_ops, the
offset can be derived from the identifier.  This is used to remove replicated
information in the various callsite macros, which has been a source of bugs in
the past.

This patch also drops the fused save_fl+cli operation, which doesn't really
add much and makes things more complex - specifically because it breaks the
1:1 relationship between identifiers and offsets.  If this operation turns out
to be particularly beneficial, then the right answer is to define a new
entrypoint for it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |   14 +-
 arch/i386/kernel/vmi.c      |   39 +------
 include/asm-i386/paravirt.h |  179 +++++++++++++++++-----------------
 3 files changed, 105 insertions(+), 127 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/arch/i386/kernel/paravirt.c
@@ -58,7 +58,6 @@ DEF_NATIVE(cli, "cli");
 DEF_NATIVE(sti, "sti");
 DEF_NATIVE(popf, "push %eax; popf");
 DEF_NATIVE(pushf, "pushf; pop %eax");
-DEF_NATIVE(pushf_cli, "pushf; pop %eax; cli");
 DEF_NATIVE(iret, "iret");
 DEF_NATIVE(sti_sysexit, "sti; sysexit");
 
@@ -66,13 +65,12 @@ static const struct native_insns
 {
 	const char *start, *end;
 } native_insns[] = {
-	[PARAVIRT_IRQ_DISABLE] = { start_cli, end_cli },
-	[PARAVIRT_IRQ_ENABLE] = { start_sti, end_sti },
-	[PARAVIRT_RESTORE_FLAGS] = { start_popf, end_popf },
-	[PARAVIRT_SAVE_FLAGS] = { start_pushf, end_pushf },
-	[PARAVIRT_SAVE_FLAGS_IRQ_DISABLE] = { start_pushf_cli, end_pushf_cli },
-	[PARAVIRT_INTERRUPT_RETURN] = { start_iret, end_iret },
-	[PARAVIRT_STI_SYSEXIT] = { start_sti_sysexit, end_sti_sysexit },
+	[PARAVIRT_PATCH(irq_disable)] = { start_cli, end_cli },
+	[PARAVIRT_PATCH(irq_enable)] = { start_sti, end_sti },
+	[PARAVIRT_PATCH(restore_fl)] = { start_popf, end_popf },
+	[PARAVIRT_PATCH(save_fl)] = { start_pushf, end_pushf },
+	[PARAVIRT_PATCH(iret)] = { start_iret, end_iret },
+	[PARAVIRT_PATCH(irq_enable_sysexit)] = { start_sti_sysexit, end_sti_sysexit },
 };
 
 static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
diff -puN arch/i386/kernel/vmi.c~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/arch/i386/kernel/vmi.c
@@ -83,11 +83,6 @@ extern struct paravirt_patch_site __star
 #define MNEM_JMP  0xe9
 #define MNEM_RET  0xc3
 
-static char irq_save_disable_callout[] = {
-	MNEM_CALL, 0, 0, 0, 0,
-	MNEM_CALL, 0, 0, 0, 0,
-	MNEM_RET
-};
 #define IRQ_PATCH_INT_MASK 0
 #define IRQ_PATCH_DISABLE  5
 
@@ -135,33 +130,17 @@ static unsigned patch_internal(int call,
 static unsigned vmi_patch(u8 type, u16 clobbers, void *insns, unsigned len)
 {
 	switch (type) {
-		case PARAVIRT_IRQ_DISABLE:
+		case PARAVIRT_PATCH(irq_disable):
 			return patch_internal(VMI_CALL_DisableInterrupts, len, insns);
-		case PARAVIRT_IRQ_ENABLE:
+		case PARAVIRT_PATCH(irq_enable):
 			return patch_internal(VMI_CALL_EnableInterrupts, len, insns);
-		case PARAVIRT_RESTORE_FLAGS:
+		case PARAVIRT_PATCH(restore_fl):
 			return patch_internal(VMI_CALL_SetInterruptMask, len, insns);
-		case PARAVIRT_SAVE_FLAGS:
+		case PARAVIRT_PATCH(save_fl):
 			return patch_internal(VMI_CALL_GetInterruptMask, len, insns);
-        	case PARAVIRT_SAVE_FLAGS_IRQ_DISABLE:
-			if (len >= 10) {
-				patch_internal(VMI_CALL_GetInterruptMask, len, insns);
-				patch_internal(VMI_CALL_DisableInterrupts, len-5, insns+5);
-				return 10;
-			} else {
-				/*
-				 * You bastards didn't leave enough room to
-				 * patch save_flags_irq_disable inline.  Patch
-				 * to a helper
-				 */
-				BUG_ON(len < 5);
-				*(char *)insns = MNEM_CALL;
-				patch_offset(insns, irq_save_disable_callout);
-				return 5;
-			}
-		case PARAVIRT_INTERRUPT_RETURN:
+		case PARAVIRT_PATCH(iret):
 			return patch_internal(VMI_CALL_IRET, len, insns);
-		case PARAVIRT_STI_SYSEXIT:
+		case PARAVIRT_PATCH(irq_enable_sysexit):
 			return patch_internal(VMI_CALL_SYSEXIT, len, insns);
 		default:
 			break;
@@ -798,12 +777,6 @@ static inline int __init activate_vmi(vo
 	para_fill(irq_disable, DisableInterrupts);
 	para_fill(irq_enable, EnableInterrupts);
 
-	/* irq_save_disable !!! sheer pain */
-	patch_offset(&irq_save_disable_callout[IRQ_PATCH_INT_MASK],
-		     (char *)paravirt_ops.save_fl);
-	patch_offset(&irq_save_disable_callout[IRQ_PATCH_DISABLE],
-		     (char *)paravirt_ops.irq_disable);
-
 	para_fill(wbinvd, WBINVD);
 	para_fill(read_tsc, RDTSC);
 
diff -puN include/asm-i386/paravirt.h~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/include/asm-i386/paravirt.h
@@ -4,19 +4,8 @@
  * para-virtualization: those hooks are defined here. */
 
 #ifdef CONFIG_PARAVIRT
-#include <linux/stringify.h>
 #include <asm/page.h>
 
-/* These are the most performance critical ops, so we want to be able to patch
- * callers */
-#define PARAVIRT_IRQ_DISABLE 0
-#define PARAVIRT_IRQ_ENABLE 1
-#define PARAVIRT_RESTORE_FLAGS 2
-#define PARAVIRT_SAVE_FLAGS 3
-#define PARAVIRT_SAVE_FLAGS_IRQ_DISABLE 4
-#define PARAVIRT_INTERRUPT_RETURN 5
-#define PARAVIRT_STI_SYSEXIT 6
-
 /* Bitmask of what can be clobbered: usually at least eax. */
 #define CLBR_NONE 0x0
 #define CLBR_EAX 0x1
@@ -191,6 +180,28 @@ struct paravirt_ops
 
 extern struct paravirt_ops paravirt_ops;
 
+#define PARAVIRT_PATCH(x)					\
+	(offsetof(struct paravirt_ops, x) / sizeof(void *))
+
+#define paravirt_type(type)					\
+	[paravirt_typenum] "i" (PARAVIRT_PATCH(type))
+#define paravirt_clobber(clobber)		\
+	[paravirt_clobber] "i" (clobber)
+
+#define PARAVIRT_CALL	"call *paravirt_ops+%c[paravirt_typenum]*4;"
+
+#define _paravirt_alt(insn_string, type, clobber)	\
+	"771:\n\t" insn_string "\n" "772:\n"		\
+	".pushsection .parainstructions,\"a\"\n"	\
+	"  .long 771b\n"				\
+	"  .byte " type "\n"				\
+	"  .byte 772b-771b\n"				\
+	"  .short " clobber "\n"			\
+	".popsection\n"
+
+#define paravirt_alt(insn_string)				\
+	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
+
 #define paravirt_enabled() (paravirt_ops.paravirt_enabled)
 
 static inline void load_esp0(struct tss_struct *tss,
@@ -512,93 +523,89 @@ struct paravirt_patch_site {
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
-#define paravirt_alt(insn_string, typenum, clobber)	\
-	"771:\n\t" insn_string "\n" "772:\n"		\
-	".pushsection .parainstructions,\"a\"\n"	\
-	"  .long 771b\n"				\
-	"  .byte " __stringify(typenum) "\n"		\
-	"  .byte 772b-771b\n"				\
-	"  .short " __stringify(clobber) "\n"		\
-	".popsection"
-
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long f;
 
-	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
-					   "call *%1;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_SAVE_FLAGS, CLBR_NONE)
-			     : "=a"(f): "m"(paravirt_ops.save_fl)
-			     : "memory", "cc");
+	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+				  PARAVIRT_CALL
+				  "popl %%edx; popl %%ecx")
+		     : "=a"(f)
+		     : paravirt_type(save_fl),
+		       paravirt_clobber(CLBR_NONE)
+		     : "memory", "cc");
 	return f;
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
-					   "call *%1;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_RESTORE_FLAGS, CLBR_EAX)
-			     : "=a"(f) : "m" (paravirt_ops.restore_fl), "0"(f)
-			     : "memory", "cc");
+	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+				  PARAVIRT_CALL
+				  "popl %%edx; popl %%ecx")
+		     : "=a"(f)
+		     : "0"(f),
+		       paravirt_type(restore_fl),
+		       paravirt_clobber(CLBR_EAX)
+		     : "memory", "cc");
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
-					   "call *%0;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_IRQ_DISABLE, CLBR_EAX)
-			     : : "m" (paravirt_ops.irq_disable)
-			     : "memory", "eax", "cc");
+	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+				  PARAVIRT_CALL
+				  "popl %%edx; popl %%ecx")
+		     :
+		     : paravirt_type(irq_disable),
+		       paravirt_clobber(CLBR_EAX)
+		     : "memory", "eax", "cc");
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
-					   "call *%0;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_IRQ_ENABLE, CLBR_EAX)
-			     : : "m" (paravirt_ops.irq_enable)
-			     : "memory", "eax", "cc");
+	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+				  PARAVIRT_CALL
+				  "popl %%edx; popl %%ecx")
+		     :
+		     : paravirt_type(irq_enable),
+		       paravirt_clobber(CLBR_EAX)
+		     : "memory", "eax", "cc");
 }
 
 static inline unsigned long __raw_local_irq_save(void)
 {
 	unsigned long f;
 
-	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
-					   "call *%1; pushl %%eax;"
-					   "call *%2; popl %%eax;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_SAVE_FLAGS_IRQ_DISABLE,
-					  CLBR_NONE)
-			     : "=a"(f)
-			     : "m" (paravirt_ops.save_fl),
-			       "m" (paravirt_ops.irq_disable)
-			     : "memory", "cc");
+	f = __raw_local_save_flags();
+	raw_local_irq_disable();
 	return f;
 }
 
-#define CLI_STRING paravirt_alt("pushl %%ecx; pushl %%edx;"		\
-		     "call *paravirt_ops+%c[irq_disable];"		\
-		     "popl %%edx; popl %%ecx",				\
-		     PARAVIRT_IRQ_DISABLE, CLBR_EAX)
-
-#define STI_STRING paravirt_alt("pushl %%ecx; pushl %%edx;"		\
-		     "call *paravirt_ops+%c[irq_enable];"		\
-		     "popl %%edx; popl %%ecx",				\
-		     PARAVIRT_IRQ_ENABLE, CLBR_EAX)
+#define CLI_STRING							\
+	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
+		      "call *paravirt_ops+%c[paravirt_cli_type]*4;"	\
+		      "popl %%edx; popl %%ecx",				\
+		      "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
+
+#define STI_STRING							\
+	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
+		      "call *paravirt_ops+%c[paravirt_sti_type]*4;"	\
+		      "popl %%edx; popl %%ecx",				\
+		      "%c[paravirt_sti_type]", "%c[paravirt_clobber]")
+
 #define CLI_STI_CLOBBERS , "%eax"
-#define CLI_STI_INPUT_ARGS \
+#define CLI_STI_INPUT_ARGS						\
 	,								\
-	[irq_disable] "i" (offsetof(struct paravirt_ops, irq_disable)),	\
-	[irq_enable] "i" (offsetof(struct paravirt_ops, irq_enable))
+	[paravirt_cli_type] "i" (PARAVIRT_PATCH(irq_disable)),		\
+	[paravirt_sti_type] "i" (PARAVIRT_PATCH(irq_enable)),		\
+	paravirt_clobber(CLBR_EAX)
+
+#undef PARAVIRT_CALL
 
 #else  /* __ASSEMBLY__ */
 
-#define PARA_PATCH(ptype, clobbers, ops)	\
+#define PARA_PATCH(off)	((off) / 4)
+
+#define PARA_SITE(ptype, clobbers, ops)		\
 771:;						\
 	ops;					\
 772:;						\
@@ -609,25 +616,25 @@ static inline unsigned long __raw_local_
 	 .short clobbers;			\
 	.popsection
 
-#define INTERRUPT_RETURN				\
-	PARA_PATCH(PARAVIRT_INTERRUPT_RETURN, CLBR_ANY,	\
-	jmp *%cs:paravirt_ops+PARAVIRT_iret)
-
-#define DISABLE_INTERRUPTS(clobbers)			\
-	PARA_PATCH(PARAVIRT_IRQ_DISABLE, clobbers,	\
-	pushl %ecx; pushl %edx;				\
-	call *paravirt_ops+PARAVIRT_irq_disable;	\
-	popl %edx; popl %ecx)				\
-
-#define ENABLE_INTERRUPTS(clobbers)			\
-	PARA_PATCH(PARAVIRT_IRQ_ENABLE, clobbers,	\
-	pushl %ecx; pushl %edx;				\
-	call *%cs:paravirt_ops+PARAVIRT_irq_enable;	\
-	popl %edx; popl %ecx)
-
-#define ENABLE_INTERRUPTS_SYSEXIT			\
-	PARA_PATCH(PARAVIRT_STI_SYSEXIT, CLBR_ANY,	\
-	jmp *%cs:paravirt_ops+PARAVIRT_irq_enable_sysexit)
+#define INTERRUPT_RETURN					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_ANY,		\
+		  jmp *%cs:paravirt_ops+PARAVIRT_iret)
+
+#define DISABLE_INTERRUPTS(clobbers)					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_disable), clobbers,		\
+		  pushl %ecx; pushl %edx;				\
+		  call *%cs:paravirt_ops+PARAVIRT_irq_disable;		\
+		  popl %edx; popl %ecx)					\
+
+#define ENABLE_INTERRUPTS(clobbers)					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable), clobbers,		\
+		  pushl %ecx; pushl %edx;				\
+		  call *%cs:paravirt_ops+PARAVIRT_irq_enable;		\
+		  popl %edx; popl %ecx)
+
+#define ENABLE_INTERRUPTS_SYSEXIT					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_ANY,	\
+		  jmp *%cs:paravirt_ops+PARAVIRT_irq_enable_sysexit)
 
 #define GET_CR0_INTO_EAX			\
 	call *paravirt_ops+PARAVIRT_read_cr0
_

Patches currently in -mm which might be from jeremy@goop.org are

paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
