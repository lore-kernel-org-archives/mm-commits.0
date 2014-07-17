From: akpm@linux-foundation.org
Subject: +
 mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:32:51 -0700
Message-ID: <53c84f13.Yl8hcYayxO0aQsBx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:63463 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaGQWcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:32:52 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so828193pab.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:32:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, bob.liu@oracle.com, dave.hansen@intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: only collapse hugepages to nodes with affinity for zone_reclaim_mode
has been added to the -mm tree.  Its filename is
     mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch

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
Subject: mm, thp: only collapse hugepages to nodes with affinity for zone_reclaim_mode

Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target
node") improved the previous khugepaged logic which allocated a
transparent hugepages from the node of the first page being collapsed.

However, it is still possible to collapse pages to remote memory which may
suffer from additional access latency.  With the current policy, it is
possible that 255 pages (with PAGE_SHIFT == 12) will be collapsed remotely
if the majority are allocated from that node.

When zone_reclaim_mode is enabled, it means the VM should make every
attempt to allocate locally to prevent NUMA performance degradation.  In
this case, we do not want to collapse hugepages to remote nodes that would
suffer from increased access latency.  Thus, when zone_reclaim_mode is
enabled, only allow collapsing to nodes with RECLAIM_DISTANCE or less.

There is no functional change for systems that disable zone_reclaim_mode.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN mm/huge_memory.c~mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode
+++ a/mm/huge_memory.c
@@ -2246,6 +2246,30 @@ static void khugepaged_alloc_sleep(void)
 
 static int khugepaged_node_load[MAX_NUMNODES];
 
+static bool khugepaged_scan_abort(int nid)
+{
+	int i;
+
+	/*
+	 * If zone_reclaim_mode is disabled, then no extra effort is made to
+	 * allocate memory locally.
+	 */
+	if (!zone_reclaim_mode)
+		return false;
+
+	/* If there is a count for this node already, it must be acceptable */
+	if (khugepaged_node_load[nid])
+		return false;
+
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		if (!khugepaged_node_load[i])
+			continue;
+		if (node_distance(nid, i) > RECLAIM_DISTANCE)
+			return true;
+	}
+	return false;
+}
+
 #ifdef CONFIG_NUMA
 static int khugepaged_find_target_node(void)
 {
@@ -2562,6 +2586,8 @@ static int khugepaged_scan_pmd(struct mm
 		 * hit record.
 		 */
 		node = page_to_nid(page);
+		if (khugepaged_scan_abort(node))
+			goto out_unmap;
 		khugepaged_node_load[node]++;
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
_

Patches currently in -mm which might be from rientjes@google.com are

revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
lib-add-size-unit-t-p-e-to-memparse.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

