Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C08243326
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837100; cv=none; b=NQc4hu8v8SQu4IuBCgcjdVPY7ZDtWT5SnvxMDkA58nyRpkhfUTElxTNc4YrhlJpQQHTQ+WxvMzfE4CwFMO1Rv7ql7k8kzbGZY5VokSGY6qeNy6wtXhHKgIA4mEcbTP/XM22GJnlDDfQ+WDsBXsxcIfcWxcJxxqo6CdvpljuONYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837100; c=relaxed/simple;
	bh=X8HoBUw6Yv69tH7foEPEA6y1c2llFO6wRiLIZb9NpFs=;
	h=Date:To:From:Subject:Message-Id; b=DTEtkAizC1xFu5jVE2b7zX3Wm3Lk3LmX6uMj8aK6Hjd6VkJc3WX/ZuhiyCCIUAgF8x5RKqIsIR/YmEyCZGTi0RZyMbmD14bbhRACdRNl6Zj2ao7VtaIUzzyeEZb3h6rtpmRLHeGoE6kQZ3Hmv9MZFScAWKUA8p0+IoAwLI3b6sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f2Yio1L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f2Yio1L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF9DC4CEDD;
	Tue, 14 Jan 2025 06:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837099;
	bh=X8HoBUw6Yv69tH7foEPEA6y1c2llFO6wRiLIZb9NpFs=;
	h=Date:To:From:Subject:From;
	b=f2Yio1L9M7UokG+cwKn6iIxqj3y5rmedT4Pww9vFmdQNw/fBarMe9uu43a2yMHyv8
	 J/5mD9/NvvR0T6riSDJoize8G/lRVs5MhlVhcUeAmoC/nfTADfaczjq/NZSCccZpvN
	 JdTh3KD3NMOsjl4WzXOOTMDABWryFy7VM6MJBFQY=
Date: Mon, 13 Jan 2025 22:44:59 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-factor-out-different-page-types-read.patch removed from -mm tree
Message-Id: <20250114064459.7CF9DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: factor out different page types read
has been removed from the -mm tree.  Its filename was
     zram-factor-out-different-page-types-read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: factor out different page types read
Date: Wed, 18 Dec 2024 15:34:22 +0900

Similarly to write, split the page read code into ZRAM_HUGE read,
ZRAM_SAME read and compressed page read to simplify the code.

Link: https://lkml.kernel.org/r/20241218063513.297475-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   85 +++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 33 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-factor-out-different-page-types-read
+++ a/drivers/block/zram/zram_drv.c
@@ -1531,54 +1531,73 @@ out:
 	zram_set_obj_size(zram, index, 0);
 }
 
-/*
- * Reads (decompresses if needed) a page from zspool (zsmalloc).
- * Corresponding ZRAM slot should be locked.
- */
-static int zram_read_from_zspool(struct zram *zram, struct page *page,
+static int read_same_filled_page(struct zram *zram, struct page *page,
 				 u32 index)
 {
-	struct zcomp_strm *zstrm;
+	void *mem;
+
+	mem = kmap_local_page(page);
+	zram_fill_page(mem, PAGE_SIZE, zram_get_handle(zram, index));
+	kunmap_local(mem);
+	return 0;
+}
+
+static int read_incompressible_page(struct zram *zram, struct page *page,
+				    u32 index)
+{
 	unsigned long handle;
-	unsigned int size;
 	void *src, *dst;
-	u32 prio;
-	int ret;
 
 	handle = zram_get_handle(zram, index);
-	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
-		void *mem;
+	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	dst = kmap_local_page(page);
+	copy_page(dst, src);
+	kunmap_local(dst);
+	zs_unmap_object(zram->mem_pool, handle);
 
-		mem = kmap_local_page(page);
-		zram_fill_page(mem, PAGE_SIZE, handle);
-		kunmap_local(mem);
-		return 0;
-	}
+	return 0;
+}
 
-	size = zram_get_obj_size(zram, index);
+static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
+{
+	struct zcomp_strm *zstrm;
+	unsigned long handle;
+	unsigned int size;
+	void *src, *dst;
+	int ret, prio;
 
-	if (size != PAGE_SIZE) {
-		prio = zram_get_priority(zram, index);
-		zstrm = zcomp_stream_get(zram->comps[prio]);
-	}
+	handle = zram_get_handle(zram, index);
+	size = zram_get_obj_size(zram, index);
+	prio = zram_get_priority(zram, index);
 
+	zstrm = zcomp_stream_get(zram->comps[prio]);
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
-	if (size == PAGE_SIZE) {
-		dst = kmap_local_page(page);
-		copy_page(dst, src);
-		kunmap_local(dst);
-		ret = 0;
-	} else {
-		dst = kmap_local_page(page);
-		ret = zcomp_decompress(zram->comps[prio], zstrm,
-				       src, size, dst);
-		kunmap_local(dst);
-		zcomp_stream_put(zram->comps[prio]);
-	}
+	dst = kmap_local_page(page);
+	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
+	kunmap_local(dst);
 	zs_unmap_object(zram->mem_pool, handle);
+	zcomp_stream_put(zram->comps[prio]);
+
 	return ret;
 }
 
+/*
+ * Reads (decompresses if needed) a page from zspool (zsmalloc).
+ * Corresponding ZRAM slot should be locked.
+ */
+static int zram_read_from_zspool(struct zram *zram, struct page *page,
+				 u32 index)
+{
+	if (zram_test_flag(zram, index, ZRAM_SAME) ||
+	    !zram_get_handle(zram, index))
+		return read_same_filled_page(zram, page, index);
+
+	if (!zram_test_flag(zram, index, ZRAM_HUGE))
+		return read_compressed_page(zram, page, index);
+	else
+		return read_incompressible_page(zram, page, index);
+}
+
 static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 			  struct bio *parent)
 {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


