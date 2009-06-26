From: akpm@linux-foundation.org
Subject: + rtc-reorder-makefile.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:07:57 -0700
Message-ID: <200906262307.n5QN7viQ028719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZFZXH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:07:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it


The patch titled
     rtc: reorder Makefile
has been added to the -mm tree.  Its filename is
     rtc-reorder-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: reorder Makefile
From: Alessandro Zummo <a.zummo@towertech.it>

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Makefile |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/Makefile~rtc-reorder-makefile drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-reorder-makefile
+++ a/drivers/rtc/Makefile
@@ -22,7 +22,9 @@ obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-a
 obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
 obj-$(CONFIG_RTC_DRV_AU1XXX)	+= rtc-au1xxx.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
+obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
+obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
 obj-$(CONFIG_RTC_DRV_DS1286)	+= rtc-ds1286.o
@@ -39,6 +41,7 @@ obj-$(CONFIG_RTC_DRV_DS3234)	+= rtc-ds32
 obj-$(CONFIG_RTC_DRV_EFI)	+= rtc-efi.o
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
+obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
 obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
@@ -46,9 +49,6 @@ obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
-obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
-obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v.o
-obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
@@ -57,9 +57,10 @@ obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PCF2123)	+= rtc-pcf2123.o
+obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
-obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
+obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
@@ -72,7 +73,10 @@ obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
+obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
+obj-$(CONFIG_RTC_DRV_STMP)	+= rtc-stmp3xxx.o
+obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
 obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl4030.o
 obj-$(CONFIG_RTC_DRV_TX4939)	+= rtc-tx4939.o
@@ -80,7 +84,3 @@ obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
-obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
-obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
-obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
-obj-$(CONFIG_RTC_DRV_STMP)	+= rtc-stmp3xxx.o
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-add-driver-for-mxcs-internal-rtc-module.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-u300-coh-901-331-rtc-driver-v3.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
bfin-delay-irq-registration-until-driver-is-ready.patch
rtc-add-freescale-stmp37xx-378x-driver.patch
rtc-philips-nxp-pcf2123-driver.patch
rtc-reorder-makefile.patch
rtc-driver-for-pcap2-pmic.patch

