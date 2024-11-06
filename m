Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3585D140E3C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854736; cv=none; b=kIzW3NlWPejeMKHGRKvDhpqfKmr3WjxM5ebkpBPeNyUtRFVxsgtSTIZFsaP6UV2+/hvJA58dXGK3+6tVw1WFi5XpMs4xNu3YdZFxuNC56o7BCDDazNnMLqiZupELWxtalKbz12F33WkIeBxH1dN/4pINtMxLgnhd4xOwpLSmqXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854736; c=relaxed/simple;
	bh=RvCAKA5DHgHFxRLf5pUAKCwv8sjMChtx0HKz2h47lFg=;
	h=Date:To:From:Subject:Message-Id; b=BDf1mB2xDw8Qdrc/QeQd4fVLMfJXRw+key2KQaArviSFcy28ALukAoVG5yQdRjY02+Km1g/o7DdFDSkrKDxv1ghDkDA+YHDPLL9P+Ywfk5RJrJt/xNYydSVjho01FEWjL/bPIOm9dIx/Sp/03n5ow+XPeL3IltijWcJL44SimlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6bgKgxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6bgKgxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C364C4CECF;
	Wed,  6 Nov 2024 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854736;
	bh=RvCAKA5DHgHFxRLf5pUAKCwv8sjMChtx0HKz2h47lFg=;
	h=Date:To:From:Subject:From;
	b=s6bgKgxwywQ547w98yUo9OPxepwAynBCl/fXfObmOFeuMNTW4bSSq887P5KCTsHvr
	 CpQPFljCKSKqLzYSjUpdnSul4VsOr0+xRsWU0cxOXg4ylGtCvLs75W6PebIeW2XwO4
	 +KyPHVz63e+Lw865WrwUXNczUUB+IFnyghN8D6Gw=
Date: Tue, 05 Nov 2024 16:58:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005856.0C364C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_vma_mapped_walk: map_pte() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_vma_mapped_walk: map_pte() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:23 +0800

In the caller of map_pte(), we may modify the pvmw->pte after acquiring
the pvmw->ptl, so convert it to using pte_offset_map_rw_nolock().  At this
time, the pte_same() check is not performed after the pvmw->ptl held, so
we should get pmdval and do pmd_same() check to ensure the stability of
pvmw->pmd.

Link: https://lkml.kernel.org/r/2620a48f34c9f19864ab0169cdbf253d31a8fcaa.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock
+++ a/mm/page_vma_mapped.c
@@ -13,7 +13,8 @@ static inline bool not_found(struct page
 	return false;
 }
 
-static bool map_pte(struct page_vma_mapped_walk *pvmw, spinlock_t **ptlp)
+static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
+		    spinlock_t **ptlp)
 {
 	pte_t ptent;
 
@@ -25,6 +26,7 @@ static bool map_pte(struct page_vma_mapp
 		return !!pvmw->pte;
 	}
 
+again:
 	/*
 	 * It is important to return the ptl corresponding to pte,
 	 * in case *pvmw->pmd changes underneath us; so we need to
@@ -32,8 +34,8 @@ static bool map_pte(struct page_vma_mapp
 	 * proceeds to loop over next ptes, and finds a match later.
 	 * Though, in most cases, page lock already protects this.
 	 */
-	pvmw->pte = pte_offset_map_nolock(pvmw->vma->vm_mm, pvmw->pmd,
-					  pvmw->address, ptlp);
+	pvmw->pte = pte_offset_map_rw_nolock(pvmw->vma->vm_mm, pvmw->pmd,
+					     pvmw->address, pmdvalp, ptlp);
 	if (!pvmw->pte)
 		return false;
 
@@ -67,8 +69,13 @@ static bool map_pte(struct page_vma_mapp
 	} else if (!pte_present(ptent)) {
 		return false;
 	}
+	spin_lock(*ptlp);
+	if (unlikely(!pmd_same(*pmdvalp, pmdp_get_lockless(pvmw->pmd)))) {
+		pte_unmap_unlock(pvmw->pte, *ptlp);
+		goto again;
+	}
 	pvmw->ptl = *ptlp;
-	spin_lock(pvmw->ptl);
+
 	return true;
 }
 
@@ -278,7 +285,7 @@ restart:
 			step_forward(pvmw, PMD_SIZE);
 			continue;
 		}
-		if (!map_pte(pvmw, &ptl)) {
+		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
 				goto restart;
 			goto next_pte;
@@ -305,8 +312,13 @@ next_pte:
 		} while (pte_none(ptep_get(pvmw->pte)));
 
 		if (!pvmw->ptl) {
+			spin_lock(ptl);
+			if (unlikely(!pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))) {
+				pte_unmap_unlock(pvmw->pte, ptl);
+				pvmw->pte = NULL;
+				goto restart;
+			}
 			pvmw->ptl = ptl;
-			spin_lock(pvmw->ptl);
 		}
 		goto this_pte;
 	} while (pvmw->address < end);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


