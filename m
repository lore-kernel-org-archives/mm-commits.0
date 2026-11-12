Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450633;
	b=aJOli2sMKq/bPNNbEf1lQkHGzcT/DhOAEmsJWHArTHWxcm2PbqDUiLyHjcJGwtwo63jf
	 XslbOXj/pWuQ3vDgqsfxFKgEynVRqI6Zbp3sj7MwlGwPyy5d9t0wyfV65nehaIA2Z7T+H
	 yMQ9NpJ3oF4lK1JuBhOOVeibLpiuFA7O7BTI+gLdGw6nolsK9CHVL+3s9fO3zSHTa39o5
	 l3Qphl8Uu7U9kU2l3HyL2m23LoYKuYxX9f8Tdkq0Zvd05CCw1fn5+f355DHGNxD1TSyvP
	 Z0GHttsCOoGnbybWTvI3sNl962zkSIa0VPX0MvRtHHYmnGwZLfYd01VysPXaUq9Ujgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450633;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nqfGVCakpaRvDeNusAVT0YDTR6d31gOByAw/m1ispBw=;
	b=L6Z3EyB9TB1B1VZY34ByBU7IpgneXgwMMf5WbCIYmDmt9ZIr+ugZ3W+aGEv8LMZjcRPk
	 LumPLyoEuIVH5QaT2HjFzeKFv2R0tPGv/NNtUAy5BefwYzLgQdlOG9S2D0WNpcjghz+fS
	 jsomV7OXXiXWebcf3IKJ/4DppxUDBwLdfrXGUZO70eIkB8O6vC8FGK//jwEY5bRWJSk3u
	 yUL/vZ8HCDuN5Jx/8/BTvZPF67bj0G+2xHno6CGJBtVnzq8trZrVYIgK2yfNqctyxxb2Z
	 /8Dloxih29Q/fNb9D/EjDyx2buJlbmCwWnYwLAycjdCF25WHb0KgSUwvBdXEbzzDd1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yytFQjhy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA940606A33B
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yytFQjhy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD171F00A07;
	Thu, 12 Nov 2026 02:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450633;
	bh=nqfGVCakpaRvDeNusAVT0YDTR6d31gOByAw/m1ispBw=;
	h=Date:To:From:Subject;
	b=yytFQjhyfA0oEtePJy6xdjGFHIQIquX6dftO1T7/MTg+E81PYTlolXs1UCJfnAOV+
	 A3F8DtlvkXy0Mugyj4QC7rpL+0gNgnliQflyaun2wWr+iupANwi1MfwMlR7hE1p+fc
	 F3uKTfDa1K0j+7KAn7RckjtG9B+VQ9axBQBjLwBo=
Date: Wed, 11 Nov 2026 18:30:32 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-return-handle-from-obj_allocated.patch added to mm-unstable branch
Message-Id: <20261112023033.5CD171F00A07@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: return handle from obj_allocated()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-return-handle-from-obj_allocated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-return-handle-from-obj_allocated.patch

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
Subject: zsmalloc: return handle from obj_allocated()
Date: Wed, 11 Nov 2026 15:46:26 +0900

Allocated handles are valid kernel addresses and never 0, so let
obj_allocated() return the handle directly (or 0 if unallocated) instead
of returning a bool.

No functional change.

Link: https://lore.kernel.org/20261111064707.2568433-4-senozhatsky@chromium.org
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

 mm/zsmalloc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-return-handle-from-obj_allocated
+++ a/mm/zsmalloc.c
@@ -822,8 +822,7 @@ static unsigned long handle_to_obj(unsig
 	return READ_ONCE(*(unsigned long *)handle);
 }
 
-static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
-				 unsigned long *phandle)
+static inline unsigned long obj_allocated(struct zpdesc *zpdesc, void *obj)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -836,11 +835,10 @@ static inline bool obj_allocated(struct
 		handle = *(unsigned long *)obj;
 
 	if (!(handle & OBJ_ALLOCATED_TAG))
-		return false;
+		return 0;
 
 	/* Clear all tags before returning the handle */
-	*phandle = handle & ~OBJ_TAG_MASK;
-	return true;
+	return handle & ~OBJ_TAG_MASK;
 }
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
@@ -1571,7 +1569,8 @@ static unsigned long find_alloced_obj(st
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		if (obj_allocated(zpdesc, addr + offset, &handle))
+		handle = obj_allocated(zpdesc, addr + offset);
+		if (handle)
 			break;
 
 		offset += class->size;
@@ -1824,8 +1823,8 @@ static int zs_page_migrate(struct page *
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
-		if (obj_allocated(zpdesc, addr, &handle)) {
-
+		handle = obj_allocated(zpdesc, addr);
+		if (handle) {
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
 			new_obj = location_to_obj(newzpdesc, obj_idx,
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

