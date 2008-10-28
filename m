From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-add-support-for-macbook-pro-5.patch added to -mm tree
Date: Mon, 27 Oct 2008 17:43:04 -0700
Message-ID: <200810280043.m9S0h4SK005312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbYJ1AnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se


The patch titled
     hwmon: applesmc: Add support for Macbook Pro 5
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-add-support-for-macbook-pro-5.patch

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
Subject: hwmon: applesmc: Add support for Macbook Pro 5
From: Henrik Rydberg <rydberg@euromail.se>

tAdd adds accelerometer, backlight and temperature sensor support for the
new unibody Macbook Pro 5.

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

input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-add-support-for-imac-5.patch
hwmon-applesmc-add-support-for-macbook-5.patch
hwmon-applesmc-add-support-for-macbook-pro-5.patch

