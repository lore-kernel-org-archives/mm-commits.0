Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD9E81AC8
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878521; cv=none; b=NJRmzzz7/maoCQamoQKggOlK4V8AbsiwBCM4iHnx0+wiS6xdEAgI3v8yJ9LwooCxRuQpOVFLb6mu/065xu1xHM1TCGlKb4jm22BhJW+ZAebrT4E9NGgYceOPdIOWyCcr5Oo1ImkkIv66/3sb/kGnCOUO2GIN6HzKDnmbIp6V46E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878521; c=relaxed/simple;
	bh=suAfhM1sa84d/WfjfBBnVqmqecIQmwIrZlnV4p8UW2Y=;
	h=Date:To:From:Subject:Message-Id; b=C/InkP0aDEhly2OCDg+noV3Q9CUBi8foyp6lP8/1De+MQv5MxMnvfyWd/pVnOqCl2oBfklW9pSzw52OZkHUl9MbjlbaCEkk8gZUI3p/UXsWRGQ5SI4QM6Ifi+xng1Dt1JEJBy1o0CEIaNIa7UqPF+kgfFIOosSWrL3kVEMkrH1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7wlkBig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7wlkBig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA49C4CED6;
	Wed, 11 Dec 2024 00:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878520;
	bh=suAfhM1sa84d/WfjfBBnVqmqecIQmwIrZlnV4p8UW2Y=;
	h=Date:To:From:Subject:From;
	b=C7wlkBigYKlGhE6GelvPmtQCUhTHEnbQo6LgvCtKQnA8V+9Ptu9R3BoxSwt6wTsDq
	 eKAcBHZQAo/Ba7xtgxSqJd/ARfWU4h3HT4iFfiOhjv/ALqLOAdliEFJduoveWbfzU/
	 1xH62R2IJNOisuWXCHQHovVfpRoIJLe25BLeCxO0=
Date: Tue, 10 Dec 2024 16:55:20 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-different-page-types-read.patch added to mm-unstable branch
Message-Id: <20241211005520.9AA49C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: factor out different page types read
has been added to the -mm mm-unstable branch.  Its filename is
     zram-factor-out-different-page-types-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-factor-out-different-page-types-read.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: factor out different page types read
Date: Tue, 10 Dec 2024 19:54:00 +0900

Similarly to write, split the page read code into ZRAM_HUGE read,
ZRAM_SAME read and compressed page read to simplify the code.

Link: https://lkml.kernel.org/r/20241210105420.1888790-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   85 +++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 33 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-factor-out-different-page-types-read
+++ a/drivers/block/zram/zram_drv.c
@@ -1532,54 +1532,73 @@ out:
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

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch

