Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE11BD4E9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941162; cv=none; b=C+71IxsUoUr0uYZhAKMvTPZvx0/PHUEpMZMs0gpLJfNvxsHXCtCAtr0lcE7mTyK9UvpWhVg4rTNkis7dY8I3SYSGXJKdYbf7u0Obuolq/p+DGKlwAJFtfTKlu26DQBIhYuWg2UXZ7BOKPKbWVXBeaGFjSCcM8nPXhCbU1ASsdN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941162; c=relaxed/simple;
	bh=YKYtWE1uYLjZo/sW2jYwW6OzPVulWQ0q8DXp9Aiq47I=;
	h=Date:To:From:Subject:Message-Id; b=oKQPbMEvmfS8SYWFk1LQGJ3pRq4xCKgKt/MNDK906UfsxK1RLzoLiIoa5SGJxac9DJYbhs6Qe3rziA9jKyTtP5x4Hq27HLcSb1muwF6T8B6Q2XSwNp/IBrIknQUTL8AhIQ9Num+FpSIpbTt1mdCW0IbR2HS/fl0YdFRGjFS9vuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hv4zGSBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hv4zGSBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122A2C116B1;
	Tue,  2 Jul 2024 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941162;
	bh=YKYtWE1uYLjZo/sW2jYwW6OzPVulWQ0q8DXp9Aiq47I=;
	h=Date:To:From:Subject:From;
	b=Hv4zGSByCdPNb/3FTo8kRmPZcFdNgmIpckXSewpbHJvUeYEp169bRlT2SIcm9SzTy
	 KTD7aJbYgcgqDSSwuh2ytmumjna26cYONeCl9GR+rX8q5lwZZDFTFpG1YnSe5fUz9U
	 Z9/gwrCdJkkBfAfgDLqNfps9uw0cBHblqaq+/Z0E=
Date: Tue, 02 Jul 2024 10:26:01 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,jgg@nvidia.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-64e-consolidate-tlb-miss-handler-patching.patch added to mm-unstable branch
Message-Id: <20240702172602.122A2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/64e: consolidate TLB miss handler patching
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-64e-consolidate-tlb-miss-handler-patching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-64e-consolidate-tlb-miss-handler-patching.patch

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
Subject: powerpc/64e: consolidate TLB miss handler patching
Date: Tue, 2 Jul 2024 15:51:17 +0200

The 64e TLB miss handler patching is done in setup_mmu_htw(), and then
again immediately afterward in early_init_mmu_global().  Consolidate it
into a single location.

Link: https://lkml.kernel.org/r/7033b37493fb48a3e5245b59d0a42afb75dabfc1.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/nohash/tlb_64e.c |   38 +++++++++++------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/arch/powerpc/mm/nohash/tlb_64e.c~powerpc-64e-consolidate-tlb-miss-handler-patching
+++ a/arch/powerpc/mm/nohash/tlb_64e.c
@@ -169,24 +169,6 @@ out:
 	}
 }
 
-static void __init setup_mmu_htw(void)
-{
-	/*
-	 * If we want to use HW tablewalk, enable it by patching the TLB miss
-	 * handlers to branch to the one dedicated to it.
-	 */
-
-	switch (book3e_htw_mode) {
-	case PPC_HTW_E6500:
-		extlb_level_exc = EX_TLB_SIZE;
-		patch_exception(0x1c0, exc_data_tlb_miss_e6500_book3e);
-		patch_exception(0x1e0, exc_instruction_tlb_miss_e6500_book3e);
-		break;
-	}
-	pr_info("MMU: Book3E HW tablewalk %s\n",
-		book3e_htw_mode != PPC_HTW_NONE ? "enabled" : "not supported");
-}
-
 /*
  * Early initialization of the MMU TLB code
  */
@@ -252,15 +234,25 @@ static void __init early_init_mmu_global
 	/* Look for supported page sizes */
 	setup_page_sizes();
 
-	/* Look for HW tablewalk support */
-	setup_mmu_htw();
-
-	if (book3e_htw_mode == PPC_HTW_NONE) {
-		extlb_level_exc = EX_TLB_SIZE;
+	/*
+	 * If we want to use HW tablewalk, enable it by patching the TLB miss
+	 * handlers to branch to the one dedicated to it.
+	 */
+	extlb_level_exc = EX_TLB_SIZE;
+	switch (book3e_htw_mode) {
+	case PPC_HTW_E6500:
+		patch_exception(0x1c0, exc_data_tlb_miss_e6500_book3e);
+		patch_exception(0x1e0, exc_instruction_tlb_miss_e6500_book3e);
+		break;
+	case PPC_HTW_NONE:
 		patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
 		patch_exception(0x1e0, exc_instruction_tlb_miss_bolted_book3e);
+		break;
 	}
 
+	pr_info("MMU: Book3E HW tablewalk %s\n",
+		book3e_htw_mode != PPC_HTW_NONE ? "enabled" : "not supported");
+
 	/* Set the global containing the top of the linear mapping
 	 * for use by the TLB miss code
 	 */
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

powerpc-64e-remove-unused-ibm-htw-code.patch
powerpc-64e-split-out-nohash-book3e-64-bit-code.patch
powerpc-64e-drop-e500-ifdefs-in-64-bit-code.patch
powerpc-64e-drop-mmu_ftr_type_fsl_e-checks-in-64-bit-code.patch
powerpc-64e-consolidate-tlb-miss-handler-patching.patch
powerpc-64e-drop-unused-tlb-miss-handlers.patch

