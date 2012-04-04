From: akpm@linux-foundation.org
Subject: + rtc-add-ioctl-to-get-clear-battery-low-voltage-status.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:27:54 -0700
Message-ID: <20120404222755.486B0A03A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40637 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DDW15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:27:57 -0400
Received: by wibhj13 with SMTP id hj13so42861wib.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:27:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.stein@systec-electronic.com, a.zummo@towertech.it


The patch titled
     Subject: rtc: add ioctl to get/clear battery low voltage status
has been added to the -mm tree.  Its filename is
     rtc-add-ioctl-to-get-clear-battery-low-voltage-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc: add ioctl to get/clear battery low voltage status

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

rtc-add-ioctl-to-get-clear-battery-low-voltage-status.patch
rtc-pcf8563-add-rtc_vl_read-rtc_vl_clr-ioctl-feature.patch

