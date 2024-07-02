Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815215218A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941206; cv=none; b=IQ0da0wVN9DKspGJs3WJpylQRaXCdi5oj3NdNCPJIhxH/65E2F+0Aq3pwe5XaoQ17xdXzgOZsA4gMfAgDFoYIqGfy15VHxSFTiKnn025OgnyEhF4nxN0viDO36hXIN0JmVjgy4jKDQ/1NCBXgw5jUQN+z7rhuihKtN25g97iv8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941206; c=relaxed/simple;
	bh=AHWJbg6vgxd9NZnZJeEw8OuaGvuRcuWUW5k3MxVF2G0=;
	h=Date:To:From:Subject:Message-Id; b=PjX2OH0KRiU73+2W7RAeYeSgaRzMIa2OkGrBh4Kus0alzObAoMVNnOaRnH+fCInUbAQR2h6Sa8Z3hBszmmJ7bJCfGWc1mHXe9w10SNE/M5y228Sn3yJ6Q90LFQpa0ASsVU2UzYYC5CFF26aQI5nOEwhzJsEuZCI94sRR+mSYCTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s7STBtYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s7STBtYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE67C4AF07;
	Tue,  2 Jul 2024 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941206;
	bh=AHWJbg6vgxd9NZnZJeEw8OuaGvuRcuWUW5k3MxVF2G0=;
	h=Date:To:From:Subject:From;
	b=s7STBtYkjOFlpn9MkmnvGSRZI8r8ZwnA5S5n1UFgiex+XZXgj+2Gs7pxHf8O3Ioym
	 G5kf9m6y2pd/vEvznof03isK3feHmoWNRCPDMigTy/Q2Tmld/sJSLCnOJuMJLZVbfy
	 smxj29Hpz284brHdjb6tMJh+ew3OHIyt+5efkQ6E=
Date: Tue, 02 Jul 2024 10:26:45 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch added to mm-unstable branch
Message-Id: <20240702172646.7DE67C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/e500: remove enc and ind fields from struct mmu_psize_def
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch

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
Subject: powerpc/e500: remove enc and ind fields from struct mmu_psize_def
Date: Tue, 2 Jul 2024 15:51:27 +0200

enc field is hidden behind BOOK3E_PAGESZ_XX macros, and when you look
closer you realise that this field is nothing else than the value of shift
minus ten.

So remove enc field and calculate tsize from shift field.

Also remove inc field which is unused.

Link: https://lkml.kernel.org/r/e99136779b5b0829c2c60d37f305a1410c65cf9b.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/mmu-e500.h |    3 ---
 arch/powerpc/mm/nohash/book3e_pgtable.c    |    4 ++--
 arch/powerpc/mm/nohash/tlb.c               |    9 +--------
 arch/powerpc/mm/nohash/tlb_64e.c           |    2 +-
 4 files changed, 4 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/nohash/mmu-e500.h~powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def
+++ a/arch/powerpc/include/asm/nohash/mmu-e500.h
@@ -244,14 +244,11 @@ typedef struct {
 /* Page size definitions, common between 32 and 64-bit
  *
  *    shift : is the "PAGE_SHIFT" value for that page size
- *    penc  : is the pte encoding mask
  *
  */
 struct mmu_psize_def
 {
 	unsigned int	shift;	/* number of bits */
-	unsigned int	enc;	/* PTE encoding */
-	unsigned int    ind;    /* Corresponding indirect page size shift */
 	unsigned int	flags;
 #define MMU_PAGE_SIZE_DIRECT	0x1	/* Supported as a direct size */
 #define MMU_PAGE_SIZE_INDIRECT	0x2	/* Supported as an indirect size */
--- a/arch/powerpc/mm/nohash/book3e_pgtable.c~powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def
+++ a/arch/powerpc/mm/nohash/book3e_pgtable.c
@@ -29,10 +29,10 @@ int __meminit vmemmap_create_mapping(uns
 		_PAGE_KERNEL_RW;
 
 	/* PTEs only contain page size encodings up to 32M */
-	BUG_ON(mmu_psize_defs[mmu_vmemmap_psize].enc > 0xf);
+	BUG_ON(mmu_psize_defs[mmu_vmemmap_psize].shift - 10 > 0xf);
 
 	/* Encode the size in the PTE */
-	flags |= mmu_psize_defs[mmu_vmemmap_psize].enc << 8;
+	flags |= (mmu_psize_defs[mmu_vmemmap_psize].shift - 10) << 8;
 
 	/* For each PTE for that area, map things. Note that we don't
 	 * increment phys because all PTEs are of the large size and
--- a/arch/powerpc/mm/nohash/tlb_64e.c~powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def
+++ a/arch/powerpc/mm/nohash/tlb_64e.c
@@ -53,7 +53,7 @@ int extlb_level_exc;
  */
 void tlb_flush_pgtable(struct mmu_gather *tlb, unsigned long address)
 {
-	int tsize = mmu_psize_defs[mmu_pte_psize].enc;
+	int tsize = mmu_psize_defs[mmu_pte_psize].shift - 10;
 
 	if (book3e_htw_mode != PPC_HTW_NONE) {
 		unsigned long start = address & PMD_MASK;
--- a/arch/powerpc/mm/nohash/tlb.c~powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def
+++ a/arch/powerpc/mm/nohash/tlb.c
@@ -53,37 +53,30 @@
 struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT] = {
 	[MMU_PAGE_4K] = {
 		.shift	= 12,
-		.enc	= BOOK3E_PAGESZ_4K,
 	},
 	[MMU_PAGE_2M] = {
 		.shift	= 21,
-		.enc	= BOOK3E_PAGESZ_2M,
 	},
 	[MMU_PAGE_4M] = {
 		.shift	= 22,
-		.enc	= BOOK3E_PAGESZ_4M,
 	},
 	[MMU_PAGE_16M] = {
 		.shift	= 24,
-		.enc	= BOOK3E_PAGESZ_16M,
 	},
 	[MMU_PAGE_64M] = {
 		.shift	= 26,
-		.enc	= BOOK3E_PAGESZ_64M,
 	},
 	[MMU_PAGE_256M] = {
 		.shift	= 28,
-		.enc	= BOOK3E_PAGESZ_256M,
 	},
 	[MMU_PAGE_1G] = {
 		.shift	= 30,
-		.enc	= BOOK3E_PAGESZ_1GB,
 	},
 };
 
 static inline int mmu_get_tsize(int psize)
 {
-	return mmu_psize_defs[psize].enc;
+	return mmu_psize_defs[psize].shift - 10;
 }
 #else
 static inline int mmu_get_tsize(int psize)
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

