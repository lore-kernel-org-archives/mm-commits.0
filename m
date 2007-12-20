From: akpm@linux-foundation.org
Subject: - x86-apic_32c-section-fix.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:25 -0800
Message-ID: <200712202338.lBKNcPnT018976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759647AbXLTXsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 apic_32.c section fix
has been removed from the -mm tree.  Its filename was
     x86-apic_32c-section-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86 apic_32.c section fix
From: Adrian Bunk <bunk@kernel.org>

tFix fixes the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

WARNING: vmlinux.o(.text+0x2390d): Section mismatch: reference to .init.text.5:setup_local_APIC (between 'start_secondary' and 'check_tsc_warp')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/apic_32.c~x86-apic_32c-section-fix arch/x86/kernel/apic_32.c
--- a/arch/x86/kernel/apic_32.c~x86-apic_32c-section-fix
+++ a/arch/x86/kernel/apic_32.c
@@ -850,7 +850,7 @@ void __init init_bsp_APIC(void)
 /**
  * setup_local_APIC - setup the local APIC
  */
-void __devinit setup_local_APIC(void)
+void __cpuinit setup_local_APIC(void)
 {
 	unsigned long oldvalue, value, maxlvt, integrated;
 	int i, j;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
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
scsi-megaraidc-__devexit-annotation.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
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
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
