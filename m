From: akpm@linux-foundation.org
Subject: [merged] ib-rdmavt-use-kmalloc_array_node.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 11:59:50 -0800
Message-ID: <20171116195950.UwD6hrcsl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934028AbdKPT7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, vbabka@suse.cz


The patch titled
     Subject: drivers/infiniband/sw/rdmavt/qp.c: use kmalloc_array_node()
has been removed from the -mm tree.  Its filename was
     ib-rdmavt-use-kmalloc_array_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: drivers/infiniband/sw/rdmavt/qp.c: use kmalloc_array_node()

Now that we have a NUMA-aware version of kmalloc_array() we can use it
instead of kmalloc_node() without an overflow check in the size
calculation.

Link: http://lkml.kernel.org/r/20170927082038.3782-5-jthumshirn@suse.de
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

 drivers/infiniband/sw/rdmavt/qp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/sw/rdmavt/qp.c~ib-rdmavt-use-kmalloc_array_node drivers/infiniband/sw/rdmavt/qp.c
--- a/drivers/infiniband/sw/rdmavt/qp.c~ib-rdmavt-use-kmalloc_array_node
+++ a/drivers/infiniband/sw/rdmavt/qp.c
@@ -238,7 +238,7 @@ int rvt_driver_qp_init(struct rvt_dev_in
 	rdi->qp_dev->qp_table_size = rdi->dparms.qp_table_size;
 	rdi->qp_dev->qp_table_bits = ilog2(rdi->dparms.qp_table_size);
 	rdi->qp_dev->qp_table =
-		kmalloc_node(rdi->qp_dev->qp_table_size *
+		kmalloc_array_node(rdi->qp_dev->qp_table_size,
 			     sizeof(*rdi->qp_dev->qp_table),
 			     GFP_KERNEL, rdi->dparms.node);
 	if (!rdi->qp_dev->qp_table)
_

Patches currently in -mm which might be from jthumshirn@suse.de are


