From: akpm@linux-foundation.org
Subject: + mm-migration-allow-the-migration-of-pageswapcache-pages.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:28 -0700
Message-ID: <201004070007.o3707Tmo016435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab0DGAHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: migration: allow the migration of PageSwapCache pages
has been added to the -mm tree.  Its filename is
     mm-migration-allow-the-migration-of-pageswapcache-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

