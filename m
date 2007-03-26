From: akpm@linux-foundation.org
Subject: - drivers-video-s3fbc-fix-a-use-before-check.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:04:45 -0800
Message-ID: <200703260104.l2Q14jkX008665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38688 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452AbXCZBIJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/s3fb.c: fix a use-before-check
has been removed from the -mm tree.  Its filename was
     drivers-video-s3fbc-fix-a-use-before-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/s3fb.c: fix a use-before-check
From: Adrian Bunk <bunk@stusta.de>

NULL checks should be before the first dereference.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3fb.c~drivers-video-s3fbc-fix-a-use-before-check drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~drivers-video-s3fbc-fix-a-use-before-check
+++ a/drivers/video/s3fb.c
@@ -1000,11 +1000,12 @@ err_enable_device:
 static void __devexit s3_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	struct s3fb_info *par = info->par;
 
 	if (info) {
 
 #ifdef CONFIG_MTRR
+		struct s3fb_info *par = info->par;
+
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
 			par->mtrr_reg = -1;
_

Patches currently in -mm which might be from bunk@stusta.de are

drivers-spi-fix-section-mismatches.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
make-mptspi_target_destroy-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-struct-v9fs_cached_file_operations-static.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
