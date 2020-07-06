From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked]
 mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
 removed from -mm tree
Date: Mon, 06 Jul 2020 16:03:11 -0700
Message-ID: <20200706230311.QxUE01f6V%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgGFXDN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:03:13 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, digetx@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, peterx@redhat.com, richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com, thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: format the check in move_normal_pmd() same as move_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch

This patch was dropped because it was nacked

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

mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch
