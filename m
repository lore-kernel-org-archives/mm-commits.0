Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C441840869
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146747; cv=none; b=jriaYsBeKdEpSDQybtabeyvSb65BepvXqdUMZ2BJkIHSBH8IKKiqvNcvdq+DyIdb8qYH/WOhIVofKYDIaaMPmXxrOvxlhFjIpNfZ9oQ8ZrmHSjJXOXLe21SKHDdnZJljMdtn2/7eKSdavLVkB3tFtpNeuskezjvVt5mzqodcx2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146747; c=relaxed/simple;
	bh=K8MPBkONqolxU1EoCOianCud+ggR/ttr2KS7sCOZ548=;
	h=Date:To:From:Subject:Message-Id; b=MGbReQ0Fm3Bu9v/kkL27JnXDpZuiZDFSV4ktb/VtONT5fA05hW65137d3bc2jm0LCCZM6HmOVJkJYty+IjAi/u4TAjs2MEUEz0zctSlJxPO05ijEzfbMSnAfhtVWT1t1AWbkNt5dCUTzXSxmCDZGF4yNG0ePgUZgZ4RJJ8GLsd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pEU14kPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pEU14kPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D884C433C7;
	Wed, 28 Feb 2024 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146747;
	bh=K8MPBkONqolxU1EoCOianCud+ggR/ttr2KS7sCOZ548=;
	h=Date:To:From:Subject:From;
	b=pEU14kPUPuS+Kn60Kt6BwlWIxlJ11yC6TtYN41O+rWzLfr1FfPXZMfzud6xkuICTe
	 BVIQRo/Zt9hIYyToEiTSw+uvZeIS3riK9R1I43vVgkbkJyIQcbDwQqMcKfVr0DU5sS
	 5fAAw3274ADmLQQznyuvo4iF3WHI24kS6cA0M8w0=
Date: Wed, 28 Feb 2024 10:59:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-separate-out-folio_flags-from-pageflags.patch added to mm-unstable branch
Message-Id: <20240228185907.3D884C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: separate out FOLIO_FLAGS from PAGEFLAGS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-separate-out-folio_flags-from-pageflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-separate-out-folio_flags-from-pageflags.patch

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
Subject: mm: separate out FOLIO_FLAGS from PAGEFLAGS
Date: Tue, 27 Feb 2024 19:23:28 +0000

Patch series "PageFlags cleanups".

We have now successfully removed all of the uses of some of the PageFlags
from the kernel, but there's nothing to stop somebody reintroducing them. 
By splitting out FOLIO_FLAGS from PAGEFLAGS, we can stop defining the old
flags; and we do that in some of the later patches.

After doing this, I realised that dump_page() was living dangerously; we
could end up calling folio_test_foo() on a pointer which no longer pointed
to a folio (as dump_page() is not necessarily called when the caller has a
reference to the page).  So I fixed that up.

And then I realised that this was the key to making dump_page() take a
const argument, which means we can constify the page flags testing, which
means we can remove more cast-away-the-const bad code.

And here's where I ended up.


This patch (of 8):

We've progressed far enough with the folio transition that some flags are
now no longer checked on pages, but only on folios.  To prevent new users
appearing, prepare to only define the folio versions of the flag
test/set/clear.

Link: https://lkml.kernel.org/r/20240227192337.757313-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240227192337.757313-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   63 +++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 20 deletions(-)

--- a/include/linux/page-flags.h~mm-separate-out-folio_flags-from-pageflags
+++ a/include/linux/page-flags.h
@@ -367,54 +367,77 @@ static unsigned long *folio_flags(struct
 #define FOLIO_PF_NO_COMPOUND	0
 #define FOLIO_PF_SECOND		1
 
+#define FOLIO_HEAD_PAGE		0
+#define FOLIO_SECOND_PAGE	1
+
 /*
  * Macros to create function definitions for page flags
  */
+#define FOLIO_TEST_FLAG(name, page)					\
+static __always_inline bool folio_test_##name(struct folio *folio)	\
+{ return test_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_SET_FLAG(name, page)					\
+static __always_inline void folio_set_##name(struct folio *folio)	\
+{ set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_CLEAR_FLAG(name, page)					\
+static __always_inline void folio_clear_##name(struct folio *folio)	\
+{ clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define __FOLIO_SET_FLAG(name, page)					\
+static __always_inline void __folio_set_##name(struct folio *folio)	\
+{ __set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define __FOLIO_CLEAR_FLAG(name, page)					\
+static __always_inline void __folio_clear_##name(struct folio *folio)	\
+{ __clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_TEST_SET_FLAG(name, page)					\
+static __always_inline bool folio_test_set_##name(struct folio *folio)	\
+{ return test_and_set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_TEST_CLEAR_FLAG(name, page)				\
+static __always_inline bool folio_test_clear_##name(struct folio *folio) \
+{ return test_and_clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_FLAG(name, page)						\
+FOLIO_TEST_FLAG(name, page)						\
+FOLIO_SET_FLAG(name, page)						\
+FOLIO_CLEAR_FLAG(name, page)
+
 #define TESTPAGEFLAG(uname, lname, policy)				\
-static __always_inline bool folio_test_##lname(struct folio *folio)	\
-{ return test_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }	\
+FOLIO_TEST_FLAG(lname, FOLIO_##policy)					\
 static __always_inline int Page##uname(struct page *page)		\
 { return test_bit(PG_##lname, &policy(page, 0)->flags); }
 
 #define SETPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void folio_set_##lname(struct folio *folio)				\
-{ set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void SetPage##uname(struct page *page)		\
 { set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define CLEARPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void folio_clear_##lname(struct folio *folio)				\
-{ clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void ClearPage##uname(struct page *page)		\
 { clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __SETPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void __folio_set_##lname(struct folio *folio)				\
-{ __set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+__FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void __SetPage##uname(struct page *page)		\
 { __set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void __folio_clear_##lname(struct folio *folio)				\
-{ __clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }	\
+__FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 { __clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
-static __always_inline							\
-bool folio_test_set_##lname(struct folio *folio)			\
-{ return test_and_set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); } \
+FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestSetPage##uname(struct page *page)	\
 { return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTCLEARFLAG(uname, lname, policy)				\
-static __always_inline							\
-bool folio_test_clear_##lname(struct folio *folio)			\
-{ return test_and_clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); } \
+FOLIO_TEST_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestClearPage##uname(struct page *page)	\
 { return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
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

