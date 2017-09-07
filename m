From: akpm@linux-foundation.org
Subject: [merged]
 memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:40:01 -0700
Message-ID: <20170907184001.Xp3Iz4lWX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755745AbdIGSkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, ying.huang@intel.com


The patch titled
     Subject: memcg, THP, swap: support move mem cgroup charge for THP swapped out
has been removed from the -mm tree.  Its filename was
     memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: memcg, THP, swap: support move mem cgroup charge for THP swapped out

PTE mapped THP (Transparent Huge Page) will be ignored when moving memory
cgroup charge.  But for THP which is in the swap cache, the memory cgroup
charge for the swap of a tail-page may be moved in current implementation.
That isn't correct, because the swap charge for all sub-pages of a THP
should be moved together.  Following the processing of the PTE mapped THP,
the mem cgroup charge moving for the swap entry for a tail-page of a THP
is ignored too.

Link: http://lkml.kernel.org/r/20170724051840.2309-9-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Shaohua Li <shli@kernel.org>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out
+++ a/mm/memcontrol.c
@@ -4639,8 +4639,11 @@ static enum mc_target_type get_mctgt_typ
 		if (!ret || !target)
 			put_page(page);
 	}
-	/* There is a swap entry and a page doesn't exist or isn't charged */
-	if (ent.val && !ret &&
+	/*
+	 * There is a swap entry and a page doesn't exist or isn't charged.
+	 * But we cannot move a tail-page in a THP.
+	 */
+	if (ent.val && !ret && (!page || !PageTransCompound(page)) &&
 	    mem_cgroup_id(mc.from) == lookup_swap_cgroup_id(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
_

Patches currently in -mm which might be from ying.huang@intel.com are


