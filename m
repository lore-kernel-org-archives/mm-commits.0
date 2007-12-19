From: akpm@linux-foundation.org
Subject: + if-0-pci_cleanup_aer_correct_error_status.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:41:25 -0800
Message-ID: <200712190041.lBJ0fPoN030180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbXLSAmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:42:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, gregkh@suse.de, shemminger@linux-foundation.org


The patch titled
     #if 0 pci_cleanup_aer_correct_error_status()
has been added to the -mm tree.  Its filename is
     if-0-pci_cleanup_aer_correct_error_status.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: #if 0 pci_cleanup_aer_correct_error_status()
From: Adrian Bunk <bunk@kernel.org>

#if 0 the no longer used pci_cleanup_aer_correct_error_status().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 ++-
 include/linux/aer.h                |    5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~if-0-pci_cleanup_aer_correct_error_status drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~if-0-pci_cleanup_aer_correct_error_status
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -117,6 +117,7 @@ int pci_cleanup_aer_uncorrect_error_stat
 	return 0;
 }
 
+#if 0
 int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 {
 	int pos;
@@ -131,6 +132,7 @@ int pci_cleanup_aer_correct_error_status
 
 	return 0;
 }
+#endif  /*  0  */
 
 static int find_device_iter(struct device *device, void *data)
 {
@@ -757,5 +759,4 @@ EXPORT_SYMBOL_GPL(pci_find_aer_capabilit
 EXPORT_SYMBOL_GPL(pci_enable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_disable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_cleanup_aer_uncorrect_error_status);
-EXPORT_SYMBOL_GPL(pci_cleanup_aer_correct_error_status);
 
diff -puN include/linux/aer.h~if-0-pci_cleanup_aer_correct_error_status include/linux/aer.h
--- a/include/linux/aer.h~if-0-pci_cleanup_aer_correct_error_status
+++ a/include/linux/aer.h
@@ -13,7 +13,6 @@ extern int pci_enable_pcie_error_reporti
 extern int pci_find_aer_capability(struct pci_dev *dev);
 extern int pci_disable_pcie_error_reporting(struct pci_dev *dev);
 extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
-extern int pci_cleanup_aer_correct_error_status(struct pci_dev *dev);
 #else
 static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
@@ -31,10 +30,6 @@ static inline int pci_cleanup_aer_uncorr
 {
 	return -EINVAL;
 }
-static inline int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
 #endif
 
 #endif //_AER_H_
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
