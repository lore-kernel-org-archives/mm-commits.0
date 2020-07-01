From: akpm@linux-foundation.org
Subject: +
 mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 19:31:26 -0700
Message-ID: <20200701023126.zLuRJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, willy@infradead.org, walken@google.com, vbabka@suse.cz, thomas_os@shipmail.org, thellstrom@vmware.com, sean.j.christopherson@intel.com, peterx@redhat.com, kirill.shutemov@linux.intel.com, digetx@gmail.com, anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/mremap: format the check in move_normal_pmd() same as move_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch

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
Subject: mm/mremap: format the check in move_normal_pmd() same as move_huge_pmd()

Patch series "mm/mremap: cleanup move_page_tables() a little", v2.

move_page_tables() tries to move page table by PMD or PTE.

The root reason is if it tries to move PMD, both old and new range should
be PMD aligned.  But current code calculate old range and new range
separately.  This leads to some redundant check and calculation.

This cleanup tries to consolidate the range check in one place to reduce
some extra range handling.


This patch (of 4):

No functional change, just improve the readability and prepare for
following cleanup.

Link: http://lkml.kernel.org/r/20200626135216.24314-1-richard.weiyang@linux.alibaba.com
Link: http://lkml.kernel.org/r/20200626135216.24314-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd
+++ a/mm/mremap.c
@@ -200,8 +200,9 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK)
-	    || old_end - old_addr < PMD_SIZE)
+	if ((old_addr & ~PMD_MASK) ||
+	    (new_addr & ~PMD_MASK) ||
+	    old_end - old_addr < PMD_SIZE)
 		return false;
 
 	/*
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
