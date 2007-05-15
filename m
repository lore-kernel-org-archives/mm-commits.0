From: akpm@linux-foundation.org
Subject: + rtc-omap-build-fix.patch added to -mm tree
Date: Mon, 14 May 2007 22:56:53 -0700
Message-ID: <200705150556.l4F5uqqF002709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758203AbXEOF6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     rtc-omap build fix
has been added to the -mm tree.  Its filename is
     rtc-omap-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-omap build fix
From: David Brownell <david-b@pacbell.net>

Fix typo which breaks build.  How did that happen?

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-build-fix drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-build-fix
+++ a/drivers/rtc/rtc-omap.c
@@ -371,7 +371,7 @@ static int __devinit omap_rtc_probe(stru
 		goto fail;
 	}
 	platform_set_drvdata(pdev, rtc);
-	dev_set_devdata(&rtc->dev, mem);
+	dev_set_drvdata(&rtc->dev, mem);
 
 	/* clear pending irqs, and set 1/second periodic,
 	 * which we'll use instead of update irqs
@@ -453,7 +453,7 @@ static int __devexit omap_rtc_remove(str
 	free_irq(omap_rtc_timer, rtc);
 	free_irq(omap_rtc_alarm, rtc);
 
-	release_resource(dev_get_devdata(&rtc->dev));
+	release_resource(dev_get_drvdata(&rtc->dev));
 	rtc_device_unregister(rtc);
 	return 0;
 }
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
rtc-ds1307-cleanups.patch
gpio-interface-loosens-call-restrictions.patch
rtc-omap-build-fix.patch
rtc-kconfig-clarification.patch
use-menuconfig-objects-ii-rtc.patch
