From: akpm@linux-foundation.org
Subject: [merged] mm-make-remove_migration_ptes-beyond-mm-migrationc.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:08 -0700
Message-ID: <56f04008.7HKizJh79EZAGgYZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbcCUT4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make remove_migration_ptes() beyond mm/migration.c
has been removed from the -mm tree.  Its filename was
     mm-make-remove_migration_ptes-beyond-mm-migrationc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make remove_migration_ptes() beyond mm/migration.c

Make remove_migration_ptes() available to be used in split_huge_page().

New parameter 'locked' added: as with try_to_umap() we need a way to
indicate that caller holds rmap lock.

We also shouldn't try to mlock() pte-mapped huge pages: pte-mapeed THP
pages are never mlocked.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 ++
 mm/migrate.c         |   15 +++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/rmap.h~mm-make-remove_migration_ptes-beyond-mm-migrationc include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-remove_migration_ptes-beyond-mm-migrationc
+++ a/include/linux/rmap.h
@@ -243,6 +243,8 @@ int page_mkclean(struct page *);
  */
 int try_to_munlock(struct page *);
 
+void remove_migration_ptes(struct page *old, struct page *new, bool locked);
+
 /*
  * Called by memory-failure.c to kill processes.
  */
diff -puN mm/migrate.c~mm-make-remove_migration_ptes-beyond-mm-migrationc mm/migrate.c
--- a/mm/migrate.c~mm-make-remove_migration_ptes-beyond-mm-migrationc
+++ a/mm/migrate.c
@@ -172,7 +172,7 @@ static int remove_migration_pte(struct p
 	else
 		page_add_file_rmap(new);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
 		mlock_vma_page(new);
 
 	/* No need to invalidate - it was non-present before */
@@ -187,14 +187,17 @@ out:
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-static void remove_migration_ptes(struct page *old, struct page *new)
+void remove_migration_ptes(struct page *old, struct page *new, bool locked)
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = remove_migration_pte,
 		.arg = old,
 	};
 
-	rmap_walk(new, &rwc);
+	if (locked)
+		rmap_walk_locked(new, &rwc);
+	else
+		rmap_walk(new, &rwc);
 }
 
 /*
@@ -702,7 +705,7 @@ static int writeout(struct address_space
 	 * At this point we know that the migration attempt cannot
 	 * be successful.
 	 */
-	remove_migration_ptes(page, page);
+	remove_migration_ptes(page, page, false);
 
 	rc = mapping->a_ops->writepage(page, &wbc);
 
@@ -900,7 +903,7 @@ static int __unmap_and_move(struct page
 
 	if (page_was_mapped)
 		remove_migration_ptes(page,
-			rc == MIGRATEPAGE_SUCCESS ? newpage : page);
+			rc == MIGRATEPAGE_SUCCESS ? newpage : page, false);
 
 out_unlock_both:
 	unlock_page(newpage);
@@ -1070,7 +1073,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (page_was_mapped)
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage);
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
 
 	unlock_page(new_hpage);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

