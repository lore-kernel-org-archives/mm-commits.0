From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-macbook-pro-5.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:01 -0800
Message-ID: <200811102032.mAAKW1N6023730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047AbYKJUiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for Macbook Pro 5
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macbook-pro-5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for Macbook Pro 5
From: Henrik Rydberg <rydberg@euromail.se>

Add accelerometer, backlight and temperature sensor support for the new
unibody Macbook Pro 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-5 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-5
+++ a/drivers/hwmon/applesmc.c
@@ -121,6 +121,10 @@ static const char* temperature_sensors_s
 /* Set 11: Macbook 5,1 */
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0P", "TN0D", "TN0P",
 	  "TTF0", "Th0H", "Th1H", "ThFH", "Ts0P", "Ts0S", NULL },
+/* Set 12: Macbook Pro 5,1 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
+	  "TG0F", "TG0H", "TG0P", "TG0T", "TG1H", "TN0D", "TN0P", "TTF0",
+	  "Th2H", "Tm0P", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1285,6 +1289,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
 /* MacBook 5: accelerometer, backlight and temperature set 11 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
+/* MacBook Pro 5: accelerometer, backlight and temperature set 12 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1294,6 +1300,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },
+		&applesmc_dmi_data[12]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-macbook-4.patch
hid-add-support-for-the-new-unibody-macbooks.patch
hid-add-support-for-the-new-unibody-macbooks-fix.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-map-missing-keys-to-appropriate-functions.patch

