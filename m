From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-macbook-pro-3.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:19 -0700
Message-ID: <200810202035.m9KKZJef011123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422AbYJTUrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: Add support for Macbook Pro 3
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macbook-pro-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: Add support for Macbook Pro 3
From: Henrik Rydberg <rydberg@euromail.se>

Add temperature sensor support for Macbook Pro 3.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-3 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-3
+++ a/drivers/hwmon/applesmc.c
@@ -110,6 +110,9 @@ static const char* temperature_sensors_s
 /* Set 8: Macbook Pro 4,1 (Penryn) */
 	{ "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P", "Th0H",
 	  "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
+/* Set 9: Macbook Pro 3,1 (Santa Rosa) */
+	{ "TALP", "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P",
+	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1269,6 +1272,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
 /* MacBook Pro 4: accelerometer, backlight and temperature set 8 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
+/* MacBook Pro 3: accelerometer, backlight and temperature set 9 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1282,6 +1287,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
 		&applesmc_dmi_data[8]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
+		&applesmc_dmi_data[9]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

