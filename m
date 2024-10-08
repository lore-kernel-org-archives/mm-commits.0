Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4305E1863E
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352557; cv=none; b=Bw3w02hkcmf3O61I6Z29w5Z5LgVcqZtT73SMc6kEeQYqkJqCtXvC2eu2ML9c2naW8hEa20rXsSxHtYAWU/VL9K6cVNIgTKCVLy0tjeiqE7XvTeXHaqxWP6pMo790++a6wMFerjkoq8PL+JmxpRkP6z6xlP2h0GtezUGp7+ZbHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352557; c=relaxed/simple;
	bh=OMuygRwuafpvgDA2UZ3dgd2QyL2r0Li0Y4RDzouH+tc=;
	h=Date:To:From:Subject:Message-Id; b=skd4I0Jr+jltXNtZVDH7B9F2NWtxAivyxelx61cDVIUFKcaov7OkbEKcrcUG7Dvn9PrQX3YK25Pfaeudxz/dtAfKEyPydtfrB93SoqxoYqgFTmkql6lB5A8IPGkVrS8w8+l37XRs5iA8qf18njAQ5rxAQmBhHoCQYv9N5YhMH7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0/JhQIj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0/JhQIj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04493C4CEC6;
	Tue,  8 Oct 2024 01:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352557;
	bh=OMuygRwuafpvgDA2UZ3dgd2QyL2r0Li0Y4RDzouH+tc=;
	h=Date:To:From:Subject:From;
	b=0/JhQIj21FQF4y0OfC2emAs5gQN3HzC56kX6Bnz1JzrQl2yMJPySqnlpDXwceKKDL
	 hsVOUPOjHQ0R8xn4+VmovglR5ZXIUlSHLwohtl9fjj2DSqEjmTPQdKP1HQFV3xofEz
	 Rzrjz76ZhpfRH4tqF9mucLt6lw/9movN3hFHnDdU=
Date: Mon, 07 Oct 2024 18:55:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_to_pgoff-to-page_pgoff.patch added to mm-unstable branch
Message-Id: <20241008015557.04493C4CEC6@smtp.kernel.org>
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
Date: Sat, 5 Oct 2024 21:01:12 +0100

Patch series "page->index removals in mm", v2.

As part of shrinking struct page, we need to stop using page->index.  This
patchset gets rid of most of the remaining references to page->index in
mm, as well as increasing the number of functions which take a const
folio/page pointer.  It shrinks the text segment of mm by a few hundred
bytes in my test config, probably mostly from removing calls to
compound_head() in page_to_pgoff().


This patch (of 7):

Change the function signature to pass in the folio as all three callers
have it.  This removes a reference to page->index, which we're trying to
get rid of.  And add kernel-doc.

Link: https://lkml.kernel.org/r/20241005200121.3231142-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    2 +-
 include/linux/pagemap.h |   31 +++++++++++++++++--------------
 mm/memory-failure.c     |    4 ++--
 mm/rmap.c               |    2 +-
 4 files changed, 21 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/include/linux/mm.h
@@ -1895,7 +1895,7 @@ static inline unsigned long page_to_sect
  *
  * Return: The Page Frame Number of the first page in the folio.
  */
-static inline unsigned long folio_pfn(struct folio *folio)
+static inline unsigned long folio_pfn(const struct folio *folio)
 {
 	return page_to_pfn(&folio->page);
 }
--- a/include/linux/pagemap.h~mm-convert-page_to_pgoff-to-page_pgoff
+++ a/include/linux/pagemap.h
@@ -1011,22 +1011,25 @@ static inline struct folio *read_mapping
 	return read_cache_folio(mapping, index, NULL, file);
 }
 
-/*
- * Get the offset in PAGE_SIZE (even for hugetlb pages).
+/**
+ * page_pgoff - Calculate the logical page offset of this page.
+ * @folio: The folio containing this page.
+ * @page: The page which we need the offset of.
+ *
+ * For file pages, this is the offset from the beginning of the file
+ * in units of PAGE_SIZE.  For anonymous pages, this is the offset from
+ * the beginning of the anon_vma in units of PAGE_SIZE.  This will
+ * return nonsense for KSM pages.
+ *
+ * Context: Caller must have a reference on the folio or otherwise
+ * prevent it from being split or freed.
+ *
+ * Return: The offset in units of PAGE_SIZE.
  */
-static inline pgoff_t page_to_pgoff(struct page *page)
+static inline pgoff_t page_pgoff(const struct folio *folio,
+		const struct page *page)
 {
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
+	return folio->index + folio_page_idx(folio, page);
 }
 
 /*
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
@@ -1280,7 +1280,7 @@ static void __page_check_anon_rmap(struc
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_to_pgoff(page) != linear_page_index(vma, address),
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
 		       page);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

