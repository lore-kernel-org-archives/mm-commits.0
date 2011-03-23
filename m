From: akpm@linux-foundation.org
Subject: [merged] drivers-mmc-host-omap_hsmmcc-use-resource_size.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:18 -0700
Message-ID: <201103232043.p2NKhsX6029004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454Ab1CWUn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, kishore.kadiyala@ti.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/host/omap_hsmmc.c: use resource_size()
has been removed from the -mm tree.  Its filename was
     drivers-mmc-host-omap_hsmmcc-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mmc/host/omap_hsmmc.c: use resource_size()
From: Chris Ball <cjb@laptop.org>

Use resource_size().

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~drivers-mmc-host-omap_hsmmcc-use-resource_size drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~drivers-mmc-host-omap_hsmmcc-use-resource_size
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2047,8 +2047,7 @@ static int __init omap_hsmmc_probe(struc
 
 	res->start += pdata->reg_offset;
 	res->end += pdata->reg_offset;
-	res = request_mem_region(res->start, res->end - res->start + 1,
-							pdev->name);
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (res == NULL)
 		return -EBUSY;
 
@@ -2287,7 +2286,7 @@ err1:
 err_alloc:
 	omap_hsmmc_gpio_free(pdata);
 err:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
@@ -2324,7 +2323,7 @@ static int omap_hsmmc_remove(struct plat
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from cjb@laptop.org are

origin.patch

