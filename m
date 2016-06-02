From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch added to -mm tree
Date: Thu, 02 Jun 2016 13:13:08 -0700
Message-ID: <57509354.GIbl4ZpWVjn8LLhy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222AbcFBUNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, minchan.kim@gmail.com, mpe@ellerman.id.au, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix
has been added to the -mm tree.  Its filename is
     powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix

tidy up radix__tlb_flush()

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/tlb-radix.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/powerpc/mm/tlb-radix.c~powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix arch/powerpc/mm/tlb-radix.c
--- a/arch/powerpc/mm/tlb-radix.c~powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix
+++ a/arch/powerpc/mm/tlb-radix.c
@@ -265,13 +265,9 @@ void radix__tlb_flush(struct mmu_gather
 	int page_size = tlb->page_size;
 
 	psize = radix_get_mmu_psize(page_size);
-	if (psize == -1)
-		/* unknown page size */
-		goto flush_mm;
 
-	if (!tlb->fullmm && !tlb->need_flush_all)
+	if (psize != -1 && !tlb->fullmm && !tlb->need_flush_all)
 		radix__flush_tlb_range_psize(mm, tlb->start, tlb->end, psize);
 	else
-flush_mm:
 		radix__flush_tlb_mm(mm);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

