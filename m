From: akpm@linux-foundation.org
Subject: - e1000-if-0-two-functions.patch removed from -mm tree
Date: Fri, 28 Sep 2007 23:00:17 -0700
Message-ID: <200709290600.l8T60HuG002966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbXI2GA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Sep 2007 02:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000: #if 0 two functions
has been removed from the -mm tree.  Its filename was
     e1000-if-0-two-functions.patch

This patch was dropped because it was folded into pci-x-pci-express-read-control-interfaces-e1000.patch

------------------------------------------------------
Subject: e1000: #if 0 two functions
From: Adrian Bunk <bunk@stusta.de>

e1000_{read,write}_pci_cfg() are no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_hw.h   |    2 --
 drivers/net/e1000/e1000_main.c |    4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/e1000/e1000_hw.h~e1000-if-0-two-functions drivers/net/e1000/e1000_hw.h
--- a/drivers/net/e1000/e1000_hw.h~e1000-if-0-two-functions
+++ a/drivers/net/e1000/e1000_hw.h
@@ -421,8 +421,6 @@ void e1000_tbi_adjust_stats(struct e1000
 void e1000_get_bus_info(struct e1000_hw *hw);
 void e1000_pci_set_mwi(struct e1000_hw *hw);
 void e1000_pci_clear_mwi(struct e1000_hw *hw);
-void e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
-void e1000_write_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
 int32_t e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t *value);
 void e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc);
 int e1000_pcix_get_mmrbc(struct e1000_hw *hw);
diff -puN drivers/net/e1000/e1000_main.c~e1000-if-0-two-functions drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-if-0-two-functions
+++ a/drivers/net/e1000/e1000_main.c
@@ -4885,6 +4885,8 @@ e1000_pci_clear_mwi(struct e1000_hw *hw)
 	pci_clear_mwi(adapter->pdev);
 }
 
+#if 0
+
 void
 e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t *value)
 {
@@ -4901,6 +4903,8 @@ e1000_write_pci_cfg(struct e1000_hw *hw,
 	pci_write_config_word(adapter->pdev, reg, *value);
 }
 
+#endif  /*  0  */
+
 int
 e1000_pcix_get_mmrbc(struct e1000_hw *hw)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

slow-down-printk-during-boot-fix-3.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-immc-fix-check-after-use.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
