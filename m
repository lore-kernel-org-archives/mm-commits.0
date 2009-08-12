From: akpm@linux-foundation.org
Subject: + mm-return-boolean-from-page_has_private.patch added to -mm tree
Date: Wed, 12 Aug 2009 15:57:08 -0700
Message-ID: <200908122257.n7CMv8YL021699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbZHLW5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, cl@linux-foundation.org


The patch titled
     mm: return boolean from page_has_private()
has been added to the -mm tree.  Its filename is
     mm-return-boolean-from-page_has_private.patch

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
Subject: mm: return boolean from page_has_private()
From: Johannes Weiner <hannes@cmpxchg.org>

Make page_has_private() return a true boolean value and remove the double
negations from the two callsites using it for arithmetic.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   13 ++++++++-----
 mm/migrate.c               |    2 +-
 mm/vmscan.c                |    2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/page-flags.h~mm-return-boolean-from-page_has_private include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-return-boolean-from-page_has_private
+++ a/include/linux/page-flags.h
@@ -417,8 +417,8 @@ static inline void __ClearPageTail(struc
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
 
-#endif /* !__GENERATING_BOUNDS_H */
-
+#define PAGE_FLAGS_PRIVATE				\
+	(1 << PG_private | 1 << PG_private_2)
 /**
  * page_has_private - Determine if page has private stuff
  * @page: The page to be checked
@@ -426,8 +426,11 @@ static inline void __ClearPageTail(struc
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
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
linux-next.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch

