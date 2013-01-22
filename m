From: akpm@linux-foundation.org
Subject: + cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:48:53 -0800
Message-ID: <20130122214853.E32ED31C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39904 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3AVVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:48:55 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so864121yen.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:48:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lenb@kernel.org, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de


The patch titled
     Subject: cpu-hotplug, memory-hotplug: try offlining the node when hotremoving a cpu
has been added to the -mm tree.  Its filename is
     cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch

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
Subject: cpu-hotplug, memory-hotplug: try offlining the node when hotremoving a cpu

The node will be offlined when all memory/cpu on the node is hotremoved. 
So we should try offline the node when hotremoving a cpu on the node.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_driver.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/processor_driver.c~cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu drivers/acpi/processor_driver.c
--- a/drivers/acpi/processor_driver.c~cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu
+++ a/drivers/acpi/processor_driver.c
@@ -45,6 +45,7 @@
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/io.h>
 #include <asm/cpu.h>
@@ -641,6 +642,7 @@ static int acpi_processor_remove(struct 
 
 	per_cpu(processors, pr->id) = NULL;
 	per_cpu(processor_device_array, pr->id) = NULL;
+	try_offline_node(cpu_to_node(pr->id));
 
 free:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
memory-hotplug-export-the-function-try_offline_node.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

