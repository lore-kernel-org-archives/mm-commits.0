Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D6FC09
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600546; cv=none; b=akDAjB9NIvnIkbpk1e3YmVx77VoUlzKIltRJtkOihImi1nfF67ZX1WUfCvMGwPGt+IxgoWSgd5IIn/jShG3rlAyfKWuTJAx61vvhMz4YEvsXI1//tRlUotMLsukdLTS0qe3V1pmqAIOfcRblOe9sszx+W7mk2KGq/9H8RRSpfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600546; c=relaxed/simple;
	bh=xidSpQr+RhNlUUc25hRuKwSfjSfGqYdQ9V4JPv0gHEA=;
	h=Date:To:From:Subject:Message-Id; b=dw24DKkXjGO6CB0wIABf1WG4Qlky09JNuyBSekdV6RwOX2MLdVME+fbgZZUOBUKQdlnTJqVPLDO8K33dhGtvrPe6SqnywNVXyPw/llf1aDvhGkRZbypFEa9B1spQL4rmCDnWY5LBtOoM2oweTR+kiaeW03JCSID1P7FM/g41uQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ViIO7ed2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ViIO7ed2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60754C433F1;
	Tue,  5 Mar 2024 01:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600546;
	bh=xidSpQr+RhNlUUc25hRuKwSfjSfGqYdQ9V4JPv0gHEA=;
	h=Date:To:From:Subject:From;
	b=ViIO7ed2NcGpQkbA3dSvSsjSAlAYCs3ykhbLs1ROPR9QKO3G2yzUW1hTIGLPzSJm8
	 68lz/9mgSNxcjxSYLcj43N5P+kSOWBmNXQbMdF/3WVClRUjXbXGengMdniN/NhTrGj
	 S0LLkZ+AvzDZcnoad8Ve/AEPBdyLfWQcQv7zyRJ0=
Date: Mon, 04 Mar 2024 17:02:25 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch removed from -mm tree
Message-Id: <20240305010226.60754C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: use order instead of nr in split_page_owner()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_owner: use order instead of nr in split_page_owner()
Date: Mon, 26 Feb 2024 15:55:30 -0500

We do not have non power of two pages, using nr is error prone if nr is
not power-of-two.  Use page order instead.

Link: https://lkml.kernel.org/r/20240226205534.1603748-5-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

 include/linux/page_owner.h |    9 ++++-----
 mm/huge_memory.c           |    2 +-
 mm/page_alloc.c            |    4 ++--
 mm/page_owner.c            |    3 ++-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int nr);
+extern void __split_page_owner(struct page *page, int order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, unsigned int nr)
+static inline void split_page_owner(struct page *page, int order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, nr);
+		__split_page_owner(page, order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
@@ -59,8 +59,7 @@ static inline void set_page_owner(struct
 			unsigned int order, gfp_t gfp_mask)
 {
 }
-static inline void split_page_owner(struct page *page,
-			unsigned short order)
+static inline void split_page_owner(struct page *page, int order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
--- a/mm/huge_memory.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/huge_memory.c
@@ -2933,7 +2933,7 @@ static void __split_huge_page(struct pag
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
-	split_page_owner(head, nr);
+	split_page_owner(head, order);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_alloc.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/page_alloc.c
@@ -2616,7 +2616,7 @@ void split_page(struct page *page, unsig
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, 1 << order);
+	split_page_owner(page, order);
 	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4801,7 +4801,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, 1 << order);
+		split_page_owner(page, order);
 		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
--- a/mm/page_owner.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/page_owner.c
@@ -306,11 +306,12 @@ void __set_page_owner_migrate_reason(str
 	page_ext_put(page_ext);
 }
 
-void __split_page_owner(struct page *page, unsigned int nr)
+void __split_page_owner(struct page *page, int order)
 {
 	int i;
 	struct page_ext *page_ext = page_ext_get(page);
 	struct page_owner *page_owner;
+	unsigned int nr = 1 << order;
 
 	if (unlikely(!page_ext))
 		return;
_

Patches currently in -mm which might be from ziy@nvidia.com are


