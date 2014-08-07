From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:49 -0700
Message-ID: <53e3dc1d.LLq+1St/44hwP/Vc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:55171 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaHGUFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:50 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so610146yha.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered

The purpose of numa_zonelist_order=zone is to preserve lower zones for use
with 32-bit devices.  If locality is preferred then the
numa_zonelist_order=node policy should be used.  Unfortunately, the fair
zone allocation policy overrides this by skipping zones on remote nodes
until the lower one is found.  While this makes sense from a page aging
and performance perspective, it breaks the expected zonelist policy.  This
patch restores the expected behaviour for zone-list ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered
+++ a/mm/page_alloc.c
@@ -1965,7 +1965,7 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
-				continue;
+				break;
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 		}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

