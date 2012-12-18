From: akpm@linux-foundation.org
Subject: [to-be-updated] swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:40:25 -0800
Message-ID: <20121218234026.1DE67200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:49913 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2LRXk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:40:29 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so70236wib.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:40:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, fengguang.wu@intel.com, hughd@google.com, khlebnikov@openvz.org, minchan@kernel.org, riel@redhat.com, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: add a simple detector for inappropriate swapin readahead
has been removed from the -mm tree.  Its filename was
     swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap: add a simple detector for inappropriate swapin readahead

The swapin readahead does a blind readahead whether or not the swapin is
sequential.  This is ok for harddisk because large reads have relatively
small costs and if the readahead pages are unneeded they can be reclaimed
easily.  But for SSD devices large reads are more expensive than small
one.  If readahead pages are unneeded, reading them in caused significant
overhead

This patch addes a simple random read detection similar to file mmap
readahead.  If a random read is detected, swapin readahead will be
skipped.  This improves a lot for a swap workload with random IO in a fast
SSD.

I run anonymous mmap write micro benchmark, which will triger swapin/swapout.

			runtime changes with patch
randwrite harddisk	-38.7%
seqwrite harddisk	-1.1%
randwrite SSD		-46.9%
seqwrite SSD		+0.3%

For both harddisk and SSD, the randwrite swap workload run time is reduced
significantly.  Sequential write swap workload hasn't chanage.

Interestingly, the randwrite harddisk test is improved too.  This might be
because swapin readahead needs to allocate extra memory, which further
tights memory pressure, so more swapout/swapin.

[akpm@linux-foundation.org: tweak code comment]
Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++
 mm/internal.h        |   48 +++++++++++++++++++++++++++++++++++++++++
 mm/memory.c          |    3 +-
 mm/rmap.c            |    3 ++
 mm/shmem.c           |    2 -
 mm/swap_state.c      |    6 +++++
 6 files changed, 63 insertions(+), 2 deletions(-)

diff -puN include/linux/rmap.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead include/linux/rmap.h
--- a/include/linux/rmap.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/include/linux/rmap.h
@@ -35,6 +35,9 @@ struct anon_vma {
 	 * anon_vma if they are the last user on release
 	 */
 	atomic_t refcount;
+#ifdef CONFIG_SWAP
+	atomic_t swapra_miss;
+#endif
 
 	/*
 	 * NOTE: the LSB of the rb_root.rb_node is set by
diff -puN mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead mm/internal.h
--- a/mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/mm/internal.h
@@ -12,6 +12,7 @@
 #define __MM_INTERNAL_H
 
 #include <linux/mm.h>
+#include <linux/rmap.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
@@ -375,4 +376,51 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
 #define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
 
+/*
+ * Unnecessary readahead harms performance, especially for SSD devices, where
+ * large reads are significantly more expensive than small ones.
+ * These implements simple swap random access detection. In swap page fault: if
+ * the page is found in swapcache, decrease a counter in the vma, otherwise we
+ * need to perform sync swapin and the counter is increased.  Optionally swapin
+ * will perform readahead if the counter is below a threshold.
+ */
+#ifdef CONFIG_SWAP
+#define SWAPRA_MISS_THRESHOLD  (100)
+#define SWAPRA_MAX_MISS ((SWAPRA_MISS_THRESHOLD) * 10)
+static inline void swap_cache_hit(struct vm_area_struct *vma)
+{
+	if (vma && vma->anon_vma)
+		atomic_dec_if_positive(&vma->anon_vma->swapra_miss);
+}
+
+static inline void swap_cache_miss(struct vm_area_struct *vma)
+{
+	if (!vma || !vma->anon_vma)
+		return;
+	if (atomic_read(&vma->anon_vma->swapra_miss) < SWAPRA_MAX_MISS)
+		atomic_inc(&vma->anon_vma->swapra_miss);
+}
+
+static inline int swap_cache_skip_readahead(struct vm_area_struct *vma)
+{
+	if (!vma || !vma->anon_vma)
+		return 0;
+	return atomic_read(&vma->anon_vma->swapra_miss) >
+		SWAPRA_MISS_THRESHOLD;
+}
+#else
+static inline void swap_cache_hit(struct vm_area_struct *vma)
+{
+}
+
+static inline void swap_cache_miss(struct vm_area_struct *vma)
+{
+}
+
+static inline int swap_cache_skip_readahead(struct vm_area_struct *vma)
+{
+	return 0;
+}
+#endif	/* CONFIG_SWAP */
+
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/memory.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead mm/memory.c
--- a/mm/memory.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/mm/memory.c
@@ -2967,7 +2967,8 @@ static int do_swap_page(struct mm_struct
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		goto out_release;
-	}
+	} else if (!(flags & FAULT_FLAG_TRIED))
+		swap_cache_hit(vma);
 
 	locked = lock_page_or_retry(page, mm, flags);
 
diff -puN mm/rmap.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead mm/rmap.c
--- a/mm/rmap.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/mm/rmap.c
@@ -367,6 +367,9 @@ static void anon_vma_ctor(void *data)
 
 	init_rwsem(&anon_vma->rwsem);
 	atomic_set(&anon_vma->refcount, 0);
+#ifdef CONFIG_SWAP
+	atomic_set(&anon_vma->swapra_miss, 0);
+#endif
 	anon_vma->rb_root = RB_ROOT;
 }
 
diff -puN mm/shmem.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead mm/shmem.c
--- a/mm/shmem.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/mm/shmem.c
@@ -919,7 +919,7 @@ static struct page *shmem_swapin(swp_ent
 	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
-
+	pvma.anon_vma = NULL;
 	page = swapin_readahead(swap, gfp, &pvma, 0);
 
 	/* Drop reference taken by mpol_shared_policy_lookup() */
diff -puN mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead mm/swap_state.c
--- a/mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead
+++ a/mm/swap_state.c
@@ -20,6 +20,7 @@
 #include <linux/page_cgroup.h>
 
 #include <asm/pgtable.h>
+#include "internal.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -379,6 +380,10 @@ struct page *swapin_readahead(swp_entry_
 	unsigned long mask = (1UL << page_cluster) - 1;
 	struct blk_plug plug;
 
+	swap_cache_miss(vma);
+	if (swap_cache_skip_readahead(vma))
+		goto skip;
+
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
 	end_offset = offset | mask;
@@ -397,5 +402,6 @@ struct page *swapin_readahead(swp_entry_
 	blk_finish_plug(&plug);
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
+skip:
 	return read_swap_cache_async(entry, gfp_mask, vma, addr);
 }
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch

