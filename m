From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 116/155] mm/page_alloc.c: use free_area_empty()
 instead of open-coding
Date: Wed, 01 Apr 2020 21:09:50 -0700
Message-ID: <20200402040950.yLnkih1dZ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:51 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
