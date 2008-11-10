From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-imac-8.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:03 -0800
Message-ID: <200811102032.mAAKW39V023738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYKJUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, klaus.doblmann@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for iMac 8
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-imac-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for iMac 8
From: Henrik Rydberg <rydberg@euromail.se>

Add temperature sensor support for iMac 8.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Klaus Doblmann <klaus.doblmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-8 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-imac-8
+++ a/drivers/hwmon/applesmc.c
@@ -125,6 +125,9 @@ static const char* temperature_sensors_s
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
 	  "TG0F", "TG0H", "TG0P", "TG0T", "TG1H", "TN0D", "TN0P", "TTF0",
 	  "Th2H", "Tm0P", "Ts0P", "Ts0S", NULL },
+/* Set 13: iMac 8,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
+	  "TL0P", "TO0P", "TW0P", "Tm0P", "Tp0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1291,6 +1294,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
 /* MacBook Pro 5: accelerometer, backlight and temperature set 12 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
+/* iMac 8: light sensor only, temperature set 13 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1340,6 +1345,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 8", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
+		&applesmc_dmi_data[13]},
 	{ applesmc_dmi_match, "Apple iMac 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-macbook-4.patch
hid-add-support-for-the-new-unibody-macbooks.patch
hid-add-support-for-the-new-unibody-macbooks-fix.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-map-missing-keys-to-appropriate-functions.patch

