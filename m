From: akpm@linux-foundation.org
Subject: + mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch added to -mm tree
Date: Tue, 02 Oct 2012 15:32:53 -0700
Message-ID: <20121002223253.936D8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51049 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2JBWcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 18:32:54 -0400
Received: by ghbz15 with SMTP id z15so860554ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 15:32:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     Subject: mm/huge_memory.c: fix build warning for UMA kernels
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch
memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch
mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch

