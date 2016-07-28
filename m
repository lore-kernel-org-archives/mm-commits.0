From: akpm@linux-foundation.org
Subject: [patch 071/101] mm, THP: clean up return value of
 madvise_free_huge_pmd
Date: Thu, 28 Jul 2016 15:48:03 -0700
Message-ID: <579a8ba3.Ltj9VK/JKReSwC3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcG1WsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ying.huang@intel.com, aarcange@redhat.com, dan.j.williams@intel.com, ebru.akagunduz@gmail.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz

From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP: clean up return value of madvise_free_huge_pmd

The definition of return value of madvise_free_huge_pmd is not clear
before.  According to the suggestion of Minchan Kim, change the type of
return value to bool and return true if we do MADV_FREE successfully on
entire pmd page, otherwise, return false.  Comments are added too.

Link: http://lkml.kernel.org/r/1467135452-16688-2-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-clean-up-return-value-of-madvise_free_huge_pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-clean-up-return-value-of-madvise_free_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -11,7 +11,7 @@ extern struct page *follow_trans_huge_pm
 					  unsigned long addr,
 					  pmd_t *pmd,
 					  unsigned int flags);
-extern int madvise_free_huge_pmd(struct mmu_gather *tlb,
+extern bool madvise_free_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd, unsigned long addr, unsigned long next);
 extern int zap_huge_pmd(struct mmu_gather *tlb,
diff -puN mm/huge_memory.c~mm-thp-clean-up-return-value-of-madvise_free_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-clean-up-return-value-of-madvise_free_huge_pmd
+++ a/mm/huge_memory.c
@@ -1249,25 +1249,26 @@ out:
 	return 0;
 }
 
-int madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+/*
+ * Return true if we do MADV_FREE successfully on entire pmd page.
+ * Otherwise, return false.
+ */
+bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		pmd_t *pmd, unsigned long addr, unsigned long next)
-
 {
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 	struct page *page;
 	struct mm_struct *mm = tlb->mm;
-	int ret = 0;
+	bool ret = false;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
 		goto out_unlocked;
 
 	orig_pmd = *pmd;
-	if (is_huge_zero_pmd(orig_pmd)) {
-		ret = 1;
+	if (is_huge_zero_pmd(orig_pmd))
 		goto out;
-	}
 
 	page = pmd_page(orig_pmd);
 	/*
@@ -1309,7 +1310,7 @@ int madvise_free_huge_pmd(struct mmu_gat
 		set_pmd_at(mm, addr, pmd, orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	}
-	ret = 1;
+	ret = true;
 out:
 	spin_unlock(ptl);
 out_unlocked:
_
