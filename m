From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:03:20 -0800
Message-ID: <200703020203.l2223K0A029569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422766AbXCBCD3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     xen-paravirt_ops: use patch site IDs computed from offset in paravirt_ops structure
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen-paravirt_ops: use patch site IDs computed from offset in paravirt_ops structure
From: Jeremy Fitzhardinge <jeremy@goop.org>

Use patch type identifiers derived from the offset of the operation in the
paravirt_ops structure.  This avoids having to maintain a separate enum for
patch site types.

This patch also drops the fused save_fl+cli operation, which doesn't really
add much and makes things more complex.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |    5 +
 arch/i386/kernel/paravirt.c    |   14 +---
 arch/i386/kernel/vmi.c         |   38 +----------
 include/asm-i386/paravirt.h    |  106 +++++++++++++++----------------
 4 files changed, 70 insertions(+), 93 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/arch/i386/kernel/asm-offsets.c
@@ -117,6 +117,11 @@ void foo(void)
 	OFFSET(PARAVIRT_irq_enable_sysexit, paravirt_ops, irq_enable_sysexit);
 	OFFSET(PARAVIRT_iret, paravirt_ops, iret);
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
+
+	DEFINE(PARAVIRT_IRQ_DISABLE, PARAVIRT_PATCH(irq_disable));
+	DEFINE(PARAVIRT_IRQ_ENABLE, PARAVIRT_PATCH(irq_enable));
+	DEFINE(PARAVIRT_STI_SYSEXIT, PARAVIRT_PATCH(irq_enable_sysexit));
+	DEFINE(PARAVIRT_INTERRUPT_RETURN, PARAVIRT_PATCH(iret));
 #endif
 
 #ifdef CONFIG_LGUEST_GUEST
diff -puN arch/i386/kernel/paravirt.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/arch/i386/kernel/paravirt.c
@@ -57,7 +57,6 @@ DEF_NATIVE(cli, "cli");
 DEF_NATIVE(sti, "sti");
 DEF_NATIVE(popf, "push %eax; popf");
 DEF_NATIVE(pushf, "pushf; pop %eax");
-DEF_NATIVE(pushf_cli, "pushf; pop %eax; cli");
 DEF_NATIVE(iret, "iret");
 DEF_NATIVE(sti_sysexit, "sti; sysexit");
 
@@ -65,13 +64,12 @@ static const struct native_insns
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
diff -puN arch/i386/kernel/vmi.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
+++ a/arch/i386/kernel/vmi.c
@@ -78,11 +78,6 @@ static struct {
 #define MNEM_JMP  0xe9
 #define MNEM_RET  0xc3
 
-static char irq_save_disable_callout[] = {
-	MNEM_CALL, 0, 0, 0, 0,
-	MNEM_CALL, 0, 0, 0, 0,
-	MNEM_RET
-};
 #define IRQ_PATCH_INT_MASK 0
 #define IRQ_PATCH_DISABLE  5
 
@@ -130,33 +125,17 @@ static unsigned patch_internal(int call,
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
@@ -733,11 +712,6 @@ static inline int __init activate_vmi(vo
 	para_fill(restore_fl, SetInterruptMask);
 	para_fill(irq_disable, DisableInterrupts);
 	para_fill(irq_enable, EnableInterrupts);
-	/* irq_save_disable !!! sheer pain */
-	patch_offset(&irq_save_disable_callout[IRQ_PATCH_INT_MASK],
-		     (char *)paravirt_ops.save_fl);
-	patch_offset(&irq_save_disable_callout[IRQ_PATCH_DISABLE],
-		     (char *)paravirt_ops.irq_disable);
 #ifndef CONFIG_NO_IDLE_HZ
 	para_fill(safe_halt, Halt);
 #else
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure
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
@@ -27,6 +16,23 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
+#define paravirt_type(type)		[paravirt_typenum] "i" (type)
+#define paravirt_clobber(clobber)	[paravirt_clobber] "i" (clobber)
+
+#define PARAVIRT_PATCH(x)		(offsetof(struct paravirt_ops, x) / sizeof(void *))
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
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -503,24 +509,16 @@ struct paravirt_patch_site {
 extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 
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
 
 	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
 					   "call *%1;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_SAVE_FLAGS, CLBR_NONE)
-			     : "=a"(f): "m"(paravirt_ops.save_fl)
+					   "popl %%edx; popl %%ecx")
+			     : "=a"(f): "m"(paravirt_ops.save_fl),
+			       paravirt_type(PARAVIRT_PATCH(save_fl)),
+			       paravirt_clobber(CLBR_NONE)
 			     : "memory", "cc");
 	return f;
 }
@@ -529,9 +527,10 @@ static inline void raw_local_irq_restore
 {
 	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
 					   "call *%1;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_RESTORE_FLAGS, CLBR_EAX)
-			     : "=a"(f) : "m" (paravirt_ops.restore_fl), "0"(f)
+					   "popl %%edx; popl %%ecx")
+			     : "=a"(f) : "m" (paravirt_ops.restore_fl), "0"(f),
+			       paravirt_type(PARAVIRT_PATCH(restore_fl)),
+			       paravirt_clobber(CLBR_EAX)
 			     : "memory", "cc");
 }
 
@@ -539,9 +538,10 @@ static inline void raw_local_irq_disable
 {
 	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
 					   "call *%0;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_IRQ_DISABLE, CLBR_EAX)
-			     : : "m" (paravirt_ops.irq_disable)
+					   "popl %%edx; popl %%ecx")
+			     : : "m" (paravirt_ops.irq_disable),
+			       paravirt_type(PARAVIRT_PATCH(irq_disable)),
+			       paravirt_clobber(CLBR_EAX)
 			     : "memory", "eax", "cc");
 }
 
@@ -549,9 +549,10 @@ static inline void raw_local_irq_enable(
 {
 	__asm__ __volatile__(paravirt_alt( "pushl %%ecx; pushl %%edx;"
 					   "call *%0;"
-					   "popl %%edx; popl %%ecx",
-					  PARAVIRT_IRQ_ENABLE, CLBR_EAX)
-			     : : "m" (paravirt_ops.irq_enable)
+					   "popl %%edx; popl %%ecx")
+			     : : "m" (paravirt_ops.irq_enable),
+			       paravirt_type(PARAVIRT_PATCH(irq_enable)),
+			       paravirt_clobber(CLBR_EAX)
 			     : "memory", "eax", "cc");
 }
 
@@ -559,32 +560,31 @@ static inline unsigned long __raw_local_
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
+
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
+#define CLI_STRING _paravirt_alt("pushl %%ecx; pushl %%edx;"		\
+				 "call *paravirt_ops+%c[irq_disable];"	\
+				 "popl %%edx; popl %%ecx",		\
+				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
+
+#define STI_STRING _paravirt_alt("pushl %%ecx; pushl %%edx;"		\
+				"call *paravirt_ops+%c[irq_enable];"	\
+				 "popl %%edx; popl %%ecx",		\
+				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
+
+
 #define CLI_STI_CLOBBERS , "%eax"
 #define __CLI_STI_INPUT_ARGS						\
-	[irq_disable] "i" (offsetof(struct paravirt_ops, irq_disable)),	\
-	[irq_enable] "i" (offsetof(struct paravirt_ops, irq_enable))
+	,								\
+		[irq_disable] "i" (offsetof(struct paravirt_ops, irq_disable)),\
+		[irq_enable] "i" (offsetof(struct paravirt_ops, irq_enable)), \
+		[paravirt_cli_type] "i" (PARAVIRT_PATCH(irq_disable)),	\
+		[paravirt_sti_type] "i" (PARAVIRT_PATCH(irq_disable)),	\
+		paravirt_clobber(CLBR_NONE)
 #define CLI_STI_INPUT_ARGS , __CLI_STI_INPUT_ARGS
 
 #else  /* __ASSEMBLY__ */
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
