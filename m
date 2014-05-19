From: akpm@linux-foundation.org
Subject: +
 mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
 added to -mm tree
Date: Mon, 19 May 2014 15:03:06 -0700
Message-ID: <537a7f9a.T5GzqEXwp+gowPl5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaESWDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz

Subject: + mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch added to -mm tree
To: vbabka@suse.cz,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:03:06 -0700


The patch titled
     Subject: mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix

Fix a (spurious) build warning:

mm/compaction.c:860:15: warning: `next_free_pfn' may be used uninitialized in this function [-Wmaybe-uninitialized]

Seems like the compiler cannot prove that exiting the for loop without
updating next_free_pfn there will mean that the check for crossing the
scanners will trigger.  So let's not confuse people who try to see why
this warning occurs.

Instead of initializing next_free_pfn to zero with an explaining comment,
just drop the damned variable altogether and work with cc->free_pfn
directly as Nayoa originally suggested.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix
+++ a/mm/compaction.c
@@ -685,7 +685,6 @@ static void isolate_freepages(struct zon
 	unsigned long block_start_pfn;	/* start of current pageblock */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
-	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -745,7 +744,7 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		next_free_pfn = block_start_pfn;
+		cc->free_pfn = block_start_pfn;
 		isolated = isolate_freepages_block(cc, block_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
@@ -768,9 +767,8 @@ static void isolate_freepages(struct zon
 	 * so that compact_finished() may detect this
 	 */
 	if (block_start_pfn < low_pfn)
-		next_free_pfn = cc->migrate_pfn;
+		cc->free_pfn = cc->migrate_pfn;
 
-	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
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
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch

