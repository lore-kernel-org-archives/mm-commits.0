Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E4F2116E0
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252154; cv=none; b=Shnz2GeOGUrKPaYcXyctb6oeB7ZQwVF3VnQfzABufZX1K1+RbN4qr4dVgdsKtOD5LaArfu04LDGcyUc5wb+A2mz2SfEVz0FRNkcDQAzdpnTfc31u+Uy/6pCBMoLISpWxLSKPkWR0US3Clrd16zAouxtP4xs9DXFvEaI8+0o63Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252154; c=relaxed/simple;
	bh=lMrNEauiji9BxY8ftswOjDZVya5DMTBN3sKRbDoXIxg=;
	h=Date:To:From:Subject:Message-Id; b=ajPiqMsncw92BoM3A8mEfl53bq8UspWRtVyO86sir3SIBIWg5ErtRoPy8NereOzTYOOr/BUstr6Gix0DOySfQpmLhj5FxXb8llq+HQo9KNQEV235XD7fjsZsNcpRcg0het4D1kcz0oV9LQDB8vIqiSOrza9yf88sTU5zZCat9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eg5aJ5kI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eg5aJ5kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520FC19421;
	Wed, 11 Mar 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252154;
	bh=lMrNEauiji9BxY8ftswOjDZVya5DMTBN3sKRbDoXIxg=;
	h=Date:To:From:Subject:From;
	b=Eg5aJ5kImrLKUZowwba2Heo7p+V7M/cCji8h+wvyg4YZPen/eNRKFQ1ex3CQql1Rz
	 ZjxVMEMlqI5vg20ujf5WGJh0cMOF2yGPUuZCcH9ca20ZkwMP1fOVBr9BIWieQ1ppx6
	 uSFgyNCOh388twtoUzPqOJPPwlUlfH67NxWkp9Ps=
Date: Wed, 11 Mar 2026 11:02:33 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch added to mm-unstable branch
Message-Id: <20260311180234.4520FC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
Date: Wed, 11 Mar 2026 10:19:00 +0100

tet's call the local variable simply "addr", per Lorenzo

Link: https://lkml.kernel.org/r/f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
+++ a/mm/memory.c
@@ -2081,17 +2081,17 @@ static void __zap_vma_range(struct mmu_g
 			return;
 		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
 	} else {
-		unsigned long next, cur = start;
+		unsigned long next, addr = start;
 		pgd_t *pgd;
 
 		tlb_start_vma(tlb, vma);
-		pgd = pgd_offset(vma->vm_mm, cur);
+		pgd = pgd_offset(vma->vm_mm, addr);
 		do {
-			next = pgd_addr_end(cur, end);
+			next = pgd_addr_end(addr, end);
 			if (pgd_none_or_clear_bad(pgd))
 				continue;
-			next = zap_p4d_range(tlb, vma, pgd, cur, next, details);
-		} while (pgd++, cur = next, cur != end);
+			next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
+		} while (pgd++, addr = next, addr != end);
 		tlb_end_vma(tlb, vma);
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
kasan-docs-slub-is-the-only-remaining-slab-implementation.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch

