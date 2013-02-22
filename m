From: akpm@linux-foundation.org
Subject: [folded-merged] acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:46:15 -0800
Message-ID: <20130222234615.88AAB31C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47459 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab3BVXqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:46:17 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so120803vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:46:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch

This patch was dropped because it was folded into acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix

clean up code, fix build warning

Cc: "Brown, Len" <len.brown@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |   93 ++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
+++ a/arch/x86/mm/srat.c
@@ -142,50 +142,8 @@ static inline int save_add_info(void) {r
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-extern struct movablemem_map movablemem_map;
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
-/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
-int __init
-acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
+static void __init handle_movablemem(int node, u64 start, u64 end)
 {
-	u64 start, end;
-	u32 hotpluggable;
-	int node, pxm;
-
-	if (srat_disabled())
-		goto out_err;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
-		goto out_err_bad_srat;
-	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		goto out_err;
-	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
-	if (hotpluggable && !save_add_info())
-		goto out_err;
-
-	start = ma->base_address;
-	end = start + ma->length;
-	pxm = ma->proximity_domain;
-	if (acpi_srat_revision <= 1)
-		pxm &= 0xff;
-
-	node = setup_node(pxm);
-	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		goto out_err_bad_srat;
-	}
-
-	if (numa_add_memblk(node, start, end) < 0)
-		goto out_err_bad_srat;
-
-	node_set(node, numa_nodes_parsed);
-
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
-	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1,
-	       hotpluggable ? "Hot Pluggable": "");
-
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	int overlap;
 	unsigned long start_pfn, end_pfn;
 
@@ -229,7 +187,54 @@ acpi_numa_memory_affinity_init(struct ac
 			 */
 			insert_movablemem_map(start_pfn, end_pfn);
 	}
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+}
+#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+static inline void handle_movablemem(int node, u64 start, u64 end)
+{
+}
+#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
+int __init
+acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
+{
+	u64 start, end;
+	u32 hotpluggable;
+	int node, pxm;
+
+	if (srat_disabled())
+		goto out_err;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
+		goto out_err_bad_srat;
+	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
+		goto out_err;
+	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
+	if (hotpluggable && !save_add_info())
+		goto out_err;
+
+	start = ma->base_address;
+	end = start + ma->length;
+	pxm = ma->proximity_domain;
+	if (acpi_srat_revision <= 1)
+		pxm &= 0xff;
+
+	node = setup_node(pxm);
+	if (node < 0) {
+		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		goto out_err_bad_srat;
+	}
+
+	if (numa_add_memblk(node, start, end) < 0)
+		goto out_err_bad_srat;
+
+	node_set(node, numa_nodes_parsed);
+
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
+	       node, pxm,
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       hotpluggable ? "Hot Pluggable": "");
+
+	handle_movablemem(node, start, end);
 
 	return 0;
 out_err_bad_srat:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

