Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450631;
	b=GmyKcwFWHKjoxhQFFulJI4k5kD2gRtSf4OsvP+QaWQJsVPoZWxQGYjodDOtcP6a+gxIZ
	 0Wm+QD+4vinyl4F7CbMLFUKblyZsL6KLh/7dq+ESpDM20igVMEnL7OdmF7MG46FT9Y+su
	 InDk1wSxUMrkvy2HFD8J3esDLcW5rSipFkJ9P6BzAcqzWNgQF1JkaaKeZcfn+cmxCo2JU
	 1il6ug9oLbaZ54mEkCo1qKLQ3Q11Ps6a9BHKXp/0QLbHwJvRbTQm6QhvgP2zkXBn6OzRh
	 6JXEYA7n5hzvRipE5XYYO2iOlkRYzxO8hNelyDO+PFmQzkPToUft0aeKub7/Whh/T0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450631;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xpP5WpHsljevOGHQlmHNvGVwovaz4XAvlLyJMqYwtBQ=;
	b=irUABJUKdfGaW9Awn87vszibMj0+kr850jVJOdbWhJY9+cGz4Acodx2avvKmKmOhAWzt
	 nMGU0XzxBP4SMzufNMdZQvAuJmKKuFR/gv63KM7/3mz3XCgUktOaAjPktgiR2ptRajCcl
	 2rbPPcU+nOL4Ca4yyFxaczMoejw+dsWiyFdwLjMox6zEd+gwOkSfqlY68PRKxDSOstnTw
	 lELxc/ZUXqzhYgtFPmpscQmMqL6n7uZtEZyhzH+trFw4tkzj42N8p3/8R0UNNdZPcxjOi
	 rLqg7pvPdEuQDh0Hzb6LL9Nh10K9vwcp6TKITwRQDXWOn6HthvORoIIcEG5lmeK27XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="X5LnLd/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A0D606A32D
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X5LnLd/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7341F00A06;
	Thu, 12 Nov 2026 02:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450630;
	bh=xpP5WpHsljevOGHQlmHNvGVwovaz4XAvlLyJMqYwtBQ=;
	h=Date:To:From:Subject;
	b=X5LnLd/9tXKDzk4nK9TrdK6F/uCgtL6/pA6PROASyL2z4QJ3Be+PgdHNujUjXYtQv
	 lND4Bsb48Wwq4AJbAFk84Zhs5Bk8txYx9JM1UyYAywiLzK0AogAa5y0IGLHfaxQre2
	 3iRv9XtVDEqORhVJEBx7ZWkGRwQe9W40CmPv+MI0=
Date: Wed, 11 Nov 2026 18:30:30 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-get_slot_handle-and-set_slot_handle.patch added to mm-unstable branch
Message-Id: <20261112023030.9E7341F00A06@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: drop get_slot_handle() and set_slot_handle()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-drop-get_slot_handle-and-set_slot_handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-get_slot_handle-and-set_slot_handle.patch

This patch will later appear in the mm-unstable branch at
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
Subject: zram: drop get_slot_handle() and set_slot_handle()
Date: Wed, 11 Nov 2026 15:46:25 +0900

zram_table_entry ->handle is overloaded to store zsmalloc handle,
same-filled page pattern and writeback block index, so calling
set_slot_handle() or get_slot_handle() for blk_idx and same-filled pattern
is confusing.

Turn ->handle into a union of handle, element and blk_idx, drop
get_slot_handle() and set_slot_handle(), and open-code field accesses.  No
functional change.

Link: https://lore.kernel.org/20261111064707.2568433-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 drivers/block/zram/zram_drv.c |   43 +++++++++++---------------------
 drivers/block/zram/zram_drv.h |    6 +++-
 2 files changed, 21 insertions(+), 28 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-get_slot_handle-and-set_slot_handle
+++ a/drivers/block/zram/zram_drv.c
@@ -111,17 +111,6 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static unsigned long get_slot_handle(struct zram *zram, unsigned long index)
-{
-	return zram->table[index].handle;
-}
-
-static void set_slot_handle(struct zram *zram, unsigned long index,
-			    unsigned long handle)
-{
-	zram->table[index].handle = handle;
-}
-
 static bool test_slot_flag(struct zram *zram, unsigned long index,
 			   enum zram_pageflags flag)
 {
@@ -951,8 +940,8 @@ static int zram_writeback_complete(struc
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
 		atomic64_dec(&zram->stats.huge_pages);
 	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
-	zs_free(zram->mem_pool, get_slot_handle(zram, index));
-	set_slot_handle(zram, index, req->blk_idx);
+	zs_free(zram->mem_pool, zram->table[index].handle);
+	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
@@ -2053,7 +2042,7 @@ static void slot_free(struct zram *zram,
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
 		clear_slot_flag(zram, index, ZRAM_WB);
-		zram_release_bdev_block(zram, get_slot_handle(zram, index));
+		zram_release_bdev_block(zram, zram->table[index].blk_idx);
 		goto out;
 	}
 
@@ -2067,7 +2056,7 @@ static void slot_free(struct zram *zram,
 		goto out;
 	}
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	if (!handle)
 		return;
 
@@ -2077,7 +2066,7 @@ static void slot_free(struct zram *zram,
 		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
-	set_slot_handle(zram, index, 0);
+	zram->table[index].element = 0;
 	set_slot_size(zram, index, 0);
 }
 
@@ -2087,7 +2076,7 @@ static int read_same_filled_page(struct
 	void *mem;
 
 	mem = kmap_local_page(page);
-	zram_fill_page(mem, PAGE_SIZE, get_slot_handle(zram, index));
+	zram_fill_page(mem, PAGE_SIZE, zram->table[index].element);
 	kunmap_local(mem);
 	return 0;
 }
@@ -2099,7 +2088,7 @@ static int read_incompressible_page(stru
 	unsigned long handle;
 	void *src, *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
 	/* an incompressible object never spans two pages */
 	src = kmap_local_page(sg_page(sg));
@@ -2123,7 +2112,7 @@ static int read_compressed_page(struct z
 	void *dst;
 	int ret, prio;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
@@ -2150,7 +2139,7 @@ static int read_from_zspool_raw(struct z
 	unsigned int size;
 	void *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 
 	/*
@@ -2177,7 +2166,7 @@ static int read_from_zspool(struct zram
 			    unsigned long index)
 {
 	if (test_slot_flag(zram, index, ZRAM_SAME) ||
-	    !get_slot_handle(zram, index))
+	    !zram->table[index].handle)
 		return read_same_filled_page(zram, page, index);
 
 	if (!test_slot_flag(zram, index, ZRAM_HUGE))
@@ -2198,7 +2187,7 @@ static int zram_read_page(struct zram *z
 		ret = read_from_zspool(zram, page, index);
 		slot_unlock(zram, index);
 	} else {
-		unsigned long blk_idx = get_slot_handle(zram, index);
+		unsigned long blk_idx = zram->table[index].blk_idx;
 
 		/*
 		 * The slot should be unlocked before reading from the backing
@@ -2244,7 +2233,7 @@ static int write_same_filled_page(struct
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_SAME);
-	set_slot_handle(zram, index, fill);
+	zram->table[index].element = fill;
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
@@ -2278,7 +2267,7 @@ static int write_incompressible_page(str
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2344,7 +2333,7 @@ static int zram_write_page(struct zram *
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2460,7 +2449,7 @@ static int recompress_slot(struct zram *
 	void *src;
 	int ret = 0;
 
-	handle_old = get_slot_handle(zram, index);
+	handle_old = zram->table[index].handle;
 	if (!handle_old)
 		return -EINVAL;
 
@@ -2543,7 +2532,7 @@ static int recompress_slot(struct zram *
 	zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle_new);
+	zram->table[index].handle = handle_new;
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
--- a/drivers/block/zram/zram_drv.h~zram-drop-get_slot_handle-and-set_slot_handle
+++ a/drivers/block/zram/zram_drv.h
@@ -78,7 +78,11 @@ enum zram_pageflags {
  * of each entry and hence of the meta table.
  */
 struct zram_table_entry {
-	unsigned long handle;
+	union {
+		unsigned long handle;
+		unsigned long element;
+		unsigned long blk_idx;
+	};
 	union {
 		unsigned long __lock;
 		struct attr {
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
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch

