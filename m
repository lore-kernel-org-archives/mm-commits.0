From: akpm@linux-foundation.org
Subject: - memory-controller-bug_on.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:35 -0800
Message-ID: <200802080803.m1883G1k014105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329AbYBHIY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memory controller BUG_ON()
has been removed from the -mm tree.  Its filename was
     memory-controller-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller BUG_ON()
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Move mem_controller_cache_charge() above radix_tree_preload(). 
radix_tree_preload() disables preemption, even though the gfp_mask passed
contains __GFP_WAIT, we cannot really do __GFP_WAIT allocations, thus we
hit a BUG_ON() in kmem_cache_alloc().

This patch moves mem_controller_cache_charge() to above radix_tree_preload()
for cache charging.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |   13 ++++++-------
 mm/swap_state.c |   13 +++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/filemap.c~memory-controller-bug_on mm/filemap.c
--- a/mm/filemap.c~memory-controller-bug_on
+++ a/mm/filemap.c
@@ -460,14 +460,12 @@ int filemap_write_and_wait_range(struct 
 int add_to_page_cache(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
+	int error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
+	if (error)
+		goto out;
 
+	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
-
-		error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
-		if (error)
-			goto out;
-
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (!error) {
@@ -482,7 +480,8 @@ int add_to_page_cache(struct page *page,
 
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
-	}
+	} else
+		mem_cgroup_uncharge_page(page);
 out:
 	return error;
 }
diff -puN mm/swap_state.c~memory-controller-bug_on mm/swap_state.c
--- a/mm/swap_state.c~memory-controller-bug_on
+++ a/mm/swap_state.c
@@ -75,13 +75,13 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
-	error = radix_tree_preload(gfp_mask);
-	if (!error) {
 
-		error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
-		if (error)
-			goto out;
+	error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
+	if (error)
+		goto out;
 
+	error = radix_tree_preload(gfp_mask);
+	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
 		error = radix_tree_insert(&swapper_space.page_tree,
 						entry.val, page);
@@ -97,7 +97,8 @@ int add_to_swap_cache(struct page *page,
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
-	}
+	} else
+		mem_cgroup_uncharge_page(page);
 out:
 	return error;
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
getdelays-fix-gcc-warnings.patch
