From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:19 -0700
Message-ID: <5390ca73.ooeXkO2UEaRrfz47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaFETwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, hannes@cmpxchg.org, mgorman@suse.de

Subject: [merged] mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch removed from -mm tree
To: mgorman@suse.de,hannes@cmpxchg.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:19 -0700


The patch titled
     Subject: mm: page_alloc: do not treat a zone that cannot be used for dirty pages as "full"
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: do not treat a zone that cannot be used for dirty pages as "full"

If a zone cannot be used for a dirty page then it gets marked "full" which
is cached in the zlc and later potentially skipped by allocation requests
that have nothing to do with dirty zones.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full
+++ a/mm/page_alloc.c
@@ -1967,7 +1967,7 @@ zonelist_scan:
 		 */
 		if ((alloc_flags & ALLOC_WMARK_LOW) &&
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
-			goto this_zone_full;
+			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_ok(zone, order, mark,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

