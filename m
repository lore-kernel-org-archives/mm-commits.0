Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0573A784E;
	Sat, 17 Oct 2026 03:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792209206; cv=none; b=FLFH67zAGkaJ9WHR0b+I1hOhIXjGRmU2nNlqpFgEy9kpawSWOLemEqM10nMQNirQHmHGqf6+dC/iTEU4qXlWyrLipwhDoOZslXJUH5rPgkmEyy3zmd2CUKlRBZYuFoShnti2b0RbHPLBCVZ1q22wrxwkFLOcifZDd//VxFteCkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792209206; c=relaxed/simple;
	bh=uDbrNcn3PQrPLj24gmTqvEmzw2JSVOhrEXaGdzHE6fg=;
	h=Date:To:From:Subject:Message-Id; b=rfIAR+aiCxyEmcN1BqgQVsXVS8us5h0AtpsadnJ4Qc1MWnZ7/N58UUyZCsLfpkdb89SfZCj6QVOIBvT8patO/Dxive/tsFjbjNszcnlswjzevP2kZTsxZPJaB3zcLmRD0puuGKHblqsdprADEPA097j3JGrmGG557j6NBI6S5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mTFfIy9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mTFfIy9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF11F000C4;
	Sat, 17 Oct 2026 03:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792209204;
	bh=V9yVhW6LMS/FMKYEyK5kTFvzEQZl+6WYZRCcqXmu57k=;
	h=Date:To:From:Subject;
	b=mTFfIy9OYNJ1KNGSnG+m7ntWNFm9paO/gunUAOCDyhnuSpOh1EEo6K/3HwagTfLSW
	 JkUr5cEbzG/RGj7St6TYUUkXhUxgxhgL8pRalAGNCvB/gikCJD2xW1oeZtJY/CkizN
	 Cee6Atfl6qlIRdOJIlnw1XXcga5D5hq3Dwvg5CKs=
Date: Fri, 16 Oct 2026 20:53:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,kylebot@openai.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch added to mm-unstable branch
Message-Id: <20261017035324.33EF11F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_vma_mapped: continue past nonmatching huge PMDs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch

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
From: Kyle Zeng <kylebot@openai.com>
Subject: mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Thu, 15 Oct 2026 18:15:49 -0700

A PTE-mapped large folio can straddle PMD boundaries after an unaligned
mremap().  If the first part is discarded and replaced with an unrelated
huge PMD, page_vma_mapped_walk() stops instead of looking for the rest of
the folio in subsequent PMDs.

This also affects migration entries.  A walk that stops at an unrelated
huge PMD can leave migration PTEs behind when migration or an anonymous
folio split restores the mappings.  Those entries do not hold mapping
references and can outlive the source folio.

This issue can lead to memory corruption and I have a reproducer for
it.

Skip the current PMD rather than ending the walk on a flag or PFN
mismatch.  Do the same if the PMD became nonpresent before the locked
recheck.  Release the PMD lock, clear the per-PMD state and advance with
step_forward(), so the existing range limit controls termination.  This
covers present, migration and device-private huge PMDs while preserving
the matching-PMD and split-to-PTE paths.

Link: https://lore.kernel.org/20261016011549.61146-1-kylebot@openai.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_vma_mapped.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-continue-past-nonmatching-huge-pmds
+++ a/mm/page_vma_mapped.c
@@ -265,28 +265,28 @@ restart:
 				softleaf_t entry;
 
 				if (!(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (pmd_is_device_private_entry(pmde)) {
 				softleaf_t entry;
 
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (!pmd_present(pmde)) {
-				return not_found(pvmw);
+				goto next_pmd;
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			/* THP/device-private pmd was split under us: handle on pte level */
@@ -299,8 +299,7 @@ restart:
 			    (pvmw->nr_pages >= HPAGE_PMD_NR))
 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
@@ -343,6 +342,17 @@ next_pte:
 			pvmw->ptl = ptl;
 		}
 		goto this_pte;
+next_pmd:
+		/*
+		 * A large folio can be PTE-mapped across PMDs, so a
+		 * nonmatching PMD does not end the walk.
+		 */
+		if (pvmw->ptl) {
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		}
+		pvmw->pmd = NULL;
+		step_forward(pvmw, PMD_SIZE);
 	} while (pvmw->address < end);
 
 	return false;
_

Patches currently in -mm which might be from kylebot@openai.com are

mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch
mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch

