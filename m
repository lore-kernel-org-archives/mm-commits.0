From: akpm@linux-foundation.org
Subject: + mm-mremap-calculate-extent-in-one-place.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 19:31:33 -0700
Message-ID: <20200701023133.kwsGe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACbf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, willy@infradead.org, walken@google.com, vbabka@suse.cz, thomas_os@shipmail.org, thellstrom@vmware.com, sean.j.christopherson@intel.com, peterx@redhat.com, kirill.shutemov@linux.intel.com, digetx@gmail.com, anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com, richard.weiyang@linux.alibaba.com


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

Page tables are moved on the base of PMD.  This requires both source and
destination range should meet the requirement.

Current code works well since move_huge_pmd() and move_normal_pmd() would
check old_addr and new_addr again.  And then return to move_ptes() if the
either of them is not aligned.

In stead of calculating the extent separately, it is better to calculate
in one place, so we know it is not necessary to try move pmd.  By doing
so, the logic seems a little clear.

Link: http://lkml.kernel.org/r/20200626135216.24314-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
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

mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
