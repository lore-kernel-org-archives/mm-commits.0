From: akpm@linux-foundation.org
Subject: + i386-gdt-cleanups-clean-up-cpu_init.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:32:51 -0700
Message-ID: <200703212232.l2LMWpWJ005575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933913AbXCUWdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     i386 GDT cleanups: clean up cpu_init()
has been added to the -mm tree.  Its filename is
     i386-gdt-cleanups-clean-up-cpu_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 GDT cleanups: clean up cpu_init()
From: Rusty Russell <rusty@rustcorp.com.au>

We now have cpu_init() and secondary_cpu_init() doing nothing but calling
_cpu_init() with the same arguments.  Rename _cpu_init() to cpu_init() and use
it as a replcement for secondary_cpu_init().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c |   34 ++++++++------------------------
 arch/i386/kernel/smpboot.c    |    8 +++----
 include/asm-i386/processor.h  |    2 -
 3 files changed, 14 insertions(+), 30 deletions(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-clean-up-cpu_init arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-gdt-cleanups-clean-up-cpu_init
+++ a/arch/i386/kernel/cpu/common.c
@@ -644,9 +644,16 @@ struct i386_pda boot_pda = {
 	.pcurrent = &init_task,
 };
 
-/* Common CPU init for both boot and secondary CPUs */
-static void __cpuinit _cpu_init(int cpu, struct task_struct *curr)
+/*
+ * cpu_init() initializes state that is per-CPU. Some data is already
+ * initialized (naturally) in the bootstrap process, such as the GDT
+ * and IDT. We reload them nevertheless, this function acts as a
+ * 'CPU state barrier', nothing should get across.
+ */
+void __cpuinit cpu_init(void)
 {
+	int cpu = smp_processor_id();
+	struct task_struct *curr = current;
 	struct tss_struct * t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
@@ -706,29 +713,6 @@ static void __cpuinit _cpu_init(int cpu,
 	mxcsr_feature_mask_init();
 }
 
-/* Entrypoint to initialize secondary CPU */
-void __cpuinit secondary_cpu_init(void)
-{
-	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	_cpu_init(cpu, curr);
-}
-
-/*
- * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
- */
-void __cpuinit cpu_init(void)
-{
-	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	_cpu_init(cpu, curr);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void __cpuinit cpu_uninit(void)
 {
diff -puN arch/i386/kernel/smpboot.c~i386-gdt-cleanups-clean-up-cpu_init arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-gdt-cleanups-clean-up-cpu_init
+++ a/arch/i386/kernel/smpboot.c
@@ -378,14 +378,14 @@ set_cpu_sibling_map(int cpu)
 static void __cpuinit start_secondary(void *unused)
 {
 	/*
-	 * Don't put *anything* before secondary_cpu_init(), SMP
-	 * booting is too fragile that we want to limit the
-	 * things done here to the most necessary things.
+	 * Don't put *anything* before cpu_init(), SMP booting is too
+	 * fragile that we want to limit the things done here to the
+	 * most necessary things.
 	 */
 #ifdef CONFIG_VMI
 	vmi_bringup();
 #endif
-	secondary_cpu_init();
+	cpu_init();
 	preempt_disable();
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
diff -puN include/asm-i386/processor.h~i386-gdt-cleanups-clean-up-cpu_init include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-gdt-cleanups-clean-up-cpu_init
+++ a/include/asm-i386/processor.h
@@ -744,6 +744,6 @@ extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
 extern void cpu_set_gdt(int);
-extern void secondary_cpu_init(void);
+extern void cpu_init(void);
 
 #endif /* __ASM_I386_PROCESSOR_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
