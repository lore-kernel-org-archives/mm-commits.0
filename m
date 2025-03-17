Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA8A217709
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188429; cv=none; b=Fm8NPzZyBFuyhKTFcz9N2g7AeCvvWqqMo2Pus6XtfCaQ4Qybai9zuPoy6h1ijVILd7G+qEXLqgZPhRfHsNhd/P7KvgFxR/Z94/IF5T6FTNkNv04Z+pwHUk7S9PcT+EQRjX/+y9NZoMkdZ7rEvRBL7iSyjcvPR/NN0uOI1gol56M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188429; c=relaxed/simple;
	bh=F2rHPozwsZ1fidmw+WGd2G15matnQ07/eUHzHYmUK6s=;
	h=Date:To:From:Subject:Message-Id; b=qM/G7OaJqj3pIkxG+HZRP1oVvvoWVZeripkAhrCYJbvRj9DjzLcnG7PrMpy+LjmQrk+WXEoEqrS4U4REBMSZsxC4P9d1xXveDh6/zpsJ+j+I3GDlWB4sxa7dF3Frq58drfVTd0GHbpynzWQIQGxP4+qqk9mACc/dJ7E8MsazqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thA0bohr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thA0bohr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4142BC4CEEC;
	Mon, 17 Mar 2025 05:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188429;
	bh=F2rHPozwsZ1fidmw+WGd2G15matnQ07/eUHzHYmUK6s=;
	h=Date:To:From:Subject:From;
	b=thA0bohrljj1dhsVPUGK/RXdcbrA41nX6JNkFfVTBfpOkX96F1rcGLmCnD4c7Zju5
	 AUouSo9hOlo5UUxSlZpy48iZZSqVZQf3CTxCX82KrdRQXCph/U5s69JtipnU36ijxf
	 FxSc+USA3qzAeRpWfDo1HHVQKYXyQ9mKr63bxF0c=
Date: Sun, 16 Mar 2025 22:13:48 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-switch-to-new-zsmalloc-object-mapping-api.patch removed from -mm tree
Message-Id: <20250317051349.4142BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: switch to new zsmalloc object mapping API
has been removed from the -mm tree.  Its filename was
     zram-switch-to-new-zsmalloc-object-mapping-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: switch to new zsmalloc object mapping API
Date: Mon, 3 Mar 2025 11:03:24 +0900

Use new read/write zsmalloc object API.  For cases when RO mapped object
spans two physical pages (requires temp buffer) compression streams now
carry around one extra physical page.

Link: https://lkml.kernel.org/r/20250303022425.285971-16-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    4 +++-
 drivers/block/zram/zcomp.h    |    2 ++
 drivers/block/zram/zram_drv.c |   28 ++++++++++------------------
 3 files changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zcomp.c
@@ -45,6 +45,7 @@ static const struct zcomp_ops *backends[
 static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
 	comp->ops->destroy_ctx(&zstrm->ctx);
+	vfree(zstrm->local_copy);
 	vfree(zstrm->buffer);
 	zstrm->buffer = NULL;
 }
@@ -57,12 +58,13 @@ static int zcomp_strm_init(struct zcomp
 	if (ret)
 		return ret;
 
+	zstrm->local_copy = vzalloc(PAGE_SIZE);
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
 	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (!zstrm->buffer) {
+	if (!zstrm->buffer || !zstrm->local_copy) {
 		zcomp_strm_free(comp, zstrm);
 		return -ENOMEM;
 	}
--- a/drivers/block/zram/zcomp.h~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zcomp.h
@@ -34,6 +34,8 @@ struct zcomp_strm {
 	struct mutex lock;
 	/* compression buffer */
 	void *buffer;
+	/* local copy of handle memory */
+	void *local_copy;
 	struct zcomp_ctx ctx;
 };
 
--- a/drivers/block/zram/zram_drv.c~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zram_drv.c
@@ -1561,11 +1561,11 @@ static int read_incompressible_page(stru
 	void *src, *dst;
 
 	handle = zram_get_handle(zram, index);
-	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_obj_read_end(zram->mem_pool, handle, src);
 
 	return 0;
 }
@@ -1583,11 +1583,11 @@ static int read_compressed_page(struct z
 	prio = zram_get_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_obj_read_end(zram->mem_pool, handle, src);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -1683,7 +1683,7 @@ static int write_incompressible_page(str
 				     u32 index)
 {
 	unsigned long handle;
-	void *src, *dst;
+	void *src;
 
 	/*
 	 * This function is called from preemptible context so we don't need
@@ -1701,11 +1701,9 @@ static int write_incompressible_page(str
 		return -ENOMEM;
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 	src = kmap_local_page(page);
-	memcpy(dst, src, PAGE_SIZE);
+	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
-	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_lock(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
@@ -1726,7 +1724,7 @@ static int zram_write_page(struct zram *
 	int ret = 0;
 	unsigned long handle;
 	unsigned int comp_len;
-	void *dst, *mem;
+	void *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element;
 	bool same_filled;
@@ -1773,11 +1771,8 @@ static int zram_write_page(struct zram *
 		return -ENOMEM;
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
-
-	memcpy(dst, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_stream_put(zstrm);
-	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_lock(zram, index);
 	zram_set_handle(zram, index, handle);
@@ -1882,7 +1877,7 @@ static int recompress_slot(struct zram *
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
 	unsigned int class_index_new;
-	void *src, *dst;
+	void *src;
 	int ret = 0;
 
 	handle_old = zram_get_handle(zram, index);
@@ -1993,12 +1988,9 @@ static int recompress_slot(struct zram *
 		return PTR_ERR((void *)handle_new);
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
-	memcpy(dst, zstrm->buffer, comp_len_new);
+	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zs_unmap_object(zram->mem_pool, handle_new);
-
 	zram_free_page(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


