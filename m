From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-add-support-for-imac-8.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:21:31 -0700
Message-ID: <200810282121.m9SLLVM5004970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbYJ1VWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, klaus.doblmann@gmail.com


The patch titled
     hwmon: applesmc: add support for iMac 8
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-add-support-for-imac-8.patch

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

input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-add-support-for-imac-5.patch
hwmon-applesmc-add-support-for-macbook-5.patch
hwmon-applesmc-add-support-for-macbook-pro-5.patch
hwmon-applesmc-add-support-for-imac-8.patch

