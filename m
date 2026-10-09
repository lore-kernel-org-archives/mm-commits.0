Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1A40963F
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525500; cv=none; b=eOwjiOHX0+YLranwFJI9NhUPl6gpck+HieVRYKUndxdCMd/SNb/ioNWJ5QKPXaM1w98uShrEx6RqYwVBPa0GPBswFRvP/5wOdhWTQ4H++YH7gDXT1s6hmiUVw09dP7cxcutvWxCxpQpUs43pPg95RZMTmk/xikAGy5Cq7NYWFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525500; c=relaxed/simple;
	bh=u/gzKLimX497jY0IkzXuEJyUeLzuo7zroyIDDiqqfOU=;
	h=Date:To:From:Subject:Message-Id; b=ma1aIq7i2FTsm8rOFppjJALRxcf05eqMwP6Tej4zhNF47dZkcvJFO2HhgMKXJUWIkZ5nZdxqt1qqmbx4sKafSzBCOS9/ybGS6/vbAUikeYGcjuMdKJh8yZpT4mdrwIKLysQY8wN9AeG/ep885yCdneWTlv2s8b0GfUNAdLzEbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gr8JGNiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gr8JGNiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8E71F000FF;
	Fri,  9 Oct 2026 05:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525498;
	bh=p6UH/VM+FErI7IxR9mUPGiIfxou1jF+GY6e0d08QSl8=;
	h=Date:To:From:Subject;
	b=gr8JGNiVf62qJW/qSrjKeX0n7aW9bFuFyIqvs6ASm35PQ1os1g3Wk4jOq2KE2qPYS
	 MjvguDNCcYkZ1fpzbcig/Khhb77MGDmV1u8XBnkZDHP087XzwbH3ABLtZSBgtftMRH
	 BU2vfjN3gsrRssnRUzQoL0mkKBc6aLzbfTgisvVk=
Date: Thu, 08 Oct 2026 22:58:18 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-remove-old-object-read-api.patch removed from -mm tree
Message-Id: <20261009055818.CF8E71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: remove old object read API
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-old-object-read-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: remove old object read API
Date: Mon, 7 Sep 2026 19:57:29 +0900

There are no users left of the old API, all have switched to SG-list
object read API.  Remove it.

Link: https://lore.kernel.org/20260907105739.1793316-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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


