From: akpm@linux-foundation.org
Subject: [patch 069/119] mm, THP, swap: don't allocate huge cluster
 for file backed swap device
Date: Wed, 06 Sep 2017 16:22:23 -0700
Message-ID: <20170906232223.4-PjALcRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754165AbdIFXWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, torvalds@linux-foundation.org, vishal.l.verma@intel.com, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: don't allocate huge cluster for file backed swap device

It's hard to write a whole transparent huge page (THP) to a file backed
swap device during swapping out and the file backed swap device isn't very
popular.  So the huge cluster allocation for the file backed swap device
is disabled.

Link: http://lkml.kernel.org/r/20170724051840.2309-5-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/swapfile.c~mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device
+++ a/mm/swapfile.c
@@ -948,9 +948,10 @@ start_over:
 			spin_unlock(&si->lock);
 			goto nextsi;
 		}
-		if (cluster)
-			n_ret = swap_alloc_cluster(si, swp_entries);
-		else
+		if (cluster) {
+			if (!(si->flags & SWP_FILE))
+				n_ret = swap_alloc_cluster(si, swp_entries);
+		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
 						    n_goal, swp_entries);
 		spin_unlock(&si->lock);
_
