From: akpm@linux-foundation.org
Subject: + mm-page_fault-remove-reduntant-check-for-write-access.patch
 added to -mm tree
Date: Wed, 23 Aug 2017 15:40:23 -0700
Message-ID: <599e0457.rYuQsR9kk7obxvQ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdHWWkY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: remove reduntant check for write access
has been added to the -mm tree.  Its filename is
     mm-page_fault-remove-reduntant-check-for-write-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_fault-remove-reduntant-check-for-write-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_fault-remove-reduntant-check-for-write-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_fault-remove-reduntant-check-for-write-access.patch

