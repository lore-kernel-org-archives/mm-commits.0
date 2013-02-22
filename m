From: akpm@linux-foundation.org
Subject: [folded-merged] page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:50:54 -0800
Message-ID: <20130222235054.856845A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:64983 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3BVXuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:50:55 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so121515vbb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:50:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, psz@maths.usyd.edu.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
has been removed from the -mm tree.  Its filename was
     page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch

This patch was dropped because it was folded into page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix

fix up min_free_kbytes extern declarations

Cc: Paul Szabo <psz@maths.usyd.edu.au>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    3 +++
 kernel/sysctl.c     |    1 -
 mm/huge_memory.c    |    1 -
 mm/page-writeback.c |    1 -
 4 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix include/linux/mm.h
--- a/include/linux/mm.h~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
+++ a/include/linux/mm.h
@@ -1394,6 +1394,9 @@ extern void setup_per_cpu_pageset(void);
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 
+/* page_alloc.c */
+extern int min_free_kbytes;
+
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
diff -puN kernel/sysctl.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix kernel/sysctl.c
--- a/kernel/sysctl.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
+++ a/kernel/sysctl.c
@@ -105,7 +105,6 @@ extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 #endif
 extern int pid_max;
-extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
diff -puN mm/huge_memory.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix mm/huge_memory.c
--- a/mm/huge_memory.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
+++ a/mm/huge_memory.c
@@ -105,7 +105,6 @@ static int set_recommended_min_free_kbyt
 	struct zone *zone;
 	int nr_zones = 0;
 	unsigned long recommended_min;
-	extern int min_free_kbytes;
 
 	if (!khugepaged_enabled())
 		return 0;
diff -puN mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix mm/page-writeback.c
--- a/mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
+++ a/mm/page-writeback.c
@@ -234,7 +234,6 @@ static unsigned long highmem_dirtyable_m
 static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
-	extern int min_free_kbytes;
 
 	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
 	x -= min(x, dirty_balance_reserve);
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

