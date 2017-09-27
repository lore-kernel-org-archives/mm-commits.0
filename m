From: akpm@linux-foundation.org
Subject: + ib-qib-use-kmalloc_array_node.patch added to -mm tree
Date: Wed, 27 Sep 2017 12:48:55 -0700
Message-ID: <59cc00a7.jFrR7bRX2mUBBIVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdI0Ts5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 15:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jthumshirn@suse.de, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/hw/qib/qib_init.c: use kmalloc_array_node()
has been added to the -mm tree.  Its filename is
     ib-qib-use-kmalloc_array_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ib-qib-use-kmalloc_array_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ib-qib-use-kmalloc_array_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jthumshirn@suse.de are

mm-add-kmalloc_array_node-and-kcalloc_node.patch
block-use-kmalloc_array_node.patch
ib-qib-use-kmalloc_array_node.patch
ib-rdmavt-use-kmalloc_array_node.patch
mm-mempool-use-kmalloc_array_node.patch
rds-ib-use-kmalloc_array_node.patch

