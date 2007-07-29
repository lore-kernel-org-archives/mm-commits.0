From: akpm@linux-foundation.org
Subject: - reorder-rtc-makefile.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:55 -0700
Message-ID: <200707290611.l6T6Btnx011016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758038AbXG2GXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.zummo@towertech.it, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Reorder RTC Makefile
has been removed from the -mm tree.  Its filename was
     reorder-rtc-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Reorder RTC Makefile
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Alphabetic reordering of the drivers in the rtc subsys makefile.

(akpm: merge this asap!  Makefiles are the source of many patch conflicts..)

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Makefile |   42 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/Makefile~reorder-rtc-makefile drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~reorder-rtc-makefile
+++ a/drivers/rtc/Makefile
@@ -15,34 +15,36 @@ rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-d
 rtc-core-$(CONFIG_RTC_INTF_PROC) += rtc-proc.o
 rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
 
+# Keep the list ordered.
+
+obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
+obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
+obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
-obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
-obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
-obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
-obj-$(CONFIG_RTC_DRV_AT32AP700X)	+= rtc-at32ap700x.o
+obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
+obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
+obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
+obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
+obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
+obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
+obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
+obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
+obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
+obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
+obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
+obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
-obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
-obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
-obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
-obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
-obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
-obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
-obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
-obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
-obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
-obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
-obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
-obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
-obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
-obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
-obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
-obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
+obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
+obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
+obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
+obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
+obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch
