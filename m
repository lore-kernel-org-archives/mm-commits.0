From: akpm@linux-foundation.org
Subject: + nvidiafb-bring-back-generic-ddc-reading.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:00 -0800
Message-ID: <200702272110.l1RLA4KV028686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXB0VKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     nvidiafb: bring back generic ddc reading
has been added to the -mm tree.  Its filename is
     nvidiafb-bring-back-generic-ddc-reading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb: bring back generic ddc reading
From: "Antonino A. Daplas" <adaplas@gmail.com>

Make nvidiafb use fb_ddc_read().  This patch was submitted before but was
reverted due to problems in a non-x86 platform.  This includes a fix for that
where ddc reading is bypassed if there is no DDC bus (duh).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c |   44 +-------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-bring-back-generic-ddc-reading drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-bring-back-generic-ddc-reading
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -70,8 +70,6 @@ static int nvidia_gpio_getscl(void *data
 	if (VGA_RD08(par->PCIO, 0x3d5) & 0x04)
 		val = 1;
 
-	val = VGA_RD08(par->PCIO, 0x3d5);
-
 	return val;
 }
 
@@ -159,51 +157,13 @@ void nvidia_delete_i2c_busses(struct nvi
 
 }
 
-static u8 *nvidia_do_probe_i2c_edid(struct nvidia_i2c_chan *chan)
-{
-	u8 start = 0x0;
-	struct i2c_msg msgs[] = {
-		{
-		 .addr = 0x50,
-		 .len = 1,
-		 .buf = &start,
-		 }, {
-		     .addr = 0x50,
-		     .flags = I2C_M_RD,
-		     .len = EDID_LENGTH,
-		     },
-	};
-	u8 *buf;
-
-	if (!chan->par)
-		return NULL;
-
-	buf = kmalloc(EDID_LENGTH, GFP_KERNEL);
-	if (!buf) {
-		dev_warn(&chan->par->pci_dev->dev, "Out of memory!\n");
-		return NULL;
-	}
-	msgs[1].buf = buf;
-
-	if (i2c_transfer(&chan->adapter, msgs, 2) == 2)
-		return buf;
-	dev_dbg(&chan->par->pci_dev->dev, "Unable to read EDID block.\n");
-	kfree(buf);
-	return NULL;
-}
-
 int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
 {
 	struct nvidia_par *par = info->par;
 	u8 *edid = NULL;
-	int i;
 
-	for (i = 0; i < 3; i++) {
-		/* Do the real work */
-		edid = nvidia_do_probe_i2c_edid(&par->chan[conn - 1]);
-		if (edid)
-			break;
-	}
+	if (par->chan[conn - 1].par)
+		edid = fb_ddc_read(&par->chan[conn - 1].adapter);
 
 	if (!edid && conn == 1) {
 		/* try to get from firmware */
_

Patches currently in -mm which might be from adaplas@gmail.com are

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
