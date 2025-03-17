Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654062153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188267; cv=none; b=JHXt7ISWGHU4fL2IqzSfF8f1LzwDgBjQn8avCSRYCpv1BjeSfpa27QS5pCabwKTxP7y/Lu+zveEslP8nyEz81Z1uRKn/+WLLALn8d1pO206rv7+ON8hkZ0L4e/mPSisvXslTJc7rPlawJBTrp90S6dtzU7EWzL9mNVMz78tzr6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188267; c=relaxed/simple;
	bh=sSmr/q0qKQreVxes2MeVjWQ7Okv7ecDDw4VeCm/sgSk=;
	h=Date:To:From:Subject:Message-Id; b=Wj62PwLdCHu96uji1rAIlkxKp7QZv9e4cm8wHfIPGr8p4z56gkb9wSec+IbUZXlvY9F6EogFffEKlyydvmmZ2YUJqo611Qwq/4/aiWx5vqbRrYzw1BNW0Tq4xR5RI1jo4eKA/QUnVQkwQ2xo8w1n+TpFdMZS8y5bBCsaKvNQuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JdKMJjqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JdKMJjqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C1C4CEEC;
	Mon, 17 Mar 2025 05:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188266;
	bh=sSmr/q0qKQreVxes2MeVjWQ7Okv7ecDDw4VeCm/sgSk=;
	h=Date:To:From:Subject:From;
	b=JdKMJjqQDOpYBkY8TfZCySI1zY9bbfJm81Z/Vfv73jh47PzrLdqTP7ep6aQTCtjCB
	 kS2SvugSOlWSKq0j6THRQMUAHSOoGKsGcLlQqs7WHB1GtqBnwmr/IC6PiWCDLGW2gt
	 x9ZTIEm9eo5LQbTIweeRRQAebJ0VrFIpzqTfNpM4=
Date: Sun, 16 Mar 2025 22:11:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-provide-mapping_wrprotect_range-function.patch removed from -mm tree
Message-Id: <20250317051106.D09C1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: provide mapping_wrprotect_range() function
has been removed from the -mm tree.  Its filename was
     mm-provide-mapping_wrprotect_range-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: provide mapping_wrprotect_range() function
Date: Sat, 8 Feb 2025 15:52:55 +0000

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

This patch provides this - mapping_wrprotect_range() - which allows for
this operation to be performed for a specified address_space, offset, PFN
and size, without requiring a folio nor, of course, an inappropriate use
of page->index, mapping.

With this provided, we can subsequently adjust the fb_defio implementation
to make use of this function and avoid incorrect invocation of
folio_mkclean() and more importantly, incorrect manipulation of
page->index and mapping fields.

Link: https://lkml.kernel.org/r/e5bf969d64e7f2f2ae944d42341fc8994b736a81.1739029358.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +
 mm/rmap.c            |   74 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

--- a/include/linux/rmap.h~mm-provide-mapping_wrprotect_range-function
+++ a/include/linux/rmap.h
@@ -738,6 +738,9 @@ unsigned long page_address_in_vma(const
  */
 int folio_mkclean(struct folio *);
 
+int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
+		unsigned long pfn, unsigned long nr_pages);
+
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
--- a/mm/rmap.c~mm-provide-mapping_wrprotect_range-function
+++ a/mm/rmap.c
@@ -1135,6 +1135,80 @@ int folio_mkclean(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_mkclean);
 
+struct wrprotect_file_state {
+	int cleaned;
+	pgoff_t pgoff;
+	unsigned long pfn;
+	unsigned long nr_pages;
+};
+
+static bool mapping_wrprotect_range_one(struct folio *folio,
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
+ * mapping_wrprotect_range() - Write-protect all mappings in a specified range.
+ *
+ * @mapping:	The mapping whose reverse mapping should be traversed.
+ * @pgoff:	The page offset at which @pfn is mapped within @mapping.
+ * @pfn:	The PFN of the page mapped in @mapping at @pgoff.
+ * @nr_pages:	The number of physically contiguous base pages spanned.
+ *
+ * Traverses the reverse mapping, finding all VMAs which contain a shared
+ * mapping of the pages in the specified range in @mapping, and write-protects
+ * them (that is, updates the page tables to mark the mappings read-only such
+ * that a write protection fault arises when the mappings are written to).
+ *
+ * The @pfn value need not refer to a folio, but rather can reference a kernel
+ * allocation which is mapped into userland. We therefore do not require that
+ * the page maps to a folio with a valid mapping or index field, rather the
+ * caller specifies these in @mapping and @pgoff.
+ *
+ * Return: the number of write-protected PTEs, or an error.
+ */
+int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
+		unsigned long pfn, unsigned long nr_pages)
+{
+	struct wrprotect_file_state state = {
+		.cleaned = 0,
+		.pgoff = pgoff,
+		.pfn = pfn,
+		.nr_pages = nr_pages,
+	};
+	struct rmap_walk_control rwc = {
+		.arg = (void *)&state,
+		.rmap_one = mapping_wrprotect_range_one,
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
+EXPORT_SYMBOL_GPL(mapping_wrprotect_range);
+
 /**
  * pfn_mkclean_range - Cleans the PTEs (including PMDs) mapped with range of
  *                     [@pfn, @pfn + @nr_pages) at the specific offset (@pgoff)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

