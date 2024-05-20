Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BC3635
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716163923; cv=none; b=pXMvNYpgbPOiOuCl3MO3iMqlNCei40WiCj3hYB+mzBPaakczaEJgzCiJ+i8UQgMSn19SNcb7zYTjOXDFMnUNr1CfhI4hrbcK3Rp1Xos1WXJs4RZNy6yzA0oNnV79Mkcuy4kcZgVsvlUVd+tshCa0N5tOA6IT0oZ6RjdAcSP9l0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716163923; c=relaxed/simple;
	bh=FiZiWGpnaAA7f/wFsXjnFgaoAd6tPzlh62hsHuWL60k=;
	h=Date:To:From:Subject:Message-Id; b=FSHhZR2U+qm92tehNTO8XRzBOS9N3HVxFV/9/5qdLC/UxHBrS2jJ61RNF8Vpjr6uDhDcmcagpI3wArL85MFBTuXUsCWKv3FfGWgzs4EOI72UjlgGcFszCIyuIAvRMyM1LMC9G+p0r/xZtl0SRthv9cnN/UCVIFiFP8bJvuwhFLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=by8lVOtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="by8lVOtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C08C32781;
	Mon, 20 May 2024 00:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716163923;
	bh=FiZiWGpnaAA7f/wFsXjnFgaoAd6tPzlh62hsHuWL60k=;
	h=Date:To:From:Subject:From;
	b=by8lVOtgzu4pWhw2JlWiR8kFdvTOTIj9p7VSMwYXNkL7EfMYJvLn670OBLHatm74k
	 Q56veDqb4IxxdV32nsN7XI1nBYFv+LIVQIV2Y2QcGKWkBVUSwoYGtMpSSh8WJRRbhR
	 BSreVe0JOmyCsMREqORzLXYo9uvfto9SVWe3TxuA=
Date: Sun, 19 May 2024 17:12:02 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch added to mm-unstable branch
Message-Id: <20240520001203.50C08C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mempolicy: use folio_alloc_mpol_noprof() in vma_alloc_folio_noprof()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mempolicy: use folio_alloc_mpol_noprof() in vma_alloc_folio_noprof()
Date: Wed, 15 May 2024 15:07:07 +0800

Convert to use folio_alloc_mpol_noprof() to make vma_alloc_folio_noprof()
to use folio throughout.

Link: https://lkml.kernel.org/r/20240515070709.78529-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof
+++ a/mm/mempolicy.c
@@ -2305,13 +2305,12 @@ struct folio *vma_alloc_folio_noprof(gfp
 {
 	struct mempolicy *pol;
 	pgoff_t ilx;
-	struct page *page;
+	struct folio *folio;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	page = alloc_pages_mpol_noprof(gfp | __GFP_COMP, order,
-				       pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
 	mpol_cond_put(pol);
-	return page_rmappable_folio(page);
+	return folio;
 }
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

