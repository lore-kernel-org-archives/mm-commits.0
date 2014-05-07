From: akpm@linux-foundation.org
Subject: +
 mm-compaction-terminate-async-compaction-when-rescheduling.patch added to
 -mm tree
Date: Wed, 07 May 2014 14:20:52 -0700
Message-ID: <536aa3b4.I6vZNl4YkmQ39FL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaEGVUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@suse.de, rientjes@google.com

Subject: + mm-compaction-terminate-async-compaction-when-rescheduling.patch added to -mm tree
To: rientjes@google.com,mgorman@suse.de,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:52 -0700


The patch titled
     Subject: mm, compaction: terminate async compaction when rescheduling
has been added to the -mm tree.  Its filename is
     mm-compaction-terminate-async-compaction-when-rescheduling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-terminate-async-compaction-when-rescheduling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-terminate-async-compaction-when-rescheduling.patch

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
Subject: mm, compaction: terminate async compaction when rescheduling

Async compaction terminates prematurely when need_resched(), see
compact_checklock_irqsave().  This can never trigger, however, if the
cond_resched() in isolate_migratepages_range() always takes care of the
scheduling.

If the cond_resched() actually triggers, then terminate this pageblock
scan for async compaction as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-terminate-async-compaction-when-rescheduling mm/compaction.c
--- a/mm/compaction.c~mm-compaction-terminate-async-compaction-when-rescheduling
+++ a/mm/compaction.c
@@ -491,8 +491,13 @@ isolate_migratepages_range(struct zone *
 			return 0;
 	}
 
+	if (cond_resched()) {
+		/* Async terminates prematurely on need_resched() */
+		if (cc->mode == MIGRATE_ASYNC)
+			return 0;
+	}
+
 	/* Time to isolate some pages for migration */
-	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
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

