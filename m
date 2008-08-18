From: akpm@linux-foundation.org
Subject: - applesmc-add-support-for-macbook-v3.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:50 -0700
Message-ID: <200808181939.m7IJdovd008369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764128AbYHRTky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guilherme.m.schroeder@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc: add support for Macbook
has been removed from the -mm tree.  Its filename was
     applesmc-add-support-for-macbook-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: applesmc: add support for Macbook
From: guilherme m. schroeder <guilherme.m.schroeder@gmail.com>

Add support for Macbook v3 (sensors and accelerometer).

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-add-support-for-macbook-v3 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-add-support-for-macbook-v3
+++ a/drivers/hwmon/applesmc.c
@@ -101,6 +101,9 @@ static const char* temperature_sensors_s
 /* Set 5: iMac */
 	{ "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P", "TO0P",
 	  "Tp0C", NULL },
+/* Set 6: Macbook3 set */
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TTF0", "TW0P", "Th0H",
+	  "Th0S", "Th1H", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1228,6 +1231,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 /* iMac: temperature set 5 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
+/* MacBook3: accelerometer and temperature set 6 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1237,10 +1242,14 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
 		(void*)&applesmc_dmi_data[0]},
-	{ applesmc_dmi_match, "Apple MacBook", {
+	{ applesmc_dmi_match, "Apple MacBook (v2)", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
 		(void*)&applesmc_dmi_data[1]},
+	{ applesmc_dmi_match, "Apple MacBook (v3)", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
+		(void*)&applesmc_dmi_data[6]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
_

Patches currently in -mm which might be from guilherme.m.schroeder@gmail.com are

origin.patch

