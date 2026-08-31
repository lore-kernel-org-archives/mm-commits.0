Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BD36B926
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220346; cv=none; b=hjnFf6BuwH601T8iPJa21eIukybML85AHYr+tQfD+nnIIjBjfy5goCWKVJf5EsrzZ9aLbEvRHdFps+ywm5TErBS6wXgSS5RlDcgjQdTenynSfNbOdkrk4ji4f/PaKiTFkvIoaYvwvJMxZ/18r1u8isAV5tYNxP3m8Int3K11dX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220346; c=relaxed/simple;
	bh=onmcZWIve3AH+EheqNyL5mJtMy82gvuSsSi2SJP3hBY=;
	h=Date:To:From:Subject:Message-Id; b=rbSClK3nkXPIJlkkz4yExUh8MXW4FiMUsLnPOEHgPlDrlj9MlH15d01n9uru4Rnc7kHjQNpPEhoLB1XatqVxFlUbocwbW05vjJLAtulvcFEcAAo/3FqcS/f0DflSwMpYhqNsVb1ilccwLk0ttrC6HDmeO/i6SDo3swIx2Mj6DRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nmAiXOOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nmAiXOOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8101F000E9;
	Mon, 31 Aug 2026 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788220344;
	bh=NNlFuGRt1vf1sVnGlfi8ijRUO1E6t2JIyfUfK5I0mnU=;
	h=Date:To:From:Subject;
	b=nmAiXOOVlYLcRjKxSr2Z+3S8k34LYylvLG+dAe4+/QevmOoIknj2KK59RmupFMZqd
	 Z8War5cP5cuPRkYeXhJmQt8mWaxf1GF8kMYIxujv3O3Hn4cBnyYvBYhiYdPREWIq7q
	 8JAz63DtXY6e4Ft8ipf1+DZE5zV1QnmO8gAoeJEs=
Date: Mon, 31 Aug 2026 16:52:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kunwu.chan@gmail.com,jannh@google.com,harry@kernel.org,david@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch added to mm-new branch
Message-Id: <20260831235224.7E8101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: remove stale hugetlb check in try_to_unmap_one
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: remove stale hugetlb check in try_to_unmap_one
Date: Mon, 31 Aug 2026 08:28:47 +0000

Post commit d4ec5572825a ("mm/rmap: add
try_to_unmap_poisoned_hugetlb_one") try_to_unmap_one() cannot be called
with a hugetlb folio.  Therefore remove the folio_test_hugetlb() check.

Link: https://lore.kernel.org/20260831082849.3573957-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2297,11 +2297,8 @@ static bool try_to_unmap_one(struct foli
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio)) {
-			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		} else {
-			pteval = ptep_get(pvmw.pte);
-		}
+		pteval = ptep_get(pvmw.pte);
+
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-remove-stale-hugetlb-check-in-try_to_unmap_one.patch

