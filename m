From: akpm@linux-foundation.org
Subject: + viafb-split-viafb_set_start_addr-up.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:13:09 -0700
Message-ID: <200908060013.n760D9E7030386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbZHFANN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: split viafb_set_start_addr up
has been added to the -mm tree.  Its filename is
     viafb-split-viafb_set_start_addr-up.patch

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
Subject: viafb: split viafb_set_start_addr up
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Move individual start address setting to viafb_set_primary_address and
viafb_set_secondary_address and make it more flexible to reuse it for
panning.  Using central functions makes it easier to follow HW
manipulations.

Remove crt locking as it should be only needed for timing manipulation.
Move iga_path manipulation to via_pci_probe.

Remove memset for screen cleaning as it is currently done only for the
second screen.  This is not needed for normal operation but has a little
chance of causing unwanted display artifacts.  This can be fixed later
more consistent and more efficient (using viafb_fillrect) if needed.

This is a code clenup, no notable runtime changes expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |   82 +++++++--------------------------
 drivers/video/via/hw.h       |    3 -
 drivers/video/via/viafbdev.c |   15 ++----
 3 files changed, 27 insertions(+), 73 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-split-viafb_set_start_addr-up drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-split-viafb_set_start_addr-up
+++ a/drivers/video/via/hw.c
@@ -629,70 +629,23 @@ void viafb_set_iga_path(void)
 	}
 }
 
-void viafb_set_start_addr(void)
+void viafb_set_primary_address(u32 addr)
 {
-	unsigned long offset = 0, tmp = 0, size = 0;
-	unsigned long length;
-
-	DEBUG_MSG(KERN_INFO "viafb_set_start_addr!\n");
-	viafb_unlock_crt();
-	/* update starting address of IGA1 */
-	viafb_write_reg(CR0C, VIACR, 0x00);	/*initial starting address */
-	viafb_write_reg(CR0D, VIACR, 0x00);
-	viafb_write_reg(CR34, VIACR, 0x00);
-	viafb_write_reg_mask(CR48, VIACR, 0x00, 0x1F);
-
-	if (viafb_dual_fb) {
-		viaparinfo->iga_path = IGA1;
-		viaparinfo1->iga_path = IGA2;
-	}
-
-	if (viafb_SAMM_ON == 1) {
-		if (!viafb_dual_fb) {
-			if (viafb_second_size)
-				size = viafb_second_size * 1024 * 1024;
-			else
-				size = 8 * 1024 * 1024;
-		} else {
-
-			size = viaparinfo1->memsize;
-		}
-		offset = viafb_second_offset;
-		DEBUG_MSG(KERN_INFO
-			  "viafb_second_size=%lx, second start_adddress=%lx\n",
-			  size, offset);
-	}
-	if (viafb_SAMM_ON == 1) {
-		offset = offset >> 3;
-
-		tmp = viafb_read_reg(VIACR, 0x62) & 0x01;
-		tmp |= (offset & 0x7F) << 1;
-		viafb_write_reg(CR62, VIACR, tmp);
-		viafb_write_reg(CR63, VIACR, ((offset & 0x7F80) >> 7));
-		viafb_write_reg(CR64, VIACR, ((offset & 0x7F8000) >> 15));
-		viafb_write_reg(CRA3, VIACR, ((offset & 0x3800000) >> 23));
-	} else {
-		/* update starting address */
-		viafb_write_reg(CR62, VIACR, 0x00);
-		viafb_write_reg(CR63, VIACR, 0x00);
-		viafb_write_reg(CR64, VIACR, 0x00);
-		viafb_write_reg(CRA3, VIACR, 0x00);
-	}
-
-	if (viafb_SAMM_ON == 1) {
-		if (viafb_accel) {
-			if (!viafb_dual_fb)
-				length = size - viaparinfo->fbmem_used;
-			else
-				length = size - viaparinfo1->fbmem_used;
-		} else
-			length = size;
-		offset = (unsigned long)(void *)viafb_FB_MM +
-			viafb_second_offset;
-		memset((void *)offset, 0, length);
-	}
-
-	viafb_lock_crt();
+	DEBUG_MSG(KERN_DEBUG "viafb_set_primary_address(0x%08X)\n", addr);
+	viafb_write_reg(CR0D, VIACR, addr & 0xFF);
+	viafb_write_reg(CR0C, VIACR, (addr >> 8) & 0xFF);
+	viafb_write_reg(CR34, VIACR, (addr >> 16) & 0xFF);
+	viafb_write_reg_mask(CR48, VIACR, (addr >> 24) & 0x1F, 0x1F);
+}
+
+void viafb_set_secondary_address(u32 addr)
+{
+	DEBUG_MSG(KERN_DEBUG "viafb_set_secondary_address(0x%08X)\n", addr);
+	/* secondary display supports only quadword aligned memory */
+	viafb_write_reg_mask(CR62, VIACR, (addr >> 2) & 0xFE, 0xFE);
+	viafb_write_reg(CR63, VIACR, (addr >> 10) & 0xFF);
+	viafb_write_reg(CR64, VIACR, (addr >> 18) & 0xFF);
+	viafb_write_reg_mask(CRA3, VIACR, (addr >> 26) & 0x07, 0x07);
 }
 
 void viafb_set_output_path(int device, int set_iga, int output_interface)
@@ -2288,7 +2241,8 @@ int viafb_setmode(int vmode_index, int h
 		outb(VPIT.SR[i - 1], VIASR + 1);
 	}
 
-	viafb_set_start_addr();
+	viafb_set_primary_address(0);
+	viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 	viafb_set_iga_path();
 
 	/* Write CRTC */
diff -puN drivers/video/via/hw.h~viafb-split-viafb_set_start_addr-up drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-split-viafb_set_start_addr-up
+++ a/drivers/video/via/hw.h
@@ -927,7 +927,8 @@ void viafb_get_mmio_info(unsigned long *
 	unsigned long *mmio_len);
 
 void viafb_set_iga_path(void);
-void viafb_set_start_addr(void);
+void viafb_set_primary_address(u32 addr);
+void viafb_set_secondary_address(u32 addr);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
 
 #endif /* __HW_H__ */
diff -puN drivers/video/via/viafbdev.c~viafb-split-viafb_set_start_addr-up drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-split-viafb_set_start_addr-up
+++ a/drivers/video/via/viafbdev.c
@@ -481,12 +481,7 @@ static int viafb_pan_display(struct fb_v
 	    var->bits_per_pixel / 16;
 
 	DEBUG_MSG(KERN_INFO "\nviafb_pan_display,offset =%d ", offset);
-
-	viafb_write_reg_mask(0x48, 0x3d4, ((offset >> 24) & 0x3), 0x3);
-	viafb_write_reg_mask(0x34, 0x3d4, ((offset >> 16) & 0xff), 0xff);
-	viafb_write_reg_mask(0x0c, 0x3d4, ((offset >> 8) & 0xff), 0xff);
-	viafb_write_reg_mask(0x0d, 0x3d4, (offset & 0xff), 0xff);
-
+	viafb_set_primary_address(offset);
 	return 0;
 }
 
@@ -1353,7 +1348,8 @@ static void viafb_set_device(struct devi
 		viafb_SAMM_ON = active_dev.samm;
 	viafb_primary_dev = active_dev.primary_dev;
 
-	viafb_set_start_addr();
+	viafb_set_primary_address(0);
+	viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 	viafb_set_iga_path();
 }
 
@@ -1537,7 +1533,8 @@ static int apply_device_setting(struct v
 			if (viafb_SAMM_ON)
 				viafb_primary_dev = setting_info.primary_device;
 
-			viafb_set_start_addr();
+			viafb_set_primary_address(0);
+			viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 			viafb_set_iga_path();
 		}
 		need_set_mode = 1;
@@ -2275,6 +2272,8 @@ static int __devinit via_pci_probe(void)
 				viafb_second_offset;
 		}
 
+		viaparinfo->iga_path = IGA1;
+		viaparinfo1->iga_path = IGA2;
 		memcpy(viafbinfo1, viafbinfo, sizeof(struct fb_info));
 		viafbinfo1->screen_base = viafbinfo->screen_base +
 			viafb_second_offset;
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-fix-rmmod-bug.patch
viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
fb-fix-fb_pan_display-range-check.patch

