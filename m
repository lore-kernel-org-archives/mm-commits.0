From: akpm@linux-foundation.org
Subject: + memory-controller-bug_on.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:07:40 -0700
Message-ID: <200709150207.l8F27era002416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbXIOCHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:07:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com


The patch titled
     memory controller BUG_ON()
has been added to the -mm tree.  Its filename is
     memory-controller-bug_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -440,14 +440,12 @@ int filemap_write_and_wait_range(struct 
 int add_to_page_cache(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
+	int error = mem_container_cache_charge(page, current->mm, gfp_mask);
+	if (error)
+		goto out;
 
+	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
-
-		error = mem_container_cache_charge(page, current->mm, gfp_mask);
-		if (error)
-			goto out;
-
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (!error) {
@@ -462,7 +460,8 @@ int add_to_page_cache(struct page *page,
 
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
-	}
+	} else
+		mem_container_uncharge_page(page);
 out:
 	return error;
 }
diff -puN mm/swap_state.c~memory-controller-bug_on mm/swap_state.c
--- a/mm/swap_state.c~memory-controller-bug_on
+++ a/mm/swap_state.c
@@ -78,13 +78,13 @@ static int __add_to_swap_cache(struct pa
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
-	error = radix_tree_preload(gfp_mask);
-	if (!error) {
 
-		error = mem_container_cache_charge(page, current->mm, gfp_mask);
-		if (error)
-			goto out;
+	error = mem_container_cache_charge(page, current->mm, gfp_mask);
+	if (error)
+		goto out;
 
+	error = radix_tree_preload(gfp_mask);
+	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
 		error = radix_tree_insert(&swapper_space.page_tree,
 						entry.val, page);
@@ -99,7 +99,8 @@ static int __add_to_swap_cache(struct pa
 
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
-	}
+	} else
+		mem_container_uncharge_page(page);
 out:
 	return error;
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
clean-up-duplicate-includes-in-documentation.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
memory-controller-bug_on.patch
