Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47D01EA7EC;
	Wed, 25 Jun 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892155; cv=none; b=vDPV9lNWhqmLo5fsJqt0rJTYvUxjFKsvwPBHuIW9xVMVUE7YgKIx/0NwBvdU/30X8goysPOoqmJvfMuKJqq8twvx11VJRcGgyqp8ZrzlSxVdWmpkgVcmvyTfB+2vzB+a3GWIuMKldt31HNbPpvv9HPF++UHX4CfMYLBcXjids1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892155; c=relaxed/simple;
	bh=7apdSq5EMmOXJ8z5is9qqpBv/JTiv+qxhMa4Yuftk+g=;
	h=Date:To:From:Subject:Message-Id; b=YFTUn0wB9p5EnvRLPJ9q0JvQyagMK1uPkEJynKtgZC4ty2bFG/1VnorRRneP+Hb+hnT8lYsKGfzWcNfou9I0ZWjUrlicnj+ObtiSDFEuYkWgcFfqC6YptM0MyLeWSRp3Ippbv2vI7tYGE+32TsjwjMgby3wUuLZfqT29U1kHKBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DdtsDXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DdtsDXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62840C4CEEA;
	Wed, 25 Jun 2025 22:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892154;
	bh=7apdSq5EMmOXJ8z5is9qqpBv/JTiv+qxhMa4Yuftk+g=;
	h=Date:To:From:Subject:From;
	b=0DdtsDXwX9OvON5YWHXNQg8mBfW5roMWKrkb0xktYEJ4TcS0tSbvXUbz9MU4+U5qv
	 5EXlNqL9tAx2dQ0lnG1oAwOT9rrWkgOy1H9zfTObEwKUQJmtlPGxtEeWnLlWFbJAq9
	 k8Q7WBpBbeVoFAvQ7K8nl6RSx63SiyzSYuqY+ymA=
Date: Wed, 25 Jun 2025 15:55:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-remove-unnecessary-holding-of-hugetlb_lock.patch removed from -mm tree
Message-Id: <20250625225554.62840C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove unnecessary holding of hugetlb_lock
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unnecessary-holding-of-hugetlb_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ge Yang <yangge1116@126.com>
Subject: mm/hugetlb: remove unnecessary holding of hugetlb_lock
Date: Tue, 27 May 2025 11:36:50 +0800

In isolate_or_dissolve_huge_folio(), after acquiring the hugetlb_lock, it
is only for the purpose of obtaining the correct hstate, which is then
passed to alloc_and_dissolve_hugetlb_folio().

alloc_and_dissolve_hugetlb_folio() itself also acquires the hugetlb_lock. 
We can have alloc_and_dissolve_hugetlb_folio() obtain the hstate by
itself, so that isolate_or_dissolve_huge_folio() no longer needs to
acquire the hugetlb_lock.  In addition, we keep the folio_test_hugetlb()
check within isolate_or_dissolve_huge_folio().  By doing so, we can avoid
disrupting the normal path by vainly holding the hugetlb_lock.

replace_free_hugepage_folios() has the same issue, and we should address
it as well.

Addresses a possible performance problem which was added by the hotfix
113ed54ad276 ("mm/hugetlb: fix kernel NULL pointer dereference when
replacing free hugetlb folios").

Link: https://lkml.kernel.org/r/1748317010-16272-1-git-send-email-yangge1116@126.com
Fixes: 113ed54ad276 ("mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios")
Signed-off-by: Ge Yang <yangge1116@126.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   54 +++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-holding-of-hugetlb_lock
+++ a/mm/hugetlb.c
@@ -2787,20 +2787,24 @@ void restore_reserve_on_error(struct hst
 /*
  * alloc_and_dissolve_hugetlb_folio - Allocate a new folio and dissolve
  * the old one
- * @h: struct hstate old page belongs to
  * @old_folio: Old folio to dissolve
  * @list: List to isolate the page in case we need to
  * Returns 0 on success, otherwise negated error.
  */
-static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
-			struct folio *old_folio, struct list_head *list)
+static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
+			struct list_head *list)
 {
-	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+	gfp_t gfp_mask;
+	struct hstate *h;
 	int nid = folio_nid(old_folio);
 	struct folio *new_folio = NULL;
 	int ret = 0;
 
 retry:
+	/*
+	 * The old_folio might have been dissolved from under our feet, so make sure
+	 * to carefully check the state under the lock.
+	 */
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(old_folio)) {
 		/*
@@ -2829,8 +2833,10 @@ retry:
 		cond_resched();
 		goto retry;
 	} else {
+		h = folio_hstate(old_folio);
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
+			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
 							      NULL, NULL);
 			if (!new_folio)
@@ -2874,35 +2880,24 @@ free_new:
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
 {
-	struct hstate *h;
 	int ret = -EBUSY;
 
-	/*
-	 * The page might have been dissolved from under our feet, so make sure
-	 * to carefully check the state under the lock.
-	 * Return success when racing as if we dissolved the page ourselves.
-	 */
-	spin_lock_irq(&hugetlb_lock);
-	if (folio_test_hugetlb(folio)) {
-		h = folio_hstate(folio);
-	} else {
-		spin_unlock_irq(&hugetlb_lock);
+	/* Not to disrupt normal path by vainly holding hugetlb_lock */
+	if (!folio_test_hugetlb(folio))
 		return 0;
-	}
-	spin_unlock_irq(&hugetlb_lock);
 
 	/*
 	 * Fence off gigantic pages as there is a cyclic dependency between
 	 * alloc_contig_range and them. Return -ENOMEM as this has the effect
 	 * of bailing out right away without further retrying.
 	 */
-	if (hstate_is_gigantic(h))
+	if (folio_order(folio) > MAX_PAGE_ORDER)
 		return -ENOMEM;
 
 	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
-		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
+		ret = alloc_and_dissolve_hugetlb_folio(folio, list);
 
 	return ret;
 }
@@ -2916,7 +2911,6 @@ int isolate_or_dissolve_huge_folio(struc
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct hstate *h;
 	struct folio *folio;
 	int ret = 0;
 
@@ -2925,23 +2919,9 @@ int replace_free_hugepage_folios(unsigne
 	while (start_pfn < end_pfn) {
 		folio = pfn_folio(start_pfn);
 
-		/*
-		 * The folio might have been dissolved from under our feet, so make sure
-		 * to carefully check the state under the lock.
-		 */
-		spin_lock_irq(&hugetlb_lock);
-		if (folio_test_hugetlb(folio)) {
-			h = folio_hstate(folio);
-		} else {
-			spin_unlock_irq(&hugetlb_lock);
-			start_pfn++;
-			continue;
-		}
-		spin_unlock_irq(&hugetlb_lock);
-
-		if (!folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
-							       &isolate_list);
+		/* Not to disrupt normal path by vainly holding hugetlb_lock */
+		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
 			if (ret)
 				break;
 
_

Patches currently in -mm which might be from yangge1116@126.com are


