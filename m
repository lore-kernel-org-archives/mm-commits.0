From: akpm@linux-foundation.org
Subject: - mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:10:59 -0700
Message-ID: <200809031610.m83GAx1j023669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYICQLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, nacc@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: make setup_zone_migrate_reserve() aware of overlapping nodes
has been removed from the -mm tree.  Its filename was
     mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make setup_zone_migrate_reserve() aware of overlapping nodes
From: Adam Litke <agl@us.ibm.com>

I have gotten to the root cause of the hugetlb badness I reported back on
August 15th.  My system has the following memory topology (note the
overlapping node):

            Node 0 Memory: 0x8000000-0x44000000
            Node 1 Memory: 0x0-0x8000000 0x44000000-0x80000000

setup_zone_migrate_reserve() scans the address range 0x0-0x8000000 looking
for a pageblock to move onto the MIGRATE_RESERVE list.  Finding no
candidates, it happily continues the scan into 0x8000000-0x44000000.  When
a pageblock is found, the pages are moved to the MIGRATE_RESERVE list on
the wrong zone.  Oops.

setup_zone_migrate_reserve() should skip pageblocks in overlapping nodes.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes
+++ a/mm/page_alloc.c
@@ -694,6 +694,9 @@ static int move_freepages(struct zone *z
 #endif
 
 	for (page = start_page; page <= end_page;) {
+		/* Make sure we are not inadvertently changing nodes */
+		VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));
+
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
@@ -2516,6 +2519,10 @@ static void setup_zone_migrate_reserve(s
 			continue;
 		page = pfn_to_page(pfn);
 
+		/* Watch out for overlapping nodes */
+		if (page_to_nid(page) != zone_to_nid(zone))
+			continue;
+
 		/* Blocks with reserved pages will never free, skip them. */
 		if (PageReserved(page))
 			continue;
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch

