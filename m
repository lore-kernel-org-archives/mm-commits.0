From: akpm@linux-foundation.org
Subject: [patch 107/119] mm, swap: fix swap readahead marking
Date: Wed, 06 Sep 2017 16:24:33 -0700
Message-ID: <20170906232433.MCShzRxEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdIFXYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: fix swap readahead marking

In the original implementation, it is possible that the existing pages in
the swap cache (not newly readahead) could be marked as the readahead
pages.  This will cause the statistics of swap readahead be wrong and
influence the swap readahead algorithm too.

This is fixed via marking a page as the readahead page only if it is newly
allocated and read from the disk.

When testing with linpack, after the fixing the swap readahead hit rate
increased from ~66% to ~86%.

Link: http://lkml.kernel.org/r/20170807054038.1843-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/swap_state.c~mm-swap-fix-swap-readahead-marking mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-fix-swap-readahead-marking
+++ a/mm/swap_state.c
@@ -498,7 +498,7 @@ struct page *swapin_readahead(swp_entry_
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
 	struct blk_plug plug;
-	bool do_poll = true;
+	bool do_poll = true, page_allocated;
 
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
@@ -514,14 +514,18 @@ struct page *swapin_readahead(swp_entry_
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
-		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
-						gfp_mask, vma, addr, false);
+		page = __read_swap_cache_async(
+			swp_entry(swp_type(entry), offset),
+			gfp_mask, vma, addr, &page_allocated);
 		if (!page)
 			continue;
-		if (offset != entry_offset &&
-		    likely(!PageTransCompound(page))) {
-			SetPageReadahead(page);
-			count_vm_event(SWAP_RA);
+		if (page_allocated) {
+			swap_readpage(page, false);
+			if (offset != entry_offset &&
+			    likely(!PageTransCompound(page))) {
+				SetPageReadahead(page);
+				count_vm_event(SWAP_RA);
+			}
 		}
 		put_page(page);
 	}
_
