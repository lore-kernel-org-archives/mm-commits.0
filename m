Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403067;
	b=DC4e1WPtfCQtF6yL3Kwx9GjBBgsOiTDx0XTZDg++i3JnLJcmFV8cDn2wB2pQK/FYsZkx
	 OCn0in0SxlIAgSxx6eqjhRx3bKcYpVDVGFW9ycHm7TUWBwVUBfxrApmGUubUhuih53qrC
	 X421D68zkKDHDiO4KVyeAhCsC2KdnZSlFCTboCHQtylXjafW1xWX3hjdEl6jrbfcwzEQ5
	 lXPqMBkrBX7GOOIKUswnQwCqJywFBrSO0LsheKbirGTVFK3ygyD80TV1zE6gxKziDdYFM
	 O0gietET4Agmx1QIHpRr051bnjNxkmTkTfCG5f90J/s5aB7ufpBAamj6q7fUPn4ZuDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403067;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=rYKmDz+gpBF8tWM/FbgD5PPRw5CNtZ3hGmiZceAQSAg=;
	b=fs50aS3KkVTDTuGCmZQrigzJTn2GvkoEVMvfi5N9zj+/i8dGujpUM80i2uC7T3zUuo7v
	 T6hGvZvG3r9PYT/bVsOF+dFpPHyJ98E+MEDaabGpaat+WLhVDL7COsgI0MkgJUmQzrwL/
	 JAqsZo3E+3iQsjXZbC7xIjamd3iXJPXavXu1g/CGhpoj1zEWqjkJk3yE0h9duXodkuvUa
	 iT7zdpHqvM7ybo7YHPz/H9mU2J2xRgZYfohydJqKi/0y5UxYowBo5a+IEyXgKvmLB2XPF
	 AvUu1EoXnjhD20soFtfGxEvXCCaCBXRufWlmL24kkn5++NP6Rlirdfy4uPN4lqWSHKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2YtO0rzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC60606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2YtO0rzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E551F000C4;
	Mon, 23 Nov 2026 03:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403067;
	bh=rYKmDz+gpBF8tWM/FbgD5PPRw5CNtZ3hGmiZceAQSAg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=2YtO0rzcxn4OriMnfPVcLHvqdRbU1ohOlXcVbLJirdrs0pMV96WZu3YvD+c1BznmR
	 wXxBQcU9oc728W9qRrM/lZ5Q6AcLqDHVNNxH9yZ/wsToNh01ytHuEFMSR7gLXvSxFt
	 B7CxVT/YrXqD/hmu8dqN7I3nClal+I7H8dZnnDOA=
Date: Sun, 22 Nov 2026 19:04:26 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-10-songmuchun@bytedance.com>
References: <20261120100856.16929-10-songmuchun@bytedance.com>
Subject: + mm-cma-centralize-cma-pageblock-initialization.patch added to mm-new branch
Message-Id: <20261123030426.D0E551F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/cma: centralize CMA pageblock initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-centralize-cma-pageblock-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-centralize-cma-pageblock-initialization.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma: centralize CMA pageblock initialization
Date: Fri, 20 Nov 2026 18:08:54 +0800

Early CMA reservations currently require callers to maintain CMA state.
This exposes internal bookkeeping requirements and splits responsibility
for the same area between CMA and its users.

Make CMA fully responsible for the state of early reservations. Pages
already handed to a caller remain owned by that caller if activation
fails, so keep their managed-page accounting intact regardless of whether
CMA retains the rest of the area.

Link: https://patch.msgid.link/20261120100856.16929-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/cma.c     |   32 +++++++++++++++++++-------------
 mm/hugetlb.c |    8 +++-----
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/mm/cma.c~mm-cma-centralize-cma-pageblock-initialization
+++ a/mm/cma.c
@@ -174,6 +174,10 @@ static void __init cma_activate_area(str
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+
+			for (pfn = cmr->base_pfn; pfn < early_pfn[r];
+			     pfn += pageblock_nr_pages)
+				init_cma_pageblock(pfn_to_page(pfn));
 		}
 
 		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
@@ -199,17 +203,20 @@ cleanup:
 	for (r = 0; r < allocrange; r++)
 		bitmap_free(cma->ranges[r].bitmap);
 
-	/* Expose all pages to the buddy, they are useless for CMA. */
-	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < cma->nranges; r++) {
-			unsigned long start_pfn;
-
-			cmr = &cma->ranges[r];
-			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
-			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = start_pfn; pfn < end_pfn; pfn++)
-				free_reserved_page(pfn_to_page(pfn));
-		}
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+		end_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+		/* Restore managed page accounting for early-reserved pages. */
+		for (pfn = cmr->base_pfn; pfn < end_pfn; pfn++)
+			adjust_managed_page_count(pfn_to_page(pfn), 1);
+
+		if (test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags))
+			continue;
+
+		/* Expose the remaining pages to the buddy. */
+		end_pfn = cmr->base_pfn + cmr->count;
+		for (; pfn < end_pfn; pfn++)
+			free_reserved_page(pfn_to_page(pfn));
 	}
 	totalcma_pages -= cma->count;
 	cma->available_count = cma->count = 0;
@@ -1020,8 +1027,7 @@ bool cma_intersects(struct cma *cma, uns
  *
  * The caller is responsible for initializing the page structures
  * in the area properly, since this just points to memblock-allocated
- * memory. The caller should subsequently use init_cma_pageblock to
- * set the migrate type and CMA stats  the pageblocks that were reserved.
+ * memory.
  *
  * If the CMA area fails to activate later, memory obtained through
  * this interface is not handed to the page allocator, this is
--- a/mm/hugetlb.c~mm-cma-centralize-cma-pageblock-initialization
+++ a/mm/hugetlb.c
@@ -3337,9 +3337,7 @@ static void __init hugetlb_bootmem_init_
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
 	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (folio_test_hugetlb_cma(folio))
-			init_cma_pageblock(folio_page(folio, i));
-		else
+		if (!folio_test_hugetlb_cma(folio))
 			init_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE, false);
 	}
@@ -3402,8 +3400,8 @@ static void __init gather_bootmem_preall
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
 		 *
-		 * For CMA pages, this is done in init_cma_pageblock
-		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
+		 * For CMA pages, this is done in cma_activate_area(), so skip
+		 * it here.
 		 */
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

