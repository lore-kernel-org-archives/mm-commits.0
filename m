From: akpm@linux-foundation.org
Subject: - watchdog-driver-for-at32ap700x-devices-fix-3.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:45 -0700
Message-ID: <200706121858.l5CIwjho018554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbXFLTF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, hskinnemoen@atmel.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     at32ap700x-wdt: add missing iounmap in _remove
has been removed from the -mm tree.  Its filename was
     watchdog-driver-for-at32ap700x-devices-fix-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: at32ap700x-wdt: add missing iounmap in _remove
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/at32ap700x_wdt.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/char/watchdog/at32ap700x_wdt.c~watchdog-driver-for-at32ap700x-devices-fix-3 drivers/char/watchdog/at32ap700x_wdt.c
--- a/drivers/char/watchdog/at32ap700x_wdt.c~watchdog-driver-for-at32ap700x-devices-fix-3
+++ a/drivers/char/watchdog/at32ap700x_wdt.c
@@ -257,6 +257,7 @@ static int __exit at32_wdt_remove(struct
 {
 	if (wdt && platform_get_drvdata(pdev) == wdt) {
 		misc_deregister(&wdt->miscdev);
+		iounmap(wdt->regs);
 		kfree(wdt);
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-watchdog.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
