Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEC3145A0F
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771463; cv=none; b=JRC1VNpUyDdIajbs7cg+Ua7rvN9qZ57pmsEvW8G3xA0fjFl5hE+JUbkEF+b/sy6yqrp3pclAS1Ghkmy0dijiaU0sYHHPQ0VhVY3hEF8KRpQnxjN0B+deleksAdE8L3TCHA6i8BWDnUa2bWhfWfNhny18KT6fU2Ibq4mBpv9p4qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771463; c=relaxed/simple;
	bh=HZOdh2RLs1E86NuZMdwQOEG5UTvlP0s1ru8AxB4RgW8=;
	h=Date:To:From:Subject:Message-Id; b=ezsE6GTa2nlhR2rVLFPzHA2L6Cwz0AGjOT18B8PUFXVHbOLv45JOg/VsjpJ8josvAHhJlKsSKrZ34Tcboj+K3OfWNIRuO02vB4P8GSzfdo2soOOZQdI27oOxGz7nR5ZNwU2vZA7EycAq4TfTuHCCi3/Turjh/ZmKT0mqO4wnkc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pNN7h7mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pNN7h7mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1032C4AF09;
	Tue, 23 Jul 2024 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771462;
	bh=HZOdh2RLs1E86NuZMdwQOEG5UTvlP0s1ru8AxB4RgW8=;
	h=Date:To:From:Subject:From;
	b=pNN7h7mU/Rp2+QhyA5UwNvUs626GVzJJNzzIddDFTV6i6JpdIc/NfALp79XvH74co
	 hviXhSKK2fyztZDboCo1+Bxy60PZFumbbs200k+Ux513lNSVh/7jKyalnAE0bc6jft
	 1BisiiJ1CK4Wn1iHMPiXBi8NWoxGX/DBowGSoHmc=
Date: Tue, 23 Jul 2024 14:51:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_to_pgoff-to-page_pgoff.patch added to mm-unstable branch
Message-Id: <20240723215102.B1032C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert page_to_pgoff() to page_pgoff()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_to_pgoff-to-page_pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_to_pgoff-to-page_pgoff.patch

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
Subject: mm: convert page_to_pgoff() to page_pgoff()
Date: Tue, 23 Jul 2024 16:34:58 +0100

Change the function signature to pass in the folio as all three
callers have it.  This removes a reference to page->index, which we're
trying to get rid of.  Also move page_pgoff() to mm/internal.h as
code outside mm has no business calling it.

Link: https://lkml.kernel.org/r/20240723153503.1669586-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   18 ------------------
 mm/internal.h           |    6 ++++++
 mm/memory-failure.c     |    4 ++--
 mm/rmap.c               |    2 +-
 4 files changed, 9 insertions(+), 21 deletions(-)

--- a/include/linux/pagemap.h~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/include/linux/pagemap.h
@@ -914,24 +914,6 @@ static inline struct folio *read_mapping
 }
 
 /*
- * Get the offset in PAGE_SIZE (even for hugetlb pages).
- */
-static inline pgoff_t page_to_pgoff(struct page *page)
-{
-	struct page *head;
-
-	if (likely(!PageTransTail(page)))
-		return page->index;
-
-	head = compound_head(page);
-	/*
-	 *  We don't initialize ->index for tail pages: calculate based on
-	 *  head page
-	 */
-	return head->index + page - head;
-}
-
-/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
--- a/mm/internal.h~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/mm/internal.h
@@ -893,6 +893,12 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
+static inline pgoff_t page_pgoff(const struct folio *folio,
+		const struct page *page)
+{
+	return folio->index + folio_page_idx(folio, page);
+}
+
 /**
  * vma_address - Find the virtual address a page range is mapped at
  * @vma: The vma which maps this object.
--- a/mm/memory-failure.c~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/mm/memory-failure.c
@@ -617,7 +617,7 @@ static void collect_procs_anon(struct fo
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page_to_pgoff(page);
+	pgoff = page_pgoff(folio, page);
 	rcu_read_lock();
 	for_each_process(tsk) {
 		struct vm_area_struct *vma;
@@ -653,7 +653,7 @@ static void collect_procs_file(struct fo
 
 	i_mmap_lock_read(mapping);
 	rcu_read_lock();
-	pgoff = page_to_pgoff(page);
+	pgoff = page_pgoff(folio, page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
 		unsigned long addr;
--- a/mm/rmap.c~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/mm/rmap.c
@@ -1266,7 +1266,7 @@ static void __page_check_anon_rmap(struc
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_to_pgoff(page) != linear_page_index(vma, address),
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
 		       page);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

bootmem-stop-using-page-index.patch
mm-constify-page_address_in_vma.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-mass-constification-of-folio-page-pointers.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

