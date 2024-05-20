Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199EEC2
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716163927; cv=none; b=B26+ewqSKEBAthsxQu87jGmhB5hbTB9WU19eBRtA7WfAzy4Gqf053mugmlMjmeiFyUqgf+G7rdrGyGtIwllqxrqsKWUBSUu99joCGiwJNSR2W0itc8uc+5bYgRtqnjiKqabO5mTWdbP9TpMlK8Uj8aHfhODP6+UcZBh7qcAj4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716163927; c=relaxed/simple;
	bh=O1nU0mxQ7BedkfKafoqih7mrDQgfhcQj/Limdj+m0bI=;
	h=Date:To:From:Subject:Message-Id; b=TZwiPH/AyGhrnRVi7nfJrJZruhBI14jSni8qDIQtGkCg6+T8AlIdIdR//iQvvrT5dXwiwl3Y+RmcY9vd95fXRcEGEix2tg/dezYlHEFhjV6c3gEUfj0jCqqhrRUWCynlSLL9tZjDE9g7amf0RlSCJ+j0l9JYV3ctPnCR8Nk5Y3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUAwcD1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUAwcD1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B608AC32781;
	Mon, 20 May 2024 00:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716163926;
	bh=O1nU0mxQ7BedkfKafoqih7mrDQgfhcQj/Limdj+m0bI=;
	h=Date:To:From:Subject:From;
	b=dUAwcD1ad0ynHaQDmdVjKSuJR02EgW2PWpSYLn1k9rgKqs6DtxeA54zs8lpSPj0QC
	 j9t07qil92pgldUy9oCnNRr/OgZTZkB1YXYqg36r2mKZfpec7KUxAhyLK4gUnLQGWE
	 U4CVbzDp9Um/6Dmvm/embQn/sJO5PcKCWliYoRbM=
Date: Sun, 19 May 2024 17:12:06 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch added to mm-unstable branch
Message-Id: <20240520001206.B608AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: use folio_alloc_mpol() in shmem_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

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

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

