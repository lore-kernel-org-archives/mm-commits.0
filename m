From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch removed from -mm tree
Date: Mon, 23 Sep 2013 15:55:19 -0700
Message-ID: <5240c6d7.MhBCmKnrwYH/rB6+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3IWWzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, gorcunov@openvz.org, gorcunov@gmail.com

Subject: [to-be-updated] arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch removed from -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:55:19 -0700


The patch titled
     Subject: arch/x86/include/asm/pgtable-2level.h: clean up pte_to_pgoff and pgoff_to_pte helpers
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: arch/x86/include/asm/pgtable-2level.h: clean up pte_to_pgoff and pgoff_to_pte helpers

Andrew asked if there a way to make pte_to_pgoff and pgoff_to_pte macro
helpers somehow more readable.

With this patch it should be more understandable what is happening with
bits when they come to and from pte entry.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |   82 ++++++++++++------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -55,6 +55,9 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+#define _mfrob(v,r,m,l)		((((v) >> (r)) & (m)) << (l))
+#define __frob(v,r,l)		(((v) >> (r)) << (l))
+
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
 /*
@@ -71,31 +74,27 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 #define PTE_FILE_BITS3		(PTE_FILE_SHIFT4 - PTE_FILE_SHIFT3 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> (PTE_FILE_SHIFT1))				\
-	  & ((1U << PTE_FILE_BITS1) - 1)))				\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT2))			\
-	    & ((1U << PTE_FILE_BITS2) - 1))				\
-	   << (PTE_FILE_BITS1))						\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT3))			\
-	    & ((1U << PTE_FILE_BITS3) - 1))				\
-	   << (PTE_FILE_BITS1 + PTE_FILE_BITS2))			\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT4)))			\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 ((((off)) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1)					\
-	     & ((1U << PTE_FILE_BITS2) - 1))				\
-	    << PTE_FILE_SHIFT2)						\
-	 + ((((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	     & ((1U << PTE_FILE_BITS3) - 1))				\
-	    << PTE_FILE_SHIFT3)						\
-	 + ((((off) >>							\
-	      (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)))	\
-	    << PTE_FILE_SHIFT4)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+#define PTE_FILE_MASK3		((1U << PTE_FILE_BITS3) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+#define PTE_FILE_LSHIFT4	(PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)
+
+#define pte_to_pgoff(pte)							    \
+	(_mfrob((pte).pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1, 0)		  + \
+	 _mfrob((pte).pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2, PTE_FILE_LSHIFT2) + \
+	 _mfrob((pte).pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3, PTE_FILE_LSHIFT3) + \
+	 __frob((pte).pte_low, PTE_FILE_SHIFT4, PTE_FILE_LSHIFT4))
+
+#define pgoff_to_pte(off)							\
+	((pte_t) { .pte_low =							\
+	_mfrob(off,                0, PTE_FILE_MASK1, PTE_FILE_SHIFT1)	+	\
+	_mfrob(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2, PTE_FILE_SHIFT2)	+	\
+	_mfrob(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3, PTE_FILE_SHIFT3)	+	\
+	__frob(off, PTE_FILE_LSHIFT4, PTE_FILE_SHIFT4)			+	\
+	_PAGE_FILE })
 
 #else /* CONFIG_MEM_SOFT_DIRTY */
 
@@ -115,22 +114,23 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> PTE_FILE_SHIFT1)				\
-	  & ((1U << PTE_FILE_BITS1) - 1))				\
-	 + ((((pte).pte_low >> PTE_FILE_SHIFT2)				\
-	     & ((1U << PTE_FILE_BITS2) - 1)) << PTE_FILE_BITS1)		\
-	 + (((pte).pte_low >> PTE_FILE_SHIFT3)				\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2)))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 (((off) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1) & ((1U << PTE_FILE_BITS2) - 1))	\
-	    << PTE_FILE_SHIFT2)						\
-	 + (((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	    << PTE_FILE_SHIFT3)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+
+#define pte_to_pgoff(pte)							    \
+	(_mfrob((pte).pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1, 0)		  + \
+	 _mfrob((pte).pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2, PTE_FILE_LSHIFT2) + \
+	 __frob((pte).pte_low, PTE_FILE_SHIFT3, PTE_FILE_LSHIFT3))
+
+#define pgoff_to_pte(off)							\
+	((pte_t) { .pte_low =							\
+	_mfrob(off,                0, PTE_FILE_MASK1, PTE_FILE_SHIFT1)	+	\
+	_mfrob(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2, PTE_FILE_SHIFT2)	+	\
+	__frob(off, PTE_FILE_LSHIFT3, PTE_FILE_SHIFT3)			+	\
+	_PAGE_FILE })
 
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update.patch

