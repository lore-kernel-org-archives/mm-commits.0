Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1081349B19
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622929; cv=none; b=TmcUxr11oa460POXDLYTFOCG5LWbUTM50ykv9qXM2prG88URXsBo3lJioAtrEqqmmgGQsezAXI8YjSt1dAboaLAzbwrK6/6GT51jI2L4z+H1GTXDFJ8eTIMIpD044SBGfMvT8l3YM2/0DiSCWcwiZh+k5IudN/BqGLYFRaSXThQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622929; c=relaxed/simple;
	bh=S1GA3g1j5SrTCj+WPlvdmWDEwGbok2lkDIcZamhsJBg=;
	h=Date:To:From:Subject:Message-Id; b=ehVmGYhQooVqqm0NA8p1Mu80beerh8+8LJ5KOlI+hGbq0vPtJFG/1bMwv9GomMCpfRUE8lAjUT0o1Cx4YlzhAEulWlLfhFC1+GVUWE+8kAudQJxdwA3a+B+D9ze2ddRopeHcHm34MoQnOiHpdGA7h82M45VtDbSv4pjYJRmc7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nApDtV7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nApDtV7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAC91F000E9;
	Tue, 25 Aug 2026 01:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622928;
	bh=yur6j9fCxTiv5LHS1U9VF6OTfs8+bCj3tZOjx11+5pc=;
	h=Date:To:From:Subject;
	b=nApDtV7RXJzZBk+xzGVUEqVNqGiwHuLuLONuJC43yyjCuPvp+6BThvSpN6XPQ94fJ
	 MjNjMikblH2Jcxe65hKV51HlIYElTS1VZD+7trtH+ez6OrcQn837MphXICGNUl7jQ4
	 yIXnL8WVee5GXKaeildab4TC9h3xsjT8ruRnWmR0=
Date: Mon, 24 Aug 2026 18:55:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch removed from -mm tree
Message-Id: <20260825015528.7DAC91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: extract reference check into folio_pte_referenced() helper
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[nico.pache@linux.dev: drop the trivial helper kerneldoc and inline marker per review]
  Link: https://lore.kernel.org/9038f552-926b-4c4c-b023-69271f45e3d5@linux.dev
Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper
+++ a/mm/khugepaged.c
@@ -672,6 +672,16 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+static bool folio_pte_referenced(struct folio *folio,
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
@@ -810,14 +820,8 @@ static enum scan_result __collapse_huge_
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
 
@@ -1766,14 +1770,8 @@ static enum scan_result collapse_scan_pm
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


