Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE41171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569877; cv=none; b=HFE7v5DEAtLDIrmt0zSNsA4Ic9vz1AgLHIM2UennXEXzX7jFPfeCKvzTMwQ/+rrY46l8mtHXShlQlD5bMIhddJ1CEy5tOPptYlQZTJnK2gAEbkKLkK0hO7kuhpo3gQ4rv2iwsOMhgNy3PPZC8Wlid7ztQ+P22fTFSvVg8ACc5P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569877; c=relaxed/simple;
	bh=kdl8fz9HKb7pKVe40qevs9+Ym8IZ/2KfgJO9Yg3Q6Ts=;
	h=Date:To:From:Subject:Message-Id; b=ZTIUHZWeshcjPXCFS0+tzyD1iUJB4REDVJRp4AlEdSdvn9JHl5asMV+1VB5hyHA41D2SzE652wl2xcnyso2F95WX9utuOOVcyw+1oWy4mdNqO25xSOP1R2kdY87L0fokEtFznIdCJDRKKKcVglfU9BBvlqDByG+nkSjf9vsvs6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FDh6JuZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FDh6JuZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A73C4CECD;
	Thu, 19 Dec 2024 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569876;
	bh=kdl8fz9HKb7pKVe40qevs9+Ym8IZ/2KfgJO9Yg3Q6Ts=;
	h=Date:To:From:Subject:From;
	b=FDh6JuZJPS7Vel05nyGd21AzknWlwNFZfQvSTbc/PVPzJjybUWlduufbupJrP04lY
	 ybl/IhM29Mip12pePSgnLsrEz/E7+7IrShqjOVM08M6rve9jDBtIHMYZX+GeOoa4kv
	 uZbI4lufkIkILaHnUtheFU8Knlsxt55F8lLmSYjA=
Date: Wed, 18 Dec 2024 16:57:56 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-different-page-types-read.patch added to mm-unstable branch
Message-Id: <20241219005756.B4A73C4CECD@smtp.kernel.org>
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
@@ -1530,54 +1530,73 @@ out:
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

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

