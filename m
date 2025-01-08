Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9412E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308365; cv=none; b=rbPu6Pa6C9Sk2q1GqYLUn4rWDe7I6QtKPCFaKsUiY375tTHm7V+sAdwjsH1BZaGBBE4YzgHE8KWa4lKacv2/UR4tZSPp1cz0CUvzrWQCjNzATTHS9JR2xR5KZjHc3O6sqG8UwtCeZUc6tZVTKvW7dSRWtFsBhA4FBIJZvxxfER4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308365; c=relaxed/simple;
	bh=bwZoI71301xeEXkAiNVYH+BwZd8Odx+av9ZN7J2ZCSQ=;
	h=Date:To:From:Subject:Message-Id; b=p4zykPHvzBfIdb450E/jq3lFu/rl8lsyc3UXA0cCB0ym41aRkBIjGK8RZqR+hvgkGDF05DKoQqIszUJETW9P/CRf1rR3ZJ25kQQVKQtwh5/B8yfc5uBvB/fVsy7pCzSR/GKjzUaDToCk5fOrpIL4k850ImmVAJhiGv8ucZL57G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XkZjANmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XkZjANmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B1C4CED0;
	Wed,  8 Jan 2025 03:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308365;
	bh=bwZoI71301xeEXkAiNVYH+BwZd8Odx+av9ZN7J2ZCSQ=;
	h=Date:To:From:Subject:From;
	b=XkZjANmrCPT/gk/OJppsDiC4K526TjdvPPJHSNylq92WEFeA5TRkQPZnlh/gDd1cD
	 7ocyIdYnBEDezIMPymkGqN02ylTX3r8bswt/bcPeb7V6FDfeXD81PEO+MoVySxfnEZ
	 2Hu+vV8U4YWK2zJNuNlvqjxw7S0QjmL+dKa9h1N0=
Date: Tue, 07 Jan 2025 19:52:44 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-simplify-vma_has_reserves.patch added to mm-unstable branch
Message-Id: <20250108035245.677B1C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: simplify vma_has_reserves()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-simplify-vma_has_reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-simplify-vma_has_reserves.patch

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
Subject: mm/hugetlb: simplify vma_has_reserves()
Date: Tue, 7 Jan 2025 15:40:00 -0500

vma_has_reserves() is a helper "trying" to know whether the vma should
consume one reservation when allocating the hugetlb folio.

However it's not clear on why we need such complexity, as such information
is already represented in the "chg" variable.

From alloc_hugetlb_folio() context, "chg" (or in the function's context,
"gbl_chg") is defined as:

  - If gbl_chg=1, the allocation cannot reuse an existing reservation
  - If gbl_chg=0, the allocation should reuse an existing reservation

Firstly, map_chg is defined as following, to cover all cases of hugetlb
reservation scenarios (mostly, via vma_needs_reservation(), but
cow_from_owner is an outlier):

CONDITION                                             HAS RESERVATION?
=========                                             ================
- SHARED: always check against per-inode resv_map
  (ignore NONRESERVE)
  - If resv exists                                ==> YES  [1]
  - If not                                        ==> NO   [2]
- PRIVATE: complicated...
  - Request came from a CoW from owner resv map   ==> NO   [3]
    (when cow_from_owner==true)
  - If does not own a resv_map at all..           ==> NO   [4]
    (examples: VM_NORESERVE, private fork())
  - If owns a resv_map, but resv donsn't exists   ==> NO   [5]
  - If owns a resv_map, and resv exists           ==> YES  [6]

Further on, gbl_chg considered spool setup, so that is a decision based on
all the context.

If we look at vma_has_reserves(), it almost does check that has already
been processed by map_chg accounting (I marked each return value to the
case above):

  static bool vma_has_reserves(struct vm_area_struct *vma, long chg)
  {
          if (vma->vm_flags & VM_NORESERVE) {
                  if (vma->vm_flags & VM_MAYSHARE && chg == 0)
                          return true;              ==> [1]
                  else
                          return false;             ==> [2] or [4]
          }

          if (vma->vm_flags & VM_MAYSHARE) {
                  if (chg)
                          return false;             ==> [2]
                  else
                          return true;              ==> [1]
          }

          if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
                  if (chg)
                          return false;             ==> [5]
                  else
                          return true;              ==> [6]
          }

          return false;                             ==> [4]
  }

It didn't check [3], but [3] case was actually already covered now by the
"chg" / "gbl_chg" / "map_chg" calculations.

In short, vma_has_reserves() doesn't provide anything more than return
"!chg"..  so just simplify all the things.

There're a lot of comments describing truncation races, IIUC there should
have no race as long as map_chg is properly done.

Link: https://lkml.kernel.org/r/20250107204002.2683356-6-peterx@redhat.com
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

 mm/hugetlb.c |   67 +++++--------------------------------------------
 1 file changed, 7 insertions(+), 60 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-simplify-vma_has_reserves
+++ a/mm/hugetlb.c
@@ -1247,66 +1247,13 @@ void clear_vma_resv_huge_pages(struct vm
 }
 
 /* Returns true if the VMA has associated reserve pages */
-static bool vma_has_reserves(struct vm_area_struct *vma, long chg)
+static bool vma_has_reserves(long chg)
 {
-	if (vma->vm_flags & VM_NORESERVE) {
-		/*
-		 * This address is already reserved by other process(chg == 0),
-		 * so, we should decrement reserved count. Without decrementing,
-		 * reserve count remains after releasing inode, because this
-		 * allocated page will go into page cache and is regarded as
-		 * coming from reserved pool in releasing step.  Currently, we
-		 * don't have any other solution to deal with this situation
-		 * properly, so add work-around here.
-		 */
-		if (vma->vm_flags & VM_MAYSHARE && chg == 0)
-			return true;
-		else
-			return false;
-	}
-
-	/* Shared mappings always use reserves */
-	if (vma->vm_flags & VM_MAYSHARE) {
-		/*
-		 * We know VM_NORESERVE is not set.  Therefore, there SHOULD
-		 * be a region map for all pages.  The only situation where
-		 * there is no region map is if a hole was punched via
-		 * fallocate.  In this case, there really are no reserves to
-		 * use.  This situation is indicated if chg != 0.
-		 */
-		if (chg)
-			return false;
-		else
-			return true;
-	}
-
 	/*
-	 * Only the process that called mmap() has reserves for
-	 * private mappings.
+	 * Now "chg" has all the conditions considered for whether we
+	 * should use an existing reservation.
 	 */
-	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		/*
-		 * Like the shared case above, a hole punch or truncate
-		 * could have been performed on the private mapping.
-		 * Examine the value of chg to determine if reserves
-		 * actually exist or were previously consumed.
-		 * Very Subtle - The value of chg comes from a previous
-		 * call to vma_needs_reserves().  The reserve map for
-		 * private mappings has different (opposite) semantics
-		 * than that of shared mappings.  vma_needs_reserves()
-		 * has already taken this difference in semantics into
-		 * account.  Therefore, the meaning of chg is the same
-		 * as in the shared case above.  Code could easily be
-		 * combined, but keeping it separate draws attention to
-		 * subtle differences.
-		 */
-		if (chg)
-			return false;
-		else
-			return true;
-	}
-
-	return false;
+	return chg == 0;
 }
 
 static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
@@ -1407,7 +1354,7 @@ static struct folio *dequeue_hugetlb_fol
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_reserves(vma, chg) && !available_huge_pages(h))
+	if (!vma_has_reserves(chg) && !available_huge_pages(h))
 		goto err;
 
 	gfp_mask = htlb_alloc_mask(h);
@@ -1425,7 +1372,7 @@ static struct folio *dequeue_hugetlb_fol
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	if (folio && vma_has_reserves(vma, chg)) {
+	if (folio && vma_has_reserves(chg)) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
@@ -3116,7 +3063,7 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (vma_has_reserves(vma, gbl_chg)) {
+		if (vma_has_reserves(gbl_chg)) {
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

