Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9981224C071
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 23:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847296; cv=none; b=lAjRBHGqHCUXVKLesr6SN9ze4Rvn+WjbLTnb2dEU7a95/TtB1Om/JyK1MxKsyJnSGZnWU5z96XNASYBv4lYxDJOSc5wT3EZ75v+1G7q4WNTx2aYyozI7dxtpbsKykXSgIAeVh+2veIrrE5EIqs/ZrE3MoHZhtjcAsoFU5rh1Ow4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847296; c=relaxed/simple;
	bh=whfw8crHzznhhpJTIFpk7neOv0tvxHDnX2rk0QG+fLM=;
	h=Date:To:From:Subject:Message-Id; b=J0vj+mhyK3S82NkFk2KQtUFa+Mls3qNubCqST67pRUGMpguNLUP7ztJudnKKAv6O303lg0Yd0XZVs1kGwfvvN4YfoE9NsOUQee/J9Cpf/lp3BlzHTw+gmFS+i0paaLn/o9TGg0BNAzPFUD+a96e6W5l2Y7q6UkjCiMkDhCXnWek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cV3oQoAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cV3oQoAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC974C4CEE2;
	Wed, 16 Apr 2025 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744847295;
	bh=whfw8crHzznhhpJTIFpk7neOv0tvxHDnX2rk0QG+fLM=;
	h=Date:To:From:Subject:From;
	b=cV3oQoAOhYdvE+LfRacAxsPd120j85BUkAJJGe3vAmv6lIn3+tx2n4iq9CutQ4qAW
	 hCjmB6u2HW4LeNIvfNFWDBLccLWPSCz6y7fFYF8FSn7cEzYXWmiNwk3zdys/8wJbE7
	 g6WIt3tQK0886yLPKbQDeTwjOFpOh0MSBNpaJWvQ=
Date: Wed, 16 Apr 2025 16:48:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch added to mm-new branch
Message-Id: <20250416234815.CC974C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy: optimize queue_folios_pte_range by PTE batching
has been added to the -mm mm-new branch.  Its filename is
     mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch

This patch will later appear in the mm-new branch at
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
From: Dev Jain <dev.jain@arm.com>
Subject: mempolicy: optimize queue_folios_pte_range by PTE batching
Date: Wed, 16 Apr 2025 11:00:48 +0530

After the check for queue_folio_required(), the code only cares about the
folio in the for loop, i.e the PTEs are redundant.  Therefore, optimize
this loop by skipping over a PTE batch mapping the same folio.

With a test program migrating pages of the calling process, which includes
a mapped VMA of size 4GB with pte-mapped large folios of order-9, and
migrating once back and forth node-0 and node-1, the average execution
time reduces from 7.5 to 4 seconds, giving an approx 47% speedup.

Link: https://lkml.kernel.org/r/20250416053048.96479-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mempolicy-optimize-queue_folios_pte_range-by-pte-batching
+++ a/mm/mempolicy.c
@@ -567,6 +567,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
+	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct vm_area_struct *vma = walk->vma;
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -574,6 +575,7 @@ static int queue_folios_pte_range(pmd_t
 	pte_t *pte, *mapped_pte;
 	pte_t ptent;
 	spinlock_t *ptl;
+	int max_nr, nr;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -587,7 +589,9 @@ static int queue_folios_pte_range(pmd_t
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
+	for (; addr != end; pte += nr, addr += nr * PAGE_SIZE) {
+		max_nr = (end - addr) >> PAGE_SHIFT;
+		nr = 1;
 		ptent = ptep_get(pte);
 		if (pte_none(ptent))
 			continue;
@@ -599,6 +603,10 @@ static int queue_folios_pte_range(pmd_t
 		folio = vm_normal_folio(vma, addr, ptent);
 		if (!folio || folio_is_zone_device(folio))
 			continue;
+		if (folio_test_large(folio) && max_nr != 1)
+			nr = folio_pte_batch(folio, addr, pte, ptent,
+					     max_nr, fpb_flags,
+					     NULL, NULL, NULL);
 		/*
 		 * vm_normal_folio() filters out zero pages, but there might
 		 * still be reserved folios to skip, perhaps in a VDSO.
@@ -631,7 +639,7 @@ static int queue_folios_pte_range(pmd_t
 		if (!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 		    !vma_migratable(vma) ||
 		    !migrate_folio_add(folio, qp->pagelist, flags)) {
-			qp->nr_failed++;
+			qp->nr_failed += nr;
 			if (strictly_unmovable(flags))
 				break;
 		}
_

Patches currently in -mm which might be from dev.jain@arm.com are

mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch

