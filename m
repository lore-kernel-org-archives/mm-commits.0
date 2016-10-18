From: akpm@linux-foundation.org
Subject: + mm-thp-avoid-unlikely-branches-for-split_huge_pmd.patch added
 to -mm tree
Date: Tue, 18 Oct 2016 16:10:05 -0700
Message-ID: <5806abcd.rtqf1LdyGRjw1Yva%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58831 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932960AbcJRXKG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 19:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: avoid unlikely branches for split_huge_pmd
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-unlikely-branches-for-split_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-unlikely-branches-for-split_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-unlikely-branches-for-split_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: avoid unlikely branches for split_huge_pmd

While doing MADV_DONTNEED on a large area of thp memory, I noticed we
encountered many unlikely() branches in profiles for each backing
hugepage.  This is because zap_pmd_range() would call split_huge_pmd(),
which rechecked the conditions that were already validated, but as part of
an unlikely() branch.

Avoid the unlikely() branch when in a context where pmd is known to be
good for __split_huge_pmd() directly.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1610181600300.84525@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 mm/memory.c             |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/mprotect.c           |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-avoid-unlikely-branches-for-split_huge_pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-avoid-unlikely-branches-for-split_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -190,6 +190,8 @@ static inline void deferred_split_huge_p
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
+static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long address, bool freeze, struct page *page) {}
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
 		unsigned long address, bool freeze, struct page *page) {}
 
diff -puN mm/memory.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd mm/memory.c
--- a/mm/memory.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd
+++ a/mm/memory.c
@@ -1240,7 +1240,7 @@ static inline unsigned long zap_pmd_rang
 			if (next - addr != HPAGE_PMD_SIZE) {
 				VM_BUG_ON_VMA(vma_is_anonymous(vma) &&
 				    !rwsem_is_locked(&tlb->mm->mmap_sem), vma);
-				split_huge_pmd(vma, pmd, addr);
+				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
 			/* fall through */
@@ -3454,7 +3454,7 @@ static int wp_huge_pmd(struct fault_env
 
 	/* COW handled on pte level: split pmd */
 	VM_BUG_ON_VMA(fe->vma->vm_flags & VM_SHARED, fe->vma);
-	split_huge_pmd(fe->vma, fe->pmd, fe->address);
+	__split_huge_pmd(fe->vma, fe->pmd, fe->address, false, NULL);
 
 	return VM_FAULT_FALLBACK;
 }
diff -puN mm/mempolicy.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd
+++ a/mm/mempolicy.c
@@ -496,7 +496,7 @@ static int queue_pages_pte_range(pmd_t *
 			page = pmd_page(*pmd);
 			if (is_huge_zero_page(page)) {
 				spin_unlock(ptl);
-				split_huge_pmd(vma, pmd, addr);
+				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
 				get_page(page);
 				spin_unlock(ptl);
diff -puN mm/mprotect.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd mm/mprotect.c
--- a/mm/mprotect.c~mm-thp-avoid-unlikely-branches-for-split_huge_pmd
+++ a/mm/mprotect.c
@@ -176,7 +176,7 @@ static inline unsigned long change_pmd_r
 
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-				split_huge_pmd(vma, pmd, addr);
+				__split_huge_pmd(vma, pmd, addr, false, NULL);
 				if (pmd_trans_unstable(pmd))
 					continue;
 			} else {
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-avoid-unlikely-branches-for-split_huge_pmd.patch

