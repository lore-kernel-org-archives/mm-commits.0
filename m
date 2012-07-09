From: akpm@linux-foundation.org
Subject: + shmem-cleanup-shmem_add_to_page_cache.patch added to -mm tree
Date: Mon, 09 Jul 2012 16:37:40 -0700
Message-ID: <20120709233741.920755C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42848 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2GIXhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 19:37:43 -0400
Received: by eeit10 with SMTP id t10so725899eei.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 16:37:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: shmem: cleanup shmem_add_to_page_cache
has been added to the -mm tree.  Its filename is
     shmem-cleanup-shmem_add_to_page_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
Subject: Subject: shmem: cleanup shmem_add_to_page_cache

Patches currently in -mm which might be from hughd@google.com are

fs-ramfs-file-nommu-add-setpageuptodate.patch
tmpfs-revert-seek_data-and-seek_hole.patch
shmem-fix-negative-rss-in-memcg-memorystat.patch
shmem-cleanup-shmem_add_to_page_cache.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
prio_tree-debugging-patch.patch

