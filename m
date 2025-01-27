Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D591195811
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011492; cv=none; b=a5QnAZYDUqtgfAihpEPVbqePtGRTm3aII6H0rq8PK1V4/Rel1U1q8uC7m4EoqAEqFZrm8hSrM2TgSp6Llvi5TD/B/G+wuIA69nfyIHJHoLW/D8IfzraStl7Nmr1JBuxredOHTPwZAhCddiP2/GWiHRGe4NWkinGzq1/xcdIWUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011492; c=relaxed/simple;
	bh=Qbhg75Ty10LIiMUrtAfuXlhHpnnJ4py8MhYUIwa7MgY=;
	h=Date:To:From:Subject:Message-Id; b=JdWnGBUci2zA6lh/OnUpBGKky64hZ0A2COHjHDF/VJ/Y2hgnW+adAqHRd58OCOrMzUWzLJgrdJJxRFOmsyTlGUo1VoTwnl6LarBztRUuCjC5bS0iFGrLWh1yRnSmyyrqBH6AAJ2iM/EHnHa0lPwoYUjjcae4lTswh9vecBSWhdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2Qejmxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2Qejmxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44896C4CED2;
	Mon, 27 Jan 2025 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011492;
	bh=Qbhg75Ty10LIiMUrtAfuXlhHpnnJ4py8MhYUIwa7MgY=;
	h=Date:To:From:Subject:From;
	b=p2QejmxgKRxbRqfCeRhZKo/p7SCcmkjfrcTTfJL3UKOPTFu18oZhizxB5gXSRsRYx
	 fBdBGn7cqSlz9MMRTFJum3awDmB0mEAPKe4062sN8XfJG/K5wKusGunm9zJR6Ps1Xk
	 BvG3wB3M9oUBiJQ8UzKHO4Vg2IH9/W+7wakLKPfg=
Date: Mon, 27 Jan 2025 12:58:11 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-use-per-cpu-compression-streams.patch added to mm-unstable branch
Message-Id: <20250127205812.44896C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not use per-CPU compression streams
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-use-per-cpu-compression-streams.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-use-per-cpu-compression-streams.patch

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
Subject: zram: do not use per-CPU compression streams
Date: Mon, 27 Jan 2025 16:29:13 +0900

Similarly to per-entry spin-lock per-CPU compression streams also have a
number of shortcoming.

First, per-CPU stream access has to be done from a non-preemptible
(atomic) section, which imposes the same atomicity requirements on
compression backends as entry spin-lock do and makes it impossible to use
algorithms that can schedule/wait/sleep during compression and
decompression.

Second, per-CPU streams noticeably increase memory usage (actually more
like wastage) of secondary compression streams.  The problem is that
secondary compression streams are allocated per-CPU, just like the primary
streams are.  Yet we never use more that one secondary stream at a time,
because recompression is a single threaded action.  Which means that
remaining num_online_cpu() - 1 streams are allocated for nothing, and this
is per-priority list (we can have several secondary compression
algorithms).  Depending on the algorithm this may lead to a significant
memory wastage, in addition each stream also carries a workmem buffer (2
physical pages).

Instead of per-CPU streams, maintain a list of idle compression streams
and allocate new streams on-demand (something that we used to do many
years ago).  So that zram read() and write() become non-atomic and ease
requirements on the compression algorithm implementation.  This also means
that we now should have only one secondary stream per-priority list.

Link: https://lkml.kernel.org/r/20250127072932.1289973-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |  162 +++++++++++++++++---------------
 drivers/block/zram/zcomp.h    |   17 +--
 drivers/block/zram/zram_drv.c |   29 +----
 include/linux/cpuhotplug.h    |    1 
 4 files changed, 108 insertions(+), 101 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-do-not-use-per-cpu-compression-streams
+++ a/drivers/block/zram/zcomp.c
@@ -6,7 +6,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 
@@ -43,31 +43,40 @@ static const struct zcomp_ops *backends[
 	NULL
 };
 
-static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
+static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *strm)
 {
-	comp->ops->destroy_ctx(&zstrm->ctx);
-	vfree(zstrm->buffer);
-	zstrm->buffer = NULL;
+	comp->ops->destroy_ctx(&strm->ctx);
+	vfree(strm->buffer);
+	kfree(strm);
 }
 
-static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 {
+	struct zcomp_strm *strm;
 	int ret;
 
-	ret = comp->ops->create_ctx(comp->params, &zstrm->ctx);
-	if (ret)
-		return ret;
+	strm = kzalloc(sizeof(*strm), GFP_KERNEL);
+	if (!strm)
+		return NULL;
+
+	INIT_LIST_HEAD(&strm->entry);
+
+	ret = comp->ops->create_ctx(comp->params, &strm->ctx);
+	if (ret) {
+		kfree(strm);
+		return NULL;
+	}
 
 	/*
-	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
-	 * case when compressed size is larger than the original one
+	 * allocate 2 pages. 1 for compressed data, plus 1 extra in case if
+	 * compressed data is larger than the original one.
 	 */
-	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (!zstrm->buffer) {
-		zcomp_strm_free(comp, zstrm);
-		return -ENOMEM;
+	strm->buffer = vzalloc(2 * PAGE_SIZE);
+	if (!strm->buffer) {
+		zcomp_strm_free(comp, strm);
+		return NULL;
 	}
-	return 0;
+	return strm;
 }
 
 static const struct zcomp_ops *lookup_backend_ops(const char *comp)
@@ -109,13 +118,59 @@ ssize_t zcomp_available_show(const char
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 {
-	local_lock(&comp->stream->lock);
-	return this_cpu_ptr(comp->stream);
+	struct zcomp_strm *strm;
+
+	might_sleep();
+
+	while (1) {
+		spin_lock(&comp->strm_lock);
+		if (!list_empty(&comp->idle_strm)) {
+			strm = list_first_entry(&comp->idle_strm,
+						struct zcomp_strm,
+						entry);
+			list_del(&strm->entry);
+			spin_unlock(&comp->strm_lock);
+			return strm;
+		}
+
+		/* cannot allocate new stream, wait for an idle one */
+		if (comp->avail_strm >= num_online_cpus()) {
+			spin_unlock(&comp->strm_lock);
+			wait_event(comp->strm_wait,
+				   !list_empty(&comp->idle_strm));
+			continue;
+		}
+
+		/* allocate new stream */
+		comp->avail_strm++;
+		spin_unlock(&comp->strm_lock);
+
+		strm = zcomp_strm_alloc(comp);
+		if (strm)
+			break;
+
+		spin_lock(&comp->strm_lock);
+		comp->avail_strm--;
+		spin_unlock(&comp->strm_lock);
+		wait_event(comp->strm_wait, !list_empty(&comp->idle_strm));
+	}
+
+	return strm;
 }
 
-void zcomp_stream_put(struct zcomp *comp)
+void zcomp_stream_put(struct zcomp *comp, struct zcomp_strm *strm)
 {
-	local_unlock(&comp->stream->lock);
+	spin_lock(&comp->strm_lock);
+	if (comp->avail_strm <= num_online_cpus()) {
+		list_add(&strm->entry, &comp->idle_strm);
+		spin_unlock(&comp->strm_lock);
+		wake_up(&comp->strm_wait);
+		return;
+	}
+
+	comp->avail_strm--;
+	spin_unlock(&comp->strm_lock);
+	zcomp_strm_free(comp, strm);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
@@ -148,61 +203,19 @@ int zcomp_decompress(struct zcomp *comp,
 	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
 }
 
-int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
-{
-	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm;
-	int ret;
-
-	zstrm = per_cpu_ptr(comp->stream, cpu);
-	local_lock_init(&zstrm->lock);
-
-	ret = zcomp_strm_init(comp, zstrm);
-	if (ret)
-		pr_err("Can't allocate a compression stream\n");
-	return ret;
-}
-
-int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm;
-
-	zstrm = per_cpu_ptr(comp->stream, cpu);
-	zcomp_strm_free(comp, zstrm);
-	return 0;
-}
-
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+void zcomp_destroy(struct zcomp *comp)
 {
-	int ret;
-
-	comp->stream = alloc_percpu(struct zcomp_strm);
-	if (!comp->stream)
-		return -ENOMEM;
-
-	comp->params = params;
-	ret = comp->ops->setup_params(comp->params);
-	if (ret)
-		goto cleanup;
+	struct zcomp_strm *strm;
 
-	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
-	if (ret < 0)
-		goto cleanup;
-
-	return 0;
-
-cleanup:
-	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
-	return ret;
-}
+	while (!list_empty(&comp->idle_strm)) {
+		strm = list_first_entry(&comp->idle_strm,
+					struct zcomp_strm,
+					entry);
+		list_del(&strm->entry);
+		zcomp_strm_free(comp, strm);
+	}
 
-void zcomp_destroy(struct zcomp *comp)
-{
-	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
 	kfree(comp);
 }
 
@@ -229,7 +242,12 @@ struct zcomp *zcomp_create(const char *a
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	INIT_LIST_HEAD(&comp->idle_strm);
+	init_waitqueue_head(&comp->strm_wait);
+	spin_lock_init(&comp->strm_lock);
+
+	comp->params = params;
+	error = comp->ops->setup_params(comp->params);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
--- a/drivers/block/zram/zcomp.h~zram-do-not-use-per-cpu-compression-streams
+++ a/drivers/block/zram/zcomp.h
@@ -3,10 +3,10 @@
 #ifndef _ZCOMP_H_
 #define _ZCOMP_H_
 
-#include <linux/local_lock.h>
-
 #define ZCOMP_PARAM_NO_LEVEL	INT_MIN
 
+#include <linux/wait.h>
+
 /*
  * Immutable driver (backend) parameters. The driver may attach private
  * data to it (e.g. driver representation of the dictionary, etc.).
@@ -31,7 +31,7 @@ struct zcomp_ctx {
 };
 
 struct zcomp_strm {
-	local_lock_t lock;
+	struct list_head entry;
 	/* compression buffer */
 	void *buffer;
 	struct zcomp_ctx ctx;
@@ -60,16 +60,15 @@ struct zcomp_ops {
 	const char *name;
 };
 
-/* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_strm __percpu *stream;
+	struct list_head idle_strm;
+	spinlock_t strm_lock;
+	u32 avail_strm;
+	wait_queue_head_t strm_wait;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
-	struct hlist_node node;
 };
 
-int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node);
-int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
@@ -77,7 +76,7 @@ struct zcomp *zcomp_create(const char *a
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp *comp);
+void zcomp_stream_put(struct zcomp *comp, struct zcomp_strm *strm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
--- a/drivers/block/zram/zram_drv.c~zram-do-not-use-per-cpu-compression-streams
+++ a/drivers/block/zram/zram_drv.c
@@ -31,7 +31,6 @@
 #include <linux/idr.h>
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
-#include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
 
@@ -1610,7 +1609,7 @@ static int read_compressed_page(struct z
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
 	zs_unmap_object(zram->mem_pool, handle);
-	zcomp_stream_put(zram->comps[prio]);
+	zcomp_stream_put(zram->comps[prio], zstrm);
 
 	return ret;
 }
@@ -1771,14 +1770,14 @@ compress_again:
 	kunmap_local(mem);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
 		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
 		return write_incompressible_page(zram, page, index);
 	}
 
@@ -1802,7 +1801,7 @@ compress_again:
 				   __GFP_HIGHMEM |
 				   __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				   GFP_NOIO | __GFP_HIGHMEM |
@@ -1814,7 +1813,7 @@ compress_again:
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
@@ -1822,7 +1821,7 @@ compress_again:
 	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
 	memcpy(dst, zstrm->buffer, comp_len);
-	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
 	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_write_lock(zram, index);
@@ -1981,7 +1980,7 @@ static int recompress_slot(struct zram *
 		kunmap_local(src);
 
 		if (ret) {
-			zcomp_stream_put(zram->comps[prio]);
+			zcomp_stream_put(zram->comps[prio], zstrm);
 			return ret;
 		}
 
@@ -1991,7 +1990,7 @@ static int recompress_slot(struct zram *
 		/* Continue until we make progress */
 		if (class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
-			zcomp_stream_put(zram->comps[prio]);
+			zcomp_stream_put(zram->comps[prio], zstrm);
 			continue;
 		}
 
@@ -2049,13 +2048,13 @@ static int recompress_slot(struct zram *
 			       __GFP_HIGHMEM |
 			       __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_stream_put(zram->comps[prio]);
+		zcomp_stream_put(zram->comps[prio], zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
 	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
 	memcpy(dst, zstrm->buffer, comp_len_new);
-	zcomp_stream_put(zram->comps[prio]);
+	zcomp_stream_put(zram->comps[prio], zstrm);
 
 	zs_unmap_object(zram->mem_pool, handle_new);
 
@@ -2803,7 +2802,6 @@ static void destroy_devices(void)
 	zram_debugfs_destroy();
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 }
 
 static int __init zram_init(void)
@@ -2813,15 +2811,9 @@ static int __init zram_init(void)
 
 	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.flags) * 8);
 
-	ret = cpuhp_setup_state_multi(CPUHP_ZCOMP_PREPARE, "block/zram:prepare",
-				      zcomp_cpu_up_prepare, zcomp_cpu_dead);
-	if (ret < 0)
-		return ret;
-
 	ret = class_register(&zram_control_class);
 	if (ret) {
 		pr_err("Unable to register zram-control class\n");
-		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return ret;
 	}
 
@@ -2830,7 +2822,6 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
-		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
 
--- a/include/linux/cpuhotplug.h~zram-do-not-use-per-cpu-compression-streams
+++ a/include/linux/cpuhotplug.h
@@ -119,7 +119,6 @@ enum cpuhp_state {
 	CPUHP_MM_ZS_PREPARE,
 	CPUHP_MM_ZSWP_POOL_PREPARE,
 	CPUHP_KVM_PPC_BOOK3S_PREPARE,
-	CPUHP_ZCOMP_PREPARE,
 	CPUHP_TIMERS_PREPARE,
 	CPUHP_TMIGR_PREPARE,
 	CPUHP_MIPS_SOC_PREPARE,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-switch-to-non-atomic-entry-locking.patch
zram-do-not-use-per-cpu-compression-streams.patch
zram-remove-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-permit-reclaim-in-recompression-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-unlock-slot-during-recompression.patch

