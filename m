From: akpm@linux-foundation.org
Subject: - watchdog-driver-for-at32ap700x-devices-fix-4.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:47 -0700
Message-ID: <200706121858.l5CIwljX018557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbXFLTGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, hskinnemoen@atmel.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     at32ap700x-wdt: add iounmap if probe function fails
has been removed from the -mm tree.  Its filename was
     watchdog-driver-for-at32ap700x-devices-fix-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: at32ap700x-wdt: add iounmap if probe function fails
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/at32ap700x_wdt.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/char/watchdog/at32ap700x_wdt.c~watchdog-driver-for-at32ap700x-devices-fix-4 drivers/char/watchdog/at32ap700x_wdt.c
--- a/drivers/char/watchdog/at32ap700x_wdt.c~watchdog-driver-for-at32ap700x-devices-fix-4
+++ a/drivers/char/watchdog/at32ap700x_wdt.c
@@ -223,6 +223,11 @@ static int __init at32_wdt_probe(struct 
 	}
 
 	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!wdt->regs) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "could not map I/O memory\n");
+		goto err_free;
+	}
 	wdt->users = 0;
 	wdt->miscdev.minor = WATCHDOG_MINOR;
 	wdt->miscdev.name = "watchdog";
@@ -238,7 +243,7 @@ static int __init at32_wdt_probe(struct 
 	ret = misc_register(&wdt->miscdev);
 	if (ret) {
 		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
-		goto err_register;
+		goto err_iounmap;
 	}
 
 	platform_set_drvdata(pdev, wdt);
@@ -247,7 +252,9 @@ static int __init at32_wdt_probe(struct 
 
 	return 0;
 
-err_register:
+err_iounmap:
+	iounmap(wdt->regs);
+err_free:
 	kfree(wdt);
 	wdt = NULL;
 	return ret;
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-watchdog.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
