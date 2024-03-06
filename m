Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF6B14AAD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759107; cv=none; b=MyJiZWM0h8d//pTAkQO4mIvasaVMe6LNytA0aOsoG1n2TTMC2kDFxVwMENiW5hD4PdRC+EvndKIljQoVSHfO5XsofMG9APEehhddb/5cM+vPDMj9Pv98tIe85AELIdU7cUhLEyQLBqYPLRIh5PSILULdGFp3w3ghjM3rBNQ0Msw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759107; c=relaxed/simple;
	bh=wEzCrYx5TH3WovVwHuOD31x4kxv/N91Ua7DG7mSGXgY=;
	h=Date:To:From:Subject:Message-Id; b=cvx2lMvly9B6kgD94PDOTGP9zLVqgsdeGxp6qktCfaygCHUSknm+ZCEXa0viHFp5Iwz5oTgMmdQcKq0oAf2yzsURuDFp7p79KfoUqhoyuoB7C0ggM6SArzsv5ecHql/syLx7Pc9MiadD352oXaSpHwqcD0E396XEDgjZPJflf6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kCygEmuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kCygEmuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E76C43390;
	Wed,  6 Mar 2024 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759106;
	bh=wEzCrYx5TH3WovVwHuOD31x4kxv/N91Ua7DG7mSGXgY=;
	h=Date:To:From:Subject:From;
	b=kCygEmuNrmUCibSCslEDVqvCPRJCrEKfpliGNDadQt8U3SJQDhignXCxJh16smL0M
	 mjw9UasyIK40afAW3tgexirf3kz08GM3wWURmkAeTOHrmpQoO28JC61x6yN7o3TrCo
	 bU0XSB+jpdafF6QObn88J/wiB/PkbCG1oqlsVb2I=
Date: Wed, 06 Mar 2024 13:05:06 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-testing-page-folio-flags.patch removed from -mm tree
Message-Id: <20240306210506.D0E76C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify testing page/folio flags
has been removed from the -mm tree.  Its filename was
     mm-constify-testing-page-folio-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify testing page/folio flags
Date: Tue, 27 Feb 2024 19:23:33 +0000

Now that dump_page() takes a const argument, we can constify all the page
flag tests.

Link: https://lkml.kernel.org/r/20240227192337.757313-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/page-flags.h~mm-constify-testing-page-folio-flags
+++ a/include/linux/page-flags.h
@@ -237,7 +237,7 @@ static inline const struct page *page_fi
 }
 #endif
 
-static __always_inline int page_is_fake_head(struct page *page)
+static __always_inline int page_is_fake_head(const struct page *page)
 {
 	return page_fixed_fake_head(page) != page;
 }
@@ -281,12 +281,12 @@ static inline unsigned long _compound_he
  */
 #define folio_page(folio, n)	nth_page(&(folio)->page, n)
 
-static __always_inline int PageTail(struct page *page)
+static __always_inline int PageTail(const struct page *page)
 {
 	return READ_ONCE(page->compound_head) & 1 || page_is_fake_head(page);
 }
 
-static __always_inline int PageCompound(struct page *page)
+static __always_inline int PageCompound(const struct page *page)
 {
 	return test_bit(PG_head, &page->flags) ||
 	       READ_ONCE(page->compound_head) & 1;
@@ -306,6 +306,16 @@ static inline void page_init_poison(stru
 }
 #endif
 
+static const unsigned long *const_folio_flags(const struct folio *folio,
+		unsigned n)
+{
+	const struct page *page = &folio->page;
+
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
+	return &page[n].flags;
+}
+
 static unsigned long *folio_flags(struct folio *folio, unsigned n)
 {
 	struct page *page = &folio->page;
@@ -367,8 +377,8 @@ static unsigned long *folio_flags(struct
  * Macros to create function definitions for page flags
  */
 #define FOLIO_TEST_FLAG(name, page)					\
-static __always_inline bool folio_test_##name(struct folio *folio)	\
-{ return test_bit(PG_##name, folio_flags(folio, page)); }
+static __always_inline bool folio_test_##name(const struct folio *folio) \
+{ return test_bit(PG_##name, const_folio_flags(folio, page)); }
 
 #define FOLIO_SET_FLAG(name, page)					\
 static __always_inline void folio_set_##name(struct folio *folio)	\
@@ -401,7 +411,7 @@ FOLIO_CLEAR_FLAG(name, page)
 
 #define TESTPAGEFLAG(uname, lname, policy)				\
 FOLIO_TEST_FLAG(lname, FOLIO_##policy)					\
-static __always_inline int Page##uname(struct page *page)		\
+static __always_inline int Page##uname(const struct page *page)		\
 { return test_bit(PG_##lname, &policy(page, 0)->flags); }
 
 #define SETPAGEFLAG(uname, lname, policy)				\
@@ -801,7 +811,7 @@ static __always_inline bool folio_test_h
 	return test_bit(PG_head, folio_flags(folio, FOLIO_PF_ANY));
 }
 
-static __always_inline int PageHead(struct page *page)
+static __always_inline int PageHead(const struct page *page)
 {
 	PF_POISONED_CHECK(page);
 	return test_bit(PG_head, &page->flags) && !page_is_fake_head(page);
_

Patches currently in -mm which might be from willy@infradead.org are


