From: akpm@linux-foundation.org
Subject: + mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch
 added to -mm tree
Date: Tue, 06 May 2014 15:38:39 -0700
Message-ID: <5369646f.DJyWGG2b/W0dCH16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaEFWik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 18:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gorcunov@openvz.org, gorcunov@gmail.com

Subject: + mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch added to -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 15:38:39 -0700


The patch titled
     Subject: mm: pgtable -- Require X86_64 for soft-dirty tracker, v2
has been added to the -mm tree.  Its filename is
     mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: pgtable -- Require X86_64 for soft-dirty tracker, v2

v2 (by akpm@):
 - guard helpers with CONFIG_HAVE_ARCH_SOFT_DIRTY on i386, otherwise
   it fails to build because we've a generic definitions in
   asm-generic/pgtable.h

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2 arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2
+++ a/arch/x86/include/asm/pgtable.h
@@ -297,6 +297,7 @@ static inline pmd_t pmd_mknotpresent(pmd
 	return pmd_clear_flags(pmd, _PAGE_PRESENT);
 }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
@@ -332,6 +333,8 @@ static inline int pte_file_soft_dirty(pt
 	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
 }
 
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 /*
  * Mask out unsupported bits in a present pgprot.  Non-present pgprots
  * can use those bits for other purposes, so leave them be.
@@ -865,6 +868,7 @@ static inline void update_mmu_cache_pmd(
 {
 }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
 	VM_BUG_ON(pte_present_nonuma(pte));
@@ -882,6 +886,7 @@ static inline pte_t pte_swp_clear_soft_d
 	VM_BUG_ON(pte_present_nonuma(pte));
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
+#endif
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
_

Patches currently in -mm which might be from gorcunov@gmail.com are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch

