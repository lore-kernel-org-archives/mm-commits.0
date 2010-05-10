From: akpm@linux-foundation.org
Subject: + ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch added to -mm tree
Date: Mon, 10 May 2010 15:11:36 -0700
Message-ID: <201005102211.o4AMBa2R025620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850Ab0EJWLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     ad525x_dpot: add support for ADN2860 and AD528x pots
has been added to the -mm tree.  Its filename is
     ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch

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
Subject: ad525x_dpot: add support for ADN2860 and AD528x pots
From: Michael Hennerich <michael.hennerich@analog.com>

New parts supported:
	AD5280, AD5282, ADN2860

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig           |    3 ++-
 drivers/misc/ad525x_dpot-i2c.c |    3 +++
 drivers/misc/ad525x_dpot.c     |   28 +++++++++++++++++-----------
 drivers/misc/ad525x_dpot.h     |    6 ++++--
 4 files changed, 26 insertions(+), 14 deletions(-)

diff -puN drivers/misc/Kconfig~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots
+++ a/drivers/misc/Kconfig
@@ -23,7 +23,8 @@ config AD525X_DPOT
 	  AD5204, AD5206, AD5207, AD5231, AD5232, AD5233, AD5235,
 	  AD5260, AD5262, AD5263, AD5290, AD5291, AD5292, AD5293,
 	  AD7376, AD8400, AD8402, AD8403, ADN2850, AD5241, AD5242,
-	  AD5243, AD5245, AD5246, AD5247, AD5248
+	  AD5243, AD5245, AD5246, AD5247, AD5248, AD5280, AD5282,
+	  ADN2860
 	  digital potentiometer chips.
 
 	  See Documentation/misc-devices/ad525x_dpot.txt for the
diff -puN drivers/misc/ad525x_dpot-i2c.c~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots drivers/misc/ad525x_dpot-i2c.c
--- a/drivers/misc/ad525x_dpot-i2c.c~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots
+++ a/drivers/misc/ad525x_dpot-i2c.c
@@ -94,6 +94,9 @@ static const struct i2c_device_id ad_dpo
 	{"ad5246", AD5246_ID},
 	{"ad5247", AD5247_ID},
 	{"ad5248", AD5248_ID},
+	{"ad5280", AD5280_ID},
+	{"ad5282", AD5282_ID},
+	{"adn2860", ADN2860_ID},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
diff -puN drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots
+++ a/drivers/misc/ad525x_dpot.c
@@ -44,6 +44,9 @@
  * AD5243		2		256		2.5, 10, 50, 100
  * AD5248		2		256		2.5, 10, 50, 100
  * AD5242		2		256		20, 50, 200
+ * AD5280		1		256		20, 50, 200
+ * AD5282		2		256		20, 50, 200
+ * ADN2860		3		512		25, 250
  *
  * See Documentation/misc-devices/ad525x_dpot.txt for more info.
  *
@@ -153,6 +156,8 @@ static s32 dpot_read_i2c(struct dpot_dat
 	case DPOT_UID(AD5242_ID):
 	case DPOT_UID(AD5243_ID):
 	case DPOT_UID(AD5248_ID):
+	case DPOT_UID(AD5280_ID):
+	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
 			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_read_r8d8(dpot, ctrl);
@@ -249,21 +254,22 @@ static s32 dpot_write_i2c(struct dpot_da
 	case DPOT_UID(AD5242_ID):
 	case DPOT_UID(AD5243_ID):
 	case DPOT_UID(AD5248_ID):
-		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ? 0 : DPOT_AD5291_RDAC_AB;
+	case DPOT_UID(AD5280_ID):
+	case DPOT_UID(AD5282_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
+			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
-
-
 	default:
-	if (reg & DPOT_ADDR_CMD)
-		return dpot_write_d8(dpot, reg);
+		if (reg & DPOT_ADDR_CMD)
+			return dpot_write_d8(dpot, reg);
 
-	if (dpot->max_pos > 256)
-		return dpot_write_r8d16(dpot, (reg & 0xF8) |
-					((reg & 0x7) << 1), value);
-	else
-		/* All other registers require instruction + data bytes */
-		return dpot_write_r8d8(dpot, reg, value);
+		if (dpot->max_pos > 256)
+			return dpot_write_r8d16(dpot, (reg & 0xF8) |
+						((reg & 0x7) << 1), value);
+		else
+			/* All other registers require instruction + data bytes */
+			return dpot_write_r8d8(dpot, reg, value);
 	}
 }
 
diff -puN drivers/misc/ad525x_dpot.h~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots drivers/misc/ad525x_dpot.h
--- a/drivers/misc/ad525x_dpot.h~ad525x_dpot-add-support-for-adn2860-and-ad528x-pots
+++ a/drivers/misc/ad525x_dpot.h
@@ -112,8 +112,10 @@ enum dpot_devid {
 	AD5246_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 37),
 	AD5247_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 38),
 	AD5248_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 39),
-
