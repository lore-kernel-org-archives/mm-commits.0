From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-add-support-for-macbook-5.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:44:22 -0700
Message-ID: <200810270644.m9R6iMj1027313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbYJ0Go2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dmlary@gmail.com


The patch titled
     hwmon: applesmc: add support for Macbook 5
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-add-support-for-macbook-5.patch

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
Subject: hwmon: applesmc: add support for Macbook 5
From: Henrik Rydberg <rydberg@euromail.se>

Add accelerometer, backlight and temperature sensor support for the new
unibody Macbook 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: David M. Lary <dmlary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-5 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-5
+++ a/drivers/hwmon/applesmc.c
@@ -118,6 +118,9 @@ static const char* temperature_sensors_s
 	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 /* Set 10: iMac 5,1 */
 	{ "TA0P", "TC0D", "TC0P", "TG0D", "TH0P", "TO0P", "Tm0P", NULL },
+/* Set 11: Macbook 5,1 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0P", "TN0D", "TN0P",
+	  "TTF0", "Th0H", "Th1H", "ThFH", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1280,6 +1283,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
 /* iMac 5: light sensor only, temperature set 10 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
+/* MacBook 5: accelerometer, backlight and temperature set 11 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1309,6 +1314,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
 		&applesmc_dmi_data[6]},
+	{ applesmc_dmi_match, "Apple MacBook 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5") },
+		&applesmc_dmi_data[11]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-add-support-for-imac-5.patch
hwmon-applesmc-add-support-for-macbook-5.patch

