From: akpm@linux-foundation.org
Subject: +
 userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch added to
 -mm tree
Date: Thu, 27 Jul 2017 16:42:02 -0700
Message-ID: <597a7a4a.q5bRkn5Vvd8inxDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdG0XmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic: introduce mfill_atomic_pte helper
has been added to the -mm tree.  Its filename is
     userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
