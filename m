From: akpm@linux-foundation.org
Subject: + calibrate_delay-must-be-__cpuinit.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:43:55 -0800
Message-ID: <200712190043.lBJ0ht41030326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbXLSAqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     calibrate_delay() must be __cpuinit
has been added to the -mm tree.  Its filename is
     calibrate_delay-must-be-__cpuinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: calibrate_delay() must be __cpuinit
From: Adrian Bunk <bunk@kernel.org>

calibrate_delay() must be __cpuinit, not __{dev,}init.

I've verified that this is correct for all users.

While doing the latter, I also did the following cleanups:
- remove pointless additional prototypes in C files
- ensure all users #include <linux/delay.h>

This fixes the following section mismatches with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

WARNING: vmlinux.o(.text+0x1128d): Section mismatch: reference to .init.text.1:calibrate_delay (between 'check_cx686_slop' and 'set_cx86_reorder')
WARNING: vmlinux.o(.text+0x25102): Section mismatch: reference to .init.text.1:calibrate_delay (between 'smp_callin' and 'cpu_coregroup_map')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Zankel <chris@zankel.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/smp.c                      |    4 ----
 arch/frv/kernel/setup.c                      |    2 +-
 arch/ia64/kernel/smpboot.c                   |    1 -
 arch/mips/kernel/smp.c                       |    1 -
 arch/powerpc/platforms/powermac/cpufreq_32.c |    2 --
 arch/sparc/kernel/sun4d_smp.c                |    4 +---
 arch/sparc/kernel/sun4m_smp.c                |    5 ++---
 arch/sparc64/kernel/smp.c                    |    2 --
 arch/x86/kernel/cpu/cyrix.c                  |    2 --
 arch/x86/kernel/smpboot_32.c                 |    2 --
 arch/x86/mach-voyager/voyager_smp.c          |    2 --
 arch/xtensa/kernel/time.c                    |    2 +-
 drivers/s390/sysinfo.c                       |    2 +-
 init/calibrate.c                             |    6 +++---
 14 files changed, 9 insertions(+), 28 deletions(-)

diff -puN arch/alpha/kernel/smp.c~calibrate_delay-must-be-__cpuinit arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/alpha/kernel/smp.c
@@ -77,10 +77,6 @@ int smp_num_probed;		/* Internal process
 int smp_num_cpus = 1;		/* Number that came online.  */
 EXPORT_SYMBOL(smp_num_cpus);
 
-extern void calibrate_delay(void);
-
-
-
 /*
  * Called by both boot and secondaries to move global data into
  *  per-processor storage.
diff -puN arch/frv/kernel/setup.c~calibrate_delay-must-be-__cpuinit arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/frv/kernel/setup.c
@@ -708,7 +708,7 @@ static void __init reserve_dma_coherent(
 /*
  * calibrate the delay loop
  */
-void __init calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	loops_per_jiffy = __delay_loops_MHz * (1000000 / HZ);
 
diff -puN arch/ia64/kernel/smpboot.c~calibrate_delay-must-be-__cpuinit arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/ia64/kernel/smpboot.c
@@ -120,7 +120,6 @@ static volatile unsigned long go[SLAVE +
 
 #define DEBUG_ITC_SYNC	0
 
-extern void __devinit calibrate_delay (void);
 extern void start_ap (void);
 extern unsigned long ia64_iobase;
 
diff -puN arch/mips/kernel/smp.c~calibrate_delay-must-be-__cpuinit arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/mips/kernel/smp.c
@@ -53,7 +53,6 @@ int __cpu_logical_map[NR_CPUS];		/* Map 
 EXPORT_SYMBOL(phys_cpu_present_map);
 EXPORT_SYMBOL(cpu_online_map);
 
-extern void __init calibrate_delay(void);
 extern void cpu_idle(void);
 
 /* Number of TCs (or siblings in Intel speak) per CPU core */
diff -puN arch/powerpc/platforms/powermac/cpufreq_32.c~calibrate_delay-must-be-__cpuinit arch/powerpc/platforms/powermac/cpufreq_32.c
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -113,8 +113,6 @@ static inline void debug_calc_bogomips(v
 	 * result. We backup/restore the value to avoid affecting the
 	 * core cpufreq framework's own calculation.
 	 */
-	extern void calibrate_delay(void);
-
 	unsigned long save_lpj = loops_per_jiffy;
 	calibrate_delay();
 	loops_per_jiffy = save_lpj;
diff -puN arch/sparc/kernel/sun4d_smp.c~calibrate_delay-must-be-__cpuinit arch/sparc/kernel/sun4d_smp.c
--- a/arch/sparc/kernel/sun4d_smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/sparc/kernel/sun4d_smp.c
@@ -19,12 +19,12 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/profile.h>
+#include <linux/delay.h>
 
 #include <asm/ptrace.h>
 #include <asm/atomic.h>
 #include <asm/irq_regs.h>
 
-#include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -41,8 +41,6 @@
 
 extern ctxd_t *srmmu_ctx_table_phys;
 
-extern void calibrate_delay(void);
-
 static volatile int smp_processors_ready = 0;
 static int smp_highest_cpu;
 extern volatile unsigned long cpu_callin_map[NR_CPUS];
diff -puN arch/sparc/kernel/sun4m_smp.c~calibrate_delay-must-be-__cpuinit arch/sparc/kernel/sun4m_smp.c
--- a/arch/sparc/kernel/sun4m_smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/sparc/kernel/sun4m_smp.c
@@ -16,6 +16,8 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/profile.h>
+#include <linux/delay.h>
+
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/irq_regs.h>
@@ -23,7 +25,6 @@
 #include <asm/ptrace.h>
 #include <asm/atomic.h>
 
-#include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -39,8 +40,6 @@
 
 extern ctxd_t *srmmu_ctx_table_phys;
 
-extern void calibrate_delay(void);
-
 extern volatile unsigned long cpu_callin_map[NR_CPUS];
 extern unsigned char boot_cpu_id;
 
diff -puN arch/sparc64/kernel/smp.c~calibrate_delay-must-be-__cpuinit arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/sparc64/kernel/smp.c
@@ -46,8 +46,6 @@
 #include <asm/ldc.h>
 #include <asm/hypervisor.h>
 
-extern void calibrate_delay(void);
-
 int sparc64_multi_core __read_mostly;
 
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
diff -puN arch/x86/kernel/cpu/cyrix.c~calibrate_delay-must-be-__cpuinit arch/x86/kernel/cpu/cyrix.c
--- a/arch/x86/kernel/cpu/cyrix.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/x86/kernel/cpu/cyrix.c
@@ -83,8 +83,6 @@ static char cyrix_model_mult2[] __cpuini
  * FIXME: our newer udelay uses the tsc. We don't need to frob with SLOP
  */
 
-extern void calibrate_delay(void) __init;
-
 static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 {
 	unsigned long flags;
diff -puN arch/x86/kernel/smpboot_32.c~calibrate_delay-must-be-__cpuinit arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/x86/kernel/smpboot_32.c
@@ -212,8 +212,6 @@ valid_k7:
 	;
 }
 
-extern void calibrate_delay(void);
-
 static atomic_t init_deasserted;
 
 static void __cpuinit smp_callin(void)
diff -puN arch/x86/mach-voyager/voyager_smp.c~calibrate_delay-must-be-__cpuinit arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/x86/mach-voyager/voyager_smp.c
@@ -444,8 +444,6 @@ static __u32 __init setup_trampoline(voi
 static void __init start_secondary(void *unused)
 {
 	__u8 cpuid = hard_smp_processor_id();
-	/* external functions not defined in the headers */
-	extern void calibrate_delay(void);
 
 	cpu_init();
 
diff -puN arch/xtensa/kernel/time.c~calibrate_delay-must-be-__cpuinit arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~calibrate_delay-must-be-__cpuinit
+++ a/arch/xtensa/kernel/time.c
@@ -204,7 +204,7 @@ again:
 }
 
 #ifndef CONFIG_GENERIC_CALIBRATE_DELAY
-void __devinit calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	loops_per_jiffy = CCOUNT_PER_JIFFY;
 	printk("Calibrating delay loop (skipped)... "
diff -puN drivers/s390/sysinfo.c~calibrate_delay-must-be-__cpuinit drivers/s390/sysinfo.c
--- a/drivers/s390/sysinfo.c~calibrate_delay-must-be-__cpuinit
+++ a/drivers/s390/sysinfo.c
@@ -422,7 +422,7 @@ void s390_adjust_jiffies(void)
 /*
  * calibrate the delay loop
  */
-void __init calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	s390_adjust_jiffies();
 	/* Print the good old Bogomips line .. */
diff -puN init/calibrate.c~calibrate_delay-must-be-__cpuinit init/calibrate.c
--- a/init/calibrate.c~calibrate_delay-must-be-__cpuinit
+++ a/init/calibrate.c
@@ -28,7 +28,7 @@ __setup("lpj=", lpj_setup);
 #define DELAY_CALIBRATION_TICKS			((HZ < 100) ? 1 : (HZ/100))
 #define MAX_DIRECT_CALIBRATION_RETRIES		5
 
-static unsigned long __devinit calibrate_delay_direct(void)
+static unsigned long __cpuinit calibrate_delay_direct(void)
 {
 	unsigned long pre_start, start, post_start;
 	unsigned long pre_end, end, post_end;
@@ -101,7 +101,7 @@ static unsigned long __devinit calibrate
 	return 0;
 }
 #else
-static unsigned long __devinit calibrate_delay_direct(void) {return 0;}
+static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
 #endif
 
 /*
@@ -111,7 +111,7 @@ static unsigned long __devinit calibrate
  */
 #define LPS_PREC 8
 
-void __devinit calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
drivers-cpufreq-cpufreq_statsc-section-fix.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
fs-nfs-directc-remove-dead-code.patch
drivers-pci-msic-move-arch-hooks-to-the-top.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
wireless-ipw2200c-add-__devinitexit-annotations.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
xen-fiddle_vdso-must-be-__init.patch
calibrate_delay-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
