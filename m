From: akpm@linux-foundation.org
Subject: - bug-in-at91-mci-suspend-routines.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:16 -0700
Message-ID: <200709160926.l8G9QGlE009172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbXIPJi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anti.sullin@artecdesign.ee, akpm@linux-foundation.org, drzeus@drzeus.cx, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     bug in AT91 MCI suspend routines
has been removed from the -mm tree.  Its filename was
     bug-in-at91-mci-suspend-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bug in AT91 MCI suspend routines
From: Anti Sullin <anti.sullin@artecdesign.ee>

This patch fixes a bug in AT91 mmc host driver, that enables the wakeup
from suspend on card detection pin even if the card detect pin is not
available (==0).  If not card detection pin is defined, IRQ0 == FIQ gets
enabled and if some activity is present on that pin, the system gets a FIQ
request, that causes a crash.

Original patch from Anti Sullin reviewed by Andrew Victor and
Marc Pignat ; thank you to all of you.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Acked-by: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~bug-in-at91-mci-suspend-routines drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~bug-in-at91-mci-suspend-routines
+++ a/drivers/mmc/host/at91_mci.c
@@ -941,7 +941,7 @@ static int __exit at91_mci_remove(struct
 
 	host = mmc_priv(mmc);
 
-	if (host->present != -1) {
+	if (host->board->det_pin) {
 		device_init_wakeup(&pdev->dev, 0);
 		free_irq(host->board->det_pin, host);
 		cancel_delayed_work(&host->mmc->detect);
@@ -972,7 +972,7 @@ static int at91_mci_suspend(struct platf
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		enable_irq_wake(host->board->det_pin);
 
 	if (mmc)
@@ -987,7 +987,7 @@ static int at91_mci_resume(struct platfo
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		disable_irq_wake(host->board->det_pin);
 
 	if (mmc)
_

Patches currently in -mm which might be from anti.sullin@artecdesign.ee are

origin.patch
git-input.patch
