From: akpm@linux-foundation.org
Subject: [merged]
 jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch removed from -mm tree
Date: Tue, 09 Jun 2015 12:53:04 -0700
Message-ID: <55774420.Mwn5f0JkTqnyWJ99%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbbFITxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 15:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

memcg-do-not-call-reclaim-if-__gfp_wait.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-only-define-hashdist-variable-when-needed.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch
oom-print-points-as-unsigned-int.patch
oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
oom-split-out-forced-oom-killer.patch
oom-split-out-forced-oom-killer-checkpatch-fixes.patch
memcg-remove-unused-mem_cgroup-oom_wakeups.patch
memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
linux-next.patch

