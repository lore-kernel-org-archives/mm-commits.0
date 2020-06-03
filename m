From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch removed from -mm
 tree
Date: Wed, 03 Jun 2020 15:21:44 -0700
Message-ID: <20200603222144.RRrTCwfkf%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgFCWVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:21:45 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-deactivations-shouldnt-bias-the-lru-balance-fix
has been removed from the -mm tree.  Its filename was
     mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch

This patch was dropped because it was folded into mm-deactivations-shouldnt-bias-the-lru-balance.patch

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-deactivations-shouldnt-bias-the-lru-balance-fix

fix set-but-not-used warning

Link: http://lkml.kernel.org/r/20200522133335.GA624@Qians-MacBook-Air.local
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap.c~mm-deactivations-shouldnt-bias-the-lru-balance-fix
+++ a/mm/swap.c
@@ -472,7 +472,7 @@ void lru_cache_add_active_or_unevictable
 static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 			      void *arg)
 {
-	int lru, file;
+	int lru;
 	bool active;
 
 	if (!PageLRU(page))
@@ -486,7 +486,6 @@ static void lru_deactivate_file_fn(struc
 		return;
 
 	active = PageActive(page);
-	file = page_is_file_lru(page);
 	lru = page_lru_base_type(page);
 
 	del_page_from_lru_list(page, lruvec, lru + active);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
