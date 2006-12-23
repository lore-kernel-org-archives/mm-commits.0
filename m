From: akpm@osdl.org
Subject: - memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:51 -0800
Message-ID: <200612230754.kBN7sp03010246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49899 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbWLWH4E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, randy.dunlap@oracle.com, rientjes@cs.washington.edu, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: fix compile error for i386 with NUMA config
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory hotplug: fix compile error for i386 with NUMA config
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Fix compile error when config memory hotplug with numa on i386.

The cause of compile error was missing of arch_add_memory(),
remove_memory(), and memory_add_physaddr_to_nid().

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@cs.washington.edu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/discontig.c |   28 ++++++++++++++++++++++++++++
 arch/i386/mm/init.c      |   10 ++--------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff -puN arch/i386/mm/discontig.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3 arch/i386/mm/discontig.c
--- a/arch/i386/mm/discontig.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3
+++ a/arch/i386/mm/discontig.c
@@ -405,3 +405,31 @@ void __init set_highmem_pages_init(int b
 	totalram_pages += totalhigh_pages;
 #endif
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int paddr_to_nid(u64 addr)
+{
+	int nid;
+	unsigned long pfn = PFN_DOWN(addr);
+
+	for_each_node(nid)
+		if (node_start_pfn[nid] <= pfn &&
+		    pfn < node_end_pfn[nid])
+			return nid;
+
+	return -1;
+}
+
+/*
+ * This function is used to ask node id BEFORE memmap and mem_section's
+ * initialization (pfn_to_nid() can't be used yet).
+ * If _PXM is not defined on ACPI's DSDT, node id must be found by this.
+ */
+int memory_add_physaddr_to_nid(u64 addr)
+{
+	int nid = paddr_to_nid(addr);
+	return (nid >= 0) ? nid : 0;
+}
+
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
diff -puN arch/i386/mm/init.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3 arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config-take-3
+++ a/arch/i386/mm/init.c
@@ -673,16 +673,10 @@ void __init mem_init(void)
 #endif
 }
 
-/*
- * this is for the non-NUMA, single node SMP system case.
- * Specifically, in the case of x86, we will always add
- * memory to the highmem for now.
- */
 #ifdef CONFIG_MEMORY_HOTPLUG
-#ifndef CONFIG_NEED_MULTIPLE_NODES
 int arch_add_memory(int nid, u64 start, u64 size)
 {
-	struct pglist_data *pgdata = &contig_page_data;
+	struct pglist_data *pgdata = NODE_DATA(nid);
 	struct zone *zone = pgdata->node_zones + ZONE_HIGHMEM;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -694,7 +688,7 @@ int remove_memory(u64 start, u64 size)
 {
 	return -EINVAL;
 }
-#endif
+EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
 struct kmem_cache *pgd_cache;
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch

