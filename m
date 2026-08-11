Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D4D37B41F
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472665; cv=none; b=rnkNV2RXK2o7JfGmqvXwilQwBFjHL9FIKLoHdBPYIrCoa6gTcSc6wExFJKLvGvtPdjU7Xk068KphD2G2a1aYQaXi9E1PuZCSF+Lj0/rcl8UjWmYK1EwUNSD0gwJoopscoNUv+Rkb1jlaMAg6gTh8Ke2aJJ56G2k/XQGAiy4qXQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472665; c=relaxed/simple;
	bh=xW7tfUwd5evgg9uMKE9iYyRSrDJYknRTne2D77WXQIE=;
	h=Date:To:From:Subject:Message-Id; b=KeaLKr/ASUZdsbx1Fxg4mgQv97IPjJdHa8GK9WFBxr6HK0+L8nioDWj6OiKFE+szFULoi7bx9RALIOGJCk3AG59sSbOwYA5er7aiBEvdlaDw55xU/PQXPi68qmOiUm3XVdZmitppqnfS5psjFgiRpsm5CuicChxhr2/F8Kyz9NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cu/0d4d6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cu/0d4d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912D41F000E9;
	Tue, 11 Aug 2026 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472663;
	bh=khH1rnSYIujIgvyKbjVbX5Fi2bBGKoLLrFrwRFQ1czI=;
	h=Date:To:From:Subject;
	b=Cu/0d4d6ZEkeQIYQq4hR/HXaiozr4Prb5lH9ZsuRbY9CJvCM3KP6LUAK4mv0FaBka
	 vawvBSRtZ6ETRdAjzFJgVpZwXfEzoiPoVdLQsjRZt+7VNcdG56T7HcF/zYULlLzZTU
	 qjeEz9sLFcbErosiuGmPCLnufKfXEybaJNn87Lrk=
Date: Tue, 11 Aug 2026 11:24:23 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch added to mm-unstable branch
Message-Id: <20260811182423.912D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: extract reference check into folio_pte_referenced() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch

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
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: extract reference check into folio_pte_referenced() helper
Date: Tue, 11 Aug 2026 06:48:34 -0600

This change deduplicates the "is this PTE/folio referenced enough to be
considered for a collapse" condition that was repeated in both
__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
a single inline helper function.

Also move the comment and use it as the function header.  While we are at
it, updated the comment to clarify that a young pte is a recently accessed
one.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper
+++ a/mm/khugepaged.c
@@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+/*
+ * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
+ *
+ * Return: true if recent access was observed through either the folio state
+ * or the current PTE mapping.
+ */
+static inline bool folio_pte_referenced(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
+{
+	/* The folio was referenced previously ... */
+	if (folio_test_young(folio) || folio_test_referenced(folio))
+		return true;
+	/* ... or the PTE mapping was recently used */
+	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -810,14 +826,8 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
@@ -1766,14 +1776,8 @@ static enum scan_result collapse_scan_pm
 			goto out_unmap;
 		}
 
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

