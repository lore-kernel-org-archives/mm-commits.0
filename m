From: akpm@linux-foundation.org
Subject: [merged] alpha-make-pte_alloc_one_kernel-inline.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:46 -0800
Message-ID: <200901161917.n0GJHkhg026350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758352AbZAPTWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: make pte_alloc_one_kernel() inline
has been removed from the -mm tree.  Its filename was
     alpha-make-pte_alloc_one_kernel-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: make pte_alloc_one_kernel() inline
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

As it's just a single call to __get_free_page().

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h |    7 ++++++-
 arch/alpha/mm/init.c             |    7 -------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/alpha/include/asm/pgalloc.h~alpha-make-pte_alloc_one_kernel-inline arch/alpha/include/asm/pgalloc.h
--- a/arch/alpha/include/asm/pgalloc.h~alpha-make-pte_alloc_one_kernel-inline
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -50,7 +50,12 @@ pmd_free(struct mm_struct *mm, pmd_t *pm
 	free_page((unsigned long)pmd);
 }
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr);
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	return pte;
+}
 
 static inline void
 pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff -puN arch/alpha/mm/init.c~alpha-make-pte_alloc_one_kernel-inline arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~alpha-make-pte_alloc_one_kernel-inline
+++ a/arch/alpha/mm/init.c
@@ -59,13 +59,6 @@ pgd_alloc(struct mm_struct *mm)
 	return ret;
 }
 
-pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return pte;
-}
