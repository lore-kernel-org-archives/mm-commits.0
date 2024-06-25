Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F42E4596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291532; cv=none; b=QfXDgovcbX10HxXOl4gNxhjOcxXGNMIgY1ZflUsajNUxcLlErQcBfEtv33yqb/j/RC6TddihNA+lVdNTqiPa96CC5h7/av0nAH0sfZAmZ8WTO9T/MwhGsUJzqhBtzDGw9BEflkAKfMHNW8B2vjEY+P3YC6+BJjFaj4yX0Tq7kWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291532; c=relaxed/simple;
	bh=FGMX3Lp6Ql4TRSMbJL0bRELDaXZMmpiJtHKT8IgYiRk=;
	h=Date:To:From:Subject:Message-Id; b=pZ9sp/HQHmObclAwm3uJGKAm2l6HLroTrepmk1T+Pncq3blIYltHHUCCDj35WDewLbaFpFIIdmeXADYl5dGffspmKvHnzv5I1tAZ6woUXgsqx3eUQLdjlY1oZ4q6kI1Xt2c1qszNj5qFzHu+MJJoK+ufvI0lH85w606ZpX7kMYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMFqTDi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMFqTDi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BBFC4AF07;
	Tue, 25 Jun 2024 04:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291531;
	bh=FGMX3Lp6Ql4TRSMbJL0bRELDaXZMmpiJtHKT8IgYiRk=;
	h=Date:To:From:Subject:From;
	b=uMFqTDi1d06yH87qMiphtPksy4OWtGI09TxSaAK/SyAutJTMn8RwxgbfawvjG0ojS
	 gY6AYz2KMM4pcOKW1xXxwnPZ2zlBEqKxEfGPxieaabVYxOQa//BORd9MmKrTJiZhP8
	 4T8bfiJHrvmfg2DsQd/qpe2Wx9haY9/Xecb98Cco=
Date: Mon, 24 Jun 2024 21:58:51 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch removed from -mm tree
Message-Id: <20240625045851.D7BBFC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: use folio_alloc_mpol() in shmem_alloc_folio()
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: shmem: use folio_alloc_mpol() in shmem_alloc_folio()
Date: Wed, 15 May 2024 15:07:09 +0800

Let's change shmem_alloc_folio() to take a order and use
folio_alloc_mpol() helper, then directly use it for normal or large folio
to cleanup code.

Link: https://lkml.kernel.org/r/20240515070709.78529-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio
+++ a/mm/shmem.c
@@ -1603,32 +1603,18 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 	return result;
 }
 
-static struct folio *shmem_alloc_hugefolio(gfp_t gfp,
+static struct folio *shmem_alloc_folio(gfp_t gfp, int order,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct mempolicy *mpol;
 	pgoff_t ilx;
-	struct page *page;
-
-	mpol = shmem_get_pgoff_policy(info, index, HPAGE_PMD_ORDER, &ilx);
-	page = alloc_pages_mpol(gfp, HPAGE_PMD_ORDER, mpol, ilx, numa_node_id());
-	mpol_cond_put(mpol);
-
-	return page_rmappable_folio(page);
-}
-
-static struct folio *shmem_alloc_folio(gfp_t gfp,
-		struct shmem_inode_info *info, pgoff_t index)
-{
-	struct mempolicy *mpol;
-	pgoff_t ilx;
-	struct page *page;
+	struct folio *folio;
 
-	mpol = shmem_get_pgoff_policy(info, index, 0, &ilx);
-	page = alloc_pages_mpol(gfp, 0, mpol, ilx, numa_node_id());
+	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
+	folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
 	mpol_cond_put(mpol);
 
-	return (struct folio *)page;
+	return folio;
 }
 
 static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
@@ -1660,12 +1646,12 @@ static struct folio *shmem_alloc_and_add
 				index + HPAGE_PMD_NR - 1, XA_PRESENT))
 			return ERR_PTR(-E2BIG);
 
-		folio = shmem_alloc_hugefolio(gfp, info, index);
+		folio = shmem_alloc_folio(gfp, HPAGE_PMD_ORDER, info, index);
 		if (!folio)
 			count_vm_event(THP_FILE_FALLBACK);
 	} else {
 		pages = 1;
-		folio = shmem_alloc_folio(gfp, info, index);
+		folio = shmem_alloc_folio(gfp, 0, info, index);
 	}
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
@@ -1765,7 +1751,7 @@ static int shmem_replace_folio(struct fo
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
 	VM_BUG_ON_FOLIO(folio_test_large(old), old);
-	new = shmem_alloc_folio(gfp, info, index);
+	new = shmem_alloc_folio(gfp, 0, info, index);
 	if (!new)
 		return -ENOMEM;
 
@@ -2633,7 +2619,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 
 	if (!*foliop) {
 		ret = -ENOMEM;
-		folio = shmem_alloc_folio(gfp, info, pgoff);
+		folio = shmem_alloc_folio(gfp, 0, info, pgoff);
 		if (!folio)
 			goto out_unacct_blocks;
 
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

