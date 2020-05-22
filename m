From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-z3fold-silence-kmemleak-false-positives-of-slots.patch added to -mm tree
Date: Fri, 22 May 2020 16:29:39 -0700
Message-ID: <20200522232939.C2baWrmbP%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgEVX3k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 19:29:40 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, catalin.marinas@arm.com, mm-commits@vger.kernel.org, vitaly.wool@konsulko.com


The patch titled
     Subject: mm/z3fold: silence kmemleak false positives of slots
has been added to the -mm tree.  Its filename is
     mm-z3fold-silence-kmemleak-false-positives-of-slots.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-silence-kmemleak-false-positives-of-slots.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-silence-kmemleak-false-positives-of-slots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/z3fold: silence kmemleak false positives of slots

Kmemleak reported many leaks while under memory pressue in,

slots = alloc_slots(pool, gfp);

which is referenced by "zhdr" in init_z3fold_page(),

zhdr->slots = slots;

However, "zhdr" could be gone without freeing slots as the later will be
freed separately when the last "handle" off of "handles" array is freed. It
will be within "slots" which is always aligned.

unreferenced object 0xc000000fdadc1040 (size 104):
  comm "oom04", pid 140476, jiffies 4295359280 (age 3454.970s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d1f0f5eb>] z3fold_zpool_malloc+0x7b0/0xe10
    alloc_slots at mm/z3fold.c:214
    (inlined by) init_z3fold_page at mm/z3fold.c:412
    (inlined by) z3fold_alloc at mm/z3fold.c:1161
    (inlined by) z3fold_zpool_malloc at mm/z3fold.c:1735
    [<0000000064a2e969>] zpool_malloc+0x34/0x50
    [<00000000af63e491>] zswap_frontswap_store+0x60c/0xda0
    zswap_frontswap_store at mm/zswap.c:1093
    [<00000000af5e07e0>] __frontswap_store+0x128/0x330
    [<00000000de2f582b>] swap_writepage+0x58/0x110
    [<000000000120885f>] pageout+0x16c/0xa40
    [<00000000444c1f68>] shrink_page_list+0x1ac8/0x25c0
    [<00000000d19e8610>] shrink_inactive_list+0x270/0x730
    [<00000000e17df726>] shrink_lruvec+0x444/0xf30
    [<000000005f02ab35>] shrink_node+0x2a4/0x9c0
    [<00000000014cabbd>] do_try_to_free_pages+0x158/0x640
    [<00000000dcfaba07>] try_to_free_pages+0x1bc/0x5f0
    [<00000000fa207ab8>] __alloc_pages_slowpath.constprop.60+0x4dc/0x15a0
    [<000000003669f1d2>] __alloc_pages_nodemask+0x520/0x650
    [<0000000011fa4168>] alloc_pages_vma+0xc0/0x420
    [<0000000098b376f2>] handle_mm_fault+0x1174/0x1bf0

Link: http://lkml.kernel.org/r/20200522220052.2225-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/z3fold.c~mm-z3fold-silence-kmemleak-false-positives-of-slots
+++ a/mm/z3fold.c
@@ -43,6 +43,7 @@
 #include <linux/spinlock.h>
 #include <linux/zpool.h>
 #include <linux/magic.h>
+#include <linux/kmemleak.h>
 
 /*
  * NCHUNKS_ORDER determines the internal allocation granularity, effectively
@@ -215,6 +216,8 @@ static inline struct z3fold_buddy_slots
 				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
 
 	if (slots) {
+		/* It will be freed separately in free_handle(). */
+		kmemleak_not_leak(slots);
 		memset(slots->slot, 0, sizeof(slots->slot));
 		slots->pool = (unsigned long)pool;
 		rwlock_init(&slots->lock);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-z3fold-silence-kmemleak-false-positives-of-slots.patch
mm-slub-fix-stack-overruns-with-slub_stats.patch
mm-swap_state-fix-a-data-race-in-swapin_nr_pages.patch
mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
