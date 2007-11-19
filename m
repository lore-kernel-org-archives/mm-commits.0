From: akpm@linux-foundation.org
Subject: - hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:15:47 -0800
Message-ID: <200711192315.lAJNFlZw001713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbXKSXQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: replace power-of-two test in drivers/hwmon/adt7470.c
has been removed from the -mm tree.  Its filename was
     hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hwmon: replace power-of-two test in drivers/hwmon/adt7470.c
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since <linux/log2.h> already supplies a power-of-two test, there's no point
in having this source file redefine it again.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7470.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/hwmon/adt7470.c~hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c
+++ a/drivers/hwmon/adt7470.c
@@ -114,8 +114,6 @@ I2C_CLIENT_INSMOD_1(adt7470);
 /* sleep 1s while gathering temperature data */
 #define TEMP_COLLECTION_TIME	1000
 
-#define power_of_2(x)	(((x) & ((x) - 1)) == 0)
-
 /* datasheet says to divide this number by the fan reading to get fan rpm */
 #define FAN_PERIOD_TO_RPM(x)	((90000 * 60) / (x))
 #define FAN_RPM_TO_PERIOD	FAN_PERIOD_TO_RPM
@@ -677,7 +675,7 @@ static int cvt_auto_temp(int input)
 {
 	if (input == ADT7470_PWM_ALL_TEMPS)
 		return 0;
-	if (input < 1 || !power_of_2(input))
+	if (input < 1 || !is_power_of_2(input))
 		return -EINVAL;
 	return ilog2(input) + 1;
 }
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
