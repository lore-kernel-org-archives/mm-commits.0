Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657467;
	b=sBuYayQbVPkNKTx/FVrtJZ6PsAzdwjwe1vdicDVSpsu2Y3C3vXNwjfzPC5wzccLy3ooM
	 qkLNfn3zGu8sSyhrc0haOXNTpFCE3FnixFtLWVrBQK/SKFDAYqx4ChBGaTIVwr6OMEnMu
	 WDte44dOzSM8usBuSfV4wx5AkN1ciBHG9ly3pGpSrqPL6p7hMR6p6JZbY01uiMSU0+Dop
	 pBdXxo9bwacj/IcbZPMBolUVwjf57RGTeveW3xY7YJHUgnRNeb9Vzsuwahw7ONAnuC012
	 cGunD8FIfh/7FNfE8kQb1i+xwPWlYtTv09+0LG6Oykrf82tAGRaplZdyIRmp6V3HqKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657467;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KR6zQxxHdtJmOrqkhnFwnQayY24In2h9f/EFqcmkqmU=;
	b=Efugl1F6BRzkqgLJy8g3uJZQIuGm3gQaWYPDY6PcOuLKRrw7MUFGJKehFgrHRXUsuI/+
	 iaIr0lB536f3zbF0egWdH7awI4dYeO0P3UmwN7EoXYXHqXDFpazYLjDfpYDxCJ3d/M86J
	 jPujfOI3xH/l/X72mqUCbHVVh/MoGssC9Xcj6WcABXGiTPLvZ70EwJmPrL1GaGbxrJGj3
	 p54/zjLyaf/bGrXDDrgOgN3HOPI2fs7Kd/w5tAWjDZmgLXOsZDXzDfVbIKP7m30ZqMqEe
	 pbXIgPuDJnHyBy3rhVG6FvujFfKo1XOj/ZxMtY9q/mRCZyH8fZ9AN1LyDBaU4YK9C6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AH6uyvY9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DF2606A326
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AH6uyvY9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199101F00A17;
	Mon,  2 Nov 2026 22:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793657467;
	bh=KR6zQxxHdtJmOrqkhnFwnQayY24In2h9f/EFqcmkqmU=;
	h=Date:To:From:Subject;
	b=AH6uyvY9bPoo8+9dFj23jV4e850rbOlyiTCm9dJ7g3oE7t9+as7fnDg+vOdVObjRm
	 N8u66S8bq7ix+WUcdfU6sryILJto4mp+gMhetyVmoPnkHgL3GuXdNYBqWOAZJW5eMG
	 8steW/8Qnoq13wEAIq4HXHt/GpbqkG1pxoiAYIuY=
Date: Mon, 02 Nov 2026 14:11:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,stable+noautosel@kernel.org,mhocko@suse.com,
	hannes@cmpxchg.org,dev.jain@arm.com,brendan.jackman@linux.dev,
	zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch added to mm-new branch
Message-Id: <20261102221107.199101F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/compaction: annotate data race for zone->free_area[order].nr_free
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/compaction: annotate data race for zone->free_area[order].nr_free
Date: Mon,  2 Nov 2026 16:19:18 +0800

KCSAN reports a data-race on nr_free which also exists on mainline:

  BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589

  race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
   fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
   isolate_freepages+0x52/0x650 mm/compaction.c:1722
   compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
   compaction_alloc+0x21/0x30 mm/compaction.c:1880
   migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
   migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
   migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
   migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
   compact_zone+0x539/0x10b0 mm/compaction.c:2660
   compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
   try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
   __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
   __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
   __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
   alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
   alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
   io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
   io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
   io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
   io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
   io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
   __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
   __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
   __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
   x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
   do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
   entry_SYSCALL_64_after_hwframe+0x76/0xe0

  value changed: 0x00000000000002f4 -> 0x00000000000002f5

nr_free is only updated with zone->lock held, but fast_isolate_freepages()
and fast_find_migrateblock() read it locklessly to skip an order that has
no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
instrumented and the report is of unknown origin.

The race is benign: a stale zero only skips the order for this round, and
a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
lock.  Annotate both reads with data_race(), following commit af1c31acc853
("mm/vmstat: annotate data race for zone->free_area[order].nr_free"), and
say at each site why both stale directions are harmless.

No functional change intended.

Link: https://lore.kernel.org/20261102081919.80625-1-hui.zhu@linux.dev
Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable+noautosel@kernel.org> # KCSAN annotation only, no functional change
---

 mm/compaction.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-annotate-data-race-for-zone-free_areanr_free
+++ a/mm/compaction.c
@@ -1601,7 +1601,12 @@ static void fast_isolate_freepages(struc
 		unsigned int order_scanned = 0;
 		unsigned long high_pfn = 0;
 
-		if (!area->nr_free)
+		/*
+		 * Opportunistic lockless check.  A false non-zero is fine, we
+		 * inspect the freelist under the lock.  A false zero is fine,
+		 * we just miss this order.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
@@ -2031,7 +2036,12 @@ static unsigned long fast_find_migratebl
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		/*
+		 * Opportunistic lockless check.  A false non-zero is fine, we
+		 * inspect the freelist under the lock.  A false zero is fine,
+		 * we just miss this order.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch
mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch

