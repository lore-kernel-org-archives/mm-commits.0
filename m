Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6838834BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085538; cv=none; b=sCoFOquDxXMoA4pMW0w/lvlIB6mHP1ogL/dd5z7E8QaFneL52OVPQh9p9+iBWq0vMLUZCUTzc05TlsH+xb4d+5JYLb6e2aSIA/1SobIkaHYP13EAVI2k+1oOpH5n8niyDkSmEfQBJx/8LHUveaJ2wdRFq1uND85OutR5oG4B/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085538; c=relaxed/simple;
	bh=9d69grUgGDcYuhXLWAe5DX5BDjMpxT+gI6W1DkqXnR4=;
	h=Date:To:From:Subject:Message-Id; b=TF6gTO+7Llol7pDDpRuLekzhhV6Fu/GsZdFeA5uB5q0ggap9vNQ5Oop0BrnuYH3Fc0TMRXdeyQcdQH3V+vKiGeIA6C/Py/5f/imiyuLLPp9WM+EnBGk/idQpVMeQFUd3WVbkK1OJf+V46pZ2omp4ID0sn0rwZXdkvHnNnEt+qvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1wk1lpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1wk1lpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3508FC4CEF0;
	Sun, 28 Sep 2025 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085538;
	bh=9d69grUgGDcYuhXLWAe5DX5BDjMpxT+gI6W1DkqXnR4=;
	h=Date:To:From:Subject:From;
	b=z1wk1lpNy7D86K38QD+SndrciP1ku15pKupTzNeHDi4NROksr2Wm4GhYhjtJwqe4o
	 xCY5eYloBI6v9jXnjsXhCwcHw8UTmyDD4FnvfxP1cAeADOor4djINkEF8Autoux6AW
	 g71hZeJbrwV94YQOsU5hZ/kJwkpn9uECdhGr4puY=
Date: Sun, 28 Sep 2025 11:52:17 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch removed from -mm tree
Message-Id: <20250928185218.3508FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PMD alignment constraint in execmem_vmalloc()
has been removed from the -mm tree.  Its filename was
     mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: remove PMD alignment constraint in execmem_vmalloc()
Date: Thu, 18 Sep 2025 15:04:53 +0530

When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
to PMD_SIZE internally, if it deems huge mappings to be eligible. 
Therefore, setting the alignment in execmem_vmalloc is redundant.  Apart
from this, it also reduces the probability of allocation in case vmalloc
fails to allocate hugepages - in the fallback case, vmalloc tries to use
the original alignment and allocate basepages, which unfortunately will
again be PMD_SIZE passed over from execmem_vmalloc, thus constraining the
search for a free space in vmalloc region.

Therefore, remove this constraint.

Link: https://lkml.kernel.org/r/20250918093453.75676-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/execmem.c~mm-remove-pmd-alignment-constraint-in-execmem_vmalloc
+++ a/mm/execmem.c
@@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct exec
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
-	if (vm_flags & VM_ALLOW_HUGE_VMAP)
-		align = PMD_SIZE;
-
 	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
 				 pgprot, vm_flags, NUMA_NO_NODE,
 				 __builtin_return_address(0));
_

Patches currently in -mm which might be from dev.jain@arm.com are


