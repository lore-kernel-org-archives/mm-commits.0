From: akpm@linux-foundation.org
Subject: + add-populated_map-to-account-for-memoryless-nodes-fix.patch added to -mm tree
Date: Mon, 11 Jun 2007 17:25:30 -0700
Message-ID: <200706120025.l5C0PULL032723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbXFLAZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 20:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, anton@samba.org, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     populated_map: fix !NUMA case, remove comment
has been added to the -mm tree.  Its filename is
     add-populated_map-to-account-for-memoryless-nodes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
