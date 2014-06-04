From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch removed from
 -mm tree
Date: Wed, 04 Jun 2014 15:28:08 -0700
Message-ID: <538f9d78.+VWxYVZdo/+9Z+rD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaFDW2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gorcunov@openvz.org, gorcunov@gmail.com

Subject: [folded-merged] mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch removed from -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:28:07 -0700


The patch titled
     Subject: mm: pgtable -- Require X86_64 for soft-dirty tracker, v2
has been removed from the -mm tree.  Its filename was
     mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker-v2.patch

This patch was dropped because it was folded into mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch

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
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch

