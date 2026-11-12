Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450640;
	b=O8Lfu7oxS+8Gjq/fzt0gDdsKHl6VfSaMPko2IRbtUMG89jT8Ic5d25Tv5Xx3zII8SmDt
	 AOGjh51tgrLgDL8cF0t75CuDWIWWTiEyk3IrPw5+WoOc+1f5B1I7LQV+dirfvmKrcTSQX
	 Ou34kU1KxaOJnmI8qwnSc/OiVmRxUeOavSvtei3IgyhZXE45IwdQwBMP6izAPLHenl7fe
	 fj1lnbHIP8ZO8RFwXZF86DLykuVCpWDsGCCg69NP1zsPapOybW6Zxg11ycZUv/aZJJ7PV
	 v2LeJ9C0wUbo43NCxyt+TdEOZQkcoFZrBjuaAdRZE/dEoWXB6WYKPjzOah/1fyHqOpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450640;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6eADYinCHuBIiTU9DOkZJlqR3Z+Du5nRUbHF1LMGFy8=;
	b=NN4XSNS/r2F1+edz0HAoz9BYM5SPOwTzqWUPgkyhu9VYpBfgwmy0S1rHx8Xww0LvgyDE
	 eYWcaCjsgysiIueWBIMruYNLrkFikANZVTMCZBLWukdr1Ijz64giuHomD/PUC3xygYiPs
	 Xjl8oj2NlK1GfBfj8bCHiJAtCYZhUA7bylAc5VkkiUA8j65pch9v1Y3brA7Q9jgy2QDEw
	 uJMwSVMDSLsxpsl2b1R8fjXDtAdPoA3hiTexdvTGxoZj84vmeEZ3E+8a0z2sPltOF184M
	 2/iAp9TBZD4CDL863F3xMXKidwNqSwn7kMGVfIW3WjbhOyxQ4RuXxS70SJNFFJYOLNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KgZDbrhw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC11606A321
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KgZDbrhw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEF21F00A07;
	Thu, 12 Nov 2026 02:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450640;
	bh=6eADYinCHuBIiTU9DOkZJlqR3Z+Du5nRUbHF1LMGFy8=;
	h=Date:To:From:Subject;
	b=KgZDbrhwAevJTMuTbLV+b5aUxhJjGfABVx/R6EaIvHuPXW7urvlJ3z5xfMuwf6e5P
	 MDwX7v0Q69kCoPoUfBoCLhDXYcyXblyvezRU9xjeZB0pIfceqYtaqLT5VLsk46WH68
	 2E105pOvS9CxZMqRkU9tXt8yUsC8vajvEjCvrUMg=
Date: Wed, 11 Nov 2026 18:30:39 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-check-mem_limit-before-allocating-zsmalloc-object.patch added to mm-unstable branch
Message-Id: <20261112023039.DDEF21F00A07@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: check mem_limit before allocating zsmalloc object
has been added to the -mm mm-unstable branch.  Its filename is
     zram-check-mem_limit-before-allocating-zsmalloc-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-check-mem_limit-before-allocating-zsmalloc-object.patch

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
Subject: zram: check mem_limit before allocating zsmalloc object
Date: Wed, 11 Nov 2026 15:46:28 +0900

zram_can_store_page() is called after zs_malloc(), so once we reach
mem_limit every write that doesn't fit into a partial zspage allocates a
new zspage only to free it right away.

Check mem_limit in zram_write_page() before compressing the page and
allocating from zsmalloc, and update max_used_pages after zs_malloc()
succeeds.  mem_limit was never a hard limit, the allocation that crosses
it happens before the check anyway, so now we can go over the limit by up
to one zspage per concurrent writer, and writes fail early until enough
slots are freed.

mem_limit can change under us, so read ->limit_pages once.

Link: https://lore.kernel.org/20261111064707.2568433-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 Documentation/admin-guide/blockdev/zram.rst |    4 ++
 drivers/block/zram/zram_drv.c               |   27 ++++++++----------
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-check-mem_limit-before-allocating-zsmalloc-object
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -181,7 +181,9 @@ Set memory limit: Optional
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
 The value can be either in bytes or you can use mem suffixes.
-In addition, you could change the value in runtime.
+In addition, you could change the value in runtime.  The limit is
+checked before zsmalloc allocation, so memory usage may slightly
+exceed it (by up to one zspage per concurrent writer).
 Examples::
 
 	# limit /dev/zram0 with 50MB memory
--- a/drivers/block/zram/zram_drv.c~zram-check-mem_limit-before-allocating-zsmalloc-object
+++ a/drivers/block/zram/zram_drv.c
@@ -177,8 +177,9 @@ static void mark_slot_accessed(struct zr
 #endif
 }
 
-static inline void update_used_max(struct zram *zram, const unsigned long pages)
+static inline void update_used_max(struct zram *zram)
 {
+	unsigned long pages = zs_get_total_pages(zram->mem_pool);
 	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
 
 	do {
@@ -190,12 +191,12 @@ static inline void update_used_max(struc
 
 static bool zram_can_store_page(struct zram *zram)
 {
-	unsigned long alloced_pages;
+	unsigned long limit_pages = READ_ONCE(zram->limit_pages);
 
-	alloced_pages = zs_get_total_pages(zram->mem_pool);
-	update_used_max(zram, alloced_pages);
+	if (!limit_pages)
+		return true;
 
-	return !zram->limit_pages || alloced_pages <= zram->limit_pages;
+	return zs_get_total_pages(zram->mem_pool) <= limit_pages;
 }
 
 #if PAGE_SIZE != 4096
@@ -375,7 +376,7 @@ static ssize_t mem_limit_store(struct de
 		return -EINVAL;
 
 	guard(rwsem_write)(&zram->dev_lock);
-	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
+	WRITE_ONCE(zram->limit_pages, PAGE_ALIGN(limit) >> PAGE_SHIFT);
 
 	return len;
 }
@@ -2255,10 +2256,7 @@ static int write_incompressible_page(str
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (!zram_can_store_page(zram)) {
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	src = kmap_local_page(page);
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
@@ -2297,6 +2295,9 @@ static int zram_write_page(struct zram *
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
+	if (!zram_can_store_page(zram))
+		return -ENOMEM;
+
 	zstrm = zcomp_cstrm_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -2322,11 +2323,7 @@ static int zram_write_page(struct zram *
 		return PTR_ERR(handle);
 	}
 
-	if (!zram_can_store_page(zram)) {
-		zcomp_cstrm_put(zstrm);
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
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

