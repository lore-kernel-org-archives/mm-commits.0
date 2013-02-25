From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-export-the-function-try_offline_node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:47 -0800
Message-ID: <20130225205047.D71D331C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61081 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:49 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so158819yen.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lenb@kernel.org, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: export the function try_offline_node()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-export-the-function-try_offline_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[rientjes@google.com: export the function try_offline_node() fix]
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 +++
 mm/memory_hotplug.c            |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-export-the-function-try_offline_node
+++ a/include/linux/memory_hotplug.h
@@ -233,6 +233,7 @@ static inline void unlock_memory_hotplug
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern void try_offline_node(int nid);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -240,6 +241,8 @@ static inline int is_mem_section_removab
 {
 	return 0;
 }
+
+static inline void try_offline_node(int nid) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
diff -puN mm/memory_hotplug.c~memory-hotplug-export-the-function-try_offline_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-export-the-function-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -1706,7 +1706,7 @@ static int check_cpu_on_node(void *data)
 }
 
 /* offline the node if all memory sections of this node are removed */
-static void try_offline_node(int nid)
+void try_offline_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long start_pfn = pgdat->node_start_pfn;
@@ -1762,6 +1762,7 @@ static void try_offline_node(int nid)
 	 */
 	memset(pgdat, 0, sizeof(*pgdat));
 }
+EXPORT_SYMBOL(try_offline_node);
 
 int __ref remove_memory(int nid, u64 start, u64 size)
 {
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

