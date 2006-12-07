From: akpm@osdl.org
Subject: + watchdog-omap_wdt-build-fix.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:28:40 -0800
Message-ID: <200612072028.kB7KSeJa024516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36340 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163293AbWLGU25 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:28:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     watchdog: omap_wdt build fix
has been added to the -mm tree.  Its filename is
     watchdog-omap_wdt-build-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: watchdog: omap_wdt build fix
From: David Brownell <david-b@pacbell.net>

Recent driver model changes affected "miscdev" and broke
the build for the OMAP watchdog timer; fixed by this patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/watchdog/omap_wdt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/watchdog/omap_wdt.c~watchdog-omap_wdt-build-fix drivers/char/watchdog/omap_wdt.c
--- a/drivers/char/watchdog/omap_wdt.c~watchdog-omap_wdt-build-fix
+++ a/drivers/char/watchdog/omap_wdt.c
@@ -290,7 +290,7 @@ static int __init omap_wdt_probe(struct 
 	omap_wdt_disable();
 	omap_wdt_adjust_timeout(timer_margin);
 
-	omap_wdt_miscdev.dev = &pdev->dev;
+	omap_wdt_miscdev.parent = &pdev->dev;
 	ret = misc_register(&omap_wdt_miscdev);
 	if (ret)
 		goto fail;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-improve-sysfs-compiler-complaint-handling.patch
correct-bus_num-and-buffer-bug-in-spi-core.patch
spi-set-kset-of-master-class-dev-explicitly.patch
add-rtc-omap-driver.patch
mmc-fix-syntax-error.patch
watchdog-omap_wdt-build-fix.patch

