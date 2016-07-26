From: akpm@linux-foundation.org
Subject: [patch 062/126] mm/page_isolation: clean up confused code
Date: Tue, 26 Jul 2016 15:24:01 -0700
Message-ID: <5797e301.6Z/LbA5s/BZT1n2M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281AbcGZWYC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_isolation: clean up confused code

When there is an isolated_page, post_alloc_hook() is called with page but
__free_pages() is called with isolated_page.  Since they are the same so
no problem but it's very confusing.  To reduce it, this patch changes
isolated_page to boolean type and uses page variable consistently.

Link: http://lkml.kernel.org/r/1466150259-27727-10-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-clean-up-confused-code mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-clean-up-confused-code
+++ a/mm/page_isolation.c
@@ -81,7 +81,7 @@ static void unset_migratetype_isolate(st
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
-	struct page *isolated_page = NULL;
+	bool isolated_page = false;
 	unsigned int order;
 	unsigned long page_idx, buddy_idx;
 	struct page *buddy;
@@ -109,7 +109,7 @@ static void unset_migratetype_isolate(st
 			if (pfn_valid_within(page_to_pfn(buddy)) &&
 			    !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
-				isolated_page = page;
+				isolated_page = true;
 			}
 		}
 	}
@@ -129,7 +129,7 @@ out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (isolated_page) {
 		post_alloc_hook(page, order, __GFP_MOVABLE);
-		__free_pages(isolated_page, order);
+		__free_pages(page, order);
 	}
 }
 
_
