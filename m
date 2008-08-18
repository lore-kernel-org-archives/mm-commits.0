From: akpm@linux-foundation.org
Subject: - applesmc-support-for-intel-imac.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:46 -0700
Message-ID: <200808181939.m7IJdk61008362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759883AbYHRTkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roberto@unbit.it, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc: support for Intel iMac
has been removed from the -mm tree.  Its filename was
     applesmc-support-for-intel-imac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: applesmc: support for Intel iMac
From: Roberto De Ioris <roberto@unbit.it>

This adds support for fans and temperature sensors on intel iMac.

Tested on iMac 24" 2.8ghz (iMac8,1), it supports the following sensors:

cpu A
ambient
gpu
gpu diode
gpu heatsink
hd bay 1
memory controller
optical drive
power

Signed-off-by: Roberto De Ioris <roberto@unbit.it>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~applesmc-support-for-intel-imac drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-support-for-intel-imac
+++ a/drivers/hwmon/applesmc.c
@@ -98,6 +98,9 @@ static const char* temperature_sensors_s
 	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
 	  "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P",
 	  "TM9S", "TN0H", "TS0C", NULL },
+/* Set 5: iMac */
+	{ "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P", "TO0P",
+	  "Tp0C", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1223,6 +1226,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 3 },
 /* MacPro: temperature set 4 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
+/* iMac: temperature set 5 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1248,6 +1253,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		(void*)&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
+		(void*)&applesmc_dmi_data[5]},
 	{ .ident = NULL }
 };
 
_

Patches currently in -mm which might be from roberto@unbit.it are

origin.patch

