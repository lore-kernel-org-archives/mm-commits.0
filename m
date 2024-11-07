Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A262218D74
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019116; cv=none; b=OO8LhBifAUJCC02G+prhjqsToOkiLKJONmcXfE6vioDsYsIgtWxq35wlW3jv6WaNbx10F1prsJiotmZLFUAkkl6wzB/7muu6sbmGykxUC3YhJWh+pB6aX/0xV4DYakTQ2Hqf5rMNwR+hsz4dKsHjKz+IHHX4trZ8DprywPFHwTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019116; c=relaxed/simple;
	bh=n+rsS2a+YOqUqBzgg8Du8jMJVvi0asYPpgjELwPqfAc=;
	h=Date:To:From:Subject:Message-Id; b=rASajpNOjDfYq1FjW1upwPKpHlslyB2IkXKMZ5oaJrg7NPXM5w8bfR7pag6nvATIQY7RsMKTmwOVLmG3UMQ9ieV82OVNkrm3KoHlyfOmLQaa86m53I/MJlld8cTwgw9pItyWbwnseT4X61M8zGplCSPsiagNN3fEWRdqLtCSYzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vYOXX/S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vYOXX/S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44201C4CECC;
	Thu,  7 Nov 2024 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019116;
	bh=n+rsS2a+YOqUqBzgg8Du8jMJVvi0asYPpgjELwPqfAc=;
	h=Date:To:From:Subject:From;
	b=vYOXX/S8UDxYGcjUEzgJUEo5Q4F8MFZyKfN9vSZwyd0DkwbmYZ76FKRZcVmZD8Ifv
	 y09xD3JJiF8Qae32WKQfD7Q6EzkTgVzd22LsiM6vY8jpk6sjGi0/MbBY/oI1L8HYRG
	 g5OLMA7JyPDnU+ZgNoiY3AO2BHe7Ow7UkPqOdnk8=
Date: Thu, 07 Nov 2024 14:38:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_to_pgoff-to-page_pgoff.patch removed from -mm tree
Message-Id: <20241107223836.44201C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert page_to_pgoff() to page_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_to_pgoff-to-page_pgoff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20241005200121.3231142-1-willy@infradead.org
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
@@ -1276,7 +1276,7 @@ static void __page_check_anon_rmap(struc
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_to_pgoff(page) != linear_page_index(vma, address),
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
 		       page);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


