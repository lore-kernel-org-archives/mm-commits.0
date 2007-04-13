From: akpm@linux-foundation.org
Subject: - x86_64-clean-up-asm-x86_64-bugsh.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:51 -0700
Message-ID: <200704132330.l3DNUp8Y012778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161257AbXDMXa4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: clean up asm-x86_64/bugs.h
has been removed from the -mm tree.  Its filename was
     x86_64-clean-up-asm-x86_64-bugsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86_64/kernel/Makefile      |    3 +-
 arch/x86_64/kernel/bugs.c        |   28 +++++++++++++++++++++++++++
 include/asm-x86_64/alternative.h |    1 
 include/asm-x86_64/bugs.h        |   30 +++--------------------------
 4 files changed, 35 insertions(+), 27 deletions(-)

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
@@ -8,7 +8,8 @@ obj-y	:= process.o signal.o entry.o trap
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o
+		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o \
+		bugs.o
 
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
