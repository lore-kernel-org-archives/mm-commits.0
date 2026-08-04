Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2923BD05
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 23:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785885141; cv=none; b=oVDSjFSWDZR4nmb09bdh7jOz95UfK6HUZfvXI9of9iBG2+D7t2aL4jKV76maFesBxr4m8Q0SQMiTiq+WuPQjbP9KkNlglS0DJnryGyLLHz/X5ceKKKGaGoqTZKo40xJdrkzQajU9tdSVlhUjlhW6exHEGb3UAJsfmIDGeBsJ4xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785885141; c=relaxed/simple;
	bh=f6bIkC9dcJi2ntH8uaizvwcvqrFW/MqMDoeluMgOzRY=;
	h=Date:To:From:Subject:Message-Id; b=DoihKUOQsEE5/j9rqFGpWubabGpHXdBOELz93agb8koVYT1slPie8U9DTrTorc2pLNIaKzOBzRjANeW5pmVjtjAw2fWHwXtQbHDTs6S9p/eZJo39bEstYuqbQCHCwd1hie952qv5Tsa8A5mSvKSw5nSjT4tsrLbO2PORQeJNPTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oAoVxydD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAoVxydD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A71F000E9;
	Tue,  4 Aug 2026 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785885139;
	bh=g+p4jAJSQyec0uqOT/mnpfAmQ70Ud1LDLtMS7DjDnnM=;
	h=Date:To:From:Subject;
	b=oAoVxydDdfIfWUfOg3V2lefOp9zbovIAvyKtVhbx4JClrz1KZJe2f1r0LMBsEsLK3
	 wARPdKwSe3lJAfJhUhYkJACY8huQEFGLk8OJfxgWJGoDEYu0P1vlDG3lOLmV6DMb1a
	 WH18NX2sBbDoXMIPrFHi8HyDKMDi09QTeiVmjpEI=
Date: Tue, 04 Aug 2026 16:12:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch added to mm-new branch
Message-Id: <20260804231219.959A71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: extract young page check into pte_is_referenced() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/khugepaged: extract young page check into pte_is_referenced() helper
Date: Tue, 04 Aug 2026 13:25:00 -0600

This change deduplicates the "is this PTE/folio referenced enough to be
considered for a collapse" condition that was repeated in both
__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
a single inline helper function.

Also move the comment and use it as the function header.  While we are at
it, updated the comment to clarify that a young pte is a recently accessed
one.

Link: https://lore.kernel.org/20260804-khugepaged_pte_refactor-v3-2-0364cad642a0@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/khugepaged.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper
+++ a/mm/khugepaged.c
@@ -672,6 +672,23 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+/*
+ * pte_is_referenced() - Check for enough referenced PTEs to justify collapsing
+ *
+ * If collapse was initiated by khugepaged, check that the page has been
+ * recently accessed (young pte) to justify collapsing the page.
+ *
+ * Return: true if the page has been recently accessed.
+ */
+static inline bool pte_is_referenced(struct collapse_control *cc, pte_t pteval,
+	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
+{
+	return cc->is_khugepaged &&
+	       (pte_young(pteval) || folio_test_young(folio) ||
+		folio_test_referenced(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr));
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -810,14 +827,7 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (pte_is_referenced(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 
@@ -1766,14 +1776,7 @@ static enum scan_result collapse_scan_pm
 			goto out_unmap;
 		}
 
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (pte_is_referenced(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

