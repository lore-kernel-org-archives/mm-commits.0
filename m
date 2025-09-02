Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1422EA46E
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857170; cv=none; b=IyKnQmW0+f+OxdzC6KRGE+9xX7hxowRFF+XW96yMXDngl5l8g77/B8EbiSeyFaSmY/b+V27i6rlK/FaRHsl8HoX58h22brCykRxh/9Z+VfQgp0ilY1HOT/+BCec3+ETaJLBA+0wvtlLz7/F+8T1iwHM5fiYaZVH+iqyKICAFHS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857170; c=relaxed/simple;
	bh=m4FmlrlooyqhZvQA3whCg4AuAPKFaNKL+K2FQsxPsew=;
	h=Date:To:From:Subject:Message-Id; b=jkaDS5Emp/PwwHE7bsStmAw5pqxH2dzs8AXCQh3RZW2d8x3sMIEOe4nrPlBXvBl+jaSvLrPzpuCuybmxenBnZW+CPMF4ByBJog45b+e22ribmFl61pNRpybuyBna2ki3wDFWk4TGPefXdP2V8hrxGMi+m29zj5RrbN1UFycyiIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EclfctwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EclfctwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B14BC4CEED;
	Tue,  2 Sep 2025 23:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857170;
	bh=m4FmlrlooyqhZvQA3whCg4AuAPKFaNKL+K2FQsxPsew=;
	h=Date:To:From:Subject:From;
	b=EclfctwRtZO8ahDByTeLAcUcrYxNul/iGO+dABxAy6eB/HArxIZZEDKmOng/MhfVO
	 mO+1hFpQXurWpZbWF0t5yin/HOwueSUyffgdW/t/Ea/eB/5VzF8O4ybY7QLJv8PcDE
	 4TFdsVrlPi3QN/DIXMI8d/w3SwFgcWyrbV2+zItA=
Date: Tue, 02 Sep 2025 16:52:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch added to mm-new branch
Message-Id: <20250902235250.2B14BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch

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
Subject: mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:12 +0800

Patch series "mm: hugetlb: cleanup and allocate frozen hugetlb folio", v2.

The first part is to clean up some hugetlb folio allocation and the others
convert to allocate frozen folio in gigantic folio, similar to
alloc_buddy_hugetlb_folio(), avoid atomic operation about folio refcount.


This patch (of 9):

Simplify alloc_fresh_hugetlb_folio() and convert more functions to use it,
which help us to remove prep_new_hugetlb_folio() and
__prep_new_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250902124820.3081488-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20250902124820.3081488-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1906,20 +1906,6 @@ static void init_new_hugetlb_folio(struc
 	set_hugetlb_cgroup_rsvd(folio, NULL);
 }
 
-static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
-{
-	init_new_hugetlb_folio(h, folio);
-	hugetlb_vmemmap_optimize_folio(h, folio);
-}
-
-static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
-{
-	__prep_new_hugetlb_folio(h, folio);
-	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, nid);
-	spin_unlock_irq(&hugetlb_lock);
-}
-
 /*
  * Find and lock address space (mapping) in write mode.
  *
@@ -2005,10 +1991,10 @@ static struct folio *only_alloc_fresh_hu
 }
 
 /*
- * Common helper to allocate a fresh hugetlb page. All specific allocators
- * should use this function to get new hugetlb pages
+ * Common helper to allocate a fresh hugetlb folio. All specific allocators
+ * should use this function to get new hugetlb folio
  *
- * Note that returned page is 'frozen':  ref count of head page and all tail
+ * Note that returned folio is 'frozen':  ref count of head page and all tail
  * pages is zero.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
@@ -2016,14 +2002,9 @@ static struct folio *alloc_fresh_hugetlb
 {
 	struct folio *folio;
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
-	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
-	if (!folio)
-		return NULL;
-
-	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	if (folio)
+		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
 }
 
@@ -2241,12 +2222,10 @@ static struct folio *alloc_surplus_huget
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
-	hugetlb_vmemmap_optimize_folio(h, folio);
-
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2290,6 +2269,10 @@ static struct folio *alloc_migrate_huget
 	if (!folio)
 		return NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	__prep_account_new_huge_page(h, folio_nid(folio));
+	spin_unlock_irq(&hugetlb_lock);
+
 	/* fresh huge pages are frozen */
 	folio_ref_unfreeze(folio, 1);
 	/*
@@ -2836,11 +2819,10 @@ retry:
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
-							      NULL, NULL);
+			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
+							      nid, NULL);
 			if (!new_folio)
 				return -ENOMEM;
-			__prep_new_hugetlb_folio(h, new_folio);
 			goto retry;
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

