Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF04C21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489950; cv=none; b=PMmceoqOdDhJrgbkQHqSOKkaRLKoVSyuEp4aAPNw4syxt2gVkVxJMxMuIrMcNL7KF69ZvsxQL3dIb94i5XOovAhCs+emuVpA5ayLl0mxU9DIr3yRLNxESefGr5BfqYoYsA7Tqqk4EGebVd9mxxwtRhINprvoL0LkTbZgFQBACl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489950; c=relaxed/simple;
	bh=dJsMR8U9/b5YGSHUtzvxDNANLoghY2wcCM7rUiVStOg=;
	h=Date:To:From:Subject:Message-Id; b=DHGL260ZvrInG4jrBcZH+aNxq/pK3oIJlHsdToPrBtR0zMyA0P5ghVPp/FFx7xPK5hnEb3JMaXfDxFPMQ35dsq6LL86DcaWZULPRwF3dktXYpz7XBWCdK36xBC0AUnXKh9ZQjap9mE6uyrfzvIAIhu1sazSJZhF2RT4J30Lvq9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xeEmBNgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xeEmBNgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FD1C4CEE7;
	Sun, 21 Sep 2025 21:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489950;
	bh=dJsMR8U9/b5YGSHUtzvxDNANLoghY2wcCM7rUiVStOg=;
	h=Date:To:From:Subject:From;
	b=xeEmBNgh4rinDhhA3Ye6u6VMlsDPUCq7c7siMNYnozPZdK+I5KZQEOxnIEPlhUsrb
	 ZSrxGowKFW5h+yKiLotLLIWLKkdEO007FpIg2YUqhFVNCT0bg0wQrimrrYJNW+mYwv
	 K5U//w+nCtJdvoE5cqjBwGkB3midVDoOSMUvgovs=
Date: Sun, 21 Sep 2025 14:25:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-contention-workaround-for-swap-cache.patch removed from -mm tree
Message-Id: <20250921212550.A5FD1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove contention workaround for swap cache
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-contention-workaround-for-swap-cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove contention workaround for swap cache
Date: Wed, 17 Sep 2025 00:00:58 +0800

Swap cluster setup will try to shuffle the clusters on initialization.  It
was helpful to avoid contention for the swap cache space.  The cluster
size (2M) was much smaller than each swap cache space (64M), so shuffling
the cluster means the allocator will try to allocate swap slots that are
in different swap cache spaces for each CPU, reducing the chance of two
CPUs using the same swap cache space, and hence reducing the contention.

Now, swap cache is managed by swap clusters, this shuffle is pointless. 
Just remove it, and clean up related macros.

This also improves the HDD swap performance as shuffling IO is a bad idea
for HDD, and now the shuffling is gone.  Test have shown a ~40%
performance gain for HDD [1]:

Doing sequential swap in of 8G data using 8 processes with usemem, average
of 3 test runs:

Before: 1270.91 KB/s per process
After:  1849.54 KB/s per process

Link: https://lore.kernel.org/linux-mm/CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20250916160100.31545-14-ryncsn@gmail.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    4 ----
 mm/swapfile.c |   32 ++++++++------------------------
 mm/zswap.c    |    7 +++++--
 3 files changed, 13 insertions(+), 30 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-contention-workaround-for-swap-cache
+++ a/mm/swapfile.c
@@ -3204,21 +3204,14 @@ static int setup_swap_map(struct swap_in
 	return 0;
 }
 
-#define SWAP_CLUSTER_INFO_COLS						\
-	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
-#define SWAP_CLUSTER_SPACE_COLS						\
-	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
-#define SWAP_CLUSTER_COLS						\
-	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
-
 static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 						union swap_header *swap_header,
 						unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	unsigned long i, j, idx;
 	int err = -ENOMEM;
+	unsigned long i;
 
 	cluster_info = kvcalloc(nr_clusters, sizeof(*cluster_info), GFP_KERNEL);
 	if (!cluster_info)
@@ -3267,22 +3260,13 @@ static struct swap_cluster_info *setup_c
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
 	}
 
-	/*
-	 * Reduce false cache line sharing between cluster_info and
-	 * sharing same address space.
-	 */
-	for (j = 0; j < SWAP_CLUSTER_COLS; j++) {
-		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
-			struct swap_cluster_info *ci;
-			idx = i * SWAP_CLUSTER_COLS + j;
-			ci = cluster_info + idx;
-			if (idx >= nr_clusters)
-				continue;
-			if (ci->count) {
-				ci->flags = CLUSTER_FLAG_NONFULL;
-				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
-				continue;
-			}
+	for (i = 0; i < nr_clusters; i++) {
+		struct swap_cluster_info *ci = &cluster_info[i];
+
+		if (ci->count) {
+			ci->flags = CLUSTER_FLAG_NONFULL;
+			list_add_tail(&ci->list, &si->nonfull_clusters[0]);
+		} else {
 			ci->flags = CLUSTER_FLAG_FREE;
 			list_add_tail(&ci->list, &si->free_clusters);
 		}
--- a/mm/swap.h~mm-swap-remove-contention-workaround-for-swap-cache
+++ a/mm/swap.h
@@ -198,10 +198,6 @@ int swap_writeout(struct folio *folio, s
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-/* One swap address space for each 64M swap space */
-#define SWAP_ADDRESS_SPACE_SHIFT	14
-#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
-#define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
 extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
--- a/mm/zswap.c~mm-swap-remove-contention-workaround-for-swap-cache
+++ a/mm/zswap.c
@@ -225,10 +225,13 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
+/* One swap address space for each 64M swap space */
+#define ZSWAP_ADDRESS_SPACE_SHIFT 14
+#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
 	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> SWAP_ADDRESS_SPACE_SHIFT];
+		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1674,7 +1677,7 @@ int zswap_swapon(int type, unsigned long
 	struct xarray *trees, *tree;
 	unsigned int nr, i;
 
-	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
 	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
 	if (!trees) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
_

Patches currently in -mm which might be from kasong@tencent.com are


