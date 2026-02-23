Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF231E515
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866973; cv=none; b=k0rc0f9OKRm+N7mYFUiot1guNWunTMr3tiRp+q3uNpNUcbgcOSKqrMMnH5nYaSMbiPqu65AuM0ZMB3zJ/ZDnIibKQ0TZxtmVXBbgH4KRQdnx54pI2VKcc0YDn5SlEf+V48L1zG6zZ6jRrl4y5LwZKbpkkA0nBgBXNlGfjK/ZcFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866973; c=relaxed/simple;
	bh=US8+6sLsfUX6x8pMjI3ECHIIPcUIG59i/ZRKmIMuqME=;
	h=Date:To:From:Subject:Message-Id; b=kgvUmdTt6W+QAxAm8/VP1QkK/AbhD1KlT5tPeEpkVyREdCC26yRp3xFQ3wf+oCyC08MELN/DzRoaXcezB654TmQNfWiGKy5ptI9cCob2fBWmPCbOdvy7l/p3aLOKmolmZNamXhKx2h83YY8H9cVMC1CuuIKlw0qg31y86yLLY+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0HmS2Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0HmS2Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F134C116C6;
	Mon, 23 Feb 2026 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771866973;
	bh=US8+6sLsfUX6x8pMjI3ECHIIPcUIG59i/ZRKmIMuqME=;
	h=Date:To:From:Subject:From;
	b=r0HmS2Yepkn7WoX8MBOkfFKvPfrcovzdqvU/q5Tq9htlpwBXapYcaAkYwNcvZnbaR
	 Kn2BiPWWf38JYEwpxvyFL+mprx8Hp0bNL7jutSohKBLSn2lXzZJrv1t/+sfE0rIcDl
	 li8SUAG+RQ/1AvrLm7ofoksNBO1mRxZjuEJcbKx0=
Date: Mon, 23 Feb 2026 09:16:12 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch added to mm-unstable branch
Message-Id: <20260223171613.2F134C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()
Date: Mon, 23 Feb 2026 17:39:20 +0100

We still mention compound_mapcount() in two comments.

Instead of simply referring to the folio mapcount in both places, let's
factor out the odd-looking PTL sync into sync_with_folio_pmd_zap(), and
add centralized documentation why this is required.

Link: https://lkml.kernel.org/r/20260223163920.287720-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |   19 +++++++++++++++++++
 mm/memory.c          |    8 +-------
 mm/page_vma_mapped.c |   11 ++---------
 3 files changed, 22 insertions(+), 16 deletions(-)

--- a/mm/internal.h~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/internal.h
@@ -516,6 +516,25 @@ void free_pgtables(struct mmu_gather *tl
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
+/**
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * @mm: The mm_struct.
+ * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ *
+ * When we stumble over a pmd_none() without holding the PTL while unmapping a
+ * folio that could have been mapped at that PMD, it could be that concurrent
+ * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
+ * already, the folio might still appear to be mapped (folio_mapped()).
+ *
+ * Wait for concurrent zapping to complete by grabbing the PTL.
+ */
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+{
+	spinlock_t *ptl = pmd_lock(mm, pmdp);
+
+	spin_unlock(ptl);
+}
+
 struct zap_details;
 void unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
--- a/mm/memory.c~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/memory.c
@@ -1993,13 +1993,7 @@ static inline unsigned long zap_pmd_rang
 		} else if (details && details->single_folio &&
 			   folio_test_pmd_mappable(details->single_folio) &&
 			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
-			/*
-			 * Take and drop THP pmd lock so that we cannot return
-			 * prematurely, while zap_huge_pmd() has cleared *pmd,
-			 * but not yet decremented compound_mapcount().
-			 */
-			spin_unlock(ptl);
+			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
 		if (pmd_none(*pmd)) {
 			addr = next;
--- a/mm/page_vma_mapped.c~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/page_vma_mapped.c
@@ -269,11 +269,6 @@ restart:
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			/*
-			 * If PVMW_SYNC, take and drop THP pmd lock so that we
-			 * cannot return prematurely, while zap_huge_pmd() has
-			 * cleared *pmd but not decremented compound_mapcount().
-			 */
 			const softleaf_t entry = softleaf_from_pmd(pmde);
 
 			if (softleaf_is_device_private(entry)) {
@@ -284,11 +279,9 @@ restart:
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR)) {
-				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+			    (pvmw->nr_pages >= HPAGE_PMD_NR))
+				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-				spin_unlock(ptl);
-			}
 			step_forward(pvmw, PMD_SIZE);
 			continue;
 		}
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch

