From: akpm@linux-foundation.org
Subject: + i386-clean-up-identify_cpu.patch added to -mm tree
Date: Sat, 07 Apr 2007 00:21:29 -0700
Message-ID: <200704070721.l377LTII029884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXDGHVf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 03:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com


The patch titled
     i386: clean up identify_cpu
has been added to the -mm tree.  Its filename is
     i386-clean-up-identify_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: clean up identify_cpu
From: Jeremy Fitzhardinge <jeremy@goop.org>

identify_cpu() is used to identify both the boot CPU and secondary
CPUs, but it performs some actions which only apply to the boot CPU.
Those functions are therefore really __init functions, but because
they're called by identify_cpu(), they must be marked __cpuinit.

This patch splits identify_cpu() into identify_boot_cpu() and
identify_secondary_cpu(), and calls the appropriate init functions
from each.  Also, identify_boot_cpu() and all the functions it
dominates are marked __init.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c    |   21 ++++++++++++++-------
 arch/i386/kernel/cpu/mtrr/main.c |    4 ++--
 arch/i386/kernel/smpboot.c       |    2 +-
 include/asm-i386/processor.h     |    3 ++-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-clean-up-identify_cpu arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-clean-up-identify_cpu
+++ a/arch/i386/kernel/cpu/common.c
@@ -394,7 +394,7 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
@@ -505,15 +505,22 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+}
 
-	if (c == &boot_cpu_data)
-		sysenter_setup();
+void __init identify_boot_cpu(void)
+{
+	identify_cpu(&boot_cpu_data);
+	sysenter_setup();
 	enable_sep_cpu();
+	mtrr_bp_init();
+}
 
-	if (c == &boot_cpu_data)
-		mtrr_bp_init();
-	else
-		mtrr_ap_init();
+void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+{
+	BUG_ON(c == &boot_cpu_data);
+	identify_cpu(c);
+	enable_sep_cpu();
+	mtrr_ap_init();
 }
 
 #ifdef CONFIG_X86_HT
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-clean-up-identify_cpu arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-clean-up-identify_cpu
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -571,7 +571,7 @@ extern void amd_init_mtrr(void);
 extern void cyrix_init_mtrr(void);
 extern void centaur_init_mtrr(void);
 
-static void __cpuinit init_ifs(void)
+static void __init init_ifs(void)
 {
 #ifndef CONFIG_X86_64
 	amd_init_mtrr();
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void __cpuinit mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
diff -puN arch/i386/kernel/smpboot.c~i386-clean-up-identify_cpu arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-clean-up-identify_cpu
+++ a/arch/i386/kernel/smpboot.c
@@ -155,7 +155,7 @@ static void __cpuinit smp_store_cpu_info
 
 	*c = boot_cpu_data;
 	if (id!=0)
-		identify_cpu(c);
+		identify_secondary_cpu(c);
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
diff -puN include/asm-i386/processor.h~i386-clean-up-identify_cpu include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-clean-up-identify_cpu
+++ a/include/asm-i386/processor.h
@@ -116,7 +116,8 @@ extern char ignore_fpu_irq;
 
 void __init cpu_detect(struct cpuinfo_x86 *c);
 
-extern void identify_cpu(struct cpuinfo_x86 *);
+extern void identify_boot_cpu(void);
+extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
_

Patches currently in -mm which might be from jeremy@goop.org are

proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-clean-up-asm-i386-bugsh.patch
i386-clean-up-identify_cpu.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
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
