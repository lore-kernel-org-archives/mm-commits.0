Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCDDEC2
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716163921; cv=none; b=K+rOPaZbtNWL1kAdE8/BMlP1XIsf5Mz9T8L+h+O6MonhLNLGNJC3AP0ZXRC02xMRWJ3FVnoDt8FDbyMOgwkvN600C0aZEv+cEUCJygyZ9AQAoURCZS5cBlP639MK2J54axKhuNsX+XYJB8tLDEy+h+KCZZ65WMaey2ttQnSd40s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716163921; c=relaxed/simple;
	bh=B9yH3fQqHWNCn3ivMTtcDgMAaEsfzklqikryBJGeLTI=;
	h=Date:To:From:Subject:Message-Id; b=usmFFnpS5xcvGQUkDe2Go7qHbnPn3U/m+7fZNaiyYKmRG5d/FrpYdtBBpSb83VGverBo7EgoIsXcBP9uLIcUpR5QKRdTohyg05jvt9hqDavn+RfznOjScR8yWBJJQLKD6VSHkamFQocufbMmYCugpspibcWYKGiXns3jLHgrcP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0vGBXn0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0vGBXn0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CAEC32781;
	Mon, 20 May 2024 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716163921;
	bh=B9yH3fQqHWNCn3ivMTtcDgMAaEsfzklqikryBJGeLTI=;
	h=Date:To:From:Subject:From;
	b=0vGBXn0vw//xa1l1J2+eh0jcWL77vY0n2AL624o1BkPURApfi5dFlU8MManVsfMnr
	 X5Px8cZrM6OsCNeN3uRW2gnR2PTEHC1Izdj3vHGM/ZBcch7xAbrShBQvpUsr0w7DOL
	 GbnLsJSmToQwCEAh9RMM037aan2K/duwvWRyIqNY=
Date: Sun, 19 May 2024 17:12:00 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_alloc_mpol.patch added to mm-unstable branch
Message-Id: <20240520001201.34CAEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_alloc_mpol()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_alloc_mpol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_alloc_mpol.patch

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

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

