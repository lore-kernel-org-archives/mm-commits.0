Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DBA3C3C;
	Thu, 24 Oct 2024 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739166; cv=none; b=N727xeE0+mXjFF8FfZlGP+cDGHu9vV0gUnWw7ZhsLXJe/cbqck4RCyVDvr+E2WyJlGj21oTmtIXiiPzieEbquIv66OV3as4DO8+D9k7Tife/hq/Z5lWjldNGg924js+RYW9HtslDXZ3duly2GbKlCoTvbM7+cGJbANG5AccgypM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739166; c=relaxed/simple;
	bh=dF/uEdjp7XCdcvyqim5Oe90hy9drx039jE3OemR4uKg=;
	h=Date:To:From:Subject:Message-Id; b=V3twLiV5meR3VH5haBfDCwySTpm6Orf2daw1iuz8vPorh+sKJLUQaAPYtw0ALYEMYAIMf5HoXBPOAzEJvBwemH6BsdAKhScwtrrYIgFhxjDyGDSUbw1H8nat1WH6OFQVEtW/24qKbE/BN9CaPyg+e2Id6iWyX2ZD6lyhtvEReBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZDrKZ84R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZDrKZ84R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582ABC4CEC6;
	Thu, 24 Oct 2024 03:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739166;
	bh=dF/uEdjp7XCdcvyqim5Oe90hy9drx039jE3OemR4uKg=;
	h=Date:To:From:Subject:From;
	b=ZDrKZ84RgZfNqFpF0DRI/6fAonUHGDZarraQU7BuV+BbvUIGxJWfMcCFYSl+/SPEI
	 iOB5nKYYSyv9e7KmwKi8BlrEB3HyIGIqCABMF1BG9ucvPOrJim/pZ+HJCmrTGUg7DO
	 G/XP3qUKTFjvU7sYDDrNwq1txp9z3KiXy4udO6ys=
Date: Wed, 23 Oct 2024 20:06:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,muchun.song@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-set-clear-page_type-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024030606.582ABC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow set/clear page_type again
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-allow-set-clear-page_type-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-set-clear-page_type-again.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: allow set/clear page_type again
Date: Sat, 19 Oct 2024 22:22:12 -0600

Some page flags (page->flags) were converted to page types
(page->page_types).  A recent example is PG_hugetlb.

From the exclusive writer's perspective, e.g., a thread doing
__folio_set_hugetlb(), there is a difference between the page flag and
type APIs: the former allows the same non-atomic operation to be repeated
whereas the latter does not.  For example, calling __folio_set_hugetlb()
twice triggers VM_BUG_ON_FOLIO(), since the second call expects the type
(PG_hugetlb) not to be set previously.

Using add_hugetlb_folio() as an example, it calls __folio_set_hugetlb() in
the following error-handling path.  And when that happens, it triggers the
aforementioned VM_BUG_ON_FOLIO().

  if (folio_test_hugetlb(folio)) {
    rc = hugetlb_vmemmap_restore_folio(h, folio);
    if (rc) {
      spin_lock_irq(&hugetlb_lock);
      add_hugetlb_folio(h, folio, false);
      ...

It is possible to make hugeTLB comply with the new requirements from the
page type API.  However, a straightforward fix would be to just allow the
same page type to be set or cleared again inside the API, to avoid any
changes to its callers.

Link: https://lkml.kernel.org/r/20241020042212.296781-1-yuzhao@google.com
Fixes: d99e3140a4d3 ("mm: turn folio_test_hugetlb into a PageType")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/page-flags.h~mm-allow-set-clear-page_type-again
+++ a/include/linux/page-flags.h
@@ -975,12 +975,16 @@ static __always_inline bool folio_test_#
 }									\
 static __always_inline void __folio_set_##fname(struct folio *folio)	\
 {									\
+	if (folio_test_##fname(folio))					\
+		return;							\
 	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
 			folio);						\
 	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
+	if (folio->page.page_type == UINT_MAX)				\
+		return;							\
 	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
 	folio->page.page_type = UINT_MAX;				\
 }
@@ -993,11 +997,15 @@ static __always_inline int Page##uname(c
 }									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
+	if (Page##uname(page))						\
+		return;							\
 	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
 	page->page_type = (unsigned int)PGTY_##lname << 24;		\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
+	if (page->page_type == UINT_MAX)				\
+		return;							\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type = UINT_MAX;					\
 }
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-allow-set-clear-page_type-again.patch

