From: akpm@osdl.org
Subject: - watchdog-omap_wdt-build-fix.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:47 -0800
Message-ID: <200612130656.kBD6ulG1030758@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965057AbWLMG45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     watchdog: omap_wdt build fix
has been removed from the -mm tree.  Its filename was
     watchdog-omap_wdt-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: watchdog: omap_wdt build fix
From: David Brownell <david-b@pacbell.net>

Recent driver model changes affected "miscdev" and broke
the build for the OMAP watchdog timer; fixed by this patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/watchdog/omap_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
fix-more-workqueue-build-breakage-tps65010.patch
another-build-fix-header-rearrangements-osk.patch
rtc-remove-syslog-spam-on-registration.patch
rtc-framework-rtc_wkalrmenabled-reporting-updates.patch

