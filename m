From: akpm@linux-foundation.org
Subject: [patch 034/131] mm/page-writeback.c: remove unused
 parameter from balance_dirty_pages()
Date: Wed, 15 Nov 2017 17:33:19 -0800
Message-ID: <20171116013319.em3XxnOgf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPBdU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, tahsin@google.com, torvalds@linux-foundation.org

From: Tahsin Erdogan <tahsin@google.com>
Subject: mm/page-writeback.c: remove unused parameter from balance_dirty_pages()

"mapping" parameter to balance_dirty_pages() is not used anymore.

Fixes: dfb8ae567835 ("writeback: let balance_dirty_pages() work on the matching cgroup bdi_writeback")
Link: http://lkml.kernel.org/r/20170927221311.23263-1-tahsin@google.com
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~writeback-remove-unused-parameter-from-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-unused-parameter-from-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -1559,8 +1559,7 @@ static inline void wb_dirty_limits(struc
  * If we're over `background_thresh' then the writeback threads are woken to
  * perform some writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping,
-				struct bdi_writeback *wb,
+static void balance_dirty_pages(struct bdi_writeback *wb,
 				unsigned long pages_dirtied)
 {
 	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
@@ -1910,7 +1909,7 @@ void balance_dirty_pages_ratelimited(str
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
-		balance_dirty_pages(mapping, wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied);
 
 	wb_put(wb);
 }
_
