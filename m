Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BBF4596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291531; cv=none; b=M76C8jImN35NQOOlNeN2HIxaioWdxPrWEBh6EDccGT7c0GJxKVih8MVupifoqiS14Q1hf9g9mBmbui3BTIn1lJdfO1bVO+zBOg+36Mu6Dbf/vFltIUcr2Advoqgd7kMgOO6nl9k4ePo5rRk9OgW2Quk2N4qUZgn9Men8z/xh9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291531; c=relaxed/simple;
	bh=bumh/ah7u8eYPea+OPds0fKsOj1mvgHt4Qgt83wEfs8=;
	h=Date:To:From:Subject:Message-Id; b=ACZjPjSnSV4Snrahf7U+CW2vlS1uquKuPMVmKW3a6csXIUJ6JfVgjmlcj/4ovZqz1/sOAs6xaF9SdIfRY/3OCR2sSJGQvsOT4a8iCEjTFPMm7jmix5JqisQuUhDCE8Q2oi/XjQU6ed72kTlPVoNGP+0OvzJn4kjFjYUh9+qtRb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPDX5cY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPDX5cY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6657C32782;
	Tue, 25 Jun 2024 04:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291530;
	bh=bumh/ah7u8eYPea+OPds0fKsOj1mvgHt4Qgt83wEfs8=;
	h=Date:To:From:Subject:From;
	b=VPDX5cY+0ZnxWc4gUXoJMRUVAorc5A1oYuwLOHKgdoMGWBUFRBTIxgoQZh6qDpcMO
	 HFr2NoqTeSzNuMovUTFAGFZD6Uwt/MwugEhVrRxHDCQu0uzTP2zVasKj1Ng4NRxKfy
	 SLfjxiGgEduVY+X3ZaONHI55id9KOY1uGj+wIMOY=
Date: Mon, 24 Jun 2024 21:58:50 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch removed from -mm tree
Message-Id: <20240625045850.C6657C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mempolicy: use folio_alloc_mpol() in alloc_migration_target_by_mpol()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mempolicy: use folio_alloc_mpol() in alloc_migration_target_by_mpol()
Date: Wed, 15 May 2024 15:07:08 +0800

Convert to use folio_alloc_mpol() to make vma_alloc_folio_noprof() to use
folio throughout.

Link: https://lkml.kernel.org/r/20240515070709.78529-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol
+++ a/mm/mempolicy.c
@@ -1211,7 +1211,6 @@ static struct folio *alloc_migration_tar
 	struct migration_mpol *mmpol = (struct migration_mpol *)private;
 	struct mempolicy *pol = mmpol->pol;
 	pgoff_t ilx = mmpol->ilx;
-	struct page *page;
 	unsigned int order;
 	int nid = numa_node_id();
 	gfp_t gfp;
@@ -1235,8 +1234,7 @@ static struct folio *alloc_migration_tar
 	else
 		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
-	page = alloc_pages_mpol(gfp, order, pol, ilx, nid);
-	return page_rmappable_folio(page);
+	return folio_alloc_mpol(gfp, order, pol, ilx, nid);
 }
 #else
 
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

