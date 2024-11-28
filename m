Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39557847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755869; cv=none; b=Y2exz/lgr+O8JgrkRCrxp94+LKE7lOC7elpHprx610Sr5p4Jg1IK8W+Z6pls8md4jUCRBzaJOZLz0y4Vq8LYMWXYYt3xcjrvwKqjd0pyfuX4UpAmJCAuUvWxguWqzxw619tIPcb/OtL4RkaPgaHEKmEPR9BHBk66BNL7vMFBmYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755869; c=relaxed/simple;
	bh=yPZ/ICZvbAx2cbNA1h+ZsKhqR3GWlJzgvyE+oH6soa0=;
	h=Date:To:From:Subject:Message-Id; b=dqE6Lbr8sO5LZlRiAKaVhtxbo6/is7JpjS+Ib7EOpiwzBqxSNulpnl1Ct4ZXnVUJpxETnIjVZsg0pHLs9mepwUbUChLfQKreBWgFJnFVobLv+lTXGVv5gOiPE2nCgXxd7ym/cuSTf89p3J/gAsHM32WMztUBPq65Y+6+uNL5JL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TNLB59vG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TNLB59vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7CFC4CECC;
	Thu, 28 Nov 2024 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755866;
	bh=yPZ/ICZvbAx2cbNA1h+ZsKhqR3GWlJzgvyE+oH6soa0=;
	h=Date:To:From:Subject:From;
	b=TNLB59vGoclR1kqk/Kzmyb5S6E1R0Fkz3XBSuiC6rJd1IeIYA8dUSNftRdJ86MzlW
	 IIsBUFHJnKTdCdDIzyaRkbtol5UF2SBgqeI061u9Bf/lzgngZ+nV4YZR1JkVvYuJ6f
	 sUE16LR15j0OTlwuAqoCf0l+xklzfITtc3ctN+2I=
Date: Wed, 27 Nov 2024 17:04:26 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-alloc_pages_mpol-static.patch added to mm-unstable branch
Message-Id: <20241128010426.9B7CFC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make alloc_pages_mpol() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-alloc_pages_mpol-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-alloc_pages_mpol-static.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make alloc_pages_mpol() static
Date: Mon, 25 Nov 2024 21:01:34 +0000

All callers outside mempolicy.c now use folio_alloc_mpol() thanks to
Kefeng's cleanups, so we can remove this as a visible symbol.

Link: https://lkml.kernel.org/r/20241125210149.2976098-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -2284,7 +2284,7 @@ struct page *alloc_pages_mpol_noprof(gfp
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	return page_rmappable_folio(alloc_pages_mpol_noprof(gfp | __GFP_COMP,
+	return page_rmappable_folio(alloc_pages_mpol(gfp | __GFP_COMP,
 							order, pol, ilx, nid));
 }
 
@@ -2299,7 +2299,7 @@ struct folio *folio_alloc_mpol_noprof(gf
  * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
  * VMA to prevent it from going away.  Should be used for all allocations
  * for folios that will be mapped into user space, excepting hugetlbfs, and
- * excepting where direct use of alloc_pages_mpol() is more appropriate.
+ * excepting where direct use of folio_alloc_mpol() is more appropriate.
  *
  * Return: The folio on success or NULL if allocation fails.
  */
@@ -2345,7 +2345,7 @@ struct page *alloc_pages_noprof(gfp_t gf
 	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
 		pol = get_task_policy(current);
 
-	return alloc_pages_mpol_noprof(gfp, order, pol, NO_INTERLEAVE_INDEX,
+	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
 				       numa_node_id());
 }
 EXPORT_SYMBOL(alloc_pages_noprof);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch

