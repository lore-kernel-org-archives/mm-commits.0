Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329372;
	b=1X3Sq5adV6vfpNE3eusHXbQxOwuK3NJCygmgBnWv0sdemGQUi0KzeF28tu160u5I4V1d
	 kjgUW2M2giyrxJg4hoL9O1O83SPR6okxKF8K/5RfzkqvK3s6s4KvZl2IhwHgx2G4FYU/y
	 qwK91gUsuEcpaHdotfmkZ8V13DZDzPjofHGBlSZ/2VBihr25YJBmwFIci0C2cXbkJgaD0
	 S0MwAUeAbt4BLBhbzf9qnse9f2S4Zh25Mahvi3v9oXNH28eYQN0Jfj2NsRAM+N0SMQhO3
	 IjrWhlCLDA7mlKePeof3orxEFpvSqNO3N0YTRL69XoMHCtn13c/n8QV3HYkNWxyaiJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329372;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zcRzJEqQm0TcWzYKUnAM1JFIHfqWS3cNRCSJJHUVQ7E=;
	b=YJF7q8QSzpIr/W8lOpKklMNPpjKVWVZ1PA2Wj27wwy+9og6HleHKkx7IDbnfCr6kNthL
	 i57TR8ntvUy7k7sUlzA8eHNT5xeKt9trCMLL2aWTNeowA+JuNL4niJMA33eAfxBDxBPBO
	 /hc2lspSe++cubDjxTfZDKeVkdIJ2wbzb9rnZTYU3N5jh64YSo04kUSQv+LImpPmp+lRO
	 jozhH90W3XprzCRt4Lorh+1nYp72yQwbnoj6p+XiITlKp0NYQDD8Khd2vnTaueT+X3Rtj
	 UvU3efI1pRo8RbhlpgAW6STzdPJg0YV5aFiy2CaRPQHB1fUWWmgS88A7qOwabmreRGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A++SS4b1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22F606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A++SS4b1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC35A1F000C1;
	Fri, 30 Oct 2026 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329371;
	bh=zcRzJEqQm0TcWzYKUnAM1JFIHfqWS3cNRCSJJHUVQ7E=;
	h=Date:To:From:Subject;
	b=A++SS4b1a5YV07Ubw+4FX3cWcZD9TijQtMZtOnEd1/T61sTDKq3obnlmCkYYD55ls
	 JXYSORwun1FzBkMB1VmgynnCpYWjwKdgZUwZL9ohrAbo2vdic1qWatnUlulVYwnvOH
	 CBZnC9H5+PT7sV+LZsByTKAr+ViOlRVvYUMRyCCc=
Date: Thu, 29 Oct 2026 20:02:51 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-borrow-idle-decompression-streams-in-exclusive-mode.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030251.AC35A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: borrow idle decompression streams in exclusive mode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-borrow-idle-decompression-streams-in-exclusive-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-borrow-idle-decompression-streams-in-exclusive-mode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: borrow idle decompression streams in exclusive mode
Date: Sun, 25 Oct 2026 11:18:30 +0900

Shared decompression streams eliminate Reader vs Reader priority
inversion for backends with stateless decompression.  However,
backends with stateful decompression contexts (zstd, deflate)
still require exclusive access to the stream [1].

Instead of unconditionally blocking on the local CPU's ->excl_lock,
we can scan online CPUs starting from the current one and try to
borrow the first free stream.  Only when all online streams are
busy, sleep on a per-zcomp waitqueue until any CPU releases an
exclusive stream, which significantly drops contention and wait
time, per Bo Zhang's measurements [2]:

  Metric              Base      cross-CPU borrow
  ----------------------------------------------
  dexcl_contended     15,919    1,447
  dexcl_wait_ns_total 109.6 s   3.66 s
  dexcl_wait_ns_max   145 ms    26.6 ms
  dexcl_avg_wait      6.88 ms   2.53 ms
  dexcl_acquire       2.21M     2.94M

A quick synthetic fio test for Reader vs Reader inversion on 24 CPUs
(preempt=full, zstd, 48 low priority (nice 19) bg readers, 24 normal
priority (nice 0) CPU hogs and 24 high priority (nice -19) fg readers),
fg reader results (average of 3 runs):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        396k               1,064k        (+2.7x)
  Read clat avg    48.32 us           9.66 us       (-5.0x)
  Read clat p50    7.58 us            8.85 us       (+17%)
  Read clat p99    14.27 us           31.02 us      (+2.2x)
  Read clat stdev  7,571 us           31.92 us      (-237x)
  Read clat max    3,555,300 us       6,288 us      (-565x)

Reader vs Reader with CONFIG_SCHED_PROXY_EXEC=y in both kernels,
21 runs each:

                          Base                    Patched
  ------------------------------------------------------------------
  zstd-3   Read IOPS      1,055k (+-160k)         1,045k (+-50k)
           Read clat max  113 ms - 2.35 s         2.8 - 6.3 ms
  zstd-12  Read IOPS      973k (+-175k)           1,045k (+-17k)
           Read clat max  135 ms - 2.34 s         2.9 - 7.5 ms

  Welch's t-test on IOPS, 21 runs each (patched vs base):
                          diff        95% CI              p
  ------------------------------------------------------------------
  zstd-3                  -1.0%       [-76k, +63k]        0.78
  zstd-12                 +7.4%       [+2k, +149k]        0.073

  Runs with max read latency over 100 ms / over 1 s:
                          Base                    Patched
  ------------------------------------------------------------------
  zstd-3                  21 of 21 / 9 of 21      0 / 0
  zstd-12                 21 of 21 / 14 of 21     0 / 0

With proxy execution base is about as fast as patched at both levels
(no significant difference, p = 0.78 and p = 0.073).  Base is noisy
though, and its worst case is still 0.1-2.3 s in every run.

Link: https://lore.kernel.org/20261025021839.1542805-15-senozhatsky@chromium.org
Link: https://lore.kernel.org/linux-kernel/20261015112440.1491168-1-zhangbo56@xiaomi.com [1]
Link: https://lore.kernel.org/linux-kernel/20261016134847.1620103-1-zhangbo0325@gmail.com [2]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/zcomp.c    |   75 +++++++++++++++++++++++---------
 drivers/block/zram/zcomp.h    |    5 +-
 drivers/block/zram/zram_drv.c |    4 -
 3 files changed, 60 insertions(+), 24 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-borrow-idle-decompression-streams-in-exclusive-mode
+++ a/drivers/block/zram/zcomp.c
@@ -185,38 +185,67 @@ bool zcomp_shared_decomp(struct zcomp *c
 	return !comp->ops->create_dctx;
 }
 
+static bool zcomp_dstrm_excl_trylock(struct zcomp_dstrm *zstrm)
+{
+	/* Cheap pre-check: don't touch a busy stream's cachelines */
+	if (mutex_is_locked(&zstrm->excl_lock))
+		return false;
+	/*
+	 * Pin the stream.  The write side of ->lock is only taken by
+	 * zcomp_cpu_dead(), which also sets ->local_copy to NULL.
+	 */
+	if (!down_read_trylock(&zstrm->lock))
+		return false;
+	if (zstrm->local_copy && mutex_trylock(&zstrm->excl_lock))
+		return true;
+	up_read(&zstrm->lock);
+	return false;
+}
+
+static struct zcomp_dstrm *zcomp_dstrm_excl_tryget(struct zcomp *comp)
+{
+	unsigned int cpu, start = raw_smp_processor_id();
+	struct zcomp_dstrm *zstrm;
+
+	/* Best-effort start CPU hint; migration during the scan is fine */
+	for_each_online_cpu_wrap(cpu, start) {
+		zstrm = per_cpu_ptr(comp->dstream, cpu);
+		if (zcomp_dstrm_excl_trylock(zstrm))
+			return zstrm;
+	}
+	return NULL;
+}
+
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode)
 {
-	for (;;) {
-		struct zcomp_dstrm *zstrm = raw_cpu_ptr(comp->dstream);
+	struct zcomp_dstrm *zstrm;
 
-		/*
-		 * Pin the stream.  The write side of ->lock is only taken
-		 * by zcomp_cpu_dead(), so this never contends with other
-		 * decompression requests, regardless of their mode.
-		 */
-		down_read(&zstrm->lock);
-		if (!zstrm->local_copy) {
-			/* The stream has been destroyed, re-try */
+	if (mode == ZCOMP_DSTRM_SHARED) {
+		for (;;) {
+			zstrm = raw_cpu_ptr(comp->dstream);
+			down_read(&zstrm->lock);
+			if (zstrm->local_copy)
+				return zstrm;
 			up_read(&zstrm->lock);
-			continue;
 		}
-
-		/*
-		 * Exclusive requests additionally own ->local_copy and
-		 * ->ctx and hence can only wait for each other.
-		 */
-		if (mode == ZCOMP_DSTRM_EXCLUSIVE)
-			mutex_lock(&zstrm->excl_lock);
-		return zstrm;
 	}
+
+	/* Checks zcomp_dstrm_excl_tryget() before touching the waitq */
+	wait_event(comp->dstrm_waitq, (zstrm = zcomp_dstrm_excl_tryget(comp)));
+	return zstrm;
 }
 
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode)
+void zcomp_dstrm_put(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+		     enum zcomp_dstrm_mode mode)
 {
-	if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+	if (mode == ZCOMP_DSTRM_EXCLUSIVE) {
 		mutex_unlock(&zstrm->excl_lock);
+		up_read(&zstrm->lock);
+		if (wq_has_sleeper(&comp->dstrm_waitq))
+			wake_up(&comp->dstrm_waitq);
+		return;
+	}
 	up_read(&zstrm->lock);
 }
 
@@ -289,6 +318,8 @@ int zcomp_decompress(struct zcomp *comp,
 	mutex_lock(&zstrm->excl_lock);
 	ret = zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy, &req);
 	mutex_unlock(&zstrm->excl_lock);
+	if (wq_has_sleeper(&comp->dstrm_waitq))
+		wake_up(&comp->dstrm_waitq);
 	return ret;
 }
 
@@ -357,6 +388,8 @@ static int zcomp_init(struct zcomp *comp
 		goto cleanup;
 	}
 
+	init_waitqueue_head(&comp->dstrm_waitq);
+
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
 
--- a/drivers/block/zram/zcomp.h~zram-borrow-idle-decompression-streams-in-exclusive-mode
+++ a/drivers/block/zram/zcomp.h
@@ -5,6 +5,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/wait.h>
 
 struct scatterlist;
 
@@ -96,6 +97,7 @@ struct zcomp_ops {
 struct zcomp {
 	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
+	wait_queue_head_t dstrm_waitq;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -115,7 +117,8 @@ void zcomp_cstrm_put(struct zcomp_cstrm
 bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
+void zcomp_dstrm_put(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+		     enum zcomp_dstrm_mode mode);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len);
--- a/drivers/block/zram/zram_drv.c~zram-borrow-idle-decompression-streams-in-exclusive-mode
+++ a/drivers/block/zram/zram_drv.c
@@ -1382,7 +1382,7 @@ static int decompress_bdev_page(struct z
 		copy_page(dst, zstrm->local_copy);
 		kunmap_local(dst);
 	}
-	zcomp_dstrm_put(zstrm, ZCOMP_DSTRM_EXCLUSIVE);
+	zcomp_dstrm_put(zram->comps[prio], zstrm, ZCOMP_DSTRM_EXCLUSIVE);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2135,7 +2135,7 @@ static int read_compressed_page(struct z
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
-	zcomp_dstrm_put(zstrm, mode);
+	zcomp_dstrm_put(zram->comps[prio], zstrm, mode);
 	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	return ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch

