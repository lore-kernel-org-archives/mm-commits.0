From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update.patch removed from -mm tree
Date: Mon, 23 Sep 2013 15:55:28 -0700
Message-ID: <5240c6e0.px77H+2hzj1siaee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3IWWz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, gorcunov@openvz.org, gorcunov@gmail.com

Subject: [to-be-updated] arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update.patch removed from -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:55:28 -0700


The patch titled
     Subject: mm: unify pte_to_pgoff and pgoff_to_pte helpers
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: unify pte_to_pgoff and pgoff_to_pte helpers

Use unified pte_bfop helper to manipulate bits in pte/pgoff bitfield, and
convert pte_to_pgoff/pgoff_to_pte to inlines.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |   70 +++++++++++++++---------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -55,8 +55,12 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
-#define _mfrob(v,r,m,l)		((((v) >> (r)) & (m)) << (l))
-#define __frob(v,r,l)		(((v) >> (r)) << (l))
+/* Bit manipulation helper on pte/pgoff entry */
+static inline unsigned long pte_bfop(unsigned long value, unsigned int rightshift,
+				     unsigned long mask, unsigned int leftshift)
+{
+	return ((value >> rightshift) & mask) << leftshift;
+}
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
@@ -82,19 +86,26 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
 #define PTE_FILE_LSHIFT4	(PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)
 
-#define pte_to_pgoff(pte)							    \
-	(_mfrob((pte).pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1, 0)		  + \
-	 _mfrob((pte).pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2, PTE_FILE_LSHIFT2) + \
-	 _mfrob((pte).pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3, PTE_FILE_LSHIFT3) + \
-	 __frob((pte).pte_low, PTE_FILE_SHIFT4, PTE_FILE_LSHIFT4))
-
-#define pgoff_to_pte(off)							\
-	((pte_t) { .pte_low =							\
-	_mfrob(off,                0, PTE_FILE_MASK1, PTE_FILE_SHIFT1)	+	\
-	_mfrob(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2, PTE_FILE_SHIFT2)	+	\
-	_mfrob(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3, PTE_FILE_SHIFT3)	+	\
-	__frob(off, PTE_FILE_LSHIFT4, PTE_FILE_SHIFT4)			+	\
-	_PAGE_FILE })
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bfop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		   +
+		 pte_bfop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bfop(pte.pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3,  PTE_FILE_LSHIFT3) +
+		 pte_bfop(pte.pte_low, PTE_FILE_SHIFT4,           -1UL,  PTE_FILE_LSHIFT4));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bfop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bfop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bfop(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3,  PTE_FILE_SHIFT3) +
+			pte_bfop(off, PTE_FILE_LSHIFT4,           -1UL,  PTE_FILE_SHIFT4) +
+			_PAGE_FILE,
+	};
+}
 
 #else /* CONFIG_MEM_SOFT_DIRTY */
 
@@ -120,17 +131,24 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
 #define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
 
-#define pte_to_pgoff(pte)							    \
-	(_mfrob((pte).pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1, 0)		  + \
-	 _mfrob((pte).pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2, PTE_FILE_LSHIFT2) + \
-	 __frob((pte).pte_low, PTE_FILE_SHIFT3, PTE_FILE_LSHIFT3))
-
-#define pgoff_to_pte(off)							\
-	((pte_t) { .pte_low =							\
-	_mfrob(off,                0, PTE_FILE_MASK1, PTE_FILE_SHIFT1)	+	\
-	_mfrob(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2, PTE_FILE_SHIFT2)	+	\
-	__frob(off, PTE_FILE_LSHIFT3, PTE_FILE_SHIFT3)			+	\
-	_PAGE_FILE })
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bfop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		   +
+		 pte_bfop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bfop(pte.pte_low, PTE_FILE_SHIFT3,           -1UL,  PTE_FILE_LSHIFT3));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bfop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bfop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bfop(off, PTE_FILE_LSHIFT3,           -1UL,  PTE_FILE_SHIFT3) +
+			_PAGE_FILE,
+	};
+}
 
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

