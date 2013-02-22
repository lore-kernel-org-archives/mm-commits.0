From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:48:13 -0800
Message-ID: <20130222234813.96EC85A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:38771 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3BVXsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:48:14 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so120952ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:48:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch

This patch was dropped because it was folded into mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix

tweak comment

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix
+++ a/mm/memory-failure.c
@@ -1040,11 +1040,11 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	/*
-	 * Currently errors on hugetlbfs pages are contained in hugepage
-	 * unit, so nr_pages should be 1 << compound_order. OTOH when
-	 * errors are on transparent hugepages, they are supposed to be
-	 * split and error containment is done in normal page unit.
-	 * So nr_pages should be one in this case.
+	 * Currently errors on hugetlbfs pages are measured in hugepage units,
+	 * so nr_pages should be 1 << compound_order.  OTOH when errors are on
+	 * transparent hugepages, they are supposed to be split and error
+	 * measurement is done in normal page units.  So nr_pages should be one
+	 * in this case.
 	 */
 	if (PageHuge(p))
 		nr_pages = 1 << compound_order(hpage);
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

