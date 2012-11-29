From: akpm@linux-foundation.org
Subject: + mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended.patch added to -mm tree
Date: Wed, 28 Nov 2012 16:15:20 -0800
Message-ID: <20121129001520.80C5582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46686 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2K2APW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 19:15:22 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so587148ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 16:15:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Valdis.Kletnieks@vt.edu, glommer@gmail.com, hannes@cmpxchg.org, jirislaby@gmail.com, rcj@linux.vnet.ibm.com, riel@redhat.com, sjenning@linux.vnet.ibm.com, zkabelac@redhat.com


The patch titled
     Subject: mm: avoid waking kswapd for THP allocations when compaction is deferred or contended
has been added to the -mm tree.  Its filename is
     mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: avoid waking kswapd for THP allocations when compaction is deferred or contended

With "mm: vmscan: scale number of pages reclaimed by reclaim/compaction
based on failures" reverted, Zdenek Kabelac reported the following

	Hmm,  so it's just took longer to hit the problem and observe
	kswapd0 spinning on my CPU again - it's not as endless like before -
	but still it easily eats minutes - it helps to	turn off  Firefox
	or TB  (memory hungry apps) so kswapd0 stops soon - and restart
	those apps again.  (And I still have like >1GB of cached memory)

	kswapd0         R  running task        0    30      2 0x00000000
	 ffff8801331efae8 0000000000000082 0000000000000018 0000000000000246
	 ffff880135b9a340 ffff8801331effd8 ffff8801331effd8 ffff8801331effd8
	 ffff880055dfa340 ffff880135b9a340 00000000331efad8 ffff8801331ee000
	Call Trace:
	 [<ffffffff81555bf2>] preempt_schedule+0x42/0x60
	 [<ffffffff81557a95>] _raw_spin_unlock+0x55/0x60
	 [<ffffffff81192971>] put_super+0x31/0x40
	 [<ffffffff81192a42>] drop_super+0x22/0x30
	 [<ffffffff81193b89>] prune_super+0x149/0x1b0
	 [<ffffffff81141e2a>] shrink_slab+0xba/0x510

The sysrq+m indicates the system has no swap so it'll never reclaim
anonymous pages as part of reclaim/compaction.  That is one part of the
problem but not the root cause as file-backed pages could also be
reclaimed.

The likely underlying problem is that kswapd is woken up or kept awake for
each THP allocation request in the page allocator slow path.

If compaction fails for the requesting process then compaction will be
deferred for a time and direct reclaim is avoided.  However, if there are
a storm of THP requests that are simply rejected, it will still be the the
case that kswapd is awake for a prolonged period of time as
pgdat->kswapd_max_order is updated each time.  This is noticed by the main
kswapd() loop and it will not call kswapd_try_to_sleep().  Instead it will
loopp, shrinking a small number of pages and calling shrink_slab() on each
iteration.

This patch defers when kswapd gets woken up for THP allocations.  For !THP
allocations, kswapd is always woken up.  For THP allocations, kswapd is
woken up iff the process is willing to enter into direct
reclaim/compaction.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended mm/page_alloc.c
--- a/mm/page_alloc.c~mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended
+++ a/mm/page_alloc.c
@@ -2378,6 +2378,15 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
 }
 
+/* Returns true if the allocation is likely for THP */
+static bool is_thp_alloc(gfp_t gfp_mask, unsigned int order)
+{
+	if (order == pageblock_order &&
+	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
+		return true;
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -2416,7 +2425,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	wake_all_kswapd(order, zonelist, high_zoneidx,
+	/* The decision whether to wake kswapd for THP is made later */
+	if (!is_thp_alloc(gfp_mask, order))
+		wake_all_kswapd(order, zonelist, high_zoneidx,
 					zone_idx(preferred_zone));
 
 	/*
@@ -2487,15 +2498,21 @@ rebalance:
 		goto got_pg;
 	sync_migration = true;
 
-	/*
-	 * If compaction is deferred for high-order allocations, it is because
-	 * sync compaction recently failed. In this is the case and the caller
-	 * requested a movable allocation that does not heavily disrupt the
-	 * system then fail the allocation instead of entering direct reclaim.
-	 */
-	if ((deferred_compaction || contended_compaction) &&
-	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
-		goto nopage;
+	if (is_thp_alloc(gfp_mask, order)) {
+		/*
+		 * If compaction is deferred for high-order allocations, it is
+		 * because sync compaction recently failed. In this is the case
+		 * and the caller requested a movable allocation that does not
+		 * heavily disrupt the system then fail the allocation instead
+		 * of entering direct reclaim.
+		 */
+		if (deferred_compaction || contended_compaction)
+			goto nopage;
+
+		/* If process is willing to reclaim/compact then wake kswapd */
+		wake_all_kswapd(order, zonelist, high_zoneidx,
+					zone_idx(preferred_zone));
+	}
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-compaction-fix-return-value-of-capture_free_page.patch
revert-revert-mm-remove-__gfp_no_kswapd.patch
mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended.patch
linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended-fix.patch

