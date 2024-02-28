Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3D71EBD
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146487; cv=none; b=uPVup2pmxD7Wr91SErc+md0XxXn3q0TLjQR2TT2vEbFmsZ7DEJmXlj/5hGCvlKQ/a1b8RSU1V+CcvJaGzvH2/e2HfCz6F7p/qdv2ID1tBMPA3XTtlu8kTCCVPuT4orFzBjaVUCXBWkLb+AZMghINEB/rQ0x+yFlo85fr4NucmAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146487; c=relaxed/simple;
	bh=ayWSPvuwFNqG6gk48bBAmQTrVnDtEiWKRS+EisQvHeM=;
	h=Date:To:From:Subject:Message-Id; b=rsiSCmlQG0b/7o7onE0SmF7K7UJGwBGlB9gqXPCET/+hwYg2/ZeMaEs6v4xsr3oFiZw3LUv6aYnhHPRdI9mSFmmTIHnDEVuI/HvHfUbqhUIoYwvyUuypto17KxJnESKURhL5XEwIzRo3dN6tVpuHtS2jUe9RL/efxIO+SWlxBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DiMIXX3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DiMIXX3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED2AC433C7;
	Wed, 28 Feb 2024 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146487;
	bh=ayWSPvuwFNqG6gk48bBAmQTrVnDtEiWKRS+EisQvHeM=;
	h=Date:To:From:Subject:From;
	b=DiMIXX3kGkIYsA13T4ukkxvN+eP/Ti0/+68efWyDwdjVVNvRydw+mFH0RjKq7oTgq
	 eVgVUI01yzeuGb5+UC6yfZcU3kikVDnCWuRuUJtaYZgBRmQiJQozJXyF3tgIxwf3iR
	 Yj+8sLXsrKYlxAPRYVJ2s9jXTTozIwq4pKe3CLuI=
Date: Wed, 28 Feb 2024 10:54:46 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch added to mm-unstable branch
Message-Id: <20240228185447.1ED2AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory.c: do_numa_page(): remove a redundant page table read
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/memory.c: do_numa_page(): remove a redundant page table read
Date: Tue, 27 Feb 2024 19:41:51 -0800

do_numa_page() is reading from the same page table entry, twice, while
holding the page table lock: once while checking that the pte hasn't
changed, and again in order to modify the pte.

Instead, just read the pte once, and save it in the same old_pte variable
that already exists.  This has no effect on behavior, other than to
provide a tiny potential improvement to performance, by avoiding the
redundant memory read (which the compiler cannot elide, due to
READ_ONCE()).

Also improve the associated comments nearby.

Link: https://lkml.kernel.org/r/20240228034151.459370-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memoryc-do_numa_page-remove-a-redundant-page-table-read
+++ a/mm/memory.c
@@ -5127,18 +5127,18 @@ static vm_fault_t do_numa_page(struct vm
 	int flags = 0;
 
 	/*
-	 * The "pte" at this point cannot be used safely without
-	 * validation through pte_unmap_same(). It's of NUMA type but
-	 * the pfn may be screwed if the read is non atomic.
+	 * The pte cannot be used safely until we verify, while holding the page
+	 * table lock, that its contents have not changed during fault handling.
 	 */
 	spin_lock(vmf->ptl);
-	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+	/* Read the live PTE from the page tables: */
+	old_pte = ptep_get(vmf->pte);
+
+	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto out;
 	}
 
-	/* Get the normal PTE  */
-	old_pte = ptep_get(vmf->pte);
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 
 	/*
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch

