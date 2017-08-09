From: akpm@linux-foundation.org
Subject: + mm-swap-fix-swap-readahead-marking.patch added to -mm tree
Date: Wed, 09 Aug 2017 14:53:01 -0700
Message-ID: <598b843d.nQNTI6VvqH3se/Kt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdHIVxC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 17:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: fix swap readahead marking
has been added to the -mm tree.  Its filename is
     mm-swap-fix-swap-readahead-marking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-swap-readahead-marking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-swap-readahead-marking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch
mm-swap-add-swap-readahead-hit-statistics.patch
mm-swap-fix-swap-readahead-marking.patch
mm-swap-vma-based-swap-readahead.patch
mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch

