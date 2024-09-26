Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2301411EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382764; cv=none; b=YvBFhrrqznaTqEUEsZ5SiGNAho3A0b+dA2iMI3/zSMOXS5jizD5lWDFlSP/FtiwkL4SulSlF2uRw2ZJwAMRYgb7LiRzePtKBQEv25n6uGOW8S8DHCofvSDs8mW3W03g4Jii1DZZEnaOtiZ8lwPxqFGbF59RqrpbTgza1rVrgquc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382764; c=relaxed/simple;
	bh=OUJ5KyItEXEJ1qZ44qUiX2ixjW+ZOLP6+ZPtS913zdc=;
	h=Date:To:From:Subject:Message-Id; b=Z4lnwG1GoSPNVEFUuMZnPI8z5IRlUieleCTC6O7egvkI5qFpADCASUcB82KODLt7U1DldnMuO5wBoniFrwJDPheohFbsBWcUjZa4ZDUuUeIRjZ5K2aVhsPdCw9VGPSocmykuNrll5UY9PeNYKFQtCqiL6VN1qqP39M5rPV1RZb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pfD8RqIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pfD8RqIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049F9C4CEC5;
	Thu, 26 Sep 2024 20:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382764;
	bh=OUJ5KyItEXEJ1qZ44qUiX2ixjW+ZOLP6+ZPtS913zdc=;
	h=Date:To:From:Subject:From;
	b=pfD8RqIiKzkgj988H0z2Mcp/mHMLR0HrJbS7HeZol/lgoCHEacIXH5lfPxZ+6o8g0
	 jbGj3uI5Lcc1+yGuEAm4QRHO672CcD3zk8P0+Cuf1x9OZQbnnaevUeK4HcCurhCtZT
	 RybOiaZ62zlGPVfRfRPxCVbtwihxfJ9+Ny1uZBTM=
Date: Thu, 26 Sep 2024 13:32:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203244.049F9C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_vma_mapped_walk: map_pte() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch

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

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

