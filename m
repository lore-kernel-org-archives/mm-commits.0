From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-on-support-rtc-alarm.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:32 -0700
Message-ID: <201010112259.o9BMxWiw023162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0JKXAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaos.youn@samsung.com, a.zummo@towertech.it, ben-linux@fluff.org, kgene.kim@samsung.com, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: fix on support RTC Alarm
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-on-support-rtc-alarm.patch

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
Subject: rtc: rtc-s3c: fix on support RTC Alarm
From: Changhwan Youn <chaos.youn@samsung.com>

The alarm_irq_enable function should be implemented to support RTC alarm. 
And fix tabs instead of white space around the proc field.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-on-support-rtc-alarm drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-on-support-rtc-alarm
+++ a/drivers/rtc/rtc-s3c.c
@@ -379,7 +379,8 @@ static const struct rtc_class_ops s3c_rt
 	.set_alarm	= s3c_rtc_setalarm,
 	.irq_set_freq	= s3c_rtc_setfreq,
 	.irq_set_state	= s3c_rtc_setpie,
-	.proc	        = s3c_rtc_proc,
+	.proc		= s3c_rtc_proc,
+	.alarm_irq_enable = s3c_rtc_setaie,
 };
 
 static void s3c_rtc_enable(struct platform_device *pdev, int en)
_

Patches currently in -mm which might be from chaos.youn@samsung.com are

linux-next.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch
rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch
rtc-rtc-s3c-fix-on-support-rtc-alarm.patch
rtc-rtc-s3c-fix-rtc-initialization-method.patch

