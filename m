From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:56 -0800
Message-ID: <20130107192657.1589D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:53133 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3AGT07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:59 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so669634lab.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@prisktech.co.nz, froese@gmx.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Prisk <linux@prisktech.co.nz>
Subject: drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield

Control register bitfield for 12H/24H mode is handled incorrectly. 
Setting CR_24H actually enables 12H mode.  This patch renames the define
and changes the initialization code to correctly set 24H mode.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Edgar Toernig <froese@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield
+++ a/drivers/rtc/rtc-vt8500.c
@@ -70,7 +70,7 @@
 				| ALARM_SEC_BIT)
 
 #define VT8500_RTC_CR_ENABLE	(1 << 0)	/* Enable RTC */
-#define VT8500_RTC_CR_24H	(1 << 1)	/* 24h time format */
+#define VT8500_RTC_CR_12H	(1 << 1)	/* 12h time format */
 #define VT8500_RTC_CR_SM_ENABLE	(1 << 2)	/* Enable periodic irqs */
 #define VT8500_RTC_CR_SM_SEC	(1 << 3)	/* 0: 1Hz/60, 1: 1Hz */
 #define VT8500_RTC_CR_CALIB	(1 << 4)	/* Enable calibration */
@@ -247,7 +247,7 @@ static int vt8500_rtc_probe(struct platf
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
-	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H,
+	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
 	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
_

Patches currently in -mm which might be from linux@prisktech.co.nz are

origin.patch
linux-next.patch

