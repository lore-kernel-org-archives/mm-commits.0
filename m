From: akpm@linux-foundation.org
Subject: + x86-smpboot_32c-section-fixes.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:51:44 -0800
Message-ID: <200712190051.lBJ0pimL030576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbXLSAwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:52:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 smpboot_32.c section fixes
has been added to the -mm tree.  Its filename is
     x86-smpboot_32c-section-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86 smpboot_32.c section fixes
From: Adrian Bunk <bunk@kernel.org>

Fix the following section mismatches with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

WARNING: vmlinux.o(.text+0x22c60): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
WARNING: vmlinux.o(.text+0x22c99): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
WARNING: vmlinux.o(.text+0x2359b): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and 'cpu_exit_clear')
WARNING: vmlinux.o(.text+0x235a0): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and 'cpu_exit_clear')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/smpboot_32.c~x86-smpboot_32c-section-fixes arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~x86-smpboot_32c-section-fixes
+++ a/arch/x86/kernel/smpboot_32.c
@@ -60,7 +60,7 @@
 #include <asm/mtrr.h>
 
 /* Set if we find a B stepping CPU */
-static int __devinitdata smp_b_stepping;
+static int __cpuinitdata smp_b_stepping;
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -744,8 +744,8 @@ static inline int alloc_cpu_id(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct * __devinitdata cpu_idle_tasks[NR_CPUS];
-static inline struct task_struct * alloc_idle_task(int cpu)
+static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
+static inline struct task_struct * __cpuinit alloc_idle_task(int cpu)
 {
 	struct task_struct *idle;
 
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
drivers-pci-msic-move-arch-hooks-to-the-top.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
wireless-ipw2200c-add-__devinitexit-annotations.patch
git-x86.patch
x86_32-disable_pse-must-be-__cpuinitdata.patch
x86_32-disable_pse-must-be-__cpuinitdata-fix.patch
x86_32-select_idle_routine-must-be-__cpuinit.patch
x86-smpboot_32c-section-fixes.patch
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
