From: akpm@linux-foundation.org
Subject: [patch 023/131] drivers/infiniband/hw/qib/qib_init.c: use
 kmalloc_array_node()
Date: Wed, 15 Nov 2017 17:32:37 -0800
Message-ID: <20171116013237.SuDbticlF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPBcj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: drivers/infiniband/hw/qib/qib_init.c: use kmalloc_array_node()

Now that we have a NUMA-aware version of kmalloc_array() we can use it
instead of kmalloc_node() without an overflow check in the size
calculation.

Link: http://lkml.kernel.org/r/20170927082038.3782-4-jthumshirn@suse.de
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/qib/qib_init.c~ib-qib-use-kmalloc_array_node drivers/infiniband/hw/qib/qib_init.c
--- a/drivers/infiniband/hw/qib/qib_init.c~ib-qib-use-kmalloc_array_node
+++ a/drivers/infiniband/hw/qib/qib_init.c
@@ -1674,8 +1674,9 @@ int qib_setup_eagerbufs(struct qib_ctxtd
 	}
 	if (!rcd->rcvegrbuf_phys) {
 		rcd->rcvegrbuf_phys =
-			kmalloc_node(chunk * sizeof(rcd->rcvegrbuf_phys[0]),
-				GFP_KERNEL, rcd->node_id);
+			kmalloc_array_node(chunk,
+					   sizeof(rcd->rcvegrbuf_phys[0]),
+					   GFP_KERNEL, rcd->node_id);
 		if (!rcd->rcvegrbuf_phys)
 			goto bail_rcvegrbuf;
 	}
_
