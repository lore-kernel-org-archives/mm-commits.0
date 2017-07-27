From: akpm@linux-foundation.org
Subject: + mm-thp-swap-add-thp-swapping-out-fallback-counting.patch added
 to -mm tree
Date: Thu, 27 Jul 2017 16:37:32 -0700
Message-ID: <597a793c.t4KEF2mQ8KOPXV69%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdG0Xhd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: add THP swapping out fallback counting
has been added to the -mm tree.  Its filename is
     mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-add-thp-swapping-out-fallback-counting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

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
Subject: mm, THP, swap: add THP swapping out fallback counting

When swapping out THP (Transparent Huge Page), instead of swapping out the
THP as a whole, sometimes we have to fallback to split the THP into normal
pages before swapping, because no free swap clusters are available, or
cgroup limit is exceeded, etc.  To count the number of the fallback, a new
VM event THP_SWPOUT_FALLBACK is added, and counted when we fallback to
split the THP.

Link: http://lkml.kernel.org/r/20170724051840.2309-13-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/vmscan.c                   |    3 +++
 mm/vmstat.c                   |    1 +
 3 files changed, 5 insertions(+)

diff -puN include/linux/vm_event_item.h~mm-thp-swap-add-thp-swapping-out-fallback-counting include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-thp-swap-add-thp-swapping-out-fallback-counting
+++ a/include/linux/vm_event_item.h
@@ -86,6 +86,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
+		THP_SWPOUT_FALLBACK,
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 		BALLOON_INFLATE,
diff -puN mm/vmscan.c~mm-thp-swap-add-thp-swapping-out-fallback-counting mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-add-thp-swapping-out-fallback-counting
+++ a/mm/vmscan.c
@@ -1153,6 +1153,9 @@ static unsigned long shrink_page_list(st
 					if (split_huge_page_to_list(page,
 								    page_list))
 						goto activate_locked;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_vm_event(THP_SWPOUT_FALLBACK);
+#endif
 					if (!add_to_swap(page))
 						goto activate_locked;
 				}
diff -puN mm/vmstat.c~mm-thp-swap-add-thp-swapping-out-fallback-counting mm/vmstat.c
--- a/mm/vmstat.c~mm-thp-swap-add-thp-swapping-out-fallback-counting
+++ a/mm/vmstat.c
@@ -1072,6 +1072,7 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 	"thp_swpout",
+	"thp_swpout_fallback",
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 	"balloon_inflate",
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

