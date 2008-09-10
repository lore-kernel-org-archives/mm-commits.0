From: akpm@linux-foundation.org
Subject: + power_supply-fix-dependency-of-tosa_battery.patch added to -mm tree
Date: Wed, 10 Sep 2008 13:49:12 -0700
Message-ID: <200809102049.m8AKnCOW025442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYIJUtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 16:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com


The patch titled
     power_supply: fix dependency of tosa_battery
has been added to the -mm tree.  Its filename is
     power_supply-fix-dependency-of-tosa_battery.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
platform-add-new-device-registration-helper.patch
power_supply-fix-dependency-of-tosa_battery.patch
make-gpiochip-label-const.patch
gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

