From: akpm@linux-foundation.org
Subject: + watchdog-driver-for-at32ap700x-devices-fix-3.patch added to -mm tree
Date: Fri, 08 Jun 2007 11:01:47 -0700
Message-ID: <200706081801.l58I1lLr007104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383AbXFHSCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 14:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, hskinnemoen@atmel.com, wim@iguana.be


The patch titled
     at32ap700x-wdt: add missing iounmap in _remove
has been added to the -mm tree.  Its filename is
     watchdog-driver-for-at32ap700x-devices-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
watchdog-driver-for-at32ap700x-devices.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
watchdog-driver-for-at32ap700x-devices-fix-3.patch
