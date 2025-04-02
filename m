Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28EA1F4CA8
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631383; cv=none; b=kKSRopM8lFNSiQXPnKSm6RVIU8CSFNRO2T8t9B6PLiCqzzw7iZhMvb0I8BuP4fOzEZI5tQhWO6wIkFmdPYmLLd6jKBo/KdEwFCPSM6lRnUXOUzzU2X/AkeUg/ZcudMPgfHsr63XZkcgdnBV4rcwaANhtklPErUieSGGR1jiFyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631383; c=relaxed/simple;
	bh=PUuTfxtyoymyhVNjvE49sBJt90EPDCUOehiKA7wwxnk=;
	h=Date:To:From:Subject:Message-Id; b=PS4kzNUSMDyni19HAlmTYrR45f9JORkgu7S0k3Kb9GFDHrm4sXciC4f6GQ8kH3cEAMZitYCy24I25RPvNzDeLbpeskBJbL19Q612Y/E0gwwPaXQpeLTvZQAPU2AVyPYn+4CuA3xr4GI7IUneahxytWcFkvh8SqBiX41M1aSj9Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zgq65LPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zgq65LPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A404C4CEDD;
	Wed,  2 Apr 2025 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631383;
	bh=PUuTfxtyoymyhVNjvE49sBJt90EPDCUOehiKA7wwxnk=;
	h=Date:To:From:Subject:From;
	b=zgq65LPWIYguljkM2BfxT610bvNQReQyoqFM5T0v6qcdqIcK5XKjup8v99opOrsfP
	 26kLK2JQmCoJxTt6nlZMybqkWDTkxC56bp7nL98z56ljn2flCxkGnpY9wCYCEGCv2n
	 qLnzk7e9H6qMkNzEov0KH1mAvBmHXfzASfZGhifY=
Date: Wed, 02 Apr 2025 15:03:02 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc32-remove-custom-definition-of-mk_pte.patch added to mm-new branch
Message-Id: <20250402220303.1A404C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc32: remove custom definition of mk_pte()
has been added to the -mm mm-new branch.  Its filename is
     sparc32-remove-custom-definition-of-mk_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc32-remove-custom-definition-of-mk_pte.patch

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
Subject: sparc32: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:57 +0100

Instead of defining pfn_pte() in terms of mk_pte(), make pfn_pte() the
base implementation.  That lets us use the generic definition of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/arch/sparc/include/asm/pgtable_32.h~sparc32-remove-custom-definition-of-mk_pte
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -255,7 +255,11 @@ static inline pte_t pte_mkyoung(pte_t pt
 }
 
 #define PFN_PTE_SHIFT			(PAGE_SHIFT - 4)
-#define pfn_pte(pfn, prot)		mk_pte(pfn_to_page(pfn), prot)
+
+static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
+{
+	return __pte((pfn << PFN_PTE_SHIFT) | pgprot_val(pgprot));
+}
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
@@ -272,15 +276,6 @@ static inline unsigned long pte_pfn(pte_
 
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
-{
-	return __pte((page_to_pfn(page) << (PAGE_SHIFT-4)) | pgprot_val(pgprot));
-}
-
 static inline pte_t mk_pte_phys(unsigned long page, pgprot_t pgprot)
 {
 	return __pte(((page) >> 4) | pgprot_val(pgprot));
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

