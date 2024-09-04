Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA761E515
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421918; cv=none; b=Z/RBiAkx2VN7o32612xvTAVHREBA3KxnVCL+eUcWbtmjVroSO/tA+etlkvMfQb33w4paVMeFTi3zkyK0gxB1aruOkk16Oo+/0vG6taYRTWzjZevGF4XcFLdAql8Zy/wa4bItPjlXhI9erZUV3BD/X4pR3jvcWyCPJ/jF4G88KEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421918; c=relaxed/simple;
	bh=L/nuPUU/4C7D9v+WugQm16KmsLQgqwqcfpaidWR9DVs=;
	h=Date:To:From:Subject:Message-Id; b=YSNECgzWcYe+sidyzphiklBDnwGWjZU2Q71wFQmN6Abh10qUheIDR0KMAj/Y9fyzwCpoFh2iFA4Gm8Ka41MBU3cqFcEZT5IfgVeHD4ss7ps+XUt+sin/6CoKHvckoAeCBkO5ahb+FoQ+HHkkXLewAuDX0YZxIFrHzI0ZojwMLEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=REracVlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="REracVlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63CFC4CEC2;
	Wed,  4 Sep 2024 03:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421917;
	bh=L/nuPUU/4C7D9v+WugQm16KmsLQgqwqcfpaidWR9DVs=;
	h=Date:To:From:Subject:From;
	b=REracVlCNC8fic4xToQ6FsEY5ZyLwg4LW2vMuiUSianH5WSr78xryd216DWc1iJ7y
	 PXrD0+kxas8OKJSu1iCbgt3lHPQaUGFYS8BGygYfVSLJ/Kl1gIdceop3vDG1IAHr36
	 A/oEGqUnXUnFvxnr4MsdWWqSiBNpofgwPvSGwvUo=
Date: Tue, 03 Sep 2024 20:51:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch removed from -mm tree
Message-Id: <20240904035157.D63CFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch

This patch was dropped because it was folded into mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix
Date: Wed, 28 Aug 2024 18:17:18 +0800

fix build without CONFIG_TRANSPARENT_HUGEPAGE

ERROR:root:/usr/bin/ld: mm/shmem.o: in function `shmem_swapin_folio':
shmem.c:(.text+0x12d9): undefined reference to `vma_thp_gfp_mask'
collect2: error: ld returned 1 exit status

Link: https://lkml.kernel.org/r/8c03467c-63b2-43b4-9851-222d4188725c@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix
+++ a/mm/shmem.c
@@ -1899,11 +1899,13 @@ static int shmem_replace_folio(struct fo
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
 		gfp = limit_gfp_mask(huge_gfp, gfp);
 	}
+#endif
 
 	new = shmem_alloc_folio(gfp, folio_order(old), info, index);
 	if (!new)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch
mm-shmem-support-large-folio-swap-out.patch
mm-shmem-support-large-folio-swap-out-fix-2.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

