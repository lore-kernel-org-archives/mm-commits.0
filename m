From: akpm@linux-foundation.org
Subject: [merged] mm-preserve-original-node-for-transparent-huge-page-copies.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:20 -0800
Message-ID: <201103072132.p27LW3jT028098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201Ab1CGVeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:34:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: preserve original node for transparent huge page copies
has been removed from the -mm tree.  Its filename was
     mm-preserve-original-node-for-transparent-huge-page-copies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: preserve original node for transparent huge page copies
From: Andi Kleen <ak@linux.intel.com>

This makes a difference for LOCAL policy, where the node cannot be
determined from the policy itself, but has to be gotten from the original
page.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-preserve-original-node-for-transparent-huge-page-copies mm/huge_memory.c
--- a/mm/huge_memory.c~mm-preserve-original-node-for-transparent-huge-page-copies
+++ a/mm/huge_memory.c
@@ -799,8 +799,8 @@ static int do_huge_pmd_wp_page_fallback(
 	}
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-					  vma, address);
+		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE,
+					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_newpage_charge(pages[i], mm,
 						       GFP_KERNEL))) {
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
mm-add-__gfp_other_node-flag.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

