From: akpm@linux-foundation.org
Subject: +
 net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
 added to -mm tree
Date: Mon, 06 Mar 2017 13:48:15 -0800
Message-ID: <58bdd91f.mjFOdcGlMwPUXANW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754815AbdCGD1R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 22:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, edumazet@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: net: use kvmalloc with __GFP_REPEAT rather than open coded variant
has been added to the -mm tree.  Its filename is
     net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: net: use kvmalloc with __GFP_REPEAT rather than open coded variant

fq_alloc_node, alloc_netdev_mqs and netif_alloc* open code kmalloc with
vmalloc fallback.  Use the kvmalloc variant instead.  Keep the
__GFP_REPEAT flag based on explanation from Eric:

"At the time, tests on the hardware I had in my labs showed that vmalloc()
could deliver pages spread all over the memory and that was a small
penalty (once memory is fragmented enough, not at boot time)"

The way how the code is constructed means, however, that we prefer to go
and hit the OOM killer before we fall back to the vmalloc for requests
<=32kB (with 4kB pages) in the current code.  This is rather disruptive
for something that can be achived with the fallback.  On the other hand
__GFP_REPEAT doesn't have any useful semantic for these requests.  So the
effect of this patch is that requests smaller than 64kB will fallback to
vmalloc easier now.

Link: http://lkml.kernel.org/r/20170306103327.2766-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c     |   24 +++++++++---------------
 net/sched/sch_fq.c |   12 +-----------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff -puN net/core/dev.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant net/core/dev.c
--- a/net/core/dev.c~net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant
+++ a/net/core/dev.c
@@ -7121,12 +7121,10 @@ static int netif_alloc_rx_queues(struct
 
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
@@ -7163,12 +7161,10 @@ static int netif_alloc_netdev_queues(str
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
@@ -7702,9 +7698,7 @@ struct net_device *alloc_netdev_mqs(int
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
-
 static void fq_free(void *addr)
 {
 	kvfree(addr);
@@ -650,7 +640,7 @@ static int fq_resize(struct Qdisc *sch,
 		return 0;
 
 	/* If XPS was setup, we can allocate memory on right NUMA node */
-	array = fq_alloc_node(sizeof(struct rb_root) << log,
+	array = kvmalloc_node(sizeof(struct rb_root) << log, GFP_KERNEL | __GFP_REPEAT,
 			      netdev_queue_numa_node_read(sch->dev_queue));
 	if (!array)
 		return -ENOMEM;
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch

