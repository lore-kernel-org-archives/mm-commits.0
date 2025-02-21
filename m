Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C07142A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181348; cv=none; b=CSzme5BLoUtcIjZ24ns5s53g822kNxTo4S4/DeRvIaVyQfPIdjTuj6ryvuURYbiqQsJk6Ey/jkhnRZury3f/u4jgYGxJ8u2NrhRja7f+ZrwcssVb0RLaTNVhoYXWRnrLMMLjueLGKPHDxnXc8c2TLWzn/EU1HWbFBwYncNS3sUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181348; c=relaxed/simple;
	bh=+3y3EpH9GzRSoYUv4QzYngoWd2KTd2m3U9bl1nUGM7Y=;
	h=Date:To:From:Subject:Message-Id; b=WE1zYV1e9qNOJibMTKmUr1O5GvOLAS2mHKfLNHfqFbZ3Wg8CDAGhTp2RqTXViTxZ0F+EgV2nj8/mTMcRYBgL/eb9ZIBu/8SOcA6ClZWwLudKM3PYuPRcAxjS5VbvnJ9HEksVHqVpB0RjsHwlATOR6Z1YX6uoV9RHqQQFCdIXcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgKtYaYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgKtYaYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D476DC4CEE6;
	Fri, 21 Feb 2025 23:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181347;
	bh=+3y3EpH9GzRSoYUv4QzYngoWd2KTd2m3U9bl1nUGM7Y=;
	h=Date:To:From:Subject:From;
	b=DgKtYaYMNBG3BlUGbVACNGiIEPble9qee3kCBGiiklIBISjgFUwDdKc+k+h0HemNF
	 r/Pz8NEHu5dlRzzR2Nd/mkDH/YIsLRys9/j0dLLG1HAD7Cb7qOhWez8tev2UizWj3X
	 JjGR9/qc+gDQ9cERjy/jmrFqDrgGK1f1RppxawA0=
Date: Fri, 21 Feb 2025 15:42:27 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-sleepable-entry-locking.patch added to mm-unstable branch
Message-Id: <20250221234227.D476DC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: sleepable entry locking
has been added to the -mm mm-unstable branch.  Its filename is
     zram-sleepable-entry-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-sleepable-entry-locking.patch

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
Subject: zram: sleepable entry locking
Date: Sat, 22 Feb 2025 07:25:32 +0900

Patch series "zsmalloc/zram: there be preemption", v8.

Currently zram runs compression and decompression in non-preemptible
sections, e.g.

    zcomp_stream_get()     // grabs CPU local lock
    zcomp_compress()

or

    zram_slot_lock() // grabs entry spin-lock zcomp_stream_get() // grabs
CPU local lock zs_map_object() // grabs rwlock and CPU local lock
zcomp_decompress() Potentially a little troublesome for a number of
reasons.

For instance, this makes it impossible to use async compression algorithms
or/and H/W compression algorithms, which can wait for OP completion or
resource availability.  This also restricts what compression algorithms
can do internally, for example, zstd can allocate internal state memory
for C/D dictionaries:

do_fsync()
 do_writepages()
  zram_bio_write()
   zram_write_page()                          // become non-preemptible
    zcomp_compress()
     zstd_compress()
      ZSTD_compress_usingCDict()
       ZSTD_compressBegin_usingCDict_internal()
        ZSTD_resetCCtx_usingCDict()
         ZSTD_resetCCtx_internal()
          zstd_custom_alloc()                 // memory allocation

Not to mention that the system can be configured to maximize compression
ratio at a cost of CPU/HW time (e.g.  lz4hc or deflate with very high
compression level) so zram can stay in non-preemptible section (even under
spin-lock or/and rwlock) for an extended period of time.  Aside from
compression algorithms, this also restricts what zram can do.  One
particular example is zram_write_page() zsmalloc handle allocation, which
has an optimistic allocation (disallowing direct reclaim) and a
pessimistic fallback path, which then forces zram to compress the page one
more time.

This series changes zram to not directly impose atomicity restrictions on
compression algorithms (and on itself), which makes zram write() fully
preemptible; zram read(), sadly, is not always preemptible yet.  There are
still indirect atomicity restrictions imposed by zsmalloc().  One notable
example is object mapping API, which returns with: a) local CPU lock held
b) zspage rwlock held

First, zsmalloc's zspage lock is converted from rwlock to a special type
of RW-lookalike look with some extra guarantees/features.  Second, a new
handle mapping is introduced which doesn't use per-CPU buffers (and hence
no local CPU lock), does fewer memcpy() calls, but requires users to
provide a pointer to temp buffer for object copy-in (when needed).  Third,
zram is converted to the new zsmalloc mapping API and thus zram read()
becomes preemptible.


This patch (of 8):

Concurrent modifications of meta table entries is now handled by per-entry
spin-lock.  This has a number of shortcomings.

First, this imposes atomic requirements on compression backends.  zram can
call both zcomp_compress() and zcomp_decompress() under entry spin-lock,
which implies that we can use only compression algorithms that don't
schedule/sleep/wait during compression and decompression.  This, for
instance, makes it impossible to use some of the ASYNC compression
algorithms (H/W compression, etc.) implementations.

Second, this can potentially trigger watchdogs.  For example, entry
re-compression with secondary algorithms is performed under entry
spin-lock.  Given that we chain secondary compression algorithms and that
some of them can be configured for best compression ratio (and worst
compression speed) zram can stay under spin-lock for quite some time.

Having a per-entry mutex (or, for instance, a rw-semaphore) significantly
increases sizeof() of each entry and hence the meta table.  Therefore
entry locking returns back to bit locking, as before, however, this time
also preempt-rt friendly, because if waits-on-bit instead of
spinning-on-bit.  Lock owners are also now permitted to schedule, which is
a first step on the path of making zram non-atomic.

Link: https://lkml.kernel.org/r/20250218235444.1543173-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250221222958.2225035-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   62 ++++++++++++++++++++++++++------
 drivers/block/zram/zram_drv.h |   20 +++++++---
 2 files changed, 65 insertions(+), 17 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-sleepable-entry-locking
+++ a/drivers/block/zram/zram_drv.c
@@ -58,19 +58,62 @@ static void zram_free_page(struct zram *
 static int zram_read_from_zspool(struct zram *zram, struct page *page,
 				 u32 index);
 
-static int zram_slot_trylock(struct zram *zram, u32 index)
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
+#define zram_lock_class(zram) (&(zram)->lock_class)
+#else
+#define slot_dep_map(zram, index) NULL
+#define zram_lock_class(zram) NULL
+#endif
+
+static void zram_slot_lock_init(struct zram *zram, u32 index)
 {
-	return spin_trylock(&zram->table[index].lock);
+	lockdep_init_map(slot_dep_map(zram, index),
+			 "zram->table[index].lock",
+			 zram_lock_class(zram), 0);
+}
+
+/*
+ * entry locking rules:
+ *
+ * 1) Lock is exclusive
+ *
+ * 2) lock() function can sleep waiting for the lock
+ *
+ * 3) Lock owner can sleep
+ *
+ * 4) Use TRY lock variant when in atomic context
+ *    - must check return value and handle locking failers
+ */
+static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
+{
+	unsigned long *lock = &zram->table[index].flags;
+
+	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
+		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
+		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+		return true;
+	}
+
+	lock_contended(slot_dep_map(zram, index), _RET_IP_);
+	return false;
 }
 
 static void zram_slot_lock(struct zram *zram, u32 index)
 {
-	spin_lock(&zram->table[index].lock);
+	unsigned long *lock = &zram->table[index].flags;
+
+	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
+	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
+	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
 }
 
 static void zram_slot_unlock(struct zram *zram, u32 index)
 {
-	spin_unlock(&zram->table[index].lock);
+	unsigned long *lock = &zram->table[index].flags;
+
+	mutex_release(slot_dep_map(zram, index), _RET_IP_);
+	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
 }
 
 static inline bool init_done(struct zram *zram)
@@ -93,7 +136,6 @@ static void zram_set_handle(struct zram
 	zram->table[index].handle = handle;
 }
 
-/* flag operations require table entry bit_spin_lock() being held */
 static bool zram_test_flag(struct zram *zram, u32 index,
 			enum zram_pageflags flag)
 {
@@ -1473,15 +1515,11 @@ static bool zram_meta_alloc(struct zram
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
 	for (index = 0; index < num_pages; index++)
-		spin_lock_init(&zram->table[index].lock);
+		zram_slot_lock_init(zram, index);
+
 	return true;
 }
 
-/*
- * To protect concurrent access to the same index entry,
- * caller should hold this table index entry's bit_spinlock to
- * indicate this index entry is accessing.
- */
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	unsigned long handle;
@@ -2625,6 +2663,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
+	lockdep_register_key(zram_lock_class(zram));
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
@@ -2653,6 +2692,7 @@ static int zram_remove(struct zram *zram
 		zram->claim = true;
 	mutex_unlock(&zram->disk->open_mutex);
 
+	lockdep_unregister_key(zram_lock_class(zram));
 	zram_debugfs_unregister(zram);
 
 	if (claimed) {
--- a/drivers/block/zram/zram_drv.h~zram-sleepable-entry-locking
+++ a/drivers/block/zram/zram_drv.h
@@ -28,7 +28,6 @@
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
 	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
 
-
 /*
  * ZRAM is mainly used for memory efficiency so we want to keep memory
  * footprint small and thus squeeze size and zram pageflags into a flags
@@ -46,6 +45,7 @@
 /* Flags for zram pages (table[page_no].flags) */
 enum zram_pageflags {
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,	/* Page consists the same element */
+	ZRAM_ENTRY_LOCK, /* entry access lock bit */
 	ZRAM_WB,	/* page is stored on backing_device */
 	ZRAM_PP_SLOT,	/* Selected for post-processing */
 	ZRAM_HUGE,	/* Incompressible page */
@@ -58,13 +58,18 @@ enum zram_pageflags {
 	__NR_ZRAM_PAGEFLAGS,
 };
 
-/*-- Data structures */
-
-/* Allocated for each disk page */
+/*
+ * Allocated for each disk page.  We use bit-lock (ZRAM_ENTRY_LOCK bit
+ * of flags) to save memory.  There can be plenty of entries and standard
+ * locking primitives (e.g. mutex) will significantly increase sizeof()
+ * of each entry and hence of the meta table.
+ */
 struct zram_table_entry {
 	unsigned long handle;
-	unsigned int flags;
-	spinlock_t lock;
+	unsigned long flags;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	ktime_t ac_time;
 #endif
@@ -137,5 +142,8 @@ struct zram {
 	struct dentry *debugfs_dir;
 #endif
 	atomic_t pp_in_progress;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key lock_class;
+#endif
 };
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

