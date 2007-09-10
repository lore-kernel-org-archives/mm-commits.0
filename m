From: akpm@linux-foundation.org
Subject: + bug-in-at91-mci-suspend-routines.patch added to -mm tree
Date: Mon, 10 Sep 2007 02:27:38 -0700
Message-ID: <200709100927.l8A9RcGF017227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbXIJJ2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 05:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anti.sullin@artecdesign.ee, akpm@linux-foundation.org, drzeus@drzeus.cx, nicolas.ferre@rfo.atmel.com


The patch titled
     bug in AT91 MCI suspend routines
has been added to the -mm tree.  Its filename is
     bug-in-at91-mci-suspend-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~bug-in-at91-mci-suspend-routines drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~bug-in-at91-mci-suspend-routines
+++ a/drivers/mmc/host/at91_mci.c
@@ -947,7 +947,7 @@ static int __exit at91_mci_remove(struct
 
 	host = mmc_priv(mmc);
 
-	if (host->present != -1) {
+	if (host->board->det_pin) {
 		device_init_wakeup(&pdev->dev, 0);
 		free_irq(host->board->det_pin, host);
 		cancel_delayed_work(&host->mmc->detect);
@@ -978,7 +978,7 @@ static int at91_mci_suspend(struct platf
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		enable_irq_wake(host->board->det_pin);
 
 	if (mmc)
@@ -993,7 +993,7 @@ static int at91_mci_resume(struct platfo
 	struct at91mci_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	if (device_may_wakeup(&pdev->dev))
+	if (host->board->det_pin && device_may_wakeup(&pdev->dev))
 		disable_irq_wake(host->board->det_pin);
 
 	if (mmc)
_

Patches currently in -mm which might be from anti.sullin@artecdesign.ee are

bug-in-at91-mci-suspend-routines.patch
