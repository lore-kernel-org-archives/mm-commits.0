From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch added
 to -mm tree
Date: Mon, 25 May 2020 13:01:59 -0700
Message-ID: <20200525200159.v4Fr7Ypx_%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgEYUCA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 May 2020 16:02:00 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix
has been added to the -mm tree.  Its filename is
     khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch

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
Subject: khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix

fix set-but-not-used warning

Link: http://lkml.kernel.org/r/20200521145644.GA6367@ovpn-112-192.phx2.redhat.com
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix
+++ a/mm/khugepaged.c
@@ -528,9 +528,8 @@ static void release_pte_pages(pte_t *pte
 
 static bool is_refcount_suitable(struct page *page)
 {
-	int expected_refcount, refcount;
+	int expected_refcount;
 
-	refcount = page_count(page);
 	expected_refcount = total_mapcount(page);
 	if (PageSwapCache(page))
 		expected_refcount += compound_nr(page);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-z3fold-silence-kmemleak-false-positives-of-slots.patch
mm-slub-fix-stack-overruns-with-slub_stats.patch
mm-swap_state-fix-a-data-race-in-swapin_nr_pages.patch
mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch
mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch
khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch
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
