From: akpm@linux-foundation.org
Subject: - rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:34 -0700
Message-ID: <200707172305.l6HN5YoY011932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936461AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     rtc-dev: return -ENOTTY in ioctl if irq_set_freq is not implemented by driver
has been removed from the -mm tree.  Its filename was
     rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-dev: return -ENOTTY in ioctl if irq_set_freq is not implemented by driver
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-dev.c~rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver
+++ a/drivers/rtc/rtc-dev.c
@@ -341,6 +341,8 @@ static int rtc_dev_ioctl(struct inode *i
 	case RTC_IRQP_READ:
 		if (ops->irq_set_freq)
 			err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
+		else
+			err = -ENOTTY;
 		break;
 
 	case RTC_IRQP_SET:
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

origin.patch
git-watchdog.patch
