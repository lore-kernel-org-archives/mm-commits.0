From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-macbook-air.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:13 -0700
Message-ID: <200810202035.m9KKZDgH011102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbYJTUgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for Macbook Air
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macbook-air.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for Macbook Air
From: Henrik Rydberg <rydberg@euromail.se>

This patch adds accelerometer, backlight and temperature sensor support
for the Macbook Air.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-air drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-air
+++ a/drivers/hwmon/applesmc.c
@@ -104,6 +104,9 @@ static const char* temperature_sensors_s
 /* Set 6: Macbook3 set */
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TTF0", "TW0P", "Th0H",
 	  "Th0S", "Th1H", NULL },
+/* Set 7: Macbook Air */
+	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TC0P", "TCFP",
+	  "TTF0", "TW0P", "Th0H", "Tp0P", "TpFP", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1259,11 +1262,17 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
 /* MacBook3: accelerometer and temperature set 6 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
+/* MacBook Air: accelerometer, backlight and temperature set 7 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
+		(void*)&applesmc_dmi_data[7]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

