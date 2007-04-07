From: akpm@linux-foundation.org
Subject: + x86-clean-up-identify_cpu.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:22:28 -0700
Message-ID: <200704072222.l37MMSkM011243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965980AbXDGWWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com


The patch titled
     x86: clean up identify_cpu
has been added to the -mm tree.  Its filename is
     x86-clean-up-identify_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: clean up identify_cpu
From: Jeremy Fitzhardinge <jeremy@goop.org>

identify_cpu() is used to identify both the boot CPU and secondary CPUs,
but it performs some actions which only apply to the boot CPU.  Those
functions are therefore really __init functions, but because they're called
by identify_cpu(), they must be marked __cpuinit.

This patch splits identify_cpu() into identify_boot_cpu() and
identify_secondary_cpu(), and calls the appropriate init functions from
each.  Also, identify_boot_cpu() and all the functions it dominates are
marked __init.

The same change applies to both i386 and x86_64, and both have to be
changed together because they share the mtrr setup code.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c    |   37 ++++++++++++++++-------
 arch/i386/kernel/cpu/mtrr/main.c |    4 +-
 arch/i386/kernel/smpboot.c       |    2 -
 arch/x86_64/kernel/bugs.c        |    2 -
 arch/x86_64/kernel/setup.c       |   45 ++++++++++++++++++++---------
 arch/x86_64/kernel/smpboot.c     |    2 -
 include/asm-i386/processor.h     |    3 +
 include/asm-x86_64/processor.h   |    3 +
 8 files changed, 66 insertions(+), 32 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~x86-clean-up-identify_cpu arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~x86-clean-up-identify_cpu
+++ a/arch/i386/kernel/cpu/common.c
@@ -394,7 +394,7 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
@@ -490,30 +490,43 @@ void __cpuinit identify_cpu(struct cpuin
 	for (i = 0; i < NCAPINTS; i++)
 		printk(" %08lx", c->x86_capability[i]);
 	printk("\n");
+}
+
+void __init identify_boot_cpu(void)
+{
+	identify_cpu(&boot_cpu_data);
+
+	/* Init Machine Check Exception if available. */
+	mcheck_init(&boot_cpu_data);
+
+	sysenter_setup();
+	enable_sep_cpu();
 
+	mtrr_bp_init();
+}
+
+void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	BUG_ON(c == &boot_cpu_data);
+	identify_cpu(c);
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
 	 * common between the CPUs.  The first time this routine gets
 	 * executed, c == &boot_cpu_data.
+	 * AND the already accumulated flags with these
 	 */
-	if ( c != &boot_cpu_data ) {
-		/* AND the already accumulated flags with these */
-		for ( i = 0 ; i < NCAPINTS ; i++ )
-			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-	}
+	for ( i = 0 ; i < NCAPINTS ; i++ )
+		boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
 
-	if (c == &boot_cpu_data)
-		sysenter_setup();
 	enable_sep_cpu();
 
-	if (c == &boot_cpu_data)
-		mtrr_bp_init();
-	else
-		mtrr_ap_init();
+	mtrr_ap_init();
 }
 
 #ifdef CONFIG_X86_HT
diff -puN arch/i386/kernel/cpu/mtrr/main.c~x86-clean-up-identify_cpu arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~x86-clean-up-identify_cpu
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
 
diff -puN arch/i386/kernel/smpboot.c~x86-clean-up-identify_cpu arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~x86-clean-up-identify_cpu
+++ a/arch/i386/kernel/smpboot.c
@@ -155,7 +155,7 @@ static void __cpuinit smp_store_cpu_info
 
 	*c = boot_cpu_data;
 	if (id!=0)
-		identify_cpu(c);
+		identify_secondary_cpu(c);
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
diff -puN arch/i386/kernel/sysenter.c~x86-clean-up-identify_cpu arch/i386/kernel/sysenter.c
diff -puN arch/x86_64/kernel/bugs.c~x86-clean-up-identify_cpu arch/x86_64/kernel/bugs.c
--- a/arch/x86_64/kernel/bugs.c~x86-clean-up-identify_cpu
+++ a/arch/x86_64/kernel/bugs.c
@@ -19,7 +19,7 @@
 
 void __init check_bugs(void)
 {
-	identify_cpu(&boot_cpu_data);
+	identify_boot_cpu();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
diff -puN arch/x86_64/kernel/setup.c~x86-clean-up-identify_cpu arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86-clean-up-identify_cpu
+++ a/arch/x86_64/kernel/setup.c
@@ -814,7 +814,7 @@ void __cpuinit early_identify_cpu(struct
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 	u32 xlvl;
@@ -870,31 +870,50 @@ void __cpuinit identify_cpu(struct cpuin
 
 	select_idle_routine(c);
 	detect_ht(c); 
+}
+
+void __init identify_boot_cpu(void)
+{
+	identify_cpu(&boot_cpu_data);
+
+#ifdef CONFIG_X86_MCE
+	mcheck_init(&boot_cpu_data);
+#endif
+
+	mtrr_bp_init();
+
+#ifdef CONFIG_NUMA
+	numa_add_cpu(smp_processor_id());
+#endif
+}
+
+void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	BUG_ON(c == &boot_cpu_data);
+
+	identify_cpu(c);
 
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
-	 * common between the CPUs.  The first time this routine gets
-	 * executed, c == &boot_cpu_data.
+	 * common between the CPUs.
+	 * AND the already accumulated flags with these
 	 */
-	if (c != &boot_cpu_data) {
-		/* AND the already accumulated flags with these */
-		for (i = 0 ; i < NCAPINTS ; i++)
-			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-	}
+	for (i = 0 ; i < NCAPINTS ; i++)
+		boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
 #endif
-	if (c == &boot_cpu_data)
-		mtrr_bp_init();
-	else
-		mtrr_ap_init();
+
+	mtrr_ap_init();
+
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
 }
- 
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
diff -puN arch/x86_64/kernel/smpboot.c~x86-clean-up-identify_cpu arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86-clean-up-identify_cpu
+++ a/arch/x86_64/kernel/smpboot.c
@@ -143,7 +143,7 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = cpu_data + id;
 
 	*c = boot_cpu_data;
-	identify_cpu(c);
+	identify_secondary_cpu(c);
 	print_cpu_info(c);
 }
 
diff -puN include/asm-i386/processor.h~x86-clean-up-identify_cpu include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~x86-clean-up-identify_cpu
+++ a/include/asm-i386/processor.h
@@ -116,7 +116,8 @@ extern char ignore_fpu_irq;
 
 void __init cpu_detect(struct cpuinfo_x86 *c);
 
-extern void identify_cpu(struct cpuinfo_x86 *);
+extern void identify_boot_cpu(void);
+extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
diff -puN include/asm-x86_64/processor.h~x86-clean-up-identify_cpu include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~x86-clean-up-identify_cpu
+++ a/include/asm-x86_64/processor.h
@@ -98,7 +98,8 @@ extern struct cpuinfo_x86 cpu_data[];
 
 extern char ignore_irq13;
 
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
