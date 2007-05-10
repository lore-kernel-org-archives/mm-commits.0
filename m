From: akpm@linux-foundation.org
Subject: + at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch added to -mm tree
Date: Thu, 10 May 2007 15:26:41 -0700
Message-ID: <200705102226.l4AMQfSW032457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933083AbXEJW1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marc.pignat@hevs.ch, andrew@sanpeople.com, david-b@pacbell.net, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk


The patch titled
     at91: fix enable/disable_irq_wake symmetry in pcmcia driver
has been added to the -mm tree.  Its filename is
     at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: at91: fix enable/disable_irq_wake symmetry in pcmcia driver
From: Marc Pignat <marc.pignat@hevs.ch>

Fix enable_irq_wake and disable_irq_wake symmetry in at91 pcmcia driver

disable_irq_wake call must be symmetric with enable_irq_wake.  This patch
fix that problem for the at91_pcmia driver.  It seems that this patch was
forgotten when we've fixed irq_wake symmetry in all at91 related drivers. 
It was discussed in the "at91 drivers and [enable/disable]_irq_wake
(wrong?) usage" thread on the linux-arm-kernel mailing list.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/at91_cf.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/pcmcia/at91_cf.c~at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver
+++ a/drivers/pcmcia/at91_cf.c
@@ -336,16 +336,21 @@ static int at91_cf_suspend(struct platfo
 		enable_irq_wake(board->det_pin);
 		if (board->irq_pin)
 			enable_irq_wake(board->irq_pin);
-	} else {
-		disable_irq_wake(board->det_pin);
-		if (board->irq_pin)
-			disable_irq_wake(board->irq_pin);
 	}
 	return 0;
 }
 
 static int at91_cf_resume(struct platform_device *pdev)
 {
+	struct at91_cf_socket	*cf = platform_get_drvdata(pdev);
+	struct at91_cf_data	*board = cf->board;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		disable_irq_wake(board->det_pin);
+		if (board->irq_pin)
+			disable_irq_wake(board->irq_pin);
+	}
+
 	pcmcia_socket_dev_resume(&pdev->dev);
 	return 0;
 }
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
