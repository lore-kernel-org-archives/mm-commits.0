Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DBF13A895
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272235; cv=none; b=W3DCoq7WCKIoFMsXFNOGEV/tfVMtrg6mT4HT5t4MnH/HpIgQMR55kNrfVPDjEaKP3pRchzTs+2Y70a9sZiqdCrheQsynoaIyZxoSer0Ce4CV83JQhhEOdmnM/+9F4YVXR7ekjr620c0VPGt25WqOJrU6MNSvZMSYd3WI2Bbtw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272235; c=relaxed/simple;
	bh=RwzeaIu2Vup36Xzv+wjyHH5lgRCcwuD9k2WJEy/d6po=;
	h=Date:To:From:Subject:Message-Id; b=PEVJgeEjlgW6odgS/S0/RhrSDN+522Ie+hV8ATGaRmcM4chfxoemYtMSaqvIXjZuh1uWdozOQNkL0kJN6O6CDyAV1i9GzUTZQykzIO9J0DUp7htIyIi1HpeqvKWPf7zG41YpG3OUtzh70VBHECtl94yFjZYUEnZ2hZRq4EnBHTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kUrrFoUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kUrrFoUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264EAC32781;
	Wed, 21 Aug 2024 20:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272235;
	bh=RwzeaIu2Vup36Xzv+wjyHH5lgRCcwuD9k2WJEy/d6po=;
	h=Date:To:From:Subject:From;
	b=kUrrFoUkzQ7/QNM9Hah+ANqISvA7to/tcZ0Ft9eGxiV9dh4M8+AsPpVnLFcH26kWj
	 m7dIfQ5S+yEzQuOcxB480vdWV8Wfjx2PU4B99iEEivb0QGzVwBoHCWvhJaCaAzeONF
	 b+pKOoiHnNDkArZl4tRuO8ZvtsdwjrxdBHPzcHbA=
Date: Wed, 21 Aug 2024 13:30:34 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-use-all-available-24-bits-of-page_type.patch added to mm-unstable branch
Message-Id: <20240821203035.264EAC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: use all available 24 bits of page_type
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-use-all-available-24-bits-of-page_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-use-all-available-24-bits-of-page_type.patch

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
Subject: zsmalloc: use all available 24 bits of page_type
Date: Wed, 21 Aug 2024 18:39:12 +0100

Now that we have an extra 8 bits, we don't need to limit ourselves to
supporting a 64KiB page size.  I'm sure both Hexagon users are grateful,
but it does reduce complexity a little.  We can also remove
reset_first_obj_offset() as calling __ClearPageZsmalloc() will now reset
all 32 bits of page_type.

Link: https://lkml.kernel.org/r/20240821173914.2270383-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    1 -
 mm/Kconfig                 |   10 ++--------
 mm/zsmalloc.c              |   15 ++++-----------
 3 files changed, 6 insertions(+), 20 deletions(-)

--- a/drivers/block/zram/Kconfig~zsmalloc-use-all-available-24-bits-of-page_type
+++ a/drivers/block/zram/Kconfig
@@ -2,7 +2,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && MMU
-	depends on HAVE_ZSMALLOC
 	select ZSMALLOC
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
--- a/mm/Kconfig~zsmalloc-use-all-available-24-bits-of-page_type
+++ a/mm/Kconfig
@@ -128,7 +128,7 @@ config ZSWAP_COMPRESSOR_DEFAULT
 choice
 	prompt "Default allocator"
 	depends on ZSWAP
-	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if HAVE_ZSMALLOC
+	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
 	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Selects the default allocator for the compressed cache for
@@ -154,7 +154,6 @@ config ZSWAP_ZPOOL_DEFAULT_Z3FOLD
 
 config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
 	bool "zsmalloc"
-	depends on HAVE_ZSMALLOC
 	select ZSMALLOC
 	help
 	  Use the zsmalloc allocator as the default allocator.
@@ -187,15 +186,10 @@ config Z3FOLD
 	  page. It is a ZBUD derivative so the simplicity and determinism are
 	  still there.
 
-config HAVE_ZSMALLOC
-	def_bool y
-	depends on MMU
-	depends on PAGE_SIZE_LESS_THAN_256KB # we want <= 64 KiB
-
 config ZSMALLOC
 	tristate
 	prompt "N:1 compression allocator (zsmalloc)" if ZSWAP
-	depends on HAVE_ZSMALLOC
+	depends on MMU
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
 	  pages of various compression levels efficiently. It achieves
--- a/mm/zsmalloc.c~zsmalloc-use-all-available-24-bits-of-page_type
+++ a/mm/zsmalloc.c
@@ -20,7 +20,7 @@
  *	page->index: links together all component pages of a zspage
  *		For the huge page, this is always 0, so we use this field
  *		to store handle.
- *	page->page_type: PG_zsmalloc, lower 16 bit locate the first object
+ *	page->page_type: PGTY_zsmalloc, lower 24 bits locate the first object
  *		offset in a subpage of a zspage
  *
  * Usage of struct page flags:
@@ -452,13 +452,7 @@ static inline struct page *get_first_pag
 	return first_page;
 }
 
-#define FIRST_OBJ_PAGE_TYPE_MASK	0xffff
-
-static inline void reset_first_obj_offset(struct page *page)
-{
-	VM_WARN_ON_ONCE(!PageZsmalloc(page));
-	page->page_type |= FIRST_OBJ_PAGE_TYPE_MASK;
-}
+#define FIRST_OBJ_PAGE_TYPE_MASK	0xffffff
 
 static inline unsigned int get_first_obj_offset(struct page *page)
 {
@@ -468,8 +462,8 @@ static inline unsigned int get_first_obj
 
 static inline void set_first_obj_offset(struct page *page, unsigned int offset)
 {
-	/* With 16 bit available, we can support offsets into 64 KiB pages. */
-	BUILD_BUG_ON(PAGE_SIZE > SZ_64K);
+	/* With 24 bits available, we can support offsets into 16 MiB pages. */
+	BUILD_BUG_ON(PAGE_SIZE > SZ_16M);
 	VM_WARN_ON_ONCE(!PageZsmalloc(page));
 	VM_WARN_ON_ONCE(offset & ~FIRST_OBJ_PAGE_TYPE_MASK);
 	page->page_type &= ~FIRST_OBJ_PAGE_TYPE_MASK;
@@ -808,7 +802,6 @@ static void reset_page(struct page *page
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	page->index = 0;
-	reset_first_obj_offset(page);
 	__ClearPageZsmalloc(page);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch

