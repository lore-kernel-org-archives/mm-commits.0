From: akpm@linux-foundation.org
Subject: + c6x-convert-to-dma_map_ops-fix.patch added to -mm tree
Date: Mon, 23 Nov 2015 14:42:31 -0800
Message-ID: <56539657.1LJfjZN66+w1dIUT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbKWWmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: C6X: fix build breakage
has been added to the -mm tree.  Its filename is
     c6x-convert-to-dma_map_ops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/c6x-convert-to-dma_map_ops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/c6x-convert-to-dma_map_ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: C6X: fix build breakage

There is a missing curly brace so this code doesn't build.

Fixes: 84f2f1c6ad15 ('c6x: convert to dma_map_ops')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/kernel/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops-fix arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops-fix
+++ a/arch/c6x/kernel/dma.c
@@ -58,7 +58,7 @@ static int c6x_dma_map_sg(struct device
 	struct scatterlist *sg;
 	int i;
 
-	for_each_sg(sglist, sg, nents, i)
+	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
 		c6x_dma_sync(sg->dma_address, sg->length, dir);
 	}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-add-tracepoint-for-scanning-pages-fix.patch
c6x-convert-to-dma_map_ops-fix.patch

