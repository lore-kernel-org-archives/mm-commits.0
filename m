Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565B3253F1F;
	Tue,  8 Apr 2025 20:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145856; cv=none; b=GxbNdymHHmY7ptTI/OqfNVozNv1q6vN2u9x+wEvayOD/9AUKTnzZydqdo38vCC11mnX+Xrp2gi4HHfePJVqSe/DtchVRdjVy2ERAqgmKZa+3iiPICNlH8sHLWoDMGcVUzIKSXfb0R+CTLmk4WTiqQ1lao3xstqJcV7L0a1cT6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145856; c=relaxed/simple;
	bh=L2Y7Z977GN3P8nWFiYplZR26tc03Vudrnby/li1gkNI=;
	h=Date:To:From:Subject:Message-Id; b=SmuYfgWPPxeRb9jYEjxxMDhpHvMhhLSdxYH4qbnYtl2/9v45jlq1mFK8IxeivuJwCCzTAWpNkE8P/pklAQA7v8rhCIVM43zuybZtjhNjsJ4tfkMFqyE8mseyrnr+94FoAxgDauKoUL6l5nnIYqQv9lEg8497moOuw7iB/CSxbuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynFGoMyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynFGoMyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C05C4CEE5;
	Tue,  8 Apr 2025 20:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744145855;
	bh=L2Y7Z977GN3P8nWFiYplZR26tc03Vudrnby/li1gkNI=;
	h=Date:To:From:Subject:From;
	b=ynFGoMyiHZOdE9ipIq+CHxw7WFVQwDM+EPQy/DwIsufdG6hntDGkbzwRgbkpvp7yx
	 8XygEd/fkZpeLfX/sGGOAR1NoY3Ll/Xmu6imLDK+6ym/Kxr+y8lf4w3eQN/BiEqclb
	 0mPSqg8FWt17YSqElrj6RX968OBnQGLh5E/GMQwk=
Date: Tue, 08 Apr 2025 13:57:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-protect-kernel-pgtables-in-apply_to_pte_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250408205735.A6C05C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: protect kernel pgtables in apply_to_pte_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: protect kernel pgtables in apply_to_pte_range()
Date: Tue, 8 Apr 2025 18:07:32 +0200

The lazy MMU mode can only be entered and left under the protection of the
page table locks for all page tables which may be modified.  Yet, when it
comes to kernel mappings apply_to_pte_range() does not take any locks. 
That does not conform arch_enter|leave_lazy_mmu_mode() semantics and could
potentially lead to re-schedulling a process while in lazy MMU mode or
racing on a kernel page table updates.

Link: https://lkml.kernel.org/r/ef8f6538b83b7fc3372602f90375348f9b4f3596.1744128123.git.agordeev@linux.ibm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    7 ++-----
 mm/memory.c       |    5 ++++-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/kasan/shadow.c~mm-protect-kernel-pgtables-in-apply_to_pte_range
+++ a/mm/kasan/shadow.c
@@ -308,14 +308,14 @@ static int kasan_populate_vmalloc_pte(pt
 	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
 	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
 
-	spin_lock(&init_mm.page_table_lock);
 	if (likely(pte_none(ptep_get(ptep)))) {
 		set_pte_at(&init_mm, addr, ptep, pte);
 		page = 0;
 	}
-	spin_unlock(&init_mm.page_table_lock);
+
 	if (page)
 		free_page(page);
+
 	return 0;
 }
 
@@ -401,13 +401,10 @@ static int kasan_depopulate_vmalloc_pte(
 
 	page = (unsigned long)__va(pte_pfn(ptep_get(ptep)) << PAGE_SHIFT);
 
-	spin_lock(&init_mm.page_table_lock);
-
 	if (likely(!pte_none(ptep_get(ptep)))) {
 		pte_clear(&init_mm, addr, ptep);
 		free_page(page);
 	}
-	spin_unlock(&init_mm.page_table_lock);
 
 	return 0;
 }
--- a/mm/memory.c~mm-protect-kernel-pgtables-in-apply_to_pte_range
+++ a/mm/memory.c
@@ -2926,6 +2926,7 @@ static int apply_to_pte_range(struct mm_
 			pte = pte_offset_kernel(pmd, addr);
 		if (!pte)
 			return err;
+		spin_lock(&init_mm.page_table_lock);
 	} else {
 		if (create)
 			pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
@@ -2951,7 +2952,9 @@ static int apply_to_pte_range(struct mm_
 
 	arch_leave_lazy_mmu_mode();
 
-	if (mm != &init_mm)
+	if (mm == &init_mm)
+		spin_unlock(&init_mm.page_table_lock);
+	else
 		pte_unmap_unlock(mapped_pte, ptl);
 
 	*mask |= PGTBL_PTE_MODIFIED;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

kasan-avoid-sleepable-page-allocation-from-atomic-context.patch
mm-cleanup-apply_to_pte_range-routine.patch
mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

