Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A1937DE84
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472674; cv=none; b=aLn8hLuWo34UJxyBLov0AGyaHa+nWCjNY4Zsbd/QdaNu8blL1UilTFIsf3jSfi1K0KF1c6GJv5AJC6i7FjnRI4LKGM1UjOw3oHywiTbf48THPu1GALdYiZzG1rHJ/azTzXoBCT4WGZRyNJN6mpg+IR2f/oxwZ9FH/YLw1UsUrIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472674; c=relaxed/simple;
	bh=8q9HL3f7wpRLIYErxnRQn5s/hM6JZ27+1WXtned6mh0=;
	h=Date:To:From:Subject:Message-Id; b=jJaUfrYDVbr8mbDVNHA18QGdS6q088wICmvcnsoicnreT2oDPs9iSlqfukFHBN0cziyH/nYR37V0r9XvNEgNBa9b42Z0v0Frh6FCIAJQ21EUYOvjnm+AUNDoMgWf6t8HRYAV7JVRgo1HpcXTBh1jCA7/jeQEx81OX+yRIiCsq+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWrHNDq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWrHNDq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA011F000E9;
	Tue, 11 Aug 2026 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472672;
	bh=93aLmf6PJEbkgSgZlqMYVZV7b9z8xvDT6DDrbT48I5s=;
	h=Date:To:From:Subject;
	b=GWrHNDq2sa5NvejNr3aPcCR+waY9zumdgtKm1Lki058gYwmLzEF7VKPAuWBvie6Rc
	 ITTUJaJ5upIVEdCeZlyfYy7HSN0Nn0DkVi8rcJi4Q3hVwtH3tOo9MivG9gdMBA79nG
	 JTEByI1ere0TJLo2PVv63n68BQERJLuhdx7sT1B8=
Date: Tue, 11 Aug 2026 11:24:32 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch added to mm-unstable branch
Message-Id: <20260811182432.8BA011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: unmap pte before releasing vma write lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch

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
Subject: mm/khugepaged: unmap pte before releasing vma write lock
Date: Tue, 11 Aug 2026 06:48:38 -0600

We are currently dropping the anon_vma write lock before unmapping the
PTE.  Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
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
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-unmap-pte-before-releasing-vma-write-lock
+++ a/mm/khugepaged.c
@@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_pa
 
 	result = SCAN_SUCCEED;
 out_up_write:
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
 	if (pte)
 		pte_unmap(pte);
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

