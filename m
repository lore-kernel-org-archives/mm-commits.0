From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-add-support-for-macbook-4.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:27 -0800
Message-ID: <200811132126.mADLQRKx027342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYKMV1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for Macbook 4
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macbook-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for Macbook 4
From: Henrik Rydberg <rydberg@euromail.se>

This patch adds accelerometer and temperature sensor support for Macbook 4.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-4 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macbook-4
+++ a/drivers/hwmon/applesmc.c
@@ -1280,7 +1280,7 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 /* iMac: temperature set 5 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
-/* MacBook3: accelerometer and temperature set 6 */
+/* MacBook3, MacBook4: accelerometer and temperature set 6 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 /* MacBook Air: accelerometer, backlight and temperature set 7 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
@@ -1329,6 +1329,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
 		&applesmc_dmi_data[6]},
+	{ applesmc_dmi_match, "Apple MacBook 4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4") },
+		&applesmc_dmi_data[6]},
 	{ applesmc_dmi_match, "Apple MacBook 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
hwmon-applesmc-add-support-for-imac-6.patch
linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

