Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8B1993AF
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864818; cv=none; b=qapkV1/lLxdZCwDTwSDNaI70tf0nVDnbJAQPIYcz2PbGhvetUp9aH+E4Tjk8eY5eGcDYtOsLbOdIwS+k3sRVqXqnvpRhCrC0fb97OoDHJrDVYA1QG6Et1GYe4Cm8rv75QXQVOgc4GSQvjopBxSzxQTDIC1+I9gHuBx9avBaFBB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864818; c=relaxed/simple;
	bh=qP/mYV0DT8SWk7cqMNuQQEI3/6y7NXqEr5bOxgqPT+Q=;
	h=Date:To:From:Subject:Message-Id; b=cIHJgiyR7O6GmYfEQDO95vuhzkQC7QTJUDJ4pUHlYlPtW2dGW7ix3yoRWORlFy1mBJjWiVP3JeFiillwsp5di7cb30KwX9HW0OYDA/E3m4AQ2KL21fM84JgUEFMIacGrNNTzIq5g94m9sye9YfjUYeTabBE4x3aJu2xbB3ZTBxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esCK7xn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esCK7xn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5407C4CEC0;
	Wed, 28 Aug 2024 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724864818;
	bh=qP/mYV0DT8SWk7cqMNuQQEI3/6y7NXqEr5bOxgqPT+Q=;
	h=Date:To:From:Subject:From;
	b=esCK7xn5qNaKp+Bf4ZUnRj++E++7+9UbHmHlhGCiUWZ4XPLk0nDcVSIPzvDBECU7p
	 TUXlOHGoYSJ3e07cZUwW8/yeqgM5QCxkWvPhFNxkCoHK5VUAZx2WGlNdT6MxPtHPV8
	 P0iDjCe6a18rBTc7QF97/Kbp3tjYp9fHjXUuuIwo=
Date: Wed, 28 Aug 2024 10:06:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch added to mm-unstable branch
Message-Id: <20240828170657.E5407C4CEC0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch

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

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

