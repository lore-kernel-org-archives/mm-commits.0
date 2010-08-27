From: akpm@linux-foundation.org
Subject: + mmc-at91_mcic-use-resource_size.patch added to -mm tree
Date: Fri, 27 Aug 2010 12:30:02 -0700
Message-ID: <201008271930.o7RJU2wk011396__7020.8779573024$1282937411$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab0H0TaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 15:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hsweeten@visionengravers.com, cjb@laptop.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: at91_mci.c: use resource_size()
has been added to the -mm tree.  Its filename is
     mmc-at91_mcic-use-resource_size.patch

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
Subject: mmc: at91_mci.c: use resource_size()
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Use resource_size().

[cjb: rebased patch against Linus]
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mcic-use-resource_size drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mcic-use-resource_size
+++ a/drivers/mmc/host/at91_mci.c
@@ -927,7 +927,7 @@ static int __init at91_mci_probe(struct 
 	if (!res)
 		return -ENXIO;
 
-	if (!request_mem_region(res->start, res->end - res->start + 1, DRIVER_NAME))
+	if (!request_mem_region(res->start, resource_size(res), DRIVER_NAME))
 		return -EBUSY;
 
 	mmc = mmc_alloc_host(sizeof(struct at91mci_host), &pdev->dev);
@@ -1016,7 +1016,7 @@ static int __init at91_mci_probe(struct 
 	/*
 	 * Map I/O region
 	 */
-	host->baseaddr = ioremap(res->start, res->end - res->start + 1);
+	host->baseaddr = ioremap(res->start, resource_size(res));
 	if (!host->baseaddr) {
 		ret = -ENOMEM;
 		goto fail1;
@@ -1092,7 +1092,7 @@ fail4b:
 fail5:
 	mmc_free_host(mmc);
 fail6:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	dev_err(&pdev->dev, "probe failed, err %d\n", ret);
 	return ret;
 }
@@ -1137,7 +1137,7 @@ static int __exit at91_mci_remove(struct
 
 	iounmap(host->baseaddr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	mmc_free_host(mmc);
 	platform_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

kernelh-add-minmax3-macros.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
mmc-at91_mcic-use-resource_size.patch
mmc-atmel-mcic-use-resource-size.patch
mmc-au1xmmcc-use-resource_size.patch

