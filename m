Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC1EFC1C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600585; cv=none; b=CAR4E182lDtBbxLtUuLP9gYeNyLs5Jsz213Pjtt463IUrDG9y0rndVO2Kg83oHJDIkVFD0COyun9HCJaqLt1a9hgoePTsHpv0zEF5YmRKPPAbDB2Hby/+xPV34bGrry4xgTA//GmqE77RreT7HsGID3suISijJhQ6R2JzAmPOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600585; c=relaxed/simple;
	bh=hN1GnKCDKhkuOvLMFFdqadZLquQLGMmo3tDJakBY1zQ=;
	h=Date:To:From:Subject:Message-Id; b=PYvAdj2/JAq/pkPtENc3qqdGa1H8m4aZx6UNdajLlrKvdsRjusCce6p6IkMpJwCVmC15AZLX5+D1D6Tg1dUs1xE6qzba7X7a2B0x7TUccubedUUY9bfaQ6Y/fu0slbhXJoiOf85W9R+UNX6pRLhPkON1K82cMOE+dQJz6RafcaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mV6szpOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mV6szpOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F845C433C7;
	Tue,  5 Mar 2024 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600585;
	bh=hN1GnKCDKhkuOvLMFFdqadZLquQLGMmo3tDJakBY1zQ=;
	h=Date:To:From:Subject:From;
	b=mV6szpOOUx4dKS2LGxCvTPji+NSxn4RuFiAvWygEsj7VE11vKQL2CgnnsSDsl5ABe
	 upmyDbiL9rxPc8MvCJu33vqu/k0g5j38G3uXNNTTUHVSNp2dUE1enlIALp4PsBtw/A
	 BBvLaM/i9yXEcqfbmijLMpYBsWCtzQIH3itDQOzs=
Date: Mon, 04 Mar 2024 17:03:04 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch removed from -mm tree
Message-Id: <20240305010305.2F845C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory.c: do_numa_page(): remove a redundant page table read
has been removed from the -mm tree.  Its filename was
     mm-memoryc-do_numa_page-remove-a-redundant-page-table-read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
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


