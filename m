Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450659;
	b=lP00V+vAqcwLSydSxcB3Ji6xJSZpB80B4rKOlvyiBWJVLZPNmAvUQfomvE1r3jJknQXE
	 l4HKQqAml3kfLYkyTrqidogRtHlauF9FJSR8xhaK10FU/stoasn/wY/kbgDTV9+2qM8pi
	 +cucnUZYQP2/kqiXWJF5MqCRBAZfgvdD8gxeutOgI+CPtr38HU5JhKCLi4FcEvn0zmpGz
	 SEQtyDJBXNuG0AE5M6e1uqQRvTO4HD+c3wLG2n+/y1tLyQFva4yYisx+s7n2zoH9WsryC
	 yl6C6s/sMm4DRefpAH/6r+Gi1qjXSW1Qx0uiXhKFGKrtsQkHYzYmyrmrRFMo3nbuQMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450659;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gWXEk/YwwBk6JIDlUe2zHSSg+WJkqI/MBRSjfbSEkH8=;
	b=e+G5kLB5/WvfRWT9gZMrXWvv8OE2NLArice33oFsHv3Th6YsXwJ6WLinrtMZsCbHGTrn
	 GXLqW1g1dvZQM2JuQQAtNJTCwz4GLrTRnL4+94lSAB0I1zjGWZW/TUycsc+4XnL53cEqO
	 PYO0kRtiU5lI/dWZLN83m2vIbAFprihjdPoT3LCAQNowjvAx5dkucJL/Flcs3ao4lDQZ/
	 H31S4HfmBOFcuRe6LuBzCeOnGpO6eH4fEBAKPUd9i62bqtbM7jtkEqYUU5vdgKwBn87eu
	 WM7O+1fK7wyx2/NclUZwhab39CcJYAT+pxdUCnkTGMZLEocuqDuhNCcw6QwVR65ppVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sp3IGXaV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7716606A321
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sp3IGXaV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0FF1F00A05;
	Thu, 12 Nov 2026 02:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450659;
	bh=gWXEk/YwwBk6JIDlUe2zHSSg+WJkqI/MBRSjfbSEkH8=;
	h=Date:To:From:Subject;
	b=sp3IGXaVHFkkYutoafJX/S/ot0yEPPs91MH6yviT1EbvEKRl2gmEeys2sKD99h43M
	 W5R9hqyqNxEHDPzu7Y1Xvfh4jGUK+cqKYrEYBe+zuSdQ5UTOztpRy1hK/6H7w7er9j
	 DyWQ19sLnNlyauFyOX0J7JVFlS4gPAl7oed2EGZc=
Date: Wed, 11 Nov 2026 18:30:58 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch added to mm-unstable branch
Message-Id: <20261112023059.5B0FF1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: populate new zspage outside class->lock in zs_store()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch

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
Subject: zsmalloc: populate new zspage outside class->lock in zs_store()
Date: Wed, 11 Nov 2026 15:46:34 +0900

A new zspage is not on class fullness lists and is not movable until
zs_store() calls insert_zspage() and SetZsPageMovable(), so neither other
zs_store() callers nor compaction and page migration can see it.  Nobody
else has the handle yet either.

So for a new zspage allocate the object and copy the data before we take
class->lock, and don't take zspage read lock.  This makes class->lock
critical section shorter and saves a zspage lock/unlock.

Link: https://lore.kernel.org/20261111064707.2568433-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 mm/zsmalloc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store
+++ a/mm/zsmalloc.c
@@ -1323,8 +1323,12 @@ int zs_store(struct zs_pool *pool, struc
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
+		zspage_read_lock(zspage);
+		spin_unlock(&class->lock);
 
-		goto out;
+		obj_write(class, zspage, obj, src, size);
+		zspage_read_unlock(zspage);
+		return 0;
 	}
 
 	spin_unlock(&class->lock);
@@ -1333,8 +1337,15 @@ int zs_store(struct zs_pool *pool, struc
 	if (!zspage)
 		return -ENOMEM;
 
-	spin_lock(&class->lock);
+	/*
+	 * New zspage is not in class->fullness_list or movable yet, so we
+	 * can allocate the object and copy data before taking class->lock
+	 * and without zspage_read_lock().
+	 */
 	obj = obj_malloc(pool, zspage, handle);
+	obj_write(class, zspage, obj, src, size);
+
+	spin_lock(&class->lock);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1343,13 +1354,8 @@ int zs_store(struct zs_pool *pool, struc
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
-out:
-	zspage_read_lock(zspage);
 	spin_unlock(&class->lock);
 
-	obj_write(class, zspage, obj, src, size);
-	zspage_read_unlock(zspage);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_store);
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

