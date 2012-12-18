From: akpm@linux-foundation.org
Subject: [merged] rtc-remove-unused-code-from-rtc-devc.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:24 -0800
Message-ID: <20121218200824.A792982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44798 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:25 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so125874qcq.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-dev.c: remove unused code from rtc-dev.c
has been removed from the -mm tree.  Its filename was
     rtc-remove-unused-code-from-rtc-devc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
