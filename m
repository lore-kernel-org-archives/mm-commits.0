From: akpm@linux-foundation.org
Subject: - sparc64-kernel-pci_sun4vc-section-fixes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:40:02 -0800
Message-ID: <200802052239.m15Mdhf5013070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760829AbYBEWlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sparc64/kernel/pci_sun4v.c section fixes
has been removed from the -mm tree.  Its filename was
     sparc64-kernel-pci_sun4vc-section-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64/kernel/pci_sun4v.c section fixes
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x39be4): Section mismatch in reference from the function probe_existing_entries() to the function .init.text:page_in_phys_avail()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/pci_sun4v.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sparc64/kernel/pci_sun4v.c~sparc64-kernel-pci_sun4vc-section-fixes arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~sparc64-kernel-pci_sun4vc-section-fixes
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -625,8 +625,8 @@ static void __init pci_sun4v_scan_bus(st
 	/* XXX register error interrupt handlers XXX */
 }
 
-static unsigned long probe_existing_entries(struct pci_pbm_info *pbm,
-					    struct iommu *iommu)
+static unsigned long __init probe_existing_entries(struct pci_pbm_info *pbm,
+						   struct iommu *iommu)
 {
 	struct iommu_arena *arena = &iommu->arena;
 	unsigned long i, cnt = 0;
@@ -653,7 +653,7 @@ static unsigned long probe_existing_entr
 	return cnt;
 }
 
-static void pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
+static void __init pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
 {
 	struct iommu *iommu = pbm->iommu;
 	struct property *prop;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
deprecate-smbfs-in-favour-of-cifs.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
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
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
