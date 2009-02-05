From: akpm@linux-foundation.org
Subject: [merged] mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:52 -0800
Message-ID: <200902051914.n15JEqCx012339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbZBETRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd/htc-egpio: fix iomem resource handling using resource_size
has been removed from the -mm tree.  Its filename was
     mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/htc-egpio: fix iomem resource handling using resource_size
From: Philipp Zabel <philipp.zabel@gmail.com>

Fix an off-by-one error in the iomem resource mapping.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/htc-egpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/htc-egpio.c~mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size drivers/mfd/htc-egpio.c
--- a/drivers/mfd/htc-egpio.c~mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size
+++ a/drivers/mfd/htc-egpio.c
@@ -286,7 +286,7 @@ static int __init egpio_probe(struct pla
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto fail;
-	ei->base_addr = ioremap_nocache(res->start, res->end - res->start);
+	ei->base_addr = ioremap_nocache(res->start, resource_size(res));
 	if (!ei->base_addr)
 		goto fail;
 	pr_debug("EGPIO phys=%08x virt=%p\n", (u32)res->start, ei->base_addr);
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

