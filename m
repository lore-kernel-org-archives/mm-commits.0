From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-migration-use-the-put_new_page-whenever-necessary.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:16:40 -0800
Message-ID: <563d0aa8.AK3rI2hJ038TNJIc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033202AbbKFUQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration use the put_new_page whenever necessary
has been removed from the -mm tree.  Its filename was
     mm-page-migration-use-the-put_new_page-whenever-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
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

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

