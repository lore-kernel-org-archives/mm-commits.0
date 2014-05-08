From: akpm@linux-foundation.org
Subject: +
 mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch added to
 -mm tree
Date: Thu, 08 May 2014 15:36:08 -0700
Message-ID: <536c06d8.IYnJ6j5+VTkHWWI5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaEHWgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2014 18:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, hughd@google.com, gthelen@google.com, rientjes@google.com

Subject: + mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,hughd@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 08 May 2014 15:36:08 -0700


The patch titled
     Subject: mm, thp: avoid excessive compaction latency during fault fix
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch

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
Subject: mm, thp: avoid excessive compaction latency during fault fix

mm-thp-avoid-excessive-compaction-latency-during-fault.patch excludes sync
compaction for all high order allocations other than thp.  What we really
want to do is suppress sync compaction for thp, but only during the page
fault path.

Orders greater than PAGE_ALLOC_COSTLY_ORDER aren't necessarily going to
loop again so this is the only way to exhaust our capabilities before
declaring that we can't allocate.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault-fix
+++ a/mm/page_alloc.c
@@ -2576,16 +2576,13 @@ rebalance:
 	if (page)
 		goto got_pg;
 
-	if (gfp_mask & __GFP_NO_KSWAPD) {
-		/*
-		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
-		 * of this allocation isn't critical.  Everything else, however,
-		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
-		 * stalls during fault.
-		 */
-		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
-			migration_mode = MIGRATE_SYNC_LIGHT;
-	}
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
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
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

