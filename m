From: akpm@linux-foundation.org
Subject: [merged] mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:03 -0800
Message-ID: <200912152159.nBFLx3hO015867__46853.4117717811$1260914453$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933838AbZLOV77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, lethal@linux-sh.org, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: let tmio-mmc use dev_name() with request_irq()
has been removed from the -mm tree.  Its filename was
     mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: let tmio-mmc use dev_name() with request_irq()
From: Magnus Damm <damm@opensource.se>

Improve the /proc/interrupts output so the irq number can be mapped to
platform device on boards with multiple tmio_mmc instances.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: <linux-mmc@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-let-tmio-mmc-use-dev_name-with-request_irq drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-let-tmio-mmc-use-dev_name-with-request_irq
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -591,7 +591,7 @@ static int __devinit tmio_mmc_probe(stru
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
-		IRQF_TRIGGER_FALLING, "tmio-mmc", host);
+		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
 		goto unmap_cnf;
 
_

Patches currently in -mm which might be from damm@opensource.se are

origin.patch
linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-start-cmt-at-clocksource-resume-v2.patch
clocksource-add-suspend-callback.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch

