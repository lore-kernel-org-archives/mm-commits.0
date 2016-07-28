From: akpm@linux-foundation.org
Subject: [patch 085/101] Revert "mm, mempool: only set __GFP_NOMEMALLOC if there are free elements"
Date: Thu, 28 Jul 2016 15:48:44 -0700
Message-ID: <579a8bcc./RqsE9zFaNg8BJr9%akpm__48386.677951976$1469746135$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1Wsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, mpatocka@redhat.com, neilb@suse.com, okozina@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm, mempool: only set __GFP_NOMEMALLOC if there are free elements"

This reverts f9054c70d28bc214b ("mm, mempool: only set __GFP_NOMEMALLOC if
there are free elements").

There has been a report about OOM killer invoked when swapping out to a
dm-crypt device.  The primary reason seems to be that the swapout out IO
managed to completely deplete memory reserves.  Ondrej was able to bisect
and explained the issue by pointing to f9054c70d28b ("mm, mempool: only
set __GFP_NOMEMALLOC if there are free elements").

The reason is that the swapout path is not throttled properly because the
md-raid layer needs to allocate from the generic_make_request path which
means it allocates from the PF_MEMALLOC context.  dm layer uses
mempool_alloc in order to guarantee a forward progress which used to
inhibit access to memory reserves when using page allocator.  This has
changed by f9054c70d28b ("mm, mempool: only set __GFP_NOMEMALLOC if there
are free elements") which has dropped the __GFP_NOMEMALLOC protection when
the memory pool is depleted.

If we are running out of memory and the only way forward to free memory is
to perform swapout we just keep consuming memory reserves rather than
throttling the mempool allocations and allowing the pending IO to complete
up to a moment when the memory is depleted completely and there is no way
forward but invoking the OOM killer.  This is less than optimal.

The original intention of f9054c70d28b was to help with the OOM situations
where the oom victim depends on mempool allocation to make a forward
progress.  David has mentioned the following backtrace:

schedule
schedule_timeout
io_schedule_timeout
mempool_alloc
__split_and_process_bio
dm_request
generic_make_request
submit_bio
mpage_readpages
ext4_readpages
__do_page_cache_readahead
ra_submit
filemap_fault
handle_mm_fault
__do_page_fault
do_page_fault
page_fault

We do not know more about why the mempool is depleted without being
replenished in time, though.  In any case the dm layer shouldn't depend on
any allocations outside of the dedicated pools so a forward progress
should be guaranteed.  If this is not the case then the dm should be fixed
rather than papering over the problem and postponing it to later by
accessing more memory reserves.

mempools are a mechanism to maintain dedicated memory reserves to guaratee
forward progress.  Allowing them an unbounded access to the page allocator
memory reserves is going against the whole purpose of this mechanism.

Bisected by Ondrej Kozina.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20160721145309.GR26379@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Ondrej Kozina <okozina@redhat.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: NeilBrown <neilb@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN mm/mempool.c~revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements mm/mempool.c
--- a/mm/mempool.c~revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements
+++ a/mm/mempool.c
@@ -306,7 +306,7 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
- * Note: neither __GFP_NOMEMALLOC nor __GFP_ZERO are supported.
+ * Note: using __GFP_ZERO is not supported.
  */
 void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -315,27 +315,16 @@ void *mempool_alloc(mempool_t *pool, gfp
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
-	/* If oom killed, memory reserves are essential to prevent livelock */
-	VM_WARN_ON_ONCE(gfp_mask & __GFP_NOMEMALLOC);
-	/* No element size to zero on allocation */
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
-
 	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
+	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
 	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
-	if (likely(pool->curr_nr)) {
-		/*
-		 * Don't allocate from emergency reserves if there are
-		 * elements available.  This check is racy, but it will
-		 * be rechecked each loop.
-		 */
-		gfp_temp |= __GFP_NOMEMALLOC;
-	}
 
 	element = pool->alloc(gfp_temp, pool->pool_data);
 	if (likely(element != NULL))
@@ -359,12 +348,11 @@ repeat_alloc:
 	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
 	 * alloc failed with that and @pool was empty, retry immediately.
 	 */
-	if ((gfp_temp & ~__GFP_NOMEMALLOC) != gfp_mask) {
+	if (gfp_temp != gfp_mask) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		gfp_temp = gfp_mask;
 		goto repeat_alloc;
 	}
-	gfp_temp = gfp_mask;
 
 	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
_
