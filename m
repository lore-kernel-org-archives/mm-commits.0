From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug_pagealloc-clean-up-guard-page-handling-code.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:43:29 -0700
Message-ID: <57fc1991.Tzg3VAd4LfB2ameY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36629 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbcJJWnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_pagealloc.c: clean-up guard page handling code
has been removed from the -mm tree.  Its filename was
     mm-debug_pagealloc-clean-up-guard-page-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug_pagealloc.c: clean-up guard page handling code

Patch series "Reduce memory waste by page extension user".


This patchset tries to reduce memory waste by page extension user.

First case is architecture supported debug_pagealloc.  It doesn't requires
additional memory if guard page isn't used.  8 bytes per page will be
saved in this case.

Second case is related to page owner feature.  Until now, if page_ext
users want to use it's own fields on page_ext, fields should be defined in
struct page_ext by hard-coding.  It has a following problem.

struct page_ext {
 #ifdef CONFIG_A
	int a;
 #endif
 #ifdef CONFIG_B
	int b;
 #endif
};

Assume that kernel is built with both CONFIG_A and CONFIG_B.  Even if we
enable feature A and doesn't enable feature B at runtime, each entry of
struct page_ext takes two int rather than one int.  It's undesirable waste
so this patch tries to reduce it.  By this patchset, we can save 20 bytes
per page dedicated for page owner feature in some configurations.  



This patch (of 6):

We can make code clean by moving decision condition for set_page_guard()
into set_page_guard() itself.  It will help code readability.  There is no
functional change.

Link: http://lkml.kernel.org/r/1471315879-32294-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-debug_pagealloc-clean-up-guard-page-handling-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug_pagealloc-clean-up-guard-page-handling-code
+++ a/mm/page_alloc.c
@@ -637,17 +637,20 @@ static int __init debug_guardpage_minord
 }
 __setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
 
-static inline void set_page_guard(struct zone *zone, struct page *page,
+static inline bool set_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype)
 {
 	struct page_ext *page_ext;
 
 	if (!debug_guardpage_enabled())
-		return;
+		return false;
+
+	if (order >= debug_guardpage_minorder())
+		return false;
 
 	page_ext = lookup_page_ext(page);
 	if (unlikely(!page_ext))
-		return;
+		return false;
 
 	__set_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
 
@@ -655,6 +658,8 @@ static inline void set_page_guard(struct
 	set_page_private(page, order);
 	/* Guard pages are not available for any usage */
 	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
+
+	return true;
 }
 
 static inline void clear_page_guard(struct zone *zone, struct page *page,
@@ -677,8 +682,8 @@ static inline void clear_page_guard(stru
 }
 #else
 struct page_ext_operations debug_guardpage_ops = { NULL, };
-static inline void set_page_guard(struct zone *zone, struct page *page,
-				unsigned int order, int migratetype) {}
+static inline bool set_page_guard(struct zone *zone, struct page *page,
+			unsigned int order, int migratetype) { return false; }
 static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype) {}
 #endif
@@ -1622,18 +1627,15 @@ static inline void expand(struct zone *z
 		size >>= 1;
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
 
-		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
-			debug_guardpage_enabled() &&
-			high < debug_guardpage_minorder()) {
-			/*
-			 * Mark as guard pages (or page), that will allow to
-			 * merge back to allocator when buddy will be freed.
-			 * Corresponding page table entries will not be touched,
-			 * pages will stay not present in virtual address space
-			 */
-			set_page_guard(zone, &page[size], high, migratetype);
+		/*
+		 * Mark as guard pages (or page), that will allow to
+		 * merge back to allocator when buddy will be freed.
+		 * Corresponding page table entries will not be touched,
+		 * pages will stay not present in virtual address space
+		 */
+		if (set_page_guard(zone, &page[size], high, migratetype))
 			continue;
-		}
+
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch

