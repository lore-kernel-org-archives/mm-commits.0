From: akpm@linux-foundation.org
Subject: - applesmc-add-temperature-sensors-set-for-macbook.patch removed from -mm tree
Date: Mon, 30 Jul 2007 11:51:25 -0700
Message-ID: <200707301851.l6UIpPj1024902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965330AbXG3SwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 14:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mactel@sukimashita.com, dtor@mail.ru, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc: add temperature sensors set for Macbook
has been removed from the -mm tree.  Its filename was
     applesmc-add-temperature-sensors-set-for-macbook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: applesmc: add temperature sensors set for Macbook
From: Martin Szulecki <mactel@sukimashita.com>

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Martin Szulecki <mactel@sukimashita.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-add-temperature-sensors-set-for-macbook drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-add-temperature-sensors-set-for-macbook
+++ a/drivers/hwmon/applesmc.c
@@ -79,11 +79,15 @@
 
 /*
  * Temperature sensors keys (sp78 - 2 bytes).
- * First set for Macbook(Pro), second for Macmini.
  */
 static const char* temperature_sensors_sets[][13] = {
+/* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
+/* Set 1: Macbook set */
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
+	  "Th1H", "Ts0P", NULL },
+/* Set 2: Macmini set */
 	{ "TC0D", "TC0P", NULL }
 };
 
@@ -1129,10 +1133,10 @@ static void applesmc_release_acceleromet
 static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 /* MacBook Pro: accelerometer, backlight and temperature set 0 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 0 },
-/* MacBook: accelerometer and temperature set 0 */
-	{ .accelerometer = 1, .light = 0, .temperature_set = 0 },
-/* MacBook: temperature set 1 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 1 }
+/* MacBook: accelerometer and temperature set 1 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 1 },
+/* MacMini: temperature set 2 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 2 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
_

Patches currently in -mm which might be from mactel@sukimashita.com are

git-hwmon.patch
