From: akpm@linux-foundation.org
Subject: [patch 054/127] mm: don't use radix tree writeback tags for pages in swap cache
Date: Fri, 07 Oct 2016 16:59:30 -0700
Message-ID: <57f836e2.9v1ZRUAXbjYogO+D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39253 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756016AbcJHAAP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ying.huang@intel.com, dave.hansen@intel.com, fengguang.wu@intel.com, hughd@google.com, mgorman@techsingularity.net, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm: don't use radix tree writeback tags for pages in swap cache

File pages use a set of radix tree tags (DIRTY, TOWRITE, WRITEBACK, etc.)
to accelerate finding the pages with a specific tag in the radix tree
during inode writeback.  But for anonymous pages in the swap cache, there
is no inode writeback.  So there is no need to find the pages with some
writeback tags in the radix tree.  It is not necessary to touch radix tree
writeback tags for pages in the swap cache.

Per Rik van Riel's suggestion, a new flag AS_NO_WRITEBACK_TAGS is
introduced for address spaces which don't need to update the writeback
tags.  The flag is set for swap caches.  It may be used for DAX file
systems, etc.

With this patch, the swap out bandwidth improved 22.3% (from ~1.2GB/s to ~
1.48GBps) in the vm-scalability swap-w-seq test case with 8 processes. 
The test is done on a Xeon E5 v3 system.  The swap device used is a RAM
simulated PMEM (persistent memory) device.  The improvement comes from the
reduced contention on the swap cache radix tree lock.  To test sequential
swapping out, the test case uses 8 processes, which sequentially allocate
and write to the anonymous pages until RAM and part of the swap device is
used up.

Details of comparison is as follow,

base             base+patch
---------------- --------------------------
         %stddev     %change         %stddev
             \          |                \
   2506952 ±  2%     +28.1%    3212076 ±  7%  vm-scalability.throughput
   1207402 ±  7%     +22.3%    1476578 ±  6%  vmstat.swap.so
     10.86 ± 12%     -23.4%       8.31 ± 16%  perf-profile.cycles-pp._raw_spin_lock_irq.__add_to_swap_cache.add_to_swap_cache.add_to_swap.shrink_page_list
     10.82 ± 13%     -33.1%       7.24 ± 14%  perf-profile.cycles-pp._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_zone_memcg
     10.36 ± 11%    -100.0%       0.00 ± -1%  perf-profile.cycles-pp._raw_spin_lock_irqsave.__test_set_page_writeback.bdev_write_page.__swap_writepage.swap_writepage
     10.52 ± 12%    -100.0%       0.00 ± -1%  perf-profile.cycles-pp._raw_spin_lock_irqsave.test_clear_page_writeback.end_page_writeback.page_endio.pmem_rw_page

Link: http://lkml.kernel.org/r/1472578089-5560-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++++++++++++
 mm/page-writeback.c     |    4 ++--
 mm/swap_state.c         |    2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache
+++ a/include/linux/pagemap.h
@@ -25,6 +25,8 @@ enum mapping_flags {
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
 	AS_EXITING	= __GFP_BITS_SHIFT + 4, /* final truncate in progress */
+	/* writeback related tags are not used */
+	AS_NO_WRITEBACK_TAGS = __GFP_BITS_SHIFT + 5,
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -64,6 +66,16 @@ static inline int mapping_exiting(struct
 	return test_bit(AS_EXITING, &mapping->flags);
 }
 
+static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
+{
+	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
+}
+
+static inline int mapping_use_writeback_tags(struct address_space *mapping)
+{
+	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
diff -puN mm/page-writeback.c~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache mm/page-writeback.c
--- a/mm/page-writeback.c~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache
+++ a/mm/page-writeback.c
@@ -2716,7 +2716,7 @@ int test_clear_page_writeback(struct pag
 	int ret;
 
 	lock_page_memcg(page);
-	if (mapping) {
+	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
@@ -2759,7 +2759,7 @@ int __test_set_page_writeback(struct pag
 	int ret;
 
 	lock_page_memcg(page);
-	if (mapping) {
+	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
diff -puN mm/swap_state.c~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache mm/swap_state.c
--- a/mm/swap_state.c~mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache
+++ a/mm/swap_state.c
@@ -37,6 +37,8 @@ struct address_space swapper_spaces[MAX_
 		.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
 		.i_mmap_writable = ATOMIC_INIT(0),
 		.a_ops		= &swap_aops,
+		/* swap cache doesn't use writeback related tags */
+		.flags		= 1 << AS_NO_WRITEBACK_TAGS,
 	}
 };
 
_
