From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch removed
 from -mm tree
Date: Thu, 21 Apr 2016 13:46:54 -0700
Message-ID: <57193c3e.o5T/OMYWGrXF6dmX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbcDUUqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: shmem_recovery_swapin to read from swap
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs recovery: shmem_recovery_swapin to read from swap

If pages of the extent are out on swap, we would much prefer to read them
in to their final locations on the assigned huge page, than have
swapin_readahead() adding unrelated pages, and __read_swap_cache_async()
allocating intermediate pages, from which we would then have to migrate
(though some may well be already in swapcache, and then need migration).

And we'd like to get all the swap I/O underway at the start, then wait on
it in probably a single page lock of the main population loop: which can
forget about swap, leaving shmem_getpage_gfp() to handle the transitions
from swapcache to pagecache.

shmem_recovery_swapin() is very much based on __read_swap_cache_async(),
but the things it needs to worry about are not always the same: it does
not matter if __read_swap_cache_async() occasionally reads an unrelated
page which has inherited a freed swap block; but shmem_recovery_swapin()
better not place that inside the huge page it is helping to build.

Ifdef CONFIG_SWAP around it and its shmem_next_swap() helper because a
couple of functions it calls are undeclared without CONFIG_SWAP.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff -puN mm/shmem.c~huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap
+++ a/mm/shmem.c
@@ -804,6 +804,105 @@ static bool shmem_work_still_useful(stru
 		!RB_EMPTY_ROOT(&mapping->i_mmap);  /* file is still mapped */
 }
 
+#ifdef CONFIG_SWAP
+static void *shmem_next_swap(struct address_space *mapping,
+			     pgoff_t *index, pgoff_t end)
+{
+	pgoff_t start = *index + 1;
+	struct radix_tree_iter iter;
+	void **slot;
+	void *radswap;
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		if (iter.index >= end)
+			break;
+		radswap = radix_tree_deref_slot(slot);
+		if (radix_tree_exception(radswap)) {
+			if (radix_tree_deref_retry(radswap))
+				goto restart;
+			goto out;
+		}
+	}
+	radswap = NULL;
+out:
+	rcu_read_unlock();
+	*index = iter.index;
+	return radswap;
+}
+
+static void shmem_recovery_swapin(struct recovery *recovery, struct page *head)
+{
+	struct shmem_inode_info *info = SHMEM_I(recovery->inode);
+	struct address_space *mapping = recovery->inode->i_mapping;
+	pgoff_t index = recovery->head_index - 1;
+	pgoff_t end = recovery->head_index + HPAGE_PMD_NR;
+	struct blk_plug plug;
+	void *radswap;
+	int error;
+
+	/*
+	 * If the file has nothing swapped out, don't waste time here.
+	 * If the team has already been exposed by an earlier attempt,
+	 * it is not safe to pursue this optimization again - truncation
+	 * *might* let swapin I/O overlap with fresh use of the page.
+	 */
+	if (!info->swapped || recovery->exposed_team)
+		return;
+
+	blk_start_plug(&plug);
+	while ((radswap = shmem_next_swap(mapping, &index, end))) {
+		swp_entry_t swap = radix_to_swp_entry(radswap);
+		struct page *page = head + (index & (HPAGE_PMD_NR-1));
+
+		/*
+		 * Code below is adapted from __read_swap_cache_async():
+		 * we want to set up async swapin to the right pages.
+		 * We don't have to worry about a more limiting gfp_mask
+		 * leading to -ENOMEM from __add_to_swap_cache(), but we
+		 * do have to worry about swapcache_prepare() succeeding
+		 * when swap has been freed and reused for an unrelated page.
+		 */
+		shr_stats(swap_entry);
+		error = radix_tree_preload(GFP_KERNEL);
+		if (error)
+			break;
+
+		error = swapcache_prepare(swap);
+		if (error) {
+			radix_tree_preload_end();
+			shr_stats(swap_cached);
+			continue;
+		}
+
+		if (!shmem_confirm_swap(mapping, index, swap)) {
+			radix_tree_preload_end();
+			swapcache_free(swap);
+			shr_stats(swap_gone);
+			continue;
+		}
+
+		__SetPageLocked(page);
+		__SetPageSwapBacked(page);
+		error = __add_to_swap_cache(page, swap);
+		radix_tree_preload_end();
+		VM_BUG_ON(error);
+
+		shr_stats(swap_read);
+		lru_cache_add_anon(page);
+		swap_readpage(page);
+		cond_resched();
+	}
+	blk_finish_plug(&plug);
+	lru_add_drain();	/* not necessary but may help debugging */
+}
+#else
+static void shmem_recovery_swapin(struct recovery *recovery, struct page *head)
+{
+}
+#endif /* CONFIG_SWAP */
+
 static struct page *shmem_get_recovery_page(struct page *page,
 					unsigned long private, int **result)
 {
@@ -855,6 +954,8 @@ static int shmem_recovery_populate(struc
 	/* Warning: this optimization relies on disband's ClearPageChecked */
 	if (PageTeam(head) && PageChecked(head))
 		return 0;
+
+	shmem_recovery_swapin(recovery, head);
 again:
 	migratable = 0;
 	unmigratable = 0;
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

