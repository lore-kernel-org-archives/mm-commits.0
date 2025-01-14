Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EA31C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836915; cv=none; b=OQz90CpJ9A8gcZusuRKmEq8Yr3DYAsZtd6vJBL9iIlcH0rSobuZiOuoN2nXv1YRWZ0ecpqL811KiIHEDDXs+WVASKqbWvIgJzCjLKtjd0hYpvnAdyQc3wbOR2uzU+xKRAOhIUKIX1ePsquSmoNmjRvNzMb7+lLQtzcAaXQvCw+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836915; c=relaxed/simple;
	bh=J9MVwiJ41dGAbMMNCoQ3DqQ8/uTtJaqw9FJTb7F1NV0=;
	h=Date:To:From:Subject:Message-Id; b=My2BOm6SWjYb4pqVKG1SVcbEQn6BVCQ1mv4KCWejPA3s4RzLsFOr9HcSXFh/yNMmd9tObkSR6eRODRJpJvO1se17gV4Ye/Ml5aziIYtvU4lTKa4BwE+a7ghdYNb7qQSwBdS+Cl8immhVamtajtsE6FHoDK9gprdn+LCTxvwIjfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WY49jECm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WY49jECm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E8AC4CEDD;
	Tue, 14 Jan 2025 06:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836914;
	bh=J9MVwiJ41dGAbMMNCoQ3DqQ8/uTtJaqw9FJTb7F1NV0=;
	h=Date:To:From:Subject:From;
	b=WY49jECmmscavgzPm8E0aqAkTiv697SRFUuP1jaSHuwApdN5rtv7WBJ34IbMYCsJ5
	 ofii7x+tUqZtiMt21ocwGFAfpAuY43Aknfkcoc66gj+tXXLhzDuQS8IK2+nLVYZ7Rj
	 gRkgVADXqAQ8jM9nnihtMxvp6t9a0UXUNBf5RFS4=
Date: Mon, 13 Jan 2025 22:41:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-alloc_pages_mpol-static.patch removed from -mm tree
Message-Id: <20250114064154.C3E8AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make alloc_pages_mpol() static
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_pages_mpol-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make alloc_pages_mpol() static
Date: Mon, 25 Nov 2024 21:01:34 +0000

All callers outside mempolicy.c now use folio_alloc_mpol() thanks to
Kefeng's cleanups, so we can remove this as a visible symbol.

And also remove the alloc_hooks for alloc_pages_mpol(), since all users
in mempolicy.c are using the nonprof version.

Link: https://lkml.kernel.org/r/20241125210149.2976098-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 --------
 mm/mempolicy.c      |    8 ++++----
 2 files changed, 4 insertions(+), 12 deletions(-)

--- a/include/linux/gfp.h~mm-make-alloc_pages_mpol-static
+++ a/include/linux/gfp.h
@@ -300,8 +300,6 @@ static inline struct page *alloc_pages_n
 
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
-struct page *alloc_pages_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
@@ -312,11 +310,6 @@ static inline struct page *alloc_pages_n
 {
 	return alloc_pages_node_noprof(numa_node_id(), gfp_mask, order);
 }
-static inline struct page *alloc_pages_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid)
-{
-	return alloc_pages_noprof(gfp, order);
-}
 static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
 	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
@@ -331,7 +324,6 @@ static inline struct folio *folio_alloc_
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
-#define alloc_pages_mpol(...)			alloc_hooks(alloc_pages_mpol_noprof(__VA_ARGS__))
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
 #define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
--- a/mm/mempolicy.c~mm-make-alloc_pages_mpol-static
+++ a/mm/mempolicy.c
@@ -2222,7 +2222,7 @@ static struct page *alloc_pages_preferre
  *
  * Return: The page on success or NULL if allocation fails.
  */
-struct page *alloc_pages_mpol_noprof(gfp_t gfp, unsigned int order,
+static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
 	nodemask_t *nodemask;
@@ -2285,7 +2285,7 @@ struct page *alloc_pages_mpol_noprof(gfp
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	return page_rmappable_folio(alloc_pages_mpol_noprof(gfp | __GFP_COMP,
+	return page_rmappable_folio(alloc_pages_mpol(gfp | __GFP_COMP,
 							order, pol, ilx, nid));
 }
 
@@ -2300,7 +2300,7 @@ struct folio *folio_alloc_mpol_noprof(gf
  * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
  * VMA to prevent it from going away.  Should be used for all allocations
  * for folios that will be mapped into user space, excepting hugetlbfs, and
- * excepting where direct use of alloc_pages_mpol() is more appropriate.
+ * excepting where direct use of folio_alloc_mpol() is more appropriate.
  *
  * Return: The folio on success or NULL if allocation fails.
  */
@@ -2346,7 +2346,7 @@ struct page *alloc_pages_noprof(gfp_t gf
 	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
 		pol = get_task_policy(current);
 
-	return alloc_pages_mpol_noprof(gfp, order, pol, NO_INTERLEAVE_INDEX,
+	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
 				       numa_node_id());
 }
 EXPORT_SYMBOL(alloc_pages_noprof);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

