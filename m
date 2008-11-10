From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-imac-5.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:31:56 -0800
Message-ID: <200811102031.mAAKVuDZ023647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbYKJUci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, johnrcampbell@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for iMac 5
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-imac-5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for iMac 5
From: Henrik Rydberg <rydberg@euromail.se>

Add temperature sensor support for iMac 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Ricky Campbell <johnrcampbell@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-5 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-5
+++ a/drivers/hwmon/applesmc.c
@@ -116,6 +116,8 @@ static const char* temperature_sensors_s
 /* Set 9: Macbook Pro 3,1 (Santa Rosa) */
 	{ "TALP", "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P",
 	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
+/* Set 10: iMac 5,1 */
+	{ "TA0P", "TC0D", "TC0P", "TG0D", "TH0P", "TO0P", "Tm0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1276,6 +1278,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
 /* MacBook Pro 3: accelerometer, backlight and temperature set 9 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
+/* iMac 5: light sensor only, temperature set 10 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1317,6 +1321,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
+		&applesmc_dmi_data[10]},
 	{ applesmc_dmi_match, "Apple iMac", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-macbook-4.patch
hid-add-support-for-the-new-unibody-macbooks.patch
hid-add-support-for-the-new-unibody-macbooks-fix.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-map-missing-keys-to-appropriate-functions.patch

