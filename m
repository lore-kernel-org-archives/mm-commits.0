Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268F3191D6
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472169; cv=none; b=EYcWKNHWtdedx9qO0u3mXQVhZChHxyofACXSuhzv3oH1S/RLr8dADZdua7BAih+FkLMBhUWQO13EXEw78d0DD1Ka166LSSDyjmuIl6X21fvoPO+w+RyUSG8/SS/0hsD2W3A2B+0DQnnbtxOad32kGzmvGJLXcPjRljJptet8CnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472169; c=relaxed/simple;
	bh=OhNPjNhrIrUngwbv5nP7JoasbQ7kZ4ByuuQDq5L3o9o=;
	h=Date:To:From:Subject:Message-Id; b=jQpXhY9zmrGVYrLyRC4xFHLTwZ/CrIH3ks29nSBmJAIzkWIL99HQ4kEYjx8HeWmcNI30h9ANHXRXatFs8BLMx7vncXHFS/JEwwayELEg5WvFxTx+TQyIaZ0MbYvpXXwFAr/sEiRuo4hYnFcE84q+n5yI2NHQ3rV4wHxNi4RAqF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQ7aPjXa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQ7aPjXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BA61F00A3A;
	Tue, 11 Aug 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472167;
	bh=YPdJu4UK1NEAcpFVZW4RI7NH2nRGV75pe65+TCHlXdY=;
	h=Date:To:From:Subject;
	b=CQ7aPjXadUWl43XzAdmNMqUln0FjCILnqb4Aul2UO4/LokbGlM8irbqhCJFewhXa0
	 IveZ+00QMFNF3J3HWHTiPfnnrUt3qVT25H6XkfFNTT67tmRZoMaNPhMxUI4RqbmMM0
	 DTjzigFj0ddmW3368mvA+r5Hb6eg9i52VoO18NxU=
Date: Tue, 11 Aug 2026 11:16:07 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch removed from -mm tree
Message-Id: <20260811181607.73BA61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: extract young page check into pte_is_referenced() helper
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-extract-young-page-check-into-pte_is_referenced-helper.patch

This patch was dropped because an updated version will be issued

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

mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

