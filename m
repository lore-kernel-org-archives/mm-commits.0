From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-__unmap_hugepage_range.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:38 -0800
Message-ID: <5489e922.5yQ6BAQ2TMrxVhGz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLKS5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hillf.zj@alibaba-inc.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix __unmap_hugepage_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-__unmap_hugepage_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: mm: hugetlb: fix __unmap_hugepage_range()

First, after flushing TLB, we have no need to scan pte from start again.
Second, before bail out loop, the address is forwarded one step.

Signed-off-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-__unmap_hugepage_range mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-__unmap_hugepage_range
+++ a/mm/hugetlb.c
@@ -2638,8 +2638,9 @@ void __unmap_hugepage_range(struct mmu_g
 
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+	address = start;
 again:
-	for (address = start; address < end; address += sz) {
+	for (; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
@@ -2686,6 +2687,7 @@ again:
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
+			address += sz;
 			spin_unlock(ptl);
 			break;
 		}
_

Patches currently in -mm which might be from hillf.zj@alibaba-inc.com are

origin.patch

