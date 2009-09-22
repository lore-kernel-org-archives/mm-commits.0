From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-migrate-swap-cache-page.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:37 -0700
Message-ID: <200909222037.n8MKbbgo032241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbZIVUiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: migrate swap cache page
has been removed from the -mm tree.  Its filename was
     memory-hotplug-migrate-swap-cache-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: migrate swap cache page
From: Shaohua Li <shaohua.li@intel.com>

In test, some pages in swap-cache can't be migrated, as they aren't rmap.

unmap_and_move() ignores swap-cache page which is just read in and hasn't
rmap (see the comments in the code), but swap_aops provides .migratepage. 
Better to migrate such pages instead of ignore them.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yakui Zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~memory-hotplug-migrate-swap-cache-page mm/migrate.c
--- a/mm/migrate.c~memory-hotplug-migrate-swap-cache-page
+++ a/mm/migrate.c
@@ -147,7 +147,7 @@ out:
 static void remove_file_migration_ptes(struct page *old, struct page *new)
 {
 	struct vm_area_struct *vma;
-	struct address_space *mapping = page_mapping(new);
+	struct address_space *mapping = new->mapping;
 	struct prio_tree_iter iter;
 	pgoff_t pgoff = new->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -664,13 +664,15 @@ static int unmap_and_move(new_page_t get
 			 *    needs to be effective.
 			 */
 			try_to_free_buffers(page);
+			goto rcu_unlock;
 		}
-		goto rcu_unlock;
+		goto skip_unmap;
 	}
 
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
+skip_unmap:
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page);
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

