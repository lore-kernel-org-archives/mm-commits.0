Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6F45028;
	Thu, 31 Oct 2024 03:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344514; cv=none; b=QFPc02pOYXwh/U41+rWZuXhHl3uVx9/KjDNXtFOH+mCyMDcpG9khBLE2uRx3xJQSUZKcxSDXrgu9pyQWWvveRWh7xUB3o9IPTwVYPp6EgbruAm7socut+UlVtThfNVx38mgXjzx0QLOdavEo6O36uz4BbK1HvJ3WbfSoJVGEsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344514; c=relaxed/simple;
	bh=6JShtNYxuOM4O/s7OgIml+v8Vh7q+yPzu3mgcaIBDDc=;
	h=Date:To:From:Subject:Message-Id; b=B3QFH+JsOFdOL8Hwo0PaaQeOF7OY3X63kuRo1pXZ1VuF9ayCP9qyWYYSAu7Ib1It8f1DmyCXqr32D4HbOHXFH/ujE4jirwsZ9YPHcMR9cLT1ZDENzVkkVgPtnXXjTLlZF+MPL1tjgcExzEVLA8spRsqLDKB7IG+0KjmNAe1Q7Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d03gL9Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d03gL9Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88268C4CECF;
	Thu, 31 Oct 2024 03:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344514;
	bh=6JShtNYxuOM4O/s7OgIml+v8Vh7q+yPzu3mgcaIBDDc=;
	h=Date:To:From:Subject:From;
	b=d03gL9RsGggT8mcDAFeKEKXUiAdgTvroSPESdDDJg3LkssvP76jh3cZzEMBQLrVHL
	 loHHoJFkWmuCH6T57aPWjn4gEjV1Z85QiKzefkpibS1pu/XSf16XPbMis3ME9cFZ1W
	 nGvNykN4VXF1HHJIWsEbAJn/vLN3PYqSMKKvSZ60=
Date: Wed, 30 Oct 2024 20:15:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,muchun.song@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-allow-set-clear-page_type-again.patch removed from -mm tree
Message-Id: <20241031031514.88268C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow set/clear page_type again
has been removed from the -mm tree.  Its filename was
     mm-allow-set-clear-page_type-again.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-keep-track-of-free-highatomic.patch

