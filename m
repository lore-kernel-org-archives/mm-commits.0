From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:11 -0700
Message-ID: <200810202035.m9KKZBkj011097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbYJTUrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: allow for variable ALV0 and ALV1 package length
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: allow for variable ALV0 and ALV1 package length
From: Henrik Rydberg <rydberg@euromail.se>

On some recent Macbooks, the package length for the light sensors ALV0 and
ALV1 has changed from 6 to 10.  This patch allows for a variable package
length encompassing both variants.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length
+++ a/drivers/hwmon/applesmc.c
@@ -57,8 +57,8 @@
 
 #define KEY_COUNT_KEY		"#KEY" /* r-o ui32 */
 
-#define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6 bytes) */
-#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6 bytes) */
+#define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6-10 bytes) */
+#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6-10 bytes) */
 #define BACKLIGHT_KEY		"LKSB" /* w-o {lkb (2 bytes) */
 
 #define CLAMSHELL_KEY		"MSLD" /* r-o ui8 (unused) */
@@ -543,17 +543,27 @@ out:
 static ssize_t applesmc_light_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
+	static int data_length;
 	int ret;
 	u8 left = 0, right = 0;
-	u8 buffer[6];
+	u8 buffer[10], query[6];
 
 	mutex_lock(&applesmc_lock);
 
-	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, 6);
+	if (!data_length) {
+		ret = applesmc_get_key_type(LIGHT_SENSOR_LEFT_KEY, query);
+		if (ret)
+			goto out;
+		data_length = clamp_val(query[0], 0, 10);
+		printk(KERN_INFO "applesmc: light sensor data length set to "
+			"%d\n", data_length);
+	}
+
+	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, data_length);
 	left = buffer[2];
 	if (ret)
 		goto out;
-	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, 6);
+	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, data_length);
 	right = buffer[2];
 
 out:
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

