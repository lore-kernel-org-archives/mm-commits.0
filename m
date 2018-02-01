From: akpm@linux-foundation.org
Subject: [merged]
 s390-mm-modify-pmdp_invalidate-to-return-old-value.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:32:21 -0800
Message-ID: <20180201193221.1PzryISb8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753556AbeBATcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, vbabka@suse.cz


The patch titled
     Subject: s390/mm: modify pmdp_invalidate to return old value.
has been removed from the -mm tree.  Its filename was
     s390-mm-modify-pmdp_invalidate-to-return-old-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: s390/mm: modify pmdp_invalidate to return old value.

It's required to avoid losing dirty and accessed bits.

Link: http://lkml.kernel.org/r/20171213105756.69879-8-kirill.shutemov@linux.intel.com
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~s390-mm-modify-pmdp_invalidate-to-return-old-value arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~s390-mm-modify-pmdp_invalidate-to-return-old-value
+++ a/arch/s390/include/asm/pgtable.h
@@ -1505,12 +1505,12 @@ static inline pmd_t pmdp_huge_clear_flus
 }
 
 #define __HAVE_ARCH_PMDP_INVALIDATE
-static inline void pmdp_invalidate(struct vm_area_struct *vma,
+static inline pmd_t pmdp_invalidate(struct vm_area_struct *vma,
 				   unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd = __pmd(pmd_val(*pmdp) | _SEGMENT_ENTRY_INVALID);
 
-	pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
+	return pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
 }
 
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are


