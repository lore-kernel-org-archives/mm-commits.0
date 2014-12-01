From: akpm@linux-foundation.org
Subject: + mm-unmapped-page-migration-avoid-unmapremap-overhead.patch
 added to -mm tree
Date: Mon, 01 Dec 2014 13:55:44 -0800
Message-ID: <547ce3e0.4zEXGrsb3tA5TZPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaLAVzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 16:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dave@stgolabs.net, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unmapped page migration avoid unmap+remap overhead
has been added to the -mm tree.  Its filename is
     mm-unmapped-page-migration-avoid-unmapremap-overhead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unmapped-page-migration-avoid-unmapremap-overhead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unmapped-page-migration-avoid-unmapremap-overhead.patch

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

mm-vmscan-count-only-dirty-pages-as-congested.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-mincore-add-hwpoison-page-handle.patch
ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-fix-anon_vma_clone-error-treatment.patch
mm-unmapped-page-migration-avoid-unmapremap-overhead.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

