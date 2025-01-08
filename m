Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD422E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308368; cv=none; b=Phyf6S6DgV3YB4A/OwK7JpsVzGUy/DM1vjW7T8auDx+lrVkaP49uX9+bQHBwkt+9GBGzLd3xrMZ+IIyaMs8kPzBRepadb9BiKid2RvtXxM7ZebXTAGud8Ps8XnstPIYu5JC90YngokDXazG9Nbkpwl/+Oejjw2iV/mauZaJW7Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308368; c=relaxed/simple;
	bh=FBpgzN4FAVHhpEnYesNCEPv6eQG9NvTV8hNHmeRK/Hs=;
	h=Date:To:From:Subject:Message-Id; b=XIJ3yOoWx0CcHZ0lQpX/wfEKBI7miq70SdygNbTfirZjoTew0H4b5sEO5sZpjJ+MHyPgTZ+BTJeLGYn67lSV18aAMP14B9qKjAfUlPi8KgeViqcMMt/rHMJWJ4IIY96UjFpOdqaGYbv4E5yQxNSnxwtjP3PQdpzInYfjjidvlRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nnpNQvQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nnpNQvQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC85C4CED0;
	Wed,  8 Jan 2025 03:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308367;
	bh=FBpgzN4FAVHhpEnYesNCEPv6eQG9NvTV8hNHmeRK/Hs=;
	h=Date:To:From:Subject:From;
	b=nnpNQvQ6spjudS7Cb9bxjZUgKI1PnsPtOhxGsmRHafFHaVUexabTvrxRzX0JpOUyn
	 9hF+nohh3drtSuwLBMWCNRW6XGrGgagvLQb4OGkQ51JkLTAaZiGWrB/6JMnbWwee0v
	 PtkOxc9Zg8jIvR3uY4q089vyKN0IWjmFBIJqKQ6U=
Date: Tue, 07 Jan 2025 19:52:46 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-drop-vma_has_reserves.patch added to mm-unstable branch
Message-Id: <20250108035247.6FC85C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: drop vma_has_reserves()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-drop-vma_has_reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-vma_has_reserves.patch

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
@@ -1246,16 +1246,6 @@ void clear_vma_resv_huge_pages(struct vm
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
@@ -1341,7 +1331,7 @@ static unsigned long available_huge_page
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long chg)
+				unsigned long address, long gbl_chg)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1350,11 +1340,10 @@ static struct folio *dequeue_hugetlb_fol
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
@@ -1372,7 +1361,7 @@ static struct folio *dequeue_hugetlb_fol
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	if (folio && vma_has_reserves(chg)) {
+	if (folio && !gbl_chg) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
@@ -3063,7 +3052,7 @@ struct folio *alloc_hugetlb_folio(struct
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

mm-hugetlb-fix-avoid_reserve-to-allow-taking-folio-from-subpool.patch
mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch
mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch
mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch
mm-hugetlb-simplify-vma_has_reserves.patch
mm-hugetlb-drop-vma_has_reserves.patch
mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

