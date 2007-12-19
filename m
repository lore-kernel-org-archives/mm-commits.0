From: akpm@linux-foundation.org
Subject: + idle_regs-must-be-__cpuinit.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:53:21 -0800
Message-ID: <200712190053.lBJ0rLcF030682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbXLSAyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     idle_regs() must be __cpuinit
has been added to the -mm tree.  Its filename is
     idle_regs-must-be-__cpuinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: idle_regs() must be __cpuinit
From: Adrian Bunk <bunk@kernel.org>

Fix the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

WARNING: vmlinux.o(.text+0x399a6): Section mismatch: reference to .init.text.5:idle_regs (between 'fork_idle' and 'get_task_mm')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c   |    2 +-
 arch/x86/kernel/cpu/common.c |    2 +-
 kernel/fork.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~idle_regs-must-be-__cpuinit arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~idle_regs-must-be-__cpuinit
+++ a/arch/ia64/kernel/smpboot.c
@@ -477,7 +477,7 @@ start_secondary (void *unused)
 	return 0;
 }
 
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	return NULL;
 }
diff -puN arch/x86/kernel/cpu/common.c~idle_regs-must-be-__cpuinit arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~idle_regs-must-be-__cpuinit
+++ a/arch/x86/kernel/cpu/common.c
@@ -638,7 +638,7 @@ void __init early_cpu_init(void)
 }
 
 /* Make sure %fs is initialized properly in idle threads */
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->fs = __KERNEL_PERCPU;
diff -puN kernel/fork.c~idle_regs-must-be-__cpuinit kernel/fork.c
--- a/kernel/fork.c~idle_regs-must-be-__cpuinit
+++ a/kernel/fork.c
@@ -1370,7 +1370,7 @@ fork_out:
 	return ERR_PTR(retval);
 }
 
-noinline struct pt_regs * __devinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
+noinline struct pt_regs * __cpuinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	return regs;
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
x86-apic_32c-section-fix.patch
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
idle_regs-must-be-__cpuinit.patch
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
