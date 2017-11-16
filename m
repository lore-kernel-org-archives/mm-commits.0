From: akpm@linux-foundation.org
Subject: [patch 022/131] block/blk-mq.c: use kmalloc_array_node()
Date: Wed, 15 Nov 2017 17:32:33 -0800
Message-ID: <20171116013233.eCYwHVw2a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932772AbdKPBcf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: block/blk-mq.c: use kmalloc_array_node()

Now that we have a NUMA-aware version of kmalloc_array() we can use it
instead of kmalloc_node() without an overflow check in the size
calculation.

Link: http://lkml.kernel.org/r/20170927082038.3782-3-jthumshirn@suse.de
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-mq.c~block-use-kmalloc_array_node block/blk-mq.c
--- a/block/blk-mq.c~block-use-kmalloc_array_node
+++ a/block/blk-mq.c
@@ -2047,7 +2047,7 @@ static int blk_mq_init_hctx(struct reque
 	 * Allocate space for all possible cpus to avoid allocation at
 	 * runtime
 	 */
-	hctx->ctxs = kmalloc_node(nr_cpu_ids * sizeof(void *),
+	hctx->ctxs = kmalloc_array_node(nr_cpu_ids, sizeof(void *),
 					GFP_KERNEL, node);
 	if (!hctx->ctxs)
 		goto unregister_cpu_notifier;
_
