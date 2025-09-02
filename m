Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D52EA46E
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857174; cv=none; b=kjKsrCxXmIEN8npTgm9Gy89RZM0lNJHgNoJgdfTz22a5Gj3dYk/1w76JC2MqLr6x6QCkWTXKm/qMUuLC1G0caM9cNC+Vf6X04RmKZEj3xBNqKvR1j890/ZbI3mDcNgXx6sLTrmi442nuMDpfR/uVzcnzsQ+I/Jr5TLa9/VsZWbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857174; c=relaxed/simple;
	bh=3etqveoSxvXdbqTv/KN84qX+ddV5g5oIoXNRYsGYcpc=;
	h=Date:To:From:Subject:Message-Id; b=cwYhes4oi2RFF/gfp/ZvdEiNEgWeMb2NIQGy2SoE0Sx1WhSjgdENZQ8v4KRDJB6sRvu5T4Yi1R+7Qe21vdpKolSO3MOMN04/qyrM2qdoTTIBCC+IEeUqrjZ4Y3RANr0N4pd/27vZmUxHjGNYPFzVOmKuXTYGyxSUSKB/pH7P7as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rR7Aj5vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rR7Aj5vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDAEC4CEF4;
	Tue,  2 Sep 2025 23:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857172;
	bh=3etqveoSxvXdbqTv/KN84qX+ddV5g5oIoXNRYsGYcpc=;
	h=Date:To:From:Subject:From;
	b=rR7Aj5vdHDUih6OPjLdVL26J60uQtMGLUtnNciT3qIuvR0BVILZp8wigrAmaZpPUF
	 puRlTSCHjsBMMkAWIMmueOn3aJMpTL6zehj/nnfo6ykEplybrT4SpN7pPqsE6CbQ/F
	 jWnuBiAogu7pFGz8wv8NpvGfFA8ceVj6zvcgA+OQ=
Date: Tue, 02 Sep 2025 16:52:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch added to mm-new branch
Message-Id: <20250902235252.9BDAEC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: directly pass order when allocate a hugetlb folio
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: hugetlb: directly pass order when allocate a hugetlb folio
Date: Tue, 2 Sep 2025 20:48:14 +0800

Use order instead of struct hstate to remove huge_page_order() call from
all hugetlb folio allocation.

Link: https://lkml.kernel.org/r/20250902124820.3081488-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |   27 +++++++++++++--------------
 mm/hugetlb_cma.c |    3 +--
 mm/hugetlb_cma.h |    6 +++---
 3 files changed, 17 insertions(+), 19 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(stru
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	int order = huge_page_order(h);
 	bool retried = false;
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
+	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
@@ -1506,16 +1505,16 @@ retry:
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
@@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapp
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
-	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
 
@@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hu
 		nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
+	int order = huge_page_order(h);
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
+	if (order > MAX_PAGE_ORDER)
+		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
+		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
+						  node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(h, folio);
 	return folio;
--- a/mm/hugetlb_cma.c~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb_cma.c
@@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio
 }
 
 
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	int order = huge_page_order(h);
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
--- a/mm/hugetlb_cma.h~mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio
+++ a/mm/hugetlb_cma.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_foli
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
-	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

