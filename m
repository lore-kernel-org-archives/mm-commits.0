From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-macbook-air-2.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:24 -0800
Message-ID: <200901072217.n07MHO8o017039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190AbZAGWhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: Add support for MacBook Air 2
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macbook-air-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: Add support for MacBook Air 2
From: Henrik Rydberg <rydberg@euromail.se>

Add temperature sensor support for MacBook Air 2.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-air-2 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-air-2
+++ a/drivers/hwmon/applesmc.c
@@ -131,6 +131,10 @@ static const char* temperature_sensors_s
 /* Set 14: iMac 6,1 */
 	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
 	  "TO0P", "Tp0P", NULL },
+/* Set 15: MacBook Air 2,1 */
+	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TN0D", "TTF0",
+	  "TV0P", "TVFP", "TW0P", "Th0P", "Tp0P", "Tp1P", "TpFP", "Ts0P",
+	  "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1301,11 +1305,17 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
 /* iMac 6: light sensor only, temperature set 14 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
+/* MacBook Air 2,1: accelerometer, backlight and temperature set 15 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air 2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2") },
+		&applesmc_dmi_data[15]},
 	{ applesmc_dmi_match, "Apple MacBook Air", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch
video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation.patch

