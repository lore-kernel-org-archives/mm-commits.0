From: akpm@linux-foundation.org
Subject: + driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:49:36 -0700
Message-ID: <200706260449.l5Q4nacx018609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbXFZEtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices fix 2
has been added to the -mm tree.  Its filename is
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices fix 2
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

rtc-at32ap700x driver updated to 2.6.22-rc4-mm2 kernel

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2 drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -202,7 +202,7 @@ static irqreturn_t at32_rtc_interrupt(in
 				& ~RTC_BIT(CTRL_TOPEN));
 		rtc_writel(rtc, VAL, rtc->alarm_time);
 		events = RTC_AF | RTC_IRQF;
-		rtc_update_irq(&rtc->rtc->class_dev, 1, events);
+		rtc_update_irq(rtc->rtc, 1, events);
 		ret = IRQ_HANDLED;
 	}
 
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-input.patch
git-watchdog.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
