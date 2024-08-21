Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F0013A895
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272233; cv=none; b=fGeFOPXdm4sMMlULanOQM+QQpiGKcyH3A65dQthMVRGmqdR+BgEC6sXsUOjhEIcdIW2CPj3a47x+MFjPWIxOgRO3U8xUA+EIUOWRYFt2YQC580t2lcqwPYzEavaMYWCHJ0Q7My5XCQzdvKXyJZBCAXri5GNnrHhevqAaELj4kKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272233; c=relaxed/simple;
	bh=Wjrc0ZZDQqRI9u3xGIKbpF5GbC5RZBgoiIEzNAi2XrY=;
	h=Date:To:From:Subject:Message-Id; b=mQdsa1eWaJjEPiuhMpr2cY3e6g11jhWYVIlgWO+iCXVOaSWCdEjItMQjNTBHVkldMwjduOxCUzaaA59+7J7IPCV+4H99dYBGSCUEZ12sNi1YRCkUFh07rpmng5+pQRMhKQRu7UKUDNs1KqkB00Dx4/xvJNHtCghKtdoMpG4AiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oxlk+0lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oxlk+0lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA8C32781;
	Wed, 21 Aug 2024 20:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272233;
	bh=Wjrc0ZZDQqRI9u3xGIKbpF5GbC5RZBgoiIEzNAi2XrY=;
	h=Date:To:From:Subject:From;
	b=Oxlk+0lXEB+zspuWUD4I3AOZDgvsjg4Vw03UlEpAOfLZ/sBAce6vd/NMdi0gT+JnN
	 4OnTihlqbeqk5YBYDCAZyAUe/cFXCdWzWEf4YJBNMj8b0QBFS9Sg2Xuy/vyfBWdDwQ
	 Yf/PKja9JXjsFAo4bGvkv60jrZWhM1rnWFUeVSCY=
Date: Wed, 21 Aug 2024 13:30:32 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-only-one-page_type-per-page.patch added to mm-unstable branch
Message-Id: <20240821203033.48EA8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support only one page_type per page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-only-one-page_type-per-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-only-one-page_type-per-page.patch

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
Subject: mm: support only one page_type per page
Date: Wed, 21 Aug 2024 18:39:11 +0100

By using a few values in the top byte, users of page_type can store up to
24 bits of additional data in page_type.  It also reduces the code size as
(with replacement of READ_ONCE() with data_race()), the kernel can check
just a single byte.  eg:

ffffffff811e3a79:       8b 47 30                mov    0x30(%rdi),%eax
ffffffff811e3a7c:       55                      push   %rbp
ffffffff811e3a7d:       48 89 e5                mov    %rsp,%rbp
ffffffff811e3a80:       25 00 00 00 82          and    $0x82000000,%eax
ffffffff811e3a85:       3d 00 00 00 80          cmp    $0x80000000,%eax
ffffffff811e3a8a:       74 4d                   je     ffffffff811e3ad9 <folio_mapping+0x69>

becomes:

ffffffff811e3a69:       80 7f 33 f5             cmpb   $0xf5,0x33(%rdi)
ffffffff811e3a6d:       55                      push   %rbp
ffffffff811e3a6e:       48 89 e5                mov    %rsp,%rbp
ffffffff811e3a71:       74 4d                   je     ffffffff811e3ac0 <folio_mapping+0x60>

replacing three instructions with one.

Link: https://lkml.kernel.org/r/20240821173914.2270383-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   68 ++++++++++++++---------------------
 kernel/vmcore_info.c       |    8 ++--
 mm/debug.c                 |   31 ++++++++++++---
 3 files changed, 56 insertions(+), 51 deletions(-)

--- a/include/linux/page-flags.h~mm-support-only-one-page_type-per-page
+++ a/include/linux/page-flags.h
@@ -923,42 +923,29 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #endif
 
 /*
- * For pages that are never mapped to userspace,
- * page_type may be used.  Because it is initialised to -1, we invert the
- * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
- * __ClearPageFoo *sets* the bit used for PageFoo.  We reserve a few high and
- * low bits so that an underflow or overflow of _mapcount won't be
- * mistaken for a page type value.
+ * For pages that do not use mapcount, page_type may be used.
+ * The low 24 bits of pagetype may be used for your own purposes, as long
+ * as you are careful to not affect the top 8 bits.  The low bits of
+ * pagetype will be overwritten when you clear the page_type from the page.
  */
-
 enum pagetype {
-	PG_buddy	= 0x40000000,
-	PG_offline	= 0x20000000,
-	PG_table	= 0x10000000,
-	PG_guard	= 0x08000000,
-	PG_hugetlb	= 0x04000000,
-	PG_slab		= 0x02000000,
-	PG_zsmalloc	= 0x01000000,
-	PG_unaccepted	= 0x00800000,
-
-	PAGE_TYPE_BASE	= 0x80000000,
-
-	/*
-	 * Reserve 0xffff0000 - 0xfffffffe to catch _mapcount underflows and
-	 * allow owners that set a type to reuse the lower 16 bit for their own
-	 * purposes.
-	 */
-	PAGE_MAPCOUNT_RESERVE	= ~0x0000ffff,
-};
+	/* 0x00-0x7f are positive numbers, ie mapcount */
+	/* Reserve 0x80-0xef for mapcount overflow. */
+	PGTY_buddy	= 0xf0,
+	PGTY_offline	= 0xf1,
+	PGTY_table	= 0xf2,
+	PGTY_guard	= 0xf3,
+	PGTY_hugetlb	= 0xf4,
+	PGTY_slab	= 0xf5,
+	PGTY_zsmalloc	= 0xf6,
+	PGTY_unaccepted	= 0xf7,
 
-#define PageType(page, flag)						\
-	((READ_ONCE(page->page_type) & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
-#define folio_test_type(folio, flag)					\
-	((READ_ONCE(folio->page.page_type) & (PAGE_TYPE_BASE | flag))  == PAGE_TYPE_BASE)
+	PGTY_mapcount_underflow = 0xff
+};
 
 static inline bool page_type_has_type(int page_type)
 {
-	return page_type < PAGE_MAPCOUNT_RESERVE;
+	return page_type < (PGTY_mapcount_underflow << 24);
 }
 
 /* This takes a mapcount which is one more than page->_mapcount */
@@ -969,40 +956,41 @@ static inline bool page_mapcount_is_type
 
 static inline bool page_has_type(const struct page *page)
 {
-	return page_type_has_type(READ_ONCE(page->page_type));
+	return page_mapcount_is_type(data_race(page->page_type));
 }
 
 #define FOLIO_TYPE_OPS(lname, fname)					\
-static __always_inline bool folio_test_##fname(const struct folio *folio)\
+static __always_inline bool folio_test_##fname(const struct folio *folio) \
 {									\
-	return folio_test_type(folio, PG_##lname);			\
+	return data_race(folio->page.page_type >> 24) == PGTY_##lname;	\
 }									\
 static __always_inline void __folio_set_##fname(struct folio *folio)	\
 {									\
-	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
-	folio->page.page_type &= ~PG_##lname;				\
+	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
+			folio);						\
+	folio->page.page_type = PGTY_##lname << 24;			\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
 	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
-	folio->page.page_type |= PG_##lname;				\
+	folio->page.page_type = UINT_MAX;				\
 }
 
 #define PAGE_TYPE_OPS(uname, lname, fname)				\
 FOLIO_TYPE_OPS(lname, fname)						\
 static __always_inline int Page##uname(const struct page *page)		\
 {									\
-	return PageType(page, PG_##lname);				\
+	return data_race(page->page_type >> 24) == PGTY_##lname;	\
 }									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
-	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
-	page->page_type &= ~PG_##lname;					\
+	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
+	page->page_type = PGTY_##lname << 24;				\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
-	page->page_type |= PG_##lname;					\
+	page->page_type = UINT_MAX;					\
 }
 
 /*
--- a/kernel/vmcore_info.c~mm-support-only-one-page_type-per-page
+++ a/kernel/vmcore_info.c
@@ -198,17 +198,17 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
-#define PAGE_SLAB_MAPCOUNT_VALUE	(~PG_slab)
+#define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)
 	VMCOREINFO_NUMBER(PAGE_SLAB_MAPCOUNT_VALUE);
 #ifdef CONFIG_MEMORY_FAILURE
 	VMCOREINFO_NUMBER(PG_hwpoison);
 #endif
 	VMCOREINFO_NUMBER(PG_head_mask);
-#define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
+#define PAGE_BUDDY_MAPCOUNT_VALUE	(PGTY_buddy << 24)
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
-#define PAGE_HUGETLB_MAPCOUNT_VALUE	(~PG_hugetlb)
+#define PAGE_HUGETLB_MAPCOUNT_VALUE	(PGTY_hugetlb << 24)
 	VMCOREINFO_NUMBER(PAGE_HUGETLB_MAPCOUNT_VALUE);
-#define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
+#define PAGE_OFFLINE_MAPCOUNT_VALUE	(PGTY_offline << 24)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
 
 #ifdef CONFIG_KALLSYMS
--- a/mm/debug.c~mm-support-only-one-page_type-per-page
+++ a/mm/debug.c
@@ -36,11 +36,6 @@ const struct trace_print_flags pageflag_
 	{0, NULL}
 };
 
-const struct trace_print_flags pagetype_names[] = {
-	__def_pagetype_names,
-	{0, NULL}
-};
-
 const struct trace_print_flags gfpflag_names[] = {
 	__def_gfpflag_names,
 	{0, NULL}
@@ -51,6 +46,27 @@ const struct trace_print_flags vmaflag_n
 	{0, NULL}
 };
 
+#define DEF_PAGETYPE_NAME(_name) [PGTY_##_name - 0xf0] =  __stringify(_name)
+
+static const char *page_type_names[] = {
+	DEF_PAGETYPE_NAME(slab),
+	DEF_PAGETYPE_NAME(hugetlb),
+	DEF_PAGETYPE_NAME(offline),
+	DEF_PAGETYPE_NAME(guard),
+	DEF_PAGETYPE_NAME(table),
+	DEF_PAGETYPE_NAME(buddy),
+	DEF_PAGETYPE_NAME(unaccepted),
+};
+
+static const char *page_type_name(unsigned int page_type)
+{
+	unsigned i = (page_type >> 24) - 0xf0;
+
+	if (i >= ARRAY_SIZE(page_type_names))
+		return "unknown";
+	return page_type_names[i];
+}
+
 static void __dump_folio(struct folio *folio, struct page *page,
 		unsigned long pfn, unsigned long idx)
 {
@@ -58,7 +74,7 @@ static void __dump_folio(struct folio *f
 	int mapcount = atomic_read(&page->_mapcount);
 	char *type = "";
 
-	mapcount = page_type_has_type(mapcount) ? 0 : mapcount + 1;
+	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount + 1;
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
@@ -92,7 +108,8 @@ static void __dump_folio(struct folio *f
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
 		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
 	if (page_has_type(&folio->page))
-		pr_warn("page_type: %x\n", folio->page.page_type);
+		pr_warn("page_type: %x(%s)\n", folio->page.page_type >> 24,
+				page_type_name(folio->page.page_type));
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch

