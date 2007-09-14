From: akpm@linux-foundation.org
Subject: + update-n_high_memory-node-state-for-memory-hotadd-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:45:04 -0700
Message-ID: <200709140145.l8E1j4jp015979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbXINBpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, apw@shadowen.org, lethal@linux-sh.org


The patch titled
     : Fix memory hotplug + sparsemem build.
has been added to the -mm tree.  Its filename is
     update-n_high_memory-node-state-for-memory-hotadd-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: : Fix memory hotplug + sparsemem build.
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Fix kswapd doesn't run when memory is added on memory-less-node.
Fix compile error of zone->node when CONFIG_NUMA is off.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~update-n_high_memory-node-state-for-memory-hotadd-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~update-n_high_memory-node-state-for-memory-hotadd-fix
+++ a/mm/memory_hotplug.c
@@ -215,10 +215,12 @@ int online_pages(unsigned long pfn, unsi
 	}
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
-	if (onlined_pages)
-		node_set_state(zone->node, N_HIGH_MEMORY);
 
 	setup_per_zone_pages_min();
+	if (onlined_pages) {
+		kswapd_run(zone_to_nid(zone));
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+	}
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists();
@@ -273,9 +275,6 @@ int add_memory(int nid, u64 start, u64 s
 		if (!pgdat)
 			return -ENOMEM;
 		new_pgdat = 1;
-		ret = kswapd_run(nid);
-		if (ret)
-			goto error;
 	}
 
 	/* call arch's memory hotadd */
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
update-n_high_memory-node-state-for-memory-hotadd-fix.patch
move-free-pages-between-lists-on-steal.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
