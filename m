From: akpm@linux-foundation.org
Subject: + mm-thp-avoid-excessive-compaction-latency-during-fault.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:20:51 -0700
Message-ID: <536aa3b3.SnmRplaYl17/80Kd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaEGVUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: + mm-thp-avoid-excessive-compaction-latency-during-fault.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:51 -0700


The patch titled
     Subject: mm, thp: avoid excessive compaction latency during fault
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-excessive-compaction-latency-during-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-excessive-compaction-latency-during-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-excessive-compaction-latency-during-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: avoid excessive compaction latency during fault

Synchronous memory compaction can be very expensive: it can iterate an
enormous amount of memory without aborting, constantly rescheduling,
waiting on page locks and lru_lock, etc, if a pageblock cannot be
defragmented.

Unfortunately, it's too expensive for transparent hugepage page faults and
it's much better to simply fallback to pages.  On 128GB machines, we find
that synchronous memory compaction can take O(seconds) for a single thp
fault.

Now that async compaction remembers where it left off without strictly
relying on sync compaction, this makes thp allocations best-effort without
causing egregious latency during fault.  We still need to retry async
compaction after reclaim, but this won't stall for seconds.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault
+++ a/mm/page_alloc.c
@@ -2578,7 +2578,17 @@ rebalance:
 					&did_some_progress);
 	if (page)
 		goto got_pg;
-	migration_mode = MIGRATE_SYNC_LIGHT;
+
+	if (gfp_mask & __GFP_NO_KSWAPD) {
+		/*
+		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
+		 * of this allocation isn't critical.  Everything else, however,
+		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
+		 * stalls during fault.
+		 */
+		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
+			migration_mode = MIGRATE_SYNC_LIGHT;
+	}
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

