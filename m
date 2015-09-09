From: akpm@linux-foundation.org
Subject: [merged] thp-change-insert_pfns-return-type-to-void.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:17 -0700
Message-ID: <55f08bd5.e2MbwQv4lSUsmKpu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change insert_pfn's return type to void
has been removed from the -mm tree.  Its filename was
     thp-change-insert_pfns-return-type-to-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: thp: change insert_pfn's return type to void

It would make more sense to have all the return values from
vmf_insert_pfn_pmd() encoded in one place instead of having to follow the
convention into insert_pfn().  Suggested by Jeff Moyer.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-change-insert_pfns-return-type-to-void mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-insert_pfns-return-type-to-void
+++ a/mm/huge_memory.c
@@ -869,7 +869,7 @@ int do_huge_pmd_anonymous_page(struct mm
 					    flags);
 }
 
-static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned long pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -887,7 +887,6 @@ static int insert_pfn_pmd(struct vm_area
 		update_mmu_cache_pmd(vma, addr, pmd);
 	}
 	spin_unlock(ptl);
-	return VM_FAULT_NOPAGE;
 }
 
 int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
@@ -909,7 +908,8 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 		return VM_FAULT_SIGBUS;
 	if (track_pfn_insert(vma, &pgprot, pfn))
 		return VM_FAULT_SIGBUS;
-	return insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+	return VM_FAULT_NOPAGE;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
_

Patches currently in -mm which might be from willy@linux.intel.com are


