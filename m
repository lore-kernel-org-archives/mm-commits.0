From: akpm@linux-foundation.org
Subject: + mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size.patch added to -mm tree
Date: Mon, 02 Feb 2009 22:57:10 -0800
Message-ID: <200902030657.n136vAjh018307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZBCG5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 01:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, sameo@openedhand.com


The patch titled
     mfd/htc-egpio: fix iomem resource handling using resource_size
has been added to the -mm tree.  Its filename is
     mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size.patch

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
mfd-htc-egpio-fix-iomem-resource-handling-using-resource_size.patch

