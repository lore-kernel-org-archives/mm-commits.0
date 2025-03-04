Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662A9250EC
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048713; cv=none; b=fxq+Vq2yA5d8W2Ll0peon8Z4hBxozpP74+ZI+gB3+QNYoptq/9HGrce1UH9PVnWYHWPaNKs/WdlyWpBBPzegmh3q+6kkw9GfunYBLOjNygneqBDU/nutE5L+X+nMyuqBkhFiTv2kAFgzuJW460ZuHYGhThvVxXEFY85QS4djfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048713; c=relaxed/simple;
	bh=ZuuIq8O+1N3BBuZHkRMcKrrzGNwx+3S/ltLGQSxivlY=;
	h=Date:To:From:Subject:Message-Id; b=pnULYjZK55d+VPm4EEOj5Jgejb775fs/xCyCE0SvHro6a8d27o3HWJtojkm+cBRcVU6jZBl0O2POIImeI9GE435WPpSuIZYbKKZa29NRJP8Js/6HbDFfyHQC4rWuQBtiY7DDld6/9R3BcaL7Kkj1cZbk7CvQ1G8piGl/Q7EVJm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ct9lhc8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ct9lhc8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2844C4CEE4;
	Tue,  4 Mar 2025 00:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048712;
	bh=ZuuIq8O+1N3BBuZHkRMcKrrzGNwx+3S/ltLGQSxivlY=;
	h=Date:To:From:Subject:From;
	b=ct9lhc8wMnUSsx6qxDU7bWbz+PkSNvsjQIbJKEnROTK2t0jTKFbeHQzlyMYJHGxHP
	 C8Uwk21+PigN3bU4MZBpHi5k6+/fJuouAf4Zi7JTpQ0BBy9Lelo3M8m8ifOXTuiubc
	 sXhBRd9ByJOUgDjW4PJ56Sp733K/pABrovOJ3ZdI=
Date: Mon, 03 Mar 2025 16:38:32 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-permit-preemption-with-active-compression-stream.patch added to mm-unstable branch
Message-Id: <20250304003832.D2844C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: permit preemption with active compression stream
has been added to the -mm mm-unstable branch.  Its filename is
     zram-permit-preemption-with-active-compression-stream.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-permit-preemption-with-active-compression-stream.patch

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

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zram-move-post-processing-target-allocation.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-sleepable-zspage-reader-lock.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

