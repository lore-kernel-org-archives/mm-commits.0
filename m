Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625871C230C
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009565; cv=none; b=slOKqGR7C+6URWeNpAyCA9C6+G+zisMAytyt2Ioq0tICOvzNdQvf/2+3i7OAM2K8M8Q3UT1TMky1jmx6nMrNB4ocvtUM7RPDTPGuStSzCpE6Gz3FIpvPW36AYl6alb1fsfCVXH4LBWfCSGPg9+rRkKJ6FKFfA0E3LZdIjNVCQfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009565; c=relaxed/simple;
	bh=tiCh/MQTZmpKLKoNPGQz79d95eguSqmV19t/vH7x1BM=;
	h=Date:To:From:Subject:Message-Id; b=sPHbp1E4r8HJeHSeLifLArAjH64ap8AOQ+6ghozd6pr3iC7zphcD8Sc0jaQO0kjdyiTuusySkaxKzmR3MxP+WEsUMMtBVPvg1YccG3kkBQtevQweqSf+3yo9E1yxBGhj2fKVIDzXVICBtoDmIz+/j6z4FVYk68Cbo2stB/DOnC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHTOnOMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHTOnOMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAC9C113CC;
	Wed, 29 May 2024 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009565;
	bh=tiCh/MQTZmpKLKoNPGQz79d95eguSqmV19t/vH7x1BM=;
	h=Date:To:From:Subject:From;
	b=sHTOnOMxJTsQoQluTtjftiNJ5/bykI8BMd+LPTF+JjXqVwCLBwpEASni7EB1yvtFS
	 1D8qfQtGXlIcX1QGfBnOhD9bYqWYQgwPCBnhR9LVUMwasr+E7HG2v1dOpvUQQLpyv4
	 7kT/RQCwBXTpGxvxxf4ZG9vgcmDeFGbIii0Sf4V4=
Date: Wed, 29 May 2024 12:06:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-use-a-proper-page-type.patch added to mm-unstable branch
Message-Id: <20240529190605.2BAC9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: use a proper page type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-use-a-proper-page-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-use-a-proper-page-type.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/zsmalloc: use a proper page type
Date: Wed, 29 May 2024 13:19:01 +0200

Let's clean it up: use a proper page type and store our data (offset into
a page) in the lower 16 bit as documented.

We won't be able to support 256 KiB base pages, which is acceptable. 
Teach Kconfig to handle that cleanly using a new CONFIG_HAVE_ZSMALLOC.

Based on this, we should do a proper "struct zsdesc" conversion, as
proposed in [1].

This removes the last _mapcount/page_type offender.

[1] https://lore.kernel.org/all/20231130101242.2590384-1-42.hyeyoo@gmail.com/

Link: https://lkml.kernel.org/r/20240529111904.2069608-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    1 +
 include/linux/page-flags.h |    3 +++
 mm/Kconfig                 |   10 ++++++++--
 mm/zsmalloc.c              |   29 +++++++++++++++++++++++++----
 4 files changed, 37 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/Kconfig~mm-zsmalloc-use-a-proper-page-type
+++ a/drivers/block/zram/Kconfig
@@ -2,6 +2,7 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && MMU
+	depends on HAVE_ZSMALLOC
 	select ZSMALLOC
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
--- a/include/linux/page-flags.h~mm-zsmalloc-use-a-proper-page-type
+++ a/include/linux/page-flags.h
@@ -957,6 +957,7 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #define PG_guard	0x08000000
 #define PG_hugetlb	0x04000000
 #define PG_slab		0x02000000
+#define PG_zsmalloc	0x01000000
 #define PAGE_MAPCOUNT_RESERVE	(~0x0000ffff)
 
 #define PageType(page, flag)						\
@@ -1072,6 +1073,8 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
 FOLIO_TEST_FLAG_FALSE(hugetlb)
 #endif
 
+PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
--- a/mm/Kconfig~mm-zsmalloc-use-a-proper-page-type
+++ a/mm/Kconfig
@@ -128,7 +128,7 @@ config ZSWAP_COMPRESSOR_DEFAULT
 choice
 	prompt "Default allocator"
 	depends on ZSWAP
-	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
+	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if HAVE_ZSMALLOC
 	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Selects the default allocator for the compressed cache for
@@ -154,6 +154,7 @@ config ZSWAP_ZPOOL_DEFAULT_Z3FOLD
 
 config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
 	bool "zsmalloc"
+	depends on HAVE_ZSMALLOC
 	select ZSMALLOC
 	help
 	  Use the zsmalloc allocator as the default allocator.
@@ -186,10 +187,15 @@ config Z3FOLD
 	  page. It is a ZBUD derivative so the simplicity and determinism are
 	  still there.
 
+config HAVE_ZSMALLOC
+	def_bool y
+	depends on MMU
+	depends on PAGE_SIZE_LESS_THAN_256KB # we want <= 64 KiB
+
 config ZSMALLOC
 	tristate
 	prompt "N:1 compression allocator (zsmalloc)" if ZSWAP
-	depends on MMU
+	depends on HAVE_ZSMALLOC
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
 	  pages of various compression levels efficiently. It achieves
--- a/mm/zsmalloc.c~mm-zsmalloc-use-a-proper-page-type
+++ a/mm/zsmalloc.c
@@ -20,7 +20,8 @@
  *	page->index: links together all component pages of a zspage
  *		For the huge page, this is always 0, so we use this field
  *		to store handle.
- *	page->page_type: first object offset in a subpage of zspage
+ *	page->page_type: PG_zsmalloc, lower 16 bit locate the first object
+ *		offset in a subpage of a zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
@@ -450,14 +451,28 @@ static inline struct page *get_first_pag
 	return first_page;
 }
 
+#define FIRST_OBJ_PAGE_TYPE_MASK	0xffff
+
+static inline void reset_first_obj_offset(struct page *page)
+{
+	VM_WARN_ON_ONCE(!PageZsmalloc(page));
+	page->page_type |= FIRST_OBJ_PAGE_TYPE_MASK;
+}
+
 static inline unsigned int get_first_obj_offset(struct page *page)
 {
-	return page->page_type;
+	VM_WARN_ON_ONCE(!PageZsmalloc(page));
+	return page->page_type & FIRST_OBJ_PAGE_TYPE_MASK;
 }
 
 static inline void set_first_obj_offset(struct page *page, unsigned int offset)
 {
-	page->page_type = offset;
+	/* With 16 bit available, we can support offsets into 64 KiB pages. */
+	BUILD_BUG_ON(PAGE_SIZE > SZ_64K);
+	VM_WARN_ON_ONCE(!PageZsmalloc(page));
+	VM_WARN_ON_ONCE(offset & ~FIRST_OBJ_PAGE_TYPE_MASK);
+	page->page_type &= ~FIRST_OBJ_PAGE_TYPE_MASK;
+	page->page_type |= offset & FIRST_OBJ_PAGE_TYPE_MASK;
 }
 
 static inline unsigned int get_freeobj(struct zspage *zspage)
@@ -791,8 +806,9 @@ static void reset_page(struct page *page
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page_mapcount_reset(page);
 	page->index = 0;
+	reset_first_obj_offset(page);
+	__ClearPageZsmalloc(page);
 }
 
 static int trylock_zspage(struct zspage *zspage)
@@ -965,11 +981,13 @@ static struct zspage *alloc_zspage(struc
 		if (!page) {
 			while (--i >= 0) {
 				dec_zone_page_state(pages[i], NR_ZSPAGES);
+				__ClearPageZsmalloc(pages[i]);
 				__free_page(pages[i]);
 			}
 			cache_free_zspage(pool, zspage);
 			return NULL;
 		}
+		__SetPageZsmalloc(page);
 
 		inc_zone_page_state(page, NR_ZSPAGES);
 		pages[i] = page;
@@ -1754,6 +1772,9 @@ static int zs_page_migrate(struct page *
 
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
+	/* We're committed, tell the world that this is a Zsmalloc page. */
+	__SetPageZsmalloc(newpage);
+
 	/* The page is locked, so this pointer must remain valid */
 	zspage = get_zspage(page);
 	pool = zspage->pool;
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

