From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-prefetch_prev_lru_page.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:18:38 -0800
Message-ID: <20200131231838.2YUY_uZNJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cai@lca.pw, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove prefetch_prev_lru_page
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-prefetch_prev_lru_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: remove prefetch_prev_lru_page

This macro was never used in git history. So better to remove.

Link: http://lkml.kernel.org/r/1579006500-127143-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-prefetch_prev_lru_page
+++ a/mm/vmscan.c
@@ -146,20 +146,6 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
-#ifdef ARCH_HAS_PREFETCH
-#define prefetch_prev_lru_page(_page, _base, _field)			\
-	do {								\
-		if ((_page)->lru.prev != _base) {			\
-			struct page *prev;				\
-									\
-			prev = lru_to_page(&(_page->lru));		\
-			prefetch(&prev->_field);			\
-		}							\
-	} while (0)
-#else
-#define prefetch_prev_lru_page(_page, _base, _field) do { } while (0)
-#endif
