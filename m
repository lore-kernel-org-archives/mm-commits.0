Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77B84596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291528; cv=none; b=W0qXsTPCzfmuydCFIVmLHlJRkdK3xvhs6a3xzrjyY56VmrZ6FmNs55MP3EIJ23b7m9ysPHgC756bGb964ghwCXKaKLb7FI1775P6kxGzuDJ/AVbccZpMjp81fyl+JMc1ckepYUIThuyNKSBULsLx4pBEHmkfDdnBVArDszOJLGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291528; c=relaxed/simple;
	bh=ECheOoekTM5NdFs73aP2SQe8TS+nM2jg+tyDpGPVFWM=;
	h=Date:To:From:Subject:Message-Id; b=HMOygkda4SA0/0sc2tbVb+TxMrfcolJsCpR9+YhEOwUkmx5Y6rjPlOrX3sz/016IxHxozSzW1OuCDb7neY0e+1wsQVVC4AMz2he/4XXxNHYppE2FM8Bj3N8t9rLhsUv1blh9tqhpsO8r8Cue4nujC7N0zMmiFHKhrMId7LImORE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnhNdwHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnhNdwHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1462C32782;
	Tue, 25 Jun 2024 04:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291528;
	bh=ECheOoekTM5NdFs73aP2SQe8TS+nM2jg+tyDpGPVFWM=;
	h=Date:To:From:Subject:From;
	b=xnhNdwHGvV+gsZqSf6Fr7+r621IjO034EkQMSw+FdVlHFrbpc0WF9tszMS1pi8MU5
	 3FuSwX6UVHTJpoQ2syIo6GFnEe6l2MV1/beHkntIvMZfwkgcrHLelRbhZ13sNxKf1R
	 M1jNKhnR6mbw5g0qvhjW0AmFGp9XDRiDaNxQ3894=
Date: Mon, 24 Jun 2024 21:58:48 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_alloc_mpol.patch removed from -mm tree
Message-Id: <20240625045848.A1462C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_alloc_mpol()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_alloc_mpol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_alloc_mpol()
Date: Wed, 15 May 2024 15:07:06 +0800

Patch series "mm: convert to folio_alloc_mpol()".


This patch (of 4):

This adds a new folio_alloc_mpol() like folio_alloc() but allocate folio
according to NUMA mempolicy.

Link: https://lkml.kernel.org/r/20240515070709.78529-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240515070709.78529-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 ++++++++
 mm/mempolicy.c      |    7 +++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/gfp.h~mm-add-folio_alloc_mpol
+++ a/include/linux/gfp.h
@@ -303,6 +303,8 @@ struct page *alloc_pages_noprof(gfp_t gf
 struct page *alloc_pages_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr, bool hugepage);
 #else
@@ -319,6 +321,11 @@ static inline struct folio *folio_alloc_
 {
 	return __folio_alloc_node(gfp, order, numa_node_id());
 }
+static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *mpol, pgoff_t ilx, int nid)
+{
+	return folio_alloc_noprof(gfp, order);
+}
 #define vma_alloc_folio_noprof(gfp, order, vma, addr, hugepage)		\
 	folio_alloc_noprof(gfp, order)
 #endif
@@ -326,6 +333,7 @@ static inline struct folio *folio_alloc_
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
 #define alloc_pages_mpol(...)			alloc_hooks(alloc_pages_mpol_noprof(__VA_ARGS__))
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
+#define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
 
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
--- a/mm/mempolicy.c~mm-add-folio_alloc_mpol
+++ a/mm/mempolicy.c
@@ -2277,6 +2277,13 @@ struct page *alloc_pages_mpol_noprof(gfp
 	return page;
 }
 
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid)
+{
+	return page_rmappable_folio(alloc_pages_mpol_noprof(gfp | __GFP_COMP,
+							order, pol, ilx, nid));
+}
+
 /**
  * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
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

