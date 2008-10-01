From: akpm@linux-foundation.org
Subject: - power_supply-fix-dependency-of-tosa_battery.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:29 -0700
Message-ID: <200810012152.m91LqTdQ006057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYJAVwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     power_supply: fix dependency of tosa_battery
has been removed from the -mm tree.  Its filename was
     power_supply-fix-dependency-of-tosa_battery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power_supply: fix dependency of tosa_battery
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

tosa_battery should also depend on wm97xx_ts as it uses dac-accessing
functions from that module.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/Kconfig~power_supply-fix-dependency-of-tosa_battery drivers/power/Kconfig
--- a/drivers/power/Kconfig~power_supply-fix-dependency-of-tosa_battery
+++ a/drivers/power/Kconfig
@@ -51,7 +51,7 @@ config BATTERY_OLPC
 
 config BATTERY_TOSA
 	tristate "Sharp SL-6000 (tosa) battery"
-	depends on MACH_TOSA && MFD_TC6393XB
+	depends on MACH_TOSA && MFD_TC6393XB && TOUCHSCREEN_WM97XX
 	help
 	  Say Y to enable support for the battery on the Sharp Zaurus
 	  SL-6000 (tosa) models.
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

git-arm.patch
git-sound.patch
git-mmc.patch
git-battery.patch
git-mfd.patch
platform-add-new-device-registration-helper.patch
make-gpiochip-label-const.patch
gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

