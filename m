From: akpm@linux-foundation.org
Subject: + memory-hotplug-export-the-function-try_offline_node.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:48:21 -0800
Message-ID: <20130122214821.E617731C1EB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44670 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AVVsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:48:23 -0500
Received: by mail-yh0-f74.google.com with SMTP id z12so604424yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:48:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lenb@kernel.org, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de


The patch titled
     Subject: memory-hotplug: export the function try_offline_node()
has been added to the -mm tree.  Its filename is
     memory-hotplug-export-the-function-try_offline_node.patch

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
Subject: memory-hotplug: export the function try_offline_node()

try_offline_node() will be needed in the tristate
drivers/acpi/processor_driver.c.

The node will be offlined when all memory/cpu on the node have been
hotremoved.  So we need the function try_offline_node() in cpu-hotplug
path.

If the memory-hotplug is disabled, and cpu-hotplug is enabled
1. no memory no the node
   we don't online the node, and cpu's node is the nearest node.
2. the node contains some memory
   the node has been onlined, and cpu's node is still needed
   to migrate the sleep task on the cpu to the same node.

So we do nothing in try_offline_node() in this case.

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

 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node
+++ a/include/linux/memory_hotplug.h
@@ -193,6 +193,7 @@ extern void get_page_bootmem(unsigned lo
 
 void lock_memory_hotplug(void);
 void unlock_memory_hotplug(void);
+extern void try_offline_node(int nid);
 
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
@@ -227,6 +228,7 @@ static inline void register_page_bootmem
 
 static inline void lock_memory_hotplug(void) {}
 static inline void unlock_memory_hotplug(void) {}
+static inline void try_offline_node(int nid) {}
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
diff -puN mm/memory_hotplug.c~memory-hotplug-export-the-function-try_offline_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-export-the-function-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -1702,7 +1702,7 @@ static int check_cpu_on_node(void *data)
 }
 
 /* offline the node if all memory sections of this node are removed */
-static void try_offline_node(int nid)
+void try_offline_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long start_pfn = pgdat->node_start_pfn;
@@ -1758,6 +1758,7 @@ static void try_offline_node(int nid)
 	 */
 	memset(pgdat, 0, sizeof(*pgdat));
 }
+EXPORT_SYMBOL(try_offline_node);
 
 int __ref remove_memory(int nid, u64 start, u64 size)
 {
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

