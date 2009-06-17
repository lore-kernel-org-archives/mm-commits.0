From: akpm@linux-foundation.org
Subject: [merged] mm-add-swap-cache-interface-for-swap-reference.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:46 -0700
Message-ID: <200906171835.n5HIZkeC001764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756847AbZFQS43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamot


The patch titled
     mm: add swap cache interface for swap reference
has been removed from the -mm tree.  Its filename was
     mm-add-swap-cache-interface-for-swap-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add swap cache interface for swap reference
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In a following patch, the usage of swap cache is recorded into swap_map. 
This patch is for necessary interface changes to do that.

2 interfaces:

  - swapcache_prepare()
  - swapcache_free()

are added for allocating/freeing refcnt from swap-cache to existing swap
entries.  But implementation itself is not changed under this patch.  At
adding swapcache_free(), memcg's hook code is moved under
swapcache_free().  This is better than using scattered hooks.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 +++++++
 mm/shmem.c           |    2 +-
 mm/swap_state.c      |   11 +++++------
 mm/swapfile.c        |   19 +++++++++++++++++++
 mm/vmscan.c          |    3 +--
 5 files changed, 33 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~mm-add-swap-cache-interface-for-swap-reference include/linux/swap.h
--- a/include/linux/swap.h~mm-add-swap-cache-interface-for-swap-reference
+++ a/include/linux/swap.h
@@ -282,8 +282,10 @@ extern void si_swapinfo(struct sysinfo *
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int swap_duplicate(swp_entry_t);
+extern int swapcache_prepare(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
+extern void swapcache_free(swp_entry_t, struct page *page);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
@@ -352,11 +354,16 @@ static inline void show_swap_cache_info(
 
 #define free_swap_and_cache(swp)	is_migration_entry(swp)
 #define swap_duplicate(swp)		is_migration_entry(swp)
+#define swapcache_prepare(swp)		is_migration_entry(swp)
 
 static inline void swap_free(swp_entry_t swp)
 {
 }
 
+static inline void swapcache_free(swp_entry_t swp, struct page *page)
+{
+}
+
 static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
diff -puN mm/shmem.c~mm-add-swap-cache-interface-for-swap-reference mm/shmem.c
--- a/mm/shmem.c~mm-add-swap-cache-interface-for-swap-reference
+++ a/mm/shmem.c
@@ -1097,7 +1097,7 @@ static int shmem_writepage(struct page *
 	shmem_swp_unmap(entry);
 unlock:
 	spin_unlock(&info->lock);
-	swap_free(swap);
+	swapcache_free(swap, NULL);
 redirty:
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
diff -puN mm/swap_state.c~mm-add-swap-cache-interface-for-swap-reference mm/swap_state.c
--- a/mm/swap_state.c~mm-add-swap-cache-interface-for-swap-reference
+++ a/mm/swap_state.c
@@ -162,11 +162,11 @@ int add_to_swap(struct page *page)
 			return 1;
 		case -EEXIST:
 			/* Raced with "speculative" read_swap_cache_async */
-			swap_free(entry);
+			swapcache_free(entry, NULL);
 			continue;
 		default:
 			/* -ENOMEM radix-tree allocation failure */
-			swap_free(entry);
+			swapcache_free(entry, NULL);
 			return 0;
 		}
 	}
@@ -188,8 +188,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&swapper_space.tree_lock);
 
-	mem_cgroup_uncharge_swapcache(page, entry);
-	swap_free(entry);
+	swapcache_free(entry, page);
 	page_cache_release(page);
 }
 
@@ -293,7 +292,7 @@ struct page *read_swap_cache_async(swp_e
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
-		if (!swap_duplicate(entry))
+		if (!swapcache_prepare(entry))
 			break;
 
 		/*
@@ -317,7 +316,7 @@ struct page *read_swap_cache_async(swp_e
 		}
 		ClearPageSwapBacked(new_page);
 		__clear_page_locked(new_page);
-		swap_free(entry);
+		swapcache_free(entry, NULL);
 	} while (err != -ENOMEM);
 
 	if (new_page)
diff -puN mm/swapfile.c~mm-add-swap-cache-interface-for-swap-reference mm/swapfile.c
--- a/mm/swapfile.c~mm-add-swap-cache-interface-for-swap-reference
+++ a/mm/swapfile.c
@@ -510,6 +510,16 @@ void swap_free(swp_entry_t entry)
 }
 
 /*
+ * Called after dropping swapcache to decrease refcnt to swap entries.
+ */
+void swapcache_free(swp_entry_t entry, struct page *page)
+{
+	if (page)
+		mem_cgroup_uncharge_swapcache(page, entry);
+	return swap_free(entry);
+}
+
+/*
  * How many references to page are currently swapped out?
  */
 static inline int page_swapcount(struct page *page)
@@ -1979,6 +1989,15 @@ bad_file:
 	goto out;
 }
 
+/*
+ * Called when allocating swap cache for exising swap entry,
+ */
+int swapcache_prepare(swp_entry_t entry)
+{
+	return swap_duplicate(entry);
+}
+
+
 struct swap_info_struct *
 get_swap_info_struct(unsigned type)
 {
diff -puN mm/vmscan.c~mm-add-swap-cache-interface-for-swap-reference mm/vmscan.c
--- a/mm/vmscan.c~mm-add-swap-cache-interface-for-swap-reference
+++ a/mm/vmscan.c
@@ -470,8 +470,7 @@ static int __remove_mapping(struct addre
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
-		mem_cgroup_uncharge_swapcache(page, swap);
-		swap_free(swap);
+		swapcache_free(swap, page);
 	} else {
 		__remove_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

