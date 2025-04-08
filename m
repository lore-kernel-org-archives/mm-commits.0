Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B63F244EA1;
	Tue,  8 Apr 2025 20:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145853; cv=none; b=OAwllvh/8cv/Uu7x+fSk+bjYnDIdJvEGTZ6CEOo93HzmRtoVTcWMBf4KvBrK8cOPoOVeAv/xPF181cVzKnzAHveYU+9bdPwuV/PaaOdziC1CXuvdPgk3rYXfp+EBP79SMj52CJa61kn07LZmljQ8vpkwNFb4hnfqztmReJecC1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145853; c=relaxed/simple;
	bh=3RRWnt3mrYJ7U06+tbAade/CQH11ZSpq9S5doL64kYs=;
	h=Date:To:From:Subject:Message-Id; b=bzCibkFJhS5jQJrLD/3+fd4UjPOfx8SpRmf70cwRaLPxaHoTEHR6Oben9ZpY7LYo9iDedl06VfEhUe/jUKhjCd2pLotXRrMbgEQsJOkTqAmOhqU2yfQOWGYTl4q9QN9mOlAxnLR/HGTgtB3Ip3tfPaq4y0HYj3qKATaJ7grb+88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kVJtwmAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kVJtwmAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89AEC4CEE5;
	Tue,  8 Apr 2025 20:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744145852;
	bh=3RRWnt3mrYJ7U06+tbAade/CQH11ZSpq9S5doL64kYs=;
	h=Date:To:From:Subject:From;
	b=kVJtwmAiEp3FMbBql7Q6H27C1A+x8GjdEchvxRCE9ZPQcgbplmwhZumHljT/6VMua
	 LhVS5pcJkNcRTHkfpG7V+eFmwyAvQld/AW5/luSbMEqHbmVuGlSt568dPcEs8Iu3y7
	 PDCPUiNT78viUUdpJ9gCTo0DYneOhD2PO6osSRi4=
Date: Tue, 08 Apr 2025 13:57:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-apply_to_pte_range-routine.patch added to mm-hotfixes-unstable branch
Message-Id: <20250408205732.B89AEC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clean up apply_to_pte_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cleanup-apply_to_pte_range-routine.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cleanup-apply_to_pte_range-routine.patch

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
Subject: mm: clean up apply_to_pte_range()
Date: Tue, 8 Apr 2025 18:07:31 +0200

Reverse 'create' vs 'mm == &init_mm' conditions and move page table mask
modification out of the atomic context.  This is a prerequisite for fixing
missing kernel page tables lock.

Link: https://lkml.kernel.org/r/0c65bc334f17ff1d7d92d31c69d7065769bbce4e.1744128123.git.agordeev@linux.ibm.com
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

 mm/memory.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-cleanup-apply_to_pte_range-routine
+++ a/mm/memory.c
@@ -2915,24 +2915,28 @@ static int apply_to_pte_range(struct mm_
 				     pte_fn_t fn, void *data, bool create,
 				     pgtbl_mod_mask *mask)
 {
+	int err = create ? -ENOMEM : -EINVAL;
 	pte_t *pte, *mapped_pte;
-	int err = 0;
 	spinlock_t *ptl;
 
-	if (create) {
-		mapped_pte = pte = (mm == &init_mm) ?
-			pte_alloc_kernel_track(pmd, addr, mask) :
-			pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	if (mm == &init_mm) {
+		if (create)
+			pte = pte_alloc_kernel_track(pmd, addr, mask);
+		else
+			pte = pte_offset_kernel(pmd, addr);
 		if (!pte)
-			return -ENOMEM;
+			return err;
 	} else {
-		mapped_pte = pte = (mm == &init_mm) ?
-			pte_offset_kernel(pmd, addr) :
-			pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (create)
+			pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
+		else
+			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
-			return -EINVAL;
+			return err;
+		mapped_pte = pte;
 	}
 
+	err = 0;
 	arch_enter_lazy_mmu_mode();
 
 	if (fn) {
@@ -2944,12 +2948,14 @@ static int apply_to_pte_range(struct mm_
 			}
 		} while (addr += PAGE_SIZE, addr != end);
 	}
-	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(mapped_pte, ptl);
+
+	*mask |= PGTBL_PTE_MODIFIED;
+
 	return err;
 }
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

kasan-avoid-sleepable-page-allocation-from-atomic-context.patch
mm-cleanup-apply_to_pte_range-routine.patch
mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

