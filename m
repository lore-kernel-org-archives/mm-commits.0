From: akpm@linux-foundation.org
Subject: [folded-merged] hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:54:18 -0800
Message-ID: <20130222235419.635CE5A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56720 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3BVXyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:54:20 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so121731ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:54:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, n-horiguchi@ah.jp.nec.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch

This patch was dropped because it was folded into hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix

tweak comments

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix
+++ a/mm/memory-failure.c
@@ -1130,11 +1130,11 @@ int memory_failure(unsigned long pfn, in
 	lock_page(hpage);
 
 	/*
-	 * We use page flags to determine what action should be taken,
-	 * but it can be modified by the error containment action.
-	 * One example is mlocked page, where PG_mlocked is cleared by
-	 * page_remove_rmap() in try_to_unmap_one(). So to determine page
-	 * status correctly, we store the page flags at this timing.
+	 * We use page flags to determine what action should be taken, but
+	 * the flags can be modified by the error containment action.  One
+	 * example is an mlocked page, where PG_mlocked is cleared by
+	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
+	 * correctly, we save a copy of the page flags at this time.
 	 */
 	page_flags = p->flags;
 
@@ -1197,8 +1197,8 @@ int memory_failure(unsigned long pfn, in
 
 	res = -EBUSY;
 	/*
-	 * The first check uses the current page flag which might not have any
-	 * relevant information. The second check with stored page flags are
+	 * The first check uses the current page flags which may not have any
+	 * relevant information. The second check with the saved page flagss is
 	 * carried out only if the first check can't determine the page status.
 	 */
 	for (ps = error_states;; ps++)
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
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

