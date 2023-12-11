Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA35246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oMhQQ02L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE39C433C8;
	Mon, 11 Dec 2023 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256142;
	bh=DDP8iPgmfrhqvkGLU9mMZlpSvvOqT/3mk1Lt1gbj9LY=;
	h=Date:To:From:Subject:From;
	b=oMhQQ02LzlUe0fXBDApVDKJLGJ8FbXFgnXsLiH56b/6Z3L4N2ScNgmus+goFiesLB
	 DibSBol7IFkqR0yZrs4kLIG1s+x0o1dyX7MBgqZYSnGkMLVbtq+bWemG9tF/eTBlzg
	 EMepmmWY0aCwfAl0bnr/YXUj59FF2MjgAxmr7tO4=
Date: Sun, 10 Dec 2023 16:55:41 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-kmap_local_page.patch removed from -mm tree
Message-Id: <20231211005541.DEE39C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use kmap_local_page()
has been removed from the -mm tree.  Its filename was
     zram-use-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use kmap_local_page()
Date: Tue, 28 Nov 2023 17:22:07 +0900

Use kmap_local_page() instead of kmap_atomic() which has been
deprecated.

Link: https://lkml.kernel.org/r/20231128083845.848008-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-kmap_local_page
+++ a/drivers/block/zram/zram_drv.c
@@ -1321,9 +1321,9 @@ static int zram_read_from_zspool(struct
 		void *mem;
 
 		value = handle ? zram_get_element(zram, index) : 0;
-		mem = kmap_atomic(page);
+		mem = kmap_local_page(page);
 		zram_fill_page(mem, PAGE_SIZE, value);
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		return 0;
 	}
 
@@ -1336,14 +1336,14 @@ static int zram_read_from_zspool(struct
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		memcpy(dst, src, PAGE_SIZE);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		ret = 0;
 	} else {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		ret = zcomp_decompress(zstrm, src, size, dst);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		zcomp_stream_put(zram->comps[prio]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
@@ -1416,21 +1416,21 @@ static int zram_write_page(struct zram *
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
 
-	mem = kmap_atomic(page);
+	mem = kmap_local_page(page);
 	if (page_same_filled(mem, &element)) {
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		/* Free memory associated with this sector now. */
 		flags = ZRAM_SAME;
 		atomic64_inc(&zram->stats.same_pages);
 		goto out;
 	}
-	kunmap_atomic(mem);
+	kunmap_local(mem);
 
 compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = kmap_atomic(page);
+	src = kmap_local_page(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
-	kunmap_atomic(src);
+	kunmap_local(src);
 
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
@@ -1494,10 +1494,10 @@ compress_again:
 
 	src = zstrm->buffer;
 	if (comp_len == PAGE_SIZE)
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 	memcpy(dst, src, comp_len);
 	if (comp_len == PAGE_SIZE)
-		kunmap_atomic(src);
+		kunmap_local(src);
 
 	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	zs_unmap_object(zram->mem_pool, handle);
@@ -1614,9 +1614,9 @@ static int zram_recompress(struct zram *
 
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 		ret = zcomp_compress(zstrm, src, &comp_len_new);
-		kunmap_atomic(src);
+		kunmap_local(src);
 
 		if (ret) {
 			zcomp_stream_put(zram->comps[prio]);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

checkpatch-do-not-require-an-empty-line-before-error-injection.patch

