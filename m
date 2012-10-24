From: akpm@linux-foundation.org
Subject: + memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch added to -mm tree
Date: Wed, 24 Oct 2012 13:05:52 -0700
Message-ID: <20121024200552.DB8901E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48259 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2JXUFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:05:54 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so104900vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:05:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com


The patch titled
     Subject: memory-hotplug: build zonelist if a zone is populated after onlining pages
has been added to the -mm tree.  Its filename is
     memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2
+++ a/mm/memory_hotplug.c
@@ -529,7 +529,9 @@ int __ref online_pages(unsigned long pfn
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

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch

