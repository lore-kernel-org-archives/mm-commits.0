Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793251740;
	b=hz1n2yz3ibCIY5Bc0SQGuwOGHQv5VUmCAY6r9XrLzOPEz6LVQ220mvpPUC3qet+zwAEJ
	 ogb8egHiuvNTkywbq/0pd3/QukKOGY61Z507GSYzzLx5WbbHwCZ2Z1CNb81c8cz9JsKlo
	 Hmh73KloYQce7HO5v7/j9WWtWG4O3BNFQVVvWrvj9OUd04b7U4d6SgsUmsPX2f/aIOdr8
	 TOJ5gBDvfooOixMlKA67+hCuJVi8asxU03dmpS+tA+1alPQg/NxBx4bwXh8/ZH1trhcpY
	 An+RvY2tucBIM8XoKGdWIMMAruJOB/evKBIQa9tazDVgYsnUe8OqnDKZsZHTmwahwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793251740;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iUGbBhgVuegGEwbJwljheDN/HF6FIDtwgtvq8E6IK30=;
	b=ydUXFV0Bfb6pVlaQ/J6uLT334pSB9CVBf4cyUTZOKsbupFMhGZcw84PptTi488lceClu
	 W9g33ogBKNXOJ0cE6D2dOAETUKL4C8i3FaDxCcXPKZKiFlHdsGvUmk/h3oymNoyRCZC3b
	 zo+ja8RPqBF4s81hgfT3cOiG2H0qrDlByfpiqoKE1zYw8VKzfmG/B4cdPnnuDuxBtmhfd
	 mKVgCD6seUBER7F7m6fduuKflpkKEVmUtA87hiPhxFcTJPEIgbhwybIy5SuTViWa0Tja8
	 GEaWwIA0lEaNWXja305173B9A6uwgPPs/pgYSMc5eBGhUTgl+r8mJtZo9gYDK48Yqhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EPkBbjYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED96606A31A;
	Thu, 29 Oct 2026 05:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EPkBbjYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538981F01825;
	Thu, 29 Oct 2026 05:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793251739;
	bh=iUGbBhgVuegGEwbJwljheDN/HF6FIDtwgtvq8E6IK30=;
	h=Date:To:From:Subject;
	b=EPkBbjYuutoajV49M+qFHeRh/il6RQG42yIKMbtHeU1mOUweMHIm+RV4jd9cZ+h7e
	 uPXB2dhEwHE/YKQo2SPPZEvsStF9ggzFJ81PDPeOjnyIJnhbB8NmQrlqROKD69eTmj
	 xj0FAguPlM/jYP1U4r8meOZ8BiFZt/JtsNdCOVDo=
Date: Wed, 28 Oct 2026 22:28:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,
	muchun.song@linux.dev,mawupeng1@huawei.com,kmehltretter@gmail.com,
	david@kernel.org,ackerleytng@google.com,enderaoelyther@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch removed from -mm tree
Message-Id: <20261029052859.538981F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhao Li <enderaoelyther@gmail.com>
Subject: mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
Date: Tue, 28 Apr 2026 19:30:38 +0800

Failed hugetlbfs page allocations can permanently consume the mount's
size= quota without allocating a huge page.  Repeated failures can make
the filesystem appear full and cause later huge-page faults or allocations
to fail with SIGBUS/allocation failure despite available huge pages and
unused real filesystem capacity.

alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg is
set.  For a subpool with max_hpages != -1, that bumps used_hpages
regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
gbl_chg > 0 (used_hpages slot only).  If the allocation later fails before
a folio is returned, the unwind must undo the used_hpages bump.  The old
cleanup only ran for !gbl_chg, leaking used_hpages on the gbl_chg > 0
path.

For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages == -1),
hugepage_subpool_get_pages() took only a speculative used_hpages slot. 
Drop that slot directly under spool->lock.  In that configuration
hugepage_subpool_put_pages() cannot restore rsv_hpages, so the direct
decrement is the exact inverse and is race-free against concurrent puts. 
This matches the used_hpages-only part of hugetlb_reserve_pages()'s
out_put_pages cleanup, but restricts it to the max-only case where no
rsv_hpages restoration is possible.

Mounts with min_hpages != -1 are left unchanged for now.  v2's approach
(hugepage_subpool_put_pages() + h->resv_huge_pages++ to back a restored
rsv_hpages slot) double-counts global backing under concurrent
free_huge_folio() and creates phantom reservations under concurrent
hugetlb_unreserve_pages().  Safe cleanup of that quadrant needs a
coordinated fix across multiple call sites.

Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of subpool
quota; this patch leaks 0/8.  Verified under QEMU.

Link: https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
  Link: https://lore.kernel.org/20260923065714.20781-1-kmehltretter@gmail.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org> # v6.15+
---

 mm/hugetlb.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure
+++ a/mm/hugetlb.c
@@ -3121,13 +3121,24 @@ struct folio *alloc_hugetlb_folio(struct
 	return folio;
 
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		if (!gbl_chg) {
+			/* Full inverse when subpool_get_pages() consumed rsv_hpages. */
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (gbl_chg > 0 && spool && spool->min_hpages == -1 &&
+			   spool->max_hpages != -1) {
+			unsigned long flags;
+
+			/*
+			 * For max-only subpools, subpool_get_pages() took only a
+			 * speculative used_hpages slot. Drop that slot directly.
+			 */
+			spin_lock_irqsave(&spool->lock, flags);
+			if (spool->used_hpages > 0)
+				spool->used_hpages--;
+			unlock_or_release_subpool(spool, flags);
+		}
 	}
 
 out_end_reservation:
_

Patches currently in -mm which might be from enderaoelyther@gmail.com are


