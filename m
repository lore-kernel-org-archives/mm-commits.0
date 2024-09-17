Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5962514BF8B
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560455; cv=none; b=GFafrzRqbuC1cjAHZmYFE/rTPM2niz2NXTzJfhhF9EDas8Tkez2Qjo2bfYQJQn2+HjN+I+C6JWwP73DpMg6q1DqQVok9tAbhGNuJkSeippW8zrNgHe3mxq/92aqUU5BBaY0BBmsNgh3v5TusHDSz66QKlPYxOUpUYdTsgOxfy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560455; c=relaxed/simple;
	bh=SYC9G+4Cbk9SIQyYKlehfqAsuaIiEfrJ58vGczjRxPw=;
	h=Date:To:From:Subject:Message-Id; b=hpmcKYvtydK7Rx7dZFyJM9wCXVEVUU5ub6UhoPsKRGfPcU53z5DWHjpqd/9gObcVxsxM59LImZIFEMYu4Yh26MUBGmJW7E85YGDwTY03apVBbxciDI32iLGQ2IB2wHZ1J+4GEKKJ7/DQhLZUWDEtRCotJYZGtkaDKYLPBYggUZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MyNOThIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MyNOThIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A096EC4CECE;
	Tue, 17 Sep 2024 08:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560455;
	bh=SYC9G+4Cbk9SIQyYKlehfqAsuaIiEfrJ58vGczjRxPw=;
	h=Date:To:From:Subject:From;
	b=MyNOThIBtK2UBnav2JLY2xKy7fLqLifBwIHNPEWW3pKg9VoP69zRqnOfOhksfptvb
	 ZaFOM/DIZVv4WCDAvzP1EymEvzo6z1PYnzxt6NjgbzXt2Ps6mNYfuXWsBRGHH/IX9E
	 kCx0PIQoZj3NC+eiKrIm3cE66MaZfIR7iXNQzB3w=
Date: Tue, 17 Sep 2024 01:07:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-is_huge_zero_pud.patch removed from -mm tree
Message-Id: <20240917080734.A096EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop is_huge_zero_pud()
has been removed from the -mm tree.  Its filename was
     mm-drop-is_huge_zero_pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: drop is_huge_zero_pud()
Date: Mon, 26 Aug 2024 16:43:36 -0400

It constantly returns false since 2017.  One assertion is added in 2019 but
it should never have triggered, IOW it means what is checked should be
asserted instead.

If it didn't exist for 7 years maybe it's good idea to remove it and only
add it when it comes.

Link: https://lkml.kernel.org/r/20240826204353.2228736-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 ----------
 mm/huge_memory.c        |   13 +------------
 2 files changed, 1 insertion(+), 22 deletions(-)

--- a/include/linux/huge_mm.h~mm-drop-is_huge_zero_pud
+++ a/include/linux/huge_mm.h
@@ -433,11 +433,6 @@ static inline bool is_huge_zero_pmd(pmd_
 	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
 }
 
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
-
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
@@ -577,11 +572,6 @@ static inline bool is_huge_zero_pmd(pmd_
 {
 	return false;
 }
-
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
 
 static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
--- a/mm/huge_memory.c~mm-drop-is_huge_zero_pud
+++ a/mm/huge_memory.c
@@ -1453,10 +1453,8 @@ static void insert_pfn_pud(struct vm_are
 	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		if (write) {
-			if (pud_pfn(*pud) != pfn_t_to_pfn(pfn)) {
-				WARN_ON_ONCE(!is_huge_zero_pud(*pud));
+			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
 				goto out_unlock;
-			}
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
@@ -1705,15 +1703,6 @@ int copy_huge_pud(struct mm_struct *dst_
 		goto out_unlock;
 
 	/*
-	 * When page table lock is held, the huge zero pud should not be
-	 * under splitting since we don't split the page itself, only pud to
-	 * a page table.
-	 */
-	if (is_huge_zero_pud(pud)) {
-		/* No huge zero pud yet */
-	}
-
-	/*
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
_

Patches currently in -mm which might be from peterx@redhat.com are


