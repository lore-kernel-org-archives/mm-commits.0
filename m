From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-calling-a-compound-page-destructor.patch
 added to -mm tree
Date: Mon, 18 May 2020 14:49:28 -0700
Message-ID: <20200518214928.FdFQxJXvK%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgERVt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:49:29 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm: simplify calling a compound page destructor
has been added to the -mm tree.  Its filename is
     mm-simplify-calling-a-compound-page-destructor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-calling-a-compound-page-destructor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-calling-a-compound-page-destructor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify calling a compound page destructor

None of the three callers of get_compound_page_dtor() want to know the
value; they just want to call the function.  Replace it with
destroy_compound_page() which calls the dtor for them.

Link: http://lkml.kernel.org/r/20200517105051.9352-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Ackedy-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/swap.c          |    5 +----
 mm/vmscan.c        |    4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-simplify-calling-a-compound-page-destructor
+++ a/include/linux/mm.h
@@ -868,10 +868,10 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
+static inline void destroy_compound_page(struct page *page)
 {
 	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
-	return compound_page_dtors[page[1].compound_dtor];
+	compound_page_dtors[page[1].compound_dtor](page);
 }
 
 static inline unsigned int compound_order(struct page *page)
--- a/mm/swap.c~mm-simplify-calling-a-compound-page-destructor
+++ a/mm/swap.c
@@ -83,8 +83,6 @@ static void __put_single_page(struct pag
 
 static void __put_compound_page(struct page *page)
 {
-	compound_page_dtor *dtor;
-
 	/*
 	 * __page_cache_release() is supposed to be called for thp, not for
 	 * hugetlb. This is because hugetlb page does never have PageLRU set
@@ -93,8 +91,7 @@ static void __put_compound_page(struct p
 	 */
 	if (!PageHuge(page))
 		__page_cache_release(page);
-	dtor = get_compound_page_dtor(page);
-	(*dtor)(page);
+	destroy_compound_page(page);
 }
 
 void __put_page(struct page *page)
--- a/mm/vmscan.c~mm-simplify-calling-a-compound-page-destructor
+++ a/mm/vmscan.c
@@ -1442,7 +1442,7 @@ free_it:
 		 * appear not as the counts should be low
 		 */
 		if (unlikely(PageTransHuge(page)))
-			(*get_compound_page_dtor(page))(page);
+			destroy_compound_page(page);
 		else
 			list_add(&page->lru, &free_pages);
 		continue;
@@ -1870,7 +1870,7 @@ static unsigned noinline_for_stack move_
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
-				(*get_compound_page_dtor(page))(page);
+				destroy_compound_page(page);
 				spin_lock_irq(&pgdat->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-readahead-prototypes-from-mmh.patch
mm-return-void-from-various-readahead-functions.patch
mm-ignore-return-value-of-readpages.patch
mm-move-readahead-nr_pages-check-into-read_pages.patch
mm-add-new-readahead_control-api.patch
mm-use-readahead_control-to-pass-arguments.patch
mm-rename-various-offset-parameters-to-index.patch
mm-rename-readahead-loop-variable-to-i.patch
mm-remove-page_offset-from-readahead-loop.patch
mm-put-readahead-pages-in-cache-earlier.patch
mm-add-readahead-address-space-operation.patch
mm-move-end_index-check-out-of-readahead-loop.patch
mm-add-page_cache_readahead_unbounded.patch
mm-document-why-we-dont-set-pagereadahead.patch
mm-use-memalloc_nofs_save-in-readahead-path.patch
fs-convert-mpage_readpages-to-mpage_readahead.patch
btrfs-convert-from-readpages-to-readahead.patch
erofs-convert-uncompressed-files-from-readpages-to-readahead.patch
erofs-convert-compressed-files-from-readpages-to-readahead.patch
ext4-convert-from-readpages-to-readahead.patch
ext4-pass-the-inode-to-ext4_mpage_readpages.patch
f2fs-convert-from-readpages-to-readahead.patch
f2fs-pass-the-inode-to-f2fs_mpage_readpages.patch
fuse-convert-from-readpages-to-readahead.patch
fuse-convert-from-readpages-to-readahead-fix.patch
iomap-convert-from-readpages-to-readahead.patch
mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
