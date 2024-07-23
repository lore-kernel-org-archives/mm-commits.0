Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF9145A0F
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771460; cv=none; b=mOw9DGEx5295mr//XYycc/qR8AIBcVmPJzwClA8RCrt9WEqLSocfoNn6lrUv4T2SWcnLDEx1Ic3wcYWmJXkmHQC5qgUXVWf3cavwgkf2akY6VTlyi5bZiWp40RcjRpdVLhkQd5tSX6no2h1REn/hjWO6iXx7ajSTQIbfVfrxKxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771460; c=relaxed/simple;
	bh=nMFYhHeJitUV19Tmsb3sihDwPdhyHV5lfvUbD0Sjgoc=;
	h=Date:To:From:Subject:Message-Id; b=F4DZXHnt3EVJl0FrY6sfZ3HZmSepanPQWK+0xTDE16wI37sLDVtS6VzxYV3GC8myQ7YWveE0eRZF+3WVDxEhxCNDZP0FN6GKujx0V0Tk8uU8y1USPC4PuVVoXf2v62s95KiJYMrdx/1DqTkLN33SeR/Grjf35Ol6tKK2RVmP4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0o6XxB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0o6XxB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9590C4AF0A;
	Tue, 23 Jul 2024 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771459;
	bh=nMFYhHeJitUV19Tmsb3sihDwPdhyHV5lfvUbD0Sjgoc=;
	h=Date:To:From:Subject:From;
	b=j0o6XxB0PBQj2ZWxt8YgEv3Y7bQLrBo+a5VhN9NnSY9n7ku2irJ9CD6pESEwItphn
	 RfPBlGFapo/lVfZE2bOlV1l2SHkjcMOUw4zUqK/1J+nZph1k0sjil5VT4TRKO/Ihr7
	 52ubzpTdWurF7ilq9jcW8kkwknWjSQ6+dz9t2qTE=
Date: Tue, 23 Jul 2024 14:50:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-page_address_in_vma.patch added to mm-unstable branch
Message-Id: <20240723215059.C9590C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify page_address_in_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-constify-page_address_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-page_address_in_vma.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify page_address_in_vma()
Date: Tue, 23 Jul 2024 16:34:57 +0100

If we also mark the struct folio argument to folio_anon_vma(), we can make
page_address_in_vma() take a const struct page pointer.

Link: https://lkml.kernel.org/r/20240723153503.1669586-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/internal.h        |    2 +-
 mm/rmap.c            |    5 +++--
 mm/util.c            |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/rmap.h~mm-constify-page_address_in_vma
+++ a/include/linux/rmap.h
@@ -732,7 +732,7 @@ bool page_vma_mapped_walk(struct page_vm
 /*
  * Used by swapoff to help locate where page is expected in vma.
  */
-unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
+unsigned long page_address_in_vma(const struct page *, struct vm_area_struct *);
 
 /*
  * Cleans the PTEs of shared mappings.
--- a/mm/internal.h~mm-constify-page_address_in_vma
+++ a/mm/internal.h
@@ -784,7 +784,7 @@ static inline bool free_area_empty(struc
 }
 
 /* mm/util.c */
-struct anon_vma *folio_anon_vma(struct folio *folio);
+struct anon_vma *folio_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MMU
 void unmap_mapping_folio(struct folio *folio);
--- a/mm/rmap.c~mm-constify-page_address_in_vma
+++ a/mm/rmap.c
@@ -771,9 +771,10 @@ static bool should_defer_flush(struct mm
  * At what user virtual address is page expected in vma?
  * Caller should check the page is actually part of the vma.
  */
-unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
+unsigned long page_address_in_vma(const struct page *page,
+		struct vm_area_struct *vma)
 {
-	struct folio *folio = page_folio(page);
+	const struct folio *folio = page_folio(page);
 	pgoff_t pgoff;
 
 	if (folio_test_anon(folio)) {
--- a/mm/util.c~mm-constify-page_address_in_vma
+++ a/mm/util.c
@@ -809,7 +809,7 @@ void *vcalloc_noprof(size_t n, size_t si
 }
 EXPORT_SYMBOL(vcalloc_noprof);
 
-struct anon_vma *folio_anon_vma(struct folio *folio)
+struct anon_vma *folio_anon_vma(const struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
 
_

Patches currently in -mm which might be from willy@infradead.org are

bootmem-stop-using-page-index.patch
mm-constify-page_address_in_vma.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-mass-constification-of-folio-page-pointers.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

