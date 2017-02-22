From: akpm@linux-foundation.org
Subject: [patch 042/142] mm, page_alloc: avoid page_to_pfn() when merging
 buddies
Date: Wed, 22 Feb 2017 15:41:51 -0800
Message-ID: <58ae21bf.sSQbD3V4QHS7d1Pm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934551AbdBVXmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: avoid page_to_pfn() when merging buddies

On architectures that allow memory holes, page_is_buddy() has to perform
page_to_pfn() to check for the memory hole.  After the previous patch, we
have the pfn already available in __free_one_page(), which is the only
caller of page_is_buddy(), so move the check there and avoid
page_to_pfn().

Link: http://lkml.kernel.org/r/20161216120009.20064-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   10 +++++-----
 mm/page_isolation.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-page_to_pfn-when-merging-buddies mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-page_to_pfn-when-merging-buddies
+++ a/mm/page_alloc.c
@@ -714,7 +714,7 @@ static inline void rmv_page_order(struct
 /*
  * This function checks whether a page is free && is the buddy
  * we can do coalesce a page and its buddy if
- * (a) the buddy is not in a hole &&
+ * (a) the buddy is not in a hole (check before calling!) &&
  * (b) the buddy is in the buddy system &&
  * (c) a page and its buddy have the same order &&
  * (d) a page and its buddy are in the same zone.
@@ -729,9 +729,6 @@ static inline void rmv_page_order(struct
 static inline int page_is_buddy(struct page *page, struct page *buddy,
 							unsigned int order)
 {
-	if (!pfn_valid_within(page_to_pfn(buddy)))
-		return 0;
-
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
 		if (page_zone_id(page) != page_zone_id(buddy))
 			return 0;
@@ -808,6 +805,9 @@ continue_merging:
 	while (order < max_order - 1) {
 		buddy_pfn = __find_buddy_pfn(pfn, order);
 		buddy = page + (buddy_pfn - pfn);
+
+		if (!pfn_valid_within(buddy_pfn))
+			goto done_merging;
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
 		/*
@@ -862,7 +862,7 @@ done_merging:
 	 * so it's less likely to be used soon and more likely to be merged
 	 * as a higher order page
 	 */
-	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
+	if ((order < MAX_ORDER-2) && pfn_valid_within(buddy_pfn)) {
 		struct page *higher_page, *higher_buddy;
 		combined_pfn = buddy_pfn & pfn;
 		higher_page = page + (combined_pfn - pfn);
diff -puN mm/page_isolation.c~mm-page_alloc-avoid-page_to_pfn-when-merging-buddies mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-avoid-page_to_pfn-when-merging-buddies
+++ a/mm/page_isolation.c
@@ -106,7 +106,7 @@ static void unset_migratetype_isolate(st
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
 
-			if (pfn_valid_within(page_to_pfn(buddy)) &&
+			if (pfn_valid_within(buddy_pfn) &&
 			    !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
 				isolated_page = true;
_
