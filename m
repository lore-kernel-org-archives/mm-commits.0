Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE9412E1FA
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969885; cv=none; b=rEvvJ22xyp0bULhZ1+L/QtE8TbHsETOqODxyVXLhKUg4fFd1tp9k25zp3ZqtK8mjuSzNBSckUIXC1xEZdgdsbjQRtWHsAohMdz3lELvN6z0M8uhIlHkvDOq5rwG1LH3Jeled75VU2UoRAbSfCWTbdyna0y8PpBvgDQh1872SnUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969885; c=relaxed/simple;
	bh=i7vCEEJlKp05q8MHaKr406SLLGgJAiIX/wcz/EKCg2M=;
	h=Date:To:From:Subject:Message-Id; b=iV/3xjEQTnD8qNAinpmirC48deQbgtpQ8Nua0ATNWFmEWK0GYStmkIJ74cF1/dnQBeXuwvEzf+Wfx+XWHVcCf71aIxBBpesDvw/YbysWGDvIyNas0lqNbz2EWh/pR+/YjjFVgt4tQeVJquX/ANyHA/t2nVGEnP4KbcWLLJlgoLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4G8QkM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4G8QkM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C173EC433F1;
	Mon, 26 Feb 2024 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708969884;
	bh=i7vCEEJlKp05q8MHaKr406SLLGgJAiIX/wcz/EKCg2M=;
	h=Date:To:From:Subject:From;
	b=V4G8QkM6Fcbln0E6AeGwLSCzH+6ul2A2wEO6UE5RMLUDRqPhgnqrfQUM5lrG9EnS+
	 o4ppfD9AQ85eh/pUwpUUGAieIgl3Eo2pSTAr+utvYPWVoxmq+QCFlKGK2ycxf+vmqK
	 NQrxMuL6seIGzEUNhzPpHNHCa/mirvFiHHBtGw+8=
Date: Mon, 26 Feb 2024 09:51:23 -0800
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,david@redhat.com,catalin.marinas@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch added to mm-unstable branch
Message-Id: <20240226175124.C173EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: improve comment in contpte_ptep_get_lockless()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: improve comment in contpte_ptep_get_lockless()
Date: Mon, 26 Feb 2024 12:03:21 +0000

Make clear the atmicity/consistency requirements of the API and how we
achieve them.

Link: https://lore.kernel.org/linux-mm/Zc-Tqqfksho3BHmU@arm.com/
Link: https://lkml.kernel.org/r/20240226120321.1055731-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-mm-improve-comment-in-contpte_ptep_get_lockless
+++ a/arch/arm64/mm/contpte.c
@@ -183,16 +183,20 @@ EXPORT_SYMBOL_GPL(contpte_ptep_get);
 pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 {
 	/*
-	 * Gather access/dirty bits, which may be populated in any of the ptes
-	 * of the contig range. We may not be holding the PTL, so any contiguous
-	 * range may be unfolded/modified/refolded under our feet. Therefore we
-	 * ensure we read a _consistent_ contpte range by checking that all ptes
-	 * in the range are valid and have CONT_PTE set, that all pfns are
-	 * contiguous and that all pgprots are the same (ignoring access/dirty).
-	 * If we find a pte that is not consistent, then we must be racing with
-	 * an update so start again. If the target pte does not have CONT_PTE
-	 * set then that is considered consistent on its own because it is not
-	 * part of a contpte range.
+	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
+	 * so that it is self-consistent, without the PTL held, so we may be
+	 * racing with other threads modifying the pte. Usually a READ_ONCE()
+	 * would suffice, but for the contpte case, we also need to gather the
+	 * access and dirty bits from across all ptes in the contiguous block,
+	 * and we can't read all of those neighbouring ptes atomically, so any
+	 * contiguous range may be unfolded/modified/refolded under our feet.
+	 * Therefore we ensure we read a _consistent_ contpte range by checking
+	 * that all ptes in the range are valid and have CONT_PTE set, that all
+	 * pfns are contiguous and that all pgprots are the same (ignoring
+	 * access/dirty). If we find a pte that is not consistent, then we must
+	 * be racing with an update so start again. If the target pte does not
+	 * have CONT_PTE set then that is considered consistent on its own
+	 * because it is not part of a contpte range.
 	 */
 
 	pgprot_t orig_prot;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

arm64-mm-export-contpte-symbols-only-to-gpl-users.patch
arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch

