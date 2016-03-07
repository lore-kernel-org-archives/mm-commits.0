From: akpm@linux-foundation.org
Subject: + mm-make-remove_migration_ptes-beyond-mm-migrationc.patch added
 to -mm tree
Date: Mon, 07 Mar 2016 14:43:25 -0800
Message-ID: <56de040d.p7jChNeqs2vNNbUx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbcCGWn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2016 17:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make remove_migration_ptes() beyond mm/migration.c
has been added to the -mm tree.  Its filename is
     mm-make-remove_migration_ptes-beyond-mm-migrationc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-remove_migration_ptes-beyond-mm-migrationc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-cleanup-pte_alloc-interfaces.patch
rmap-introduce-rmap_walk_locked.patch
rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch
mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

