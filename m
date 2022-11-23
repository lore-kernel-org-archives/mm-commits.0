Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86E4C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiKWCxl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiKWCxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25D48D4A0
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F3CD61A09
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE490C433B5;
        Wed, 23 Nov 2022 02:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172003;
        bh=cPO66vngHQWdwEkyBJjeH/DhUpYpyipdz5CMYvZQpLk=;
        h=Date:To:From:Subject:From;
        b=OuWIEXwKd0h0Hpn134TAhn6il49AIx5O/RxDJnDe0edf5AODLyyUjzxSg6WQlvazs
         b4s0j4RwXHjL+q/FR1kd+m7WnkQw8IdolYDXgbeembdcmM0M4hmitKekxkJQy2wcoP
         ITLkt9sUo75eZrL8qKsH+7H4/9cBCXs0BUsW8dVw=
Date:   Tue, 22 Nov 2022 18:53:22 -0800
To:     mm-commits@vger.kernel.org, fengwei.yin@intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-multi-gen-lru-retry-folios-written-back-while-isolated.patch removed from -mm tree
Message-Id: <20221123025322.DE490C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: retry folios written back while isolated
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-retry-folios-written-back-while-isolated.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: retry folios written back while isolated
Date: Tue, 15 Nov 2022 18:38:07 -0700

The page reclaim isolates a batch of folios from the tail of one of the
LRU lists and works on those folios one by one.  For a suitable
swap-backed folio, if the swap device is async, it queues that folio for
writeback.  After the page reclaim finishes an entire batch, it puts back
the folios it queued for writeback to the head of the original LRU list.

In the meantime, the page writeback flushes the queued folios also by
batches.  Its batching logic is independent from that of the page reclaim.
For each of the folios it writes back, the page writeback calls
folio_rotate_reclaimable() which tries to rotate a folio to the tail.

folio_rotate_reclaimable() only works for a folio after the page reclaim
has put it back.  If an async swap device is fast enough, the page
writeback can finish with that folio while the page reclaim is still
working on the rest of the batch containing it.  In this case, that folio
will remain at the head and the page reclaim will not retry it before
reaching there.

This patch adds a retry to evict_folios().  After evict_folios() has
finished an entire batch and before it puts back folios it cannot free
immediately, it retries those that may have missed the rotation.

Before this patch, ~60% of folios swapped to an Intel Optane missed
folio_rotate_reclaimable().  After this patch, ~99% of missed folios were
reclaimed upon retry.

This problem affects relatively slow async swap devices like Samsung 980
Pro much less and does not affect sync swap devices like zram or zswap at
all.

Link: https://lkml.kernel.org/r/20221116013808.3995280-1-yuzhao@google.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-retry-folios-written-back-while-isolated
+++ a/mm/vmscan.c
@@ -4971,10 +4971,13 @@ static int evict_folios(struct lruvec *l
 	int scanned;
 	int reclaimed;
 	LIST_HEAD(list);
+	LIST_HEAD(clean);
 	struct folio *folio;
+	struct folio *next;
 	enum vm_event_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
+	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
@@ -4991,20 +4994,37 @@ static int evict_folios(struct lruvec *l
 
 	if (list_empty(&list))
 		return scanned;
-
+retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
+	sc->nr_reclaimed += reclaimed;
 
-	list_for_each_entry(folio, &list, lru) {
-		/* restore LRU_REFS_FLAGS cleared by isolate_folio() */
-		if (folio_test_workingset(folio))
-			folio_set_referenced(folio);
+	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
+		if (!folio_evictable(folio)) {
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+			continue;
+		}
 
-		/* don't add rejected pages to the oldest generation */
 		if (folio_test_reclaim(folio) &&
-		    (folio_test_dirty(folio) || folio_test_writeback(folio)))
-			folio_clear_active(folio);
-		else
-			folio_set_active(folio);
+		    (folio_test_dirty(folio) || folio_test_writeback(folio))) {
+			/* restore LRU_REFS_FLAGS cleared by isolate_folio() */
+			if (folio_test_workingset(folio))
+				folio_set_referenced(folio);
+			continue;
+		}
+
+		if (skip_retry || folio_test_active(folio) || folio_test_referenced(folio) ||
+		    folio_mapped(folio) || folio_test_locked(folio) ||
+		    folio_test_dirty(folio) || folio_test_writeback(folio)) {
+			/* don't add rejected folios to the oldest generation */
+			set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS,
+				      BIT(PG_active));
+			continue;
+		}
+
+		/* retry folios that may have missed folio_rotate_reclaimable() */
+		list_move(&folio->lru, &clean);
+		sc->nr_scanned -= folio_nr_pages(folio);
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);
@@ -5026,7 +5046,13 @@ static int evict_folios(struct lruvec *l
 	mem_cgroup_uncharge_list(&list);
 	free_unref_page_list(&list);
 
-	sc->nr_reclaimed += reclaimed;
+	INIT_LIST_HEAD(&list);
+	list_splice_init(&clean, &list);
+
+	if (!list_empty(&list)) {
+		skip_retry = true;
+		goto retry;
+	}
 
 	if (need_swapping && type == LRU_GEN_ANON)
 		*need_swapping = true;
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-remove-null-checks-on-node_data.patch

