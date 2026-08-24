Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C334A76F
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787591395; cv=none; b=HGr2bHF6NCS7xeRs0cJyM8iSL+YawXWWxs7LnM3q7U+UzTvLzleNZt7ORWmLa2XEtuYOGZMNUMjSJfBjapo/30Y2/0NRl2tC/X0U9FhzeNBH4dHxT/C0A//IfaDO22/BhQaS5rmtK1Ifn+Mgzr3Q553zWmIbFph5/LSlJbHhfNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787591395; c=relaxed/simple;
	bh=oGsepphqX8YFDFiEJ3A5Tl9c/gy8XAyM03xEKEeMRsE=;
	h=Date:To:From:Subject:Message-Id; b=IMaoqq0P1pYp5KUzJnmQmfgxuOWsButCS95wCEn2VPnGaXfv8T/qRE+uW8H0tUSG25a+6TkiliWBTcvZORKkZ38nFk78MuZjPk1Yyud0WilZR9nhc4uJ/YNJE+o208R3EovshOixjO3C77cWXGiMyqBbQ8PdBEoAVVHhBqmHtkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=REh3cl5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="REh3cl5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5127C1F000E9;
	Mon, 24 Aug 2026 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787591386;
	bh=Cxj5/XiX1C95e9S9YhiNhwJO7twed99KsTIEY8aYT+c=;
	h=Date:To:From:Subject;
	b=REh3cl5N74iHKASiFA4yc9NHnQczJTRbIoY82OMpiyuTEET2gal6i1UNIykwylr/z
	 o6kLfBe47PUMwDl5S8lAnSLffh98IaxGq8NnncK1mgkPqw7+C1EIOsjChDFNmdaP6k
	 WDwY7FTf87EX1LBhKibROr+OeSSc4SMrm5jwOUB4=
Date: Mon, 24 Aug 2026 10:09:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch added to mm-unstable branch
Message-Id: <20260824170946.5127C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch

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

Author: Nico Pache (Red Hat) <nico.pache@linux.dev>
Subject: mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
Date:   Fri Aug 21 04:27:18 2026 -0600

drop the trivial helper kerneldoc and inline marker per review

Link: https://lore.kernel.org/9038f552-926b-4c4c-b023-69271f45e3d5@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
+++ a/mm/khugepaged.c
@@ -666,13 +666,7 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-/*
- * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
- *
- * Return: true if recent access was observed through either the folio state
- * or the current PTE mapping.
- */
-static inline bool folio_pte_referenced(struct folio *folio,
+static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

