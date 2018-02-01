From: akpm@linux-foundation.org
Subject: [patch 066/119] s390/mm: modify pmdp_invalidate to return
 old value.
Date: Wed, 31 Jan 2018 16:18:05 -0800
Message-ID: <20180201001805.fH7N_20ip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755789AbeBAASH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
