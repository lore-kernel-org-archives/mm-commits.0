From: akpm@linux-foundation.org
Subject: [folded-merged] mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:54:41 -0800
Message-ID: <20130222235441.9FE1F31C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34040 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3BVXym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:54:42 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so121689qeb.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:54:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@infradead.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-accurately-document-nr_free__pages-functions-with-code-comments-fix
has been removed from the -mm tree.  Its filename was
     mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch

This patch was dropped because it was folded into mm-accurately-document-nr_free__pages-functions-with-code-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-accurately-document-nr_free__pages-functions-with-code-comments-fix

tweak comments

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments-fix
+++ a/mm/page_alloc.c
@@ -2814,12 +2814,12 @@ void free_pages_exact(void *virt, size_t
 EXPORT_SYMBOL(free_pages_exact);
 
 /**
- * nr_free_zone_pages - get pages that is beyond high watermark
+ * nr_free_zone_pages - count number of pages beyond high watermark
  * @offset: The zone index of the highest zone
  *
- * The function counts pages which are beyond high watermark within
- * all zones at or below a given zone index. For each zone, the
- * amount of pages is calculated as:
+ * nr_free_zone_pages() counts the number of counts pages which are beyond the
+ * high watermark within all zones at or below a given zone index.  For each
+ * zone, the number of pages is calculated as:
  *     present_pages - high_pages
  */
 static unsigned long nr_free_zone_pages(int offset)
@@ -2843,10 +2843,10 @@ static unsigned long nr_free_zone_pages(
 }
 
 /**
- * nr_free_buffer_pages - get pages that is beyond high watermark
+ * nr_free_buffer_pages - count number of pages beyond high watermark
  *
- * The function counts pages which are beyond high watermark within
- * ZONE_DMA and ZONE_NORMAL.
+ * nr_free_buffer_pages() counts the number of pages which are beyond the high
+ * watermark within ZONE_DMA and ZONE_NORMAL.
  */
 unsigned long nr_free_buffer_pages(void)
 {
@@ -2855,10 +2855,10 @@ unsigned long nr_free_buffer_pages(void)
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
 /**
- * nr_free_pagecache_pages - get pages that is beyond high watermark
+ * nr_free_pagecache_pages - count number of pages beyond high watermark
  *
- * The function counts pages which are beyond high watermark within
- * all zones.
+ * nr_free_pagecache_pages() counts the number of pages which are beyond the
+ * high watermark within all zones.
  */
 unsigned long nr_free_pagecache_pages(void)
 {
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
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-fast-hierarchy-aware-child-test.patch
mm-rename-page-struct-field-helpers.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

