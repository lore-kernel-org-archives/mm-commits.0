From: akpm@linux-foundation.org
Subject: - nvidiafb-access-crt-registers-safely.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:32 -0700
Message-ID: <200705090300.l4930W0k010578@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032790AbXEIDAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: access CRT registers safely
has been removed from the -mm tree.  Its filename was
     nvidiafb-access-crt-registers-safely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: access CRT registers safely
From: "Antonino A. Daplas" <adaplas@gmail.com>

Use Read/WriteCrtc() to access CRTC registers in nv_i2c.c.  These are safer
  because it uses the correct CRTC base (0x3bx or 0x3dx).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

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

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
