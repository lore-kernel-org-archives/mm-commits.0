From: akpm@linux-foundation.org
Subject: + mm-drop-unused-pmdp_huge_get_and_clear_notify.patch added to
 -mm tree
Date: Mon, 06 Mar 2017 13:33:59 -0800
Message-ID: <58bdd5c7.RbKCRcOfKcHzsWmF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdCFVey (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:34:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop unused pmdp_huge_get_and_clear_notify()
has been added to the -mm tree.  Its filename is
     mm-drop-unused-pmdp_huge_get_and_clear_notify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-unused-pmdp_huge_get_and_clear_notify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-unused-pmdp_huge_get_and_clear_notify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop unused pmdp_huge_get_and_clear_notify()

Dave noticed that after fixing MADV_DONTNEED vs.  numa balancing race the
last pmdp_huge_get_and_clear_notify() user is gone.

Let's drop the helper.

Link: http://lkml.kernel.org/r/20170306112047.24809-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-drop-unused-pmdp_huge_get_and_clear_notify include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-drop-unused-pmdp_huge_get_and_clear_notify
+++ a/include/linux/mmu_notifier.h
@@ -394,18 +394,6 @@ static inline void mmu_notifier_mm_destr
 	___pud;								\
 })
 
-#define pmdp_huge_get_and_clear_notify(__mm, __haddr, __pmd)		\
-({									\
-	unsigned long ___haddr = __haddr & HPAGE_PMD_MASK;		\
-	pmd_t ___pmd;							\
-									\
-	___pmd = pmdp_huge_get_and_clear(__mm, __haddr, __pmd);		\
-	mmu_notifier_invalidate_range(__mm, ___haddr,			\
-				      ___haddr + HPAGE_PMD_SIZE);	\
-									\
-	___pmd;								\
-})
