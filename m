Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0651CD33
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644475; cv=none; b=TSp/lrwVYkgTcJ+yMjWeXUHeLw9K4Y/sjwcBU/k2K2O4MJ2W5Cme1XFyog94SoaTTPxMRgibB1NGv2MdrMOotgN9sKzGdNSUMEszNQENaIE/ZhiByfAno94rh7mYB+fwAYSs/9cXxMPeb/xwNvkUEDuHkgElNK55nFCaaFd9zC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644475; c=relaxed/simple;
	bh=tYvtJo4zQXkDCy+RP1kG9vejYd/nooeKtslEn4kI8HQ=;
	h=Date:To:From:Subject:Message-Id; b=WMOBqVgoZh+jXE89rI+dxu/k6+Nqa8JeKijNdjGzGXLmd+4YpIleHgA4VjiZXWeJAUMlQRVmNHz4mcfblSO9qSI5wwD3f0OhoKpa0HwE/KSqYFvtId+Z0sgVAScjkjYIbgQi7uUsFo33vlavkx6JNyut1OSdf/8C6/oeEI85PWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M1+vrefu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M1+vrefu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D2CC43390;
	Thu, 22 Feb 2024 23:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644475;
	bh=tYvtJo4zQXkDCy+RP1kG9vejYd/nooeKtslEn4kI8HQ=;
	h=Date:To:From:Subject:From;
	b=M1+vrefu4mLjA8gd1wtz19cpJ+BuR8k05YnVUHuvXgrl+wQz2t/6xvyIX+Bv6h/kS
	 Z9jI9pPxCHjZqk+0mNUz4855zxm47SUQkL+l9MXSVHPHOSkv9DFsGvuZG7ZJJuiXbn
	 YVHmKlRmrPamShqZOxVSLaasLH6oQyQJWHF+mdNU=
Date: Thu, 22 Feb 2024 15:27:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-handle-page-case-in-zap_present_pte-separately.patch removed from -mm tree
Message-Id: <20240222232755.04D2CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: handle !page case in zap_present_pte() separately
has been removed from the -mm tree.  Its filename was
     mm-memory-handle-page-case-in-zap_present_pte-separately.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: handle !page case in zap_present_pte() separately
Date: Wed, 14 Feb 2024 21:44:27 +0100

We don't need uptodate accessed/dirty bits, so in theory we could replace
ptep_get_and_clear_full() by an optimized ptep_clear_full() function. 
Let's rely on the provided pte.

Further, there is no scenario where we would have to insert uffd-wp
markers when zapping something that is not a normal page (i.e., zeropage).
Add a sanity check to make sure this remains true.

should_zap_folio() no longer has to handle NULL pointers.  This change
replaces 2/3 "!page/!folio" checks by a single "!page" one.

Note that arch_check_zapped_pte() on x86-64 checks the HW-dirty bit to
detect shadow stack entries.  But for shadow stack entries, the HW dirty
bit (in combination with non-writable PTEs) is set by software.  So for
the arch_check_zapped_pte() check, we don't have to sync against HW
setting the HW dirty bit concurrently, it is always set.

Link: https://lkml.kernel.org/r/20240214204435.167852-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memory-handle-page-case-in-zap_present_pte-separately
+++ a/mm/memory.c
@@ -1499,10 +1499,6 @@ static inline bool should_zap_folio(stru
 	if (should_zap_cows(details))
 		return true;
 
-	/* E.g. the caller passes NULL for the case of a zero folio */
-	if (!folio)
-		return true;
-
 	/* Otherwise we should only zap non-anon folios */
 	return !folio_test_anon(folio);
 }
@@ -1540,24 +1536,28 @@ static inline void zap_present_pte(struc
 		int *rss, bool *force_flush, bool *force_break)
 {
 	struct mm_struct *mm = tlb->mm;
-	struct folio *folio = NULL;
 	bool delay_rmap = false;
+	struct folio *folio;
 	struct page *page;
 
 	page = vm_normal_page(vma, addr, ptent);
-	if (page)
-		folio = page_folio(page);
+	if (!page) {
+		/* We don't need up-to-date accessed/dirty bits. */
+		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+		arch_check_zapped_pte(vma, ptent);
+		tlb_remove_tlb_entry(tlb, pte, addr);
+		VM_WARN_ON_ONCE(userfaultfd_wp(vma));
+		ksm_might_unmap_zero_page(mm, ptent);
+		return;
+	}
 
+	folio = page_folio(page);
 	if (unlikely(!should_zap_folio(details, folio)))
 		return;
 	ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
 	arch_check_zapped_pte(vma, ptent);
 	tlb_remove_tlb_entry(tlb, pte, addr);
 	zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
-	if (unlikely(!page)) {
-		ksm_might_unmap_zero_page(mm, ptent);
-		return;
-	}
 
 	if (!folio_test_anon(folio)) {
 		if (pte_dirty(ptent)) {
_

Patches currently in -mm which might be from david@redhat.com are


