Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDFB19B5A3
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774630834; cv=none; b=k7g1XdUaeRYDzh0FgiwyfW7G1G/NtP7n+11ABfG9oq7bV4RZJL9QrvCtKCpVfBoICbxbaDiw9rzrkf7k5PwMK/oU7D+phxHZL0okcsANSo0KcxcQHOHutvcB+BwlXBV40DeYp0v936ZM2+s6dz2uRu+vdufpBQAko4hywSXi5FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774630834; c=relaxed/simple;
	bh=uP60itY+rdcgJULT8hJ21xs4zUPNhVhHg5C60zD+1YA=;
	h=Date:To:From:Subject:Message-Id; b=fPGL6/u8qMWTMNbZ/Sgr9zFKFshp5jSz4dscz8ZxLQLpUU73RL3zHOSqzT1TGUhxtdmg/vxTEp1IJZi5hOJq83CJ7QHtS+CmNzvLtYYj8gD2yk0oa0dNaktcIi2rZiFiM6RuZ1VQj/vb+cSD3k0aHlW3Vh0hgQtZwDwXxchQQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xz8+1kvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xz8+1kvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54C3C19423;
	Fri, 27 Mar 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774630834;
	bh=uP60itY+rdcgJULT8hJ21xs4zUPNhVhHg5C60zD+1YA=;
	h=Date:To:From:Subject:From;
	b=xz8+1kvhQXrBl3ROKTvqn2668feCJNCgv56+dmZsuNL7y88rb16MfNKSCCtY+AAHr
	 6Mc3vUsRSYigNZdux7ZiQ7Uj/IBZ+0BedKKIavYxkcYg/IssXkSLraYTr+GyONiTgQ
	 JW5qmIsYoSFWNuAHPJv+01cgdATsC0PrKhPxw2ik=
Date: Fri, 27 Mar 2026 10:00:33 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch added to mm-new branch
Message-Id: <20260327170033.E54C3C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
Date: Thu, 26 Mar 2026 01:08:33 -0700

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.  Replace vma_start_write() in
collapse_huge_page().

Link: https://lkml.kernel.org/r/20260326080836.695207-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1166,7 +1166,10 @@ static enum scan_result collapse_huge_pa
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
_

Patches currently in -mm which might be from surenb@google.com are

mm-vma-cleanup-error-handling-path-in-vma_expand.patch
mm-use-vma_start_write_killable-in-mm-syscalls.patch
mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch

