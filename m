From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue.patch added to -mm tree
Date: Wed, 24 Sep 2014 15:47:37 -0700
Message-ID: <54234a09.U2qxcHSLLha8BfTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXWri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/Kconfig: Let several drivers depend on HAS_IOMEM to avoid compiling issue
has been added to the -mm tree.  Its filename is
     drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: drivers/rtc/Kconfig: Let several drivers depend on HAS_IOMEM to avoid compiling issue

Some drivers need 'devm_ioremap_resource' or 'devm_ioremap' which need
HAS_IOMEM, so let them depend on it.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-xgene.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-stk17ta8.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1742.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1553.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1511.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1286.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-rp5c01.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-msm6242.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t59.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t35.ko] undefined!
  ERROR: "devm_ioremap" [drivers/rtc/rtc-bq4802.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue
+++ a/drivers/rtc/Kconfig
@@ -752,6 +752,7 @@ config RTC_DRV_DS1216
 
 config RTC_DRV_DS1286
 	tristate "Dallas DS1286"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Dallas DS1286 RTC chips.
 
@@ -763,6 +764,7 @@ config RTC_DRV_DS1302
 
 config RTC_DRV_DS1511
 	tristate "Dallas DS1511"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1511 timekeeping/watchdog chip.
@@ -772,6 +774,7 @@ config RTC_DRV_DS1511
 
 config RTC_DRV_DS1553
 	tristate "Maxim/Dallas DS1553"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Maxim/Dallas DS1553 timekeeping chip.
@@ -781,6 +784,7 @@ config RTC_DRV_DS1553
 
 config RTC_DRV_DS1742
 	tristate "Maxim/Dallas DS1742/1743"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Maxim/Dallas DS1742/1743 timekeeping chip.
@@ -836,6 +840,7 @@ config RTC_DRV_EFI
 
 config RTC_DRV_STK17TA8
 	tristate "Simtek STK17TA8"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the
 	  Simtek STK17TA8 timekeeping chip.
@@ -854,6 +859,7 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T35
 	tristate "ST M48T35"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the
 	  ST M48T35 RTC chip.
@@ -863,6 +869,7 @@ config RTC_DRV_M48T35
 
 config RTC_DRV_M48T59
 	tristate "ST M48T59/M48T08/M48T02"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the
 	  ST M48T59 RTC chip and compatible ST M48T08 and M48T02.
@@ -875,6 +882,7 @@ config RTC_DRV_M48T59
 
 config RTC_DRV_MSM6242
 	tristate "Oki MSM6242"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Oki MSM6242
 	  timekeeping chip. It is used in some Amiga models (e.g. A2000).
@@ -884,6 +892,7 @@ config RTC_DRV_MSM6242
 
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
+	depends on HAS_IOMEM
 	help
 	  If you say Y here you will get support for the TI
 	  BQ4802 RTC chip.
@@ -893,6 +902,7 @@ config RTC_DRV_BQ4802
 
 config RTC_DRV_RP5C01
 	tristate "Ricoh RP5C01"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the Ricoh RP5C01
 	  timekeeping chip. It is used in some Amiga models (e.g. A3000
@@ -1387,6 +1397,7 @@ config RTC_DRV_MOXART
 
 config RTC_DRV_XGENE
 	tristate "APM X-Gene RTC"
+	depends on HAS_IOMEM
 	help
 	  If you say yes here you get support for the APM X-Gene SoC real time
 	  clock.
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

drivers-rtc-kconfig-let-several-drivers-depend-on-has_iomem-to-avoid-compiling-issue.patch
linux-next.patch

