From: akpm@linux-foundation.org
Subject: + s3cmci-use-resource_size-instead-of-local-macro.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:03 -0700
Message-ID: <200909292257.n8TMv3DU025450__11298.383100848$1254265043$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZI2W5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: use resource_size() instead of local macro
has been added to the -mm tree.  Its filename is
     s3cmci-use-resource_size-instead-of-local-macro.patch

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
Subject: s3cmci: use resource_size() instead of local macro
From: Ben Dooks <ben@simtec.co.uk>

Replace the local definition RESSIZE() with the standard resource_size()
call for getting the size of a struct resource.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-use-resource_size-instead-of-local-macro drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-use-resource_size-instead-of-local-macro
+++ a/drivers/mmc/host/s3cmci.c
@@ -58,8 +58,6 @@ static const int dbgmap_debug = dbg_err 
 		dev_dbg(&host->pdev->dev, args);  \
 	} while (0)
 
-#define RESSIZE(ressource) (((ressource)->end - (ressource)->start)+1)
-
 static struct s3c2410_dma_client s3cmci_dma_client = {
 	.name		= "s3c-mci",
 };
@@ -1298,7 +1296,7 @@ static int __devinit s3cmci_probe(struct
 	}
 
 	host->mem = request_mem_region(host->mem->start,
-				       RESSIZE(host->mem), pdev->name);
+				       resource_size(host->mem), pdev->name);
 
 	if (!host->mem) {
 		dev_err(&pdev->dev, "failed to request io memory region.\n");
@@ -1306,7 +1304,7 @@ static int __devinit s3cmci_probe(struct
 		goto probe_free_host;
 	}
 
-	host->base = ioremap(host->mem->start, RESSIZE(host->mem));
+	host->base = ioremap(host->mem->start, resource_size(host->mem));
 	if (!host->base) {
 		dev_err(&pdev->dev, "failed to ioremap() io memory region.\n");
 		ret = -EINVAL;
@@ -1433,7 +1431,7 @@ static int __devinit s3cmci_probe(struct
 	iounmap(host->base);
 
  probe_free_mem_region:
-	release_mem_region(host->mem->start, RESSIZE(host->mem));
+	release_mem_region(host->mem->start, resource_size(host->mem));
 
  probe_free_host:
 	mmc_free_host(mmc);
@@ -1469,7 +1467,7 @@ static int __devexit s3cmci_remove(struc
 	free_irq(host->irq, host);
 
 	iounmap(host->base);
-	release_mem_region(host->mem->start, RESSIZE(host->mem));
+	release_mem_region(host->mem->start, resource_size(host->mem));
 
 	mmc_free_host(mmc);
 	return 0;
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-use-resource_size-instead-of-local-macro.patch
s3cmci-update-probe-to-use-new-platform-id-list.patch
s3cmci-change-gpio-to-gpiolib-from-s3c24xx-specific-calls.patch
s3cmci-change-to-use-dev_pm_ops.patch
s3cmci-fix-direct-write-to-interrupt-mask.patch
s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch
s3cmci-add-sdio-irq-support.patch
s3cmci-kconfig-selection-for-pio-dma-both.patch
s3cmci-dma-fixes.patch
s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch
s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

