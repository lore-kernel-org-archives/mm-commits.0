From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:07:47 -0700
Message-ID: <560afda3.BFVN2vC2AWF8bdyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbI2VHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: distinguish between being unable to sleep, unwilling to sleep and avoiding waking kswapd
has been added to the -mm tree.  Its filename is
     mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: distinguish between being unable to sleep, unwilling to sleep and avoiding waking kswapd

__GFP_WAIT has been used to identify atomic context in callers that hold
spinlocks or are in interrupts.  They are expected to be high priority and
have access one of two watermarks lower than "min" which can be referred
to as the "atomic reserve".  __GFP_HIGH users get access to the first
lower watermark and can be called the "high priority reserve".

Over time, callers had a requirement to not block when fallback options
were available.  Some have abused __GFP_WAIT leading to a situation where
an optimisitic allocation with a fallback option can access atomic
reserves.

This patch uses __GFP_ATOMIC to identify callers that are truely atomic,
cannot sleep and have no alternative.  High priority users continue to use
__GFP_HIGH.  __GFP_DIRECT_RECLAIM identifies callers that can sleep and
are willing to enter direct reclaim.  __GFP_KSWAPD_RECLAIM to identify
callers that want to wake kswapd for background reclaim.  __GFP_WAIT is
redefined as a caller that is willing to enter direct reclaim and wake
kswapd for background reclaim.

This patch then converts a number of sites

o __GFP_ATOMIC is used by callers that are high priority and have memory
  pools for those requests. GFP_ATOMIC uses this flag.

o Callers that have a limited mempool to guarantee forward progress clear
  __GFP_DIRECT_RECLAIM but keep __GFP_KSWAPD_RECLAIM. bio allocations fall
  into this category where kswapd will still be woken but atomic reserves
  are not used as there is a one-entry mempool to guarantee progress.

o Callers that are checking if they are non-blocking should use the
  helper gfpflags_allow_blocking() where possible. This is because
  checking for __GFP_WAIT as was done historically now can trigger false
  positives. Some exceptions like dm-crypt.c exist where the code intent
  is clearer if __GFP_DIRECT_RECLAIM is used instead of the helper due to
  flag manipulations.

o Callers that built their own GFP flags instead of starting with GFP_KERNEL
  and friends now also need to specify __GFP_KSWAPD_RECLAIM.

The first key hazard to watch out for is callers that removed __GFP_WAIT
and was depending on access to atomic reserves for inconspicuous reasons. 
In some cases it may be appropriate for them to use __GFP_HIGH.

The second key hazard is callers that assembled their own combination of
GFP flags instead of starting with something like GFP_KERNEL.  They may
now wish to specify __GFP_KSWAPD_RECLAIM.  It's almost certainly harmless
if it's missed in most cases as other activity will wake kswapd.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/balance                                     |   14 +--
 arch/arm/mm/dma-mapping.c                                    |    6 -
 arch/arm/xen/mm.c                                            |    2 
 arch/arm64/mm/dma-mapping.c                                  |    4 
 arch/x86/kernel/pci-dma.c                                    |    2 
 block/bio.c                                                  |   26 ++---
 block/blk-core.c                                             |   16 +--
 block/blk-ioc.c                                              |    2 
 block/blk-mq-tag.c                                           |    2 
 block/blk-mq.c                                               |    8 -
 drivers/block/drbd/drbd_receiver.c                           |    3 
 drivers/block/osdblk.c                                       |    2 
 drivers/connector/connector.c                                |    3 
 drivers/firewire/core-cdev.c                                 |    2 
 drivers/gpu/drm/i915/i915_gem.c                              |    2 
 drivers/infiniband/core/sa_query.c                           |    2 
 drivers/iommu/amd_iommu.c                                    |    2 
 drivers/iommu/intel-iommu.c                                  |    2 
 drivers/md/dm-crypt.c                                        |    6 -
 drivers/md/dm-kcopyd.c                                       |    2 
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c               |    2 
 drivers/media/pci/solo6x10/solo6x10-v4l2.c                   |    2 
 drivers/media/pci/tw68/tw68-video.c                          |    2 
 drivers/mtd/mtdcore.c                                        |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |    2 
 drivers/staging/android/ion/ion_system_heap.c                |    2 
 drivers/staging/lustre/include/linux/libcfs/libcfs_private.h |    2 
 drivers/usb/host/u132-hcd.c                                  |    2 
 drivers/video/fbdev/vermilion/vermilion.c                    |    2 
 fs/btrfs/disk-io.c                                           |    2 
 fs/btrfs/extent_io.c                                         |   14 +--
 fs/btrfs/volumes.c                                           |    4 
 fs/ext4/super.c                                              |    2 
 fs/fscache/cookie.c                                          |    2 
 fs/fscache/page.c                                            |    6 -
 fs/jbd2/transaction.c                                        |    4 
 fs/nfs/file.c                                                |    6 -
 fs/xfs/xfs_qm.c                                              |    2 
 include/linux/gfp.h                                          |   46 +++++++---
 include/linux/skbuff.h                                       |    6 -
 include/net/sock.h                                           |    2 
 include/trace/events/gfpflags.h                              |    5 -
 kernel/audit.c                                               |    6 -
 kernel/cgroup.c                                              |    2 
 kernel/locking/lockdep.c                                     |    2 
 kernel/power/snapshot.c                                      |    2 
 kernel/smp.c                                                 |    2 
 lib/idr.c                                                    |    4 
 lib/radix-tree.c                                             |   10 +-
 mm/backing-dev.c                                             |    2 
 mm/dmapool.c                                                 |    2 
 mm/memcontrol.c                                              |    6 -
 mm/mempool.c                                                 |   10 +-
 mm/migrate.c                                                 |    2 
 mm/page_alloc.c                                              |   43 +++++----
 mm/slab.c                                                    |   18 +--
 mm/slub.c                                                    |   10 +-
 mm/vmalloc.c                                                 |    2 
 mm/vmscan.c                                                  |    4 
 mm/zswap.c                                                   |    5 -
 net/core/skbuff.c                                            |    8 -
 net/core/sock.c                                              |    6 -
 net/netlink/af_netlink.c                                     |    2 
 net/rds/ib_recv.c                                            |    4 
 net/rxrpc/ar-connection.c                                    |    2 
 net/sctp/associola.c                                         |    2 
 66 files changed, 211 insertions(+), 173 deletions(-)

diff -puN Documentation/vm/balance~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd Documentation/vm/balance
--- a/Documentation/vm/balance~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/Documentation/vm/balance
@@ -1,12 +1,14 @@
 Started Jan 2000 by Kanoj Sarcar <kanoj@sgi.com>
 
-Memory balancing is needed for non __GFP_WAIT as well as for non
-__GFP_IO allocations.
+Memory balancing is needed for !__GFP_ATOMIC and !__GFP_KSWAPD_RECLAIM as
+well as for non __GFP_IO allocations.
 
-There are two reasons to be requesting non __GFP_WAIT allocations:
-the caller can not sleep (typically intr context), or does not want
-to incur cost overheads of page stealing and possible swap io for
-whatever reasons.
+The first reason why a caller may avoid reclaim is that the caller can not
+sleep due to holding a spinlock or is in interrupt context. The second may
+be that the caller is willing to fail the allocation without incurring the
+overhead of page reclaim. This may happen for opportunistic high-order
+allocation requests that have order-0 fallback options. In such cases,
+the caller may also wish to avoid waking kswapd.
 
 __GFP_IO allocation requests are made to prevent file system deadlocks.
 
diff -puN arch/arm/mm/dma-mapping.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/arch/arm/mm/dma-mapping.c
@@ -651,12 +651,12 @@ static void *__dma_alloc(struct device *
 
 	if (nommu())
 		addr = __alloc_simple_buffer(dev, size, gfp, &page);
-	else if (dev_get_cma_area(dev) && (gfp & __GFP_WAIT))
+	else if (dev_get_cma_area(dev) && (gfp & __GFP_DIRECT_RECLAIM))
 		addr = __alloc_from_contiguous(dev, size, prot, &page,
 					       caller, want_vaddr);
 	else if (is_coherent)
 		addr = __alloc_simple_buffer(dev, size, gfp, &page);
-	else if (!(gfp & __GFP_WAIT))
+	else if (!gfpflags_allow_blocking(gfp))
 		addr = __alloc_from_pool(size, &page);
 	else
 		addr = __alloc_remap_buffer(dev, size, gfp, prot, &page,
@@ -1363,7 +1363,7 @@ static void *arm_iommu_alloc_attrs(struc
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (!(gfp & __GFP_WAIT))
+	if (!gfpflags_allow_blocking(gfp))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	/*
diff -puN arch/arm/xen/mm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd arch/arm/xen/mm.c
--- a/arch/arm/xen/mm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/arch/arm/xen/mm.c
@@ -25,7 +25,7 @@
 unsigned long xen_get_swiotlb_free_pages(unsigned int order)
 {
 	struct memblock_region *reg;
-	gfp_t flags = __GFP_NOWARN;
+	gfp_t flags = __GFP_NOWARN|__GFP_KSWAPD_RECLAIM;
 
 	for_each_memblock(memory, reg) {
 		if (reg->base < (phys_addr_t)0xffffffff) {
diff -puN arch/arm64/mm/dma-mapping.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/arch/arm64/mm/dma-mapping.c
@@ -100,7 +100,7 @@ static void *__dma_alloc_coherent(struct
 	if (IS_ENABLED(CONFIG_ZONE_DMA) &&
 	    dev->coherent_dma_mask <= DMA_BIT_MASK(32))
 		flags |= GFP_DMA;
-	if (dev_get_cma_area(dev) && (flags & __GFP_WAIT)) {
+	if (dev_get_cma_area(dev) && gfpflags_allow_blocking(flags)) {
 		struct page *page;
 		void *addr;
 
@@ -148,7 +148,7 @@ static void *__dma_alloc(struct device *
 
 	size = PAGE_ALIGN(size);
 
-	if (!coherent && !(flags & __GFP_WAIT)) {
+	if (!coherent && !gfpflags_allow_blocking(flags)) {
 		struct page *page = NULL;
 		void *addr = __alloc_from_pool(size, &page, flags);
 
diff -puN arch/x86/kernel/pci-dma.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/arch/x86/kernel/pci-dma.c
@@ -90,7 +90,7 @@ void *dma_generic_alloc_coherent(struct
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
-	if (flag & __GFP_WAIT) {
+	if (gfpflags_allow_blocking(flag)) {
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
 		if (page && page_to_phys(page) + size > dma_mask) {
 			dma_release_from_contiguous(dev, page, count);
diff -puN block/bio.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd block/bio.c
--- a/block/bio.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/block/bio.c
@@ -211,7 +211,7 @@ fallback:
 		bvl = mempool_alloc(pool, gfp_mask);
 	} else {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
-		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
+		gfp_t __gfp_mask = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
 
 		/*
 		 * Make this allocation restricted and don't dump info on
@@ -221,11 +221,11 @@ fallback:
 		__gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
 		/*
-		 * Try a slab allocation. If this fails and __GFP_WAIT
+		 * Try a slab allocation. If this fails and __GFP_DIRECT_RECLAIM
 		 * is set, retry with the 1-entry mempool
 		 */
 		bvl = kmem_cache_alloc(bvs->slab, __gfp_mask);
-		if (unlikely(!bvl && (gfp_mask & __GFP_WAIT))) {
+		if (unlikely(!bvl && (gfp_mask & __GFP_DIRECT_RECLAIM))) {
 			*idx = BIOVEC_MAX_IDX;
 			goto fallback;
 		}
@@ -395,12 +395,12 @@ static void punt_bios_to_rescuer(struct
  *   If @bs is NULL, uses kmalloc() to allocate the bio; else the allocation is
  *   backed by the @bs's mempool.
  *
- *   When @bs is not NULL, if %__GFP_WAIT is set then bio_alloc will always be
- *   able to allocate a bio. This is due to the mempool guarantees. To make this
- *   work, callers must never allocate more than 1 bio at a time from this pool.
- *   Callers that need to allocate more than 1 bio must always submit the
- *   previously allocated bio for IO before attempting to allocate a new one.
- *   Failure to do so can cause deadlocks under memory pressure.
+ *   When @bs is not NULL, if %__GFP_DIRECT_RECLAIM is set then bio_alloc will
+ *   always be able to allocate a bio. This is due to the mempool guarantees.
+ *   To make this work, callers must never allocate more than 1 bio at a time
+ *   from this pool. Callers that need to allocate more than 1 bio must always
+ *   submit the previously allocated bio for IO before attempting to allocate
+ *   a new one. Failure to do so can cause deadlocks under memory pressure.
  *
  *   Note that when running under generic_make_request() (i.e. any block
  *   driver), bios are not submitted until after you return - see the code in
@@ -459,13 +459,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 		 * We solve this, and guarantee forward progress, with a rescuer
 		 * workqueue per bio_set. If we go to allocate and there are
 		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_WAIT; if that fails, we punt those bios we
-		 * would be blocking to the rescuer workqueue before we retry
-		 * with the original gfp_flags.
+		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
+		 * bios we would be blocking to the rescuer workqueue before
+		 * we retry with the original gfp_flags.
 		 */
 
 		if (current->bio_list && !bio_list_empty(current->bio_list))
-			gfp_mask &= ~__GFP_WAIT;
+			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
 		if (!p && gfp_mask != saved_gfp) {
diff -puN block/blk-core.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd block/blk-core.c
--- a/block/blk-core.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/block/blk-core.c
@@ -1160,8 +1160,8 @@ rq_starved:
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
- * Get a free request from @q.  If %__GFP_WAIT is set in @gfp_mask, this
- * function keeps retrying under memory pressure and fails iff @q is dead.
+ * Get a free request from @q.  If %__GFP_DIRECT_RECLAIM is set in @gfp_mask,
+ * this function keeps retrying under memory pressure and fails iff @q is dead.
  *
  * Must be called with @q->queue_lock held and,
  * Returns ERR_PTR on failure, with @q->queue_lock held.
@@ -1181,7 +1181,7 @@ retry:
 	if (!IS_ERR(rq))
 		return rq;
 
-	if (!(gfp_mask & __GFP_WAIT) || unlikely(blk_queue_dying(q))) {
+	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
 	}
@@ -1259,11 +1259,11 @@ EXPORT_SYMBOL(blk_get_request);
  * BUG.
  *
  * WARNING: When allocating/cloning a bio-chain, careful consideration should be
- * given to how you allocate bios. In particular, you cannot use __GFP_WAIT for
- * anything but the first bio in the chain. Otherwise you risk waiting for IO
- * completion of a bio that hasn't been submitted yet, thus resulting in a
- * deadlock. Alternatively bios should be allocated using bio_kmalloc() instead
- * of bio_alloc(), as that avoids the mempool deadlock.
+ * given to how you allocate bios. In particular, you cannot use
+ * __GFP_DIRECT_RECLAIM for anything but the first bio in the chain. Otherwise
+ * you risk waiting for IO completion of a bio that hasn't been submitted yet,
+ * thus resulting in a deadlock. Alternatively bios should be allocated using
+ * bio_kmalloc() instead of bio_alloc(), as that avoids the mempool deadlock.
  * If possible a big IO should be split into smaller parts when allocation
  * fails. Partial allocation should not be an error, or you risk a live-lock.
  */
diff -puN block/blk-ioc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd block/blk-ioc.c
--- a/block/blk-ioc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/block/blk-ioc.c
@@ -289,7 +289,7 @@ struct io_context *get_task_io_context(s
 {
 	struct io_context *ioc;
 
-	might_sleep_if(gfp_flags & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(gfp_flags));
 
 	do {
 		task_lock(task);
diff -puN block/blk-mq-tag.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd block/blk-mq-tag.c
--- a/block/blk-mq-tag.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/block/blk-mq-tag.c
@@ -264,7 +264,7 @@ static int bt_get(struct blk_mq_alloc_da
 	if (tag != -1)
 		return tag;
 
-	if (!(data->gfp & __GFP_WAIT))
+	if (!gfpflags_allow_blocking(data->gfp))
 		return -1;
 
 	bs = bt_wait_ptr(bt, hctx);
diff -puN block/blk-mq.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd block/blk-mq.c
--- a/block/blk-mq.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/block/blk-mq.c
@@ -85,7 +85,7 @@ static int blk_mq_queue_enter(struct req
 		if (percpu_ref_tryget_live(&q->mq_usage_counter))
 			return 0;
 
-		if (!(gfp & __GFP_WAIT))
+		if (!gfpflags_allow_blocking(gfp))
 			return -EBUSY;
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
@@ -261,11 +261,11 @@ struct request *blk_mq_alloc_request(str
 
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
-	blk_mq_set_alloc_data(&alloc_data, q, gfp & ~__GFP_WAIT,
+	blk_mq_set_alloc_data(&alloc_data, q, gfp & ~__GFP_DIRECT_RECLAIM,
 			reserved, ctx, hctx);
 
 	rq = __blk_mq_alloc_request(&alloc_data, rw);
-	if (!rq && (gfp & __GFP_WAIT)) {
+	if (!rq && (gfp & __GFP_DIRECT_RECLAIM)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
 
@@ -1207,7 +1207,7 @@ static struct request *blk_mq_map_reques
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q,
-				__GFP_WAIT|GFP_ATOMIC, false, ctx, hctx);
+				__GFP_WAIT|__GFP_HIGH, false, ctx, hctx);
 		rq = __blk_mq_alloc_request(&alloc_data, rw);
 		ctx = alloc_data.ctx;
 		hctx = alloc_data.hctx;
diff -puN drivers/block/drbd/drbd_receiver.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/block/drbd/drbd_receiver.c
--- a/drivers/block/drbd/drbd_receiver.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/block/drbd/drbd_receiver.c
@@ -357,7 +357,8 @@ drbd_alloc_peer_req(struct drbd_peer_dev
 	}
 
 	if (has_payload && data_size) {
-		page = drbd_alloc_pages(peer_device, nr_pages, (gfp_mask & __GFP_WAIT));
+		page = drbd_alloc_pages(peer_device, nr_pages,
+					gfpflags_allow_blocking(gfp_mask));
 		if (!page)
 			goto fail;
 	}
diff -puN drivers/block/osdblk.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/block/osdblk.c
--- a/drivers/block/osdblk.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/block/osdblk.c
@@ -271,7 +271,7 @@ static struct bio *bio_chain_clone(struc
 			goto err_out;
 
 		tmp->bi_bdev = NULL;
-		gfpmask &= ~__GFP_WAIT;
+		gfpmask &= ~__GFP_DIRECT_RECLAIM;
 		tmp->bi_next = NULL;
 
 		if (!new_chain)
diff -puN drivers/connector/connector.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/connector/connector.c
--- a/drivers/connector/connector.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/connector/connector.c
@@ -124,7 +124,8 @@ int cn_netlink_send_mult(struct cn_msg *
 	if (group)
 		return netlink_broadcast(dev->nls, skb, portid, group,
 					 gfp_mask);
-	return netlink_unicast(dev->nls, skb, portid, !(gfp_mask&__GFP_WAIT));
+	return netlink_unicast(dev->nls, skb, portid,
+			!gfpflags_allow_blocking(gfp_mask));
 }
 EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
 
diff -puN drivers/firewire/core-cdev.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/firewire/core-cdev.c
--- a/drivers/firewire/core-cdev.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/firewire/core-cdev.c
@@ -486,7 +486,7 @@ static int ioctl_get_info(struct client
 static int add_client_resource(struct client *client,
 			       struct client_resource *resource, gfp_t gfp_mask)
 {
-	bool preload = !!(gfp_mask & __GFP_WAIT);
+	bool preload = gfpflags_allow_blocking(gfp_mask);
 	unsigned long flags;
 	int ret;
 
diff -puN drivers/gpu/drm/i915/i915_gem.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2215,7 +2215,7 @@ i915_gem_object_get_pages_gtt(struct drm
 	 */
 	mapping = file_inode(obj->base.filp)->i_mapping;
 	gfp = mapping_gfp_mask(mapping);
-	gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
+	gfp |= __GFP_NORETRY | __GFP_NOWARN;
 	gfp &= ~(__GFP_IO | __GFP_WAIT);
 	sg = st->sgl;
 	st->nents = 0;
diff -puN drivers/infiniband/core/sa_query.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/infiniband/core/sa_query.c
--- a/drivers/infiniband/core/sa_query.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/infiniband/core/sa_query.c
@@ -1083,7 +1083,7 @@ static void init_mad(struct ib_sa_mad *m
 
 static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 {
-	bool preload = !!(gfp_mask & __GFP_WAIT);
+	bool preload = gfpflags_allow_blocking(gfp_mask);
 	unsigned long flags;
 	int ret, id;
 
diff -puN drivers/iommu/amd_iommu.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/iommu/amd_iommu.c
@@ -2755,7 +2755,7 @@ static void *alloc_coherent(struct devic
 
 	page = alloc_pages(flag | __GFP_NOWARN,  get_order(size));
 	if (!page) {
-		if (!(flag & __GFP_WAIT))
+		if (!gfpflags_allow_blocking(flag))
 			return NULL;
 
 		page = dma_alloc_from_contiguous(dev, size >> PAGE_SHIFT,
diff -puN drivers/iommu/intel-iommu.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/iommu/intel-iommu.c
@@ -3533,7 +3533,7 @@ static void *intel_alloc_coherent(struct
 			flags |= GFP_DMA32;
 	}
 
-	if (flags & __GFP_WAIT) {
+	if (gfpflags_allow_blocking(flags)) {
 		unsigned int count = size >> PAGE_SHIFT;
 
 		page = dma_alloc_from_contiguous(dev, count, order);
diff -puN drivers/md/dm-crypt.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/md/dm-crypt.c
@@ -994,7 +994,7 @@ static struct bio *crypt_alloc_buffer(st
 	struct bio_vec *bvec;
 
 retry:
-	if (unlikely(gfp_mask & __GFP_WAIT))
+	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
 		mutex_lock(&cc->bio_alloc_lock);
 
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
@@ -1010,7 +1010,7 @@ retry:
 		if (!page) {
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
-			gfp_mask |= __GFP_WAIT;
+			gfp_mask |= __GFP_DIRECT_RECLAIM;
 			goto retry;
 		}
 
@@ -1027,7 +1027,7 @@ retry:
 	}
 
 return_clone:
-	if (unlikely(gfp_mask & __GFP_WAIT))
+	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
 		mutex_unlock(&cc->bio_alloc_lock);
 
 	return clone;
diff -puN drivers/md/dm-kcopyd.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/md/dm-kcopyd.c
--- a/drivers/md/dm-kcopyd.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/md/dm-kcopyd.c
@@ -244,7 +244,7 @@ static int kcopyd_get_pages(struct dm_kc
 	*pages = NULL;
 
 	do {
-		pl = alloc_pl(__GFP_NOWARN | __GFP_NORETRY);
+		pl = alloc_pl(__GFP_NOWARN | __GFP_NORETRY | __GFP_KSWAPD_RECLAIM);
 		if (unlikely(!pl)) {
 			/* Use reserved pages */
 			pl = kc->pages;
diff -puN drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -1291,7 +1291,7 @@ static struct solo_enc_dev *solo_enc_all
 	solo_enc->vidq.ops = &solo_enc_video_qops;
 	solo_enc->vidq.mem_ops = &vb2_dma_sg_memops;
 	solo_enc->vidq.drv_priv = solo_enc;
-	solo_enc->vidq.gfp_flags = __GFP_DMA32;
+	solo_enc->vidq.gfp_flags = __GFP_DMA32 | __GFP_KSWAPD_RECLAIM;
 	solo_enc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	solo_enc->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_enc->vidq.lock = &solo_enc->lock;
diff -puN drivers/media/pci/solo6x10/solo6x10-v4l2.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/media/pci/solo6x10/solo6x10-v4l2.c
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -675,7 +675,7 @@ int solo_v4l2_init(struct solo_dev *solo
 	solo_dev->vidq.mem_ops = &vb2_dma_contig_memops;
 	solo_dev->vidq.drv_priv = solo_dev;
 	solo_dev->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	solo_dev->vidq.gfp_flags = __GFP_DMA32;
+	solo_dev->vidq.gfp_flags = __GFP_DMA32 | __GFP_KSWAPD_RECLAIM;
 	solo_dev->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_dev->vidq.lock = &solo_dev->lock;
 	ret = vb2_queue_init(&solo_dev->vidq);
diff -puN drivers/media/pci/tw68/tw68-video.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/media/pci/tw68/tw68-video.c
--- a/drivers/media/pci/tw68/tw68-video.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/media/pci/tw68/tw68-video.c
@@ -975,7 +975,7 @@ int tw68_video_init2(struct tw68_dev *de
 	dev->vidq.ops = &tw68_video_qops;
 	dev->vidq.mem_ops = &vb2_dma_sg_memops;
 	dev->vidq.drv_priv = dev;
-	dev->vidq.gfp_flags = __GFP_DMA32;
+	dev->vidq.gfp_flags = __GFP_DMA32 | __GFP_KSWAPD_RECLAIM;
 	dev->vidq.buf_struct_size = sizeof(struct tw68_buf);
 	dev->vidq.lock = &dev->lock;
 	dev->vidq.min_buffers_needed = 2;
diff -puN drivers/mtd/mtdcore.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/mtd/mtdcore.c
@@ -1188,8 +1188,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
-		       __GFP_NORETRY | __GFP_NO_KSWAPD;
+	gfp_t flags = __GFP_NOWARN | __GFP_DIRECT_RECLAIM | __GFP_NORETRY;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -691,7 +691,7 @@ static void *bnx2x_frag_alloc(const stru
 {
 	if (fp->rx_frag_size) {
 		/* GFP_KERNEL allocations are used only during initialization */
-		if (unlikely(gfp_mask & __GFP_WAIT))
+		if (unlikely(gfpflags_allow_blocking(gfp_mask)))
 			return (void *)__get_free_page(gfp_mask);
 
 		return netdev_alloc_frag(fp->rx_frag_size);
diff -puN drivers/staging/android/ion/ion_system_heap.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/staging/android/ion/ion_system_heap.c
--- a/drivers/staging/android/ion/ion_system_heap.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/staging/android/ion/ion_system_heap.c
@@ -27,7 +27,7 @@
 #include "ion_priv.h"
 
 static gfp_t high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN |
-				     __GFP_NORETRY) & ~__GFP_WAIT;
+				     __GFP_NORETRY) & ~__GFP_DIRECT_RECLAIM;
 static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
 static const unsigned int orders[] = {8, 4, 0};
 static const int num_orders = ARRAY_SIZE(orders);
diff -puN drivers/staging/lustre/include/linux/libcfs/libcfs_private.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -95,7 +95,7 @@ do {								    \
 do {									    \
 	LASSERT(!in_interrupt() ||					    \
 		((size) <= LIBCFS_VMALLOC_SIZE &&			    \
-		 ((mask) & __GFP_WAIT) == 0));				    \
+		 !gfpflags_allow_blocking(mask)));			    \
 } while (0)
 
 #define LIBCFS_ALLOC_POST(ptr, size)					    \
diff -puN drivers/usb/host/u132-hcd.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/usb/host/u132-hcd.c
@@ -2244,7 +2244,7 @@ static int u132_urb_enqueue(struct usb_h
 {
 	struct u132 *u132 = hcd_to_u132(hcd);
 	if (irqs_disabled()) {
-		if (__GFP_WAIT & mem_flags) {
+		if (gfpflags_allow_blocking(mem_flags)) {
 			printk(KERN_ERR "invalid context for function that migh"
 				"t sleep\n");
 			return -EINVAL;
diff -puN drivers/video/fbdev/vermilion/vermilion.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd drivers/video/fbdev/vermilion/vermilion.c
--- a/drivers/video/fbdev/vermilion/vermilion.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/drivers/video/fbdev/vermilion/vermilion.c
@@ -99,7 +99,7 @@ static int vmlfb_alloc_vram_area(struct
 		 * below the first 16MB.
 		 */
 
-		flags = __GFP_DMA | __GFP_HIGH;
+		flags = __GFP_DMA | __GFP_HIGH | __GFP_KSWAPD_RECLAIM;
 		va->logical =
 			 __get_free_pages(flags, --max_order);
 	} while (va->logical == 0 && max_order > min_order);
diff -puN fs/btrfs/disk-io.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/btrfs/disk-io.c
@@ -2572,7 +2572,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 	fs_info->avg_delayed_ref_runtime = NSEC_PER_SEC >> 6; /* div by 64 */
 	/* readahead state */
-	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
+	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	spin_lock_init(&fs_info->reada_lock);
 
 	fs_info->thread_pool_size = min_t(unsigned long,
diff -puN fs/btrfs/extent_io.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/btrfs/extent_io.c
@@ -594,7 +594,7 @@ int clear_extent_bit(struct extent_io_tr
 	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		clear = 1;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
+	if (!prealloc && gfpflags_allow_blocking(mask)) {
 		/*
 		 * Don't care for allocation failure here because we might end
 		 * up not needing the pre-allocated extent state at all, which
@@ -718,7 +718,7 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (gfpflags_allow_blocking(mask))
 		cond_resched();
 	goto again;
 }
@@ -850,7 +850,7 @@ __set_extent_bit(struct extent_io_tree *
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
+	if (!prealloc && gfpflags_allow_blocking(mask)) {
 		prealloc = alloc_extent_state(mask);
 		BUG_ON(!prealloc);
 	}
@@ -1028,7 +1028,7 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (gfpflags_allow_blocking(mask))
 		cond_resched();
 	goto again;
 }
@@ -1076,7 +1076,7 @@ int convert_extent_bit(struct extent_io_
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
+	if (!prealloc && gfpflags_allow_blocking(mask)) {
 		/*
 		 * Best effort, don't worry if extent state allocation fails
 		 * here for the first iteration. We might have a cached state
@@ -1253,7 +1253,7 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (gfpflags_allow_blocking(mask))
 		cond_resched();
 	first_iteration = false;
 	goto again;
@@ -4316,7 +4316,7 @@ int try_release_extent_mapping(struct ex
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 
-	if ((mask & __GFP_WAIT) &&
+	if (gfpflags_allow_blocking(mask) &&
 	    page->mapping->host->i_size > 16 * 1024 * 1024) {
 		u64 len;
 		while (start <= end) {
diff -puN fs/btrfs/volumes.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/btrfs/volumes.c
@@ -156,8 +156,8 @@ static struct btrfs_device *__alloc_devi
 	spin_lock_init(&dev->reada_lock);
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
-	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_WAIT);
-	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_WAIT);
+	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
+	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 
 	return dev;
 }
diff -puN fs/ext4/super.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/ext4/super.c
--- a/fs/ext4/super.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/ext4/super.c
@@ -1058,7 +1058,7 @@ static int bdev_try_to_free_page(struct
 		return 0;
 	if (journal)
 		return jbd2_journal_try_to_free_buffers(journal, page,
-							wait & ~__GFP_WAIT);
+						wait & ~__GFP_DIRECT_RECLAIM);
 	return try_to_free_buffers(page);
 }
 
diff -puN fs/fscache/cookie.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/fscache/cookie.c
--- a/fs/fscache/cookie.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/fscache/cookie.c
@@ -111,7 +111,7 @@ struct fscache_cookie *__fscache_acquire
 
 	/* radix tree insertion won't use the preallocation pool unless it's
 	 * told it may not wait */
-	INIT_RADIX_TREE(&cookie->stores, GFP_NOFS & ~__GFP_WAIT);
+	INIT_RADIX_TREE(&cookie->stores, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 
 	switch (cookie->def->type) {
 	case FSCACHE_COOKIE_TYPE_INDEX:
diff -puN fs/fscache/page.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/fscache/page.c
--- a/fs/fscache/page.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/fscache/page.c
@@ -58,7 +58,7 @@ bool release_page_wait_timeout(struct fs
 
 /*
  * decide whether a page can be released, possibly by cancelling a store to it
- * - we're allowed to sleep if __GFP_WAIT is flagged
+ * - we're allowed to sleep if __GFP_DIRECT_RECLAIM is flagged
  */
 bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 				  struct page *page,
@@ -122,7 +122,7 @@ page_busy:
 	 * allocator as the work threads writing to the cache may all end up
 	 * sleeping on memory allocation, so we may need to impose a timeout
 	 * too. */
-	if (!(gfp & __GFP_WAIT) || !(gfp & __GFP_FS)) {
+	if (!(gfp & __GFP_DIRECT_RECLAIM) || !(gfp & __GFP_FS)) {
 		fscache_stat(&fscache_n_store_vmscan_busy);
 		return false;
 	}
@@ -132,7 +132,7 @@ page_busy:
 		_debug("fscache writeout timeout page: %p{%lx}",
 			page, page->index);
 
-	gfp &= ~__GFP_WAIT;
+	gfp &= ~__GFP_DIRECT_RECLAIM;
 	goto try_again;
 }
 EXPORT_SYMBOL(__fscache_maybe_release_page);
diff -puN fs/jbd2/transaction.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/jbd2/transaction.c
@@ -1937,8 +1937,8 @@ out:
  * @journal: journal for operation
  * @page: to try and free
  * @gfp_mask: we use the mask to detect how hard should we try to release
- * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
- * release the buffers.
+ * buffers. If __GFP_DIRECT_RECLAIM and __GFP_FS is set, we wait for commit
+ * code to release the buffers.
  *
  *
  * For all the buffers on this page,
diff -puN fs/nfs/file.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/nfs/file.c
--- a/fs/nfs/file.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/nfs/file.c
@@ -473,8 +473,8 @@ static int nfs_release_page(struct page
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
 
 	/* Always try to initiate a 'commit' if relevant, but only
-	 * wait for it if __GFP_WAIT is set.  Even then, only wait 1
-	 * second and only if the 'bdi' is not congested.
+	 * wait for it if the caller allows blocking.  Even then,
+	 * only wait 1 second and only if the 'bdi' is not congested.
 	 * Waiting indefinitely can cause deadlocks when the NFS
 	 * server is on this machine, when a new TCP connection is
 	 * needed and in other rare cases.  There is no particular
@@ -484,7 +484,7 @@ static int nfs_release_page(struct page
 	if (mapping) {
 		struct nfs_server *nfss = NFS_SERVER(mapping->host);
 		nfs_commit_inode(mapping->host, 0);
-		if ((gfp & __GFP_WAIT) &&
+		if (gfpflags_allow_blocking(gfp) &&
 		    !bdi_write_congested(&nfss->backing_dev_info)) {
 			wait_on_page_bit_killable_timeout(page, PG_private,
 							  HZ);
diff -puN fs/xfs/xfs_qm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/fs/xfs/xfs_qm.c
@@ -525,7 +525,7 @@ xfs_qm_shrink_scan(
 	unsigned long		freed;
 	int			error;
 
-	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
+	if ((sc->gfp_mask & (__GFP_FS|__GFP_DIRECT_RECLAIM)) != (__GFP_FS|__GFP_DIRECT_RECLAIM))
 		return 0;
 
 	INIT_LIST_HEAD(&isol.buffers);
diff -puN include/linux/gfp.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/include/linux/gfp.h
@@ -29,12 +29,13 @@ struct vm_area_struct;
 #define ___GFP_NOMEMALLOC	0x10000u
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
-#define ___GFP_WAIT		0x80000u
+#define ___GFP_ATOMIC		0x80000u
 #define ___GFP_NOACCOUNT	0x100000u
 #define ___GFP_NOTRACK		0x200000u
-#define ___GFP_NO_KSWAPD	0x400000u
+#define ___GFP_DIRECT_RECLAIM	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
+#define ___GFP_KSWAPD_RECLAIM	0x2000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -71,7 +72,7 @@ struct vm_area_struct;
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
  * mechanism or reclaimed
  */
-#define __GFP_WAIT	((__force gfp_t)___GFP_WAIT)	/* Can wait and reschedule? */
+#define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)  /* Caller cannot wait or reschedule */
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)	/* Should access emergency pools? */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)	/* Can start physical IO? */
 #define __GFP_FS	((__force gfp_t)___GFP_FS)	/* Can call down to low-level FS? */
@@ -94,23 +95,37 @@ struct vm_area_struct;
 #define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to kmemcg */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
-#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
 /*
+ * A caller that is willing to wait may enter direct reclaim and will
+ * wake kswapd to reclaim pages in the background until the high
+ * watermark is met. A caller may wish to clear __GFP_DIRECT_RECLAIM to
+ * avoid unnecessary delays when a fallback option is available but
+ * still allow kswapd to reclaim in the background. The kswapd flag
+ * can be cleared when the reclaiming of pages would cause unnecessary
+ * disruption.
+ */
+#define __GFP_WAIT ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
+#define __GFP_DIRECT_RECLAIM	((__force gfp_t)___GFP_DIRECT_RECLAIM) /* Caller can reclaim */
+#define __GFP_KSWAPD_RECLAIM	((__force gfp_t)___GFP_KSWAPD_RECLAIM) /* kswapd can wake */
+
+/*
  * This may seem redundant, but it's a way of annotating false positives vs.
  * allocations that simply cannot be supported (e.g. page tables).
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
-#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
-/* This equals 0, but use constants in case they ever change */
-#define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
-/* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
-#define GFP_ATOMIC	(__GFP_HIGH)
+/*
+ * GFP_ATOMIC callers can not sleep, need the allocation to succeed.
+ * A lower watermark is applied to allow access to "atomic reserves"
+ */
+#define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
+#define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
 #define GFP_NOIO	(__GFP_WAIT)
 #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
 #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
@@ -119,10 +134,10 @@ struct vm_area_struct;
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
-#define GFP_IOFS	(__GFP_IO | __GFP_FS)
-#define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
-			 __GFP_NO_KSWAPD)
+#define GFP_IOFS	(__GFP_IO | __GFP_FS | __GFP_KSWAPD_RECLAIM)
+#define GFP_TRANSHUGE	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
+			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN) & \
+			 ~__GFP_KSWAPD_RECLAIM)
 
 /* This mask makes up all the page movable related flags */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
@@ -164,6 +179,11 @@ static inline int gfpflags_to_migratetyp
 	return (gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
 }
 
+static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
+{
+	return gfp_flags & __GFP_DIRECT_RECLAIM;
+}
+
 #ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
diff -puN include/linux/skbuff.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd include/linux/skbuff.h
--- a/include/linux/skbuff.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/include/linux/skbuff.h
@@ -1215,7 +1215,7 @@ static inline int skb_cloned(const struc
 
 static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
 {
-	might_sleep_if(pri & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(pri));
 
 	if (skb_cloned(skb))
 		return pskb_expand_head(skb, 0, 0, pri);
@@ -1299,7 +1299,7 @@ static inline int skb_shared(const struc
  */
 static inline struct sk_buff *skb_share_check(struct sk_buff *skb, gfp_t pri)
 {
-	might_sleep_if(pri & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(pri));
 	if (skb_shared(skb)) {
 		struct sk_buff *nskb = skb_clone(skb, pri);
 
@@ -1335,7 +1335,7 @@ static inline struct sk_buff *skb_share_
 static inline struct sk_buff *skb_unshare(struct sk_buff *skb,
 					  gfp_t pri)
 {
-	might_sleep_if(pri & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(pri));
 	if (skb_cloned(skb)) {
 		struct sk_buff *nskb = skb_copy(skb, pri);
 
diff -puN include/net/sock.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd include/net/sock.h
--- a/include/net/sock.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/include/net/sock.h
@@ -2020,7 +2020,7 @@ struct sk_buff *sk_stream_alloc_skb(stru
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (sk->sk_allocation & __GFP_WAIT)
+	if (gfpflags_allow_blocking(sk->sk_allocation))
 		return &current->task_frag;
 
 	return &sk->sk_frag;
diff -puN include/trace/events/gfpflags.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/include/trace/events/gfpflags.h
@@ -20,7 +20,7 @@
 	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
 	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
 	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
-	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
+	{(unsigned long)__GFP_ATOMIC,		"GFP_ATOMIC"},		\
 	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
 	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
 	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
@@ -36,7 +36,8 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
+	{(unsigned long)__GFP_DIRECT_RECLAIM,	"GFP_DIRECT_RECLAIM"},	\
+	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"GFP_KSWAPD_RECLAIM"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
diff -puN kernel/audit.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd kernel/audit.c
--- a/kernel/audit.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/kernel/audit.c
@@ -1357,16 +1357,16 @@ struct audit_buffer *audit_log_start(str
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
-	if (gfp_mask & __GFP_WAIT) {
+	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
 		if (audit_pid && audit_pid == current->pid)
-			gfp_mask &= ~__GFP_WAIT;
+			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 		else
 			reserve = 0;
 	}
 
 	while (audit_backlog_limit
 	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
-		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
+		if (gfp_mask & __GFP_DIRECT_RECLAIM && audit_backlog_wait_time) {
 			long sleep_time;
 
 			sleep_time = timeout_start + audit_backlog_wait_time - jiffies;
diff -puN kernel/cgroup.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd kernel/cgroup.c
--- a/kernel/cgroup.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/kernel/cgroup.c
@@ -208,7 +208,7 @@ static int cgroup_idr_alloc(struct idr *
 
 	idr_preload(gfp_mask);
 	spin_lock_bh(&cgroup_idr_lock);
-	ret = idr_alloc(idr, ptr, start, end, gfp_mask & ~__GFP_WAIT);
+	ret = idr_alloc(idr, ptr, start, end, gfp_mask & ~__GFP_DIRECT_RECLAIM);
 	spin_unlock_bh(&cgroup_idr_lock);
 	idr_preload_end();
 	return ret;
diff -puN kernel/locking/lockdep.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/kernel/locking/lockdep.c
@@ -2738,7 +2738,7 @@ static void __lockdep_trace_alloc(gfp_t
 		return;
 
 	/* no reclaim without waiting on it */
-	if (!(gfp_mask & __GFP_WAIT))
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return;
 
 	/* this guy won't enter reclaim */
diff -puN kernel/power/snapshot.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/kernel/power/snapshot.c
@@ -1779,7 +1779,7 @@ alloc_highmem_pages(struct memory_bitmap
 	while (to_alloc-- > 0) {
 		struct page *page;
 
-		page = alloc_image_page(__GFP_HIGHMEM);
+		page = alloc_image_page(__GFP_HIGHMEM|__GFP_KSWAPD_RECLAIM);
 		memory_bm_set_bit(bm, page_to_pfn(page));
 	}
 	return nr_highmem;
diff -puN kernel/smp.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd kernel/smp.c
--- a/kernel/smp.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/kernel/smp.c
@@ -669,7 +669,7 @@ void on_each_cpu_cond(bool (*cond_func)(
 	cpumask_var_t cpus;
 	int cpu, ret;
 
-	might_sleep_if(gfp_flags & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(gfp_flags));
 
 	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
 		preempt_disable();
diff -puN lib/idr.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd lib/idr.c
--- a/lib/idr.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/lib/idr.c
@@ -399,7 +399,7 @@ void idr_preload(gfp_t gfp_mask)
 	 * allocation guarantee.  Disallow usage from those contexts.
 	 */
 	WARN_ON_ONCE(in_interrupt());
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 
 	preempt_disable();
 
@@ -453,7 +453,7 @@ int idr_alloc(struct idr *idr, void *ptr
 	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	int id;
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 
 	/* sanity checks */
 	if (WARN_ON_ONCE(start < 0))
diff -puN lib/radix-tree.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd lib/radix-tree.c
--- a/lib/radix-tree.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/lib/radix-tree.c
@@ -188,7 +188,7 @@ radix_tree_node_alloc(struct radix_tree_
 	 * preloading in the interrupt anyway as all the allocations have to
 	 * be atomic. So just do normal allocation when in interrupt.
 	 */
-	if (!(gfp_mask & __GFP_WAIT) && !in_interrupt()) {
+	if (!gfpflags_allow_blocking(gfp_mask) && !in_interrupt()) {
 		struct radix_tree_preload *rtp;
 
 		/*
@@ -249,7 +249,7 @@ radix_tree_node_free(struct radix_tree_n
  * with preemption not disabled.
  *
  * To make use of this facility, the radix tree must be initialised without
- * __GFP_WAIT being passed to INIT_RADIX_TREE().
+ * __GFP_DIRECT_RECLAIM being passed to INIT_RADIX_TREE().
  */
 static int __radix_tree_preload(gfp_t gfp_mask)
 {
@@ -286,12 +286,12 @@ out:
  * with preemption not disabled.
  *
  * To make use of this facility, the radix tree must be initialised without
- * __GFP_WAIT being passed to INIT_RADIX_TREE().
+ * __GFP_DIRECT_RECLAIM being passed to INIT_RADIX_TREE().
  */
 int radix_tree_preload(gfp_t gfp_mask)
 {
 	/* Warn on non-sensical use... */
-	WARN_ON_ONCE(!(gfp_mask & __GFP_WAIT));
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp_mask));
 	return __radix_tree_preload(gfp_mask);
 }
 EXPORT_SYMBOL(radix_tree_preload);
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(radix_tree_preload);
  */
 int radix_tree_maybe_preload(gfp_t gfp_mask)
 {
-	if (gfp_mask & __GFP_WAIT)
+	if (gfpflags_allow_blocking(gfp_mask))
 		return __radix_tree_preload(gfp_mask);
 	/* Preloading doesn't help anything with this gfp mask, skip it */
 	preempt_disable();
diff -puN mm/backing-dev.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/backing-dev.c
--- a/mm/backing-dev.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/backing-dev.c
@@ -632,7 +632,7 @@ struct bdi_writeback *wb_get_create(stru
 {
 	struct bdi_writeback *wb;
 
-	might_sleep_if(gfp & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(gfp));
 
 	if (!memcg_css->parent)
 		return &bdi->wb;
diff -puN mm/dmapool.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/dmapool.c
--- a/mm/dmapool.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/dmapool.c
@@ -326,7 +326,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	size_t offset;
 	void *retval;
 
-	might_sleep_if(mem_flags & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(mem_flags));
 
 	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
diff -puN mm/memcontrol.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/memcontrol.c
@@ -2046,7 +2046,7 @@ retry:
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
-	if (!(gfp_mask & __GFP_WAIT))
+	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
 	mem_cgroup_events(mem_over_limit, MEMCG_MAX, 1);
@@ -4421,8 +4421,8 @@ static int mem_cgroup_do_precharge(unsig
 {
 	int ret;
 
-	/* Try a single bulk charge without reclaim first */
-	ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_WAIT, count);
+	/* Try a single bulk charge without reclaim first, kswapd may wake */
+	ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_DIRECT_RECLAIM, count);
 	if (!ret) {
 		mc.precharge += count;
 		return ret;
diff -puN mm/mempool.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/mempool.c
--- a/mm/mempool.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/mempool.c
@@ -320,13 +320,13 @@ void * mempool_alloc(mempool_t *pool, gf
 	gfp_t gfp_temp;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
 	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
 
-	gfp_temp = gfp_mask & ~(__GFP_WAIT|__GFP_IO);
+	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
 
@@ -349,7 +349,7 @@ repeat_alloc:
 	}
 
 	/*
-	 * We use gfp mask w/o __GFP_WAIT or IO for the first round.  If
+	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
 	 * alloc failed with that and @pool was empty, retry immediately.
 	 */
 	if (gfp_temp != gfp_mask) {
@@ -358,8 +358,8 @@ repeat_alloc:
 		goto repeat_alloc;
 	}
 
-	/* We must not sleep if !__GFP_WAIT */
-	if (!(gfp_mask & __GFP_WAIT)) {
+	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		return NULL;
 	}
diff -puN mm/migrate.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/migrate.c
--- a/mm/migrate.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/migrate.c
@@ -1576,7 +1576,7 @@ static struct page *alloc_misplaced_dst_
 					 (GFP_HIGHUSER_MOVABLE |
 					  __GFP_THISNODE | __GFP_NOMEMALLOC |
 					  __GFP_NORETRY | __GFP_NOWARN) &
-					 ~GFP_IOFS, 0);
+					 ~(__GFP_IO | __GFP_FS), 0);
 
 	return newpage;
 }
diff -puN mm/page_alloc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/page_alloc.c
@@ -169,12 +169,12 @@ void pm_restrict_gfp_mask(void)
 	WARN_ON(!mutex_is_locked(&pm_mutex));
 	WARN_ON(saved_gfp_mask);
 	saved_gfp_mask = gfp_allowed_mask;
-	gfp_allowed_mask &= ~GFP_IOFS;
+	gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
 }
 
 bool pm_suspended_storage(void)
 {
-	if ((gfp_allowed_mask & GFP_IOFS) == GFP_IOFS)
+	if ((gfp_allowed_mask & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS))
 		return false;
 	return true;
 }
@@ -2183,7 +2183,7 @@ static bool should_fail_alloc_page(gfp_t
 		return false;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return false;
-	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
+	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
 	return should_fail(&fail_page_alloc.attr, 1 << order);
@@ -2685,7 +2685,7 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		if (test_thread_flag(TIF_MEMDIE) ||
 		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
 			filter &= ~SHOW_MEM_FILTER_NODES;
-	if (in_interrupt() || !(gfp_mask & __GFP_WAIT))
+	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
 	if (fmt) {
@@ -2945,7 +2945,6 @@ static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
-	const bool atomic = !(gfp_mask & (__GFP_WAIT | __GFP_NO_KSWAPD));
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
@@ -2954,11 +2953,11 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (atomic == true) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_HIGH (__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
-	if (atomic) {
+	if (gfp_mask & __GFP_ATOMIC) {
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
@@ -2995,11 +2994,16 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
 }
 
+static inline bool is_thp_gfp_mask(gfp_t gfp_mask)
+{
+	return (gfp_mask & (GFP_TRANSHUGE | __GFP_KSWAPD_RECLAIM)) == GFP_TRANSHUGE;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	const gfp_t wait = gfp_mask & __GFP_WAIT;
+	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
@@ -3020,15 +3024,23 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	}
 
 	/*
+	 * We also sanity check to catch abuse of atomic reserves being used by
+	 * callers that are not in atomic context.
+	 */
+	if (WARN_ON_ONCE((gfp_mask & (__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)) ==
+				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
+		gfp_mask &= ~__GFP_ATOMIC;
+
+	/*
 	 * If this allocation cannot block and it is for a specific node, then
 	 * fail early.  There's no need to wakeup kswapd or retry for a
 	 * speculative node-specific allocation.
 	 */
-	if (IS_ENABLED(CONFIG_NUMA) && (gfp_mask & __GFP_THISNODE) && !wait)
+	if (IS_ENABLED(CONFIG_NUMA) && (gfp_mask & __GFP_THISNODE) && !can_direct_reclaim)
 		goto nopage;
 
 retry:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		wake_all_kswapds(order, ac);
 
 	/*
@@ -3071,8 +3083,8 @@ retry:
 		}
 	}
 
-	/* Atomic allocations - we can't balance anything */
-	if (!wait) {
+	/* Caller is not willing to reclaim, we can't balance anything */
+	if (!can_direct_reclaim) {
 		/*
 		 * All existing users of the deprecated __GFP_NOFAIL are
 		 * blockable, so warn of any new users that actually allow this
@@ -3102,7 +3114,7 @@ retry:
 		goto got_pg;
 
 	/* Checks for THP-specific high-order allocations */
-	if ((gfp_mask & GFP_TRANSHUGE) == GFP_TRANSHUGE) {
+	if (is_thp_gfp_mask(gfp_mask)) {
 		/*
 		 * If compaction is deferred for high-order allocations, it is
 		 * because sync compaction recently failed. If this is the case
@@ -3137,8 +3149,7 @@ retry:
 	 * fault, so use asynchronous memory compaction for THP unless it is
 	 * khugepaged trying to collapse.
 	 */
-	if ((gfp_mask & GFP_TRANSHUGE) != GFP_TRANSHUGE ||
-						(current->flags & PF_KTHREAD))
+	if (!is_thp_gfp_mask(gfp_mask) || (current->flags & PF_KTHREAD))
 		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/* Try direct reclaim and then allocating */
@@ -3209,7 +3220,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 
 	lockdep_trace_alloc(gfp_mask);
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
diff -puN mm/slab.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/slab.c
--- a/mm/slab.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/slab.c
@@ -1030,12 +1030,12 @@ static inline int cache_free_alien(struc
 }
 
 /*
- * Construct gfp mask to allocate from a specific node but do not invoke reclaim
- * or warn about failures.
+ * Construct gfp mask to allocate from a specific node but do not direct reclaim
+ * or warn about failures. kswapd may still wake to reclaim in the background.
  */
 static inline gfp_t gfp_exact_node(gfp_t flags)
 {
-	return (flags | __GFP_THISNODE | __GFP_NOWARN) & ~__GFP_WAIT;
+	return (flags | __GFP_THISNODE | __GFP_NOWARN) & ~__GFP_DIRECT_RECLAIM;
 }
 #endif
 
@@ -2632,7 +2632,7 @@ static int cache_grow(struct kmem_cache
 
 	offset *= cachep->colour_off;
 
-	if (local_flags & __GFP_WAIT)
+	if (gfpflags_allow_blocking(local_flags))
 		local_irq_enable();
 
 	/*
@@ -2662,7 +2662,7 @@ static int cache_grow(struct kmem_cache
 
 	cache_init_objs(cachep, page);
 
-	if (local_flags & __GFP_WAIT)
+	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
 	check_irq_off();
 	spin_lock(&n->list_lock);
@@ -2676,7 +2676,7 @@ static int cache_grow(struct kmem_cache
 opps1:
 	kmem_freepages(cachep, page);
 failed:
-	if (local_flags & __GFP_WAIT)
+	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
 	return 0;
 }
@@ -2868,7 +2868,7 @@ force_grow:
 static inline void cache_alloc_debugcheck_before(struct kmem_cache *cachep,
 						gfp_t flags)
 {
-	might_sleep_if(flags & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(flags));
 #if DEBUG
 	kmem_flagcheck(cachep, flags);
 #endif
@@ -3056,11 +3056,11 @@ retry:
 		 */
 		struct page *page;
 
-		if (local_flags & __GFP_WAIT)
+		if (gfpflags_allow_blocking(local_flags))
 			local_irq_enable();
 		kmem_flagcheck(cache, flags);
 		page = kmem_getpages(cache, local_flags, numa_mem_id());
-		if (local_flags & __GFP_WAIT)
+		if (gfpflags_allow_blocking(local_flags))
 			local_irq_disable();
 		if (page) {
 			/*
diff -puN mm/slub.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/slub.c
--- a/mm/slub.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/slub.c
@@ -1263,7 +1263,7 @@ static inline struct kmem_cache *slab_pr
 {
 	flags &= gfp_allowed_mask;
 	lockdep_trace_alloc(flags);
-	might_sleep_if(flags & __GFP_WAIT);
+	might_sleep_if(gfpflags_allow_blocking(flags));
 
 	if (should_failslab(s->object_size, flags, s->flags))
 		return NULL;
@@ -1352,7 +1352,7 @@ static struct page *allocate_slab(struct
 
 	flags &= gfp_allowed_mask;
 
-	if (flags & __GFP_WAIT)
+	if (gfpflags_allow_blocking(flags))
 		local_irq_enable();
 
 	flags |= s->allocflags;
@@ -1362,8 +1362,8 @@ static struct page *allocate_slab(struct
 	 * so we fall-back to the minimum order allocation.
 	 */
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
-	if ((alloc_gfp & __GFP_WAIT) && oo_order(oo) > oo_order(s->min))
-		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_WAIT;
+	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
+		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_DIRECT_RECLAIM;
 
 	page = alloc_slab_page(s, alloc_gfp, node, oo);
 	if (unlikely(!page)) {
@@ -1423,7 +1423,7 @@ static struct page *allocate_slab(struct
 	page->frozen = 1;
 
 out:
-	if (flags & __GFP_WAIT)
+	if (gfpflags_allow_blocking(flags))
 		local_irq_disable();
 	if (!page)
 		return NULL;
diff -puN mm/vmalloc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/vmalloc.c
--- a/mm/vmalloc.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/vmalloc.c
@@ -1617,7 +1617,7 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
-		if (gfp_mask & __GFP_WAIT)
+		if (gfpflags_allow_blocking(gfp_mask))
 			cond_resched();
 	}
 
diff -puN mm/vmscan.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/vmscan.c
@@ -1476,7 +1476,7 @@ static int too_many_isolated(struct zone
 	 * won't get blocked by normal direct-reclaimers, forming a circular
 	 * deadlock.
 	 */
-	if ((sc->gfp_mask & GFP_IOFS) == GFP_IOFS)
+	if ((sc->gfp_mask & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS))
 		inactive >>= 3;
 
 	return isolated > inactive;
@@ -3791,7 +3791,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
-	if (!(gfp_mask & __GFP_WAIT) || (current->flags & PF_MEMALLOC))
+	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
 		return ZONE_RECLAIM_NOSCAN;
 
 	/*
diff -puN mm/zswap.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd mm/zswap.c
--- a/mm/zswap.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/mm/zswap.c
@@ -571,7 +571,7 @@ static struct zswap_pool *zswap_pool_fin
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
-	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN;
+	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
@@ -1011,7 +1011,8 @@ static int zswap_frontswap_store(unsigne
 	/* store */
 	len = dlen + sizeof(struct zswap_header);
 	ret = zpool_malloc(entry->pool->zpool, len,
-			   __GFP_NORETRY | __GFP_NOWARN, &handle);
+			   __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM,
+			   &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto put_dstmem;
diff -puN net/core/skbuff.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/core/skbuff.c
--- a/net/core/skbuff.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/core/skbuff.c
@@ -414,7 +414,7 @@ struct sk_buff *__netdev_alloc_skb(struc
 	len += NET_SKB_PAD;
 
 	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
-	    (gfp_mask & (__GFP_WAIT | GFP_DMA))) {
+	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
 			goto skb_fail;
@@ -481,7 +481,7 @@ struct sk_buff *__napi_alloc_skb(struct
 	len += NET_SKB_PAD + NET_IP_ALIGN;
 
 	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
-	    (gfp_mask & (__GFP_WAIT | GFP_DMA))) {
+	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
 			goto skb_fail;
@@ -4451,7 +4451,7 @@ struct sk_buff *alloc_skb_with_frags(uns
 		return NULL;
 
 	gfp_head = gfp_mask;
-	if (gfp_head & __GFP_WAIT)
+	if (gfp_head & __GFP_DIRECT_RECLAIM)
 		gfp_head |= __GFP_REPEAT;
 
 	*errcode = -ENOBUFS;
@@ -4466,7 +4466,7 @@ struct sk_buff *alloc_skb_with_frags(uns
 
 		while (order) {
 			if (npages >= 1 << order) {
-				page = alloc_pages((gfp_mask & ~__GFP_WAIT) |
+				page = alloc_pages((gfp_mask & ~__GFP_DIRECT_RECLAIM) |
 						   __GFP_COMP |
 						   __GFP_NOWARN |
 						   __GFP_NORETRY,
diff -puN net/core/sock.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/core/sock.c
--- a/net/core/sock.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/core/sock.c
@@ -1879,8 +1879,10 @@ bool skb_page_frag_refill(unsigned int s
 
 	pfrag->offset = 0;
 	if (SKB_FRAG_PAGE_ORDER) {
-		pfrag->page = alloc_pages((gfp & ~__GFP_WAIT) | __GFP_COMP |
-					  __GFP_NOWARN | __GFP_NORETRY,
+		/* Avoid direct reclaim but allow kswapd to wake */
+		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
+					  __GFP_COMP | __GFP_NOWARN |
+					  __GFP_NORETRY,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
diff -puN net/netlink/af_netlink.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/netlink/af_netlink.c
@@ -2116,7 +2116,7 @@ int netlink_broadcast_filtered(struct so
 	consume_skb(info.skb2);
 
 	if (info.delivered) {
-		if (info.congested && (allocation & __GFP_WAIT))
+		if (info.congested && gfpflags_allow_blocking(allocation))
 			yield();
 		return 0;
 	}
diff -puN net/rds/ib_recv.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/rds/ib_recv.c
--- a/net/rds/ib_recv.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/rds/ib_recv.c
@@ -305,7 +305,7 @@ static int rds_ib_recv_refill_one(struct
 	gfp_t slab_mask = GFP_NOWAIT;
 	gfp_t page_mask = GFP_NOWAIT;
 
-	if (gfp & __GFP_WAIT) {
+	if (gfp & __GFP_DIRECT_RECLAIM) {
 		slab_mask = GFP_KERNEL;
 		page_mask = GFP_HIGHUSER;
 	}
@@ -379,7 +379,7 @@ void rds_ib_recv_refill(struct rds_conne
 	struct ib_recv_wr *failed_wr;
 	unsigned int posted = 0;
 	int ret = 0;
-	bool can_wait = !!(gfp & __GFP_WAIT);
+	bool can_wait = !!(gfp & __GFP_DIRECT_RECLAIM);
 	u32 pos;
 
 	/* the goal here is to just make sure that someone, somewhere
diff -puN net/rxrpc/ar-connection.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/rxrpc/ar-connection.c
--- a/net/rxrpc/ar-connection.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/rxrpc/ar-connection.c
@@ -500,7 +500,7 @@ int rxrpc_connect_call(struct rxrpc_sock
 		if (bundle->num_conns >= 20) {
 			_debug("too many conns");
 
-			if (!(gfp & __GFP_WAIT)) {
+			if (!gfpflags_allow_blocking(gfp)) {
 				_leave(" = -EAGAIN");
 				return -EAGAIN;
 			}
diff -puN net/sctp/associola.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd net/sctp/associola.c
--- a/net/sctp/associola.c~mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd
+++ a/net/sctp/associola.c
@@ -1588,7 +1588,7 @@ int sctp_assoc_lookup_laddr(struct sctp_
 /* Set an association id for a given association */
 int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 {
-	bool preload = !!(gfp & __GFP_WAIT);
+	bool preload = gfpflags_allow_blocking(gfp);
 	int ret;
 
 	/* If the id is already assigned, keep it. */
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

