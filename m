From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-calculate-extent-in-one-place.patch added to
 -mm tree
Date: Wed, 08 Jul 2020 16:16:43 -0700
Message-ID: <20200708231643.4riB__yFP%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGHXQp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:16:45 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, digetx@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, peterx@redhat.com, richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com, thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: calculate extent in one place
has been added to the -mm tree.  Its filename is
     mm-mremap-calculate-extent-in-one-place.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-calculate-extent-in-one-place.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-calculate-extent-in-one-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: calculate extent in one place

Page tables is moved on the base of PMD.  This requires both source and
destination range should meet the requirement.

Current code works well since move_huge_pmd() and move_normal_pmd() would
check old_addr and new_addr again.  And then return to move_ptes() if the
either of them is not aligned.

Instead of calculating the extent separately, it is better to calculate in
one place, so we know it is not necessary to try move pmd.  By doing so,
the logic seems a little clear.

Link: http://lkml.kernel.org/r/20200708095028.41706-3-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-mremap-calculate-extent-in-one-place
+++ a/mm/mremap.c
@@ -258,6 +258,9 @@ unsigned long move_page_tables(struct vm
 		extent = next - old_addr;
 		if (extent > old_end - old_addr)
 			extent = old_end - old_addr;
+		next = (new_addr + PMD_SIZE) & PMD_MASK;
+		if (extent > next - new_addr)
+			extent = next - new_addr;
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
@@ -301,9 +304,6 @@ unsigned long move_page_tables(struct vm
 
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
 			break;
-		next = (new_addr + PMD_SIZE) & PMD_MASK;
-		if (extent > next - new_addr)
-			extent = next - new_addr;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent, new_vma,
 			  new_pmd, new_addr, need_rmap_locks);
 	}
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch
