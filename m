From: akpm@linux-foundation.org
Subject: + nvidiafb-access-crt-registers-safely.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:16 -0700
Message-ID: <200704091938.l39JcGS2021598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXDITiS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     nvidiafb: access CRT registers safely
has been added to the -mm tree.  Its filename is
     nvidiafb-access-crt-registers-safely.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb: access CRT registers safely
From: "Antonino A. Daplas" <adaplas@gmail.com>

Use Read/WriteCrtc() to access CRTC registers in nv_i2c.c.  These are safer
  because it uses the correct CRTC base (0x3bx or 0x3dx).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-access-crt-registers-safely drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-access-crt-registers-safely
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -30,16 +30,14 @@ static void nvidia_gpio_setscl(void *dat
 	struct nvidia_par *par = chan->par;
 	u32 val;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
-	val = VGA_RD08(par->PCIO, 0x3d5) & 0xf0;
+	val = NVReadCrtc(par, chan->ddc_base + 1) & 0xf0;
 
 	if (state)
 		val |= 0x20;
 	else
 		val &= ~0x20;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
-	VGA_WR08(par->PCIO, 0x3d5, val | 0x1);
+	NVWriteCrtc(par, chan->ddc_base + 1, val | 0x01);
 }
 
 static void nvidia_gpio_setsda(void *data, int state)
@@ -48,16 +46,14 @@ static void nvidia_gpio_setsda(void *dat
 	struct nvidia_par *par = chan->par;
 	u32 val;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
-	val = VGA_RD08(par->PCIO, 0x3d5) & 0xf0;
+	val = NVReadCrtc(par, chan->ddc_base + 1) & 0xf0;
 
 	if (state)
 		val |= 0x10;
 	else
 		val &= ~0x10;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
-	VGA_WR08(par->PCIO, 0x3d5, val | 0x1);
+	NVWriteCrtc(par, chan->ddc_base + 1, val | 0x01);
 }
 
 static int nvidia_gpio_getscl(void *data)
@@ -66,8 +62,7 @@ static int nvidia_gpio_getscl(void *data
 	struct nvidia_par *par = chan->par;
 	u32 val = 0;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base);
-	if (VGA_RD08(par->PCIO, 0x3d5) & 0x04)
+	if (NVReadCrtc(par, chan->ddc_base) & 0x04)
 		val = 1;
 
 	return val;
@@ -79,8 +74,7 @@ static int nvidia_gpio_getsda(void *data
 	struct nvidia_par *par = chan->par;
 	u32 val = 0;
 
-	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base);
-	if (VGA_RD08(par->PCIO, 0x3d5) & 0x08)
+	if (NVReadCrtc(par, chan->ddc_base) & 0x08)
 		val = 1;
 
 	return val;
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
