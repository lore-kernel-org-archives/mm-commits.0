Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20F612DDAF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824880; cv=none; b=PNrvxEOLFSIryss/OnL+58dTvmZyIJeaUeTpsdc6HGByhuSszzZQP/sMVwZenpOIdEhH6KjwBpWdX0QFM9pmlBNAhqvO6DGHdlF5EU1Vs2EMtkXUN7Jf1hEnztq5jBZyj7F4gVkGXDXT+W8T1Ni8VeLNuBwsN7SPLp3VZkSyYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824880; c=relaxed/simple;
	bh=dTtlSwJ8wURGBHsKeet1abJDlBo2Tx6NKugF5KWyvW4=;
	h=Date:To:From:Subject:Message-Id; b=phQHy50dUBX7Me58Asz4Wd+n5FdLeaYqJvVrUHfEl8CyMxfI/mQEREYFvucgQ7QVwGqzgd3NstxU50LJmKvW6SUZV1it7zFu1qoXTK3AHopUAQXzh/LlUi7Fi7mhV7AJTBY4ws6ljd57ALMvTavkA4WO/Zq1DIB5kWUYsxIBCOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JexB0ms7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JexB0ms7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF6EC32782;
	Fri, 12 Jul 2024 22:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824880;
	bh=dTtlSwJ8wURGBHsKeet1abJDlBo2Tx6NKugF5KWyvW4=;
	h=Date:To:From:Subject:From;
	b=JexB0ms77BOZ5MCplUU366GEbcID/glqlNZXZBcqeCoUf6bZL0kV5kqdwL9JK2dSq
	 498BGpUoeR0iXUi04Ex3cAykGFclYEJD+ns6Lu3hceeRx7xiBht0MuZePiKVxYiCGq
	 5DiV/Sq8wGjvcclpog5vQbWstOE1aMoOWmRxZ4vA=
Date: Fri, 12 Jul 2024 15:54:39 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-e500-free-r10-for-find_pte.patch removed from -mm tree
Message-Id: <20240712225440.3BF6EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/e500: free r10 for FIND_PTE
has been removed from the -mm tree.  Its filename was
     powerpc-e500-free-r10-for-find_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/e500: free r10 for FIND_PTE
Date: Tue, 2 Jul 2024 15:51:31 +0200

Move r13 load after the call to FIND_PTE, and use r13 instead of r10 for
storing fault address.  This will allow using r10 freely in FIND_PTE in
following patch to handle hugepage size.

Link: https://lkml.kernel.org/r/a3ee563ad5b13c891a15d3aae6c136c44ce8aa63.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_85xx.S |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/powerpc/kernel/head_85xx.S~powerpc-e500-free-r10-for-find_pte
+++ a/arch/powerpc/kernel/head_85xx.S
@@ -294,9 +294,10 @@ set_ivor:
 /* Macros to hide the PTE size differences
  *
  * FIND_PTE -- walks the page tables given EA & pgdir pointer
- *   r10 -- EA of fault
+ *   r10 -- free
  *   r11 -- PGDIR pointer
  *   r12 -- free
+ *   r13 -- EA of fault
  *   label 2: is the bailout case
  *
  * if we find the pte (fall through):
@@ -307,7 +308,7 @@ set_ivor:
 #ifdef CONFIG_PTE_64BIT
 #ifdef CONFIG_HUGETLB_PAGE
 #define FIND_PTE	\
-	rlwinm	r12, r10, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
+	rlwinm	r12, r13, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
 	add	r12, r11, r12;						\
 	lwz	r11, 4(r12);		/* Get pgd/pmd entry */		\
 	rlwinm.	r12, r11, 0, 0, 20;	/* Extract pt base address */	\
@@ -317,26 +318,26 @@ set_ivor:
 	andi.	r10, r11, HUGEPD_SHIFT_MASK@l; /* extract size field */	\
 	xor	r12, r10, r11;		/* drop size bits from pointer */ \
 	b	1001f;							\
-1000:	rlwimi	r12, r10, 23, 20, 28;	/* Compute pte address */	\
+1000:	rlwimi	r12, r13, 23, 20, 28;	/* Compute pte address */	\
 	li	r10, 0;			/* clear r10 */			\
 1001:	lwz	r11, 4(r12);		/* Get pte entry */
 #else
 #define FIND_PTE	\
-	rlwinm	r12, r10, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
+	rlwinm	r12, r13, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
 	add	r12, r11, r12;						\
 	lwz	r11, 4(r12);		/* Get pgd/pmd entry */		\
 	rlwinm.	r12, r11, 0, 0, 20;	/* Extract pt base address */	\
 	beq	2f;			/* Bail if no table */		\
-	rlwimi	r12, r10, 23, 20, 28;	/* Compute pte address */	\
+	rlwimi	r12, r13, 23, 20, 28;	/* Compute pte address */	\
 	lwz	r11, 4(r12);		/* Get pte entry */
 #endif /* HUGEPAGE */
 #else /* !PTE_64BIT */
 #define FIND_PTE	\
-	rlwimi	r11, r10, 12, 20, 29;	/* Create L1 (pgdir/pmd) address */	\
+	rlwimi	r11, r13, 12, 20, 29;	/* Create L1 (pgdir/pmd) address */	\
 	lwz	r11, 0(r11);		/* Get L1 entry */			\
 	rlwinm.	r12, r11, 0, 0, 19;	/* Extract L2 (pte) base address */	\
 	beq	2f;			/* Bail if no table */			\
-	rlwimi	r12, r10, 22, 20, 29;	/* Compute PTE address */		\
+	rlwimi	r12, r13, 22, 20, 29;	/* Compute PTE address */		\
 	lwz	r11, 0(r12);		/* Get Linux PTE */
 #endif
 
@@ -443,13 +444,13 @@ START_BTB_FLUSH_SECTION
 	BTB_FLUSH(r10)
 1:
 END_BTB_FLUSH_SECTION
-	mfspr	r10, SPRN_DEAR		/* Get faulting address */
+	mfspr	r13, SPRN_DEAR		/* Get faulting address */
 
 	/* If we are faulting a kernel address, we have to use the
 	 * kernel page tables.
 	 */
 	lis	r11, PAGE_OFFSET@h
-	cmplw	5, r10, r11
+	cmplw	5, r13, r11
 	blt	5, 3f
 	lis	r11, swapper_pg_dir@h
 	ori	r11, r11, swapper_pg_dir@l
@@ -472,14 +473,14 @@ END_BTB_FLUSH_SECTION
 #endif
 
 4:
+	FIND_PTE
+
 #ifdef CONFIG_PTE_64BIT
 	li	r13,_PAGE_PRESENT|_PAGE_BAP_SR
 	oris	r13,r13,_PAGE_ACCESSED@h
 #else
 	li	r13,_PAGE_PRESENT|_PAGE_READ|_PAGE_ACCESSED
 #endif
-
-	FIND_PTE
 	andc.	r13,r13,r11		/* Check permission */
 
 #ifdef CONFIG_PTE_64BIT
@@ -536,13 +537,13 @@ START_BTB_FLUSH_SECTION
 1:
 END_BTB_FLUSH_SECTION
 
-	mfspr	r10, SPRN_SRR0		/* Get faulting address */
+	mfspr	r13, SPRN_SRR0		/* Get faulting address */
 
 	/* If we are faulting a kernel address, we have to use the
 	 * kernel page tables.
 	 */
 	lis	r11, PAGE_OFFSET@h
-	cmplw	5, r10, r11
+	cmplw	5, r13, r11
 	blt	5, 3f
 	lis	r11, swapper_pg_dir@h
 	ori	r11, r11, swapper_pg_dir@l
@@ -551,6 +552,7 @@ END_BTB_FLUSH_SECTION
 	rlwinm	r12,r12,0,16,1
 	mtspr	SPRN_MAS1,r12
 
+	FIND_PTE
 	/* Make up the required permissions for kernel code */
 #ifdef CONFIG_PTE_64BIT
 	li	r13,_PAGE_PRESENT | _PAGE_BAP_SX
@@ -571,6 +573,7 @@ END_BTB_FLUSH_SECTION
 	beq	2f			/* KUAP fault */
 #endif
 
+	FIND_PTE
 	/* Make up the required permissions for user code */
 #ifdef CONFIG_PTE_64BIT
 	li	r13,_PAGE_PRESENT | _PAGE_BAP_UX
@@ -580,7 +583,6 @@ END_BTB_FLUSH_SECTION
 #endif
 
 4:
-	FIND_PTE
 	andc.	r13,r13,r11		/* Check permission */
 
 #ifdef CONFIG_PTE_64BIT
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


