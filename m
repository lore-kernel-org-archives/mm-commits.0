From: akpm@linux-foundation.org
Subject: + rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:18:18 -0700
Message-ID: <200706111818.l5BIII73025708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbXFKSSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     rtc-dev: return -ENOTTY in ioctl if irq_set_freq is not implemented by driver
has been added to the -mm tree.  Its filename is
     rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+)

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

git-avr32.patch
watchdog-driver-for-at32ap700x-devices.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
watchdog-driver-for-at32ap700x-devices-fix-3.patch
watchdog-driver-for-at32ap700x-devices-fix-4.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
