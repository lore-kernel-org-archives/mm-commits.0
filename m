From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-prandom_u32_max.patch added to -mm tree
Date: Wed, 13 May 2020 15:48:03 -0700
Message-ID: <20200513224803.MYVBmbWx7%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgEMWsE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 18:48:04 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: use prandom_u32_max()
has been added to the -mm tree.  Its filename is
     mm-swap-use-prandom_u32_max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-use-prandom_u32_max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-use-prandom_u32_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

swap-try-to-scan-more-free-slots-even-when-fragmented.patch
mm-swap-use-prandom_u32_max.patch
proc-pid-smaps-add-pmd-migration-entry-parsing.patch
