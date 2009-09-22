From: akpm@linux-foundation.org
Subject: [merged] mm-return-boolean-from-page_has_private.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:48 -0700
Message-ID: <200909222041.n8MKfmE3008316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZIVUlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: return boolean from page_has_private()
has been removed from the -mm tree.  Its filename was
     mm-return-boolean-from-page_has_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: return boolean from page_has_private()
From: Johannes Weiner <hannes@cmpxchg.org>

Make page_has_private() return a true boolean value and remove the double
negations from the two callsites using it for arithmetic.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   13 ++++++++-----
 mm/migrate.c               |    2 +-
 mm/vmscan.c                |    2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/page-flags.h~mm-return-boolean-from-page_has_private include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-return-boolean-from-page_has_private
+++ a/include/linux/page-flags.h
@@ -402,8 +402,8 @@ static inline void __ClearPageTail(struc
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
 
-#endif /* !__GENERATING_BOUNDS_H */
-
+#define PAGE_FLAGS_PRIVATE				\
+	(1 << PG_private | 1 << PG_private_2)
 /**
  * page_has_private - Determine if page has private stuff
  * @page: The page to be checked
@@ -411,8 +411,11 @@ static inline void __ClearPageTail(struc
  * Determine if a page has private stuff, indicating that release routines
  * should be invoked upon it.
  */
-#define page_has_private(page)			\
-	((page)->flags & ((1 << PG_private) |	\
-			  (1 << PG_private_2)))
+static inline int page_has_private(struct page *page)
+{
+	return !!(page->flags & PAGE_FLAGS_PRIVATE);
+}
+
+#endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/migrate.c~mm-return-boolean-from-page_has_private mm/migrate.c
--- a/mm/migrate.c~mm-return-boolean-from-page_has_private
+++ a/mm/migrate.c
@@ -272,7 +272,7 @@ static int migrate_page_move_mapping(str
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + !!page_has_private(page);
+	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
diff -puN mm/vmscan.c~mm-return-boolean-from-page_has_private mm/vmscan.c
--- a/mm/vmscan.c~mm-return-boolean-from-page_has_private
+++ a/mm/vmscan.c
@@ -286,7 +286,7 @@ static inline int page_mapping_inuse(str
 
 static inline int is_page_cache_freeable(struct page *page)
 {
-	return page_count(page) - !!page_has_private(page) == 2;
+	return page_count(page) - page_has_private(page) == 2;
 }
 
 static int may_write_to_queue(struct backing_dev_info *bdi)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

