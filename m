Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6087320F
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741671082; cv=none; b=VV4Qb7g8E08IJe9PRvUtuh13+FftBQFU7YXSltqW937+mQRreZ/NNUJuu5zEH+M64jj9JPHrWm8kPXjrXGZjm4FNIULFxw3jjVdXonUyb+OohPNjB0tm3HdW5GZI5QCcVxEs/wP0VkwMctRzCGfAkoq9V36YLsWkgxdGigp6TxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741671082; c=relaxed/simple;
	bh=Zolem5RMxkxaH7IRt99CYLBmNZxfIupuWFOD5ALzlLo=;
	h=Date:To:From:Subject:Message-Id; b=r9/lB/KF3I/Sb50FXc/HqSPX44PUIPu2l3SYmdJuBJLuZZ9s9OxAb1BX16UIaPxRO1W4gReX+Dns6l1fkFU4gqJBJ3D96T3Bqcd/ksdYtjIFkQee1Ar0kFVxrHOxOBb1x8+3MfLbAOWjeK1FrN0BcUU7zemHaD3gxe9hs3tqG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rZyVZ2Av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rZyVZ2Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0954AC4CEE9;
	Tue, 11 Mar 2025 05:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741671082;
	bh=Zolem5RMxkxaH7IRt99CYLBmNZxfIupuWFOD5ALzlLo=;
	h=Date:To:From:Subject:From;
	b=rZyVZ2AvYspdj51b4flIS3NpEa9FXh9/cSfyKXdOCdqGgAFm5LPMTlS43V+Y9hb1z
	 ghfk8DZcXCaqZ5qL6jR51kmAE4IfTACwrgMqTVever4+BLdz6t2U0KWdfCLhd0u8iP
	 8xX8I9RRPfNRMUb0peCPa3Zl3KMpSHhMK1+eWHuE=
Date: Mon, 10 Mar 2025 22:31:21 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,lorenzo.stoakes@oracle.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch added to mm-unstable branch
Message-Id: <20250311053122.0954AC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use ptep_get() instead of directly dereferencing pte_t*
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

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
Subject: mm: use ptep_get() instead of directly dereferencing pte_t*
Date: Mon, 10 Mar 2025 14:04:17 +0000

It is best practice for all pte accesses to go via the arch helpers, to
ensure non-torn values and to allow the arch to intervene where needed
(contpte for arm64 for example).  While in this case it was probably safe
to directly dereference, let's tidy it up for consistency.

Link: https://lkml.kernel.org/r/20250310140418.1737409-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-use-ptep_get-instead-of-directly-dereferencing-pte_t
+++ a/mm/migrate.c
@@ -202,7 +202,7 @@ static bool try_to_map_unused_to_zeropag
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
+	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch
mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

