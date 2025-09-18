Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92F13B2A4
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758231588; cv=none; b=Xk4+jesV3zs6Ry0lD2pAagGlKzGLHf76QwAmA4mW6jCsYZk5+DloYa396Wx0yS04DanAxQddkoAF+gDV1BUi+Jvriws6CrqlaFY1/8PlzBzVwSFMMz3UOSSW9psVMF8jY0Rp3HmbMaC1r4gKG27bZzMW7bgTIpz5S5ZHm0Ahuow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758231588; c=relaxed/simple;
	bh=lD2dnTk8oDMfAwgDNQECk/D+BVPybiPgPVjLJNHFvBU=;
	h=Date:To:From:Subject:Message-Id; b=LFwPQHBqkehvYP/vZ1JO+A0Ceif2GRQxYfzE+X21CRimsatm3adVstvYV8QYIERCpr4VHsJe9Yy9qnuLdp7Eh4PzLoG4KqTbQdo7MjAayEbH0BYqViiIKeltmq9YCfGkyAm/Uirt989uRwCckIXidHFpaUToAXauUVxz2bN7HIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dO4kyvJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dO4kyvJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BBDC4CEE7;
	Thu, 18 Sep 2025 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758231588;
	bh=lD2dnTk8oDMfAwgDNQECk/D+BVPybiPgPVjLJNHFvBU=;
	h=Date:To:From:Subject:From;
	b=dO4kyvJo4TZbwu73He091oyd8lC33RnfrU2nH1pKXHdUBbrry3iRsF2gqryN4PtXy
	 +tZHFoQ3YmuCwaqcrORoQBTjmAcYnaeNBAr/h7PpEv/T2D0g6LtTHLct02uT2eexap
	 NoT1DNWm95BCEYItgajTu60x7gE9kh1Ba0rj8l/I=
Date: Thu, 18 Sep 2025 14:39:47 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,jgg@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch added to mm-unstable branch
Message-Id: <20250918213948.21BBDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
Date: Thu Sep 18 02:38:36 PM PDT 2025

restore inadvertently-removed newline

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
+++ a/mm/memory.c
@@ -2955,6 +2955,7 @@ static int remap_pfn_range_notrack(struc
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
+
 	if (!error)
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch

