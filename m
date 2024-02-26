Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA70D133407
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708986333; cv=none; b=PzqOGTIieeMi3rzugp2ARxgyBtq6le6SyflTmRSq1sdonaOGSqlqKFWr/TZ0+wjrPpfmgJD+EM9As5KmxVMtC++FhSGPVljva+r7xNlIGQLWn+G5PEpr98z5RxCXPCPicJtZwYSsOHRo2ilMAMugQwdFKrEJHV6iYQx9uGpFjB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708986333; c=relaxed/simple;
	bh=3c9KqYXurqV0aOFfs59+yTUT14QoGJrRiXvAlJgAP4k=;
	h=Date:To:From:Subject:Message-Id; b=jZQRg2UVCQW2ALD7Zg40UbBckionQ6tFAiz8Ifg7STfHEJWT4+hHFyyYqWQZc9CxX5n/obk8zDg/oWUzGtl52n7ZOsY+fXWZKQ7LSdZNy4l1eHhRlS5m9Fv3BWE8jcHsic7Gh3RYuJXwejK1twT4qDfKFcCyJH9F2uVrjCmrfyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y3PbMQBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y3PbMQBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2349C433C7;
	Mon, 26 Feb 2024 22:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708986332;
	bh=3c9KqYXurqV0aOFfs59+yTUT14QoGJrRiXvAlJgAP4k=;
	h=Date:To:From:Subject:From;
	b=y3PbMQBvDd34KEAKDQxE7WG+a/0v2W6UiA1vX4EXdQpu7XZRhpTgiCusQP6j0I9dX
	 7hP+XPAuA6oMNc8dOb/K2tcol+kNjedNVQCXLVoJL0QxdUyblqH0svrxVQjxpREkC0
	 Rk+5pxboUa20jd+mCkjdMLRgzVYiRFjiG7FMIjMg=
Date: Mon, 26 Feb 2024 14:25:32 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch added to mm-unstable branch
Message-Id: <20240226222532.A2349C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_owner: add support for splitting to any order in split page_owner
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_owner: add support for splitting to any order in split page_owner
Date: Mon, 26 Feb 2024 15:55:32 -0500

It adds a new_order parameter to set new page order in page owner.  It
prepares for upcoming changes to support split huge page to any lower
order.

Link: https://lkml.kernel.org/r/20240226205534.1603748-7-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   13 ++++++++-----
 mm/huge_memory.c           |    2 +-
 mm/page_alloc.c            |    4 ++--
 mm/page_owner.c            |    7 +++----
 4 files changed, 14 insertions(+), 12 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/include/linux/page_owner.h
@@ -11,7 +11,8 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, int order);
+extern void __split_page_owner(struct page *page, int old_order,
+			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +32,11 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, int order)
+static inline void split_page_owner(struct page *page, int old_order,
+			int new_order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, old_order, new_order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
@@ -56,10 +58,11 @@ static inline void reset_page_owner(stru
 {
 }
 static inline void set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask)
+			unsigned short order, gfp_t gfp_mask)
 {
 }
-static inline void split_page_owner(struct page *page, int order)
+static inline void split_page_owner(struct page *page, int old_order,
+			int new_order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
--- a/mm/huge_memory.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/huge_memory.c
@@ -2933,7 +2933,7 @@ static void __split_huge_page(struct pag
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
-	split_page_owner(head, order);
+	split_page_owner(head, order, 0);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_alloc.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_alloc.c
@@ -2616,7 +2616,7 @@ void split_page(struct page *page, unsig
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order);
+	split_page_owner(page, order, 0);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4803,7 +4803,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order);
+		split_page_owner(page, order, 0);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
--- a/mm/page_owner.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_owner.c
@@ -306,19 +306,18 @@ void __set_page_owner_migrate_reason(str
 	page_ext_put(page_ext);
 }
 
-void __split_page_owner(struct page *page, int order)
+void __split_page_owner(struct page *page, int old_order, int new_order)
 {
 	int i;
 	struct page_ext *page_ext = page_ext_get(page);
 	struct page_owner *page_owner;
-	unsigned int nr = 1 << order;
 
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < (1 << old_order); i++) {
 		page_owner = get_page_owner(page_ext);
-		page_owner->order = 0;
+		page_owner->order = new_order;
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch
mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch

