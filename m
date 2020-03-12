From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-simplify-page_is_buddy-for-better-code-readability.patch
 added to -mm tree
Date: Wed, 11 Mar 2020 18:11:39 -0700
Message-ID: <20200312011139.7OMdoMA4k%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbgCLBLl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 21:11:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@linux.intel.com, chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, vbabka@suse.cz, willy@infradead.org


The patch titled
     Subject: mm/page_alloc: simplify page_is_buddy() for better code readability
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-page_is_buddy-for-better-code-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-page_is_buddy-for-better-code-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-page_is_buddy-for-better-code-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -793,32 +793,25 @@ static inline void set_page_order(struct
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
