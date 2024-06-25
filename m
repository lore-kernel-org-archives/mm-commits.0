Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E964596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291530; cv=none; b=lm2MvFYEfMfE9QVf79vRj41Lpd3qP4M8RaYn+kwue2ywyOrH6HW1Tt+Ei+J6gt5aX4Sc1HM+QqCXDp9pMYPy2GBWR3AKvH3bP5zlzRKvboAcPeTcNXyehsPSmy6vVLusscjlcGBSDyjMXLoAWRTPoRqSptrEDxLKA7XLkW2TaMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291530; c=relaxed/simple;
	bh=Ak8Rcwsumu7WqxwlEVnKmm3+Ax96BorrqcHknBm7LT8=;
	h=Date:To:From:Subject:Message-Id; b=XxFZO9W/3yKKc3VonX5EI6BkNdgsijyjET5rQFXIbQJHdTvnq/xmWEuZggzo3qtJ85SsT8W7HXk9uV8/3AtvYOxUxzPmT8GLAofuQPZpsMmC6OQAXQLWTtxaWfxudVPDXLj98P7uoVdZAT5V6edHNEUt6+ENsrQ32jawZh6lAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PGx9oUr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PGx9oUr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4401C32789;
	Tue, 25 Jun 2024 04:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291529;
	bh=Ak8Rcwsumu7WqxwlEVnKmm3+Ax96BorrqcHknBm7LT8=;
	h=Date:To:From:Subject:From;
	b=PGx9oUr7z2bWp9xtsaupU30lYBKw5toiG+Awqux/Dzrzsk9wRjdoDtzHl9cGqYvNs
	 UL6DGtAFf2tJbfbvpwdMGQcu+GSicRW3G7rXuUPg/w6jlVJs3JcptW3WU8nZEkgBsE
	 1bYu0hVgvH20iepMbScvqOOeLyTQlyPz/scF+iSg=
Date: Mon, 24 Jun 2024 21:58:49 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch removed from -mm tree
Message-Id: <20240625045849.B4401C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mempolicy: use folio_alloc_mpol_noprof() in vma_alloc_folio_noprof()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

