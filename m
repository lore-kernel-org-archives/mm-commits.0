Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D949B17E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118452; cv=none; b=rIlO/zE9tPc5tRoB5/knALIqKnarIuJZIe942Td0txFue5bzmg/tlRa0LoweCvgE16lKOV4zv+E0VgTEKRYQc+sxNw/0QXAJx/cQNILw3S/8+ka7WWdbB9zm7921PWNvo6iY3NvB8fN3ZkpGlt1HiKD7DY9vlDva5ynekdwGElY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118452; c=relaxed/simple;
	bh=BWHmavmWtQ4wIIN/K/BqmZD7hy14dVTLog0zAg7mKjo=;
	h=Date:To:From:Subject:Message-Id; b=agbESQdcUS4qusfM2DnCzgNC61LNrOAXOcBpOWP5bcUKlemHPHbEb4lHu//ZRemDzBKErruIV9UKXKigpZEn9RKseysdL0gPY24P7vYV0doBK/oS/aYYMt4TKiMaWdBblKGiM+OYjKu1Wik9Uu/+aR/WtUNZdB+PI+MsfF3J/2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FpK/KbdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FpK/KbdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2780C4CEF1;
	Sat,  6 Sep 2025 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118452;
	bh=BWHmavmWtQ4wIIN/K/BqmZD7hy14dVTLog0zAg7mKjo=;
	h=Date:To:From:Subject:From;
	b=FpK/KbdC9aSnELbZNmAhhH+3XkPUXreMEZbzG8prpMiTCzlMTfLvB9BImVBbOekb5
	 5JAJpMLsmF5R9UZTABye6x5Rvfm1I3JLk25CVUvhxb8ZNvY7feKibTwPErT4lpqJmd
	 qjSC6Ii8kQSogMPpSaOVK+3p/msy3+rgDYTU6QMk=
Date: Fri, 05 Sep 2025 17:27:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-contention-workaround-for-swap-cache.patch added to mm-new branch
Message-Id: <20250906002732.A2780C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove contention workaround for swap cache
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-contention-workaround-for-swap-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-contention-workaround-for-swap-cache.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove contention workaround for swap cache
Date: Sat, 6 Sep 2025 03:13:55 +0800

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
Link: https://lkml.kernel.org/r/20250905191357.78298-14-ryncsn@gmail.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    4 ----
 mm/swapfile.c |   32 ++++++++------------------------
 mm/zswap.c    |    7 +++++--
 3 files changed, 13 insertions(+), 30 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-contention-workaround-for-swap-cache
+++ a/mm/swapfile.c
@@ -3202,21 +3202,14 @@ static int setup_swap_map(struct swap_in
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
@@ -3265,22 +3258,13 @@ static struct swap_cluster_info *setup_c
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
@@ -197,10 +197,6 @@ int swap_writeout(struct folio *folio, s
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

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

