From: akpm@linux-foundation.org
Subject: - savagefb-rework-i2c-bit-access.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:46 -0700
Message-ID: <200705090300.l4930k8O010606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032902AbXEIDAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     savagefb: rework i2c bit access
has been removed from the -mm tree.  Its filename was
     savagefb-rework-i2c-bit-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: savagefb: rework i2c bit access
From: "Antonino A. Daplas" <adaplas@gmail.com>

Use already defined VGAwCR/VGArCR functions to access the i2c bus.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb-i2c.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/video/savage/savagefb-i2c.c~savagefb-rework-i2c-bit-access drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~savagefb-rework-i2c-bit-access
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -41,10 +41,6 @@
 #define SAVAGE4_I2C_SCL_IN	0x00000008
 #define SAVAGE4_I2C_SDA_IN	0x00000010
 
-#define SET_CR_IX(base, val)	writeb((val), base + 0x8000 + VGA_CR_IX)
-#define SET_CR_DATA(base, val)	writeb((val), base + 0x8000 + VGA_CR_DATA)
-#define GET_CR_DATA(base)	readb(base + 0x8000 + VGA_CR_DATA)
-
 static void savage4_gpio_setscl(void *data, int val)
 {
 	struct savagefb_i2c_chan *chan = data;
@@ -92,15 +88,15 @@ static void prosavage_gpio_setscl(void* 
 	struct savagefb_i2c_chan *chan = data;
 	u32			  r;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	r = GET_CR_DATA(chan->ioaddr);
+	r = VGArCR(chan->reg, chan->par);
 	r |= PROSAVAGE_I2C_ENAB;
 	if (val) {
 		r |= PROSAVAGE_I2C_SCL_OUT;
 	} else {
 		r &= ~PROSAVAGE_I2C_SCL_OUT;
 	}
-	SET_CR_DATA(chan->ioaddr, r);
+
+	VGAwCR(chan->reg, r, chan->par);
 }
 
 static void prosavage_gpio_setsda(void* data, int val)
@@ -108,31 +104,29 @@ static void prosavage_gpio_setsda(void* 
 	struct savagefb_i2c_chan *chan = data;
 	unsigned int r;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	r = GET_CR_DATA(chan->ioaddr);
+	r = VGArCR(chan->reg, chan->par);
 	r |= PROSAVAGE_I2C_ENAB;
 	if (val) {
 		r |= PROSAVAGE_I2C_SDA_OUT;
 	} else {
 		r &= ~PROSAVAGE_I2C_SDA_OUT;
 	}
-	SET_CR_DATA(chan->ioaddr, r);
+
+	VGAwCR(chan->reg, r, chan->par);
 }
 
 static int prosavage_gpio_getscl(void* data)
 {
 	struct savagefb_i2c_chan *chan = data;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	return (0 != (GET_CR_DATA(chan->ioaddr) & PROSAVAGE_I2C_SCL_IN));
+	return (VGArCR(chan->reg, chan->par) & PROSAVAGE_I2C_SCL_IN) ? 1 : 0;
 }
 
 static int prosavage_gpio_getsda(void* data)
 {
 	struct savagefb_i2c_chan *chan = data;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	return (0 != (GET_CR_DATA(chan->ioaddr) & PROSAVAGE_I2C_SDA_IN));
+	return (VGArCR(chan->reg, chan->par) & PROSAVAGE_I2C_SDA_IN) ? 1 : 0;
 }
 
 static int savage_setup_i2c_bus(struct savagefb_i2c_chan *chan,
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
