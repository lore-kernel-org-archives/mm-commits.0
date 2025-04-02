Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63321F4612
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631385; cv=none; b=VwE34dWkkls33DaCuAFLfayG7GfhUlpmmHzO9xU4HjMpBoBqbfsss+TTKrDsIh47RvjEpiT+DoqegyvFfQZYJIGLqUiiiipVUaDQ+uoiEYLp3x4GFlJcEjUgEbMyvFLQMKeXr+1+901wNWvL9A4IgW5e8UDW//HSY8ycLdwztFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631385; c=relaxed/simple;
	bh=qURfn6XO0V32Po29CtXlvrGrH/evbIIaJuTqqzXpwqo=;
	h=Date:To:From:Subject:Message-Id; b=uvdC/vdzGyTDPGhJ17b0rSVLT1y0Vav/0XkfAI5kwFwwBivmh1rY2DYiCJYtkcv60kUaUrfnGSchxpclUDibmwv9XMIBdsnYvbdlQuWm1oSsVQacZyMH2gwvah+Jy4ukMBmQpaoBMhda+wnt66Njg5sMI7vT/7hFXCaCGZM2HVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFbsQw7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFbsQw7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81203C4CEDD;
	Wed,  2 Apr 2025 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631385;
	bh=qURfn6XO0V32Po29CtXlvrGrH/evbIIaJuTqqzXpwqo=;
	h=Date:To:From:Subject:From;
	b=NFbsQw7l2nFHyHYRGNaGYpkOSxPQJ1f7vvF/3rj4nzwiSg9IDLqznOdt8tlf6plkR
	 +TzRNqEImu38GQmmphGVug2A8Y1r2coyhBcKvxm7dR+qlnJYGSHHX7vKe+8lZwH5ZG
	 tvAuFZIsqmZrVDNWQfkVlfd9UyQ4d6uz+sfwprsk=
Date: Wed, 02 Apr 2025 15:03:05 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-remove-custom-definition-of-mk_pte.patch added to mm-new branch
Message-Id: <20250402220305.81203C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: um: remove custom definition of mk_pte()
has been added to the -mm mm-new branch.  Its filename is
     um-remove-custom-definition-of-mk_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-remove-custom-definition-of-mk_pte.patch

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
Subject: um: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:59 +0100

Move the pfn_pte() definitions from the 2level and 4level files to the
generic pgtable.h and delete the custom definition of mk_pte() so that we
use the central definition.

Link: https://lkml.kernel.org/r/20250402181709.2386022-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/pgtable-2level.h |    1 -
 arch/um/include/asm/pgtable-4level.h |    9 ---------
 arch/um/include/asm/pgtable.h        |   18 ++++++++----------
 3 files changed, 8 insertions(+), 20 deletions(-)

--- a/arch/um/include/asm/pgtable-2level.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable-2level.h
@@ -37,7 +37,6 @@ static inline void pgd_mkuptodate(pgd_t
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 
 #define pte_pfn(x) phys_to_pfn(pte_val(x))
-#define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
 #endif
--- a/arch/um/include/asm/pgtable-4level.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable-4level.h
@@ -102,15 +102,6 @@ static inline unsigned long pte_pfn(pte_
 	return phys_to_pfn(pte_val(pte));
 }
 
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pte_t pte;
-	phys_t phys = pfn_to_phys(page_nr);
-
-	pte_set_val(pte, phys, pgprot);
-	return pte;
-}
-
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
--- a/arch/um/include/asm/pgtable.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable.h
@@ -260,19 +260,17 @@ static inline int pte_same(pte_t pte_a,
 	return !((pte_val(pte_a) ^ pte_val(pte_b)) & ~_PAGE_NEEDSYNC);
 }
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-
 #define __virt_to_page(virt) phys_to_page(__pa(virt))
 #define virt_to_page(addr) __virt_to_page((const unsigned long) addr)
 
-#define mk_pte(page, pgprot) \
-	({ pte_t pte;					\
-							\
-	pte_set_val(pte, page_to_phys(page), (pgprot));	\
-	pte;})
+static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
+{
+	pte_t pte;
+
+	pte_set_val(pte, pfn_to_phys(pfn), pgprot);
+
+	return pte;
+}
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
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

