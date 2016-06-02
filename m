From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 12:49:31 -0700
Message-ID: <57508dcb.yeJwWB4Mvr4decxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcFBTtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: introduce split_page_owner and replace manual handling
has been added to the -mm tree.  Its filename is
     mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: introduce split_page_owner and replace manual handling

split_page() calls set_page_owner() to set up page_owner to each pages. 
But, it has a drawback that head page and the others have different
stacktrace because callsite of set_page_owner() is slightly differnt.  To
avoid this problem, this patch copies head page's page_owner to the
others.  It needs to introduce new function, split_page_owner() but it
also remove the other function, get_page_owner_gfp() so looks good to do.

Link: http://lkml.kernel.org/r/1464230275-25791-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   12 +++++-------
 mm/page_alloc.c            |    8 ++------
 mm/page_owner.c            |   14 +++++++-------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff -puN include/linux/page_owner.h~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling
+++ a/include/linux/page_owner.h
@@ -10,7 +10,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned int order);
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
-extern gfp_t __get_page_owner_gfp(struct page *page);
+extern void __split_page_owner(struct page *page, unsigned int order);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(struct page *page);
@@ -28,12 +28,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline gfp_t get_page_owner_gfp(struct page *page)
+static inline void split_page_owner(struct page *page, unsigned int order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		return __get_page_owner_gfp(page);
-	else
-		return 0;
+		__split_page_owner(page, order);
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
@@ -58,9 +56,9 @@ static inline void set_page_owner(struct
 			unsigned int order, gfp_t gfp_mask)
 {
 }
-static inline gfp_t get_page_owner_gfp(struct page *page)
+static inline void split_page_owner(struct page *page,
+			unsigned int order)
 {
-	return 0;
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
diff -puN mm/page_alloc.c~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling
+++ a/mm/page_alloc.c
@@ -2459,7 +2459,6 @@ void free_hot_cold_page_list(struct list
 void split_page(struct page *page, unsigned int order)
 {
 	int i;
-	gfp_t gfp_mask;
 
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
@@ -2473,12 +2472,9 @@ void split_page(struct page *page, unsig
 		split_page(virt_to_page(page[0].shadow), order);
 #endif
 
-	gfp_mask = get_page_owner_gfp(page);
-	set_page_owner(page, 0, gfp_mask);
-	for (i = 1; i < (1 << order); i++) {
+	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-		set_page_owner(page + i, 0, gfp_mask);
-	}
+	split_page_owner(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
diff -puN mm/page_owner.c~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-introduce-split_page_owner-and-replace-manual-handling
+++ a/mm/page_owner.c
@@ -94,17 +94,17 @@ void __set_page_owner_migrate_reason(str
 	page_ext->last_migrate_reason = reason;
 }
 
-gfp_t __get_page_owner_gfp(struct page *page)
+void __split_page_owner(struct page *page, unsigned int order)
 {
+	int i;
 	struct page_ext *page_ext = lookup_page_ext(page);
+
 	if (unlikely(!page_ext))
-		/*
-		 * The caller just returns 0 if no valid gfp
-		 * So return 0 here too.
-		 */
-		return 0;
+		return;
 
-	return page_ext->gfp_mask;
+	page_ext->order = 0;
+	for (i = 1; i < (1 << order); i++)
+		__copy_page_owner(page, page + i);
 }
 
 void __copy_page_owner(struct page *oldpage, struct page *newpage)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

