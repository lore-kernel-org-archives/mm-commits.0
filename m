From: akpm@linux-foundation.org
Subject: + driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:07:29 -0700
Message-ID: <200706262107.l5QL7Tgm002120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757756AbXFZVHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix 3
has been added to the -mm tree.  Its filename is
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix 3
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

rtc-at32ap700x: add comment to spinlock_t lock definition

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3 drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -62,6 +62,7 @@ struct rtc_at32ap700x {
 	void __iomem		*regs;
 	unsigned long		alarm_time;
 	unsigned long		irq;
+	/* Protect against concurrent register access. */
 	spinlock_t		lock;
 };
 
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
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
