From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 056/118] mm/vmscan: remove prefetch_prev_lru_page
Date: Thu, 30 Jan 2020 22:14:10 -0800
Message-ID: <20200131061410.BD4iJ_kKY%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:12 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cai@lca.pw, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
