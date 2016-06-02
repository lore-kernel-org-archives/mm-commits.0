From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch added to
 -mm tree
Date: Thu, 02 Jun 2016 13:13:06 -0700
Message-ID: <57509352.hs7GWg/sh/ds0nZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222AbcFBUNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, minchan.kim@gmail.com, mpe@ellerman.id.au, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/radix: implement tlb mmu gather flush efficiently
has been added to the -mm tree.  Its filename is
     powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm/radix: implement tlb mmu gather flush efficiently

Now that we track page size in mmu_gather, we can use address based tlbie
format when doing a tlb_flush().  We don't do this if we are invalidating
the full address space.

Link: http://lkml.kernel.org/r/1464860389-29019-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/tlb-radix.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/tlb-radix.c~powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently arch/powerpc/mm/tlb-radix.c
--- a/arch/powerpc/mm/tlb-radix.c~powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently
+++ a/arch/powerpc/mm/tlb-radix.c
@@ -243,9 +243,35 @@ void radix__flush_tlb_range(struct vm_ar
 }
 EXPORT_SYMBOL(radix__flush_tlb_range);
 
+static int radix_get_mmu_psize(int page_size)
+{
+	int psize;
+
+	if (page_size == (1UL << mmu_psize_defs[mmu_virtual_psize].shift))
+		psize = mmu_virtual_psize;
+	else if (page_size == (1UL << mmu_psize_defs[MMU_PAGE_2M].shift))
+		psize = MMU_PAGE_2M;
+	else if (page_size == (1UL << mmu_psize_defs[MMU_PAGE_1G].shift))
+		psize = MMU_PAGE_1G;
+	else
+		return -1;
+	return psize;
+}
 
 void radix__tlb_flush(struct mmu_gather *tlb)
 {
+	int psize = 0;
 	struct mm_struct *mm = tlb->mm;
-	radix__flush_tlb_mm(mm);
+	int page_size = tlb->page_size;
+
+	psize = radix_get_mmu_psize(page_size);
+	if (psize == -1)
+		/* unknown page size */
+		goto flush_mm;
+
+	if (!tlb->fullmm && !tlb->need_flush_all)
+		radix__flush_tlb_range_psize(mm, tlb->start, tlb->end, psize);
+	else
+flush_mm:
+		radix__flush_tlb_mm(mm);
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-debug-add-vm_warn-which-maps-to-warn.patch
powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch
mm-hugetlb-simplify-hugetlb-unmap.patch
mm-change-the-interface-for-__tlb_remove_page.patch
mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change.patch
powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch
a.patch

