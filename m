From: akpm@linux-foundation.org
Subject: + x86_64-clean-up-asm-x86_64-bugsh.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:22:24 -0700
Message-ID: <200704072222.l37MMOF1011238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35048 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965980AbXDGWWb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, torvalds@linux-foundation.org


The patch titled
     x86_64: clean up asm-x86_64/bugs.h
has been added to the -mm tree.  Its filename is
     x86_64-clean-up-asm-x86_64-bugsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: clean up asm-x86_64/bugs.h
From: Jeremy Fitzhardinge <jeremy@goop.org>

Most of asm-x86_64/bugs.h is code which should be in a C file, so put it
there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/Makefile      |    2 -
 arch/x86_64/kernel/bugs.c        |   28 +++++++++++++++++++++++++++
 include/asm-x86_64/alternative.h |    1 
 include/asm-x86_64/bugs.h        |   30 +++--------------------------
 4 files changed, 34 insertions(+), 27 deletions(-)

diff -puN /dev/null arch/x86_64/kernel/bugs.c
--- /dev/null
+++ a/arch/x86_64/kernel/bugs.c
@@ -0,0 +1,28 @@
+/*
+ *  arch/x86_64/kernel/bugs.c
+ *
+ *  Copyright (C) 1994  Linus Torvalds
+ *  Copyright (C) 2000  SuSE
+ *
+ * This is included by init/main.c to check for architecture-dependent bugs.
+ *
+ * Needs:
+ *	void check_bugs(void);
+ */
+
+#include <linux/kernel.h>
+#include <asm/alternative.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/msr.h>
+#include <asm/pda.h>
+
+void __init check_bugs(void)
+{
+	identify_cpu(&boot_cpu_data);
+#if !defined(CONFIG_SMP)
+	printk("CPU: ");
+	print_cpu_info(&boot_cpu_data);
+#endif
+	alternative_instructions();
+}
diff -puN arch/x86_64/kernel/Makefile~x86_64-clean-up-asm-x86_64-bugsh arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~x86_64-clean-up-asm-x86_64-bugsh
+++ a/arch/x86_64/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y	:= process.o signal.o entry.o trap
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o
+		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
diff -puN include/asm-x86_64/alternative.h~x86_64-clean-up-asm-x86_64-bugsh include/asm-x86_64/alternative.h
--- a/include/asm-x86_64/alternative.h~x86_64-clean-up-asm-x86_64-bugsh
+++ a/include/asm-x86_64/alternative.h
@@ -19,6 +19,7 @@ struct alt_instr {
 	u8  pad[3];
 } __attribute__ ((packed));
 
+extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
diff -puN include/asm-x86_64/bugs.h~x86_64-clean-up-asm-x86_64-bugsh include/asm-x86_64/bugs.h
--- a/include/asm-x86_64/bugs.h~x86_64-clean-up-asm-x86_64-bugsh
+++ a/include/asm-x86_64/bugs.h
@@ -1,28 +1,6 @@
-/*
- *  include/asm-x86_64/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- *  Copyright (C) 2000  SuSE
- *
- * This is included by init/main.c to check for architecture-dependent bugs.
- *
- * Needs:
- *	void check_bugs(void);
- */
+#ifndef _ASM_X86_64_BUGS_H
+#define _ASM_X86_64_BUGS_H
 
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/pda.h>
+void check_bugs(void);
 
-extern void alternative_instructions(void);
-
-static void __init check_bugs(void)
-{
-	identify_cpu(&boot_cpu_data);
-#if !defined(CONFIG_SMP)
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	alternative_instructions(); 
-}
+#endif	/* _ASM_X86_64_BUGS_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
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
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-clean-up-asm-i386-bugsh.patch
x86_64-clean-up-asm-x86_64-bugsh.patch
x86-clean-up-identify_cpu.patch
i386-clean-up-identify_cpu.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
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
