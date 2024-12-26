Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A33D145B00
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249617; cv=none; b=MZ3wHNK/hPtXWXQt2Q716uKgnhKyRlBuEBHydrDHqezshZfOwvI7CZM0oV29pfVeeRfq2Ru6Ar99ftvTQMtJAUZLgbhMGFusz4atg/SuVfGwwMhSkDNPINjaq7eGTin6O0xd8DuMpSuHflWyRIDiuY9N7fM7iAsD+PxBH0C+xAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249617; c=relaxed/simple;
	bh=ae4HYajqV6QR8ArDIfemR+hxai6vN/QoUyqRSykVwPE=;
	h=Date:To:From:Subject:Message-Id; b=aKgTKOq0z4ZRJkdwLoqzOyhZvcsv0oe+fklhvk2ATxUjPm2l6BAe4DXx9J0g8ntmmQjtJNmqcukmBA1+gTNVXVIbCbd/x1LSHlm7MQ3CSMJAS5tKTdzGi58et6fAA7V7A0pLDJOwOuuV35q2NEfcQcdEl9BhvmmtoA/yWiafe0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynj02ZZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynj02ZZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C642C4CED1;
	Thu, 26 Dec 2024 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249617;
	bh=ae4HYajqV6QR8ArDIfemR+hxai6vN/QoUyqRSykVwPE=;
	h=Date:To:From:Subject:From;
	b=ynj02ZZR5tf9FX/QDzGvhOkHU5Uj1ZYAR+FCYNxpke2zEZPcpRzvnn2GreR8Eq1fH
	 LgItg5EIo+Ys8bQcDoobM8vrorJdCVCE3VPL82xbutLoE1r6KfOZujEbAs9fOpug7E
	 oKA7PThz2IrjrX9vwpm4efzB2rTzHOEUpQ2YJoqY=
Date: Thu, 26 Dec 2024 13:46:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214657.0C642C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert __zs_map_object/__zs_unmap_object to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch

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

mm-migrate-remove-slab-checks-in-isolate_movable_page.patch
mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch
mm-zsmalloc-add-and-use-pfn-zpdesc-seeking-funcs.patch
mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch
mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch
mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch
mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch
mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

