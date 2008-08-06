From: akpm@linux-foundation.org
Subject: - rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch removed from -mm tree
Date: Tue, 05 Aug 2008 17:42:09 -0700
Message-ID: <200808060042.m760g9rj031807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYHFAmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 20:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-rs5c732: add support for Ricoh R2025S/D RTC
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-rs5c732: add support for Ricoh R2025S/D RTC
From: Paul Mundt <lethal@linux-sh.org>

This adds support for the Ricoh R2025S/D series of I2C RTCs, produced
by Ricoh Japan and described at:

	http://www.ricoh.co.jp/LSI/product_rtc/2wire/r2025x/

This series has very minor deviations from the rest of the RS5C chips, most of
which have to do with the oscillator, which was abstracted away in an earlier
patch.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -1,5 +1,5 @@
 /*
- * An I2C driver for Ricoh RS5C372 and RV5C38[67] RTCs
+ * An I2C driver for Ricoh RS5C372, R2025S/D and RV5C38[67] RTCs
  *
  * Copyright (C) 2005 Pavel Mironchik <pmironchik@optifacio.net>
  * Copyright (C) 2006 Tower Technologies
@@ -52,7 +52,8 @@
 #	define RS5C_CTRL1_CT4		(4 << 0)	/* 1 Hz level irq */
 #define RS5C_REG_CTRL2		15
 #	define RS5C372_CTRL2_24		(1 << 5)
-#	define RS5C_CTRL2_XSTP		(1 << 4)
+#	define R2025_CTRL2_XST		(1 << 5)
+#	define RS5C_CTRL2_XSTP		(1 << 4)	/* only if !R2025S/D */
 #	define RS5C_CTRL2_CTFG		(1 << 2)
 #	define RS5C_CTRL2_AAFG		(1 << 1)	/* or WAFG */
 #	define RS5C_CTRL2_BAFG		(1 << 0)	/* or DAFG */
@@ -64,6 +65,7 @@
 
 enum rtc_type {
 	rtc_undef = 0,
+	rtc_r2025sd,
 	rtc_rs5c372a,
 	rtc_rs5c372b,
 	rtc_rv5c386,
@@ -71,6 +73,7 @@ enum rtc_type {
 };
 
 static const struct i2c_device_id rs5c372_id[] = {
+	{ "r2025sd", rtc_r2025sd },
 	{ "rs5c372a", rtc_rs5c372a },
 	{ "rs5c372b", rtc_rs5c372b },
 	{ "rv5c386", rtc_rv5c386 },
@@ -531,9 +534,15 @@ static int rs5c_oscillator_setup(struct 
 	unsigned char buf[2];
 	int addr, i, ret = 0;
 
-	if (!(rs5c372->regs[RS5C_REG_CTRL2] & RS5C_CTRL2_XSTP))
-		return ret;
-	rs5c372->regs[RS5C_REG_CTRL2] &= ~RS5C_CTRL2_XSTP;
+	if (rs5c372->type == rtc_r2025sd) {
+		if (!(rs5c372->regs[RS5C_REG_CTRL2] & R2025_CTRL2_XST))
+			return ret;
+		rs5c372->regs[RS5C_REG_CTRL2] &= ~R2025_CTRL2_XST;
+	} else {
+		if (!(rs5c372->regs[RS5C_REG_CTRL2] & RS5C_CTRL2_XSTP))
+			return ret;
+		rs5c372->regs[RS5C_REG_CTRL2] &= ~RS5C_CTRL2_XSTP;
+	}
 
 	addr   = RS5C_ADDR(RS5C_REG_CTRL1);
 	buf[0] = rs5c372->regs[RS5C_REG_CTRL1];
@@ -546,6 +555,7 @@ static int rs5c_oscillator_setup(struct 
 		buf[1] |= RS5C372_CTRL2_24;
 		rs5c372->time24 = 1;
 		break;
+	case rtc_r2025sd:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		buf[0] |= RV5C387_CTRL1_24;
@@ -623,6 +633,7 @@ static int rs5c372_probe(struct i2c_clie
 		if (rs5c372->regs[RS5C_REG_CTRL2] & RS5C372_CTRL2_24)
 			rs5c372->time24 = 1;
 		break;
+	case rtc_r2025sd:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		if (rs5c372->regs[RS5C_REG_CTRL1] & RV5C387_CTRL1_24)
@@ -638,6 +649,9 @@ static int rs5c372_probe(struct i2c_clie
 
 	/* if the oscillator lost power and no other software (like
 	 * the bootloader) set it up, do it here.
+	 *
+	 * The R2025S/D does this a little differently than the other
+	 * parts, so we special case that..
 	 */
 	err = rs5c_oscillator_setup(rs5c372);
 	if (unlikely(err < 0)) {
@@ -650,6 +664,7 @@ static int rs5c372_probe(struct i2c_clie
 
 	dev_info(&client->dev, "%s found, %s, driver version " DRV_VERSION "\n",
 			({ char *s; switch (rs5c372->type) {
+			case rtc_r2025sd:	s = "r2025sd"; break;
 			case rtc_rs5c372a:	s = "rs5c372a"; break;
 			case rtc_rs5c372b:	s = "rs5c372b"; break;
 			case rtc_rv5c386:	s = "rv5c386"; break;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-renesas-highlander-fpga-smbus-support-update.patch
git-sh.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

