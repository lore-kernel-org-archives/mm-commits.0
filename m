From: akpm@linux-foundation.org
Subject: [folded-merged] page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:50:57 -0800
Message-ID: <20130222235057.DF02F5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55465 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3BVXu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:50:59 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so120961vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:50:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, psz@maths.usyd.edu.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix
has been removed from the -mm tree.  Its filename was
     page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch

This patch was dropped because it was folded into page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix

fix min() warning

Cc: Paul Szabo <psz@maths.usyd.edu.au>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix mm/page-writeback.c
--- a/mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix
+++ a/mm/page-writeback.c
@@ -242,7 +242,7 @@ static unsigned long global_dirtyable_me
 		x -= highmem_dirtyable_memory(x);
 
 	/* Subtract min_free_kbytes */
-	x -= min(x, min_free_kbytes >> (PAGE_SHIFT - 10));
+	x -= min_t(unsigned long, x, min_free_kbytes >> (PAGE_SHIFT - 10));
 
 	return x + 1;	/* Ensure that we never return 0 */
 }
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
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

