From: akpm@linux-foundation.org
Subject: + mm-page-migration-use-the-put_new_page-whenever-necessary.patch added to -mm tree
Date: Mon, 19 Oct 2015 15:03:30 -0700
Message-ID: <562568b2.WCBUria7XCjDbZT4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbbJSWDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration use the put_new_page whenever necessary
has been added to the -mm tree.  Its filename is
     mm-page-migration-use-the-put_new_page-whenever-necessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-migration-use-the-put_new_page-whenever-necessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-migration-use-the-put_new_page-whenever-necessary.patch

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
Subject: mm: page migration use the put_new_page whenever necessary

I don't know of any problem from the way it's used in our current tree,
but there is one defect in page migration's custom put_new_page feature.

An unused newpage is expected to be released with the put_new_page(), but
there was one MIGRATEPAGE_SUCCESS (0) path which released it with
putback_lru_page(): which can be very wrong for a custom pool.

Fixed more easily by resetting put_new_page once it won't be needed, than
by adding a further flag to modify the rc test.

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

 mm/migrate.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/migrate.c~mm-page-migration-use-the-put_new_page-whenever-necessary mm/migrate.c
--- a/mm/migrate.c~mm-page-migration-use-the-put_new_page-whenever-necessary
+++ a/mm/migrate.c
@@ -938,10 +938,11 @@ static ICE_noinline int unmap_and_move(n
 				   int force, enum migrate_mode mode,
 				   enum migrate_reason reason)
 {
-	int rc = 0;
+	int rc = MIGRATEPAGE_SUCCESS;
 	int *result = NULL;
-	struct page *newpage = get_new_page(page, private, &result);
+	struct page *newpage;
 
+	newpage = get_new_page(page, private, &result);
 	if (!newpage)
 		return -ENOMEM;
 
@@ -955,6 +956,8 @@ static ICE_noinline int unmap_and_move(n
 			goto out;
 
 	rc = __unmap_and_move(page, newpage, force, mode);
+	if (rc == MIGRATEPAGE_SUCCESS)
+		put_new_page = NULL;
 
 out:
 	if (rc != -EAGAIN) {
@@ -981,7 +984,7 @@ out:
 	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
 	 * during isolation.
 	 */
-	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
+	if (put_new_page) {
 		ClearPageSwapBacked(newpage);
 		put_new_page(newpage, private);
 	} else if (unlikely(__is_movable_balloon_page(newpage))) {
@@ -1022,7 +1025,7 @@ static int unmap_and_move_huge_page(new_
 				struct page *hpage, int force,
 				enum migrate_mode mode)
 {
-	int rc = 0;
+	int rc = -EAGAIN;
 	int *result = NULL;
 	int page_was_mapped = 0;
 	struct page *new_hpage;
@@ -1044,8 +1047,6 @@ static int unmap_and_move_huge_page(new_
 	if (!new_hpage)
 		return -ENOMEM;
 
-	rc = -EAGAIN;
-
 	if (!trylock_page(hpage)) {
 		if (!force || mode != MIGRATE_SYNC)
 			goto out;
@@ -1070,8 +1071,10 @@ static int unmap_and_move_huge_page(new_
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
-	if (rc == MIGRATEPAGE_SUCCESS)
+	if (rc == MIGRATEPAGE_SUCCESS) {
 		hugetlb_cgroup_migrate(hpage, new_hpage);
+		put_new_page = NULL;
+	}
 
 	unlock_page(hpage);
 out:
@@ -1083,7 +1086,7 @@ out:
 	 * it.  Otherwise, put_page() will drop the reference grabbed during
 	 * isolation.
 	 */
-	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+	if (put_new_page)
 		put_new_page(new_hpage, private);
 	else
 		putback_active_hugepage(new_hpage);
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

