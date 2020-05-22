From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch added to -mm tree
Date: Fri, 22 May 2020 16:38:36 -0700
Message-ID: <20200522233836.S59eM6fRK%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgEVXih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 19:38:37 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-deactivations-shouldnt-bias-the-lru-balance-fix
has been added to the -mm tree.  Its filename is
     mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -475,7 +475,7 @@ void lru_cache_add_active_or_unevictable
 static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 			      void *arg)
 {
-	int lru, file;
+	int lru;
 	bool active;
 
 	if (!PageLRU(page))
@@ -489,7 +489,6 @@ static void lru_deactivate_file_fn(struc
 		return;
 
 	active = PageActive(page);
-	file = page_is_file_lru(page);
 	lru = page_lru_base_type(page);
 
 	del_page_from_lru_list(page, lruvec, lru + active);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-z3fold-silence-kmemleak-false-positives-of-slots.patch
mm-slub-fix-stack-overruns-with-slub_stats.patch
mm-swap_state-fix-a-data-race-in-swapin_nr_pages.patch
mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch
mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch
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
