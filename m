Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B630B21FF3B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085526; cv=none; b=cidTShA7CMRMTuuuTo2QvXRXO+RpP78pQTOa1SbF/JKg6sDCC3ImWvKYXlxzrr+BkwgKYqqafgdvbhY7epB1hDi2GMai4z4kUvU8BgBNBXJwYEGgMiRlGw14fBtTmNFVKVSoR6cLILJxkEA+dYMKO/8wE6T+xevMC54OsG937Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085526; c=relaxed/simple;
	bh=U2xiOx0W3iNEHnwzf5gp/3QZGcuHKLegYEL7xjri820=;
	h=Date:To:From:Subject:Message-Id; b=U+CsEtjYGlYA74+2Z/6FZTjhkS25n32BHi5+InKkFS8iFu19+mvAEmIM0RharsHHYANOgHQGAClggGF3EgczXr/EPgwLHox6AUDSPLRJQFQNpk9Cb+8+Nx33jhQAPD0exDX8sKRQHppnkxUCSgslPUmeULUBuTVG99QKWMdJHmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1dLIHQV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1dLIHQV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E08C4CEF0;
	Sun, 28 Sep 2025 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085526;
	bh=U2xiOx0W3iNEHnwzf5gp/3QZGcuHKLegYEL7xjri820=;
	h=Date:To:From:Subject:From;
	b=1dLIHQV1yBk/TMlA2gfO9UoDYyBtezLcyPmM8Nr0xdOkUSZ7luHkIw2l/2n663c3T
	 m5Edn2KkOCreEHdyAlVZhTJy9TPEamaFVsRUTBc7fhH+c8EOAvCxVFx/uqOvyVHh4Z
	 LEaTcTq3JiwaHskd7iIfSWf2NjPGFks7DlPxINLU=
Date: Sun, 28 Sep 2025 11:52:06 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch removed from -mm tree
Message-Id: <20250928185206.88E08C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix a mlock race condition in folio_referenced_one()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: fix a mlock race condition in folio_referenced_one()
Date: Tue, 23 Sep 2025 12:07:07 +0100

The mlock_vma_folio() function requires the page table lock to be held in
order to safely mlock the folio.  However, folio_referenced_one() mlocks a
large folios outside of the page_vma_mapped_walk() loop where the page
table lock has already been dropped.

Rework the mlock logic to use the same code path inside the loop for both
large and small folios.

Use PVMW_PGTABLE_CROSSED to detect when the folio is mapped across a page
table boundary.

[akpm@linux-foundation.org: s/CROSSSED/CROSSED/]
Link: https://lkml.kernel.org/r/20250923110711.690639-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
+			if (pvmw.flags & PVMW_PGTABLE_CROSSED)
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


