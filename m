Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608861607AA
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006235; cv=none; b=GRzxtQad4rm7ZsZXwTEgiLJVqlfk2HEX6OesEVrJjz6sMa2NQ7a4EYaZe9eeOlQeYOpP/rvCPYV8fJkQA8FRlHCL/SXwM0khjLorFcfGgh3O7sYrzNwt+5PLbQaFvflGmuSv4eY6WWWNTNgS+49nytoTdkL2fWGW9SJRy7DaSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006235; c=relaxed/simple;
	bh=3kPRysOqMjWgblZCkhOb149QoMtqLFFbO5Iuk4b+Bco=;
	h=Date:To:From:Subject:Message-Id; b=TVlIhTtMKbPK6sqLG8t0+1XYWHM3ygv+/o52p8E6+VnczB1YjmAXYUGyW9hO46uitmjTQe2QkY17v0dJgxO7cFHVZetbt0qUzTVUFkDK34caS54LaNUu5vON+hMieDbzzBpbazLrHFwieue2Dk+wUNz3fMR0OdTbqN/MS3XbE7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R74Oq8T6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R74Oq8T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2E3C4CED6;
	Thu, 16 Jan 2025 05:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006235;
	bh=3kPRysOqMjWgblZCkhOb149QoMtqLFFbO5Iuk4b+Bco=;
	h=Date:To:From:Subject:From;
	b=R74Oq8T6dwQYExnXDz1Edi4W78PkOeSSnm0oU3XYhsAzy5D+9KwcSHS17iIZGM6sh
	 GQLKeHYH7zQOFJ4I81TujwZLjN3tLoE7Ko0cEOZQCPtjcR4oNkuegELINy+qd9EFct
	 koxU9Ey1j0bOBfx6K2oNyvzJtNt1u1znW3niDI8U=
Date: Wed, 15 Jan 2025 21:43:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch removed from -mm tree
Message-Id: <20250116054355.2F2E3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert get_zspage() to take zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert get_zspage() to take zpdesc
Date: Tue, 17 Dec 2024 00:04:46 +0900

Now that all users except get_next_page() (which will be removed in later
patch) use zpdesc, convert get_zspage() to take zpdesc instead of page.

Link: https://lkml.kernel.org/r/20241216150450.1228021-16-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-get_zspage-to-take-zpdesc
+++ a/mm/zsmalloc.c
@@ -757,9 +757,9 @@ out:
 	return newfg;
 }
 
-static struct zspage *get_zspage(struct page *page)
+static struct zspage *get_zspage(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = (struct zspage *)page_private(page);
+	struct zspage *zspage = zpdesc->zspage;
 
 	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 	return zspage;
@@ -767,7 +767,7 @@ static struct zspage *get_zspage(struct
 
 static struct page *get_next_page(struct page *page)
 {
-	struct zspage *zspage = get_zspage(page);
+	struct zspage *zspage = get_zspage(page_zpdesc(page));
 
 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
@@ -777,7 +777,7 @@ static struct page *get_next_page(struct
 
 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
+	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
@@ -827,7 +827,7 @@ static inline bool obj_allocated(struct
 				 unsigned long *phandle)
 {
 	unsigned long handle;
-	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
+	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
 		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
@@ -1232,7 +1232,7 @@ void *zs_map_object(struct zs_pool *pool
 	read_lock(&pool->migrate_lock);
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 
 	/*
 	 * migration cannot move any zpages in this zspage. Here, class->lock
@@ -1282,7 +1282,7 @@ void zs_unmap_object(struct zs_pool *poo
 
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
@@ -1445,7 +1445,7 @@ static void obj_free(int class_size, uns
 
 	obj_to_location(obj, &f_zpdesc, &f_objidx);
 	f_offset = offset_in_page(class_size * f_objidx);
-	zspage = get_zspage(zpdesc_page(f_zpdesc));
+	zspage = get_zspage(f_zpdesc);
 
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
@@ -1479,7 +1479,7 @@ void zs_free(struct zs_pool *pool, unsig
 	read_lock(&pool->migrate_lock);
 	obj = handle_to_obj(handle);
 	obj_to_zpdesc(obj, &f_zpdesc);
-	zspage = get_zspage(zpdesc_page(f_zpdesc));
+	zspage = get_zspage(f_zpdesc);
 	class = zspage_class(pool, zspage);
 	spin_lock(&class->lock);
 	read_unlock(&pool->migrate_lock);
@@ -1812,7 +1812,7 @@ static int zs_page_migrate(struct page *
 	__SetPageZsmalloc(zpdesc_page(newzpdesc));
 
 	/* The page is locked, so this pointer must remain valid */
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 	pool = zspage->pool;
 
 	/*
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


