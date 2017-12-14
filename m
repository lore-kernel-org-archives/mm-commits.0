From: akpm@linux-foundation.org
Subject: + s390-mm-modify-pmdp_invalidate-to-return-old-value.patch added
 to -mm tree
Date: Wed, 13 Dec 2017 16:11:23 -0800
Message-ID: <5a31c1ab.94SYBifrbvuzO0YY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdLNALZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: modify pmdp_invalidate to return old value.
has been added to the -mm tree.  Its filename is
     s390-mm-modify-pmdp_invalidate-to-return-old-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-mm-modify-pmdp_invalidate-to-return-old-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-mm-modify-pmdp_invalidate-to-return-old-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1511,12 +1511,12 @@ static inline pmd_t pmdp_huge_clear_flus
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

s390-mm-modify-pmdp_invalidate-to-return-old-value.patch

