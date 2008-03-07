From: akpm@linux-foundation.org
Subject: + powerpc-8xx-fix-swap.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:07:54 -0800
Message-ID: <200803070807.m2787sRq012352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbYCGIIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:08:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitb@kernel.crashing.org, benh@kernel.crashing.org, galak@kernel.crashing.org, paulus@samba.org, scottwood@freescale.com, segher@kernel.crashing.org, yur@emcraft.com


The patch titled
     powerpc: 8xx: fix swap
has been added to the -mm tree.  Its filename is
     powerpc-8xx-fix-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: 8xx: fix swap
From: Vitaly Bordug <vitb@kernel.crashing.org>

This makes swap routines operate correctly on the ppc_8xx based machines. 
Code has been revalidated on mpc885ads (8M sdram) with recent kernel.  Based
on patch from Yuri Tikhonov <yur@emcraft.com> to do the same on arch/ppc
instance.

Recent kernel's size makes swap feature very important on low-memory
platforms, those are actually non-operable without it.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_8xx.S      |   30 +++++++++++++++++++++++++-
 include/asm-powerpc/pgtable-ppc32.h |    8 ------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/kernel/head_8xx.S~powerpc-8xx-fix-swap arch/powerpc/kernel/head_8xx.S
--- a/arch/powerpc/kernel/head_8xx.S~powerpc-8xx-fix-swap
+++ a/arch/powerpc/kernel/head_8xx.S
@@ -332,8 +332,18 @@ InstructionTLBMiss:
 	mfspr	r11, SPRN_MD_TWC	/* ....and get the pte address */
 	lwz	r10, 0(r11)	/* Get the pte */
 
+#ifdef CONFIG_SWAP
+	/* do not set the _PAGE_ACCESSED bit of a non-present page */
+	andi.	r11, r10, _PAGE_PRESENT
+	beq	4f
+	ori	r10, r10, _PAGE_ACCESSED
+	mfspr	r11, SPRN_MD_TWC	/* get the pte address again */
+	stw	r10, 0(r11)
+4:
+#else
 	ori	r10, r10, _PAGE_ACCESSED
 	stw	r10, 0(r11)
+#endif
 
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 21, 22 and 28 must be clear.
@@ -398,8 +408,17 @@ DataStoreTLBMiss:
 	DO_8xx_CPU6(0x3b80, r3)
 	mtspr	SPRN_MD_TWC, r11
 
-	mfspr	r11, SPRN_MD_TWC	/* get the pte address again */
+#ifdef CONFIG_SWAP
+	/* do not set the _PAGE_ACCESSED bit of a non-present page */
+	andi.	r11, r10, _PAGE_PRESENT
+	beq	4f
 	ori	r10, r10, _PAGE_ACCESSED
+4:
+	/* and update pte in table */
+#else
+	ori	r10, r10, _PAGE_ACCESSED
+#endif
+	mfspr	r11, SPRN_MD_TWC	/* get the pte address again */
 	stw	r10, 0(r11)
 
 	/* The Linux PTE won't go exactly into the MMU TLB.
@@ -507,7 +526,16 @@ DataTLBError:
 
 	/* Update 'changed', among others.
 	*/
+#ifdef CONFIG_SWAP
+	ori	r10, r10, _PAGE_DIRTY|_PAGE_HWWRITE
+	/* do not set the _PAGE_ACCESSED bit of a non-present page */
+	andi.	r11, r10, _PAGE_PRESENT
+	beq	4f
+	ori	r10, r10, _PAGE_ACCESSED
+4:
+#else
 	ori	r10, r10, _PAGE_DIRTY|_PAGE_ACCESSED|_PAGE_HWWRITE
+#endif
 	mfspr	r11, SPRN_MD_TWC		/* Get pte address again */
 	stw	r10, 0(r11)		/* and update pte in table */
 
diff -puN include/asm-powerpc/pgtable-ppc32.h~powerpc-8xx-fix-swap include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~powerpc-8xx-fix-swap
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -339,14 +339,6 @@ extern int icache_44x_need_flush;
 #define _PMD_PAGE_MASK	0x000c
 #define _PMD_PAGE_8M	0x000c
 
-/*
- * The 8xx TLB miss handler allegedly sets _PAGE_ACCESSED in the PTE
- * for an address even if _PAGE_PRESENT is not set, as a performance
- * optimization.  This is a bug if you ever want to use swap unless
- * _PAGE_ACCESSED is 2, which it isn't, or unless you have 8xx-specific
- * definitions for __swp_entry etc. below, which would be gross.
- *  -- paulus
- */
 #define _PTE_NONE_MASK _PAGE_ACCESSED
 
 #else /* CONFIG_6xx */
_

Patches currently in -mm which might be from vitb@kernel.crashing.org are

powerpc-8xx-fix-swap.patch

