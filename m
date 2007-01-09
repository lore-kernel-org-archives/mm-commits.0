From: akpm@osdl.org
Subject: - make-usbvision_rvfree-static.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:28:33 -0800
Message-ID: <200701092028.l09KSX9X014317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414AbXAIU32 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     make usbvision_rvfree() static
has been removed from the -mm tree.  Its filename was
     make-usbvision_rvfree-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make usbvision_rvfree() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/usbvision/usbvision-core.c |    2 +-
 drivers/media/video/usbvision/usbvision.h      |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/usbvision/usbvision-core.c~make-usbvision_rvfree-static drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~make-usbvision_rvfree-static
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -139,7 +139,7 @@ static void *usbvision_rvmalloc(unsigned
 	return mem;
 }
 
-void usbvision_rvfree(void *mem, unsigned long size)
+static void usbvision_rvfree(void *mem, unsigned long size)
 {
 	unsigned long adr;
 
diff -puN drivers/media/video/usbvision/usbvision.h~make-usbvision_rvfree-static drivers/media/video/usbvision/usbvision.h
--- a/drivers/media/video/usbvision/usbvision.h~make-usbvision_rvfree-static
+++ a/drivers/media/video/usbvision/usbvision.h
@@ -486,7 +486,6 @@ int usbvision_init_i2c(struct usb_usbvis
 void call_i2c_clients(struct usb_usbvision *usbvision, unsigned int cmd,void *arg);
 
 /* defined in usbvision-core.c                                      */
-void usbvision_rvfree(void *mem, unsigned long size);
 int usbvision_read_reg(struct usb_usbvision *usbvision, unsigned char reg);
 int usbvision_write_reg(struct usb_usbvision *usbvision, unsigned char reg,
 			unsigned char value);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
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
x86_64-re-add-a-newline-to-restore_context.patch
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
