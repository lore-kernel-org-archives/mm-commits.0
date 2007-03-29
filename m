From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-clean-up-cpu_init.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:14 -0700
Message-ID: <200703292339.l2TNdEvB015416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43190 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945941AbXC2XjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 GDT cleanups: clean up cpu_init()
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-clean-up-cpu_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
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
