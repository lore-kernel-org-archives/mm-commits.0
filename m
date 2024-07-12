Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C027D3E8
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824864; cv=none; b=DcyQ2AmyUynmm7zs/9YNE3Gn4ug5nEwqtrjrEc9pZPh2OhqLvpy8KvbnK5Ve8xqIg7rANYislgKp93NrRh9btioOG81ClFbV7TwvXw7RdECNAnLdkAYqNLjeTVNHQawDlRQcE1vfehSsHAcnkxFCC0Ch8MgkubAMg+4b4UjEIA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824864; c=relaxed/simple;
	bh=/HdvrEqVbrWpoJPhCnPfBf2CrmZ/nfQQItDHtKuDK0I=;
	h=Date:To:From:Subject:Message-Id; b=kXUFiuaMT1pc7LRGvQTVlyYP3qKkmb374ge3Qc+IKujOJXJqCwJvCrS7s1O1xIAkreBjdpZUdR1URWBlLEQVJHzB9OvBornuNMjHj+x3IZashQbOmx5L0Ko97mKJEYSM/+tpuyhUwc7j6B7vD/Ca3nGLlyj39+uauZa9eiJIPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdtbIIS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdtbIIS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9546CC32782;
	Fri, 12 Jul 2024 22:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824864;
	bh=/HdvrEqVbrWpoJPhCnPfBf2CrmZ/nfQQItDHtKuDK0I=;
	h=Date:To:From:Subject:From;
	b=sdtbIIS+t+66bJZB8Jw7G6ce93LEo6+TWIxkGPOKa/ifdtT/Aw+J9gubKu3bJP1Yo
	 2AU3S9p0uOU2m1Ac7501UvLJEtr9e1qZt1yGk85kYt2Prp2BIqdpLPkYStqWbdKNax
	 HCbSQ32jQ9CGpGteN+bQfMaePZ7436EOM63M6uUY=
Date: Fri, 12 Jul 2024 15:54:24 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,jgg@nvidia.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-64e-consolidate-tlb-miss-handler-patching.patch removed from -mm tree
Message-Id: <20240712225424.9546CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/64e: consolidate TLB miss handler patching
has been removed from the -mm tree.  Its filename was
     powerpc-64e-consolidate-tlb-miss-handler-patching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


