From: akpm@linux-foundation.org
Subject: [folded-merged] c6x-convert-to-dma_map_ops-fix.patch removed from -mm tree
Date: Wed, 20 Jan 2016 14:38:39 -0800
Message-ID: <56a00c6f.frO81kJJYAzkvQA5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbcATWil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:38:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, borntraeger@de.ibm.com, hch@lst.de, jroedel@suse.de, msalter@redhat.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: C6X: fix build breakage
has been removed from the -mm tree.  Its filename was
     c6x-convert-to-dma_map_ops-fix.patch

This patch was dropped because it was folded into c6x-convert-to-dma_map_ops.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: C6X: fix build breakage

There is a missing curly brace so this code doesn't build.

Fixes: 84f2f1c6ad15 ('c6x: convert to dma_map_ops')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mark Salter <msalter@redhat.com>
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

c6x-convert-to-dma_map_ops.patch
maintainers-fix-mic-maintainers-entry.patch

