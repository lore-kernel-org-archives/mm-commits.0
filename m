From: akpm@linux-foundation.org
Subject: [patch 073/119] memcg, THP, swap: support move mem cgroup
 charge for THP swapped out
Date: Wed, 06 Sep 2017 16:22:37 -0700
Message-ID: <20170906232237.YBjhmjJEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754199AbdIFXWj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, torvalds@linux-foundation.org, vishal.l.verma@intel.com, ying.huang@intel.com

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
