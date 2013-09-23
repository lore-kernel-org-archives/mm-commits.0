From: akpm@linux-foundation.org
Subject: + arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
 added to -mm tree
Date: Mon, 23 Sep 2013 15:55:13 -0700
Message-ID: <5240c6d1.RdZqtGIgjqQ+0oxu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3IWWzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, tglx@linutronix.de, mingo@elte.hu, luto@amacapital.net, hpa@zytor.com, gorcunov@openvz.org, gorcunov@gmail.com

Subject: + arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch added to -mm tree
To: gorcunov@gmail.com,gorcunov@openvz.org,hpa@zytor.com,luto@amacapital.net,mingo@elte.hu,tglx@linutronix.de,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:55:13 -0700


The patch titled
     Subject: arch/x86: mnify pte_to_pgoff and pgoff_to_pte helpers
has been added to the -mm tree.  Its filename is
     arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

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
Subject: arch/x86: mnify pte_to_pgoff and pgoff_to_pte helpers

Use unified pte_bitop helper to manipulate bits in pte/pgoff bitfield, and
convert pte_to_pgoff/pgoff_to_pte to inlines.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |  100 ++++++++++++++----------
 1 file changed, 59 insertions(+), 41 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -55,6 +55,13 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+/* Bit manipulation helper on pte/pgoff entry */
+static inline unsigned long pte_bitop(unsigned long value, unsigned int rightshift,
+				      unsigned long mask, unsigned int leftshift)
+{
+	return ((value >> rightshift) & mask) << leftshift;
+}
+
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
 /*
@@ -71,31 +78,34 @@ static inline pmd_t native_pmdp_get_and_
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
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3,  PTE_FILE_LSHIFT3) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT4,           -1UL,  PTE_FILE_LSHIFT4));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3,  PTE_FILE_SHIFT3) +
+			pte_bitop(off, PTE_FILE_LSHIFT4,           -1UL,  PTE_FILE_SHIFT4) +
+			_PAGE_FILE,
+	};
+}
 
 #else /* CONFIG_MEM_SOFT_DIRTY */
 
@@ -115,22 +125,30 @@ static inline pmd_t native_pmdp_get_and_
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
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3,           -1UL,  PTE_FILE_LSHIFT3));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3,           -1UL,  PTE_FILE_SHIFT3) +
+			_PAGE_FILE,
+	};
+}
 
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers-update.patch

