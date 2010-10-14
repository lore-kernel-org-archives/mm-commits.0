From: akpm@linux-foundation.org
Subject: + drivers-misc-ad525x_dpot-new-features.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:22:39 -0700
Message-ID: <201010142222.o9EMMdMj022861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab0JNWWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, chrisv@cyberswitching.com, vapier@gentoo.org


The patch titled
     drivers/misc/ad525x_dpot.c: new features
has been added to the -mm tree.  Its filename is
     drivers-misc-ad525x_dpot-new-features.patch

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
Subject: drivers/misc/ad525x_dpot.c: new features
From: Michael Hennerich <michael.hennerich@analog.com>

Add support for AD5270, AD5271, AD5272, AD5274 digital potentiometers. 
Add 20-TP feature for AD5291 and AD5292 parts, and update feature list. 
AD5291 rdac read back must be shifted by two.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig           |    3 
 drivers/misc/ad525x_dpot-i2c.c |    2 
 drivers/misc/ad525x_dpot-spi.c |    2 
 drivers/misc/ad525x_dpot.c     |  107 ++++++++++++++++++++++++++++---
 drivers/misc/ad525x_dpot.h     |   25 ++++++-
 5 files changed, 124 insertions(+), 15 deletions(-)

diff -puN drivers/misc/Kconfig~drivers-misc-ad525x_dpot-new-features drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-ad525x_dpot-new-features
+++ a/drivers/misc/Kconfig
@@ -24,7 +24,8 @@ config AD525X_DPOT
 	  AD5260, AD5262, AD5263, AD5290, AD5291, AD5292, AD5293,
 	  AD7376, AD8400, AD8402, AD8403, ADN2850, AD5241, AD5242,
 	  AD5243, AD5245, AD5246, AD5247, AD5248, AD5280, AD5282,
-	  ADN2860, AD5273, AD5171, AD5170, AD5172, AD5173
+	  ADN2860, AD5273, AD5171, AD5170, AD5172, AD5173, AD5270,
+	  AD5271, AD5272, AD5274
 	  digital potentiometer chips.
 
 	  See Documentation/misc-devices/ad525x_dpot.txt for the
diff -puN drivers/misc/ad525x_dpot-i2c.c~drivers-misc-ad525x_dpot-new-features drivers/misc/ad525x_dpot-i2c.c
--- a/drivers/misc/ad525x_dpot-i2c.c~drivers-misc-ad525x_dpot-new-features
+++ a/drivers/misc/ad525x_dpot-i2c.c
@@ -102,6 +102,8 @@ static const struct i2c_device_id ad_dpo
 	{"ad5170", AD5170_ID},
 	{"ad5172", AD5172_ID},
 	{"ad5173", AD5173_ID},
+	{"ad5272", AD5272_ID},
+	{"ad5274", AD5274_ID},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
diff -puN drivers/misc/ad525x_dpot-spi.c~drivers-misc-ad525x_dpot-new-features drivers/misc/ad525x_dpot-spi.c
--- a/drivers/misc/ad525x_dpot-spi.c~drivers-misc-ad525x_dpot-new-features
+++ a/drivers/misc/ad525x_dpot-spi.c
@@ -38,6 +38,8 @@ static const struct ad_dpot_id ad_dpot_s
 	{.name = "ad8402", .devid = AD8402_ID},
 	{.name = "ad8403", .devid = AD8403_ID},
 	{.name = "adn2850", .devid = ADN2850_ID},
+	{.name = "ad5270", .devid = AD5270_ID},
+	{.name = "ad5271", .devid = AD5271_ID},
 	{}
 };
 
diff -puN drivers/misc/ad525x_dpot.c~drivers-misc-ad525x_dpot-new-features drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~drivers-misc-ad525x_dpot-new-features
+++ a/drivers/misc/ad525x_dpot.c
@@ -29,9 +29,9 @@
  * AD5262		2		256		20, 50, 200
  * AD5263		4		256		20, 50, 200
  * AD5290		1		256		10, 50, 100
- * AD5291		1		256		20
- * AD5292		1		1024		20
- * AD5293		1		1024		20
+ * AD5291		1		256		20, 50, 100  (20-TP)
+ * AD5292		1		1024		20, 50, 100  (20-TP)
+ * AD5293		1		1024		20, 50, 100
  * AD7376		1		128		10, 50, 100, 1M
  * AD8400		1		256		1, 10, 50, 100
  * AD8402		2		256		1, 10, 50, 100
@@ -52,6 +52,10 @@
  * AD5170		1		256		2.5, 10, 50, 100 (OTP)
  * AD5172		2		256		2.5, 10, 50, 100 (OTP)
  * AD5173		2		256		2.5, 10, 50, 100 (OTP)
+ * AD5270		1		1024		20, 50, 100 (50-TP)
+ * AD5271		1		256		20, 50, 100 (50-TP)
+ * AD5272		1		1024		20, 50, 100 (50-TP)
+ * AD5274		1		256		20, 50, 100 (50-TP)
  *
  * See Documentation/misc-devices/ad525x_dpot.txt for more info.
  *
@@ -126,18 +130,38 @@ static inline int dpot_write_r8d16(struc
 static s32 dpot_read_spi(struct dpot_data *dpot, u8 reg)
 {
 	unsigned ctrl = 0;
+	int value;
 
 	if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
 
 		if (dpot->feat & F_RDACS_WONLY)
 			return dpot->rdac_cache[reg & DPOT_RDAC_MASK];
-
 		if (dpot->uid == DPOT_UID(AD5291_ID) ||
 			dpot->uid == DPOT_UID(AD5292_ID) ||
-			dpot->uid == DPOT_UID(AD5293_ID))
-			return dpot_read_r8d8(dpot,
+			dpot->uid == DPOT_UID(AD5293_ID)) {
+
+			value = dpot_read_r8d8(dpot,
 				DPOT_AD5291_READ_RDAC << 2);
 
+			if (dpot->uid == DPOT_UID(AD5291_ID))
+				value = value >> 2;
+
+			return value;
+		} else if (dpot->uid == DPOT_UID(AD5270_ID) ||
+			dpot->uid == DPOT_UID(AD5271_ID)) {
+
+			value = dpot_read_r8d8(dpot,
+				DPOT_AD5270_1_2_4_READ_RDAC << 2);
+
+			if (value < 0)
+				return value;
+
+			if (dpot->uid == DPOT_UID(AD5271_ID))
+				value = value >> 2;
+
+			return value;
+		}
+
 		ctrl = DPOT_SPI_READ_RDAC;
 	} else if (reg & DPOT_ADDR_EEPROM) {
 		ctrl = DPOT_SPI_READ_EEPROM;
@@ -153,6 +177,7 @@ static s32 dpot_read_spi(struct dpot_dat
 
 static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 {
+	int value;
 	unsigned ctrl = 0;
 	switch (dpot->uid) {
 	case DPOT_UID(AD5246_ID):
@@ -177,6 +202,25 @@ static s32 dpot_read_i2c(struct dpot_dat
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
 			0 : DPOT_AD5172_3_A0;
 		return dpot_read_r8d8(dpot, ctrl);
+	case DPOT_UID(AD5272_ID):
+	case DPOT_UID(AD5274_ID):
+			dpot_write_r8d8(dpot,
+				(DPOT_AD5270_1_2_4_READ_RDAC << 2), 0);
+
+			value = dpot_read_r8d16(dpot,
+				DPOT_AD5270_1_2_4_RDAC << 2);
+
+			if (value < 0)
+				return value;
+			/*
+			 * AD5272/AD5274 returns high byte first, however
+			 * underling smbus expects low byte first.
+			 */
+			value = swab16(value);
+
+			if (dpot->uid == DPOT_UID(AD5271_ID))
+				value = value >> 2;
+		return value;
 	default:
 		if ((reg & DPOT_REG_TOL) || (dpot->max_pos > 256))
 			return dpot_read_r8d16(dpot, (reg & 0xF8) |
@@ -198,7 +242,7 @@ static s32 dpot_write_spi(struct dpot_da
 {
 	unsigned val = 0;
 
-	if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
+	if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD | DPOT_ADDR_OTP))) {
 		if (dpot->feat & F_RDACS_WONLY)
 			dpot->rdac_cache[reg & DPOT_RDAC_MASK] = value;
 
@@ -219,11 +263,30 @@ static s32 dpot_write_spi(struct dpot_da
 		} else {
 			if (dpot->uid == DPOT_UID(AD5291_ID) ||
 				dpot->uid == DPOT_UID(AD5292_ID) ||
-				dpot->uid == DPOT_UID(AD5293_ID))
+				dpot->uid == DPOT_UID(AD5293_ID)) {
+
+				dpot_write_r8d8(dpot, DPOT_AD5291_CTRLREG << 2,
+						DPOT_AD5291_UNLOCK_CMD);
+
+				if (dpot->uid == DPOT_UID(AD5291_ID))
+					value = value << 2;
+
 				return dpot_write_r8d8(dpot,
 					(DPOT_AD5291_RDAC << 2) |
 					(value >> 8), value & 0xFF);
+			} else if (dpot->uid == DPOT_UID(AD5270_ID) ||
+				dpot->uid == DPOT_UID(AD5271_ID)) {
+				dpot_write_r8d8(dpot,
+						DPOT_AD5270_1_2_4_CTRLREG << 2,
+						DPOT_AD5270_1_2_4_UNLOCK_CMD);
+
+				if (dpot->uid == DPOT_UID(AD5271_ID))
+					value = value << 2;
 
+				return dpot_write_r8d8(dpot,
+					(DPOT_AD5270_1_2_4_RDAC << 2) |
+					(value >> 8), value & 0xFF);
+			}
 			val = DPOT_SPI_RDAC | (reg & DPOT_RDAC_MASK);
 		}
 	} else if (reg & DPOT_ADDR_EEPROM) {
@@ -243,6 +306,16 @@ static s32 dpot_write_spi(struct dpot_da
 			val = DPOT_SPI_INC_ALL;
 			break;
 		}
+	} else if (reg & DPOT_ADDR_OTP) {
+		if (dpot->uid == DPOT_UID(AD5291_ID) ||
+			dpot->uid == DPOT_UID(AD5292_ID)) {
+			return dpot_write_r8d8(dpot,
+				DPOT_AD5291_STORE_XTPM << 2, 0);
+		} else if (dpot->uid == DPOT_UID(AD5270_ID) ||
+			dpot->uid == DPOT_UID(AD5271_ID)) {
+			return dpot_write_r8d8(dpot,
+				DPOT_AD5270_1_2_4_STORE_XTPM << 2, 0);
+		}
 	} else
 		BUG();
 
@@ -303,10 +376,25 @@ static s32 dpot_write_i2c(struct dpot_da
 			tmp = dpot_read_r8d16(dpot, tmp);
 			if (tmp >> 14) /* Ready to Program? */
 				return -EFAULT;
-			ctrl = DPOT_AD5270_2_3_FUSE;
+			ctrl = DPOT_AD5170_2_3_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
+	case DPOT_UID(AD5272_ID):
+	case DPOT_UID(AD5274_ID):
+		dpot_write_r8d8(dpot, DPOT_AD5270_1_2_4_CTRLREG << 2,
+				DPOT_AD5270_1_2_4_UNLOCK_CMD);
+
+		if (reg & DPOT_ADDR_OTP)
+			return dpot_write_r8d8(dpot,
+					DPOT_AD5270_1_2_4_STORE_XTPM << 2, 0);
+
+		if (dpot->uid == DPOT_UID(AD5274_ID))
+			value = value << 2;
+
+		return dpot_write_r8d8(dpot, (DPOT_AD5270_1_2_4_RDAC << 2) |
+				       (value >> 8), value & 0xFF);
+		break;
 	default:
 		if (reg & DPOT_ADDR_CMD)
 			return dpot_write_d8(dpot, reg);
@@ -320,7 +408,6 @@ static s32 dpot_write_i2c(struct dpot_da
 	}
 }
 
-
 static s32 dpot_write(struct dpot_data *dpot, u8 reg, u16 value)
 {
 	if (dpot->feat & F_SPI)
diff -puN drivers/misc/ad525x_dpot.h~drivers-misc-ad525x_dpot-new-features drivers/misc/ad525x_dpot.h
--- a/drivers/misc/ad525x_dpot.h~drivers-misc-ad525x_dpot-new-features
+++ a/drivers/misc/ad525x_dpot.h
@@ -93,8 +93,10 @@ enum dpot_devid {
 			BRDAC0 | BRDAC1 | BRDAC2 | BRDAC3, 8, 23),
 	AD5290_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_8BIT,
 			BRDAC0, 8, 24),
-	AD5291_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT, BRDAC0, 8, 25),
-	AD5292_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT, BRDAC0, 10, 26),
+	AD5291_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT | F_CMD_OTP,
+			BRDAC0, 8, 25),
+	AD5292_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT | F_CMD_OTP,
+			BRDAC0, 10, 26),
 	AD5293_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT, BRDAC0, 10, 27),
 	AD7376_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_8BIT,
 			BRDAC0, 7, 28),
@@ -122,6 +124,12 @@ enum dpot_devid {
 	AD5170_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 8, 45),
 	AD5172_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0 | BRDAC1, 8, 46),
 	AD5173_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0 | BRDAC1, 8, 47),
+	AD5270_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP | F_SPI_16BIT,
+			BRDAC0, 10, 48),
+	AD5271_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP | F_SPI_16BIT,
+			BRDAC0, 8, 49),
+	AD5272_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 10, 50),
+	AD5274_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 8, 51),
 };
 
 #define DPOT_RDAC0		0
@@ -165,10 +173,19 @@ enum dpot_devid {
 /* AD5291/2/3 use special commands */
 #define DPOT_AD5291_RDAC	0x01
 #define DPOT_AD5291_READ_RDAC	0x02
-
-#define DPOT_AD5291_RDAC_AB	0x80
+#define DPOT_AD5291_STORE_XTPM	0x03
+#define DPOT_AD5291_CTRLREG	0x06
+#define DPOT_AD5291_UNLOCK_CMD	0x03
+
+/* AD5270/1/2/4 use special commands */
+#define DPOT_AD5270_1_2_4_RDAC		0x01
+#define DPOT_AD5270_1_2_4_READ_RDAC	0x02
+#define DPOT_AD5270_1_2_4_STORE_XTPM	0x03
+#define DPOT_AD5270_1_2_4_CTRLREG	0x07
+#define DPOT_AD5270_1_2_4_UNLOCK_CMD	0x03
 
 #define DPOT_AD5282_RDAC_AB	0x80
+
 #define DPOT_AD5273_FUSE	0x80
 #define DPOT_AD5170_2_3_FUSE	0x20
 #define DPOT_AD5170_2_3_OW	0x08
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch

