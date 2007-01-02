From: akpm@osdl.org
Subject: + drivers-mtd-ubi-vtblc-make-2-functions-static.patch added to -mm tree
Date: Tue, 02 Jan 2007 12:46:02 -0800
Message-ID: <200701022046.l02Kk2sn029120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbXABUto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 15:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dedekind@infradead.org


The patch titled
     drivers/mtd/ubi/vtbl.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     drivers-mtd-ubi-vtblc-make-2-functions-static.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/mtd/ubi/vtbl.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/ubi/vtbl.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/ubi/vtbl.c~drivers-mtd-ubi-vtblc-make-2-functions-static drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c~drivers-mtd-ubi-vtblc-make-2-functions-static
+++ a/drivers/mtd/ubi/vtbl.c
@@ -178,8 +178,8 @@ int ubi_vtbl_set_corrupted(const struct 
 	return 0;
 }
 
-const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
-					    int vol_id);
+static const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
+					       int vol_id);
 
 const struct ubi_vtbl_vtr *ubi_vtbl_get_vtr(const struct ubi_info *ubi,
 					    int vol_id)
@@ -237,7 +237,7 @@ static int __init check_scanning_info(co
 
 static void __exit free_volume_info(const struct ubi_info *ubi);
 
-void __init init_ivols(struct ubi_info *ubi);
+static void __init init_ivols(struct ubi_info *ubi);
 
 int __init ubi_vtbl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
 {
@@ -778,7 +778,7 @@ write_error:
  * This function initializes information about internal UBI volumes. This
  * information is not stored on flash but instead, is kept only in RAM.
  */
-void __init init_ivols(struct ubi_info *ubi)
+static void __init init_ivols(struct ubi_info *ubi)
 {
 	struct ubi_vtbl_vtr *vtr;
 	struct ubi_vtbl_info *vtbl = ubi->vtbl;
@@ -818,8 +818,8 @@ void __init init_ivols(struct ubi_info *
  * This function returns a pointer to the volume tabe record. The @vol_id must
  * be correct.
  */
-const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
-					    int vol_id)
+static const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
+					       int vol_id)
 {
 	ubi_assert(ubi_is_ivol(vol_id));
 	return &ubi->vtbl->ivol_vtrs[vol_id - UBI_INTERNAL_VOL_START];
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
