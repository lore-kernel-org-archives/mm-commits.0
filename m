From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-skip-swapcache-for-swapin-of-synchronous-device-fix.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 16:51:11 -0800
Message-ID: <5a0ce0ff.eUpD9aXr6baEVspr%akpm__16890.5169274241$1510793483$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdKPAvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:51:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, hughd@google.com, lists@nerdbynature.de, mhocko@suse.com, minchan@kernel.org, stable@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: fix false error message in __swp_swapcount()
has been removed from the -mm tree.  Its filename was
     mm-swap-skip-swapcache-for-swapin-of-synchronous-device-fix.patch

This patch was dropped because it was folded into mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mm, swap: fix false error message in __swp_swapcount()

When a page fault occurs for a swap entry, the physical swap readahead
(not the VMA base swap readahead) may readahead several swap entries after
the fault swap entry.  The readahead algorithm calculates some of the swap
entries to readahead via increasing the offset of the fault swap entry
without checking whether they are beyond the end of the swap device and it
relys on the __swp_swapcount() and swapcache_prepare() to check it. 
Although __swp_swapcount() checks for the swap entry passed in, it will
complain with the error message as follow for the expected invalid swap
entry.  This may make the end users confused.

  swap_info_get: Bad swap offset entry 0200f8a7

To fix the false error message, the swap entry checking is added in
swapin_readahead() to avoid to pass the out-of-bound swap entries and the
swap entry reserved for the swap header to __swp_swapcount() and
swapcache_prepare().

Link: http://lkml.kernel.org/r/20171102054225.22897-1-ying.huang@intel.com
Fixes: e8c26ab60598 ("mm/swap: skip readahead for unreferenced swap slots")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/swap_state.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device-fix mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device-fix
+++ a/mm/swap_state.c
@@ -559,6 +559,7 @@ struct page *swapin_readahead(swp_entry_
 	unsigned long offset = entry_offset;
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
+	struct swap_info_struct *si = swp_swap_info(entry);
 	struct blk_plug plug;
 	bool do_poll = true, page_allocated;
 
@@ -572,6 +573,8 @@ struct page *swapin_readahead(swp_entry_
 	end_offset = offset | mask;
 	if (!start_offset)	/* First page is swap header. */
 		start_offset++;
+	if (end_offset >= si->max)
+		end_offset = si->max - 1;
 
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch

