From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:40:19 -0800
Message-ID: <20121211234020.1C6E3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39764 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2LKXkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:40:21 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so6114qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:40:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: build zonelist if a zone is populated after onlining pages
has been removed from the -mm tree.  Its filename was
     memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch

This patch was dropped because it was folded into memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: build zonelist if a zone is populated after onlining pages

After "memory-hotplug: allocate zone's pcp before onlining pages", we
build zone list before onlining pages to allocate zone's pcp.  But the
zone doesn't have pages before onlining pages, and the zone is not in
zonelist, so we still need to build zonelist after onlining pages.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2
+++ a/mm/memory_hotplug.c
@@ -522,7 +522,9 @@ int __ref online_pages(unsigned long pfn
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	if (onlined_pages) {
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
-		if (!need_zonelists_rebuild)
+		if (need_zonelists_rebuild)
+			build_all_zonelists(NULL, NULL);
+		else
 			zone_pcp_update(zone);
 	}
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch

