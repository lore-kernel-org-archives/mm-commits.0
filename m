Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029EF1BE226
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941216; cv=none; b=PrOtQZeRfJtdki4vwLaB4sPTTbR2flAtLHEJYzF8jOwP3NaiNVouHEhiunF9DUBVKyjz5+fp9ybG1+Vx8kk9eaf6PXNBke9TtvZUY0B0ur34GlPLjX3x6pTcpAE77Te9Vd5c6zOnIy+TwbeUDVRKH285BMXOjyIAl7sZPQqtvJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941216; c=relaxed/simple;
	bh=qW/ytnuaqHWgTTKxmT1tS5zrj7zs8zJ/gXMCjqtL0WY=;
	h=Date:To:From:Subject:Message-Id; b=HOPTunhMImphUepvd7SZKOWD/uhd8W73dyse7n4LCT2V83HT89huvgrfyGcxBlm9gQ10Mcgd71RzTNxcVw62ZF6jHWpQgyDJKOUrDOi6R33gYSmUGB6c5e2I6enVtqtSnVUgtUQ/JYXKq7qyyG51fAqV+U1bwDRgfIQ0iPz/Fiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uv/EwhB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uv/EwhB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC884C116B1;
	Tue,  2 Jul 2024 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941215;
	bh=qW/ytnuaqHWgTTKxmT1tS5zrj7zs8zJ/gXMCjqtL0WY=;
	h=Date:To:From:Subject:From;
	b=uv/EwhB+QiZjRk6L59TSdrtwQuuuxz+u5xjjOjiqvj4xq0L1zbn6h+iVh7o+0vKQn
	 xEjuLduzQFjPU4BeNyh+sm7hACFBVwgexM8nF5Jh4/XJJ6tC8HgVRVwmfHFzEC4gVt
	 AqawWC0RA7uavmEK/xqND2sP5RIlARO91eQfIiHo=
Date: Tue, 02 Jul 2024 10:26:55 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-e500-free-r10-for-find_pte.patch added to mm-unstable branch
Message-Id: <20240702172655.CC884C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/e500: free r10 for FIND_PTE
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-e500-free-r10-for-find_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-e500-free-r10-for-find_pte.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

