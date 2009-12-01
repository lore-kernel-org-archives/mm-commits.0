From: akpm@linux-foundation.org
Subject: + mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch added to -mm tree
Date: Tue, 01 Dec 2009 13:54:16 -0800
Message-ID: <200912012154.nB1LsGj8029755__8153.75205497748$1259704483$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZLAVyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 16:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, lethal@linux-sh.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: let tmio-mmc use dev_name() with request_irq()
has been added to the -mm tree.  Its filename is
     mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -582,7 +582,7 @@ static int __devinit tmio_mmc_probe(stru
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
-		IRQF_TRIGGER_FALLING, "tmio-mmc", host);
+		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
 		goto unmap_ctl;
 
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

