From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 082/131] mm/vmscan: update the comment of
 should_continue_reclaim()
Date: Wed, 03 Jun 2020 16:01:21 -0700
Message-ID: <20200603230121.hu-1pX3rV%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXBX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:01:23 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, qiwuchen55@gmail.com, torvalds@linux-foundation.org

From: Qiwu Chen <qiwuchen55@gmail.com>
Subject: mm/vmscan: update the comment of should_continue_reclaim()

try_to_compact_zone() has been replaced by try_to_compact_pages(), which
is necessary to be updated in the comment of should_continue_reclaim().

Link: http://lkml.kernel.org/r/20200501034907.22991-1-chenqiwu@xiaomi.com
Signed-off-by: Qiwu Chen <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-update-the-comment-of-should_continue_reclaim
+++ a/mm/vmscan.c
@@ -2577,7 +2577,7 @@ static bool in_reclaim_compaction(struct
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
  * true if more pages should be reclaimed such that when the page allocator
- * calls try_to_compact_zone() that it will have enough free pages to succeed.
+ * calls try_to_compact_pages() that it will have enough free pages to succeed.
  * It will give up earlier than that if there is difficulty reclaiming pages.
  */
 static inline bool should_continue_reclaim(struct pglist_data *pgdat,
_
