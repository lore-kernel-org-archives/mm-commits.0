From: akpm@linux-foundation.org
Subject: + cosmetic-fixes-to-rtc-subsystems-kconfig.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:32:57 -0700
Message-ID: <200710240632.l9O6Wvkg026537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbXJXGdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     Cosmetic fixes to RTC subsystem's Kconfig
has been added to the -mm tree.  Its filename is
     cosmetic-fixes-to-rtc-subsystems-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cosmetic fixes to RTC subsystem's Kconfig
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Add adds a warning if a potentially conflicting RTC option has been
selected and makes some other cosmetic fixes to the Kconfig.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   56 ++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/Kconfig~cosmetic-fixes-to-rtc-subsystems-kconfig drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~cosmetic-fixes-to-rtc-subsystems-kconfig
+++ a/drivers/rtc/Kconfig
@@ -20,6 +20,10 @@ menuconfig RTC_CLASS
 
 if RTC_CLASS
 
+if GEN_RTC || RTC
+comment "Conflicting RTC option has been selected, check GEN_RTC and RTC"
+endif
+
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
@@ -47,7 +51,7 @@ config RTC_HCTOSYS_DEVICE
 
 	  If the clock you specify here is not battery backed, it may still
 	  be useful to reinitialize system time when resuming from system
-	  sleep states.  Do not specify an RTC here unless it stays powered
+	  sleep states. Do not specify an RTC here unless it stays powered
 	  during all this system's supported sleep states.
 
 config RTC_DEBUG
@@ -140,7 +144,7 @@ config RTC_DRV_DS1307
 	  will be called rtc-ds1307.
 
 config RTC_DRV_DS1374
-	tristate "Maxim/Dallas Semiconductor DS1374 Real Time Clock"
+	tristate "Dallas/Maxim DS1374"
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
@@ -160,7 +164,7 @@ config RTC_DRV_DS1672
 	  will be called rtc-ds1672.
 
 config RTC_DRV_MAX6900
-	tristate "Maxim 6900"
+	tristate "Maxim MAX6900"
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6900 I2C RTC chip.
@@ -178,10 +182,10 @@ config RTC_DRV_RS5C372
 	  will be called rtc-rs5c372.
 
 config RTC_DRV_ISL1208
-	tristate "Intersil 1208"
+	tristate "Intersil ISL1208"
 	help
 	  If you say yes here you get support for the
-	  Intersil 1208 RTC chip.
+	  Intersil ISL1208 RTC chip.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-isl1208.
@@ -218,7 +222,7 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T80 series RTC"
+	tristate "ST M41T80/81/82/83/84/85/87"
 	help
 	  If you say Y here you will get support for the
 	  ST M41T80 RTC chips series. Currently following chips are
@@ -250,6 +254,15 @@ comment "SPI RTC drivers"
 
 if SPI_MASTER
 
+config RTC_DRV_MAX6902
+	tristate "Maxim MAX6902"
+	help
+	  If you say yes here you will get support for the
+	  Maxim MAX6902 SPI RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max6902.
+
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
 	help
@@ -259,15 +272,6 @@ config RTC_DRV_RS5C348
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-rs5c348.
 
-config RTC_DRV_MAX6902
-	tristate "Maxim 6902"
-	help
-	  If you say yes here you will get support for the
-	  Maxim MAX6902 SPI RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-max6902.
-
 endif # SPI_MASTER
 
 comment "Platform RTC drivers"
@@ -301,32 +305,32 @@ config RTC_DRV_DS1216
 	  If you say yes here you get support for the Dallas DS1216 RTC chips.
 
 config RTC_DRV_DS1553
-	tristate "Dallas DS1553"
+	tristate "Maxim/Dallas DS1553"
 	help
 	  If you say yes here you get support for the
-	  Dallas DS1553 timekeeping chip.
+	  Maxim/Dallas DS1553 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1553.
 
-config RTC_DRV_STK17TA8
-	tristate "Simtek STK17TA8"
-	depends on RTC_CLASS
+config RTC_DRV_DS1742
+	tristate "Maxim/Dallas DS1742/1743"
 	help
 	  If you say yes here you get support for the
-	  Simtek STK17TA8 timekeeping chip.
+	  Maxim/Dallas DS1742/1743 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-stk17ta8.
+	  will be called rtc-ds1742.
 
-config RTC_DRV_DS1742
-	tristate "Dallas DS1742/1743"
+config RTC_DRV_STK17TA8
+	tristate "Simtek STK17TA8"
+	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
-	  Dallas DS1742/1743 timekeeping chip.
+	  Simtek STK17TA8 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds1742.
+	  will be called rtc-stk17ta8.
 
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
