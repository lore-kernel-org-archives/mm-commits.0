From: akpm@linux-foundation.org
Subject: [merged]
 fs-buffer-move-allocation-failure-loop-into-the-allocator.patch removed
 from -mm tree
Date: Thu, 17 Oct 2013 11:13:19 -0700
Message-ID: <526028bf.VXNqOMIUeIM/8+nL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab3JQSNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, mhocko@suse.cz, azurit@pobox.sk, hannes@cmpxchg.org

Subject: [merged] fs-buffer-move-allocation-failure-loop-into-the-allocator.patch removed from -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,mhocko@suse.cz,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:19 -0700


The patch titled
     Subject: fs: buffer: move allocation failure loop into the allocator
has been removed from the -mm tree.  Its filename was
     fs-buffer-move-allocation-failure-loop-into-the-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: buffer: move allocation failure loop into the allocator

Buffer allocation has a very crude indefinite loop around waking the
flusher threads and performing global NOFS direct reclaim because it can
not handle allocation failures.

The most immediate problem with this is that the allocation may fail due
to a memory cgroup limit, where flushers + direct reclaim might not make
any progress towards resolving the situation at all.  Because unlike the
global case, a memory cgroup may not have any cache at all, only anonymous
pages but no swap.  This situation will lead to a reclaim livelock with
insane IO from waking the flushers and thrashing unrelated filesystem
cache in a tight loop.

Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
any looping happens in the page allocator, which knows how to orchestrate
kswapd, direct reclaim, and the flushers sensibly.  It also allows memory
cgroups to detect allocations that can't handle failure and will allow
them to ultimately bypass the limit if reclaim can not make progress.

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c     |   14 ++++++++++++--
 mm/memcontrol.c |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-buffer-move-allocation-failure-loop-into-the-allocator fs/buffer.c
--- a/fs/buffer.c~fs-buffer-move-allocation-failure-loop-into-the-allocator
+++ a/fs/buffer.c
@@ -1005,9 +1005,19 @@ grow_dev_page(struct block_device *bdev,
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;		/* Will call free_more_memory() */
+	gfp_t gfp_mask;
 
-	page = find_or_create_page(inode->i_mapping, index,
-		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
+	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
+	gfp_mask |= __GFP_MOVABLE;
+	/*
+	 * XXX: __getblk_slow() can not really deal with failure and
+	 * will endlessly loop on improvised global reclaim.  Prefer
+	 * looping in the allocator rather than here, at least that
+	 * code knows what it's doing.
+	 */
+	gfp_mask |= __GFP_NOFAIL;
+
+	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
 	if (!page)
 		return ret;
 
diff -puN mm/memcontrol.c~fs-buffer-move-allocation-failure-loop-into-the-allocator mm/memcontrol.c
--- a/mm/memcontrol.c~fs-buffer-move-allocation-failure-loop-into-the-allocator
+++ a/mm/memcontrol.c
@@ -2766,6 +2766,8 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = root_mem_cgroup;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

