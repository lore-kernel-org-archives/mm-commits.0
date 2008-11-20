From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-imac-6.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:02 -0800
Message-ID: <200811202042.mAKKg3je006726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYKTUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:42:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, caleb.hyde@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: Add support for iMac 6
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-imac-6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: Add support for iMac 6
From: Henrik Rydberg <rydberg@euromail.se>

Add temperature sensor support for iMac 6.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Caleb Hyde <caleb.hyde@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-6 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-6
+++ a/drivers/hwmon/applesmc.c
@@ -128,6 +128,9 @@ static const char* temperature_sensors_s
 /* Set 13: iMac 8,1 */
 	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
 	  "TL0P", "TO0P", "TW0P", "Tm0P", "Tp0P", NULL },
+/* Set 14: iMac 6,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
+	  "TO0P", "Tp0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1296,6 +1299,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
 /* iMac 8: light sensor only, temperature set 13 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
+/* iMac 6: light sensor only, temperature set 14 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1353,6 +1358,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
 		&applesmc_dmi_data[13]},
+	{ applesmc_dmi_match, "Apple iMac 6", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac6") },
+		&applesmc_dmi_data[14]},
 	{ applesmc_dmi_match, "Apple iMac 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

