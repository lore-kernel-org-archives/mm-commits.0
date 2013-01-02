From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield.patch added to -mm tree
Date: Wed, 02 Jan 2013 14:44:18 -0800
Message-ID: <20130102224419.75C2120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:63133 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3ABWoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:44:21 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so909481wey.4
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:44:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@prisktech.co.nz, froese@gmx.de, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -247,7 +247,7 @@ static int __devinit vt8500_rtc_probe(st
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
-	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H,
+	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
 	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
_

Patches currently in -mm which might be from linux@prisktech.co.nz are

maintainers-fix-drivers-rtc-rtc-vt8500c.patch
drivers-rtc-rtc-vt8500c-correct-handling-of-cr_24h-bitfield.patch
drivers-rtc-rtc-vt8500c-fix-handling-of-data-passed-in-struct-rtc_time.patch
linux-next.patch

