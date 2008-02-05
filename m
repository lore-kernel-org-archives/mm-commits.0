From: akpm@linux-foundation.org
Subject: - tmpfs-move-swap_state-stats-update.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:25 -0800
Message-ID: <200802052230.m15MU6Eq012035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073AbYBEWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: move swap_state stats update
has been removed from the -mm tree.  Its filename was
     tmpfs-move-swap_state-stats-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
