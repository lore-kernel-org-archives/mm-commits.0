Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB20F522F
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547222; cv=none; b=IyLlRMLlL+ATFZHml+QrpKMbbFgjpDrSoH+R/Qd4UNyOQSZKMP9i/VO29SC9H37s8yH/hVbTxcyVu9gb9rqF+1VO5bJZ/jdIuqfgJ5LqXMHiTSMjTIH7A3CJGakdAUB+w67yLpZnhBt9c80jOsr7mUoQr/MFISn1xQHQKpFndRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547222; c=relaxed/simple;
	bh=aR+biIVVPog/Ly1Jyg3vBdaPl3US+CYnd/XyXGAIjr4=;
	h=Date:To:From:Subject:Message-Id; b=SY3VzN4snCpYeMHfEJ4TQ5p1Jyl0l+88XDhoQ6G5UBVe0zuIOH8QMC94R3g7eOff6O8vSLHWbKAkxBCcy+jLmp7EWvAJc0kr9AEJY4EAG96PrU7r0KrQ+TRLo81QZzzduxfEaIbmy3blnRFXzegtlSY46lGJDgyIwjzchi9vQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qMT0fpKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qMT0fpKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ED6C4CEEB;
	Wed, 10 Sep 2025 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757547222;
	bh=aR+biIVVPog/Ly1Jyg3vBdaPl3US+CYnd/XyXGAIjr4=;
	h=Date:To:From:Subject:From;
	b=qMT0fpKseSORGY3+HbYEENiLeFcTRQtKAglCKssBidSfsGJTUj4JHXYTbT3K36LMQ
	 2OZYNW/bw2sNHiu7CMDD76lWSecIGdNgxbHpSA+lfifrsUb6qDWvuMTQLhSM2ZN63v
	 m5aQupX3DSmc0qlQDkmzkHYu+Yur77UE09DfFVhc=
Date: Wed, 10 Sep 2025 16:33:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20250910233342.44ED6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch

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

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

