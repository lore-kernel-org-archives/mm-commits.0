Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377C817597
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755893; cv=none; b=ql+FhxcSfcgEF9kWk8fdG5CmbYJesuaKQ2VXc6vlNM/evyWFRfJ0dCQ4lav2q/mCmwJQ9BtdfzkK6MUqAKTmsDYTU4tRrWoVde8v4lz5shdAIxlNVY2Ivg6bLDW5f2SmkpkehJNVUGBBHn2oWSF4Ldvioc9oWj7JL2rFI2s+BnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755893; c=relaxed/simple;
	bh=y/zG1UtimQA5EGcHc9JnDanMM6a7/l0whzDiAL6HiR8=;
	h=Date:To:From:Subject:Message-Id; b=KJ/DOM7UmfjRit+wuNQrW5I0ZfwlsJTaZHay9xLMWBF06zaXW+slm6CprQ5f9Trfq9g+0t5Ew+nYkPwS+YuMI4V3AkFNaWQHZ3i4evGOexkvhRNtgTLC5RkmwBTFGQ9utMULtBOnrKSgTVGJrY2scd8kBbhdnvC73x2TCFoZykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CNOIKHcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CNOIKHcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099FAC4CECC;
	Thu, 28 Nov 2024 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755893;
	bh=y/zG1UtimQA5EGcHc9JnDanMM6a7/l0whzDiAL6HiR8=;
	h=Date:To:From:Subject:From;
	b=CNOIKHcAWmOxO1XSzfsgaLe2IRkgA3CvXSlsrb1tsycPS3yULoy9QbZ823ejIfmoU
	 1yj8AhgQolmyi1bHMLOSxNXoRVTiD69OmHnzAts4Ju5GYLr+01iNGAYKT+s6Kl7KDr
	 hOl+ZBjUph5ZrXAPAV7w4IDqL4X5W7nO340uP400=
Date: Wed, 27 Nov 2024 17:04:52 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-add-alloc_frozen_pages.patch added to mm-unstable branch
Message-Id: <20241128010453.099FAC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: add alloc_frozen_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-add-alloc_frozen_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-add-alloc_frozen_pages.patch

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
Subject: mm/mempolicy: add alloc_frozen_pages()
Date: Mon, 25 Nov 2024 21:01:46 +0000

Provide an interface to allocate pages from the page allocator without
incrementing their refcount.  This saves an atomic operation on free,
which may be beneficial to some users (eg slab).

Link: https://lkml.kernel.org/r/20241125210149.2976098-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   12 +++++++++++
 mm/mempolicy.c |   49 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-mempolicy-add-alloc_frozen_pages
+++ a/mm/internal.h
@@ -747,6 +747,18 @@ struct page *__alloc_frozen_pages_noprof
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
+#ifdef CONFIG_NUMA
+struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
+#else
+static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
+{
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+}
+#endif
+
+#define alloc_frozen_pages(...) \
+	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
--- a/mm/mempolicy.c~mm-mempolicy-add-alloc_frozen_pages
+++ a/mm/mempolicy.c
@@ -2205,9 +2205,9 @@ static struct page *alloc_pages_preferre
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
 	if (!page)
-		page = __alloc_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
 
 	return page;
 }
@@ -2253,8 +2253,9 @@ static struct page *alloc_pages_mpol(gfp
 			 * First, try to allocate THP only on local node, but
 			 * don't reclaim unnecessarily, just compact.
 			 */
-			page = __alloc_pages_node_noprof(nid,
-				gfp | __GFP_THISNODE | __GFP_NORETRY, order);
+			page = __alloc_frozen_pages_noprof(
+				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
+				nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2266,7 +2267,7 @@ static struct page *alloc_pages_mpol(gfp
 		}
 	}
 
-	page = __alloc_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE) && page) {
 		/* skip NUMA_INTERLEAVE_HIT update if numa stats is disabled */
@@ -2284,8 +2285,13 @@ static struct page *alloc_pages_mpol(gfp
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	return page_rmappable_folio(alloc_pages_mpol(gfp | __GFP_COMP,
-							order, pol, ilx, nid));
+	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
+			ilx, nid);
+	if (!page)
+		return NULL;
+
+	set_page_refcounted(page);
+	return page_rmappable_folio(page);
 }
 
 /**
@@ -2320,6 +2326,21 @@ struct folio *vma_alloc_folio_noprof(gfp
 }
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
+struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
+{
+	struct mempolicy *pol = &default_policy;
+
+	/*
+	 * No reference counting needed for current->mempolicy
+	 * nor system default_policy
+	 */
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
+
+	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
+				       numa_node_id());
+}
+
 /**
  * alloc_pages - Allocate pages.
  * @gfp: GFP flags.
@@ -2336,17 +2357,11 @@ EXPORT_SYMBOL(vma_alloc_folio_noprof);
  */
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	struct mempolicy *pol = &default_policy;
+	struct page *page = alloc_frozen_pages_noprof(gfp, order);
 
-	/*
-	 * No reference counting needed for current->mempolicy
-	 * nor system default_policy
-	 */
-	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
-		pol = get_task_policy(current);
-
-	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
-				       numa_node_id());
+	if (page)
+		set_page_refcounted(page);
+	return page;
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

