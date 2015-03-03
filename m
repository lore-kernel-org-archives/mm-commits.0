From: akpm@linux-foundation.org
Subject: +
 jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch added
 to -mm tree
Date: Mon, 02 Mar 2015 16:17:04 -0800
Message-ID: <54f4fd80.KhHgF9qtkhazN1OU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbbCCARG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL

This basically reverts 47def82672b3 ("jbd2: Remove __GFP_NOFAIL from jbd2
layer").  The deprecation of __GFP_NOFAIL was a bad choice because it led
to open coding the endless loop around the allocator rather than removing
the dependency on the non failing allocation.  So the deprecation was a
clear failure and the reality tells us that __GFP_NOFAIL is not even close
to go away.

It is still true that __GFP_NOFAIL allocations are generally discouraged
and new uses should be evaluated and an alternative (pre-allocations or
reservations) should be considered but it doesn't make any sense to lie
the allocator about the requirements.  Allocator can take steps to help
making a progress if it knows the requirements.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vipul Pandya <vipul@chelsio.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c     |   11 +----------
 fs/jbd2/transaction.c |   20 +++++++-------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail
+++ a/fs/jbd2/journal.c
@@ -371,16 +371,7 @@ int jbd2_journal_write_metadata_buffer(t
 	 */
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
-retry_alloc:
-	new_bh = alloc_buffer_head(GFP_NOFS);
-	if (!new_bh) {
-		/*
-		 * Failure is not an option, but __GFP_NOFAIL is going
-		 * away; so we retry ourselves here.
-		 */
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-		goto retry_alloc;
-	}
+	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
 
 	/* keep subsequent assertions sane */
 	atomic_set(&new_bh->b_count, 1);
diff -puN fs/jbd2/transaction.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail
+++ a/fs/jbd2/transaction.c
@@ -278,22 +278,16 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
+		/*
+		 * If __GFP_FS is not present, then we may be being called from
+		 * inside the fs writeback layer, so we MUST NOT fail.
+		 */
+		if ((gfp_mask & __GFP_FS) == 0)
+			gfp_mask |= __GFP_NOFAIL;
 		new_transaction = kmem_cache_zalloc(transaction_cache,
 						    gfp_mask);
-		if (!new_transaction) {
-			/*
-			 * If __GFP_FS is not present, then we may be
-			 * being called from inside the fs writeback
-			 * layer, so we MUST NOT fail.  Since
-			 * __GFP_NOFAIL is going away, we will arrange
-			 * to retry the allocation ourselves.
-			 */
-			if ((gfp_mask & __GFP_FS) == 0) {
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
-				goto alloc_transaction;
-			}
+		if (!new_transaction)
 			return -ENOMEM;
-		}
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
sparc-clarify-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation.patch

