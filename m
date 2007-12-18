From: akpm@linux-foundation.org
Subject: + tmpfs-move-swap_state-stats-update.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:32:01 -0800
Message-ID: <200712182232.lBIMW1uj025319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbXLRWcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: move swap_state stats update
has been added to the -mm tree.  Its filename is
     tmpfs-move-swap_state-stats-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tmpfs: move swap_state stats update
From: Hugh Dickins <hugh@veritas.com>

Both unionfs and memcgroups pose challenges to tmpfs and shmem.  To help fix,
it's best to move the swap swizzling functions from swap_state.c to shmem.c. 
As a preliminary to that, move swap stats updating down into
__add_to_swap_cache, which will remain internal to swap_state.c.

Well, actually, just move down the incrementation of add_total: remove
noent_race and exist_race completely, they are relics of my 2.4.11 testing. 
Alt-SysRq-m users will be thrilled if 2.6.25 is at last free of "race M+N"s.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN mm/swap_state.c~tmpfs-move-swap_state-stats-update mm/swap_state.c
--- a/mm/swap_state.c~tmpfs-move-swap_state-stats-update
+++ a/mm/swap_state.c
@@ -52,16 +52,13 @@ static struct {
 	unsigned long del_total;
 	unsigned long find_success;
 	unsigned long find_total;
-	unsigned long noent_race;
-	unsigned long exist_race;
 } swap_cache_info;
 
 void show_swap_cache_info(void)
 {
-	printk("Swap cache: add %lu, delete %lu, find %lu/%lu, race %lu+%lu\n",
+	printk("Swap cache: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
-		swap_cache_info.find_success, swap_cache_info.find_total,
-		swap_cache_info.noent_race, swap_cache_info.exist_race);
+		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
 }
@@ -89,6 +86,7 @@ static int __add_to_swap_cache(struct pa
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
+			INC_CACHE_INFO(add_total);
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
@@ -102,10 +100,9 @@ static int add_to_swap_cache(struct page
 	int error;
 
 	BUG_ON(PageLocked(page));
-	if (!swap_duplicate(entry)) {
-		INC_CACHE_INFO(noent_race);
+	if (!swap_duplicate(entry))
 		return -ENOENT;
-	}
+
 	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
 	/*
@@ -114,11 +111,8 @@ static int add_to_swap_cache(struct page
 	if (error) {
 		ClearPageLocked(page);
 		swap_free(entry);
-		if (error == -EEXIST)
-			INC_CACHE_INFO(exist_race);
 		return error;
 	}
-	INC_CACHE_INFO(add_total);
 	return 0;
 }
 
@@ -178,11 +172,9 @@ int add_to_swap(struct page * page, gfp_
 		case 0:				/* Success */
 			SetPageUptodate(page);
 			SetPageDirty(page);
-			INC_CACHE_INFO(add_total);
 			return 1;
 		case -EEXIST:
 			/* Raced with "speculative" read_swap_cache_async */
-			INC_CACHE_INFO(exist_race);
 			swap_free(entry);
 			continue;
 		default:
@@ -225,9 +217,7 @@ int move_to_swap_cache(struct page *page
 		if (!swap_duplicate(entry))
 			BUG();
 		SetPageDirty(page);
-		INC_CACHE_INFO(add_total);
-	} else if (err == -EEXIST)
-		INC_CACHE_INFO(exist_race);
+	}
 	return err;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
