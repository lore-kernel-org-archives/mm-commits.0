From: akpm@linux-foundation.org
Subject: +
 memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 16:37:23 -0700
Message-ID: <597a7933.3wy1DiMp/vR070v2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdG0XhY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, THP, swap: support move mem cgroup charge for THP swapped out
has been added to the -mm tree.  Its filename is
     memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch

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
@@ -4620,8 +4620,11 @@ static enum mc_target_type get_mctgt_typ
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

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

