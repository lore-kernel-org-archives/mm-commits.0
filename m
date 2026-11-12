Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450643;
	b=RP8Oul51Tp4RZY9sUAlNfH7qkhxQSVZUJOAHnrfD+2y9PB/uG3JfyuB0rRXGAm2RdRVq
	 A9kYHb5VFvmm3P/p3gP1hSPCLXd17dW4v58Mf2cAqsNMWL3UBMjjDHQJnqYkGoA9u6gPW
	 VKPE8Uxp4weFSTUCif3v/9cZjHFvETV+TMOb0zCi5KwGMru7VUiqngDBbYGg7R58CyXPG
	 0MNwioobA/zCUJVZGly1/4E/d6Rk3GnD1hvXAZgRKY8bi14aPYDfAzNjryOGGo9GYpS2q
	 SgtxfUx9pVONWgPADdbCJmyxHblt2dwPwbr7w05+HQdJ46dDez0KjyQmyLuItXkTqCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450643;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tQBUckRVg3bQxLIv9QL6YL2tEw2EEzvVOGeNuc0rayM=;
	b=zd3Hcsq8Ty10UISquAIinuOMiECqeOU9gBKmSXFtjxAT/SFA/KYEA8UVLK0jYzZ8W+1c
	 zO3lWMcDd8IAMaZk+Mm6CGq4WpLmG02PZxJh8smDxm21EERr/QMhKoQhAQa/n3w6N6wI7
	 QO/Y/r0krIqrt2KABilie033dKZiYXLDziqpfc9xKZkKztXQnsgtSLq2rDnkdK0b7jYrg
	 NF7LM8YCwDffqJbcFdiwrWS/y2NC2v/nhnm1iLLglekbgSdKlj2SsXIEm8yG7zjopAp3D
	 9Rc4m9QsFDlcD8NqVMv8D7oyu8FEaOVMgNqYoNRm6s60l95Xn9m3yjZ6u2Ra2XZBR1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=khzyAeVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229C606A327
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=khzyAeVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA7F1F00A05;
	Thu, 12 Nov 2026 02:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450642;
	bh=tQBUckRVg3bQxLIv9QL6YL2tEw2EEzvVOGeNuc0rayM=;
	h=Date:To:From:Subject;
	b=khzyAeVHY71dPYQkMPqiqY68wWUWned5Ff3ItASIEwWshROzGScqi/sfOOQBbz+HE
	 V/7MzCs+A4bsJ/YDLxS6LQitr4BorV0qfZSPPLHhUlsvvEaWLFrPKHY5eRK4C1ItfA
	 m5byyfRYXVqp5bRR83/dWPih8cGAKtD7GuokEZXc=
Date: Wed, 11 Nov 2026 18:30:42 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-allocate-zsmalloc-object-under-slot-lock.patch added to mm-unstable branch
Message-Id: <20261112023042.8EA7F1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: allocate zsmalloc object under slot lock
has been added to the -mm mm-unstable branch.  Its filename is
     zram-allocate-zsmalloc-object-under-slot-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-allocate-zsmalloc-object-under-slot-lock.patch

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
Subject: zram: allocate zsmalloc object under slot lock
Date: Wed, 11 Nov 2026 15:46:29 +0900

zram_write_page() and write_incompressible_page() allocate and write
zsmalloc object first and take slot lock only to free the old slot data
and set the new handle.  A subsequent patch makes zsmalloc store object
location directly in zram table entry, so we need to free the slot before
we allocate a new object for it.

Free the slot and allocate the object under slot lock.  recompress_slot()
already allocates objects under it, and GFP_NOIO reclaim cannot re-enter
zram write path.

mem_limit is checked before slot_free() (previous patch), so hitting the
limit keeps the old slot data.  zs_malloc() can still fail after
slot_free(), e.g.  when we write from reclaim (PF_MEMALLOC), which is
swap-out, so the old slot data (if any) is stale anyway, or when the
writer is an OOM victim that has no reserves left.  The slot is left empty
then, matching standard block write-failure semantics.

Link: https://lore.kernel.org/20261111064707.2568433-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 drivers/block/zram/zram_drv.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-allocate-zsmalloc-object-under-slot-lock
+++ a/drivers/block/zram/zram_drv.c
@@ -2250,11 +2250,15 @@ static int write_incompressible_page(str
 	struct zs_handle *handle;
 	void *src;
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
+	}
 
 	update_used_max(zram);
 
@@ -2262,8 +2266,6 @@ static int write_incompressible_page(str
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
@@ -2315,11 +2317,14 @@ static int zram_write_page(struct zram *
 		return write_incompressible_page(zram, page, index);
 	}
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, comp_len,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	if (IS_ERR(handle)) {
 		zcomp_cstrm_put(zstrm);
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
 	}
 
@@ -2328,8 +2333,6 @@ static int zram_write_page(struct zram *
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
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

