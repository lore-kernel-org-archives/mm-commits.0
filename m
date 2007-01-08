From: akpm@osdl.org
Subject: + remove-bogus-con_is_present-prototypes.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:33:41 -0800
Message-ID: <200701082333.l08NXfRJ022751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXAHXhW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     remove bogus con_is_present() prototypes
has been added to the -mm tree.  Its filename is
     remove-bogus-con_is_present-prototypes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove bogus con_is_present() prototypes
From: Adrian Bunk <bunk@stusta.de>

Although gcc seems to accept "extern" prototypes after it has seen the
"static inline" function, that's not really correct.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    2 --
 drivers/video/igafb.c          |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~remove-bogus-con_is_present-prototypes drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~remove-bogus-con_is_present-prototypes
+++ a/drivers/video/aty/atyfb_base.c
@@ -2957,8 +2957,6 @@ extern void (*prom_palette) (int);
 static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
 			struct fb_info *info, unsigned long addr)
 {
-	extern int con_is_present(void);
-
 	struct atyfb_par *par = info->par;
 	struct pcidev_cookie *pcp;
 	char prop[128];
diff -puN drivers/video/igafb.c~remove-bogus-con_is_present-prototypes drivers/video/igafb.c
--- a/drivers/video/igafb.c~remove-bogus-con_is_present-prototypes
+++ a/drivers/video/igafb.c
@@ -370,7 +370,6 @@ static int __init iga_init(struct fb_inf
 
 int __init igafb_init(void)
 {
-        extern int con_is_present(void);
         struct fb_info *info;
         struct pci_dev *pdev;
         struct iga_par *par;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
make-isa_bridge-alpha-only.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
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
remove-bogus-con_is_present-prototypes.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
