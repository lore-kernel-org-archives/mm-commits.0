From: akpm@linux-foundation.org
Subject: [folded] page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:58:50 -0700
Message-ID: <200906162158.n5GLwoIm027970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbZFPV7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch
has been removed from the -mm tree.  Its filename was
     page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch

This patch was dropped because it was folded into page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch
From: Christoph Lameter <cl@linux.com>

On Mon, 25 May 2009, Mel Gorman wrote:

> I expect that the machine would start running into reclaim issues with
> enough uptime because it'll not be using Highmem as it should. Similarly,
> the GFP_DMA32 may also be a problem as the new implementation is going
> ZONE_DMA when ZONE_NORMAL would have been ok in this case.

Right. The fallback for DMA32 is wrong. Should fall back to ZONE_NORMAL.
Not to DMA. And the config variable to check for highmem was wrong.

Subject: Fix gfp zone patch

1. If there is no DMA32 fall back to NORMAL instead of DMA

2. Use the correct config variable for HIGHMEM

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch
+++ a/include/linux/gfp.h
@@ -125,7 +125,7 @@ static inline int allocflags_to_migratet
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
-#ifdef CONFIG_ZONE_HIGHMEM
+#ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
 #define OPT_ZONE_HIGHMEM ZONE_NORMAL
@@ -140,7 +140,7 @@ static inline int allocflags_to_migratet
 #ifdef CONFIG_ZONE_DMA32
 #define OPT_ZONE_DMA32 ZONE_DMA32
 #else
-#define OPT_ZONE_DMA32 OPT_ZONE_DMA
+#define OPT_ZONE_DMA32 ZONE_NORMAL
 #endif
 
 /*
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch

