Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3334263C9E
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313169; cv=none; b=i1pq5jCx3rPcv4ZxYe22vfLheJgc2BBopxpuV2SozKI/cFRictgmGB0VC5Qcq7r2Xw+6/nAWH4qGSJQcuoAyqPOtsJ3a5Qjecfm0PyW6SszSOX2zlN2rXM4q+LhxEY5EMAteWpA2UzVqGlyjXtd5QZEaKZaCFrRPbqLTyfRyaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313169; c=relaxed/simple;
	bh=86QMwVjL/YRHuIYSQwlWmaX880QJOwcv81C29jRqApA=;
	h=Date:To:From:Subject:Message-Id; b=SHaKDyM088ZwWS9VWlq9BLzCjNI/leRhR8V2+81wbQ+cAeWrh7bOLkbXMuEbCT13CoIwicXQSyU4xxjDgvucgA4n/EYplaTNWxTi5TrPlp5G9bk+jxengLWGDGL7DCrGRUShYgn17Z+hABYLMTcwEOeotmXSKEhWVKxeH8nvXiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZjGM2Uo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZjGM2Uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41662C4CEF0;
	Fri, 19 Sep 2025 20:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758313168;
	bh=86QMwVjL/YRHuIYSQwlWmaX880QJOwcv81C29jRqApA=;
	h=Date:To:From:Subject:From;
	b=pZjGM2UotASvVgj4wCemK2VD8SLNrzf2qpEeaw6ixSKWyrcv0ythv4Jz3bz00e1lf
	 y8XbmNl+toY4gWKWHGiIyRHGdtVaDweuGgw4mztOYp4W6p9BW0rM3NJMr31JhgzcAO
	 4VyzTc0FEfjeg8i5ORGXREqvVj6eU9xmQQ1/XqlQ=
Date: Fri, 19 Sep 2025 13:19:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch added to mm-unstable branch
Message-Id: <20250919201928.41662C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix a mlock race condition in folio_referenced_one()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: fix a mlock race condition in folio_referenced_one()
Date: Fri, 19 Sep 2025 13:40:33 +0100

The mlock_vma_folio() function requires the page table lock to be held in
order to safely mlock the folio.  However, folio_referenced_one() mlocks a
large folios outside of the page_vma_mapped_walk() loop where the page
table lock has already been dropped.

Rework the mlock logic to use the same code path inside the loop for both
large and small folios.

Use PVMW_PGTABLE_CROSSED to detect when the folio is mapped across a page
table boundary.

Link: https://lkml.kernel.org/r/20250919124036.455709-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   57 ++++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one
+++ a/mm/rmap.c
@@ -850,34 +850,34 @@ static bool folio_referenced_one(struct
 {
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	int referenced = 0;
-	unsigned long start = address, ptes = 0;
+	int ptes = 0, referenced = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			if (!folio_test_large(folio) || !pvmw.pte) {
-				/* Restore the mlock which got missed */
-				mlock_vma_folio(folio, vma);
-				page_vma_mapped_walk_done(&pvmw);
-				pra->vm_flags |= VM_LOCKED;
-				return false; /* To break the loop */
-			}
+			ptes++;
+			pra->mapcount--;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
 			/*
-			 * For large folio fully mapped to VMA, will
-			 * be handled after the pvmw loop.
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
 			 *
-			 * For large folio cross VMA boundaries, it's
-			 * expected to be picked  by page reclaim. But
-			 * should skip reference of pages which are in
-			 * the range of VM_LOCKED vma. As page reclaim
-			 * should just count the reference of pages out
-			 * the range of VM_LOCKED vma.
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
 			 */
-			ptes++;
-			pra->mapcount--;
-			continue;
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				continue;
+
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
 		}
 
 		/*
@@ -913,23 +913,6 @@ static bool folio_referenced_one(struct
 		pra->mapcount--;
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) &&
-			folio_test_large(folio) &&
-			folio_within_vma(folio, vma)) {
-		unsigned long s_align, e_align;
-
-		s_align = ALIGN_DOWN(start, PMD_SIZE);
-		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
-
-		/* folio doesn't cross page table boundary and fully mapped */
-		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
-			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma);
-			pra->vm_flags |= VM_LOCKED;
-			return false; /* To break the loop */
-		}
-	}
-
 	if (referenced)
 		folio_clear_idle(folio);
 	if (folio_test_clear_young(folio))
_

Patches currently in -mm which might be from kas@kernel.org are

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

