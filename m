From: akpm@linux-foundation.org
Subject: [merged] mm-swap-use-prandom_u32_max.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:40:34 -0700
Message-ID: <20200602214034.HSy09fQJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBVke (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: use prandom_u32_max()
has been removed from the -mm tree.  Its filename was
     mm-swap-use-prandom_u32_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/swapfile.c: use prandom_u32_max()

To improve the code readability and take advantage of the common
implementation.

Link: http://lkml.kernel.org/r/20200512081013.520201-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-prandom_u32_max
+++ a/mm/swapfile.c
@@ -3209,7 +3209,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * select a random position to start with to help wear leveling
 		 * SSD
 		 */
-		p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
+		p->cluster_next = 1 + prandom_u32_max(p->highest_bit);
 		nr_cluster = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
 		cluster_info = kvcalloc(nr_cluster, sizeof(*cluster_info),
_

Patches currently in -mm which might be from ying.huang@intel.com are
