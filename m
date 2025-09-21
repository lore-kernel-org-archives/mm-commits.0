Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04BE28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489859; cv=none; b=ZRH2m51TlajgzutCVIr0iBlSXO7GcDQcf7HkUPZfYlGdpEvEHspz933z0UP2O99IfmmRbC1jEe4xOajjkEljYZuB8Z+dU8Gl7lbKFCYKlww616l2gjTbc7GyJBMzWAoU9dotYtEI7+lHENkp0QWc6I4WO+4EYWNdy2XinkcigfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489859; c=relaxed/simple;
	bh=MMPj1L6V7wVTlqIhWn3NTmUIy2DXpyuqZ9yeNtUgMF8=;
	h=Date:To:From:Subject:Message-Id; b=qavbVFH4eusDIJ27vEu8Ekctrs+plix2/wxnHzEWbicYHCKHWyaR6CFoayGkrQ/b65bt1zuJloIcqPVa6vQUhiyJqqkAQ+csz9bTSXh/F2mGBD6/3yt2RYoP1MwT9E5XxWRUgimC2mcTKg2tZ6LVcd0vRB2VBKqJ5RZhiVmtamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P21YWnzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P21YWnzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5111C4CEE7;
	Sun, 21 Sep 2025 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489858;
	bh=MMPj1L6V7wVTlqIhWn3NTmUIy2DXpyuqZ9yeNtUgMF8=;
	h=Date:To:From:Subject:From;
	b=P21YWnzSzOBzLfUyWHUSlC2tRPbH2PLVUa0KNZK6UrUpSh2sf9b3lexdidKa8L+dQ
	 7eRvMLyfJ4gHuZMG9tjhsNAK7H8rO0O8lYNRMbJlDnD32P7ejKFIrmhZ9jNZVrAnhV
	 UD2Z54VdYGpmlnliZTL/vdAuTFSCYQxcnWgtV1FI=
Date: Sun, 21 Sep 2025 14:24:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250921212418.B5111C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:54 +0800

Patch series "mm: hugetlb: cleanup hugetlb folio allocation", v3.

Some cleanups for hugetlb folio allocation.


This patch (of 3):

Simplify alloc_fresh_hugetlb_folio() and convert more functions to use it,
which help us to remove prep_new_hugetlb_folio() and
__prep_new_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250910133958.301467-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20250910133958.301467-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

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
@@ -2005,25 +1991,20 @@ static struct folio *only_alloc_fresh_hu
 }
 
 /*
- * Common helper to allocate a fresh hugetlb page. All specific allocators
- * should use this function to get new hugetlb pages
+ * Common helper to allocate a fresh hugetlb folio. All specific allocators
+ * should use this function to get new hugetlb folio
  *
- * Note that returned page is 'frozen':  ref count of head page and all tail
- * pages is zero.
+ * Note that returned folio is 'frozen':  ref count of head page and all tail
+ * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask)
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


