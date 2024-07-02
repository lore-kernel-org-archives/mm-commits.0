Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5A15218A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941158; cv=none; b=HwL+2m1V4Ht1wtsNkFuM+gJrFhuekdwpw215DtHiBELBhYqPRjtVsYgb3qqsUZlYu8+thCrI6jfY0BmV2IQBv/nsAQ04E4AMnsVMP+G4wOn6jU15PFZQVFQOH69LtL1YTOIdMdHDTQVIdudv2pF7xi3viNFNm3oeAzSA+qUway4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941158; c=relaxed/simple;
	bh=nUmqUCLF2UTKg/DbDhH3i7o79Z+dY7zyPUfAzqaloaA=;
	h=Date:To:From:Subject:Message-Id; b=OTtftBL8NcM/KdgNHiUZixlof87FftuzmZPh9WtGRwJoUp8vnAeHn7wtjKBpRb4Qii/bSHg/X6pR/jHifUH+gglMbjyaexrYN1Z0WDiFt5lwg7/AhV+lXdHVoJprre8vg4L1VUJcKrRrpLRPCjAjYXnrhR0Wc907l7sPnGiCtkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FgWxI7hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FgWxI7hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2033C116B1;
	Tue,  2 Jul 2024 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941157;
	bh=nUmqUCLF2UTKg/DbDhH3i7o79Z+dY7zyPUfAzqaloaA=;
	h=Date:To:From:Subject:From;
	b=FgWxI7hvLB35WUVw4UBDeafdv086ivPWpqy8ad/ZIGAA3qQzGO6UdemtwPQKdRPyo
	 4Y3QEcH58BudjY5eNzdeokFZLdgtu1h5J7Iw6H2l0VOlmpe5NKWQ0lXRb7XxfudK1J
	 D/IqeXxse8pWVkd5vVzmLCwnkv+Mke+OGYYD5EY0=
Date: Tue, 02 Jul 2024 10:25:57 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,jgg@nvidia.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch added to mm-unstable branch
Message-Id: <20240702172557.D2033C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/64e: drop E500 ifdefs in 64-bit code
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch

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
Subject: powerpc/64e: drop E500 ifdefs in 64-bit code
Date: Tue, 2 Jul 2024 15:51:15 +0200

All 64-bit Book3E have E500=y, so drop the unneeded ifdefs.

Link: https://lkml.kernel.org/r/7fb88809c88a1b774063eda602a9333079403f83.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/nohash/tlb_64e.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/powerpc/mm/nohash/tlb_64e.c~powerpc-64e-drop-e500-ifdefs-in-64-bit-code
+++ a/arch/powerpc/mm/nohash/tlb_64e.c
@@ -85,7 +85,6 @@ static void __init setup_page_sizes(void
 	unsigned int eptcfg;
 	int psize;
 
-#ifdef CONFIG_PPC_E500
 	unsigned int mmucfg = mfspr(SPRN_MMUCFG);
 	int fsl_mmu = mmu_has_feature(MMU_FTR_TYPE_FSL_E);
 
@@ -151,7 +150,6 @@ static void __init setup_page_sizes(void
 
 		goto out;
 	}
-#endif
 out:
 	/* Cleanup array and print summary */
 	pr_info("MMU: Supported page sizes\n");
@@ -180,13 +178,11 @@ static void __init setup_mmu_htw(void)
 	 */
 
 	switch (book3e_htw_mode) {
-#ifdef CONFIG_PPC_E500
 	case PPC_HTW_E6500:
 		extlb_level_exc = EX_TLB_SIZE;
 		patch_exception(0x1c0, exc_data_tlb_miss_e6500_book3e);
 		patch_exception(0x1e0, exc_instruction_tlb_miss_e6500_book3e);
 		break;
-#endif
 	}
 	pr_info("MMU: Book3E HW tablewalk %s\n",
 		book3e_htw_mode != PPC_HTW_NONE ? "enabled" : "not supported");
@@ -217,7 +213,6 @@ static void early_init_this_mmu(void)
 	}
 	mtspr(SPRN_MAS4, mas4);
 
-#ifdef CONFIG_PPC_E500
 	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		unsigned int num_cams;
 		bool map = true;
@@ -238,7 +233,6 @@ static void early_init_this_mmu(void)
 			linear_map_top = map_mem_in_cams(linear_map_top,
 							 num_cams, false, true);
 	}
-#endif
 
 	/* A sync won't hurt us after mucking around with
 	 * the MMU configuration
@@ -270,7 +264,6 @@ static void __init early_init_mmu_global
 	/* Look for HW tablewalk support */
 	setup_mmu_htw();
 
-#ifdef CONFIG_PPC_E500
 	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		if (book3e_htw_mode == PPC_HTW_NONE) {
 			extlb_level_exc = EX_TLB_SIZE;
@@ -279,7 +272,6 @@ static void __init early_init_mmu_global
 				exc_instruction_tlb_miss_bolted_book3e);
 		}
 	}
-#endif
 
 	/* Set the global containing the top of the linear mapping
 	 * for use by the TLB miss code
@@ -291,7 +283,6 @@ static void __init early_init_mmu_global
 
 static void __init early_mmu_set_memory_limit(void)
 {
-#ifdef CONFIG_PPC_E500
 	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		/*
 		 * Limit memory so we dont have linear faults.
@@ -302,7 +293,6 @@ static void __init early_mmu_set_memory_
 		 */
 		memblock_enforce_memory_limit(linear_map_top);
 	}
-#endif
 
 	memblock_set_current_limit(linear_map_top);
 }
@@ -340,7 +330,6 @@ void setup_initial_memory_limit(phys_add
 	 * We crop it to the size of the first MEMBLOCK to
 	 * avoid going over total available memory just in case...
 	 */
-#ifdef CONFIG_PPC_E500
 	if (early_mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		unsigned long linear_sz;
 		unsigned int num_cams;
@@ -353,7 +342,6 @@ void setup_initial_memory_limit(phys_add
 
 		ppc64_rma_size = min_t(u64, linear_sz, 0x40000000);
 	} else
-#endif
 		ppc64_rma_size = min_t(u64, first_memblock_size, 0x40000000);
 
 	/* Finally limit subsequent allocations */
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

powerpc-64e-remove-unused-ibm-htw-code.patch
powerpc-64e-split-out-nohash-book3e-64-bit-code.patch
powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch
powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch
powerpc-64e-consolidate-tlb-miss-handler-patching.patch
powerpc-64e-drop-unused-tlb-miss-handlers.patch

