From: akpm@linux-foundation.org
Subject: + applesmc-sensors-set-for-macbook2.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:33:45 -0800
Message-ID: <200711292033.lATKXjjl006138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760953AbXK2Ud4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rkoktarianto@gmail.com, mhoffman@lightlink.com, nicolas@boichat.ch


The patch titled
     applesmc: sensors set for MacBook2
has been added to the -mm tree.  Its filename is
     applesmc-sensors-set-for-macbook2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: applesmc: sensors set for MacBook2
From: Riki Oktarianto <rkoktarianto@gmail.com>

On my mid-2007 MacBook2, reading Ts0P sensor always failed with this message:
applesmc: wait status failed: 5 != 50.

So I assume that there's no such Ts0p sensor in this model (please confirm,
anyone). If there's the case, then we need a new set of sensors defined for
MacBook2.

Signed-off-by: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-sensors-set-for-macbook2 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-sensors-set-for-macbook2
+++ a/drivers/hwmon/applesmc.c
@@ -84,12 +84,15 @@ static const char* temperature_sensors_s
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
-/* Set 1: Macbook set */
+/* Set 1: Macbook2 set */
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
+	  "Th1H", NULL },
+/* Set 2: Macbook set */
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
 	  "Th1H", "Ts0P", NULL },
-/* Set 2: Macmini set */
+/* Set 3: Macmini set */
 	{ "TC0D", "TC0P", NULL },
-/* Set 3: Mac Pro (2 x Quad-Core) */
+/* Set 4: Mac Pro (2 x Quad-Core) */
 	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
 	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "THTG", "TH0P",
 	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
@@ -1212,12 +1215,14 @@ static void applesmc_release_acceleromet
 static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 /* MacBook Pro: accelerometer, backlight and temperature set 0 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 0 },
-/* MacBook: accelerometer and temperature set 1 */
+/* MacBook2: accelerometer and temperature set 1 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 1 },
-/* MacMini: temperature set 2 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 2 },
-/* MacPro: temperature set 3 */
+/* MacBook: accelerometer and temperature set 2 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 2 },
+/* MacMini: temperature set 3 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 3 },
+/* MacPro: temperature set 4 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1229,16 +1234,20 @@ static __initdata struct dmi_system_id a
 		(void*)&applesmc_dmi_data[0]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
 		(void*)&applesmc_dmi_data[1]},
+	{ applesmc_dmi_match, "Apple MacBook", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+		(void*)&applesmc_dmi_data[2]},
 	{ applesmc_dmi_match, "Apple Macmini", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
-		(void*)&applesmc_dmi_data[2]},
+		(void*)&applesmc_dmi_data[3]},
 	{ applesmc_dmi_match, "Apple MacPro2", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
-		(void*)&applesmc_dmi_data[3]},
+		(void*)&applesmc_dmi_data[4]},
 	{ .ident = NULL }
 };
 
_

Patches currently in -mm which might be from rkoktarianto@gmail.com are

applesmc-sensors-set-for-macbook2.patch
