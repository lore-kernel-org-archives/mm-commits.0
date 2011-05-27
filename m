From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:19 -0700
Message-ID: <201105271955.p4RJtONc017450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756980Ab1E0T4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, alessandro.zummo@towertech.it, vzapolskiy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-mxc.c: remove defines already included in rtc.h
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-mxc.c: remove defines already included in rtc.h
From: Wolfram Sang <w.sang@pengutronix.de>

[akpm@linux-foundation.org: retain the code comments]
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    6 ------
 include/linux/rtc.h   |    8 ++++----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch
+++ a/drivers/rtc/rtc-mxc.c
@@ -55,12 +55,6 @@ static const u32 PIE_BIT_DEF[MAX_PIE_NUM
 	{ MAX_PIE_FREQ,	RTC_SAM7_BIT },
 };
 
-/* Those are the bits from a classic RTC we want to mimic */
-#define RTC_IRQF	0x80	/* any of the following 3 is active */
-#define RTC_PF		0x40	/* Periodic interrupt */
-#define RTC_AF		0x20	/* Alarm interrupt */
-#define RTC_UF		0x10	/* Update interrupt for 1Hz RTC */
-
 #define MXC_RTC_TIME	0
 #define MXC_RTC_ALARM	1
 
diff -puN include/linux/rtc.h~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch include/linux/rtc.h
--- a/include/linux/rtc.h~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch
+++ a/include/linux/rtc.h
@@ -92,10 +92,10 @@ struct rtc_pll_info {
 #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
 
 /* interrupt flags */
-#define RTC_IRQF 0x80 /* any of the following is active */
-#define RTC_PF 0x40
-#define RTC_AF 0x20
-#define RTC_UF 0x10
+#define RTC_IRQF 0x80	/* Any of the following is active */
+#define RTC_PF 0x40	/* Periodic interrupt */
+#define RTC_AF 0x20	/* Alarm interrupt */
+#define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
rtc-driver-for-pt7c4338-chip.patch
gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch

