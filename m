Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450629;
	b=sGhf/Ez9go0N7CpNlXGXQTzmSI1OppU7vRVo3wZxK9H7Iu7tHMxPzDF+HDo/399BCfL+
	 M87KVyb68B0wSJajjxane1JBkFC2xFCSZqEXVMUFB+hW9uL4FNyQLnpQ1hfvn6tfV8gjG
	 BBcuRpJj0MkQ0nRzq3i5n8SweucjR6aUoQK03am9LrhAOh7PoCejlYe7lgJP0DKSjqXg5
	 onj7LwpTNCA9cVp1YD8qnOXHm454aAH6yJrwwoCBJbcAfut9cDZJVCFQXW3ZloEGkfD5c
	 qZkHhYazB6UCHaYivEA95li1HLK+Fvy0Z1GteBgY4x89RfjmUH9aObx3iz+l9HhyPqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450629;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BqpDAh+D5iqhlPeYfoI97xS4ItEdhZirwHmVb9PrmbU=;
	b=JZoNbSl6vw2zIZxbFfJkHH9KKX9P9YpyDeJXh2D2Yb5lVGOk64tgfvO+PPPI6vIT3dFo
	 yV7om96QKaKBfA8qHJN3yqmzjl/Cb54cU24owUzYlByT22fVSQMAFrqChldIqJKcBCZLm
	 Sz73wfAptr4+ELJLi0WgfUQJSBUf6m1UKJ0VNIx+qB+qTsYEuycc6acwmCj2phYmhj/OC
	 pS+bAr2uNFWgzLHxEG9lz16eP60rcNCmSOcbE6elnNApSDPE21da9Y0RqjUbaHKofVUDB
	 WZos1pF1MRDEM4Fo0xesZ0aTpbjaEtqd2YU89UH5OeHoA9f+ry9wo1rsNdIpggyAwkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zM2CpAFq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0099F606A327
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zM2CpAFq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B71F00A06;
	Thu, 12 Nov 2026 02:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450628;
	bh=BqpDAh+D5iqhlPeYfoI97xS4ItEdhZirwHmVb9PrmbU=;
	h=Date:To:From:Subject;
	b=zM2CpAFqbhDiwBCiBLoDzNT0i2bd/a6eUhFKG0GqvvI2JEndxpLobiSqksrzGN4xx
	 t04L5a48cqe5JdJjqp4ceuapJUaq/mqfdsjkZvdpNs7Q7QMMWYEBQB/puEg3+U82mD
	 DYWWKORv6m081+6C+tAkmzhZB0PM3REnkmZ0ZwSM=
Date: Wed, 11 Nov 2026 18:30:28 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-stale-comment-in-write_incompressible_page.patch added to mm-unstable branch
Message-Id: <20261112023028.861B71F00A06@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: drop stale comment in write_incompressible_page()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-drop-stale-comment-in-write_incompressible_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-stale-comment-in-write_incompressible_page.patch

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
Subject: zram: drop stale comment in write_incompressible_page()
Date: Wed, 11 Nov 2026 15:46:24 +0900

Patch series "zsmalloc: redesign object alloc API", v3.

Both zram and zswap already have per-entry structures that store zsmalloc
handles, so allocating a separate handle_cachep object per stored page is
redundant.  This series embeds struct zs_handle directly into zram and
zswap entries and drops handle_cachep, saving 8 bytes and a slab
alloc/free per stored object (2MB per 1GB of swapped out 4K pages).

It also folds zs_malloc() and zs_obj_write() into zs_store() so we don't
take pool->lock and look up object location again right after allocation.

A simple zram test on a 24-vCPU VM
==================================
165 fewer kernel instructions and 0.7-1.8% fewer kernel cycles per write;
lz4 single writer +2.3% IOPS / -2.6% average latency;
24 writers +0.9-+1.0% IOPS; no regressions.
Memory: 8 bytes less per stored page.


This patch (of 11):

zram doesn't do fast/slow-path handle allocation anymore, so
the comment in write_incompressible_page() is stale.  Drop it.

Link: https://lore.kernel.org/20261111064707.2568433-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20261111064707.2568433-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 drivers/block/zram/zram_drv.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-stale-comment-in-write_incompressible_page
+++ a/drivers/block/zram/zram_drv.c
@@ -2260,11 +2260,6 @@ static int write_incompressible_page(str
 	unsigned long handle;
 	void *src;
 
-	/*
-	 * This function is called from preemptible context so we don't need
-	 * to do optimistic and fallback to pessimistic handle allocation,
-	 * like we do for compressible pages.
-	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
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

