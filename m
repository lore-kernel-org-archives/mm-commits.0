Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03D7346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006220; cv=none; b=LW+WHJOTcjRg+pBgCBZrDR80E4bgWU7YiB72UEdvsqzOHjAe4Q32ct01qpRGnZr3Ym0Tmu0KSzPVBfuCGZ1OaZlVYRTldSNZMhhVEllhi0Ux0B+R1xLsx8lXMn4l5NAwbFfKkHsUFoUDkKYusUnB9x9AfjR8qMk7sW26odx4bsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006220; c=relaxed/simple;
	bh=df7YLy15wACWOKdjkIcXQOd7833Y36PW3wvjUMhCk8E=;
	h=Date:To:From:Subject:Message-Id; b=ZwhWQyUzrNQfoqM1Sn8fkQMLhLOor5qYk9S64jKPLNf97ez6xlOUUBl9Pa6kVv1U4LpDRbFXO3eN+1QwhJuDFv0J00EvhJD72Nldivf7TI1GXgaNjB6Lht37mI9hFiHwuoycAKkaKnPqQSpt+YNROGV4KI9xFFKRnyd3ditw8J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gREwlIiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gREwlIiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B13C4CEE2;
	Thu, 16 Jan 2025 05:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006220;
	bh=df7YLy15wACWOKdjkIcXQOd7833Y36PW3wvjUMhCk8E=;
	h=Date:To:From:Subject:From;
	b=gREwlIiX0c+vzz/oxGUQjUOwq4oGAOnD3Cqo4p5anplCGiaTcjtku5ObBfYo9ng3f
	 ZyMrIdiGO7dYvEVAeMWxtZNm63F0eg1qpZugxwWxflqsNQwC6NnzOImk+yYuYLywmd
	 9ir8AsWrIBBLIVPKiqQJG3R7TsXiHtBkfqpIzfZM=
Date: Wed, 15 Jan 2025 21:43:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054340.34B13C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert __zs_map_object/__zs_unmap_object to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert __zs_map_object/__zs_unmap_object to use zpdesc
Date: Tue, 17 Dec 2024 00:04:34 +0900

These two functions take a pointer to an array of struct page.  Make
__zs_{map,unmap}_object() take pointer to an array of zpdesc instead of
page.

Add silly type casting when calling them.  Casting will be removed later.

Link: https://lkml.kernel.org/r/20241216150450.1228021-4-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -1049,7 +1049,7 @@ static inline void __zs_cpu_down(struct
 }
 
 static void *__zs_map_object(struct mapping_area *area,
-			struct page *pages[2], int off, int size)
+			struct zpdesc *zpdescs[2], int off, int size)
 {
 	size_t sizes[2];
 	char *buf = area->vm_buf;
@@ -1065,14 +1065,14 @@ static void *__zs_map_object(struct mapp
 	sizes[1] = size - sizes[0];
 
 	/* copy object to per-cpu buffer */
-	memcpy_from_page(buf, pages[0], off, sizes[0]);
-	memcpy_from_page(buf + sizes[0], pages[1], 0, sizes[1]);
+	memcpy_from_page(buf, zpdesc_page(zpdescs[0]), off, sizes[0]);
+	memcpy_from_page(buf + sizes[0], zpdesc_page(zpdescs[1]), 0, sizes[1]);
 out:
 	return area->vm_buf;
 }
 
 static void __zs_unmap_object(struct mapping_area *area,
-			struct page *pages[2], int off, int size)
+			struct zpdesc *zpdescs[2], int off, int size)
 {
 	size_t sizes[2];
 	char *buf;
@@ -1090,8 +1090,8 @@ static void __zs_unmap_object(struct map
 	sizes[1] = size - sizes[0];
 
 	/* copy per-cpu buffer to object */
-	memcpy_to_page(pages[0], off, buf, sizes[0]);
-	memcpy_to_page(pages[1], 0, buf + sizes[0], sizes[1]);
+	memcpy_to_page(zpdesc_page(zpdescs[0]), off, buf, sizes[0]);
+	memcpy_to_page(zpdesc_page(zpdescs[1]), 0, buf + sizes[0], sizes[1]);
 
 out:
 	/* enable page faults to match kunmap_local() return conditions */
@@ -1230,7 +1230,7 @@ void *zs_map_object(struct zs_pool *pool
 	pages[1] = get_next_page(page);
 	BUG_ON(!pages[1]);
 
-	ret = __zs_map_object(area, pages, off, class->size);
+	ret = __zs_map_object(area, (struct zpdesc **)pages, off, class->size);
 out:
 	if (likely(!ZsHugePage(zspage)))
 		ret += ZS_HANDLE_SIZE;
@@ -1265,7 +1265,7 @@ void zs_unmap_object(struct zs_pool *poo
 		pages[1] = get_next_page(page);
 		BUG_ON(!pages[1]);
 
-		__zs_unmap_object(area, pages, off, class->size);
+		__zs_unmap_object(area, (struct zpdesc **)pages, off, class->size);
 	}
 	local_unlock(&zs_map_area.lock);
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


