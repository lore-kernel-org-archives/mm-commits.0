From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:39:31 -0700
Message-ID: <56f03fe3.2c/6b6c8rnHNZ+Pt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, gthelen@google.com, mhocko@kernel.org, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: only set __GFP_NOMEMALLOC if there are free elements
has been removed from the -mm tree.  Its filename was
     mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: only set __GFP_NOMEMALLOC if there are free elements

If an oom killed thread calls mempool_alloc(), it is possible that it'll
loop forever if there are no elements on the freelist since
__GFP_NOMEMALLOC prevents it from accessing needed memory reserves in oom
conditions.

Only set __GFP_NOMEMALLOC if there are elements on the freelist.  If there
are no free elements, allow allocations without the bit set so that memory
reserves can be accessed if needed.

Additionally, using mempool_alloc() with __GFP_NOMEMALLOC is not supported
since the implementation can loop forever without accessing memory
reserves when needed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/mempool.c~mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements mm/mempool.c
--- a/mm/mempool.c~mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements
+++ a/mm/mempool.c
@@ -310,25 +310,36 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
- * Note: using __GFP_ZERO is not supported.
+ * Note: neither __GFP_NOMEMALLOC nor __GFP_ZERO are supported.
  */
-void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
 	void *element;
 	unsigned long flags;
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
+	/* If oom killed, memory reserves are essential to prevent livelock */
+	VM_WARN_ON_ONCE(gfp_mask & __GFP_NOMEMALLOC);
+	/* No element size to zero on allocation */
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
+
 	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
-	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
 	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
+	if (likely(pool->curr_nr)) {
+		/*
+		 * Don't allocate from emergency reserves if there are
+		 * elements available.  This check is racy, but it will
+		 * be rechecked each loop.
+		 */
+		gfp_temp |= __GFP_NOMEMALLOC;
+	}
 
 	element = pool->alloc(gfp_temp, pool->pool_data);
 	if (likely(element != NULL))
@@ -352,11 +363,12 @@ repeat_alloc:
 	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
 	 * alloc failed with that and @pool was empty, retry immediately.
 	 */
-	if (gfp_temp != gfp_mask) {
+	if ((gfp_temp & ~__GFP_NOMEMALLOC) != gfp_mask) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		gfp_temp = gfp_mask;
 		goto repeat_alloc;
 	}
+	gfp_temp = gfp_mask;
 
 	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
_

Patches currently in -mm which might be from rientjes@google.com are


