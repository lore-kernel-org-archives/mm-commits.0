Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D671D40F72D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525499; cv=none; b=t3DH6iZZsoye94kFxqUjL4pRls5cgvFfE3N1RQmCru9PKFNTRUsxpUxnmvnqGadOKbAParALR4tdjEcslm6do0M/eHSaSfJjVlCMXB2WwkKSMXvA4jI0wO0f55suBst3e5HuGIWaZk4VrF9PVgrtCNy20HfIae5pKNtytWBQKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525499; c=relaxed/simple;
	bh=tCuPuhVYJVm0NjTJ7msTS92oqUQMmAu/x//T4s7ZpJM=;
	h=Date:To:From:Subject:Message-Id; b=p2a5STSBYO0YvZPR5sJ5dNyGdc6PfsHeTUWmkAPWQL2tclLT9GD8a3ClvaqOXoBzw/RadAH3oz/MXELi2Do/DM0PK9MODL61bKQo/gJ6gGrjbs482n77h9c0utXUvy7O0kl/WwDUp0v3nUAaHkbK6tqCdUNVhZC5kjRP8P6zelM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgD6ge+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgD6ge+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7081F00898;
	Fri,  9 Oct 2026 05:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525497;
	bh=ecxC2G9vzkzKWDFGdPvjYcbnUaTOHHFcxIyxZhRIRa4=;
	h=Date:To:From:Subject;
	b=QgD6ge+m3HSUa3os5pjlN7PGeWgZYLzOzqjT45uCXVRogKKrfv4G7zssn6gUoY46p
	 XaCTwzW+L4oKbRBOTRMJY7b/Q3mJgtH+jnHR3Lz/FV+To4qf5C+7UvdxE8P2+6dpEf
	 zT6C72izqWNq+g8uTv20AXiU/2hAXYHA3AGK/fvI=
Date: Thu, 08 Oct 2026 22:58:17 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-convert-to-sg-list-zsmalloc-object-read-api.patch removed from -mm tree
Message-Id: <20261009055817.AD7081F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: convert to SG-list zsmalloc object read API
has been removed from the -mm tree.  Its filename was
     zram-convert-to-sg-list-zsmalloc-object-read-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: convert to SG-list zsmalloc object read API
Date: Mon, 7 Sep 2026 19:57:28 +0900

Patch series "zsmallc: remove old object read API".

zram remains the only user of old zsmalloc object read API.  This series
removes the old API and converts zram to use the new SG-list based API.


This patch (of 2):

zram remains the last user of old zsmalloc object read API, that performed
linearisation on the zsmalloc side.  There is a new SG-list API, that has
a bunch of benefits.  Switch zram to SG-list zsmalloc object read API.

Link: https://lore.kernel.org/20260907105739.1793316-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20260907105739.1793316-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 drivers/block/zram/zcomp.c    |   23 +++++++++++--
 drivers/block/zram/zcomp.h    |    4 +-
 drivers/block/zram/zram_drv.c |   56 ++++++++++++++++++--------------
 3 files changed, 55 insertions(+), 28 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-convert-to-sg-list-zsmalloc-object-read-api
+++ a/drivers/block/zram/zcomp.c
@@ -7,6 +7,8 @@
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/cpuhotplug.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
 #include <linux/sysfs.h>
 
@@ -158,17 +160,32 @@ int zcomp_compress(struct zcomp *comp, s
 }
 
 int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		     const void *src, unsigned int src_len, void *dst)
+		     struct scatterlist *sg, unsigned int src_len, void *dst)
 {
 	struct zcomp_req req = {
-		.src = src,
 		.dst = dst,
 		.src_len = src_len,
 		.dst_len = PAGE_SIZE,
 	};
+	void *src = NULL;
+	int ret;
 
 	might_sleep();
-	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+
+	if (sg_is_last(sg)) {
+		/* the object is contained within one page, read it in-place */
+		src = kmap_local_page(sg_page(sg));
+		req.src = src + sg->offset;
+	} else {
+		/* the object spans two pages, linearize it into local copy */
+		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
+		req.src = zstrm->local_copy;
+	}
+
+	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+	if (src)
+		kunmap_local(src);
+	return ret;
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
--- a/drivers/block/zram/zcomp.h~zram-convert-to-sg-list-zsmalloc-object-read-api
+++ a/drivers/block/zram/zcomp.h
@@ -5,6 +5,8 @@
 
 #include <linux/mutex.h>
 
+struct scatterlist;
+
 #define ZCOMP_PARAM_NOT_SET	INT_MIN
 
 struct deflate_params {
@@ -91,6 +93,6 @@ void zcomp_stream_put(struct zcomp_strm
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
 int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		     const void *src, unsigned int src_len, void *dst);
+		     struct scatterlist *sg, unsigned int src_len, void *dst);
 
 #endif /* _ZCOMP_H_ */
--- a/drivers/block/zram/zram_drv.c~zram-convert-to-sg-list-zsmalloc-object-read-api
+++ a/drivers/block/zram/zram_drv.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
+#include <linux/scatterlist.h>
 #include <linux/kernel_read_file.h>
 #include <linux/rcupdate.h>
 
@@ -1347,9 +1348,9 @@ static int decompress_bdev_page(struct z
 				unsigned long index)
 {
 	struct zcomp_strm *zstrm;
+	struct scatterlist sg[1];
 	unsigned int size;
 	int ret, prio;
-	void *src;
 
 	slot_lock(zram, index);
 	/* Since slot was unlocked we need to make sure it's still ZRAM_WB */
@@ -1368,13 +1369,18 @@ static int decompress_bdev_page(struct z
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
+	sg_init_table(sg, 1);
+	sg_set_page(sg, page, size, 0);
+
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = kmap_local_page(page);
-	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size,
+	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 			       zstrm->local_copy);
-	if (!ret)
-		copy_page(src, zstrm->local_copy);
-	kunmap_local(src);
+	if (!ret) {
+		void *dst = kmap_local_page(page);
+
+		copy_page(dst, zstrm->local_copy);
+		kunmap_local(dst);
+	}
 	zcomp_stream_put(zstrm);
 	slot_unlock(zram, index);
 
@@ -2086,15 +2092,19 @@ static int read_same_filled_page(struct
 static int read_incompressible_page(struct zram *zram, struct page *page,
 				    unsigned long index)
 {
+	struct scatterlist sg[2];
 	unsigned long handle;
 	void *src, *dst;
 
 	handle = get_slot_handle(zram, index);
-	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
+	/* an incompressible object never spans two pages */
+	src = kmap_local_page(sg_page(sg));
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, PAGE_SIZE, src);
+	kunmap_local(src);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	return 0;
 }
@@ -2103,9 +2113,10 @@ static int read_compressed_page(struct z
 				unsigned long index)
 {
 	struct zcomp_strm *zstrm;
+	struct scatterlist sg[2];
 	unsigned long handle;
 	unsigned int size;
-	void *src, *dst;
+	void *dst;
 	int ret, prio;
 
 	handle = get_slot_handle(zram, index);
@@ -2113,12 +2124,11 @@ static int read_compressed_page(struct z
 	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, size,
-				zstrm->local_copy);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
 	dst = kmap_local_page(page);
-	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
+	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, size, src);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -2128,25 +2138,23 @@ static int read_compressed_page(struct z
 static int read_from_zspool_raw(struct zram *zram, struct page *page,
 				unsigned long index)
 {
-	struct zcomp_strm *zstrm;
+	struct scatterlist sg[2];
 	unsigned long handle;
 	unsigned int size;
-	void *src;
+	void *dst;
 
 	handle = get_slot_handle(zram, index);
 	size = get_slot_size(zram, index);
 
 	/*
-	 * We need to get stream just for ->local_copy buffer, in
-	 * case if object spans two physical pages. No decompression
-	 * takes place here, as we read raw compressed data.
+	 * No decompression takes place here, we copy out raw compressed
+	 * data directly into the destination page.
 	 */
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, size,
-				zstrm->local_copy);
-	memcpy_to_page(page, 0, src, size);
-	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
+	dst = kmap_local_page(page);
+	sg_copy_to_buffer(sg, sg_nents(sg), dst, size);
+	kunmap_local(dst);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	memzero_page(page, size, PAGE_SIZE - size);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


