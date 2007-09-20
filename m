From: akpm@linux-foundation.org
Subject: - i386-fix-section-mismatch-warning-in-intelc.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:17 -0700
Message-ID: <200709202117.l8KLHHfE003069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbXITV2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ak@suse.de, frankvm@frankvm.com, mm-commits@vger.kernel.org


The patch titled
     i386: fix section mismatch warning in intel.c
has been removed from the -mm tree.  Its filename was
     i386-fix-section-mismatch-warning-in-intelc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix section mismatch warning in intel.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0xc88c): Section mismatch: reference to .init.text:trap_init_f00f_bug (between 'init_intel' and 'cpuid4_cache_lookup')

init_intel are __cpuint where trap_init_f00f_bug is __init.
Fixed by declaring trap_init_f00f_bug __cpuinit.

Moved the defintion of trap_init_f00f_bug to the sole user in init.c
so the ugly prototype in intel.c could get killed.

Frank van Maarseveen <frankvm@frankvm.com> supplied the .config used
to reproduce the warning.

Cc: Frank van Maarseveen <frankvm@frankvm.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel.c |   17 +++++++++++++++--
 arch/i386/kernel/traps.c     |   14 --------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/cpu/intel.c~i386-fix-section-mismatch-warning-in-intelc arch/i386/kernel/cpu/intel.c
--- a/arch/i386/kernel/cpu/intel.c~i386-fix-section-mismatch-warning-in-intelc
+++ a/arch/i386/kernel/cpu/intel.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 
 #include <asm/processor.h>
+#include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/uaccess.h>
 
@@ -19,8 +20,6 @@
 #include <mach_apic.h>
 #endif
 
-extern int trap_init_f00f_bug(void);
-
 #ifdef CONFIG_X86_INTEL_USERCOPY
 /*
  * Alignment at which movsl is preferred for bulk memory copies.
@@ -95,6 +94,20 @@ static int __cpuinit num_cpu_cores(struc
 		return 1;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
+
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
diff -puN arch/i386/kernel/traps.c~i386-fix-section-mismatch-warning-in-intelc arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-fix-section-mismatch-warning-in-intelc
+++ a/arch/i386/kernel/traps.c
@@ -1179,20 +1179,6 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
-#ifdef CONFIG_X86_F00F_BUG
-void __init trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 /*
  * This needs to use 'idt_table' rather than 'idt', and
  * thus use the _nonmapped_ version of the IDT, as the
_

Patches currently in -mm which might be from sam@ravnborg.org are

git-avr32.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
powerpc-proper-defconfig-for-crosscompiles.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-kbuild.patch
mkmakefile-include-arch-on-o=-builds.patch
include-linux-kbuild-remove-duplicate-entries.patch
tristate-choices-with-mixed-tristate-and-boolean.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mips.patch
alpha-beautify-vmlinuxlds.patch
kconfig-syntax-cleanups.patch
script-to-check-for-undefined-kconfig-symbols.patch
documentation-make-headers_installtxt.patch
