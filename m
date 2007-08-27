From: akpm@linux-foundation.org
Subject: + update-n_high_memory-node-state-for-memory-hotadd.patch added to -mm tree
Date: Mon, 27 Aug 2007 16:11:30 -0700
Message-ID: <200708272311.l7RNBU8s000964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbXH0XLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 19:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     update N_HIGH_MEMORY node state for memory hotadd
has been added to the -mm tree.  Its filename is
     update-n_high_memory-node-state-for-memory-hotadd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update N_HIGH_MEMORY node state for memory hotadd
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Setting N_HIGH_MEMORY node state in free_area_init_nodes() works for memory
present at boot time, but not for hot-added memory.  Update the
N_HIGH_MEMORY node state in online_pages(), if we've added pages to this
node, before rebuilding zonelists.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN mm/memory_hotplug.c~update-n_high_memory-node-state-for-memory-hotadd mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~update-n_high_memory-node-state-for-memory-hotadd
+++ a/mm/memory_hotplug.c
@@ -215,6 +215,8 @@ int online_pages(unsigned long pfn, unsi
 	}
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
+	if (onlined_pages)
+		node_set_state(zone->node, N_HIGH_MEMORY);
 
 	setup_per_zone_pages_min();
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
