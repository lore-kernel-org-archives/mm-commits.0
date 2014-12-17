From: akpm@linux-foundation.org
Subject: + mm-protect-set_page_dirty-from-ongoing-truncation.patch added
 to -mm tree
Date: Wed, 17 Dec 2014 13:34:55 -0800
Message-ID: <5491f6ff.8J6LoSrIUsbI2od0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLQVe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jack@suse.cz, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: protect set_page_dirty() from ongoing truncation
has been added to the -mm tree.  Its filename is
     mm-protect-set_page_dirty-from-ongoing-truncation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-protect-set_page_dirty-from-ongoing-truncation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-protect-set_page_dirty-from-ongoing-truncation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: protect set_page_dirty() from ongoing truncation

Tejun, while reviewing the code, spotted the following race condition
between the dirtying and truncation of a page:

__set_page_dirty_nobuffers()       __delete_from_page_cache()
  if (TestSetPageDirty(page))
                                     page->mapping = NULL
				     if (PageDirty())
				       dec_zone_page_state(page, NR_FILE_DIRTY);
				       dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
    if (page->mapping)
      account_page_dirtied(page)
        __inc_zone_page_state(page, NR_FILE_DIRTY);
	__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);

which results in an imbalance of NR_FILE_DIRTY and BDI_RECLAIMABLE.

Dirtiers usually lock out truncation, either by holding the page lock
directly, or in case of zap_pte_range(), by pinning the mapcount with the
page table lock held.  The notable exception to this rule, though, is
do_wp_page(), for which this race exists.  However, do_wp_page() already
waits for a locked page to unlock before setting the dirty bit, in order
to prevent a race where clear_page_dirty() misses the page bit in the
presence of dirty ptes.  Upgrade that wait to a fully locked
set_page_dirty() to also cover the situation explained above.

Afterwards, the code in set_page_dirty() dealing with a truncation race is
no longer needed.  Remove it.

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    1 
 mm/memory.c               |   27 ++++++++++++++--------
 mm/page-writeback.c       |   43 ++++++++++--------------------------
 3 files changed, 29 insertions(+), 42 deletions(-)

diff -puN include/linux/writeback.h~mm-protect-set_page_dirty-from-ongoing-truncation include/linux/writeback.h
--- a/include/linux/writeback.h~mm-protect-set_page_dirty-from-ongoing-truncation
+++ a/include/linux/writeback.h
@@ -177,7 +177,6 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
-void set_page_dirty_balance(struct page *page);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
diff -puN mm/memory.c~mm-protect-set_page_dirty-from-ongoing-truncation mm/memory.c
--- a/mm/memory.c~mm-protect-set_page_dirty-from-ongoing-truncation
+++ a/mm/memory.c
@@ -2137,17 +2137,24 @@ reuse:
 		if (!dirty_page)
 			return ret;
 
-		/*
-		 * Yes, Virginia, this is actually required to prevent a race
-		 * with clear_page_dirty_for_io() from clearing the page dirty
-		 * bit after it clear all dirty ptes, but before a racing
-		 * do_wp_page installs a dirty pte.
-		 *
-		 * do_shared_fault is protected similarly.
-		 */
 		if (!page_mkwrite) {
-			wait_on_page_locked(dirty_page);
-			set_page_dirty_balance(dirty_page);
+			struct address_space *mapping;
+			int dirtied;
+
+			lock_page(dirty_page);
+			dirtied = set_page_dirty(dirty_page);
+			VM_BUG_ON_PAGE(PageAnon(dirty_page), dirty_page);
+			mapping = dirty_page->mapping;
+			unlock_page(dirty_page);
+
+			if (dirtied && mapping) {
+				/*
+				 * Some device drivers do not set page.mapping
+				 * but still dirty their pages
+				 */
+				balance_dirty_pages_ratelimited(mapping);
+			}
+
 			/* file_update_time outside page_lock */
 			if (vma->vm_file)
 				file_update_time(vma->vm_file);
diff -puN mm/page-writeback.c~mm-protect-set_page_dirty-from-ongoing-truncation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-protect-set_page_dirty-from-ongoing-truncation
+++ a/mm/page-writeback.c
@@ -1541,16 +1541,6 @@ pause:
 		bdi_start_background_writeback(bdi);
 }
 
-void set_page_dirty_balance(struct page *page)
-{
-	if (set_page_dirty(page)) {
-		struct address_space *mapping = page_mapping(page);
-
-		if (mapping)
-			balance_dirty_pages_ratelimited(mapping);
-	}
-}
-
 static DEFINE_PER_CPU(int, bdp_ratelimits);
 
 /*
@@ -2123,32 +2113,25 @@ EXPORT_SYMBOL(account_page_dirtied);
  * page dirty in that case, but not all the buffers.  This is a "bottom-up"
  * dirtying, whereas __set_page_dirty_buffers() is a "top-down" dirtying.
  *
- * Most callers have locked the page, which pins the address_space in memory.
- * But zap_pte_range() does not lock the page, however in that case the
- * mapping is pinned by the vma's ->vm_file reference.
- *
- * We take care to handle the case where the page was truncated from the
- * mapping by re-checking page_mapping() inside tree_lock.
+ * The caller must ensure this doesn't race with truncation.  Most will simply
+ * hold the page lock, but e.g. zap_pte_range() calls with the page mapped and
+ * the pte lock held, which also locks out truncation.
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
-		struct address_space *mapping2;
 		unsigned long flags;
 
 		if (!mapping)
 			return 1;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
-		mapping2 = page_mapping(page);
-		if (mapping2) { /* Race with truncate? */
-			BUG_ON(mapping2 != mapping);
-			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
-			account_page_dirtied(page, mapping);
-			radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-		}
+		BUG_ON(page_mapping(page) != mapping);
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		account_page_dirtied(page, mapping);
+		radix_tree_tag_set(&mapping->page_tree, page_index(page),
+				   PAGECACHE_TAG_DIRTY);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
@@ -2305,12 +2288,10 @@ int clear_page_dirty_for_io(struct page
 		/*
 		 * We carefully synchronise fault handlers against
 		 * installing a dirty pte and marking the page dirty
-		 * at this point. We do this by having them hold the
-		 * page lock at some point after installing their
-		 * pte, but before marking the page dirty.
-		 * Pages are always locked coming in here, so we get
-		 * the desired exclusion. See mm/memory.c:do_wp_page()
-		 * for more comments.
+		 * at this point.  We do this by having them hold the
+		 * page lock while dirtying the page, and pages are
+		 * always locked coming in here, so we get the desired
+		 * exclusion.
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch

