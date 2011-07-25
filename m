From: akpm@linux-foundation.org
Subject: [folded] mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:58:10 -0700
Message-ID: <201107252358.p6PNwAWl006327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab1GYX6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix.patch

This patch was dropped because it was folded into mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
From: Mel Gorman <mgorman@suse.de>

mm/page_alloc.c: In function `__alloc_pages_direct_reclaim':
mm/page_alloc.c:1983:3: error: implicit declaration of function `zlc_clear_zones_full'

This patch is a build fix for !CONFIG_NUMA that should be merged with
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch .

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
+++ a/mm/page_alloc.c
@@ -1647,6 +1647,10 @@ static int zlc_zone_worth_trying(struct 
 static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 {
 }
+
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page-allocator-initialise-zlc-for-first-zone-eligible-for-zone_reclaim.patch
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch
include-linux-kernelh-hide-internal-macros-from-userspace.patch

