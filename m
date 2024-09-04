Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C9E768FD
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423520; cv=none; b=t9/3z1z3gc1i+tFTxVwuJBj1uClTb79CLqffzp1xI4WfgmkDZIgrgzvR8ecmY82z9M7kP2u8dTT2rsfqtiBxHzDRBIaHu86+Tp0YIdcfasbRUbi/tIuwez1OwQnwWS+uCI/Od+L8e25xsjzpCybriErCRusV8mSepUqjtSwbzkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423520; c=relaxed/simple;
	bh=LHo9IeQsL7N8vFy2R8crzO6J63RO5B2i9O+R1ZP7pKM=;
	h=Date:To:From:Subject:Message-Id; b=S3iVwIXaP5eZjy67u7ClgyreLp55GeO1nPDQMSWLv/odlK2JowkugKGcBEPz+2zGWkQiRbsdhZnZWsHo8lOYLhmjakGv9+uyP25QjjF8qB0frZT7ddghKHfZ6ayqyFgHlod4ZkhPsantkV2l44nbX7eE/gXOapcufSQZkhSbBQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJmHSFAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJmHSFAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A2C4CEC2;
	Wed,  4 Sep 2024 04:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423520;
	bh=LHo9IeQsL7N8vFy2R8crzO6J63RO5B2i9O+R1ZP7pKM=;
	h=Date:To:From:Subject:From;
	b=IJmHSFAtOcaYel4y70biPXKwDL9PJ4qJqudx2PT2Qn2cU+r4/p3Ol0+x5efITF1yi
	 svb+b6o7zp7QQuU3TXlWkIflzjUxo1Y6ikcANO/hyvfD6OLW6Zy/auDZ5FHoXY9W27
	 vBct0a354JtyuE/Bmkj3apAPe+olUou7hFWGQEaA=
Date: Tue, 03 Sep 2024 21:18:40 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-only-one-page_type-per-page.patch removed from -mm tree
Message-Id: <20240904041840.868A2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support only one page_type per page
has been removed from the -mm tree.  Its filename was
     mm-support-only-one-page_type-per-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[wangkefeng.wang@huawei.com: fix ubsan warnings]
  Link: https://lkml.kernel.org/r/2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com
Link: https://lkml.kernel.org/r/20240821173914.2270383-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
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
+	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
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
+	page->page_type = (unsigned int)PGTY_##lname << 24;		\
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

swap-convert-swapon-to-use-a-folio.patch

