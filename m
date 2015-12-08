From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-2.patch removed from
 -mm tree
Date: Tue, 08 Dec 2015 12:35:25 -0800
Message-ID: <56673f0d.TzYQNIeK9LaDtykj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbbLHUf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 15:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, dave.hansen@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mingo@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: restore COMPACT_CLUSTER_MAX to 32
has been removed from the -mm tree.  Its filename was
     mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-2.patch

This patch was dropped because it was folded into mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/compaction: restore COMPACT_CLUSTER_MAX to 32

Until now, COMPACT_CLUSTER_MAX is defined as SWAP_CLUSTER_MAX.  Commit
("mm: increase SWAP_CLUSTER_MAX to batch TLB flushes") changes
SWAP_CLUSTER_MAX from 32 to 256 to improve tlb flush performance so
COMPACT_CLUSTER_MAX is also changed to 256.  But, it has no justification
on compaction-side and I think that loss is more than benefit.

One example is that migration scanner would isolates and migrates too many
pages unnecessarily with 256 COMPACT_CLUSTER_MAX.  It may be enough to
migrate 4 pages in order to make order-2 page, but, now, compaction will
migrate 256 pages.

To reduce this unneeded overhead, this patch restores COMPACT_CLUSTER_MAX
to 32.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-2 include/linux/swap.h
--- a/include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-2
+++ a/include/linux/swap.h
@@ -155,7 +155,7 @@ enum {
 };
 
 #define SWAP_CLUSTER_MAX 256UL
-#define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
+#define COMPACT_CLUSTER_MAX 32UL
 
 /*
  * Ratio between zone->managed_pages and the "gap" that above the per-zone
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch
mm-cma-always-check-which-page-cause-allocation-failure-v2.patch
mm-compaction-__compact_pgdat-code-cleanuup.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

