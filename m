From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-__unmap_hugepage_range.patch added to -mm tree
Date: Tue, 04 Nov 2014 11:58:46 -0800
Message-ID: <54592ff6.lDoep/WXaOffD+/V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaKDT6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 14:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hillf.zj@alibaba-inc.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix __unmap_hugepage_range()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-__unmap_hugepage_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-__unmap_hugepage_range.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-__unmap_hugepage_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2641,8 +2641,9 @@ void __unmap_hugepage_range(struct mmu_g
 
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+	address = start;
 again:
-	for (address = start; address < end; address += sz) {
+	for (; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
@@ -2689,6 +2690,7 @@ again:
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
+			address += sz;
 			spin_unlock(ptl);
 			break;
 		}
_

Patches currently in -mm which might be from hillf.zj@alibaba-inc.com are

mm-hugetlb-fix-__unmap_hugepage_range.patch

