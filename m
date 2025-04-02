Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADE71F4CA8
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631384; cv=none; b=ULEVROMMFXeIQx8i04k4sNEtUoQgNsPgrc9d7Vx/fe7iTccTQj9WAPc+N5dE4qRwxOglfVozOLo7cKr7Yvqye+oO0eDhQ6T0EuyIGnGiiZrHOsiMY6FOSJuFRevSS6QoNz6HfF8uukvCKkxzmHE69ZUS1Qzh/ZT/KW+iEs6vSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631384; c=relaxed/simple;
	bh=6rIoY0XqhrpED6j0niDy2wOEMBc3NoPAHXLQ+ioWH04=;
	h=Date:To:From:Subject:Message-Id; b=C4/UYENjw3sTHpbFoI7uVLdY8nwujQF3mPKOKZHoLI1q0MnQYxzv31QCyDzifE51fE0tbZEbPM9NUs0EfrGCg53ihPhzHIqonP51fdpvojhd9XsHOVXxYM64LJ/ufAQhAVHKk2sHi3PEaIlMIiq9Jq3CqX89S5zasRHM482lqLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tj4R2PC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tj4R2PC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE08C4CEDD;
	Wed,  2 Apr 2025 22:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631384;
	bh=6rIoY0XqhrpED6j0niDy2wOEMBc3NoPAHXLQ+ioWH04=;
	h=Date:To:From:Subject:From;
	b=Tj4R2PC7W4XjqBjlM9s00OvMqimE8XvvPx2wvvIWT+8P0ksrSwDLm5WLFspVa3N/E
	 opt1cYRTjaI+ZHwkzVBrfmGQvUSvHI7K9K5hZo1/mz0xkarD+SytdB4+tn2Wq7Bbdt
	 8I7SHyM+ZW+qBkaP6zCOl4FlivNO9iWQXi2k/O/E=
Date: Wed, 02 Apr 2025 15:03:03 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-remove-custom-definition-of-mk_pte.patch added to mm-new branch
Message-Id: <20250402220304.4CE08C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: remove custom definition of mk_pte()
has been added to the -mm mm-new branch.  Its filename is
     x86-remove-custom-definition-of-mk_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-remove-custom-definition-of-mk_pte.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: x86: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:58 +0100

Move the shadow stack check to pfn_pte() which lets us use the common
definition of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-remove-custom-definition-of-mk_pte
+++ a/arch/x86/include/asm/pgtable.h
@@ -772,6 +772,9 @@ static inline pgprotval_t check_pgprot(p
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
+	/* This bit combination is used to mark shadow stacks */
+	WARN_ON_ONCE((pgprot_val(pgprot) & (_PAGE_DIRTY | _PAGE_RW)) ==
+			_PAGE_DIRTY);
 	pfn ^= protnone_mask(pgprot_val(pgprot));
 	pfn &= PTE_PFN_MASK;
 	return __pte(pfn | check_pgprot(pgprot));
@@ -1068,22 +1071,6 @@ static inline unsigned long pmd_page_vad
  */
 #define pmd_page(pmd)	pfn_to_page(pmd_pfn(pmd))
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- *
- * (Currently stuck as a macro because of indirect forward reference
- * to linux/mm.h:page_to_nid())
- */
-#define mk_pte(page, pgprot)						  \
-({									  \
-	pgprot_t __pgprot = pgprot;					  \
-									  \
-	WARN_ON_ONCE((pgprot_val(__pgprot) & (_PAGE_DIRTY | _PAGE_RW)) == \
-		    _PAGE_DIRTY);					  \
-	pfn_pte(page_to_pfn(page), __pgprot);				  \
-})
-
 static inline int pmd_bad(pmd_t pmd)
 {
 	return (pmd_flags(pmd) & ~(_PAGE_USER | _PAGE_ACCESSED)) !=
_

Patches currently in -mm which might be from willy@infradead.org are

mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch
mm-introduce-a-common-definition-of-mk_pte.patch
sparc32-remove-custom-definition-of-mk_pte.patch
x86-remove-custom-definition-of-mk_pte.patch
um-remove-custom-definition-of-mk_pte.patch
mm-make-mk_pte-definition-unconditional.patch
mm-add-folio_mk_pte.patch
hugetlb-simplify-make_huge_pte.patch
mm-remove-mk_huge_pte.patch
mm-add-folio_mk_pmd.patch
arch-remove-mk_pmd.patch
filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

