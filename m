From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-migration-allow-the-migration-of-pageswapcache-pages.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:07:07 -0700
Message-ID: <201004221907.o3MJ771a002178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740Ab0DVTO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: migration: allow the migration of PageSwapCache pages
has been removed from the -mm tree.  Its filename was
     mm-migration-allow-the-migration-of-pageswapcache-pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: migration: allow the migration of PageSwapCache pages
From: Mel Gorman <mel@csn.ul.ie>

PageAnon pages that are unmapped may or may not have an anon_vma so are
not currently migrated.  However, a swap cache page can be migrated and
fits this description.  This patch identifies page swap caches and allows
them to be migrated but ensures that no attempt to made to remap the pages
would would potentially try to access an already freed anon_vma.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff -puN mm/migrate.c~mm-migration-allow-the-migration-of-pageswapcache-pages mm/migrate.c
--- a/mm/migrate.c~mm-migration-allow-the-migration-of-pageswapcache-pages
+++ a/mm/migrate.c
@@ -485,7 +485,8 @@ static int fallback_migrate_page(struct 
  *   < 0 - error code
  *  == 0 - success
  */
-static int move_to_new_page(struct page *newpage, struct page *page)
+static int move_to_new_page(struct page *newpage, struct page *page,
+						int remap_swapcache)
 {
 	struct address_space *mapping;
 	int rc;
@@ -520,10 +521,12 @@ static int move_to_new_page(struct page 
 	else
 		rc = fallback_migrate_page(mapping, newpage, page);
 
-	if (!rc)
-		remove_migration_ptes(page, newpage);
-	else
+	if (rc) {
 		newpage->mapping = NULL;
+	} else {
+		if (remap_swapcache)
+			remove_migration_ptes(page, newpage);
+	}
 
 	unlock_page(newpage);
 
@@ -540,6 +543,7 @@ static int unmap_and_move(new_page_t get
 	int rc = 0;
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
+	int remap_swapcache = 1;
 	int rcu_locked = 0;
 	int charge = 0;
 	struct mem_cgroup *mem = NULL;
@@ -601,18 +605,27 @@ static int unmap_and_move(new_page_t get
 		rcu_read_lock();
 		rcu_locked = 1;
 
-		/*
-		 * If the page has no mappings any more, just bail. An
-		 * unmapped anon page is likely to be freed soon but worse,
-		 * it's possible its anon_vma disappeared between when
-		 * the page was isolated and when we reached here while
-		 * the RCU lock was not held
-		 */
-		if (!page_mapped(page))
-			goto rcu_unlock;
+		/* Determine how to safely use anon_vma */
+		if (!page_mapped(page)) {
+			if (!PageSwapCache(page))
+				goto rcu_unlock;
 
-		anon_vma = page_anon_vma(page);
-		atomic_inc(&anon_vma->external_refcount);
+			/*
+			 * We cannot be sure that the anon_vma of an unmapped
+			 * swapcache page is safe to use. In this case, the
+			 * swapcache page gets migrated but the pages are not
+			 * remapped
+			 */
+			remap_swapcache = 0;
+		} else {
+			/*
+			 * Take a reference count on the anon_vma if the
+			 * page is mapped so that it is guaranteed to
+			 * exist when the page is remapped later
+			 */
+			anon_vma = page_anon_vma(page);
+			atomic_inc(&anon_vma->external_refcount);
+		}
 	}
 
 	/*
@@ -647,9 +660,9 @@ static int unmap_and_move(new_page_t get
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page);
+		rc = move_to_new_page(newpage, page, remap_swapcache);
 
-	if (rc)
+	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
 rcu_unlock:
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

