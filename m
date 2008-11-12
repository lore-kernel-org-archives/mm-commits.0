From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-add-support-for-imac-6.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:55:22 -0800
Message-ID: <200811122255.mACMtM4m006261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbYKLWzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:55:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, caleb.hyde@gmail.com


The patch titled
     hwmon: applesmc: Add support for iMac 6
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-add-support-for-imac-6.patch

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

hwmon-applesmc-add-support-for-macbook-4.patch
hwmon-applesmc-add-support-for-imac-6.patch
linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

