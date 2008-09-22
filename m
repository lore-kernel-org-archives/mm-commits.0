From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-add-support-for-macbook-pro-4.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:31:42 -0700
Message-ID: <200809222331.m8MNVgEP003882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbYIVXch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com


The patch titled
     hwmon: applesmc: Add support for Macbook Pro 4
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-add-support-for-macbook-pro-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: Add support for Macbook Pro 4
From: Henrik Rydberg <rydberg@euromail.se>

Adds temperature sensor support for the Macbook Pro 4.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-4 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-pro-4
+++ a/drivers/hwmon/applesmc.c
@@ -107,6 +107,9 @@ static const char* temperature_sensors_s
 /* Set 7: Macbook Air */
 	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TC0P", "TCFP",
 	  "TTF0", "TW0P", "Th0H", "Tp0P", "TpFP", "Ts0P", "Ts0S", NULL },
+/* Set 8: Macbook Pro 4,1 (Penryn) */
+	{ "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P", "Th0H",
+	  "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1264,6 +1267,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 /* MacBook Air: accelerometer, backlight and temperature set 7 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
+/* MacBook Pro 4: accelerometer, backlight and temperature set 8 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1273,6 +1278,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
+		&applesmc_dmi_data[8]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch
hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch
hwmon-applesmc-prolong-status-wait.patch
hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch
hwmon-applesmc-add-support-for-macbook-air.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
hwmon-applesmc-add-support-for-macbook-pro-4.patch

