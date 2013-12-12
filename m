From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-add-kconfig-for-enabling-page-table-method.patch removed from -mm
 tree
Date: Thu, 12 Dec 2013 12:47:50 -0800
Message-ID: <52aa20f6.oyMV4qEK1r26Cf3n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3LLUrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Dec 2013 15:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, semenzato@google.com, riel@redhat.com, penberg@kernel.org, ngupta@vflare.org, mgorman@suse.de, konrad.wilk@oracle.com, hughd@google.com, gregkh@linuxfoundation.org, bob.liu@oracle.com, axboe@kernel.dk, minchan@kernel.org

Subject: [merged] zsmalloc-add-kconfig-for-enabling-page-table-method.patch removed from -mm tree
To: minchan@kernel.org,axboe@kernel.dk,bob.liu@oracle.com,gregkh@linuxfoundation.org,hughd@google.com,konrad.wilk@oracle.com,mgorman@suse.de,ngupta@vflare.org,penberg@kernel.org,riel@redhat.com,semenzato@google.com,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Dec 2013 12:47:50 -0800


The patch titled
     Subject: zsmalloc: add Kconfig for enabling page table method
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-kconfig-for-enabling-page-table-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: add Kconfig for enabling page table method

Zsmalloc has two methods 1) copy-based and 2) pte based to access objects
that span two pages.  You can see history why we supported two approach
from [1].

But it was bad choice that adding hard coding to select arch which want to
use pte based method because there are lots of SoC in an architecure and
they can have different cache size, CPU speed and so on so it would be
better to expose it to user as selectable Kconfig option like Andrew
Morton suggested.

[1] https://lkml.org/lkml/2012/7/11/58

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zsmalloc/Kconfig         |   13 +++++++++++++
 drivers/staging/zsmalloc/zsmalloc-main.c |   19 ++++---------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/staging/zsmalloc/Kconfig~zsmalloc-add-kconfig-for-enabling-page-table-method drivers/staging/zsmalloc/Kconfig
--- a/drivers/staging/zsmalloc/Kconfig~zsmalloc-add-kconfig-for-enabling-page-table-method
+++ a/drivers/staging/zsmalloc/Kconfig
@@ -9,3 +9,16 @@ config ZSMALLOC
 	  non-standard allocator interface where a handle, not a pointer, is
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
+
+config PGTABLE_MAPPING
+	bool "Use page table mapping to access object in zsmalloc"
+	depends on ZSMALLOC
+	help
+	  By default, zsmalloc uses a copy-based object mapping method to
+	  access allocations that span two pages. However, if a particular
+	  architecture (ex, ARM) performs VM mapping faster than copying,
+	  then you should select this. This causes zsmalloc to use page table
+	  mapping rather than copying for object mapping.
+
+	  You can check speed with zsmalloc benchmark[1].
+	  [1] https://github.com/spartacus06/zsmalloc
diff -puN drivers/staging/zsmalloc/zsmalloc-main.c~zsmalloc-add-kconfig-for-enabling-page-table-method drivers/staging/zsmalloc/zsmalloc-main.c
--- a/drivers/staging/zsmalloc/zsmalloc-main.c~zsmalloc-add-kconfig-for-enabling-page-table-method
+++ a/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -218,19 +218,8 @@ struct zs_pool {
 #define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
 #define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
 
-/*
- * By default, zsmalloc uses a copy-based object mapping method to access
- * allocations that span two pages. However, if a particular architecture
- * performs VM mapping faster than copying, then it should be added here
- * so that USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use
- * page table mapping rather than copying for object mapping.
- */
-#if defined(CONFIG_ARM) && !defined(MODULE)
-#define USE_PGTABLE_MAPPING
-#endif
-
 struct mapping_area {
-#ifdef USE_PGTABLE_MAPPING
+#ifdef CONFIG_PGTABLE_MAPPING
 	struct vm_struct *vm; /* vm area for mapping object that span pages */
 #else
 	char *vm_buf; /* copy buffer for objects that span pages */
@@ -631,7 +620,7 @@ static struct page *find_get_zspage(stru
 	return page;
 }
 
-#ifdef USE_PGTABLE_MAPPING
+#ifdef CONFIG_PGTABLE_MAPPING
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -669,7 +658,7 @@ static inline void __zs_unmap_object(str
 	unmap_kernel_range(addr, PAGE_SIZE * 2);
 }
 
-#else /* USE_PGTABLE_MAPPING */
+#else /* CONFIG_PGTABLE_MAPPING */
 
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
@@ -747,7 +736,7 @@ out:
 	pagefault_enable();
 }
 
-#endif /* USE_PGTABLE_MAPPING */
+#endif /* CONFIG_PGTABLE_MAPPING */
 
 static int zs_cpu_notifier(struct notifier_block *nb, unsigned long action,
 				void *pcpu)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
debugging-keep-track-of-page-owners.patch

