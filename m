From: akpm@linux-foundation.org
Subject: [patch 025/131] mm/mempool.c: use kmalloc_array_node()
Date: Wed, 15 Nov 2017 17:32:45 -0800
Message-ID: <20171116013245.vVzL1zOnk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933515AbdKPBcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: mm/mempool.c: use kmalloc_array_node()

Now that we have a NUMA-aware version of kmalloc_array() we can use it
instead of kmalloc_node() without an overflow check in the size
calculation.

Link: http://lkml.kernel.org/r/20170927082038.3782-6-jthumshirn@suse.de
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempool-use-kmalloc_array_node mm/mempool.c
--- a/mm/mempool.c~mm-mempool-use-kmalloc_array_node
+++ a/mm/mempool.c
@@ -189,7 +189,7 @@ mempool_t *mempool_create_node(int min_n
 	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
 	if (!pool)
 		return NULL;
-	pool->elements = kmalloc_node(min_nr * sizeof(void *),
+	pool->elements = kmalloc_array_node(min_nr, sizeof(void *),
 				      gfp_mask, node_id);
 	if (!pool->elements) {
 		kfree(pool);
_
