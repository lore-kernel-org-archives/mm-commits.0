Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69E217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188412; cv=none; b=tBPP3IQm+Wf4ekDIC1riAnv2qqZQtzYeQtm1hrl9rIiQcZUEQd3ENwD5YBLDmi0lx1qEwXM41yLWXZ2a3jLcMSR02iRWiWhSDP6c7ZmYUFxyhrsN91JjRCOYld1M5rUePj8kTKPqrwpe8DzEb5V9cNVhpagP78vnc596fbGmH7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188412; c=relaxed/simple;
	bh=jJi4/zqUUXqAizXNN07BZBs4RvsRLXCwFm7G57YN1Cg=;
	h=Date:To:From:Subject:Message-Id; b=QEKleeHgWckbVB287cBi3CJ2nVJ7Fb9WQU510Yu0c1brzMr62ggJ6ayey+b6k1HgkEA4uoXrh9HXBamCiFM6yBY1R91guJantVAmoErwWFiH/ddhVnK8cHMda3bpW9hXOWnobwl4JUUiUk5oyelzcsGUnBej1sZ+iMC0BgBwnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1XTjXIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1XTjXIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A6DC4CEEC;
	Mon, 17 Mar 2025 05:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188412;
	bh=jJi4/zqUUXqAizXNN07BZBs4RvsRLXCwFm7G57YN1Cg=;
	h=Date:To:From:Subject:From;
	b=V1XTjXIoKZwlbdmhahmAHIdXTVSuWQx+D/w30AVu/Jf8/52CjIIPCrcZHSB0MB0x+
	 MV++08tj/LMarUrsVwzI2Bbmef8Tg7XiqMKmzUT5LOKB57GZ/5jd2z7VhCetsV8hq+
	 nGKpbJoeL4xorHx8NdIyXCtvN1wn++BTBQUqyVFU=
Date: Sun, 16 Mar 2025 22:13:31 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-permit-preemption-with-active-compression-stream.patch removed from -mm tree
Message-Id: <20250317051331.E6A6DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: permit preemption with active compression stream
has been removed from the -mm tree.  Its filename was
     zram-permit-preemption-with-active-compression-stream.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: permit preemption with active compression stream
Date: Mon, 3 Mar 2025 11:03:11 +0900

Currently, per-CPU stream access is done from a non-preemptible (atomic)
section, which imposes the same atomicity requirements on compression
backends as entry spin-lock, and makes it impossible to use algorithms
that can schedule/wait/sleep during compression and decompression.

Switch to preemptible per-CPU model, similar to the one used in zswap. 
Instead of a per-CPU local lock, each stream carries a mutex which is
locked throughout entire time zram uses it for compression or
decompression, so that cpu-dead event waits for zram to stop using a
particular per-CPU stream and release it.

Link: https://lkml.kernel.org/r/20250303022425.285971-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |   41 ++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |    6 ++--
 drivers/block/zram/zram_drv.c |   20 +++++++--------
 3 files changed, 42 insertions(+), 25 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-permit-preemption-with-active-compression-stream
+++ a/drivers/block/zram/zcomp.c
@@ -6,7 +6,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/cpu.h>
+#include <linux/cpuhotplug.h>
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 
@@ -109,13 +109,29 @@ ssize_t zcomp_available_show(const char
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 {
-	local_lock(&comp->stream->lock);
-	return this_cpu_ptr(comp->stream);
+	for (;;) {
+		struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream);
+
+		/*
+		 * Inspired by zswap
+		 *
+		 * stream is returned with ->mutex locked which prevents
+		 * cpu_dead() from releasing this stream under us, however
+		 * there is still a race window between raw_cpu_ptr() and
+		 * mutex_lock(), during which we could have been migrated
+		 * from a CPU that has already destroyed its stream.  If
+		 * so then unlock and re-try on the current CPU.
+		 */
+		mutex_lock(&zstrm->lock);
+		if (likely(zstrm->buffer))
+			return zstrm;
+		mutex_unlock(&zstrm->lock);
+	}
 }
 
-void zcomp_stream_put(struct zcomp *comp)
+void zcomp_stream_put(struct zcomp_strm *zstrm)
 {
-	local_unlock(&comp->stream->lock);
+	mutex_unlock(&zstrm->lock);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
@@ -151,12 +167,9 @@ int zcomp_decompress(struct zcomp *comp,
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm;
+	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
 	int ret;
 
-	zstrm = per_cpu_ptr(comp->stream, cpu);
-	local_lock_init(&zstrm->lock);
-
 	ret = zcomp_strm_init(comp, zstrm);
 	if (ret)
 		pr_err("Can't allocate a compression stream\n");
@@ -166,16 +179,17 @@ int zcomp_cpu_up_prepare(unsigned int cp
 int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm;
+	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
 
-	zstrm = per_cpu_ptr(comp->stream, cpu);
+	mutex_lock(&zstrm->lock);
 	zcomp_strm_free(comp, zstrm);
+	mutex_unlock(&zstrm->lock);
 	return 0;
 }
 
 static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 {
-	int ret;
+	int ret, cpu;
 
 	comp->stream = alloc_percpu(struct zcomp_strm);
 	if (!comp->stream)
@@ -186,6 +200,9 @@ static int zcomp_init(struct zcomp *comp
 	if (ret)
 		goto cleanup;
 
+	for_each_possible_cpu(cpu)
+		mutex_init(&per_cpu_ptr(comp->stream, cpu)->lock);
+
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
 		goto cleanup;
--- a/drivers/block/zram/zcomp.h~zram-permit-preemption-with-active-compression-stream
+++ a/drivers/block/zram/zcomp.h
@@ -3,7 +3,7 @@
 #ifndef _ZCOMP_H_
 #define _ZCOMP_H_
 
-#include <linux/local_lock.h>
+#include <linux/mutex.h>
 
 #define ZCOMP_PARAM_NO_LEVEL	INT_MIN
 
@@ -31,7 +31,7 @@ struct zcomp_ctx {
 };
 
 struct zcomp_strm {
-	local_lock_t lock;
+	struct mutex lock;
 	/* compression buffer */
 	void *buffer;
 	struct zcomp_ctx ctx;
@@ -77,7 +77,7 @@ struct zcomp *zcomp_create(const char *a
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp *comp);
+void zcomp_stream_put(struct zcomp_strm *zstrm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
--- a/drivers/block/zram/zram_drv.c~zram-permit-preemption-with-active-compression-stream
+++ a/drivers/block/zram/zram_drv.c
@@ -1607,7 +1607,7 @@ static int read_compressed_page(struct z
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
 	zs_unmap_object(zram->mem_pool, handle);
-	zcomp_stream_put(zram->comps[prio]);
+	zcomp_stream_put(zstrm);
 
 	return ret;
 }
@@ -1768,14 +1768,14 @@ compress_again:
 	kunmap_local(mem);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
 		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zstrm);
 		return write_incompressible_page(zram, page, index);
 	}
 
@@ -1799,7 +1799,7 @@ compress_again:
 				   __GFP_HIGHMEM |
 				   __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zstrm);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				   GFP_NOIO | __GFP_HIGHMEM |
@@ -1811,7 +1811,7 @@ compress_again:
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
@@ -1819,7 +1819,7 @@ compress_again:
 	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
 	memcpy(dst, zstrm->buffer, comp_len);
-	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+	zcomp_stream_put(zstrm);
 	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_lock(zram, index);
@@ -1978,7 +1978,7 @@ static int recompress_slot(struct zram *
 		kunmap_local(src);
 
 		if (ret) {
-			zcomp_stream_put(zram->comps[prio]);
+			zcomp_stream_put(zstrm);
 			return ret;
 		}
 
@@ -1988,7 +1988,7 @@ static int recompress_slot(struct zram *
 		/* Continue until we make progress */
 		if (class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
-			zcomp_stream_put(zram->comps[prio]);
+			zcomp_stream_put(zstrm);
 			continue;
 		}
 
@@ -2046,13 +2046,13 @@ static int recompress_slot(struct zram *
 			       __GFP_HIGHMEM |
 			       __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_stream_put(zram->comps[prio]);
+		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
 	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
 	memcpy(dst, zstrm->buffer, comp_len_new);
-	zcomp_stream_put(zram->comps[prio]);
+	zcomp_stream_put(zstrm);
 
 	zs_unmap_object(zram->mem_pool, handle_new);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


