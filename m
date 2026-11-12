Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450645;
	b=caSXyNmR44eT+1L6ZEymd/j4XnwlPPsUlnsDTpDHeCH5yTlHM3epldA3VkF+dZ5kVDbf
	 X4d2yDOTEjy/waUuMAAM/a3+WgogiYBbqcTSBTAndXSud9DOY6VVHbpJmlLWroyH6esE8
	 M8o1Gro7+QgGaDcikyJOLYK5KAlVtK7L3bWfau4znOeN5rJw3DnGGN158HN7Vk0etPfFW
	 /GKmq1cp7/6PDcYmc6yDUwcJKM5BNtMkWhio1UmEhH02g1WTGL7eV7jQr9JF9D+lQbfkM
	 CSwoHxfC+9eSNPtdQZTK6Q3Q2m1IMbKRmUoV4hvcjQWPpWWbgLKNLK1qDWbWmTYJgiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450645;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7qlAh+t/00qmd/ZHHlqkzaqifTYBlGQrkAw7/ad3s6Q=;
	b=YspJ/GojPg9zt2ENOLYKt/3qwSNdSlCcPkcDGPWEtUl3mvIdNM3EUnvXB1DT2GcCTc2g
	 lhwJnZ7v057a6+gJg3FykJ9p2n8rLqAjq+TRvp3R84/Dyhq+jgXP5lBJCoFbaI0jIvocM
	 byOSshLzhj8jQo5Ce11f6u87SM8VBHjoSdVVN2I8UcoaoQ7rgQdEWaT6OTycH5xDShdCf
	 iLuxyZkQ2MH+uWBKkTcvHhBpUyaoAPM59vvZ6zME2cHfg+NXfH97TxuM3o8CJHjKJPWnm
	 YNptZwLlCyivkAv7lKQ+BnoeI849aV6U3/zKAoTFIYsQtDjZPE9Rig3HCIAUAViukAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q6Pi0Xgr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33788606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q6Pi0Xgr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B236F1F00A06;
	Thu, 12 Nov 2026 02:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450644;
	bh=7qlAh+t/00qmd/ZHHlqkzaqifTYBlGQrkAw7/ad3s6Q=;
	h=Date:To:From:Subject;
	b=q6Pi0XgrzottfMKv/9uhlsZneHHfD+ksg7lianRhLP5m25xZDZAMzFAGS4Ewp5Xjz
	 6AC43D53HvlUNWZIk5H7nAGVrga4pTZ0stytqR/6Xcfhx+4UEATp+U5U8W2jK8NqYw
	 BwTP3RHLQWVRiQx4Deq0zxgaHPxajb/UHPCcwAAo=
Date: Wed, 11 Nov 2026 18:30:44 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-do-not-free-the-entry-if-its-pool-is-null.patch added to mm-unstable branch
Message-Id: <20261112023044.B236F1F00A06@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zswap: do not free the entry if its pool is NULL
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-do-not-free-the-entry-if-its-pool-is-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-do-not-free-the-entry-if-its-pool-is-null.patch

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
Subject: zswap: do not free the entry if its pool is NULL
Date: Wed, 11 Nov 2026 15:46:30 +0900

zswap_entry_free() warns if the entry has no pool (which should never
happen), skips zs_free() and then frees the entry.  A subsequent patch
embeds zsmalloc handle into zswap_entry, so zsmalloc object will point to
the entry, and we cannot free the entry while the object is still there.

Bail out early and leak the entry, its cgroup charge and stats instead.

Link: https://lore.kernel.org/20261111064707.2568433-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 mm/zswap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~zswap-do-not-free-the-entry-if-its-pool-is-null
+++ a/mm/zswap.c
@@ -787,10 +787,11 @@ static void zswap_entry_free(struct zswa
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
 	zswap_lru_del(entry);
-	if (!WARN_ON_ONCE(!pool)) {
-		zs_free(pool->zs_pool, entry->handle);
-		zswap_pool_put(pool);
-	}
+	if (WARN_ON_ONCE(!pool))
+		return;
+
+	zs_free(pool->zs_pool, entry->handle);
+	zswap_pool_put(pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
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

