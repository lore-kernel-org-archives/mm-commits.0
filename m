From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-missing-remove-function.patch added to -mm tree
Date: Fri, 09 Jul 2010 14:26:43 -0700
Message-ID: <201007092126.o69LQhI3026465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab0GIV1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 17:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com


The patch titled
     sdhci-s3c: add missing remove function
has been added to the -mm tree.  Its filename is
     sdhci-s3c-add-missing-remove-function.patch

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
Subject: sdhci-s3c: add missing remove function
From: Marek Szyprowski <m.szyprowski@samsung.com>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-missing-remove-function drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-missing-remove-function
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -365,6 +365,26 @@ static int __devinit sdhci_s3c_probe(str
 
 static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 {
+	struct sdhci_host *host =  platform_get_drvdata(pdev);
+	struct sdhci_s3c *sc = sdhci_priv(host);
+	int ptr;
+
+	sdhci_remove_host(host, 1);
+
+	for (ptr = 0; ptr < 3; ptr++) {
+		clk_disable(sc->clk_bus[ptr]);
+		clk_put(sc->clk_bus[ptr]);
+	}
+	clk_disable(sc->clk_io);
+	clk_put(sc->clk_io);
+
+	iounmap(host->ioaddr);
+	release_resource(sc->ioarea);
+	kfree(sc->ioarea);
+
+	sdhci_free_host(host);
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
sdhci-s3c-add-missing-remove-function.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value-fix.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch

