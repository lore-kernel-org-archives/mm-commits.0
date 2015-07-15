From: akpm@linux-foundation.org
Subject: + mm-page_owner-set-correct-gfp_mask-on-page_owner.patch added to -mm tree
Date: Wed, 15 Jul 2015 14:16:38 -0700
Message-ID: <55a6cdb6.WgBoMvTimIR9unei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbGOVQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: set correct gfp_mask on page_owner
has been added to the -mm tree.  Its filename is
     mm-page_owner-set-correct-gfp_mask-on-page_owner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-set-correct-gfp_mask-on-page_owner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-set-correct-gfp_mask-on-page_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/page_owner: set correct gfp_mask on page_owner

Currently, we set wrong gfp_mask to page_owner info in case of isolated
freepage by compaction and split page.  It causes incorrect mixed
pageblock report that we can get from '/proc/pagetypeinfo'.  This metric
is really useful to measure fragmentation effect so should be accurate. 
This patch fixes it by setting correct information.

Without this patch, after kernel build workload is finished, number of
mixed pageblock is 112 among roughly 210 movable pageblocks.

But, with this fix, output shows that mixed pageblock is just 57.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   13 +++++++++++++
 mm/page_alloc.c            |    8 +++++---
 mm/page_owner.c            |    7 +++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff -puN include/linux/page_owner.h~mm-page_owner-set-correct-gfp_mask-on-page_owner include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-set-correct-gfp_mask-on-page_owner
+++ a/include/linux/page_owner.h
@@ -8,6 +8,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned int order);
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
+extern gfp_t __get_page_owner_gfp(struct page *page);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -25,6 +26,14 @@ static inline void set_page_owner(struct
 
 	__set_page_owner(page, order, gfp_mask);
 }
+
+static inline gfp_t get_page_owner_gfp(struct page *page)
+{
+	if (likely(!page_owner_inited))
+		return 0;
+
+	return __get_page_owner_gfp(page);
+}
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -33,6 +42,10 @@ static inline void set_page_owner(struct
 			unsigned int order, gfp_t gfp_mask)
 {
 }
+static inline gfp_t get_page_owner_gfp(struct page *page)
+{
+	return 0;
+}
 
 #endif /* CONFIG_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff -puN mm/page_alloc.c~mm-page_owner-set-correct-gfp_mask-on-page_owner mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-set-correct-gfp_mask-on-page_owner
+++ a/mm/page_alloc.c
@@ -1948,6 +1948,7 @@ void free_hot_cold_page_list(struct list
 void split_page(struct page *page, unsigned int order)
 {
 	int i;
+	gfp_t gfp_mask;
 
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
@@ -1961,10 +1962,11 @@ void split_page(struct page *page, unsig
 		split_page(virt_to_page(page[0].shadow), order);
 #endif
 
-	set_page_owner(page, 0, 0);
+	gfp_mask = get_page_owner_gfp(page);
+	set_page_owner(page, 0, gfp_mask);
 	for (i = 1; i < (1 << order); i++) {
 		set_page_refcounted(page + i);
-		set_page_owner(page + i, 0, 0);
+		set_page_owner(page + i, 0, gfp_mask);
 	}
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -1994,7 +1996,7 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	set_page_owner(page, order, 0);
+	set_page_owner(page, order, __GFP_MOVABLE);
 
 	/* Set the pageblock if the isolated page is at least a pageblock */
 	if (order >= pageblock_order - 1) {
diff -puN mm/page_owner.c~mm-page_owner-set-correct-gfp_mask-on-page_owner mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-set-correct-gfp_mask-on-page_owner
+++ a/mm/page_owner.c
@@ -76,6 +76,13 @@ void __set_page_owner(struct page *page,
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
 
+gfp_t __get_page_owner_gfp(struct page *page)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
+
+	return page_ext->gfp_mask;
+}
+
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_ext *page_ext)
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch

