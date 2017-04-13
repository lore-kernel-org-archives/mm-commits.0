From: akpm@linux-foundation.org
Subject: [patch 04/11] mm: drop unused pmdp_huge_get_and_clear_notify()
Date: Thu, 13 Apr 2017 14:56:23 -0700
Message-ID: <58eff407.r3M4biZJBFFEloN/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752196AbdDMV4Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, dave.hansen@intel.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop unused pmdp_huge_get_and_clear_notify()

Dave noticed that after fixing MADV_DONTNEED vs.  numa balancing race the
last pmdp_huge_get_and_clear_notify() user is gone.

Let's drop the helper.

Link: http://lkml.kernel.org/r/20170306112047.24809-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: <stable@vger.kernel.org>
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
