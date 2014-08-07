From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:57 -0700
Message-ID: <53e3dc25.J6lMroXJgVyNyO8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:59628 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaHGUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:58 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837358oig.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, bob.liu@oracle.com, dave.hansen@intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: only collapse hugepages to nodes with affinity for zone_reclaim_mode
has been removed from the -mm tree.  Its filename was
     mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
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
@@ -2233,6 +2233,30 @@ static void khugepaged_alloc_sleep(void)
 
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
@@ -2545,6 +2569,8 @@ static int khugepaged_scan_pmd(struct mm
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

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

