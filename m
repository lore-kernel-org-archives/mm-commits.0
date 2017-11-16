From: akpm@linux-foundation.org
Subject: [patch 026/131] net/rds/ib_fmr.c: use kmalloc_array_node()
Date: Wed, 15 Nov 2017 17:32:49 -0800
Message-ID: <20171116013249.faSFBtThQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933534AbdKPBcv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: net/rds/ib_fmr.c: use kmalloc_array_node()

Now that we have a NUMA-aware version of kmalloc_array() we can use it
instead of kmalloc_node() without an overflow check in the size
calculation.

Link: http://lkml.kernel.org/r/20170927082038.3782-7-jthumshirn@suse.de
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/ib_fmr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/rds/ib_fmr.c~rds-ib-use-kmalloc_array_node net/rds/ib_fmr.c
--- a/net/rds/ib_fmr.c~rds-ib-use-kmalloc_array_node
+++ a/net/rds/ib_fmr.c
@@ -139,8 +139,8 @@ static int rds_ib_map_fmr(struct rds_ib_
 		return -EINVAL;
 	}
 
-	dma_pages = kmalloc_node(sizeof(u64) * page_cnt, GFP_ATOMIC,
-				 rdsibdev_to_node(rds_ibdev));
+	dma_pages = kmalloc_array_node(sizeof(u64), page_cnt, GFP_ATOMIC,
+				       rdsibdev_to_node(rds_ibdev));
 	if (!dma_pages) {
 		ib_dma_unmap_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
 		return -ENOMEM;
_
