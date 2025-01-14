Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAD246354
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837197; cv=none; b=i6hXpcRxNYPxmWn/LfIAv7qu2NfIujtz8e5ZOl23Posw+3CeUbv3sTzC6k7TpyRXcZoZD6ijtEbqNfURHbLuE5aCsmg+cQKLN2aXh2Iro3JCIk+ROp2fi3Pcvc621hltrS5LiFPl+Dai0WRF0QzpKvLCCEPvdt4h9Takz0OgtcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837197; c=relaxed/simple;
	bh=qvNJfrtmaTUlm9QVk7zBBWSl5va7JqugG+hSGTCXdBk=;
	h=Date:To:From:Subject:Message-Id; b=uRoPMpo4W7hLboHBl3oi+EWJeovjqkQTH8y0uDhGb0F5HgreVZKdW3pv79duX2G953KMzpk2mN9ypy18aAR9S2zIcwLGq9lY5iO42s4ll9QyobcxjDfvMiIx2rw9bMx+rAoF8cCON8NOnFiD7v9vQI0d5mu631iX8u/D8FJFsRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWwj4hAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWwj4hAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D824C4CEDF;
	Tue, 14 Jan 2025 06:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837197;
	bh=qvNJfrtmaTUlm9QVk7zBBWSl5va7JqugG+hSGTCXdBk=;
	h=Date:To:From:Subject:From;
	b=qWwj4hAvvjItchKkRxo6V27rws2wlIOn1/pKVt+lBcAETbRp0i2JNgpBkRizLVI8b
	 izwoCUnDrvf/NJk2PmliVRlQA8SiLzkY+1HCTiBoSmn95lgE4Gya97bGnwfZyacvm1
	 2uSmrjkKj1FUS6er4LaalmA6LCjaFCZal10ZjvNE=
Date: Mon, 13 Jan 2025 22:46:36 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch removed from -mm tree
Message-Id: <20250114064637.0D824C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: unify restore reserve accounting for new allocations
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1365,11 +1365,6 @@ static struct folio *dequeue_hugetlb_fol
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	if (folio && !gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
 	mpol_cond_put(mpol);
 	return folio;
 
@@ -3056,15 +3051,20 @@ struct folio *alloc_hugetlb_folio(struct
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


