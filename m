From: akpm@linux-foundation.org
Subject: + block-use-kmalloc_array_node.patch added to -mm tree
Date: Wed, 27 Sep 2017 12:48:53 -0700
Message-ID: <59cc00a5.gD4TEdtLRaLsxYb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56330 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdI0Tsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 15:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jthumshirn@suse.de, axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block/blk-mq.c: use kmalloc_array_node()
has been added to the -mm tree.  Its filename is
     block-use-kmalloc_array_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-use-kmalloc_array_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-use-kmalloc_array_node.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-mq.c~block-use-kmalloc_array_node block/blk-mq.c
--- a/block/blk-mq.c~block-use-kmalloc_array_node
+++ a/block/blk-mq.c
@@ -1979,7 +1979,7 @@ static int blk_mq_init_hctx(struct reque
 	 * Allocate space for all possible cpus to avoid allocation at
 	 * runtime
 	 */
-	hctx->ctxs = kmalloc_node(nr_cpu_ids * sizeof(void *),
+	hctx->ctxs = kmalloc_array_node(nr_cpu_ids, sizeof(void *),
 					GFP_KERNEL, node);
 	if (!hctx->ctxs)
 		goto unregister_cpu_notifier;
_

Patches currently in -mm which might be from jthumshirn@suse.de are

mm-add-kmalloc_array_node-and-kcalloc_node.patch
block-use-kmalloc_array_node.patch
ib-qib-use-kmalloc_array_node.patch
ib-rdmavt-use-kmalloc_array_node.patch
mm-mempool-use-kmalloc_array_node.patch
rds-ib-use-kmalloc_array_node.patch

