From: akpm@linux-foundation.org
Subject: - mm-swap-prefetch-more-improvements.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:52:57 -0700
Message-ID: <200707092352.l69NqvHm021614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758320AbXGIXxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     mm: swap prefetch more improvements
has been removed from the -mm tree.  Its filename was
     mm-swap-prefetch-more-improvements.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: mm: swap prefetch more improvements
From: Con Kolivas <kernel@kolivas.org>

Failed radix_tree_insert wasn't being handled leaving stale kmem.

The list should be iterated over in the reverse order when prefetching.

Make the yield within kprefetchd stronger through the use of cond_resched.

Check that the pos entry hasn't been removed while unlocked.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_prefetch.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/swap_prefetch.c~mm-swap-prefetch-more-improvements mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~mm-swap-prefetch-more-improvements
+++ a/mm/swap_prefetch.c
@@ -117,7 +117,8 @@ void add_to_swapped_list(struct page *pa
 	if (likely(!radix_tree_insert(&swapped.swap_tree, index, entry))) {
 		list_add(&entry->swapped_list, &swapped.list);
 		swapped.count++;
-	}
+	} else
+		kmem_cache_free(swapped.cache, entry);
 
 out_locked:
 	spin_unlock_irqrestore(&swapped.lock, flags);
@@ -431,7 +432,7 @@ out:
 static enum trickle_return trickle_swap(void)
 {
 	enum trickle_return ret = TRICKLE_DELAY;
-	struct list_head *p, *next;
+	struct swapped_entry *pos, *n;
 	unsigned long flags;
 
 	if (!prefetch_enabled())
@@ -444,19 +445,19 @@ static enum trickle_return trickle_swap(
 		return TRICKLE_FAILED;
 
 	spin_lock_irqsave(&swapped.lock, flags);
-	list_for_each_safe(p, next, &swapped.list) {
-		struct swapped_entry *entry;
+	list_for_each_entry_safe_reverse(pos, n, &swapped.list, swapped_list) {
 		swp_entry_t swp_entry;
 		int node;
 
 		spin_unlock_irqrestore(&swapped.lock, flags);
-		might_sleep();
-		if (!prefetch_suitable())
+		/* Yield to anything else running */
+		if (cond_resched() || !prefetch_suitable())
 			goto out_unlocked;
 
 		spin_lock_irqsave(&swapped.lock, flags);
-		entry = list_entry(p, struct swapped_entry, swapped_list);
-		node = get_swap_entry_node(entry);
+		if (unlikely(!pos))
+			continue;
+		node = get_swap_entry_node(pos);
 		if (!node_isset(node, sp_stat.prefetch_nodes)) {
 			/*
 			 * We found an entry that belongs to a node that is
@@ -464,7 +465,7 @@ static enum trickle_return trickle_swap(
 			 */
 			continue;
 		}
-		swp_entry = entry->swp_entry;
+		swp_entry = pos->swp_entry;
 		spin_unlock_irqrestore(&swapped.lock, flags);
 
 		if (trickle_swap_cache_async(swp_entry, node) == TRICKLE_DELAY)
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-swap-prefetch-more-improvements.patch
mm-swap-prefetch-increase-aggressiveness-and-tunability.patch
