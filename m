From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:48:29 -0700
Message-ID: <538fa23d.sPAScdqIhNGmtj9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFDWsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@nvidia.com, shawn.guo@linaro.org, sfr@canb.auug.org.au, rientjes@google.com, khilman@linaro.org, fabio.estevam@freescale.com, vbabka@suse.cz

Subject: [folded-merged] mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch removed from -mm tree
To: vbabka@suse.cz,fabio.estevam@freescale.com,khilman@linaro.org,rientjes@google.com,sfr@canb.auug.org.au,shawn.guo@linaro.org,swarren@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:48:29 -0700


The patch titled
     Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2
has been removed from the -mm tree.  Its filename was
     mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch

This patch was dropped because it was folded into mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2

Step 1: Change function name and comment between v1 and v2 so that the return
        value signals the opposite thing.
Step 2: Change the call sites to reflect the opposite return value.
Step 3: ???
Step 4: Make a complete fool of yourself.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Kevin Hilman <khilman@linaro.org>
Reported-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2
+++ a/mm/compaction.c
@@ -237,13 +237,13 @@ static inline bool compact_should_abort(
 	if (need_resched()) {
 		if (cc->mode == MIGRATE_ASYNC) {
 			cc->contended = true;
-			return false;
+			return true;
 		}
 
 		cond_resched();
 	}
 
-	return true;
+	return false;
 }
 
 /* Returns true if the page is within a block suitable for migration to */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch

