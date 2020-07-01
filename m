From: akpm@linux-foundation.org
Subject: + mm-mremap-start-addresses-are-properly-aligned.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 19:31:36 -0700
Message-ID: <20200701023136.iD1gN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACbi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, willy@infradead.org, walken@google.com, vbabka@suse.cz, thomas_os@shipmail.org, thellstrom@vmware.com, sean.j.christopherson@intel.com, peterx@redhat.com, kirill.shutemov@linux.intel.com, digetx@gmail.com, anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/mremap: start addresses are properly aligned
has been added to the -mm tree.  Its filename is
     mm-mremap-start-addresses-are-properly-aligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-start-addresses-are-properly-aligned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-start-addresses-are-properly-aligned.patch

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
Subject: mm/mremap: start addresses are properly aligned

After previous cleanup, extent is the minimal step for both source and
destination.  This means when extent is HPAGE_PMD_SIZE or PMD_SIZE,
old_addr and new_addr are properly aligned too.

Since these two functions are only invoked in move_page_tables, it is safe
to remove the check now.

Link: http://lkml.kernel.org/r/20200626135216.24314-5-richard.weiyang@linux.alibaba.com
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

 mm/huge_memory.c |    3 ---
 mm/mremap.c      |    3 ---
 2 files changed, 6 deletions(-)

--- a/mm/huge_memory.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/huge_memory.c
@@ -1729,9 +1729,6 @@ bool move_huge_pmd(struct vm_area_struct
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
 
-	if ((old_addr & ~HPAGE_PMD_MASK) || (new_addr & ~HPAGE_PMD_MASK))
-		return false;
-
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
--- a/mm/mremap.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/mremap.c
@@ -199,9 +199,6 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK))
-		return false;
