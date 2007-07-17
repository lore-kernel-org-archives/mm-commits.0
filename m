From: akpm@linux-foundation.org
Subject: - rtc-kconfig-tweax.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:41 -0700
Message-ID: <200707172305.l6HN5fVJ011942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852AbXGQXPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     RTC Kconfig tweax
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-tweax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC Kconfig tweax
From: David Brownell <david-b@pacbell.net>

Minor fix to the Kconfig for RTCs: don't display section headers for I2C or
SPI unless they're configured.  And depend on SPI_MASTER; having slave
support wouldn't help.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-tweax drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-tweax
+++ a/drivers/rtc/Kconfig
@@ -118,7 +118,7 @@ config RTC_DRV_TEST
 	  will be called rtc-test.
 
 comment "I2C RTC drivers"
-	depends on RTC_CLASS
+	depends on RTC_CLASS && I2C
 
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
@@ -213,11 +213,11 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 comment "SPI RTC drivers"
-	depends on RTC_CLASS
+	depends on RTC_CLASS && SPI_MASTER
 
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
-	depends on RTC_CLASS && SPI
+	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C348A and RS5C348B RTC chips.
@@ -227,7 +227,7 @@ config RTC_DRV_RS5C348
 
 config RTC_DRV_MAX6902
 	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI
+	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6902 SPI RTC chip.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
