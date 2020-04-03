From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:39:37 -0700
Message-ID: <20200403203937.A77Bz3xto%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCUjh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/page_alloc.c: use free_area_empty() instead of open-coding
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/page_alloc.c: use free_area_empty() instead of open-coding

Use free_area_empty() API to replace list_empty() for better code
readability.

Link: http://lkml.kernel.org/r/1583674354-7713-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-free_area_empty-instead-of-open-coding
+++ a/mm/page_alloc.c
@@ -3460,8 +3460,7 @@ bool __zone_watermark_ok(struct zone *z,
 			return true;
 		}
 #endif
-		if (alloc_harder &&
-			!list_empty(&area->free_list[MIGRATE_HIGHATOMIC]))
+		if (alloc_harder && !free_area_empty(area, MIGRATE_HIGHATOMIC))
 			return true;
 	}
 	return false;
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
