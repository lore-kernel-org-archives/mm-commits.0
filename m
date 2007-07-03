From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-m41t80-driver-take-3.patch added to -mm tree
Date: Tue, 03 Jul 2007 10:42:32 -0700
Message-ID: <200707031742.l63HgXn6005556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411AbXGCRms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 13:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it


The patch titled
     rtc: add rtc-m41t80 driver (take 3)
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-m41t80-driver-take-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: add rtc-m41t80 driver (take 3)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

* Move a Kconfig entry into "I2C RTC drivers" section

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-m41t80-driver-take-3 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rtc-m41t80-driver-take-3
+++ a/drivers/rtc/Kconfig
@@ -212,6 +212,18 @@ config RTC_DRV_PCF8583
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8583.
 
+config RTC_DRV_M41T80
+	tristate "ST M41T80 series RTC"
+	depends on RTC_CLASS && I2C
+	help
+	  If you say Y here you will get support for the
+	  ST M41T80 RTC chips series. Currently following chips are
+	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
+	  and M41ST87.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41t80.
+
 comment "SPI RTC drivers"
 	depends on RTC_CLASS && SPI_MASTER
 
@@ -281,18 +293,6 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
-config RTC_DRV_M41T80
-	tristate "ST M41T80 series RTC"
-	depends on RTC_CLASS && I2C
-	help
-	  If you say Y here you will get support for the
-	  ST M41T80 RTC chips series. Currently following chips are
-	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
-	  and M41ST87.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-m41t80.
-
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
 	depends on RTC_CLASS
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-add-rtc-m41t80-driver-take-3.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
