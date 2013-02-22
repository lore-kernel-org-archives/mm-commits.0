From: akpm@linux-foundation.org
Subject: [folded-merged] tmpfs-fix-mempolicy-object-leaks-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:55:13 -0800
Message-ID: <20130222235513.837915A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47601 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3BVXzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:55:15 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so121662vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:55:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs-fix-mempolicy-object-leaks-fix
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-mempolicy-object-leaks-fix.patch

This patch was dropped because it was folded into tmpfs-fix-mempolicy-object-leaks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tmpfs-fix-mempolicy-object-leaks-fix

fix handling of mpol_parse_str() errors, per Hugh

Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~tmpfs-fix-mempolicy-object-leaks-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-mempolicy-object-leaks-fix
+++ a/mm/shmem.c
@@ -2464,6 +2464,7 @@ static int shmem_parse_options(char *opt
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
 			mpol_put(mpol);
+			mpol = NULL;
 			if (mpol_parse_str(value, &mpol))
 				goto bad_val;
 		} else {
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
tmpfs-fix-mempolicy-object-leaks.patch

