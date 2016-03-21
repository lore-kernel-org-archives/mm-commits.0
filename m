From: akpm@linux-foundation.org
Subject: [merged] mm-memory-hotplug-small-cleanup-in-online_pages.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:34 -0700
Message-ID: <56f03faa.wVLheLD3RR9i9+A8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbcCUT4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory hotplug: small cleanup in online_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-small-cleanup-in-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, memory hotplug: small cleanup in online_pages()

We can reuse the nid we've determined instead of repeated pfn_to_nid() usages.
Also zone_to_nid() should be a bit cheaper in general than pfn_to_nid().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory-hotplug-small-cleanup-in-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-small-cleanup-in-online_pages
+++ a/mm/memory_hotplug.c
@@ -1055,7 +1055,7 @@ int __ref online_pages(unsigned long pfn
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_online(nr_pages, zone, &arg);
 
-	nid = pfn_to_nid(pfn);
+	nid = zone_to_nid(zone);
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
@@ -1095,7 +1095,7 @@ int __ref online_pages(unsigned long pfn
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	if (onlined_pages) {
-		node_states_set_node(zone_to_nid(zone), &arg);
+		node_states_set_node(nid, &arg);
 		if (need_zonelists_rebuild)
 			build_all_zonelists(NULL, NULL);
 		else
@@ -1107,7 +1107,7 @@ int __ref online_pages(unsigned long pfn
 	init_per_zone_wmark_min();
 
 	if (onlined_pages) {
-		kswapd_run(zone_to_nid(zone));
+		kswapd_run(nid);
 		kcompactd_run(nid);
 	}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


