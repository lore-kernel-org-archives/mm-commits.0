Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA615218A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941196; cv=none; b=M0ZllFiHwY1nKvAScqvUNSQm/NiKkUCm5Bb8WosjOKUUOCfwurCFs01Bgz6tAl9+eq6V2OxSNHYofD2NprDROuI0dIaYgN0NSGYpmRuDAJyzvSS6qelGpt+lk3wHEjJVKORIEZo2tlCZA1igQAuMMZYw+SxsAHwqETwZPgD6bpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941196; c=relaxed/simple;
	bh=o0VnVNVTnEXZnDwOwv3BYFDNyHN60ERjhl8kyK8/DHg=;
	h=Date:To:From:Subject:Message-Id; b=TY5NX+6PofDvbOyVt//SmmWfgD0yPwZkqoIgAObYExZdE2wAAbi0JGRsX8quhONxbWU68yL/cfROqj4jhlfN7altjnQl1e5AQpdAQmRthOTP7Ws0Hp3CU6O5JRV+RTKjG0g3MyNfurD4UrXuxUOnXP3zqNSiNead0LB1iZks5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s3I7yGg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s3I7yGg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2E8C116B1;
	Tue,  2 Jul 2024 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941196;
	bh=o0VnVNVTnEXZnDwOwv3BYFDNyHN60ERjhl8kyK8/DHg=;
	h=Date:To:From:Subject:From;
	b=s3I7yGg8aBU6uuPb6qUNhHtdpmUsr3pYNfqsefp7LwrlsJ5wyYu2czXB+jAPOFTHD
	 b/T9AGUWm0eBK13H5z+sBblJ2JOH0gYQt7sl5rpSRVchcFO0Q0nVs/yPdm7eGRL8w0
	 YoTypuuVsbmiFECX2Y/b2NUyEm3sj4mwVRRkrl0s=
Date: Tue, 02 Jul 2024 10:26:36 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch added to mm-unstable branch
Message-Id: <20240702172636.8A2E8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/8xx: fix size given to set_huge_pte_at()
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch

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

