Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7CB2E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308370; cv=none; b=mlmPZgSKIExNzg6vobknDkI1LrpEDJpGz+2LnhzSXI3sQxtm0L+oVwQfFJ3UEd/XAg0tPuACsDkJAFRMGMt7kALePV8L1eb5oclJi30vly/6o0hQkgq+GPHWxYpol56HssQNKKMQI9Znw809IcRoqZwd2Wd9PDjCAI1vLK4ssu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308370; c=relaxed/simple;
	bh=beC0bcRx5KKE0psflA/WCmHn5VwoiStIluEb7Ye+mMQ=;
	h=Date:To:From:Subject:Message-Id; b=h2+TWKYrSppMH24L+edxK5pQ7E2p2t9RzzSDnpcOZi77vUoHbvxESsqkcFTFAgn+QQi2YMYLgZ4CR8L+uCBSfyIS6oLUnjtaJAJb2G/viFohFevk30cwy4eMBTujNB5AL3z/HcnOoJf3wbFNczc12RsZEj7qflenzKy2AAGDIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mWLh8hFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mWLh8hFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680E6C4CED0;
	Wed,  8 Jan 2025 03:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308369;
	bh=beC0bcRx5KKE0psflA/WCmHn5VwoiStIluEb7Ye+mMQ=;
	h=Date:To:From:Subject:From;
	b=mWLh8hFJ7GP4/1Y7QtcgFSCN4V0kpWrhgdtjn7pj8RT/bFUINHfHTV3/ghLbmkHyM
	 EmzcpnbaYzhxylbXnA7qHkc2jCLnPwkBpLiox8syZUor7A+RDJoMCBBDNnGXkMkqK9
	 Hs0iK1aqFVrDLVTyz0SmKYXuSWjCFciRYnrPenD0=
Date: Tue, 07 Jan 2025 19:52:48 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch added to mm-unstable branch
Message-Id: <20250108035249.680E6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: unify restore reserve accounting for new allocations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

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
Subject: mm/hugetlb: unify restore reserve accounting for new allocations
Date: Tue, 7 Jan 2025 15:40:02 -0500

Either hugetlb pages dequeued from hstate, or newly allocated from buddy,
would require restore-reserve accounting to be managed properly.  Merge
the two paths on it.  Add a small comment to make it slightly nicer.

Link: https://lkml.kernel.org/r/20250107204002.2683356-8-peterx@redhat.com
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

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations
+++ a/mm/hugetlb.c
@@ -1361,11 +1361,6 @@ static struct folio *dequeue_hugetlb_fol
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	if (folio && !gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
 	mpol_cond_put(mpol);
 	return folio;
 
@@ -3052,15 +3047,20 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (!gbl_chg) {
-			folio_set_hugetlb_restore_reserve(folio);
-			h->resv_huge_pages--;
-		}
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		/* Fall through */
 	}
 
+	/*
+	 * Either dequeued or buddy-allocated folio needs to add special
+	 * mark to the folio when it consumes a global reservation.
+	 */
+	if (!gbl_chg) {
+		folio_set_hugetlb_restore_reserve(folio);
+		h->resv_huge_pages--;
+	}
+
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
 	/* If allocation is not consuming a reservation, also store the
 	 * hugetlb_cgroup pointer on the page.
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-avoid_reserve-to-allow-taking-folio-from-subpool.patch
mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch
mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch
mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch
mm-hugetlb-simplify-vma_has_reserves.patch
mm-hugetlb-drop-vma_has_reserves.patch
mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

