From: akpm@linux-foundation.org
Subject: [merged] drivers-mmc-host-omapc-use-resource_size.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:14 -0700
Message-ID: <201103232043.p2NKhppk028996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456Ab1CWUoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, jarkko.lavinen@nokia.com, kishore.kadiyala@ti.com, linux-mmc@vger.kernel.org, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/host/omap.c: use resource_size()
has been removed from the -mm tree.  Its filename was
     drivers-mmc-host-omapc-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mmc/host/omap.c: use resource_size()
From: Chris Ball <cjb@laptop.org>

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/omap.c~drivers-mmc-host-omapc-use-resource_size drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~drivers-mmc-host-omapc-use-resource_size
+++ a/drivers/mmc/host/omap.c
@@ -1417,7 +1417,7 @@ static int __init mmc_omap_probe(struct 
 	if (res == NULL || irq < 0)
 		return -ENXIO;
 
-	res = request_mem_region(res->start, res->end - res->start + 1,
+	res = request_mem_region(res->start, resource_size(res),
 				 pdev->name);
 	if (res == NULL)
 		return -EBUSY;
@@ -1457,7 +1457,7 @@ static int __init mmc_omap_probe(struct 
 
 	host->irq = irq;
 	host->phys_base = host->mem_res->start;
-	host->virt_base = ioremap(res->start, res->end - res->start + 1);
+	host->virt_base = ioremap(res->start, resource_size(res));
 	if (!host->virt_base)
 		goto err_ioremap;
 
@@ -1514,7 +1514,7 @@ err_free_mmc_host:
 err_ioremap:
 	kfree(host);
 err_free_mem_region:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
_

Patches currently in -mm which might be from cjb@laptop.org are

origin.patch

