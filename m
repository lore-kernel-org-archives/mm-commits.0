From: akpm@linux-foundation.org
Subject: [merged]
 mm-unmapped-page-migration-avoid-unmapremap-overhead.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:11 -0800
Message-ID: <548d0d2b.yvWHDw75mHUqSFVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dave@stgolabs.net, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unmapped page migration avoid unmap+remap overhead
has been removed from the -mm tree.  Its filename was
     mm-unmapped-page-migration-avoid-unmapremap-overhead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: unmapped page migration avoid unmap+remap overhead

Page migration's __unmap_and_move(), and rmap's try_to_unmap(), were
created for use on pages almost certainly mapped into userspace.  But
nowadays compaction often applies them to unmapped page cache pages: which
may exacerbate contention on i_mmap_rwsem quite unnecessarily, since
try_to_unmap_file() makes no preliminary page_mapped() check.

Now check page_mapped() in __unmap_and_move(); and avoid repeating the
same overhead in rmap_walk_file() - don't remove_migration_ptes() when we
never inserted any.

(The PageAnon(page) comment blocks now look even sillier than before, but
clean that up on some other occasion.  And note in passing that
try_to_unmap_one() does not use a migration entry when PageSwapCache, so
remove_migration_ptes() will then not update that swap entry to newpage
pte: not a big deal, but something else to clean up later.)

Davidlohr remarked in "mm,fs: introduce helpers around the i_mmap_mutex"
conversion to i_mmap_rwsem, that "The biggest winner of these changes is
migration": a part of the reason might be all of that unnecessary taking
of i_mmap_mutex in page migration; and it's rather a shame that I didn't
get around to sending this patch in before his - this one is much less
useful after Davidlohr's conversion to rwsem, but still good.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN mm/migrate.c~mm-unmapped-page-migration-avoid-unmapremap-overhead mm/migrate.c
--- a/mm/migrate.c~mm-unmapped-page-migration-avoid-unmapremap-overhead
+++ a/mm/migrate.c
@@ -746,7 +746,7 @@ static int fallback_migrate_page(struct
  *  MIGRATEPAGE_SUCCESS - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page,
-				int remap_swapcache, enum migrate_mode mode)
+				int page_was_mapped, enum migrate_mode mode)
 {
 	struct address_space *mapping;
 	int rc;
@@ -784,7 +784,7 @@ static int move_to_new_page(struct page
 		newpage->mapping = NULL;
 	} else {
 		mem_cgroup_migrate(page, newpage, false);
-		if (remap_swapcache)
+		if (page_was_mapped)
 			remove_migration_ptes(page, newpage);
 		page->mapping = NULL;
 	}
@@ -798,7 +798,7 @@ static int __unmap_and_move(struct page
 				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	int remap_swapcache = 1;
+	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!trylock_page(page)) {
@@ -870,7 +870,6 @@ static int __unmap_and_move(struct page
 			 * migrated but are not remapped when migration
 			 * completes
 			 */
-			remap_swapcache = 0;
 		} else {
 			goto out_unlock;
 		}
@@ -910,13 +909,17 @@ static int __unmap_and_move(struct page
 	}
 
 	/* Establish migration ptes or remove ptes */
-	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+	if (page_mapped(page)) {
+		try_to_unmap(page,
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+		page_was_mapped = 1;
+	}
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, remap_swapcache, mode);
+		rc = move_to_new_page(newpage, page, page_was_mapped, mode);
 
-	if (rc && remap_swapcache)
+	if (rc && page_was_mapped)
 		remove_migration_ptes(page, page);
 
 	/* Drop an anon_vma reference if we took one */
@@ -1017,6 +1020,7 @@ static int unmap_and_move_huge_page(new_
 {
 	int rc = 0;
 	int *result = NULL;
+	int page_was_mapped = 0;
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 
@@ -1047,12 +1051,16 @@ static int unmap_and_move_huge_page(new_
 	if (PageAnon(hpage))
 		anon_vma = page_get_anon_vma(hpage);
 
-	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+	if (page_mapped(hpage)) {
+		try_to_unmap(hpage,
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+		page_was_mapped = 1;
+	}
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, 1, mode);
+		rc = move_to_new_page(new_hpage, hpage, page_was_mapped, mode);
 
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc != MIGRATEPAGE_SUCCESS && page_was_mapped)
 		remove_migration_ptes(hpage, hpage);
 
 	if (anon_vma)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
linux-next.patch

