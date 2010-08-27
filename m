From: akpm@linux-foundation.org
Subject: + drivers-mmc-host-omap_hsmmcc-use-resource_size.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:53:47 -0700
Message-ID: <201008272053.o7RKrl0J015452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab0H0UyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, madhu.cr@ti.com


The patch titled
     drivers/mmc/host/omap_hsmmc.c: use resource_size()
has been added to the -mm tree.  Its filename is
     drivers-mmc-host-omap_hsmmcc-use-resource_size.patch

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
Subject: drivers/mmc/host/omap_hsmmc.c: use resource_size()
From: Chris Ball <cjb@laptop.org>

Use resource_size().

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~drivers-mmc-host-omap_hsmmcc-use-resource_size drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~drivers-mmc-host-omap_hsmmcc-use-resource_size
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2003,7 +2003,7 @@ static int __init omap_hsmmc_probe(struc
 	if (res == NULL || irq < 0)
 		return -ENXIO;
 
-	res = request_mem_region(res->start, res->end - res->start + 1,
+	res = request_mem_region(res->start, resource_size(res),
 							pdev->name);
 	if (res == NULL)
 		return -EBUSY;
@@ -2256,7 +2256,7 @@ err1:
 err_alloc:
 	omap_hsmmc_gpio_free(pdata);
 err:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
@@ -2293,7 +2293,7 @@ static int omap_hsmmc_remove(struct plat
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from cjb@laptop.org are

linux-next.patch
arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected.patch
omap_hsmmc-remove-unused-state-variable.patch
mmc-at91_mci-add-missing-linux-highmemh-include.patch
mmc-mmc-44-ddr-support.patch
mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging.patch
mmc-at91_mcic-use-resource_size.patch
mmc-atmel-mcic-use-resource-size.patch
mmc-au1xmmcc-use-resource_size.patch
mmc-use-snprintf-not-sprintf.patch
drivers-mmc-host-omapc-use-resource_size.patch
drivers-mmc-host-omap_hsmmcc-use-resource_size.patch

