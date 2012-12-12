From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:09 -0800
Message-ID: <20121212195810.7053120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51558 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:13 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so64908wib.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: update start_pfn in zone and pg_data when spanned_pages == 0.
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memory_hotplug.c: update start_pfn in zone and pg_data when spanned_pages == 0.

If we hot-remove memory only and leave the cpus alive, the corresponding
node will not be removed.  But the node_start_pfn and node_spanned_pages
in pg_data will be reset to 0.  In this case, when we hot-add the memory
back next time, the node_start_pfn will always be 0 because no pfn is less
than 0.  After that, if we hot-remove the memory again, it will cause
kernel panic in function find_biggest_section_pfn() when it tries to scan
all the pfns.

The zone will also have the same problem.

This patch sets start_pfn to the start_pfn of the section being added when
spanned_pages of the zone or pg_data is 0.

---How to reproduce---

1. hot-add a container with some memory and cpus;
2. hot-remove the container's memory, and leave cpus there;
3. hot-add these memory again;
4. hot-remove them again;

then, the kernel will panic.

---Call trace---

[10530.646285] BUG: unable to handle kernel paging request at
00000fff82a8cc38
[10530.729670] IP: [<ffffffff811c0d55>] find_biggest_section_pfn+0xe5/0x180
......
[10533.064975] Call Trace:
[10533.094162]  [<ffffffff811c0fcf>] ? __remove_zone+0x2f/0x1b0
[10533.161757]  [<ffffffff811c1124>] __remove_zone+0x184/0x1b0
[10533.228318]  [<ffffffff811c11dc>] __remove_section+0x8c/0xb0
[10533.295916]  [<ffffffff811c12e7>] __remove_pages+0xe7/0x120
[10533.362476]  [<ffffffff81654f7c>] arch_remove_memory+0x2c/0x80
[10533.432151]  [<ffffffff81655bb6>] remove_memory+0x56/0x90
[10533.496633]  [<ffffffff813da0c8>]
acpi_memory_device_remove_memory+0x48/0x73
[10533.580846]  [<ffffffff813da55a>] acpi_memory_device_notify+0x153/0x274
[10533.659865]  [<ffffffff813a63cf>] ? acpi_bus_get_device+0x2f/0x77
[10533.732653]  [<ffffffff813a6589>] ? acpi_bus_notify+0xb5/0xec
[10533.801291]  [<ffffffff813b6786>] acpi_ev_notify_dispatch+0x41/0x5f
[10533.876156]  [<ffffffff813a3867>] acpi_os_execute_deferred+0x27/0x34
[10533.952062]  [<ffffffff81090589>] process_one_work+0x219/0x680
[10534.021736]  [<ffffffff81090528>] ? process_one_work+0x1b8/0x680
[10534.093488]  [<ffffffff813a3840>] ?
acpi_os_wait_events_complete+0x23/0x23
[10534.175622]  [<ffffffff810923be>] worker_thread+0x12e/0x320
[10534.242181]  [<ffffffff81092290>] ? manage_workers+0x110/0x110
[10534.311855]  [<ffffffff81098396>] kthread+0xc6/0xd0
[10534.370111]  [<ffffffff8167c7c4>] kernel_thread_helper+0x4/0x10
[10534.440824]  [<ffffffff81672230>] ? retint_restore_args+0x13/0x13
[10534.513612]  [<ffffffff810982d0>] ? __init_kthread_worker+0x70/0x70
[10534.588480]  [<ffffffff8167c7c0>] ? gs_change+0x13/0x13
......
[10535.045543] ---[ end trace 96d845dbf33fee11 ]---

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0
+++ a/mm/memory_hotplug.c
@@ -205,7 +205,7 @@ static void grow_zone_span(struct zone *
 	zone_span_writelock(zone);
 
 	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	if (start_pfn < zone->zone_start_pfn)
+	if (!zone->spanned_pages || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
 	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
@@ -220,7 +220,7 @@ static void grow_pgdat_span(struct pglis
 	unsigned long old_pgdat_end_pfn =
 		pgdat->node_start_pfn + pgdat->node_spanned_pages;
 
-	if (start_pfn < pgdat->node_start_pfn)
+	if (!pgdat->node_spanned_pages || start_pfn < pgdat->node_start_pfn)
 		pgdat->node_start_pfn = start_pfn;
 
 	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

