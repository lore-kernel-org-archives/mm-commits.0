From: akpm@linux-foundation.org
Subject: +
 mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
 added to -mm tree
Date: Sat, 18 Jan 2020 16:07:07 -0800
Message-ID: <20200119000707.wCzhP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgASAHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Jan 2020 19:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, thellstrom@vmware.com, kirill@shutemov.name, dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com, richardw.yang@linux.intel.com


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
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/mremap: format the check in move_normal_pmd() same as move_huge_pmd()

Patch series "mm/mremap.c: cleanup move_page_tables() a little".

move_page_tables() tries to move page table by PMD or PTE.

The root reason is if it tries to move PMD, both old and new range should
be PMD aligned.  But current code calculate old range and new range
separately.  This leads to some redundant check and calculation.

This cleanup tries to consolidate the range check in one place to reduce
some extra range handling.


This patch (of 5):

No functional change, just improve the readability and prepare for
following cleanup.

Link: http://lkml.kernel.org/r/20200117232254.2792-2-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
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

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
