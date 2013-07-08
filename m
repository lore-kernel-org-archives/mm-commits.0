From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-use-already-exist-interface-huge_page_shift.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:25:58 -0700
Message-ID: <51db1246.ZJPwmzsZpBBeoR7z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3GHTZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hugetlb-use-already-exist-interface-huge_page_shift.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,benh@kernel.crashing.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:58 -0700


The patch titled
     Subject: mm/hugetlb: use already existing interface huge_page_shift
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-already-exist-interface-huge_page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hugetlb: use already existing interface huge_page_shift

Use the already existing interface huge_page_shift instead of h->order +
PAGE_SHIFT.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 mm/hugetlb.c                  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-use-already-exist-interface-huge_page_shift arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-use-already-exist-interface-huge_page_shift
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -357,7 +357,7 @@ void add_gpage(u64 addr, u64 page_size,
 int alloc_bootmem_huge_page(struct hstate *hstate)
 {
 	struct huge_bootmem_page *m;
-	int idx = shift_to_mmu_psize(hstate->order + PAGE_SHIFT);
+	int idx = shift_to_mmu_psize(huge_page_shift(hstate));
 	int nr_gpages = gpage_freearray[idx].nr_gpages;
 
 	if (nr_gpages == 0)
diff -puN mm/hugetlb.c~mm-hugetlb-use-already-exist-interface-huge_page_shift mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-already-exist-interface-huge_page_shift
+++ a/mm/hugetlb.c
@@ -319,7 +319,7 @@ unsigned long vma_kernel_pagesize(struct
 
 	hstate = hstate_vma(vma);
 
-	return 1UL << (hstate->order + PAGE_SHIFT);
+	return 1UL << huge_page_shift(hstate);
 }
 EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-thp-fix-doc-for-transparent-huge-zero-page.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

