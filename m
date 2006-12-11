From: akpm@osdl.org
Subject: + memory-hotplug-fix-compile-error-for-i386-with-numa-config.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:16:30 -0800
Message-ID: <200612112016.kBBKGUcn005912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937532AbWLKUQo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, ak@suse.de, rientjes@cs.washington.edu


The patch titled
     memory hotplug: fix compile error for i386 with NUMA config
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-compile-error-for-i386-with-numa-config.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug: fix compile error for i386 with NUMA config
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This patch is to fix compile error when config memory hotplug with numa on
i386.

The cause of compile error was missing of arch_add_memory(),
remove_memory(), and memory_add_physaddr_to_nid().

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: David Rientjes <rientjes@cs.washington.edu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/discontig.c |   17 +++++++++++++++++
 arch/i386/mm/init.c      |    9 +--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff -puN arch/i386/mm/discontig.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config arch/i386/mm/discontig.c
--- a/arch/i386/mm/discontig.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config
+++ a/arch/i386/mm/discontig.c
@@ -405,3 +405,20 @@ void __init set_highmem_pages_init(int b
 	totalram_pages += totalhigh_pages;
 #endif
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+/* This is the case that there is no _PXM on DSDT for added memory */
+int memory_add_physaddr_to_nid(u64 addr)
+{
+	int nid;
+	unsigned long pfn = addr >> PAGE_SHIFT;
+
+	for (nid = 0; nid < MAX_NUMNODES; nid++){
+		if (node_start_pfn[nid] <= pfn &&
+		    pfn < node_end_pfn[nid])
+			return nid;
+	}
+
+	return 0;
+}
+#endif
diff -puN arch/i386/mm/init.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~memory-hotplug-fix-compile-error-for-i386-with-numa-config
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
@@ -695,7 +689,6 @@ int remove_memory(u64 start, u64 size)
 	return -EINVAL;
 }
 #endif
-#endif
 
 struct kmem_cache *pgd_cache;
 struct kmem_cache *pmd_cache;
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

memory-hotplug-fix-compile-error-for-i386-with-numa-config.patch

