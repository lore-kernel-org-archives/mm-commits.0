From: akpm@linux-foundation.org
Subject: [merged] rtc-add-ioctl-to-get-clear-battery-low-voltage-status.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:22 -0700
Message-ID: <20120531192022.60E92A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46086 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab2EaTUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:23 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76227wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.stein@systec-electronic.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add ioctl to get/clear battery low voltage status
has been removed from the -mm tree.  Its filename was
     rtc-add-ioctl-to-get-clear-battery-low-voltage-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: rtc: add ioctl to get/clear battery low voltage status

Currently there is no generic way to get the RTC battery status within an
application.  So add an ioctl to read the status bit.  The idea is that
the bit is set once a low voltage is detected.  It stays there until it is
reset using the RTC_VL_CLR ioctl.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rtc.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/rtc.h~rtc-add-ioctl-to-get-clear-battery-low-voltage-status include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-ioctl-to-get-clear-battery-low-voltage-status
+++ a/include/linux/rtc.h
@@ -91,6 +91,9 @@ struct rtc_pll_info {
 #define RTC_PLL_GET	_IOR('p', 0x11, struct rtc_pll_info)  /* Get PLL correction */
 #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
 
+#define RTC_VL_READ	_IOR('p', 0x13, int)	/* Voltage low detector */
+#define RTC_VL_CLR	_IO('p', 0x14)		/* Clear voltage low information */
+
 /* interrupt flags */
 #define RTC_IRQF 0x80	/* Any of the following is active */
 #define RTC_PF 0x40	/* Periodic interrupt */
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

origin.patch
linux-next.patch

