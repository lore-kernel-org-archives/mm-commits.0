From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_fault-remove-reduntant-check-for-write-access.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:39:52 -0700
Message-ID: <20170911193952.l4ehtsxmy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdIKTjx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: remove reduntant check for write access
has been removed from the -mm tree.  Its filename was
     mm-page_fault-remove-reduntant-check-for-write-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/memory.c: remove reduntant check for write access

Flags argument has been copied into vmf.flags and it is not changed in
between.  Hence a single write access check can be used for both PUD and
PMD.

Link: http://lkml.kernel.org/r/20170823082839.1812-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-page_fault-remove-reduntant-check-for-write-access mm/memory.c
--- a/mm/memory.c~mm-page_fault-remove-reduntant-check-for-write-access
+++ a/mm/memory.c
@@ -3961,6 +3961,7 @@ static int __handle_mm_fault(struct vm_a
 		.pgoff = linear_page_index(vma, address),
 		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
+	unsigned int dirty = flags & FAULT_FLAG_WRITE;
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -3983,7 +3984,6 @@ static int __handle_mm_fault(struct vm_a
 
 		barrier();
 		if (pud_trans_huge(orig_pud) || pud_devmap(orig_pud)) {
-			unsigned int dirty = flags & FAULT_FLAG_WRITE;
 
 			/* NUMA case for anonymous PUDs would go here */
 
@@ -4020,8 +4020,7 @@ static int __handle_mm_fault(struct vm_a
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
 
-			if ((vmf.flags & FAULT_FLAG_WRITE) &&
-					!pmd_write(orig_pmd)) {
+			if (dirty && !pmd_write(orig_pmd)) {
 				ret = wp_huge_pmd(&vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are


