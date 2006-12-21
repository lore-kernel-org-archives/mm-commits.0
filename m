From: akpm@osdl.org
Subject: - drivers-media-video-cafe_ccicc-fix-null-dereference.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:21 -0800
Message-ID: <200612212010.kBLKAL2f003560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36783 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423068AbWLUUNj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cafe_ccic.c: fix NULL dereference
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cafe_ccicc-fix-null-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/video/cafe_ccic.c: fix NULL dereference
From: Adrian Bunk <bunk@stusta.de>

We shouldn't dereference "cam" when we already know it's NULL.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/cafe_ccic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-null-dereference drivers/media/video/cafe_ccic.c
--- a/drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-null-dereference
+++ a/drivers/media/video/cafe_ccic.c
@@ -2166,7 +2166,7 @@ static void cafe_pci_remove(struct pci_d
 	struct cafe_camera *cam = cafe_find_by_pdev(pdev);
 
 	if (cam == NULL) {
-		cam_warn(cam, "pci_remove on unknown pdev %p\n", pdev);
+		printk(KERN_WARNING "pci_remove on unknown pdev %p\n", pdev);
 		return;
 	}
 	mutex_lock(&cam->s_mutex);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
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

