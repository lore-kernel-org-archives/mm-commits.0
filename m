From: akpm@linux-foundation.org
Subject: - drivers-net-cxgb3-xgmacc-remove-dead-code.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:30 -0700
Message-ID: <200710051957.l95JvURG022470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762797AbXJEUBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/net/cxgb3/xgmac.c: remove dead code
has been removed from the -mm tree.  Its filename was
     drivers-net-cxgb3-xgmacc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/net/cxgb3/xgmac.c: remove dead code
From: Adrian Bunk <bunk@stusta.de>

This patch removes dead code ("tx_xcnt" can never be != 0 at this place)
spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/xgmac.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/cxgb3/xgmac.c~drivers-net-cxgb3-xgmacc-remove-dead-code drivers/net/cxgb3/xgmac.c
--- a/drivers/net/cxgb3/xgmac.c~drivers-net-cxgb3-xgmacc-remove-dead-code
+++ a/drivers/net/cxgb3/xgmac.c
@@ -522,10 +522,7 @@ int t3b2_mac_watchdog_task(struct cmac *
 		goto rxcheck;
 	}
 
-	if (((tx_tcnt != mac->tx_tcnt) &&
-	     (tx_xcnt == 0) && (mac->tx_xcnt == 0)) ||
-	    ((mac->tx_mcnt == tx_mcnt) &&
-	     (tx_xcnt != 0) && (mac->tx_xcnt != 0))) {
+	if ((tx_tcnt != mac->tx_tcnt) && (mac->tx_xcnt == 0))  {
 		if (mac->toggle_cnt > 4) {
 			status = 2;
 			goto out;
_

Patches currently in -mm which might be from bunk@stusta.de are

slow-down-printk-during-boot.patch
git-acpi.patch
git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-net.patch
git-backlight.patch
git-nfs.patch
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
