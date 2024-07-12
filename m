Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0221CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824873; cv=none; b=buloHp3mc5d2qIlbIexg/0ZXWvNoZRi6MQ54+/9JabN9BB6ZPEXp88Ff2SN9BI/qB3/2cb8uR3MZIgQMOstR6kgAhJHJIRA8zc+UZu8sIkqZcqr+Zl2WfwtVOHTc5RSxHm2QHlZPhZNa+r/+cD1WSYOvwo2O3ghWuijZFICk7Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824873; c=relaxed/simple;
	bh=8N2w7602V2U2QOfaubJ9tDopi0qt9qV2xS72QeH2Udo=;
	h=Date:To:From:Subject:Message-Id; b=UNA5r3T/cSm9PLSMhF9+weqiDtpB+TgIJPkDZ8PLl7QGnY13LiD4/F8mfck6SRnZLW88j15k0ugbWs80FfYyK109jPaE+Ny6DlDAngjyjwyzXYgWVyefs8To3mjfw0UJiyKzqs5g6JbzcbpkrVnBiNPs8ID1ws6/vthHO/XfY0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CE6ioy9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CE6ioy9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF836C32782;
	Fri, 12 Jul 2024 22:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824872;
	bh=8N2w7602V2U2QOfaubJ9tDopi0qt9qV2xS72QeH2Udo=;
	h=Date:To:From:Subject:From;
	b=CE6ioy9WkljQfC+hXvsAIKFFwH9+XHAhStUhtV1h9AjISMtMKhr5cdUjOmgpKxESW
	 sxGXoFvblCDMGsSlBS+YcZRatC1QouopGFW7USELj1YMO5Z+SXt1nPBcjc+vxoqVe7
	 mvbgLb8f+Qz792+zLKlG4RigAMuhDCDm/Wlylh1I=
Date: Fri, 12 Jul 2024 15:54:32 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch removed from -mm tree
Message-Id: <20240712225432.BF836C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/8xx: fix size given to set_huge_pte_at()
has been removed from the -mm tree.  Its filename was
     powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/8xx: fix size given to set_huge_pte_at()
Date: Tue, 2 Jul 2024 15:51:24 +0200

set_huge_pte_at() expects the size of the hugepage as an int, not the
psize which is the index of the page definition in table mmu_psize_defs[]

Link: https://lkml.kernel.org/r/97f2090011e25d99b6b0aae73e22e1b921c5d1fb.1719928057.git.christophe.leroy@csgroup.eu
Fixes: 935d4f0c6dc8 ("mm: hugetlb: add huge page size param to set_huge_pte_at()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/nohash/8xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/nohash/8xx.c~powerpc-8xx-fix-size-given-to-set_huge_pte_at
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -94,7 +94,8 @@ static int __ref __early_map_kernel_huge
 		return -EINVAL;
 
 	set_huge_pte_at(&init_mm, va, ptep,
-			pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)), psize);
+			pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)),
+			1UL << mmu_psize_to_shift(psize));
 
 	return 0;
 }
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


