Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FC24335D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837196; cv=none; b=W3lodd+r60s2Gy5Kk4o8loPSa6WjlRTOHZpXSeLzZ+46ORE6yQahjjmJ38shjUOzDsHZfSpYQjHIYM7VsCrxTJ0WsMCmQOrD9qI6pMw7Jbpjodu9Z4lv5CaYX4TGC+DtweLQk/RkTUTgIz2qRqsqxvktXYm+uqn3+JDeukFyrkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837196; c=relaxed/simple;
	bh=iyFbDD/Jr8luq1WyqwproH1d02QwfizCFu8DJrexpfA=;
	h=Date:To:From:Subject:Message-Id; b=qQ/DSybViKcHCyVQolXBvvnHAYqMsQfqI+y+ILKmzH6PjMVTM7uNBkvnYWUvN2CwtL/ROKtf+aUxi7oGgkWcD+kLufqQeOr55L2yhrheNRQBz/OMFJlH87hOP65M1IalFtRvroo16abLPMZGRUzbF3cehucQf4krEcKxBoDAcsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhaYtSVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhaYtSVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0154C4CEDD;
	Tue, 14 Jan 2025 06:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837196;
	bh=iyFbDD/Jr8luq1WyqwproH1d02QwfizCFu8DJrexpfA=;
	h=Date:To:From:Subject:From;
	b=YhaYtSVU+wBjBkMaqmNMGYS7lXkF9BozGGFXrNngWOhdBzyNNiQCw4Ygx8VIPfXei
	 xuR2vClR0ZQQedadYodOgyvdgKafXI0F3bch0ahGl3UmXerAwr1EKvwCMHFKsHyfDt
	 z4nLH6FT0DKITULV0IfvPb6/it8DmmylW1/xtpbo=
Date: Mon, 13 Jan 2025 22:46:35 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-drop-vma_has_reserves.patch removed from -mm tree
Message-Id: <20250114064635.E0154C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: drop vma_has_reserves()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-vma_has_reserves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: drop vma_has_reserves()
Date: Tue, 7 Jan 2025 15:40:01 -0500

After the previous cleanup, vma_has_reserves() is mostly an empty helper
except that it says "use reserve count" is inverted meaning from "needs a
global reserve count", which is still true.

To avoid confusions on having two inverted ways to ask the same question,
always use the gbl_chg everywhere, and drop the function.

When at it, rename "chg" to "gbl_chg" in dequeue_hugetlb_folio_vma().  It
might be helpful for readers to see that the "chg" here is the global
reserve count, not the vma resv count.

Link: https://lkml.kernel.org/r/20250107204002.2683356-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-vma_has_reserves
+++ a/mm/hugetlb.c
@@ -1247,16 +1247,6 @@ void clear_vma_resv_huge_pages(struct vm
 	hugetlb_dup_vma_private(vma);
 }
 
-/* Returns true if the VMA has associated reserve pages */
-static bool vma_has_reserves(long chg)
-{
-	/*
-	 * Now "chg" has all the conditions considered for whether we
-	 * should use an existing reservation.
-	 */
-	return chg == 0;
-}
-
 static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	int nid = folio_nid(folio);
@@ -1345,7 +1335,7 @@ static unsigned long available_huge_page
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long chg)
+				unsigned long address, long gbl_chg)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1354,11 +1344,10 @@ static struct folio *dequeue_hugetlb_fol
 	int nid;
 
 	/*
-	 * A child process with MAP_PRIVATE mappings created by their parent
-	 * have no page reserves. This check ensures that reservations are
-	 * not "stolen". The child may still get SIGKILLed
+	 * gbl_chg==1 means the allocation requires a new page that was not
+	 * reserved before.  Making sure there's at least one free page.
 	 */
-	if (!vma_has_reserves(chg) && !available_huge_pages(h))
+	if (gbl_chg && !available_huge_pages(h))
 		goto err;
 
 	gfp_mask = htlb_alloc_mask(h);
@@ -1376,7 +1365,7 @@ static struct folio *dequeue_hugetlb_fol
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	if (folio && vma_has_reserves(chg)) {
+	if (folio && !gbl_chg) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
@@ -3067,7 +3056,7 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (vma_has_reserves(gbl_chg)) {
+		if (!gbl_chg) {
 			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
_

Patches currently in -mm which might be from peterx@redhat.com are


