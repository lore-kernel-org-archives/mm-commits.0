Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CE12B93
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752972448; cv=none; b=EsxYXUBmWUJzZKnGOJE6H3i7g3pmoCUF5EMJjk0omojZVJzBvbUJCMwTN8nJzATXaRFGb9mFnM8ZNipvAAIIyDamEXqoCoGbpr6I7Zy8mxbDhYrK0wscvlsOOHdQqwSv9kZjyevCcHnNL9bfSSRVa+mAB0t9/pZ0fIFscDbVpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752972448; c=relaxed/simple;
	bh=mjK7rCopCyyaP30VtOlgJCHV7PW+kuslcocy5XlfxLA=;
	h=Date:To:From:Subject:Message-Id; b=XFMfTNMBp5xmppmXsiqgcyKpdg/OF77K2eoKIq79CCgmXnLAgL/2K4o28sa0BJ0ORM5flHhghER5e+uwXL9R5pNJtp+D4EejB0F9nCOO6GfvtXc5GTTwbqDMzm7PKJVWfpQAJ2XQ7hOqYnf2ltsNMNk2vtI/etZjU1wGobZ9zUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2Y/Cyxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2Y/Cyxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF57DC4CEF4;
	Sun, 20 Jul 2025 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752972447;
	bh=mjK7rCopCyyaP30VtOlgJCHV7PW+kuslcocy5XlfxLA=;
	h=Date:To:From:Subject:From;
	b=p2Y/CyxzCiJCD7I3kD001PcqXc/1PFc0l9xINd0hjxag7tCS9plu6/M1nGZJX4x4p
	 uGa1eosz7P69bOJ7sr+j7avfoOk3HtdSXasu8CefPfornvzLu71dbS90RSL5rMzT+7
	 c8T6wIxhpx0QuSabEFLy3iG+hH9Dk6hLP+u/tJMg=
Date: Sat, 19 Jul 2025 17:47:27 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch added to mm-new branch
Message-Id: <20250720004727.BF57DC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: get frozen folio refcount with folio_expected_ref_count()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: get frozen folio refcount with folio_expected_ref_count()
Date: Thu, 17 Jul 2025 22:29:59 -0400

Instead of open coding the refcount calculation, use
folio_expected_ref_count() to calculate frozen folio refcount.  Because:

1. __folio_split() does not split a folio with PG_private, so no elevated
   refcount from PG_private;
2. a frozen folio in __folio_split() is fully unmapped, so folio_mapcount()
   in folio_expected_ref_count() is always 0;
3. (mapping || swap_cache) ? folio_nr_pages(folio) is taken care of by
   folio_expected_ref_count() too.

Link: https://lkml.kernel.org/r/20250718023000.4044406-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count
+++ a/mm/huge_memory.c
@@ -3737,6 +3737,7 @@ static int __folio_split(struct folio *f
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct address_space *swap_cache = NULL;
 		struct lruvec *lruvec;
+		int expected_refs;
 
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
@@ -3800,11 +3801,8 @@ static int __folio_split(struct folio *f
 		     new_folio = next) {
 			next = folio_next(new_folio);
 
-			folio_ref_unfreeze(
-				new_folio,
-				1 + ((mapping || swap_cache) ?
-					     folio_nr_pages(new_folio) :
-					     0));
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -3834,8 +3832,8 @@ static int __folio_split(struct folio *f
 		 * Otherwise, a parallel folio_try_get() can grab @folio
 		 * and its caller can see stale page cache entries.
 		 */
-		folio_ref_unfreeze(folio, 1 +
-			((mapping || swap_cache) ? folio_nr_pages(folio) : 0));
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
 
 		unlock_page_lruvec(lruvec);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch

