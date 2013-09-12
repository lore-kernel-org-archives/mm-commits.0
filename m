From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:15 -0700
Message-ID: <523219cb.zKYLcrXMzpuvbMTE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3ILTpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, jbeulich@suse.com, gorcunov@openvz.org, gorcunov@gmail.com

Subject: [merged] mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte.patch removed from -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org,jbeulich@suse.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:15 -0700


The patch titled
     Subject: mm: make sure _PAGE_SWP_SOFT_DIRTY bit is not set on present pte
has been removed from the -mm tree.  Its filename was
     mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: make sure _PAGE_SWP_SOFT_DIRTY bit is not set on present pte

_PAGE_SOFT_DIRTY bit should never be set on present pte so add VM_BUG_ON
to catch any potential future abuse.

Also add a comment on _PAGE_SWP_SOFT_DIRTY definition explaining scope of
its usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |   34 +++++++++++++------------
 arch/x86/include/asm/pgtable_types.h |    3 ++
 2 files changed, 22 insertions(+), 15 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte
+++ a/arch/x86/include/asm/pgtable.h
@@ -315,21 +315,6 @@ static inline pmd_t pmd_mksoft_dirty(pmd
 	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
-static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
-{
-	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
-}
-
-static inline int pte_swp_soft_dirty(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
-}
-
-static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
-{
-	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
-}
-
 static inline pte_t pte_file_clear_soft_dirty(pte_t pte)
 {
 	return pte_clear_flags(pte, _PAGE_SOFT_DIRTY);
@@ -446,6 +431,7 @@ pte_t *populate_extra_pte(unsigned long
 
 #ifndef __ASSEMBLY__
 #include <linux/mm_types.h>
+#include <linux/mmdebug.h>
 #include <linux/log2.h>
 
 static inline int pte_none(pte_t pte)
@@ -864,6 +850,24 @@ static inline void update_mmu_cache_pmd(
 {
 }
 
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
diff -puN arch/x86/include/asm/pgtable_types.h~mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -75,6 +75,9 @@
  * with swap entry format. On x86 bits 6 and 7 are *not* involved
  * into swap entry computation, but bit 6 is used for nonlinear
  * file mapping, so we borrow bit 7 for soft dirty tracking.
+ *
+ * Please note that this bit must be treated as swap dirty page
+ * mark if and only if the PTE has present bit clear!
  */
 #ifdef CONFIG_MEM_SOFT_DIRTY
 #define _PAGE_SWP_SOFT_DIRTY	_PAGE_PSE
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

