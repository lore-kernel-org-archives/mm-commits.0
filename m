Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856541607AA
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006236; cv=none; b=c2WArCusKKEM6Rr/cj3Iz5AbSBkARRybW/KLk0NhNSCI/amTrWPvPs3KL9YoLdNhMSqtxt84oxsa9JIsocP5QF+XqJifnPsdbNhbVRqdO6YMlK2GawMqsLJK00RDpBayQg6gpwwuprBSrfizz33KLuNLrIgnfZsRoEz/VTJbmWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006236; c=relaxed/simple;
	bh=/gTP1ind8sRVIJNXZqejMIvcpbRp2VlpeKleIqw+j0Y=;
	h=Date:To:From:Subject:Message-Id; b=GWQI8ZPvaUfBVqnALu+QAxi8dybiUqykNJIaC5IfMLlXrgQWv8Z8LAvLqeX48O0ekOUr9VGSvxHM7e/T2yeSVGXYBa1tjeDHez9yXnyacsf9aG3Is5JngmpICitPQDlQwMaHvGpNdVz3uHeuDG6M95WZ3OZvDOir0x7Fyyh/V9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PaNDp7ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PaNDp7ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59565C4CED6;
	Thu, 16 Jan 2025 05:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006236;
	bh=/gTP1ind8sRVIJNXZqejMIvcpbRp2VlpeKleIqw+j0Y=;
	h=Date:To:From:Subject:From;
	b=PaNDp7adgKEJZ0OtMry0cu1YhzOukgOEkr2mdnY2tXAoWWi8dARXQkIVh4qV3Z5yh
	 wyIzZB67LBCbKPJ9kbWmir3R34c2VaLVCZxRWt56LyxGe9X0inYH4fTMbgjMi+Gl5I
	 I/0Yr8KsQBPALR5vVmLMhgDn/fGbV/P8B4fyC7yg=
Date: Wed, 15 Jan 2025 21:43:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch removed from -mm tree
Message-Id: <20250116054356.59565C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert SetZsPageMovable and remove unused funcs
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: mm/zsmalloc: convert SetZsPageMovable and remove unused funcs
Date: Tue, 17 Dec 2024 00:04:47 +0900

Convert SetZsPageMovable() to use zpdesc, and then remove unused funcs:
get_next_page()/get_first_page()/is_first_page().

Link: https://lkml.kernel.org/r/20241216150450.1228021-17-42.hyeyoo@gmail.com
Originally-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs
+++ a/mm/zsmalloc.c
@@ -452,11 +452,6 @@ static DEFINE_PER_CPU(struct mapping_are
 	.lock	= INIT_LOCAL_LOCK(lock),
 };
 
-static __maybe_unused int is_first_page(struct page *page)
-{
-	return PagePrivate(page);
-}
-
 static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
@@ -473,14 +468,6 @@ static inline void mod_zspage_inuse(stru
 	zspage->inuse += val;
 }
 
-static inline struct page *get_first_page(struct zspage *zspage)
-{
-	struct page *first_page = zpdesc_page(zspage->first_zpdesc);
-
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-	return first_page;
-}
-
 static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
@@ -765,16 +752,6 @@ static struct zspage *get_zspage(struct
 	return zspage;
 }
 
-static struct page *get_next_page(struct page *page)
-{
-	struct zspage *zspage = get_zspage(page_zpdesc(page));
-
-	if (unlikely(ZsHugePage(zspage)))
-		return NULL;
-
-	return (struct page *)page->index;
-}
-
 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -1936,13 +1913,13 @@ static void init_deferred_free(struct zs
 
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct zpdesc *zpdesc = get_first_zpdesc(zspage);
 
 	do {
-		WARN_ON(!trylock_page(page));
-		__SetPageMovable(page, &zsmalloc_mops);
-		unlock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+		WARN_ON(!zpdesc_trylock(zpdesc));
+		__zpdesc_set_movable(zpdesc, &zsmalloc_mops);
+		zpdesc_unlock(zpdesc);
+	} while ((zpdesc = get_next_zpdesc(zpdesc)) != NULL);
 }
 #else
 static inline void zs_flush_migration(struct zs_pool *pool) { }
_

Patches currently in -mm which might be from alexs@kernel.org are


