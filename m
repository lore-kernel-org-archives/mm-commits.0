Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CB5921EF
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890125; cv=none; b=pEVyd6los0j1jjl9GOalLlw7HlHnLyw0UA94JxJQjDHPJBKqk/Ga47+KstwK0hU3Y7WhfCA+jJIjRYqoU2Y5H5/XVqs6p/2bAq4ajIv4IyWTZlD5TVu77xzGsPYdGH5w+62wEY2jzwSQPkKmFzZsjBaWT9TTl/ZJS+BBm0xXhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890125; c=relaxed/simple;
	bh=HdpaWnWK6iCht2CBnGxfB3RIh8fGCp0r9MQi5ww3x10=;
	h=Date:To:From:Subject:Message-Id; b=klMYMib+FPKun1eexYMFcjD1sVxO1UdVHOeuVU44P/d0A9zBUbcNU95M0qBAeCwKSKTn56TE7taJ/8sgGPbwcYK6aJw7iI1smNv5wdOCu7o0JmmGtr6J1EXzIzCIMdFsxYvJtveujHmp/aZ58nA3ckhIBsFCHJkg1Ep/1Q0iQcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=osr5I5QB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="osr5I5QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9E01F00ACF;
	Tue,  8 Sep 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890123;
	bh=9tQbeszmrXhSx0i5ZmRcNza5o7usjCyfHlWCaigk7w8=;
	h=Date:To:From:Subject;
	b=osr5I5QBRt8Z5t4iM/XpK3KHOJ3a8tuScrSKi1r5FrHZzY83mKvtYtAwEUioRZa74
	 wbi/C4IqywtetBgLzNAxQLdF/9Fw6gdMNybKyaiTQyKQaT4JkMU8nh8fbIEgAt/eJ7
	 SovVQmaExfSUYd8UyW5Y1r/4/aGtQIglk2vm/+5Q=
Date: Tue, 08 Sep 2026 10:55:23 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch added to mm-new branch
Message-Id: <20260908175523.AD9E01F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: add folio_swap_entry() and folio_page_swap_entry()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swap: add folio_swap_entry() and folio_page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:31 -0400

Patch series "mm: remove page_swap_entry()", v2.

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio.  The swap entry is folio
state, but the only helper for it is page-based: page_swap_entry() takes a
page and recomputes the folio its callers already hold.  Several callers
avoid it by open-coding the arithmetic on folio->swap instead.

Add folio_swap_entry() and folio_page_swap_entry(), convert all users, and
remove page_swap_entry(), with a few other cleanups along the way.


This patch (of 8):

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio.  page_swap_entry() hides
this behind a compound_head() call, and callers that already have the
folio sometimes open-code the arithmetic instead.

Add folio_swap_entry(), which takes a folio and a page index, and
folio_page_swap_entry() for callers that have the page.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu
Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/include/linux/swap.h~mm-swap-add-folio_swap_entry-and-folio_page_swap_entry
+++ a/include/linux/swap.h
@@ -272,6 +272,39 @@ struct swap_info_struct {
 	const struct swap_ops *ops;
 };
 
+/**
+ * folio_swap_entry - Return the swap entry for a page within a folio.
+ * @folio: The folio.
+ * @idx: The index of the page within the folio.
+ *
+ * A folio in the swap cache occupies folio_nr_pages() contiguous swap
+ * entries starting at folio->swap. The caller must ensure the folio is
+ * in the swap cache and that @idx is within the folio.
+ */
+static inline
+swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
+{
+	swp_entry_t entry = folio->swap;
+
+	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
+	entry.val += idx;
+	return entry;
+}
+
+/**
+ * folio_page_swap_entry - Return the swap entry of a page in a folio.
+ * @folio: The folio containing @page.
+ * @page: A page within @folio.
+ *
+ * The caller must ensure the folio is in the swap cache and that @page
+ * is part of @folio.
+ */
+static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
+		const struct page *page)
+{
+	return folio_swap_entry(folio, folio_page_idx(folio, page));
+}
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch

