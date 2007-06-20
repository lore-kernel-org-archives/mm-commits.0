From: akpm@linux-foundation.org
Subject: - add-populated_map-to-account-for-memoryless-nodes-fix.patch removed from -mm tree
Date: Tue, 19 Jun 2007 20:29:04 -0700
Message-ID: <200706200329.l5K3T4SN027100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758081AbXFTD3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 23:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, anton@samba.org, clameter@sgi.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     populated_map: fix !NUMA case, remove comment
has been removed from the -mm tree.  Its filename was
     add-populated_map-to-account-for-memoryless-nodes-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: populated_map: fix !NUMA case, remove comment
From: Nishanth Aravamudan <nacc@us.ibm.com>

populated_map needs to be consistent in both the NUMA and !NUMA cases to
fix hugepage allocation with empty nodes.  Assume the one node in the !NUMA
case is populated.

Remove a comment that would only increase the maintenance burden.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~add-populated_map-to-account-for-memoryless-nodes-fix mm/page_alloc.c
--- a/mm/page_alloc.c~add-populated_map-to-account-for-memoryless-nodes-fix
+++ a/mm/page_alloc.c
@@ -1971,10 +1971,6 @@ static void build_zonelists(pg_data_t *p
 		build_zonelists_in_zone_order(pgdat, j);
 	}
 
-	/*
-	 * record populated zones for use when INTERLEAVE'ing or using
-	 * GFP_THISNODE
-	 */
 	if (pgdat->node_present_pages)
 		node_set_populated(local_node);
 }
@@ -2038,6 +2034,8 @@ static void build_zonelists(pg_data_t *p
 
 		zonelist->zones[j] = NULL;
 	}
+
+	node_set_populated(local_node);
 }
 
 /* non-NUMA variant of zonelist performance cache - just NULL zlcache_ptr */
_

Patches currently in -mm which might be from nacc@us.ibm.com are

hugetlb-remove-unnecessary-nid-initialization.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
