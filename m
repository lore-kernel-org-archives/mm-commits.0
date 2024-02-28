Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D057440B
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146754; cv=none; b=L6ypEn18nsnZstHRHhPslhWcXGYQ03DJro/j9sxP4bcRv/BBLCxFIBAAUNYyxja8lFZt21HLE6Zv6cH8iybJtV2H1plNO/Im3P3SoAExDVT/9Dpp6j8VCWtsz02xqmEItWmHpArxAIG6r4dv46pS3ndYuB0eTuIToIDx1OFbY9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146754; c=relaxed/simple;
	bh=r6fxQaIAhNRKZMqsg9qldXtVSA2moJGwqehTzfwEH8A=;
	h=Date:To:From:Subject:Message-Id; b=s2WOUuYvru/KIRE9V9X9ARafxvDs+1O9OLMllzZtp+HJn6Di1SeX0jTFAeDPSgxYXkcTpSGNDWen/kVsaf5nHNqSC2eYt3gyDSDLxMdnYty/2dIbeoA5GnhPaODrFkHFPCAXCiuaAoPlPau17GLkXDrWHYI491oXKgBn35ErmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njBSbwWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njBSbwWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FE9C433F1;
	Wed, 28 Feb 2024 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146754;
	bh=r6fxQaIAhNRKZMqsg9qldXtVSA2moJGwqehTzfwEH8A=;
	h=Date:To:From:Subject:From;
	b=njBSbwWNPKfhFbOkj6zjO8ZUzx9mFN3oxKskvdB4KCKIcAAbf4NYgSHs757VIYwEl
	 ka9HM7Pdttuj19O8CZ68kG4eWHqOQdzeZhK+gZPmNEp3FV4AKc/AJ/ajJ4syI67r3Q
	 MCoj9b2UvUZV4XxOaqq3mnL+HcYxtpsRia5XMpG4=
Date: Wed, 28 Feb 2024 10:59:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-testing-page-folio-flags.patch added to mm-unstable branch
Message-Id: <20240228185914.27FE9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify testing page/folio flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-constify-testing-page-folio-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-testing-page-folio-flags.patch

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
Subject: mm: constify testing page/folio flags
Date: Tue, 27 Feb 2024 19:23:33 +0000

Now that dump_page() takes a const argument, we can constify all the page
flag tests.

Link: https://lkml.kernel.org/r/20240227192337.757313-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

