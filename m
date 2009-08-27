From: akpm@linux-foundation.org
Subject: + viafb-another-small-cleanup-of-viafb_par.patch added to -mm tree
Date: Wed, 26 Aug 2009 17:26:18 -0700
Message-ID: <200908270026.n7R0QIKf027719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbZH0A0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 20:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: another small cleanup of viafb_par
has been added to the -mm tree.  Its filename is
     viafb-another-small-cleanup-of-viafb_par.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: another small cleanup of viafb_par
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This removes the completly useless io variable as well as the temporary
used variables mmio_base and mmio_len in favor to use directly the fb_info
variables.

This is a code cleanup only, no runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |    3 +--
 drivers/video/via/hw.h       |    3 +--
 drivers/video/via/viafbdev.c |    9 ++++-----
 drivers/video/via/viafbdev.h |    3 ---
 4 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-another-small-cleanup-of-viafb_par drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-another-small-cleanup-of-viafb_par
+++ a/drivers/video/via/hw.c
@@ -2496,8 +2496,7 @@ void viafb_crt_enable(void)
 	viafb_write_reg_mask(CR36, VIACR, 0x0, BIT5 + BIT4);
 }
 
-void viafb_get_mmio_info(unsigned long *mmio_base,
-	unsigned long *mmio_len)
+void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len)
 {
 	struct pci_dev *pdev = NULL;
 	u32 vendor, device;
diff -puN drivers/video/via/hw.h~viafb-another-small-cleanup-of-viafb_par drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-another-small-cleanup-of-viafb_par
+++ a/drivers/video/via/hw.h
@@ -923,8 +923,7 @@ int viafb_get_pixclock(int hres, int vre
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
 			   int vmode_refresh, int flag);
-void viafb_get_mmio_info(unsigned long *mmio_base,
-	unsigned long *mmio_len);
+void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len);
 
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
diff -puN drivers/video/via/viafbdev.c~viafb-another-small-cleanup-of-viafb_par drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-another-small-cleanup-of-viafb_par
+++ a/drivers/video/via/viafbdev.c
@@ -69,8 +69,6 @@ static void viafb_setup_fixinfo(struct f
 
 	fix->smem_start = viaparinfo->fbmem;
 	fix->smem_len = viaparinfo->fbmem_free;
-	fix->mmio_start = viaparinfo->mmio_base;
-	fix->mmio_len = viaparinfo->mmio_len;
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
@@ -2004,9 +2002,10 @@ static int __devinit via_pci_probe(void)
 		return -ENOMEM;
 	}
 
-	viafb_get_mmio_info(&viaparinfo->mmio_base, &viaparinfo->mmio_len);
-	viaparinfo->io_virt = ioremap_nocache(viaparinfo->mmio_base,
-		viaparinfo->mmio_len);
+	viafb_get_mmio_info(&viafbinfo->fix.mmio_start,
+		&viafbinfo->fix.mmio_len);
+	viaparinfo->io_virt = ioremap_nocache(viafbinfo->fix.mmio_start,
+		viafbinfo->fix.mmio_len);
 	if (!viaparinfo->io_virt) {
 		printk(KERN_WARNING "ioremap failed: hardware acceleration disabled\n");
 		viafb_accel = 0;
diff -puN drivers/video/via/viafbdev.h~viafb-another-small-cleanup-of-viafb_par drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-another-small-cleanup-of-viafb_par
+++ a/drivers/video/via/viafbdev.h
@@ -41,9 +41,6 @@ struct viafb_par {
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
-	unsigned int io;	/*io space address */
-	unsigned long mmio_base;	/*mmio base address */
-	unsigned long mmio_len;	/*mmio base length */
 	u32 fbmem_free;		/* Free FB memory */
 	u32 fbmem_used;		/* Use FB memory size */
 	u32 cursor_start;	/* Cursor Start Address */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

