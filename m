Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9157328E0
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085302; cv=none; b=XSn6QlPof7J/YyfPrF5fMYibGJXDxdL4NSWauq9SQiAVUeU+x7xpNQVyRW42MOHeIPsolugx65qbFiLG/7ic8UXMZ4NbcF80cguO9uk9cHYRwETsfRpygpjthvzH4Y7FMhsU/L5/y8Vwc0aqEdrPZqkdJSgCqmbXnv/CQTrvX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085302; c=relaxed/simple;
	bh=+yZ2iPkyVipHW4kRlySIlcPoxZxR73B2jQmLuxJTTwM=;
	h=Date:To:From:Subject:Message-Id; b=ceoS8XvetPtAXibR+1RqwEPxIk+xgL6Pa/6/3v6HDqcGXRATOj6JBxFurdV3YGY3auTk7qgo8MFsBcm2HqRdV/Jzw53vMYt6j0GZ+0bym3a0utnTCimM33YYdsErqQndWb7+2oE0v0BklUTSRnNCM2ssKuEAvLed0HKIA6aKiN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GpSOrVgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GpSOrVgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199CF1F000FF;
	Fri, 11 Sep 2026 00:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789085300;
	bh=qz6TcSRZxCh+fRQxvb61AIiwBrPDKYdozqInNEW1luk=;
	h=Date:To:From:Subject;
	b=GpSOrVgJYICFdHi/hSYa3ERsBhJ4XT0gpoPagEsOFkJtxmjlY9Fwurr96nUFr2Hdu
	 B4t8NuYs6J5U0Ty8GRU3tROmW2mXfWFwYx6cBRrvoOJxezuArdpxZOvpZtN3JN/ecs
	 z84PyffMRdoLfPh90Sqhei1pPxRryY6w0k341Qdk=
Date: Thu, 10 Sep 2026 17:08:19 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-old-object-read-api.patch added to mm-new branch
Message-Id: <20260911000820.199CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: remove old object read API
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-remove-old-object-read-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-remove-old-object-read-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: remove old object read API
Date: Mon, 7 Sep 2026 19:57:29 +0900

There are no users left of the old API, all have switched to SG-list
object read API.  Remove it.

Link: https://lore.kernel.org/20260907105739.1793316-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    4 -
 mm/zsmalloc.c            |   77 -------------------------------------
 2 files changed, 81 deletions(-)

--- a/include/linux/zsmalloc.h~zsmalloc-remove-old-object-read-api
+++ a/include/linux/zsmalloc.h
@@ -40,10 +40,6 @@ unsigned int zs_lookup_class_index(struc
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
-void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			size_t mem_len, void *local_copy);
-void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     size_t mem_len, void *handle_mem);
 void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
--- a/mm/zsmalloc.c~zsmalloc-remove-old-object-read-api
+++ a/mm/zsmalloc.c
@@ -1134,83 +1134,6 @@ unsigned long zs_get_total_pages(struct
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			size_t mem_len, void *local_copy)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-	struct size_class *class;
-	void *addr;
-
-	/* Guarantee we can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/* Make sure migration doesn't move any pages in this zspage */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	if (!ZsHugePage(zspage))
-		off += ZS_HANDLE_SIZE;
-
-	if (off + mem_len <= PAGE_SIZE) {
-		/* this object is contained entirely within a page */
-		addr = kmap_local_zpdesc(zpdesc);
-		addr += off;
-	} else {
-		size_t sizes[2];
-
-		/* this object spans two pages */
-		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = mem_len - sizes[0];
-		addr = local_copy;
-
-		memcpy_from_page(addr, zpdesc_page(zpdesc),
-				 off, sizes[0]);
-		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_from_page(addr + sizes[0],
-				 zpdesc_page(zpdesc),
-				 0, sizes[1]);
-	}
-
-	return addr;
-}
-EXPORT_SYMBOL_GPL(zs_obj_read_begin);
-
-void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     size_t mem_len, void *handle_mem)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-	struct size_class *class;
-
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	if (!ZsHugePage(zspage))
-		off += ZS_HANDLE_SIZE;
-
-	if (off + mem_len <= PAGE_SIZE) {
-		handle_mem -= off;
-		kunmap_local(handle_mem);
-	}
-
-	zspage_read_unlock(zspage);
-}
-EXPORT_SYMBOL_GPL(zs_obj_read_end);
-
 void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len)
 {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-remove-unreachable-kernel_read_file_from_path-return-check.patch
zram-convert-to-sg-list-zsmalloc-object-read-api.patch
zsmalloc-remove-old-object-read-api.patch

