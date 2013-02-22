From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:41:50 -0800
Message-ID: <20130222234150.B27B55A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60285 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab3BVXlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:41:52 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so120521qcr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:41:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, rdunlap@infradead.org, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch

This patch was dropped because it was folded into memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix

fix warning when CONFIG_NEED_MULTIPLE_NODES=n

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix
+++ a/mm/memory_hotplug.c
@@ -1077,7 +1077,8 @@ out:
 int __ref add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0, new_node = 0;
+	bool new_pgdat;
+	bool new_node;
 	struct resource *res;
 	int ret;
 
@@ -1088,8 +1089,8 @@ int __ref add_memory(int nid, u64 start,
 	if (!res)
 		goto out;
 
-	new_pgdat = NODE_DATA(nid) ? 0 : 1;
-	new_node = node_online(nid) ? 0 : 1;
+	new_pgdat = (NODE_DATA(nid) == NULL);
+	new_node = !node_online(nid);
 	if (new_node) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
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
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
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

