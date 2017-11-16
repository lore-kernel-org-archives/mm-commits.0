From: akpm@linux-foundation.org
Subject: [merged]
 writeback-remove-unused-parameter-from-balance_dirty_pages.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:00:23 -0800
Message-ID: <20171116200023.t2NAA4MzG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934367AbdKPUAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, tahsin@google.com


The patch titled
     Subject: mm/page-writeback.c: remove unused parameter from balance_dirty_pages()
has been removed from the -mm tree.  Its filename was
     writeback-remove-unused-parameter-from-balance_dirty_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from tahsin@google.com are


