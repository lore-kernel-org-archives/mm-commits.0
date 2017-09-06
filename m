From: akpm@linux-foundation.org
Subject: [patch 081/119] userfaultfd: mcopy_atomic: introduce
 mfill_atomic_pte helper
Date: Wed, 06 Sep 2017 16:23:06 -0700
Message-ID: <20170906232306.zNfAyhpqZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdIFXXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, xemul@virtuozzo.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: mcopy_atomic: introduce mfill_atomic_pte helper

Shuffle the code a bit to improve readability.

Link: http://lkml.kernel.org/r/1497939652-16528-5-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   46 +++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper
+++ a/mm/userfaultfd.c
@@ -371,6 +371,34 @@ extern ssize_t __mcopy_atomic_hugetlb(st
 				      bool zeropage);
 #endif /* CONFIG_HUGETLB_PAGE */
 
+static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
+						pmd_t *dst_pmd,
+						struct vm_area_struct *dst_vma,
+						unsigned long dst_addr,
+						unsigned long src_addr,
+						struct page **page,
+						bool zeropage)
+{
+	ssize_t err;
+
+	if (vma_is_anonymous(dst_vma)) {
+		if (!zeropage)
+			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
+					       dst_addr, src_addr, page);
+		else
+			err = mfill_zeropage_pte(dst_mm, dst_pmd,
+						 dst_vma, dst_addr);
+	} else {
+		err = -EINVAL; /* if zeropage is true return -EINVAL */
+		if (likely(!zeropage))
+			err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
+						     dst_vma, dst_addr,
+						     src_addr, page);
+	}
+
+	return err;
+}
+
 static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 					      unsigned long dst_start,
 					      unsigned long src_start,
@@ -487,22 +515,8 @@ retry:
 		BUG_ON(pmd_none(*dst_pmd));
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
-		if (vma_is_anonymous(dst_vma)) {
-			if (!zeropage)
-				err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
-						       dst_addr, src_addr,
-						       &page);
-			else
-				err = mfill_zeropage_pte(dst_mm, dst_pmd,
-							 dst_vma, dst_addr);
-		} else {
-			err = -EINVAL; /* if zeropage is true return -EINVAL */
-			if (likely(!zeropage))
-				err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
-							     dst_vma, dst_addr,
-							     src_addr, &page);
-		}
