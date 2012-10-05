From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:30 -0700
Message-ID: <20121005202230.9992E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54016 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:31 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so173203yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: fix build warning for UMA kernels
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/huge_memory.c: fix build warning for UMA kernels

"mm, mpol: Use special PROT_NONE to migrate pages" causes a build warning
when CONFIG_NUMA is not enabled:

mm/huge_memory.c: In function 'do_huge_pmd_prot_none':
mm/huge_memory.c:745: warning: unused variable 'node'

"node" is only used once, so avoid using it altogether.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-fix-build-warning-for-uma-kernels mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-fix-build-warning-for-uma-kernels
+++ a/mm/huge_memory.c
@@ -742,7 +742,6 @@ void do_huge_pmd_prot_none(struct mm_str
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	struct page *page = NULL;
-	int node;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
@@ -765,8 +764,7 @@ void do_huge_pmd_prot_none(struct mm_str
 	 * XXX should we serialize against split_huge_page ?
 	 */
 
-	node = mpol_misplaced(page, vma, haddr, mm->numa_big);
-	if (node == -1)
+	if (mpol_misplaced(page, vma, haddr, mm->numa_big) == -1)
 		goto do_fixup;
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
oom-remove-deprecated-oom_adj.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-up-zone-present-pages.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch
make-gfp_notrack-definition-unconditional.patch
memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch
memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch
mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch
mm-thp-fix-mlock-statistics.patch
mm-thp-fix-mlock-statistics-fix.patch
mm-use-%pk-for-proc-vmallocinfo.patch
mm-document-pagehuge-somewhat.patch

