From: akpm@linux-foundation.org
Subject: + mm-remove-__gfp_cold.patch added to -mm tree
Date: Wed, 18 Oct 2017 15:17:01 -0700
Message-ID: <59e7d2dd.iTGjSw4ZzkB3qWbS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdJRWRD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __GFP_COLD
has been added to the -mm tree.  Its filename is
     mm-remove-__gfp_cold.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-__gfp_cold.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-__gfp_cold.patch

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
Subject: mm: remove __GFP_COLD

As the page free path makes no distinction between cache hot and cold
pages, there is no real useful ordering of pages in the free list that
allocation requests can take advantage of.  Juding from the users of
__GFP_COLD, it is likely that a number of them are the result of copying
other sites instead of actually measuring the impact.  Remove the
__GFP_COLD parameter which simplifies a number of paths in the page
allocator.

This is potentially controversial but bear in mind that the size of the
per-cpu pagelists versus modern cache sizes means that the whole per-cpu
list can often fit in the L3 cache.  Hence, there is only a potential
benefit for microbenchmarks that alloc/free pages in a tight loop.  It's
even worse when THP is taken into account which has little or no chance of
getting a cache-hot page as the per-cpu list is bypassed and the zeroing
of multiple pages will thrash the cache anyway.

The truncate microbenchmarks are not shown as this patch affects the
allocation path and not the free path.  A page fault microbenchmark was
tested but it showed no sigificant difference which is not surprising
given that the __GFP_COLD branches are a miniscule percentage of the fault
path.

Link: http://lkml.kernel.org/r/20171018075952.10627-9-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amazon/ena/ena_netdev.c          |    2 -
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c             |    2 -
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c      |    3 -
 drivers/net/ethernet/cavium/liquidio/octeon_network.h |    2 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c            |    5 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c   |    4 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c          |    3 -
 drivers/net/ethernet/sfc/falcon/rx.c                  |    2 -
 drivers/net/ethernet/sfc/rx.c                         |    2 -
 drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c       |    2 -
 drivers/net/ethernet/ti/netcp_core.c                  |    2 -
 drivers/net/virtio_net.c                              |    1 
 drivers/staging/lustre/lustre/mdc/mdc_request.c       |    2 -
 fs/cachefiles/rdwr.c                                  |    6 +--
 include/linux/gfp.h                                   |    5 --
 include/linux/pagemap.h                               |    8 ----
 include/linux/skbuff.h                                |    2 -
 include/linux/slab.h                                  |    3 -
 include/trace/events/mmflags.h                        |    1 
 kernel/power/snapshot.c                               |    4 +-
 mm/filemap.c                                          |    6 +--
 mm/page_alloc.c                                       |   20 +++-------
 mm/percpu-vm.c                                        |    2 -
 net/core/skbuff.c                                     |    4 +-
 tools/perf/builtin-kmem.c                             |    1 
 25 files changed, 32 insertions(+), 62 deletions(-)

diff -puN drivers/net/ethernet/amazon/ena/ena_netdev.c~mm-remove-__gfp_cold drivers/net/ethernet/amazon/ena/ena_netdev.c
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -517,7 +517,7 @@ static int ena_refill_rx_bufs(struct ena
 
 
 		rc = ena_alloc_rx_page(rx_ring, rx_info,
-				       __GFP_COLD | GFP_ATOMIC | __GFP_COMP);
+				       GFP_ATOMIC | __GFP_COMP);
 		if (unlikely(rc < 0)) {
 			netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
 				   "failed to alloc buffer for rx queue %d\n",
diff -puN drivers/net/ethernet/amd/xgbe/xgbe-desc.c~mm-remove-__gfp_cold drivers/net/ethernet/amd/xgbe/xgbe-desc.c
--- a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
@@ -295,7 +295,7 @@ again:
 	order = alloc_order;
 
 	/* Try to obtain pages, decreasing order if necessary */
-	gfp = GFP_ATOMIC | __GFP_COLD | __GFP_COMP | __GFP_NOWARN;
+	gfp = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
 	while (order >= 0) {
 		pages = alloc_pages_node(node, gfp, order);
 		if (pages)
diff -puN drivers/net/ethernet/aquantia/atlantic/aq_ring.c~mm-remove-__gfp_cold drivers/net/ethernet/aquantia/atlantic/aq_ring.c
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -304,8 +304,7 @@ int aq_ring_rx_fill(struct aq_ring_s *se
 		buff->flags = 0U;
 		buff->len = AQ_CFG_RX_FRAME_MAX;
 
-		buff->page = alloc_pages(GFP_ATOMIC | __GFP_COLD |
-					 __GFP_COMP, pages_order);
+		buff->page = alloc_pages(GFP_ATOMIC | __GFP_COMP, pages_order);
 		if (!buff->page) {
 			err = -ENOMEM;
 			goto err_exit;
diff -puN drivers/net/ethernet/cavium/liquidio/octeon_network.h~mm-remove-__gfp_cold drivers/net/ethernet/cavium/liquidio/octeon_network.h
--- a/drivers/net/ethernet/cavium/liquidio/octeon_network.h~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/cavium/liquidio/octeon_network.h
@@ -195,7 +195,7 @@ static inline void
 	struct sk_buff *skb;
 	struct octeon_skb_page_info *skb_pg_info;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_COLD);
+	page = alloc_page(GFP_ATOMIC);
 	if (unlikely(!page))
 		return NULL;
 
diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~mm-remove-__gfp_cold drivers/net/ethernet/mellanox/mlx4/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -193,7 +193,7 @@ static int mlx4_en_fill_rx_buffers(struc
 
 			if (mlx4_en_prepare_rx_desc(priv, ring,
 						    ring->actual_size,
-						    GFP_KERNEL | __GFP_COLD)) {
+						    GFP_KERNEL)) {
 				if (ring->actual_size < MLX4_EN_MIN_RX_SIZE) {
 					en_err(priv, "Failed to allocate enough rx buffers\n");
 					return -ENOMEM;
@@ -552,8 +552,7 @@ static void mlx4_en_refill_rx_buffers(st
 	do {
 		if (mlx4_en_prepare_rx_desc(priv, ring,
 					    ring->prod & ring->size_mask,
-					    GFP_ATOMIC | __GFP_COLD |
-					    __GFP_MEMALLOC))
+					    GFP_ATOMIC | __GFP_MEMALLOC))
 			break;
 		ring->prod++;
 	} while (likely(--missing));
diff -puN drivers/net/ethernet/netronome/nfp/nfp_net_common.c~mm-remove-__gfp_cold drivers/net/ethernet/netronome/nfp/nfp_net_common.c
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1183,7 +1183,7 @@ static void *nfp_net_rx_alloc_one(struct
 	if (!dp->xdp_prog)
 		frag = netdev_alloc_frag(dp->fl_bufsz);
 	else
-		frag = page_address(alloc_page(GFP_KERNEL | __GFP_COLD));
+		frag = page_address(alloc_page(GFP_KERNEL));
 	if (!frag) {
 		nn_dp_warn(dp, "Failed to alloc receive page frag\n");
 		return NULL;
@@ -1206,7 +1206,7 @@ static void *nfp_net_napi_alloc_one(stru
 	if (!dp->xdp_prog)
 		frag = napi_alloc_frag(dp->fl_bufsz);
 	else
-		frag = page_address(alloc_page(GFP_ATOMIC | __GFP_COLD));
+		frag = page_address(alloc_page(GFP_ATOMIC));
 	if (!frag) {
 		nn_dp_warn(dp, "Failed to alloc receive page frag\n");
 		return NULL;
diff -puN drivers/net/ethernet/qlogic/qlge/qlge_main.c~mm-remove-__gfp_cold drivers/net/ethernet/qlogic/qlge/qlge_main.c
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -1092,8 +1092,7 @@ static int ql_get_next_chunk(struct ql_a
 {
 	if (!rx_ring->pg_chunk.page) {
 		u64 map;
-		rx_ring->pg_chunk.page = alloc_pages(__GFP_COLD | __GFP_COMP |
-						GFP_ATOMIC,
+		rx_ring->pg_chunk.page = alloc_pages(__GFP_COMP | GFP_ATOMIC,
 						qdev->lbq_buf_order);
 		if (unlikely(!rx_ring->pg_chunk.page)) {
 			netif_err(qdev, drv, qdev->ndev,
diff -puN drivers/net/ethernet/sfc/falcon/rx.c~mm-remove-__gfp_cold drivers/net/ethernet/sfc/falcon/rx.c
--- a/drivers/net/ethernet/sfc/falcon/rx.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/sfc/falcon/rx.c
@@ -163,7 +163,7 @@ static int ef4_init_rx_buffers(struct ef
 	do {
 		page = ef4_reuse_page(rx_queue);
 		if (page == NULL) {
-			page = alloc_pages(__GFP_COLD | __GFP_COMP |
+			page = alloc_pages(__GFP_COMP |
 					   (atomic ? GFP_ATOMIC : GFP_KERNEL),
 					   efx->rx_buffer_order);
 			if (unlikely(page == NULL))
diff -puN drivers/net/ethernet/sfc/rx.c~mm-remove-__gfp_cold drivers/net/ethernet/sfc/rx.c
--- a/drivers/net/ethernet/sfc/rx.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/sfc/rx.c
@@ -163,7 +163,7 @@ static int efx_init_rx_buffers(struct ef
 	do {
 		page = efx_reuse_page(rx_queue);
 		if (page == NULL) {
-			page = alloc_pages(__GFP_COLD | __GFP_COMP |
+			page = alloc_pages(__GFP_COMP |
 					   (atomic ? GFP_ATOMIC : GFP_KERNEL),
 					   efx->rx_buffer_order);
 			if (unlikely(page == NULL))
diff -puN drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c~mm-remove-__gfp_cold drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
@@ -335,7 +335,7 @@ static int xlgmac_alloc_pages(struct xlg
 	dma_addr_t pages_dma;
 
 	/* Try to obtain pages, decreasing order if necessary */
-	gfp |= __GFP_COLD | __GFP_COMP | __GFP_NOWARN;
+	gfp |= __GFP_COMP | __GFP_NOWARN;
 	while (order >= 0) {
 		pages = alloc_pages(gfp, order);
 		if (pages)
diff -puN drivers/net/ethernet/ti/netcp_core.c~mm-remove-__gfp_cold drivers/net/ethernet/ti/netcp_core.c
--- a/drivers/net/ethernet/ti/netcp_core.c~mm-remove-__gfp_cold
+++ a/drivers/net/ethernet/ti/netcp_core.c
@@ -906,7 +906,7 @@ static int netcp_allocate_rx_buf(struct
 		sw_data[0] = (u32)bufptr;
 	} else {
 		/* Allocate a secondary receive queue entry */
-		page = alloc_page(GFP_ATOMIC | GFP_DMA | __GFP_COLD);
+		page = alloc_page(GFP_ATOMIC | GFP_DMA);
 		if (unlikely(!page)) {
 			dev_warn_ratelimited(netcp->ndev_dev, "Secondary page alloc failed\n");
 			goto fail;
diff -puN drivers/net/virtio_net.c~mm-remove-__gfp_cold drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~mm-remove-__gfp_cold
+++ a/drivers/net/virtio_net.c
@@ -988,7 +988,6 @@ static bool try_fill_recv(struct virtnet
 	int err;
 	bool oom;
 
-	gfp |= __GFP_COLD;
 	do {
 		if (vi->mergeable_rx_bufs)
 			err = add_recvbuf_mergeable(vi, rq, gfp);
diff -puN drivers/staging/lustre/lustre/mdc/mdc_request.c~mm-remove-__gfp_cold drivers/staging/lustre/lustre/mdc/mdc_request.c
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c~mm-remove-__gfp_cold
+++ a/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1151,7 +1151,7 @@ static int mdc_read_page_remote(void *da
 	}
 
 	for (npages = 1; npages < max_pages; npages++) {
-		page = page_cache_alloc_cold(inode->i_mapping);
+		page = page_cache_alloc(inode->i_mapping);
 		if (!page)
 			break;
 		page_pool[npages] = page;
diff -puN fs/cachefiles/rdwr.c~mm-remove-__gfp_cold fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~mm-remove-__gfp_cold
+++ a/fs/cachefiles/rdwr.c
@@ -256,8 +256,7 @@ static int cachefiles_read_backing_file_
 			goto backing_page_already_present;
 
 		if (!newpage) {
-			newpage = __page_cache_alloc(cachefiles_gfp |
-						     __GFP_COLD);
+			newpage = __page_cache_alloc(cachefiles_gfp);
 			if (!newpage)
 				goto nomem_monitor;
 		}
@@ -493,8 +492,7 @@ static int cachefiles_read_backing_file(
 				goto backing_page_already_present;
 
 			if (!newpage) {
-				newpage = __page_cache_alloc(cachefiles_gfp |
-							     __GFP_COLD);
+				newpage = __page_cache_alloc(cachefiles_gfp);
 				if (!newpage)
 					goto nomem;
 			}
diff -puN include/linux/gfp.h~mm-remove-__gfp_cold include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-__gfp_cold
+++ a/include/linux/gfp.h
@@ -23,7 +23,6 @@ struct vm_area_struct;
 #define ___GFP_HIGH		0x20u
 #define ___GFP_IO		0x40u
 #define ___GFP_FS		0x80u
-#define ___GFP_COLD		0x100u
 #define ___GFP_NOWARN		0x200u
 #define ___GFP_RETRY_MAYFAIL	0x400u
 #define ___GFP_NOFAIL		0x800u
@@ -191,16 +190,12 @@ struct vm_area_struct;
 /*
  * Action modifiers
  *
- * __GFP_COLD indicates that the caller does not expect to be used in the near
- *   future. Where possible, a cache-cold page will be returned.
- *
  * __GFP_NOWARN suppresses allocation failure reports.
  *
  * __GFP_COMP address compound page metadata.
  *
  * __GFP_ZERO returns a zeroed page on success.
  */
-#define __GFP_COLD	((__force gfp_t)___GFP_COLD)
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
diff -puN include/linux/pagemap.h~mm-remove-__gfp_cold include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-remove-__gfp_cold
+++ a/include/linux/pagemap.h
@@ -233,15 +233,9 @@ static inline struct page *page_cache_al
 	return __page_cache_alloc(mapping_gfp_mask(x));
 }
 
-static inline struct page *page_cache_alloc_cold(struct address_space *x)
-{
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
-}
-
 static inline gfp_t readahead_gfp_mask(struct address_space *x)
 {
-	return mapping_gfp_mask(x) |
-				  __GFP_COLD | __GFP_NORETRY | __GFP_NOWARN;
+	return mapping_gfp_mask(x) | __GFP_NORETRY | __GFP_NOWARN;
 }
 
 typedef int filler_t(void *, struct page *);
diff -puN include/linux/skbuff.h~mm-remove-__gfp_cold include/linux/skbuff.h
--- a/include/linux/skbuff.h~mm-remove-__gfp_cold
+++ a/include/linux/skbuff.h
@@ -2672,7 +2672,7 @@ static inline struct page *__dev_alloc_p
 	 * 4.  __GFP_MEMALLOC is ignored if __GFP_NOMEMALLOC is set due to
 	 *     code in gfp_to_alloc_flags that should be enforcing this.
 	 */
-	gfp_mask |= __GFP_COLD | __GFP_COMP | __GFP_MEMALLOC;
+	gfp_mask |= __GFP_COMP | __GFP_MEMALLOC;
 
 	return alloc_pages_node(NUMA_NO_NODE, gfp_mask, order);
 }
diff -puN include/linux/slab.h~mm-remove-__gfp_cold include/linux/slab.h
--- a/include/linux/slab.h~mm-remove-__gfp_cold
+++ a/include/linux/slab.h
@@ -452,9 +452,6 @@ static __always_inline void *kmalloc_lar
  * Also it is possible to set different flags by OR'ing
  * in one or more of the following additional @flags:
  *
- * %__GFP_COLD - Request cache-cold pages instead of
- *   trying to return cache-warm pages.
- *
  * %__GFP_HIGH - This allocation has high priority and may use emergency pools.
  *
  * %__GFP_NOFAIL - Indicate that this allocation is in no way allowed to fail
diff -puN include/trace/events/mmflags.h~mm-remove-__gfp_cold include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-remove-__gfp_cold
+++ a/include/trace/events/mmflags.h
@@ -31,7 +31,6 @@
 	{(unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
 	{(unsigned long)__GFP_IO,		"__GFP_IO"},		\
 	{(unsigned long)__GFP_FS,		"__GFP_FS"},		\
-	{(unsigned long)__GFP_COLD,		"__GFP_COLD"},		\
 	{(unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
 	{(unsigned long)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},	\
 	{(unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
diff -puN kernel/power/snapshot.c~mm-remove-__gfp_cold kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-remove-__gfp_cold
+++ a/kernel/power/snapshot.c
@@ -1882,7 +1882,7 @@ static int enough_free_mem(unsigned int
  */
 static inline int get_highmem_buffer(int safe_needed)
 {
-	buffer = get_image_page(GFP_ATOMIC | __GFP_COLD, safe_needed);
+	buffer = get_image_page(GFP_ATOMIC, safe_needed);
 	return buffer ? 0 : -ENOMEM;
 }
 
@@ -1943,7 +1943,7 @@ static int swsusp_alloc(struct memory_bi
 		while (nr_pages-- > 0) {
 			struct page *page;
 
-			page = alloc_image_page(GFP_ATOMIC | __GFP_COLD);
+			page = alloc_image_page(GFP_ATOMIC);
 			if (!page)
 				goto err_out;
 			memory_bm_set_bit(copy_bm, page_to_pfn(page));
diff -puN mm/filemap.c~mm-remove-__gfp_cold mm/filemap.c
--- a/mm/filemap.c~mm-remove-__gfp_cold
+++ a/mm/filemap.c
@@ -2272,7 +2272,7 @@ no_cached_page:
 		 * Ok, it wasn't cached, so we need to create a new
 		 * page..
 		 */
-		page = page_cache_alloc_cold(mapping);
+		page = page_cache_alloc(mapping);
 		if (!page) {
 			error = -ENOMEM;
 			goto out;
@@ -2384,7 +2384,7 @@ static int page_cache_read(struct file *
 	int ret;
 
 	do {
-		page = __page_cache_alloc(gfp_mask|__GFP_COLD);
+		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			return -ENOMEM;
 
@@ -2788,7 +2788,7 @@ static struct page *do_read_cache_page(s
 repeat:
 	page = find_get_page(mapping, index);
 	if (!page) {
-		page = __page_cache_alloc(gfp | __GFP_COLD);
+		page = __page_cache_alloc(gfp);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
 		err = add_to_page_cache_lru(page, mapping, index, gfp);
diff -puN mm/page_alloc.c~mm-remove-__gfp_cold mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-__gfp_cold
+++ a/mm/page_alloc.c
@@ -2316,7 +2316,7 @@ retry:
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
-			int migratetype, bool cold)
+			int migratetype)
 {
 	int i, alloced = 0;
 
@@ -2338,10 +2338,7 @@ static int rmqueue_bulk(struct zone *zon
 		 * merge IO requests if the physical pages are ordered
 		 * properly.
 		 */
-		if (likely(!cold))
-			list_add(&page->lru, list);
-		else
-			list_add_tail(&page->lru, list);
+		list_add(&page->lru, list);
 		list = &page->lru;
 		alloced++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
@@ -2771,7 +2768,7 @@ static inline void zone_statistics(struc
 
 /* Remove page from the per-cpu list, caller must protect the list */
 static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
-			bool cold, struct per_cpu_pages *pcp,
+			struct per_cpu_pages *pcp,
 			struct list_head *list)
 {
 	struct page *page;
@@ -2780,16 +2777,12 @@ static struct page *__rmqueue_pcplist(st
 		if (list_empty(list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, list,
-					migratetype, cold);
+					migratetype);
 			if (unlikely(list_empty(list)))
 				return NULL;
 		}
 
-		if (cold)
-			page = list_last_entry(list, struct page, lru);
-		else
-			page = list_first_entry(list, struct page, lru);
-
+		page = list_first_entry(list, struct page, lru);
 		list_del(&page->lru);
 		pcp->count--;
 	} while (check_new_pcp(page));
@@ -2804,14 +2797,13 @@ static struct page *rmqueue_pcplist(stru
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
-	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 	struct page *page;
 	unsigned long flags;
 
 	local_irq_save(flags);
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	list = &pcp->lists[migratetype];
-	page = __rmqueue_pcplist(zone,  migratetype, cold, pcp, list);
+	page = __rmqueue_pcplist(zone,  migratetype, pcp, list);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone);
diff -puN mm/percpu-vm.c~mm-remove-__gfp_cold mm/percpu-vm.c
--- a/mm/percpu-vm.c~mm-remove-__gfp_cold
+++ a/mm/percpu-vm.c
@@ -81,7 +81,7 @@ static void pcpu_free_pages(struct pcpu_
 static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    struct page **pages, int page_start, int page_end)
 {
-	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
+	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM;
 	unsigned int cpu, tcpu;
 	int i;
 
diff -puN net/core/skbuff.c~mm-remove-__gfp_cold net/core/skbuff.c
--- a/net/core/skbuff.c~mm-remove-__gfp_cold
+++ a/net/core/skbuff.c
@@ -353,7 +353,7 @@ static void *__netdev_alloc_frag(unsigne
  */
 void *netdev_alloc_frag(unsigned int fragsz)
 {
-	return __netdev_alloc_frag(fragsz, GFP_ATOMIC | __GFP_COLD);
+	return __netdev_alloc_frag(fragsz, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(netdev_alloc_frag);
 
@@ -366,7 +366,7 @@ static void *__napi_alloc_frag(unsigned
 
 void *napi_alloc_frag(unsigned int fragsz)
 {
-	return __napi_alloc_frag(fragsz, GFP_ATOMIC | __GFP_COLD);
+	return __napi_alloc_frag(fragsz, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(napi_alloc_frag);
 
diff -puN tools/perf/builtin-kmem.c~mm-remove-__gfp_cold tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~mm-remove-__gfp_cold
+++ a/tools/perf/builtin-kmem.c
@@ -640,7 +640,6 @@ static const struct {
 	{ "__GFP_ATOMIC",		"_A" },
 	{ "__GFP_IO",			"I" },
 	{ "__GFP_FS",			"F" },
-	{ "__GFP_COLD",			"CO" },
 	{ "__GFP_NOWARN",		"NWR" },
 	{ "__GFP_RETRY_MAYFAIL",	"R" },
 	{ "__GFP_NOFAIL",		"NF" },
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch

