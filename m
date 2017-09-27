From: akpm@linux-foundation.org
Subject: +
 writeback-remove-unused-parameter-from-balance_dirty_pages.patch added to
 -mm tree
Date: Wed, 27 Sep 2017 15:21:57 -0700
Message-ID: <59cc2485.IMnA4Bqc2UQjHqpg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbdI0WV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tahsin@google.com, hannes@cmpxchg.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: remove unused parameter from balance_dirty_pages()
has been added to the -mm tree.  Its filename is
     writeback-remove-unused-parameter-from-balance_dirty_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-remove-unused-parameter-from-balance_dirty_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-remove-unused-parameter-from-balance_dirty_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tahsin Erdogan <tahsin@google.com>
Subject: mm/page-writeback.c: remove unused parameter from balance_dirty_pages()

"mapping" parameter to balance_dirty_pages() is not used anymore.

Fixes: dfb8ae567835 ("writeback: let balance_dirty_pages() work on the matching cgroup bdi_writeback")
Link: http://lkml.kernel.org/r/20170927221311.23263-1-tahsin@google.com
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

writeback-remove-unused-parameter-from-balance_dirty_pages.patch

