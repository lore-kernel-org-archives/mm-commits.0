Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D41BE23B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941160; cv=none; b=PM8T+1pt8g42aTk4rg9Yvzg1DEQ104ZdjCd9tyUv7VheE5n2GYKyFaTS5r5EPSHOSFWbRKvM34dEi2WaJQa8TJntvXnxIUjTq133Hi7yax2fqxMuqFaj9hpvCnm28ZSfUR3GY22YeFwfuv6BesdlxKfT5rWsYE0nEgGyPG8Bw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941160; c=relaxed/simple;
	bh=hDmD64V0lJ+VrG+21b1+xNZuM09bgvSorTpyM8GsbEg=;
	h=Date:To:From:Subject:Message-Id; b=RR6EO5G6TRCHBUZbDxRF7JF9yH6Qe7ljaFx3sNhaMBtOnIrWSLrLALXeWi9TpFjVs62qqFYgI3+SHd2XG0WxZ3RAgt6PZB8bCMZYHmTrm/sYEhVHA69i8IDCpWCaXXAslHT+qu4CLbkqDNR2Yj5CyjfT3EKu9DwNUBHGH+B5xgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzUzR1K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzUzR1K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79FAC4AF0C;
	Tue,  2 Jul 2024 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941159;
	bh=hDmD64V0lJ+VrG+21b1+xNZuM09bgvSorTpyM8GsbEg=;
	h=Date:To:From:Subject:From;
	b=tzUzR1K1DorpARsZYrMcjztm/2C2yL62VtxquDqTz85bLXKm4iPKe5ByNLXqO2Hbj
	 bR4fL4c5g3CA+k/+nS5iWrFaGm4aqyzvylc64Lkp4YIIhXLEYlEd3qPT/24QnPw8gb
	 5vpA8/jQOwT0NvqWytb96sj8HNM+w7P6868EVqFM=
Date: Tue, 02 Jul 2024 10:25:59 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,jgg@nvidia.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch added to mm-unstable branch
Message-Id: <20240702172559.A79FAC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/64e: drop MMU_FTR_TYPE_FSL_E checks in 64-bit code
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch

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
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: powerpc/64e: drop MMU_FTR_TYPE_FSL_E checks in 64-bit code
Date: Tue, 2 Jul 2024 15:51:16 +0200

All 64-bit Book3E have MMU_FTR_TYPE_FSL_E, since A2 was removed, so remove
checks for it in 64-bit only code.

Link: https://lkml.kernel.org/r/2b0b0bc9752e6cece222e4e2050358da70bb631d.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_64.c   |    6 -
 arch/powerpc/mm/nohash/tlb_64e.c |  101 +++++++++++------------------
 2 files changed, 40 insertions(+), 67 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c~powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code
+++ a/arch/powerpc/kernel/setup_64.c
@@ -696,11 +696,7 @@ __init u64 ppc64_bolted_size(void)
 {
 #ifdef CONFIG_PPC_BOOK3E_64
 	/* Freescale BookE bolts the entire linear mapping */
-	/* XXX: BookE ppc64_rma_limit setup seems to disagree? */
-	if (early_mmu_has_feature(MMU_FTR_TYPE_FSL_E))
-		return linear_map_top;
-	/* Other BookE, we assume the first GB is bolted */
-	return 1ul << 30;
+	return linear_map_top;
 #else
 	/* BookS radix, does not take faults on linear mapping */
 	if (early_radix_enabled())
--- a/arch/powerpc/mm/nohash/tlb_64e.c~powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code
+++ a/arch/powerpc/mm/nohash/tlb_64e.c
@@ -86,9 +86,8 @@ static void __init setup_page_sizes(void
 	int psize;
 
 	unsigned int mmucfg = mfspr(SPRN_MMUCFG);
-	int fsl_mmu = mmu_has_feature(MMU_FTR_TYPE_FSL_E);
 
-	if (fsl_mmu && (mmucfg & MMUCFG_MAVN) == MMUCFG_MAVN_V1) {
+	if ((mmucfg & MMUCFG_MAVN) == MMUCFG_MAVN_V1) {
 		unsigned int tlb1cfg = mfspr(SPRN_TLB1CFG);
 		unsigned int min_pg, max_pg;
 
@@ -115,7 +114,7 @@ static void __init setup_page_sizes(void
 		goto out;
 	}
 
-	if (fsl_mmu && (mmucfg & MMUCFG_MAVN) == MMUCFG_MAVN_V2) {
+	if ((mmucfg & MMUCFG_MAVN) == MMUCFG_MAVN_V2) {
 		u32 tlb1cfg, tlb1ps;
 
 		tlb0cfg = mfspr(SPRN_TLB0CFG);
@@ -213,26 +212,24 @@ static void early_init_this_mmu(void)
 	}
 	mtspr(SPRN_MAS4, mas4);
 
-	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
-		unsigned int num_cams;
-		bool map = true;
+	unsigned int num_cams;
+	bool map = true;
 
-		/* use a quarter of the TLBCAM for bolted linear map */
-		num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
+	/* use a quarter of the TLBCAM for bolted linear map */
+	num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
 
-		/*
-		 * Only do the mapping once per core, or else the
-		 * transient mapping would cause problems.
-		 */
+	/*
+	 * Only do the mapping once per core, or else the
+	 * transient mapping would cause problems.
+	 */
 #ifdef CONFIG_SMP
-		if (hweight32(get_tensr()) > 1)
-			map = false;
+	if (hweight32(get_tensr()) > 1)
+		map = false;
 #endif
 
-		if (map)
-			linear_map_top = map_mem_in_cams(linear_map_top,
-							 num_cams, false, true);
-	}
+	if (map)
+		linear_map_top = map_mem_in_cams(linear_map_top,
+						 num_cams, false, true);
 
 	/* A sync won't hurt us after mucking around with
 	 * the MMU configuration
@@ -242,16 +239,10 @@ static void early_init_this_mmu(void)
 
 static void __init early_init_mmu_global(void)
 {
-	/* XXX This should be decided at runtime based on supported
-	 * page sizes in the TLB, but for now let's assume 16M is
-	 * always there and a good fit (which it probably is)
-	 *
+	/*
 	 * Freescale booke only supports 4K pages in TLB0, so use that.
 	 */
-	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E))
-		mmu_vmemmap_psize = MMU_PAGE_4K;
-	else
-		mmu_vmemmap_psize = MMU_PAGE_16M;
+	mmu_vmemmap_psize = MMU_PAGE_4K;
 
 	/* XXX This code only checks for TLB 0 capabilities and doesn't
 	 *     check what page size combos are supported by the HW. It
@@ -264,13 +255,10 @@ static void __init early_init_mmu_global
 	/* Look for HW tablewalk support */
 	setup_mmu_htw();
 
-	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
-		if (book3e_htw_mode == PPC_HTW_NONE) {
-			extlb_level_exc = EX_TLB_SIZE;
-			patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
-			patch_exception(0x1e0,
-				exc_instruction_tlb_miss_bolted_book3e);
-		}
+	if (book3e_htw_mode == PPC_HTW_NONE) {
+		extlb_level_exc = EX_TLB_SIZE;
+		patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
+		patch_exception(0x1e0, exc_instruction_tlb_miss_bolted_book3e);
 	}
 
 	/* Set the global containing the top of the linear mapping
@@ -283,16 +271,14 @@ static void __init early_init_mmu_global
 
 static void __init early_mmu_set_memory_limit(void)
 {
-	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
-		/*
-		 * Limit memory so we dont have linear faults.
-		 * Unlike memblock_set_current_limit, which limits
-		 * memory available during early boot, this permanently
-		 * reduces the memory available to Linux.  We need to
-		 * do this because highmem is not supported on 64-bit.
-		 */
-		memblock_enforce_memory_limit(linear_map_top);
-	}
+	/*
+	 * Limit memory so we dont have linear faults.
+	 * Unlike memblock_set_current_limit, which limits
+	 * memory available during early boot, this permanently
+	 * reduces the memory available to Linux.  We need to
+	 * do this because highmem is not supported on 64-bit.
+	 */
+	memblock_enforce_memory_limit(linear_map_top);
 
 	memblock_set_current_limit(linear_map_top);
 }
@@ -313,12 +299,8 @@ void early_init_mmu_secondary(void)
 void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 				phys_addr_t first_memblock_size)
 {
-	/* On non-FSL Embedded 64-bit, we adjust the RMA size to match
-	 * the bolted TLB entry. We know for now that only 1G
-	 * entries are supported though that may eventually
-	 * change.
-	 *
-	 * on FSL Embedded 64-bit, usually all RAM is bolted, but with
+	/*
+	 * On FSL Embedded 64-bit, usually all RAM is bolted, but with
 	 * unusual memory sizes it's possible for some RAM to not be mapped
 	 * (such RAM is not used at all by Linux, since we don't support
 	 * highmem on 64-bit).  We limit ppc64_rma_size to what would be
@@ -330,19 +312,14 @@ void setup_initial_memory_limit(phys_add
 	 * We crop it to the size of the first MEMBLOCK to
 	 * avoid going over total available memory just in case...
 	 */
-	if (early_mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
-		unsigned long linear_sz;
-		unsigned int num_cams;
-
-		/* use a quarter of the TLBCAM for bolted linear map */
-		num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
-
-		linear_sz = map_mem_in_cams(first_memblock_size, num_cams,
-					    true, true);
-
-		ppc64_rma_size = min_t(u64, linear_sz, 0x40000000);
-	} else
-		ppc64_rma_size = min_t(u64, first_memblock_size, 0x40000000);
+	unsigned long linear_sz;
+	unsigned int num_cams;
+
+	/* use a quarter of the TLBCAM for bolted linear map */
+	num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
+
+	linear_sz = map_mem_in_cams(first_memblock_size, num_cams, true, true);
+	ppc64_rma_size = min_t(u64, linear_sz, 0x40000000);
 
 	/* Finally limit subsequent allocations */
 	memblock_set_current_limit(first_memblock_base + ppc64_rma_size);
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

powerpc-64e-remove-unused-ibm-htw-code.patch
powerpc-64e-split-out-nohash-book3e-64-bit-code.patch
powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch
powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch
powerpc-64e-consolidate-tlb-miss-handler-patching.patch
powerpc-64e-drop-unused-tlb-miss-handlers.patch

