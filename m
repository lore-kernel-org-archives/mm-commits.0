Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B6298CBC
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489847; cv=none; b=XGfoPNP+xUyoPZxlGfdbmFeEfrrzrjBfcjmc8BcHfzl5qaVsQTftXllBVFI5KWEFgW6uMeFnqVvDRjYYly5aMTRXrf2GCUBd61ZUXdTYFDwWQbFRsfx1WU3KopvZVB0yqIWQXQ1SvU0OmfG5uxBaR0rrf6u8trUQRubhLT+0PYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489847; c=relaxed/simple;
	bh=TZA/aFSICDwB5hl3sYkP4c+R2rx7F52Zthvb0/jlDjQ=;
	h=Date:To:From:Subject:Message-Id; b=Tp4/nzlJhSeKtgpL9d/+cazGbTrRmCSSDoEwii7f6Yebf6RP3FKun59mh0z5mWCIxwY2zSkhYE8B22KcLf9s4w7NUh3qsYtUHXcMEXs+vYfQLyAIZPglrexfpajpyE5tjIh7BCUun6X0GRCuxI+BhwEj1qzOtruqkbmSpe6N76g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2X5LxgFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2X5LxgFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C298C4CEE7;
	Sun, 21 Sep 2025 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489847;
	bh=TZA/aFSICDwB5hl3sYkP4c+R2rx7F52Zthvb0/jlDjQ=;
	h=Date:To:From:Subject:From;
	b=2X5LxgFfEltlagagC/EYGdVwDxvLNdF69otyVTSfaw77i7b+ILTISckGyIHDgBH5f
	 KmISkHAJ3nFoYS4ukx3FbYE3X02JkIgZ2Wnc99xrajUpVTY9XLIKpLyTnSopv78vBw
	 gyI/egJvyfOy3qptcB8lqFdQctid+DfkQDDL8rOw=
Date: Sun, 21 Sep 2025 14:24:07 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch removed from -mm tree
Message-Id: <20250921212407.8C298C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
has been removed from the -mm tree.  Its filename was
     mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
Date: Mon, 1 Sep 2025 17:03:55 +0200

There is the concern that unpin_user_page_range_dirty_lock() might do some
weird merging of PFN ranges -- either now or in the future -- such that
PFN range is contiguous but the page range might not be.

Let's sanity-check for that and drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-35-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock
+++ a/mm/gup.c
@@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
 static inline struct folio *gup_folio_range_next(struct page *start,
 		unsigned long npages, unsigned long i, unsigned int *ntails)
 {
-	struct page *next = nth_page(start, i);
+	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
 	unsigned int nr = 1;
 
@@ -342,6 +342,10 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_loc
  * "gup-pinned page range" refers to a range of pages that has had one of the
  * pin_user_pages() variants called on that page.
  *
+ * The page range must be truly physically contiguous: the page range
+ * corresponds to a contiguous PFN range and all pages can be iterated
+ * naturally.
+ *
  * For the page ranges defined by [page .. page+npages], make that range (or
  * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
  * page range was previously listed as clean.
@@ -359,6 +363,8 @@ void unpin_user_page_range_dirty_lock(st
 	struct folio *folio;
 	unsigned int nr;
 
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
+
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
 		if (make_dirty && !folio_test_dirty(folio)) {
_

Patches currently in -mm which might be from david@redhat.com are


