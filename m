Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A33C320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560200; cv=none; b=YBA6pYoeimVYDGQ1zS2B+LBzO1giIIrftSBWs22spU9xLgplJdrTXtxJoxjL5+9aK5wnavN5b3dns8zRUnUYohiROWrIp1Vz4cu8Pway6kw9BcJ7/3Zi49df0xUGNREum+VMqRAblI+4loEGx07Du2oO1CqjvTDESbVaX9mR+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560200; c=relaxed/simple;
	bh=scEATOZ9H/eAwk4i5x8b2bpuAUHSaLTkYok8HKN9pD4=;
	h=Date:To:From:Subject:Message-Id; b=V2ssPZDw1RSrREhg61NnkVJ058u85nSWK21n62GEiSfxrp6NYQL6Q6M2WXjOPROKk1zeZT/jdfZNpnqAHc13v2yCgSXnoan/W9Gx6dpi50w+mLlyqFur+l/CcbzJDKMUZT4WSzI9zaDBupy9/qu77OkLQx0P52QqW7ujq3SvaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BeIB+ZW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BeIB+ZW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40468C43390;
	Thu, 22 Feb 2024 00:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560200;
	bh=scEATOZ9H/eAwk4i5x8b2bpuAUHSaLTkYok8HKN9pD4=;
	h=Date:To:From:Subject:From;
	b=BeIB+ZW9lpM5gqv6icqirYB0DFhP+RU5+md8/lXiZ8WYO5B872gZ/PKCL9EFB/QH5
	 91b0gy2CM9/ZEGOnF2cg48l+LL4ZPmC0o+k549iWDdk0m68M1+HkZkI1QY11pU7awW
	 Het9hMp6IjZVTRZcs/48uXcD2+CcpF+z+LBjrSj8=
Date: Wed, 21 Feb 2024 16:03:19 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch removed from -mm tree
Message-Id: <20240222000320.40468C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: improve the handling of hugetlb allocation failure for freed or in-use hugetlb
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: hugetlb: improve the handling of hugetlb allocation failure for freed or in-use hugetlb
Date: Tue, 6 Feb 2024 11:08:11 +0800

alloc_and_dissolve_hugetlb_folio() preallocates a new hugetlb page before
it takes hugetlb_lock.  In 3 out of 4 cases the page is not really used
and therefore the newly allocated page is just freed right away.  This is
wasteful and it might cause pre-mature failures in those cases.

Address that by moving the allocation down to the only case (hugetlb page
is really in the free pages pool).  We need to drop hugetlb_lock to do so
and therefore need to recheck the page state after regaining it.

The patch is more of a cleanup than an actual fix to an existing problem. 
There are no known reports about pre-mature failures.

Link: https://lkml.kernel.org/r/62890fd60b1ecd5bf1cdc476c973f60fe37aa0cb.1707181934.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb
+++ a/mm/hugetlb.c
@@ -3029,21 +3029,9 @@ static int alloc_and_dissolve_hugetlb_fo
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nid = folio_nid(old_folio);
-	struct folio *new_folio;
+	struct folio *new_folio = NULL;
 	int ret = 0;
 
-	/*
-	 * Before dissolving the folio, we need to allocate a new one for the
-	 * pool to remain stable.  Here, we allocate the folio and 'prep' it
-	 * by doing everything but actually updating counters and adding to
-	 * the pool.  This simplifies and let us do most of the processing
-	 * under the lock.
-	 */
-	new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, NULL, NULL);
-	if (!new_folio)
-		return -ENOMEM;
-	__prep_new_hugetlb_folio(h, new_folio);
-
 retry:
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(old_folio)) {
@@ -3073,6 +3061,16 @@ retry:
 		cond_resched();
 		goto retry;
 	} else {
+		if (!new_folio) {
+			spin_unlock_irq(&hugetlb_lock);
+			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
+							      NULL, NULL);
+			if (!new_folio)
+				return -ENOMEM;
+			__prep_new_hugetlb_folio(h, new_folio);
+			goto retry;
+		}
+
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
@@ -3100,9 +3098,11 @@ retry:
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
-	/* Folio has a zero ref count, but needs a ref to be freed */
-	folio_ref_unfreeze(new_folio, 1);
-	update_and_free_hugetlb_folio(h, new_folio, false);
+	if (new_folio) {
+		/* Folio has a zero ref count, but needs a ref to be freed */
+		folio_ref_unfreeze(new_folio, 1);
+		update_and_free_hugetlb_folio(h, new_folio, false);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch

