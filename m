Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB4770E5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423522; cv=none; b=rcYeZ9sipbuSbRu5q+l+NebwBSBhqHqCwtic16nfCSh1Ca0DVJOP2zz8Bzg3j8wGiCeK+OQiR96N2l6NAGt5g2aeD0CCQDl05l27IA3Ec3qOJG4663HGx6MnGXyNr9TLac6pi79JaHAkUN39yQRgnZY/vsHkJLTvaxQWLFlgk5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423522; c=relaxed/simple;
	bh=eW2aUQxzAKni1MLz35ZuBvDF3bL42aFlIyWFKRYCy44=;
	h=Date:To:From:Subject:Message-Id; b=s3wVyZFGVpxCap8Xfuy5MukiDMsnyHP2Ic8vavTnm+K1IX5cYq6HO+iA/iXw+QQOHK9TQh3HdIwHA+JCNJSdqFtywGpkr4pS1mYSkZt9gcYlYHQtKb8BLLGYzjX94DrtcQdPRWKOntwBbKKW6l6EtUi5j62b7/jYcEUyfbQPYL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X3c0UQEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X3c0UQEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0717C4CEC2;
	Wed,  4 Sep 2024 04:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423522;
	bh=eW2aUQxzAKni1MLz35ZuBvDF3bL42aFlIyWFKRYCy44=;
	h=Date:To:From:Subject:From;
	b=X3c0UQEz4oDpw3h6KbNxv4fuen0WlWVQLan+TGpqqWYdOuDAjNLsv4D26QHrXCh1u
	 iPxkvmOWklEVKBJ28utuxTNE0X0D6HXzJTJepgWmUxYyfg214+I4IsGQUluGlxQTYp
	 ftQhy9NmOqUmMGEfGkohMSpKeQ9QegAWKdF6N6Bw=
Date: Tue, 03 Sep 2024 21:18:42 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-use-all-available-24-bits-of-page_type.patch removed from -mm tree
Message-Id: <20240904041842.B0717C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: use all available 24 bits of page_type
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-all-available-24-bits-of-page_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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
 	depends on CRYPTO_LZO || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
 	select ZSMALLOC
 	help
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

swap-convert-swapon-to-use-a-folio.patch

