From: akpm@linux-foundation.org
Subject: + sdhci-s3c-fix-incorrect-spinlock-usage-after-merge.patch added to -mm tree
Date: Mon, 20 Sep 2010 11:36:44 -0700
Message-ID: <201009201836.o8KIaiQX006018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab0ITShX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 14:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, cjb@laptop.org, kyungmin.park@samsung.com


The patch titled
     sdhci-s3c: fix incorrect spinlock usage after merge
has been added to the -mm tree.  Its filename is
     sdhci-s3c-fix-incorrect-spinlock-usage-after-merge.patch

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
Subject: sdhci-s3c: fix incorrect spinlock usage after merge
From: Marek Szyprowski <m.szyprowski@samsung.com>

In f522886e202a34a21 ("drivers/mmc/host/sdhci-s3c.c: use the correct mutex
and card detect function") a merge conflict in the sdhci-s3c driver been
fixed.  However the fix used incorrect spinlock operation - it cause a
race with sdhci interrupt service.  The correct way to solve it is to use
spin_lock_irqsave/irqrestore() calls.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-fix-incorrect-spinlock-usage-after-merge drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-fix-incorrect-spinlock-usage-after-merge
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -241,8 +241,10 @@ static struct sdhci_ops sdhci_s3c_ops = 
 static void sdhci_s3c_notify_change(struct platform_device *dev, int state)
 {
 	struct sdhci_host *host = platform_get_drvdata(dev);
+	unsigned long flags;
+
 	if (host) {
-		spin_lock(&host->lock);
+		spin_lock_irqsave(&host->lock, flags);
 		if (state) {
 			dev_dbg(&dev->dev, "card inserted.\n");
 			host->flags &= ~SDHCI_DEVICE_DEAD;
@@ -253,7 +255,7 @@ static void sdhci_s3c_notify_change(stru
 			host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 		}
 		tasklet_schedule(&host->card_tasklet);
-		spin_unlock(&host->lock);
+		spin_unlock_irqrestore(&host->lock, flags);
 	}
 }
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
sdhci-s3c-fix-incorrect-spinlock-usage-after-merge.patch

