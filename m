From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
 added to -mm tree
Date: Tue, 28 May 2013 16:02:08 -0700
Message-ID: <51a53770.DUyA5aNq4mHy+uCG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab3E1XCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, liwanp@linux.vnet.ibm.com

Subject: + mm-hugetlb-use-already-exist-interface-huge_page_shift.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,benh@kernel.crashing.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:02:08 -0700


The patch titled
     Subject: mm/hugetlb: use already existing interface huge_page_shift
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-already-exist-interface-huge_page_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch

