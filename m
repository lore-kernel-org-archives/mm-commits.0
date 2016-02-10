From: akpm@linux-foundation.org
Subject: + mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch
 added to -mm tree
Date: Wed, 10 Feb 2016 12:23:04 -0800
Message-ID: <56bb9c28.LTI9KCIqcyu5pp2B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbcBJUXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 15:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: khugepaged: call pte flush at the time of collapse
has been added to the -mm tree.  Its filename is
     mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm,thp: khugepaged: call pte flush at the time of collapse

This showed up on ARC when running LMBench bw_mem tests as
Overlapping TLB Machine Check Exception triggered due to STLB entry
(2M pages) overlapping some NTLB entry (regular 8K page).

bw_mem 2m touches a large chunk of vaddr creating NTLB entries.
In the interim khugepaged kicks in, collapsing the contiguous ptes into
a single pmd. pmdp_collapse_flush()->flush_pmd_tlb_range() is called to
flush out NTLB entries for the ptes. This for ARC (by design) can only
shootdown STLB entries (for pmd). The stray NTLB entries cause the overlap
with the subsequent STLB entry for collapsed page.
So make pmdp_collapse_flush() call pte flush interface not pmd flush.

Note that originally all thp flush call sites in generic code called
flush_tlb_range() leaving it to architecture to implement the flush for
pte and/or pmd. Commit 12ebc1581ad11454 changed this by calling a new
opt-in API flush_pmd_tlb_range() which made the semantics more explicit
but failed to distinguish the pte vs pmd flush in generic code, which is
what this patch fixes.

Note that ARC can fixed w/o touching the generic pmdp_collapse_flush()
by defining a ARC version, but that defeats the purpose of generic
version, plus sementically this is the right thing to do.

Fixes STAR 9000961194: LMBench on AXS103 triggering duplicate TLB
exceptions with super pages

Fixes: 12ebc1581ad11454 ("mm,thp: introduce flush_pmd_tlb_range")
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[4.4]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/pgtable-generic.c~mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse
+++ a/mm/pgtable-generic.c
@@ -195,7 +195,9 @@ pmd_t pmdp_collapse_flush(struct vm_area
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	VM_BUG_ON(pmd_trans_huge(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
-	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+
+	/* collapse entails shooting down ptes not pmd */
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
 #endif
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch

