From: akpm@linux-foundation.org
Subject: + alpha-make-pte_alloc_one_kernel-inline.patch added to -mm tree
Date: Wed, 14 Jan 2009 09:47:46 -0800
Message-ID: <200901141747.n0EHlk8i020890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbZANRsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 12:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: make pte_alloc_one_kernel() inline
has been added to the -mm tree.  Its filename is
     alpha-make-pte_alloc_one_kernel-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
