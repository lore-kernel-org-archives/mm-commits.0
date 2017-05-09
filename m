From: akpm@linux-foundation.org
Subject: [merged]
 net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:02:45 -0700
Message-ID: <20170509180245.Wrf0SxMt0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbdEISCq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, edumazet@google.com, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz


The patch titled
     Subject: net: use kvmalloc with __GFP_REPEAT rather than open coded variant
has been removed from the -mm tree.  Its filename was
     net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: net: use kvmalloc with __GFP_REPEAT rather than open coded variant

fq_alloc_node, alloc_netdev_mqs and netif_alloc* open code kmalloc with
vmalloc fallback.  Use the kvmalloc variant instead.  Keep the
__GFP_REPEAT flag based on explanation from Eric:

"At the time, tests on the hardware I had in my labs showed that vmalloc()
could deliver pages spread all over the memory and that was a small
penalty (once memory is fragmented enough, not at boot time)"

The way how the code is constructed means, however, that we prefer to
go and hit the OOM killer before we fall back to the vmalloc for
requests <=32kB (with 4kB pages) in the current code.  This is rather
disruptive for something that can be achived with the fallback.  On the
other hand __GFP_REPEAT doesn't have any useful semantic for these
requests.  So the effect of this patch is that requests which fit into
32kB will fall back to vmalloc easier now.

Link: http://lkml.kernel.org/r/20170306103327.2766-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c     |   24 +++++++++---------------
 net/sched/sch_fq.c |   12 +-----------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff -puN net/core/dev.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant net/core/dev.c
--- a/net/core/dev.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant
+++ a/net/core/dev.c
@@ -7264,12 +7264,10 @@ static int netif_alloc_rx_queues(struct
 
 	BUG_ON(count < 1);
 
-	rx = kzalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!rx) {
-		rx = vzalloc(sz);
-		if (!rx)
-			return -ENOMEM;
-	}
+	rx = kvzalloc(sz, GFP_KERNEL | __GFP_REPEAT);
+	if (!rx)
+		return -ENOMEM;
+
 	dev->_rx = rx;
 
 	for (i = 0; i < count; i++)
@@ -7306,12 +7304,10 @@ static int netif_alloc_netdev_queues(str
 	if (count < 1 || count > 0xffff)
 		return -EINVAL;
 
-	tx = kzalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!tx) {
-		tx = vzalloc(sz);
-		if (!tx)
-			return -ENOMEM;
-	}
+	tx = kvzalloc(sz, GFP_KERNEL | __GFP_REPEAT);
+	if (!tx)
+		return -ENOMEM;
+
 	dev->_tx = tx;
 
 	netdev_for_each_tx_queue(dev, netdev_init_one_queue, NULL);
@@ -7845,9 +7841,7 @@ struct net_device *alloc_netdev_mqs(int
 	/* ensure 32-byte alignment of whole construct */
 	alloc_size += NETDEV_ALIGN - 1;
 
-	p = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!p)
-		p = vzalloc(alloc_size);
+	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_REPEAT);
 	if (!p)
 		return NULL;
 
diff -puN net/sched/sch_fq.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant net/sched/sch_fq.c
--- a/net/sched/sch_fq.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant
+++ a/net/sched/sch_fq.c
@@ -624,16 +624,6 @@ static void fq_rehash(struct fq_sched_da
 	q->stat_gc_flows += fcnt;
 }
 
-static void *fq_alloc_node(size_t sz, int node)
-{
-	void *ptr;
-
-	ptr = kmalloc_node(sz, GFP_KERNEL | __GFP_REPEAT | __GFP_NOWARN, node);
-	if (!ptr)
-		ptr = vmalloc_node(sz, node);
-	return ptr;
-}
