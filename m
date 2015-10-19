From: akpm@linux-foundation.org
Subject: +
 mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch added to
 -mm tree
Date: Mon, 19 Oct 2015 15:03:34 -0700
Message-ID: <562568b6.6BHKPK4ZzsUZacUn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbJSWDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration remove_migration_ptes at lock+unlock level
has been added to the -mm tree.  Its filename is
     mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch

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
Subject: mm: page migration remove_migration_ptes at lock+unlock level

Clean up page migration a little more by calling remove_migration_ptes()
from the same level, on success or on failure, from __unmap_and_move() or
from unmap_and_move_huge_page().

Don't reset page->mapping of a PageAnon old page in move_to_new_page(),
leave that to when the page is freed.  Except for here in page migration,
it has been an invariant that a PageAnon (bit set in page->mapping) page
stays PageAnon until it is freed, and I think we're safer to keep to that.

And with the above rearrangement, it's necessary because zap_pte_range()
wants to identify whether a migration entry represents a file or an anon
page, to update the appropriate rss stats without waiting on it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN mm/migrate.c~mm-page-migration-remove_migration_ptes-at-lockunlock-level mm/migrate.c
--- a/mm/migrate.c~mm-page-migration-remove_migration_ptes-at-lockunlock-level
+++ a/mm/migrate.c
@@ -722,7 +722,7 @@ static int fallback_migrate_page(struct
  *  MIGRATEPAGE_SUCCESS - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page,
-				int page_was_mapped, enum migrate_mode mode)
+				enum migrate_mode mode)
 {
 	struct address_space *mapping;
 	int rc;
@@ -755,19 +755,21 @@ static int move_to_new_page(struct page
 		 * space which also has its own migratepage callback. This
 		 * is the most common path for page migration.
 		 */
-		rc = mapping->a_ops->migratepage(mapping,
-						newpage, page, mode);
+		rc = mapping->a_ops->migratepage(mapping, newpage, page, mode);
 	else
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
-	if (rc != MIGRATEPAGE_SUCCESS) {
+	/*
+	 * When successful, old pagecache page->mapping must be cleared before
+	 * page is freed; but stats require that PageAnon be left as PageAnon.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		set_page_memcg(page, NULL);
+		if (!PageAnon(page))
+			page->mapping = NULL;
+	} else {
 		set_page_memcg(newpage, NULL);
 		newpage->mapping = NULL;
-	} else {
-		set_page_memcg(page, NULL);
-		if (page_was_mapped)
-			remove_migration_ptes(page, newpage);
-		page->mapping = NULL;
 	}
 	return rc;
 }
@@ -902,10 +904,11 @@ static int __unmap_and_move(struct page
 	}
 
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, page_was_mapped, mode);
+		rc = move_to_new_page(newpage, page, mode);
 
-	if (rc && page_was_mapped)
-		remove_migration_ptes(page, page);
+	if (page_was_mapped)
+		remove_migration_ptes(page,
+			rc == MIGRATEPAGE_SUCCESS ? newpage : page);
 
 out_unlock_both:
 	unlock_page(newpage);
@@ -1066,10 +1069,11 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, page_was_mapped, mode);
+		rc = move_to_new_page(new_hpage, hpage, mode);
 
-	if (rc != MIGRATEPAGE_SUCCESS && page_was_mapped)
-		remove_migration_ptes(hpage, hpage);
+	if (page_was_mapped)
+		remove_migration_ptes(hpage,
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage);
 
 	unlock_page(new_hpage);
 
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

