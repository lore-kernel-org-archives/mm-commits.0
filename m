Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55B15218A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941204; cv=none; b=uih4YEzbmsWaV5CGqCLYVXz38lAZyyQW0HUJCyHzrulp8GOknr8jPx+hMdXuEF2W1DcakARKdfDFdS2CUSUfs/ZzLpNYjW88fNrKZ9viW6B+9Yn+jURiuYYmS9n7D8Upj/sL31Jd+bEy07fYZNvpHUYwjU1Ibuwlwl+F5ruqdxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941204; c=relaxed/simple;
	bh=CQhkWmMyymL5O2r1lHKK5nKlvIP8zRcraC335U5UdWE=;
	h=Date:To:From:Subject:Message-Id; b=CF7hrxfFn8ZsXwPnGv3+vOGNLXjpcaCZHX1b1jJXDFehiHUDMDLCEc/h+7+SRpWle+l1wOHBtEIiFCD+pPSHpJz7/GFK72CR1L2Zzm3pmjlzYLLGRGvYZRniXFKdCwS7DuBQqhSc33ey4jzh+cvNGCijjxoCoeS2WjkThbtenCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZwJpJc0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZwJpJc0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E73C116B1;
	Tue,  2 Jul 2024 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941204;
	bh=CQhkWmMyymL5O2r1lHKK5nKlvIP8zRcraC335U5UdWE=;
	h=Date:To:From:Subject:From;
	b=ZwJpJc0FGbKNMp+60H1jo2XVgswJe8uFhClYzRhkGnPFhsOosU7KGXxThwLt/Efz/
	 HvOGJyaaY/hiStzTB3Lhllkb5g2OD9V+F7juNyGInPla50lQKJaPG9nAtsoovREFIU
	 0ksM5uWu+fq1IC+licgF6hcKsSxd/FYBJ4bkaFjM=
Date: Tue, 02 Jul 2024 10:26:44 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-8xx-simplify-struct-mmu_psize_def.patch added to mm-unstable branch
Message-Id: <20240702172644.A1E73C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/8xx: simplify struct mmu_psize_def
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-8xx-simplify-struct-mmu_psize_def.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-8xx-simplify-struct-mmu_psize_def.patch

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
Subject: powerpc/8xx: simplify struct mmu_psize_def
Date: Tue, 2 Jul 2024 15:51:26 +0200

On 8xx, only the shift field is used in struct mmu_psize_def

Remove other fields and related macros.

Link: https://lkml.kernel.org/r/dd0587a9e8354005858c7f8c9a775ad05523b314.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/32/mmu-8xx.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h~powerpc-8xx-simplify-struct-mmu_psize_def
+++ a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -189,19 +189,14 @@ typedef struct {
 
 #define PHYS_IMMR_BASE (mfspr(SPRN_IMMR) & 0xfff80000)
 
-/* Page size definitions, common between 32 and 64-bit
+/*
+ * Page size definitions for 8xx
  *
  *    shift : is the "PAGE_SHIFT" value for that page size
- *    penc  : is the pte encoding mask
  *
  */
 struct mmu_psize_def {
 	unsigned int	shift;	/* number of bits */
-	unsigned int	enc;	/* PTE encoding */
-	unsigned int    ind;    /* Corresponding indirect page size shift */
-	unsigned int	flags;
-#define MMU_PAGE_SIZE_DIRECT	0x1	/* Supported as a direct size */
-#define MMU_PAGE_SIZE_INDIRECT	0x2	/* Supported as an indirect size */
 };
 
 extern struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT];
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

