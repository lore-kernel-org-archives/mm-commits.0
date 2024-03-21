Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C688E134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055003; cv=none; b=qN+pfetSdGDT4WDdJTD+h5ZvP0/9dbfd9PKYk8KZNBnVKQ3DMGiRm/JoY/p93rBi8VYUuGOULKCWsAzzlwDTAOMixoI/CZoj/nfLguAFB/1aEjfBaJYT5F/6bwNDlw/yDMFIG6cVQ3/DwJyJ6wsNlO10w5Q7yifsa39rRdJxIu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055003; c=relaxed/simple;
	bh=k8Vj8tRhS+yNr/qeTorDIMmRaMXXe6AeCQDbRRho/IA=;
	h=Date:To:From:Subject:Message-Id; b=qYafxQwI18KrA8if3S9fpMRZtGrjjPiGx/Upr9+J8BOQYNr95ZuHxegaHhr5te+vzGsZ9fSAXIf+xQpxnw9nu/I250sT9NlyhjcYzHOaoaaIR1nZkMoR61cDifir94yIJnnr4YXaM/sC0QygnBO2+3T6lJkQq3Y9PPl9iUTq6Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sX4iOls3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sX4iOls3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C757C433F1;
	Thu, 21 Mar 2024 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055003;
	bh=k8Vj8tRhS+yNr/qeTorDIMmRaMXXe6AeCQDbRRho/IA=;
	h=Date:To:From:Subject:From;
	b=sX4iOls3KgB6fwciZz9N2Q1j7izv3j4AClb5fbqUQZeXaBx5SqCdEWn6Xy7AxxpaF
	 T7gzR8TOpKi3sWrYDLJuwiHYpKPztWxQiUYRWMkqVHjiRcEQpRnauFn20IuTmnPQ2z
	 t3F3YhCSTmzdglF1yvPRnIQBPZ6pTvWlerb42RQM=
Date: Thu, 21 Mar 2024 14:03:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-create-folio_flag_false-and-folio_type_ops-macros.patch added to mm-unstable branch
Message-Id: <20240321210323.4C757C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: create FOLIO_FLAG_FALSE and FOLIO_TYPE_OPS macros
has been added to the -mm mm-unstable branch.  Its filename is
     mm-create-folio_flag_false-and-folio_type_ops-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-create-folio_flag_false-and-folio_type_ops-macros.patch

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
Subject: mm: create FOLIO_FLAG_FALSE and FOLIO_TYPE_OPS macros
Date: Thu, 21 Mar 2024 14:24:40 +0000

Following the separation of FOLIO_FLAGS from PAGEFLAGS, separate
FOLIO_FLAG_FALSE from PAGEFLAG_FALSE and FOLIO_TYPE_OPS from
PAGE_TYPE_OPS.

Link: https://lkml.kernel.org/r/20240321142448.1645400-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   70 +++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 23 deletions(-)

--- a/include/linux/page-flags.h~mm-create-folio_flag_false-and-folio_type_ops-macros
+++ a/include/linux/page-flags.h
@@ -458,30 +458,51 @@ static __always_inline int TestClearPage
 	TESTSETFLAG(uname, lname, policy)				\
 	TESTCLEARFLAG(uname, lname, policy)
 
+#define FOLIO_TEST_FLAG_FALSE(name)					\
+static inline bool folio_test_##name(const struct folio *folio)		\
+{ return false; }
+#define FOLIO_SET_FLAG_NOOP(name)					\
+static inline void folio_set_##name(struct folio *folio) { }
+#define FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void folio_clear_##name(struct folio *folio) { }
+#define __FOLIO_SET_FLAG_NOOP(name)					\
+static inline void __folio_set_##name(struct folio *folio) { }
+#define __FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void __folio_clear_##name(struct folio *folio) { }
+#define FOLIO_TEST_SET_FLAG_FALSE(name)					\
+static inline bool folio_test_set_##name(struct folio *folio)		\
+{ return false; }
+#define FOLIO_TEST_CLEAR_FLAG_FALSE(name)				\
+static inline bool folio_test_clear_##name(struct folio *folio)		\
+{ return false; }
+
+#define FOLIO_FLAG_FALSE(name)						\
+FOLIO_TEST_FLAG_FALSE(name)						\
+FOLIO_SET_FLAG_NOOP(name)						\
+FOLIO_CLEAR_FLAG_NOOP(name)
+
 #define TESTPAGEFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_##lname(const struct folio *folio) { return false; } \
+FOLIO_TEST_FLAG_FALSE(lname)						\
 static inline int Page##uname(const struct page *page) { return 0; }
 
 #define SETPAGEFLAG_NOOP(uname, lname)					\
-static inline void folio_set_##lname(struct folio *folio) { }		\
+FOLIO_SET_FLAG_NOOP(lname)						\
 static inline void SetPage##uname(struct page *page) {  }
 
 #define CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void folio_clear_##lname(struct folio *folio) { }		\
+FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void ClearPage##uname(struct page *page) {  }
 
 #define __CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void __folio_clear_##lname(struct folio *folio) { }	\
+__FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void __ClearPage##uname(struct page *page) {  }
 
 #define TESTSETFLAG_FALSE(uname, lname)					\
-static inline bool folio_test_set_##lname(struct folio *folio)		\
-{ return 0; }								\
+FOLIO_TEST_SET_FLAG_FALSE(lname)					\
 static inline int TestSetPage##uname(struct page *page) { return 0; }
 
 #define TESTCLEARFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_clear_##lname(struct folio *folio)	\
-{ return 0; }								\
+FOLIO_TEST_CLEAR_FLAG_FALSE(lname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 #define PAGEFLAG_FALSE(uname, lname) TESTPAGEFLAG_FALSE(uname, lname)	\
@@ -977,35 +998,38 @@ static inline int page_has_type(const st
 	return page_type_has_type(page->page_type);
 }
 
+#define FOLIO_TYPE_OPS(lname, fname)					\
+static __always_inline bool folio_test_##fname(const struct folio *folio)\
+{									\
+	return folio_test_type(folio, PG_##lname);			\
+}									\
+static __always_inline void __folio_set_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
+	folio->page.page_type &= ~PG_##lname;				\
+}									\
+static __always_inline void __folio_clear_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
+	folio->page.page_type |= PG_##lname;				\
+}
+
 #define PAGE_TYPE_OPS(uname, lname, fname)				\
+FOLIO_TYPE_OPS(lname, fname)						\
 static __always_inline int Page##uname(const struct page *page)		\
 {									\
 	return PageType(page, PG_##lname);				\
 }									\
-static __always_inline int folio_test_##fname(const struct folio *folio)\
-{									\
-	return folio_test_type(folio, PG_##lname);			\
-}									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
 	page->page_type &= ~PG_##lname;					\
 }									\
-static __always_inline void __folio_set_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
-	folio->page.page_type &= ~PG_##lname;				\
-}									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type |= PG_##lname;					\
-}									\
-static __always_inline void __folio_clear_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
-	folio->page.page_type |= PG_##lname;				\
-}									\
+}
 
 /*
  * PageBuddy() indicates that the page is free and in the buddy system
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

