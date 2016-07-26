From: akpm@linux-foundation.org
Subject: [patch 027/126] mm/init: fix zone boundary creation
Date: Tue, 26 Jul 2016 15:22:17 -0700
Message-ID: <5797e299.b10HkxzsgUyJOrVa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbcGZWWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oohall@gmail.com, anton@samba.org, benh@kernel.crashing.org, mgorman@techsingularity.net, paulus@samba.org

From: "Oliver O'Halloran" <oohall@gmail.com>
Subject: mm/init: fix zone boundary creation

As a part of memory initialisation the architecture passes an array to
free_area_init_nodes() which specifies the max PFN of each memory zone. 
This array is not necessarily monotonic (due to unused zones) so this
array is parsed to build monotonic lists of the min and max PFN for each
zone.  ZONE_MOVABLE is special cased here as its limits are managed by the
mm subsystem rather than the architecture.  Unfortunately, this special
casing is broken when ZONE_MOVABLE is the not the last zone in the zone
list.  The core of the issue is:

	if (i == ZONE_MOVABLE)
		continue;
	arch_zone_lowest_possible_pfn[i] =
		arch_zone_highest_possible_pfn[i-1];

As ZONE_MOVABLE is skipped the lowest_possible_pfn of the next zone will
be set to zero.  This patch fixes this bug by adding explicitly tracking
where the next zone should start rather than relying on the contents
arch_zone_highest_possible_pfn[].

Thie is low priority.  To get bitten by this you need to enable a zone
that appears after ZONE_MOVABLE in the zone_type enum.  As far as I can
tell this means running a kernel with ZONE_DEVICE or ZONE_CMA enabled,
so I can't see this affecting too many people.

I only noticed this because I've been fiddling with ZONE_DEVICE on
powerpc and 4.6 broke my test kernel.  This bug, in conjunction with
the changes in Taku Izumi's kernelcore=mirror patch (d91749c1dda71) and
powerpc being the odd architecture which initialises max_zone_pfn[] to
~0ul instead of 0 caused all of system memory to be placed into
ZONE_DEVICE at boot, followed a panic since device memory cannot be
used for kernel allocations.  I've already submitted a patch to fix the
powerpc specific bits, but I figured this should be fixed too.

Link: http://lkml.kernel.org/r/1462435033-15601-1-git-send-email-oohall@gmail.com
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-init-fix-zone-boundary-creation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-init-fix-zone-boundary-creation
+++ a/mm/page_alloc.c
@@ -6467,15 +6467,18 @@ void __init free_area_init_nodes(unsigne
 				sizeof(arch_zone_lowest_possible_pfn));
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
-	arch_zone_lowest_possible_pfn[0] = find_min_pfn_with_active_regions();
-	arch_zone_highest_possible_pfn[0] = max_zone_pfn[0];
-	for (i = 1; i < MAX_NR_ZONES; i++) {
+
+	start_pfn = find_min_pfn_with_active_regions();
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		arch_zone_lowest_possible_pfn[i] =
-			arch_zone_highest_possible_pfn[i-1];
-		arch_zone_highest_possible_pfn[i] =
-			max(max_zone_pfn[i], arch_zone_lowest_possible_pfn[i]);
+
+		end_pfn = max(max_zone_pfn[i], start_pfn);
+		arch_zone_lowest_possible_pfn[i] = start_pfn;
+		arch_zone_highest_possible_pfn[i] = end_pfn;
+
+		start_pfn = end_pfn;
 	}
 	arch_zone_lowest_possible_pfn[ZONE_MOVABLE] = 0;
 	arch_zone_highest_possible_pfn[ZONE_MOVABLE] = 0;
_
