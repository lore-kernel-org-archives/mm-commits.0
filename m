From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:10:17 -0800
Message-ID: <563d4169.P1xNlRU+Rhd1r1H7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbbKGAKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:10:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch

This patch was dropped because it was folded into mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix

simplify __zone_watermark_ok(), per Vlastimil

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix
+++ a/mm/page_alloc.c
@@ -2377,11 +2377,8 @@ static bool __zone_watermark_ok(struct z
 		if (!area->nr_free)
 			continue;
 
-		if (alloc_harder) {
-			if (area->nr_free)
-				return true;
-			continue;
-		}
+		if (alloc_harder)
+			return true;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
 			if (!list_empty(&area->free_list[mt]))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

