From: akpm@linux-foundation.org
Subject: [merged] lm90-support-the-max6648-6692-chips.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:07 -0800
Message-ID: <200903061928.n26JS8pw022651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbZCFT2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     lm90: support the MAX6648/6692 chips
has been removed from the -mm tree.  Its filename was
     lm90-support-the-max6648-6692-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lm90: support the MAX6648/6692 chips
From: "Darrick J. Wong" <djwong@us.ibm.com>

The max6648 chip has nearly the same register set as the 6657 and seems to
have a working manufacturer/chip id so we can detect it.  This patch adds
support for it.  Tested on a Nvidia Quadro FX 1500 card.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    4 ++--
 drivers/hwmon/lm90.c  |    7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/Kconfig~lm90-support-the-max6648-6692-chips drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lm90-support-the-max6648-6692-chips
+++ a/drivers/hwmon/Kconfig
@@ -543,8 +543,8 @@ config SENSORS_LM90
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
 	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, and Maxim
-	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680 and
-	  MAX6681 sensor chips.
+	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680,
+	  MAX6648, MAX6692 and MAX6681 sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff -puN drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips drivers/hwmon/lm90.c
--- a/drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips
+++ a/drivers/hwmon/lm90.c
@@ -776,7 +776,12 @@ static int lm90_detect(struct i2c_client
 			 && (reg_config1 & 0x3f) == 0x00
 			 && reg_convrate <= 0x07) {
 				kind = max6646;
-			}
+			} else
+			/* The MAX6648/6692 chips have a working man/chip id
+			 * and the same register set as the 6657.
+			 */
+			if (chip_id == 0x59 && address == 0x4C)
+				kind = max6657;
 		}
 
 		if (kind <= 0) { /* identification failed */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

lm85-fix-the-version-check-that-broke-adt7468-probing.patch
lm85-add-vrm10-support-for-adt7468-chip.patch
linux-next.patch

