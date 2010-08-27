From: akpm@linux-foundation.org
Subject: + drivers-mmc-host-omapc-use-resource_size.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:53:45 -0700
Message-ID: <201008272053.o7RKrjth015449__12431.8728609525$1282942442$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab0H0Ux5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cjb@laptop.org, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, tony@atomide.com


The patch titled
     drivers/mmc/host/omap.c: use resource_size()
has been added to the -mm tree.  Its filename is
     drivers-mmc-host-omapc-use-resource_size.patch

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
Subject: drivers/mmc/host/omap.c: use resource_size()
From: Chris Ball <cjb@laptop.org>

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/omap.c~drivers-mmc-host-omapc-use-resource_size drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~drivers-mmc-host-omapc-use-resource_size
+++ a/drivers/mmc/host/omap.c
@@ -1416,7 +1416,7 @@ static int __init mmc_omap_probe(struct 
 	if (res == NULL || irq < 0)
 		return -ENXIO;
 
-	res = request_mem_region(res->start, res->end - res->start + 1,
+	res = request_mem_region(res->start, resource_size(res),
 				 pdev->name);
 	if (res == NULL)
 		return -EBUSY;
@@ -1456,7 +1456,7 @@ static int __init mmc_omap_probe(struct 
 
 	host->irq = irq;
 	host->phys_base = host->mem_res->start;
-	host->virt_base = ioremap(res->start, res->end - res->start + 1);
+	host->virt_base = ioremap(res->start, resource_size(res));
 	if (!host->virt_base)
 		goto err_ioremap;
 
@@ -1513,7 +1513,7 @@ err_free_mmc_host:
 err_ioremap:
 	kfree(host);
 err_free_mem_region:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
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

