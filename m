From: akpm@linux-foundation.org
Subject: [merged] shmem-cleanup-shmem_add_to_page_cache.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:36 -0700
Message-ID: <20120712193737.335825C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44293 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2GLThj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:39 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr14so146132wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: cleanup shmem_add_to_page_cache
has been removed from the -mm tree.  Its filename was
     shmem-cleanup-shmem_add_to_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: cleanup shmem_add_to_page_cache

shmem_add_to_page_cache() has three callsites, but only one of them wants
the radix_tree_preload() (an exceptional entry guarantees that the radix
tree node is present in the other cases), and only that site can achieve
mem_cgroup_uncharge_cache_page() (PageSwapCache makes it a no-op in the
other cases).  We did it this way originally to reflect
add_to_page_cache_locked(); but it's confusing now, so move the radix_tree
preloading and mem_cgroup uncharging to that one caller.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   58 ++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff -puN mm/shmem.c~shmem-cleanup-shmem_add_to_page_cache mm/shmem.c
--- a/mm/shmem.c~shmem-cleanup-shmem_add_to_page_cache
+++ a/mm/shmem.c
@@ -288,40 +288,31 @@ static int shmem_add_to_page_cache(struc
 				   struct address_space *mapping,
 				   pgoff_t index, gfp_t gfp, void *expected)
 {
-	int error = 0;
+	int error;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
+	page_cache_get(page);
+	page->mapping = mapping;
+	page->index = index;
+
+	spin_lock_irq(&mapping->tree_lock);
 	if (!expected)
-		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+		error = radix_tree_insert(&mapping->page_tree, index, page);
+	else
+		error = shmem_radix_tree_replace(mapping, index, expected,
+								 page);
 	if (!error) {
-		page_cache_get(page);
-		page->mapping = mapping;
-		page->index = index;
-
-		spin_lock_irq(&mapping->tree_lock);
-		if (!expected)
-			error = radix_tree_insert(&mapping->page_tree,
-							index, page);
-		else
-			error = shmem_radix_tree_replace(mapping, index,
-							expected, page);
-		if (!error) {
-			mapping->nrpages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			__inc_zone_page_state(page, NR_SHMEM);
-			spin_unlock_irq(&mapping->tree_lock);
-		} else {
-			page->mapping = NULL;
-			spin_unlock_irq(&mapping->tree_lock);
-			page_cache_release(page);
-		}
-		if (!expected)
-			radix_tree_preload_end();
+		mapping->nrpages++;
+		__inc_zone_page_state(page, NR_FILE_PAGES);
+		__inc_zone_page_state(page, NR_SHMEM);
+		spin_unlock_irq(&mapping->tree_lock);
+	} else {
+		page->mapping = NULL;
+		spin_unlock_irq(&mapping->tree_lock);
+		page_cache_release(page);
 	}
-	if (error)
-		mem_cgroup_uncharge_cache_page(page);
 	return error;
 }
 
@@ -1202,11 +1193,18 @@ repeat:
 		__set_page_locked(page);
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
-		if (!error)
-			error = shmem_add_to_page_cache(page, mapping, index,
-						gfp, NULL);
 		if (error)
 			goto decused;
+		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+		if (!error) {
+			error = shmem_add_to_page_cache(page, mapping, index,
+							gfp, NULL);
+			radix_tree_preload_end();
+		}
+		if (error) {
+			mem_cgroup_uncharge_cache_page(page);
+			goto decused;
+		}
 		lru_cache_add_anon(page);
 
 		spin_lock(&info->lock);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

