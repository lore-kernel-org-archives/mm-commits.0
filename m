Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C27F1F2C28
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738360439; cv=none; b=S1wL4wI/eO/KUMT2oey5O+gwGCxzEnMpTlz1MtxYN8fRJC3zddhI2qNKMDZ/A98RVTgOlWpFIXm+U4n82YYUMXZqgCe8FnGXBEmK24KPRTO+jOSYulGwPzaIsFxlj9unoft2ZsPxqbU/16Iv5EZxVLJNI0mIFJZG/2068RV9/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738360439; c=relaxed/simple;
	bh=+Araq9A+gGaDcqFmZDzNzok3w86RWYOwypXA8cuCUSo=;
	h=Date:To:From:Subject:Message-Id; b=QtoKOV1UnO4ythP6m/POXn9X8O6wi+qBSIbAJ6X3PLOsKFUTdtbHCF3AC5khhClU3fM7EfrcHzHczXhV60oz08wmBFWjjB2n6gVcF+HKfUR+x83raS7Be6wKxBBJgdkwvx5/jtCA9PRLI2eoDWnn5m1IbulWaqZDpwFAhOQWGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eMzAxXr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eMzAxXr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4538C4CEE1;
	Fri, 31 Jan 2025 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738360438;
	bh=+Araq9A+gGaDcqFmZDzNzok3w86RWYOwypXA8cuCUSo=;
	h=Date:To:From:Subject:From;
	b=eMzAxXr5DeMdzbJKQQOjIiLkHuzRUJ6qmUl0BPbhFuZU5+Sv8RU/CJ4M9SmNPGnnk
	 tXlClNewEXRwluyXcljOWKNfYudyeU6N3sfVv7ysWxTG+KmLMxluwnGTI+by+r9dB+
	 BY4yhu1JayrOUmZEAqdArel0Ls8WQ1cwRaZhUGkE=
Date: Fri, 31 Jan 2025 13:53:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,soci@c64.rulez.org,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-mapping_wrprotect_page-function.patch added to mm-unstable branch
Message-Id: <20250131215358.A4538C4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: provide mapping_wrprotect_page() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-mapping_wrprotect_page-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-mapping_wrprotect_page-function.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: provide mapping_wrprotect_page() function
Date: Fri, 31 Jan 2025 18:28:57 +0000

In the fb_defio video driver, page dirty state is used to determine when
frame buffer pages have been changed, allowing for batched, deferred I/O
to be performed for efficiency.

This implementation had only one means of doing so effectively - the use
of the folio_mkclean() function.

However, this use of the function is inappropriate, as the fb_defio
implementation allocates kernel memory to back the framebuffer, and then
is forced to specified page->index, mapping fields in order to permit the
folio_mkclean() rmap traversal to proceed correctly.

It is not correct to specify these fields on kernel-allocated memory, and
moreover since these are not folios, page->index, mapping are deprecated
fields, soon to be removed.

We therefore need to provide a means by which we can correctly traverse
the reverse mapping and write-protect mappings for a page backing an
address_space page cache object at a given offset.

This patch provides this - mapping_wrprotect_page() allows for this
operation to be performed for a specified address_space, offset and page,
without requiring a folio nor, of course, an inappropriate use of
page->index, mapping.

With this provided, we can subequently adjust the fb_defio implementation
to make use of this function and avoid incorrect invocation of
folio_mkclean() and more importantly, incorrect manipulation of
page->index, mapping fields.

Link: https://lkml.kernel.org/r/c802c17cdba59e3455f3d7db07659d5da0ed6dc1.1738347308.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +
 mm/rmap.c            |   73 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

--- a/include/linux/rmap.h~mm-provide-mapping_wrprotect_page-function
+++ a/include/linux/rmap.h
@@ -739,6 +739,9 @@ unsigned long page_address_in_vma(const
  */
 int folio_mkclean(struct folio *);
 
+int mapping_wrprotect_page(struct address_space *mapping, pgoff_t pgoff,
+		unsigned long nr_pages, struct page *page);
+
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
--- a/mm/rmap.c~mm-provide-mapping_wrprotect_page-function
+++ a/mm/rmap.c
@@ -1129,6 +1129,79 @@ int folio_mkclean(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_mkclean);
 
+struct wrprotect_file_state {
+	int cleaned;
+	pgoff_t pgoff;
+	unsigned long pfn;
+	unsigned long nr_pages;
+};
+
+static bool mapping_wrprotect_page_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	struct wrprotect_file_state *state = (struct wrprotect_file_state *)arg;
+	struct page_vma_mapped_walk pvmw = {
+		.pfn		= state->pfn,
+		.nr_pages	= state->nr_pages,
+		.pgoff		= state->pgoff,
+		.vma		= vma,
+		.address	= address,
+		.flags		= PVMW_SYNC,
+	};
+
+	state->cleaned += page_vma_mkclean_one(&pvmw);
+
+	return true;
+}
+
+static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
+			     pgoff_t pgoff_start, unsigned long nr_pages,
+			     struct rmap_walk_control *rwc, bool locked);
+
+/**
+ * mapping_wrprotect_page() - Write protect all mappings of this page.
+ *
+ * @mapping:	The mapping whose reverse mapping should be traversed.
+ * @pgoff:	The page offset at which @page is mapped within @mapping.
+ * @nr_pages:	The number of physically contiguous base pages spanned.
+ * @page:	The page mapped in @mapping at @pgoff.
+ *
+ * Traverses the reverse mapping, finding all VMAs which contain a shared
+ * mapping of the single @page in @mapping at offset @pgoff and write-protecting
+ * the mappings.
+ *
+ * The page does not have to be a folio, but rather can be a kernel allocation
+ * that is mapped into userland. We therefore do not require that the page maps
+ * to a folio with a valid mapping or index field, rather these are specified in
+ * @mapping and @pgoff.
+ *
+ * Return: the number of write-protected PTEs, or an error.
+ */
+int mapping_wrprotect_page(struct address_space *mapping, pgoff_t pgoff,
+		unsigned long nr_pages, struct page *page)
+{
+	struct wrprotect_file_state state = {
+		.cleaned = 0,
+		.pgoff = pgoff,
+		.pfn = page_to_pfn(page),
+		.nr_pages = nr_pages,
+	};
+	struct rmap_walk_control rwc = {
+		.arg = (void *)&state,
+		.rmap_one = mapping_wrprotect_page_one,
+		.invalid_vma = invalid_mkclean_vma,
+	};
+
+	if (!mapping)
+		return 0;
+
+	__rmap_walk_file(/* folio = */NULL, mapping, pgoff, nr_pages, &rwc,
+			 /* locked = */false);
+
+	return state.cleaned;
+}
+EXPORT_SYMBOL_GPL(mapping_wrprotect_page);
+
 /**
  * pfn_mkclean_range - Cleans the PTEs (including PMDs) mapped with range of
  *                     [@pfn, @pfn + @nr_pages) at the specific offset (@pgoff)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_page-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch

