From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 118/155] mm/page_alloc: simplify page_is_buddy()
 for better code readability
Date: Wed, 01 Apr 2020 21:09:56 -0700
Message-ID: <20200402040956.IYrzeYzCM%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:57 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org

From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/page_alloc: simplify page_is_buddy() for better code readability

Simplify page_is_buddy() to reduce the redundant code for better code
readability.

Link: http://lkml.kernel.org/r/1583853751-5525-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-page_is_buddy-for-better-code-readability
+++ a/mm/page_alloc.c
@@ -792,32 +792,25 @@ static inline void set_page_order(struct
  *
  * For recording page's order, we use page_private(page).
  */
-static inline int page_is_buddy(struct page *page, struct page *buddy,
+static inline bool page_is_buddy(struct page *page, struct page *buddy,
 							unsigned int order)
 {
-	if (page_is_guard(buddy) && page_order(buddy) == order) {
-		if (page_zone_id(page) != page_zone_id(buddy))
-			return 0;
+	if (!page_is_guard(buddy) && !PageBuddy(buddy))
+		return false;
 
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+	if (page_order(buddy) != order)
+		return false;
 
-		return 1;
-	}
+	/*
+	 * zone check is done late to avoid uselessly calculating
+	 * zone/node ids for pages that could never merge.
+	 */
+	if (page_zone_id(page) != page_zone_id(buddy))
+		return false;
 
-	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		/*
-		 * zone check is done late to avoid uselessly
-		 * calculating zone/node ids for pages that could
-		 * never merge.
-		 */
-		if (page_zone_id(page) != page_zone_id(buddy))
-			return 0;
+	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
 
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
