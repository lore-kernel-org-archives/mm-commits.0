From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:04:39 -0700
Message-ID: <20120918190441.ABF7520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52008 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2IRTEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:04:44 -0400
Received: by wgbdt11 with SMTP id dt11so8580wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: reset pgdat->kswapd to NULL if creating kernel thread fails
has been removed from the -mm tree.  Its filename was
     memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory hotplug: reset pgdat->kswapd to NULL if creating kernel thread fails

If kthread_run() fails, pgdat->kswapd contains errno.  When we stop this
thread, we only check whether pgdat->kswapd is NULL and access it.  If it
contains errno, it will cause page fault.  Reset pgdat->kswapd to NULL
when creating kernel thread fails can avoid this problem.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails mm/vmscan.c
--- a/mm/vmscan.c~memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails
+++ a/mm/vmscan.c
@@ -3102,6 +3102,7 @@ int kswapd_run(int nid)
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
 		printk("Failed to start kswapd on node %d\n",nid);
+		pgdat->kswapd = NULL;
 		ret = -1;
 	}
 	return ret;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch

