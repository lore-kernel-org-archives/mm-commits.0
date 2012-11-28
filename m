From: akpm@linux-foundation.org
Subject: + rtc-remove-unused-code-from-rtc-devc.patch added to -mm tree
Date: Wed, 28 Nov 2012 14:39:44 -0800
Message-ID: <20121128223945.0B3E620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64946 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422634Ab2K1Wjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 17:39:47 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so839419bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 14:39:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-dev.c: remove unused code from rtc-dev.c
has been added to the -mm tree.  Its filename is
     rtc-remove-unused-code-from-rtc-devc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-dev.c: remove unused code from rtc-dev.c

This code is under #if 0 and not used.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-remove-unused-code-from-rtc-devc drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-unused-code-from-rtc-devc
+++ a/drivers/rtc/rtc-dev.c
@@ -379,25 +379,6 @@ static long rtc_dev_ioctl(struct file *f
 		err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
 		break;
 
-#if 0
-	case RTC_EPOCH_SET:
-#ifndef rtc_epoch
-		/*
-		 * There were no RTC clocks before 1900.
-		 */
-		if (arg < 1900) {
-			err = -EINVAL;
-			break;
-		}
-		rtc_epoch = arg;
-		err = 0;
-#endif
-		break;
