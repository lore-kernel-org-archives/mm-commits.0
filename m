From: akpm@linux-foundation.org
Subject: + powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff.patch
 added to -mm tree
Date: Mon, 11 Jan 2016 14:15:46 -0800
Message-ID: <56942992.wNCAuE08OKAAuoG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759928AbcAKWPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, ldufour@linux.vnet.ibm.com, mpe@ellerman.id.au, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix _PAGE_SWP_SOFT_DIRTY breaking swapoff
has been added to the -mm tree.  Its filename is
     powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: powerpc/mm: fix _PAGE_SWP_SOFT_DIRTY breaking swapoff

Swapoff after swapping hangs on the G5, when CONFIG_CHECKPOINT_RESTORE=y
but CONFIG_MEM_SOFT_DIRTY is not set.  That's because the non-zero
_PAGE_SWP_SOFT_DIRTY bit, added by CONFIG_HAVE_ARCH_SOFT_DIRTY=y, is not
discounted when CONFIG_MEM_SOFT_DIRTY is not set: so swap ptes cannot be
recognized.

(I suspect that the peculiar dependence of HAVE_ARCH_SOFT_DIRTY on
CHECKPOINT_RESTORE in arch/powerpc/Kconfig comes from an incomplete
attempt to solve this problem.)

It's true that the relationship between CONFIG_HAVE_ARCH_SOFT_DIRTY and
and CONFIG_MEM_SOFT_DIRTY is too confusing, and it's true that swapoff
should be made more robust; but nevertheless, fix up the powerpc ifdefs as
x86_64 and s390 (which met the same problem) have them, defining the bits
as 0 if CONFIG_MEM_SOFT_DIRTY is not set.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/hash.h    |    5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h |    9 ++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/hash.h~powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff arch/powerpc/include/asm/book3s/64/hash.h
--- a/arch/powerpc/include/asm/book3s/64/hash.h~powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff
+++ a/arch/powerpc/include/asm/book3s/64/hash.h
@@ -33,7 +33,12 @@
 #define _PAGE_F_GIX_SHIFT	12
 #define _PAGE_F_SECOND		0x08000 /* Whether to use secondary hash or not */
 #define _PAGE_SPECIAL		0x10000 /* software: special page */
+
+#ifdef CONFIG_MEM_SOFT_DIRTY
 #define _PAGE_SOFT_DIRTY	0x20000 /* software: software dirty tracking */
+#else
+#define _PAGE_SOFT_DIRTY	0x00000
+#endif
 
 /*
  * We need to differentiate between explicit huge page and THP huge
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -162,8 +162,13 @@ static inline void pgd_set(pgd_t *pgdp,
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __swp_entry_to_pte(x)		__pte((x).val)
 
-#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifdef CONFIG_MEM_SOFT_DIRTY
 #define _PAGE_SWP_SOFT_DIRTY   (1UL << (SWP_TYPE_BITS + _PAGE_BIT_SWAP_TYPE))
+#else
+#define _PAGE_SWP_SOFT_DIRTY	0UL
+#endif /* CONFIG_MEM_SOFT_DIRTY */
+
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_SWP_SOFT_DIRTY);
@@ -176,8 +181,6 @@ static inline pte_t pte_swp_clear_soft_d
 {
 	return __pte(pte_val(pte) & ~_PAGE_SWP_SOFT_DIRTY);
 }
-#else
-#define _PAGE_SWP_SOFT_DIRTY	0
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 void pgtable_cache_add(unsigned shift, void (*ctor)(void *));
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch
powerpc-mm-fix-_page_swp_soft_dirty-breaking-swapoff.patch

