Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D577E3BD638
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896599; cv=none; b=AdEP4PtRsArQwzEQm6NDEYzpryf8My3zGuxdBDxjGE2FlOFCZAWD7osLQ2dH5WUoLqPqqCWZIpFZGESHw6afoJu+sXv+8Ef5DfSfjlQrujIxZwHc25u1nxe1FPOb/d7FKlJKN2AfsNw+bWJQGSD0a3reCPMNmLHmzCbuIeyQP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896599; c=relaxed/simple;
	bh=lT0A8J2wNePfrmT3Om8KAdID0oyZkgDZfG0xhfimwo0=;
	h=Date:To:From:Subject:Message-Id; b=nFv/LDearTFrzo1w4h55LxqIcEe09cPtBUAGCinUDmxESrtqkbcjjqpzAdxpXk4+96+NRnc0jV+QS8PVcy2HAVU/Dk97ojc1iuVqjuCAWijRIwkfiqsSIo5+b1PhLOmBCsi26S5EFnkHic1Pj4fTWdd6bEbF0TJRUe+IqM+LIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=as32KJYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="as32KJYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FE11F000E9;
	Wed,  5 Aug 2026 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896597;
	bh=d5HNzpJLtBKiOkMicq7d80MAOKp5AXtqcy27rpg/Sxw=;
	h=Date:To:From:Subject;
	b=as32KJYNQKyLtBOlsvQdjMAHXlsDRW8OedAXkGtuebbCc4TBCMJ0qdzeE7xvBPfas
	 F3+HjeL5DZZi48MrFjikL8x18s0Fv3vLhtsotEvZ2MGn/6HpTeeY7QcLbua6kk1Gts
	 Jr7h0VKct64+6eIqi+DoDFlppoAoKVi8jKiilZnE=
Date: Tue, 04 Aug 2026 19:23:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch removed from -mm tree
Message-Id: <20260805022317.62FE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
has been removed from the -mm tree.  Its filename was
     mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
Date: Thu, 2 Jul 2026 07:59:52 +0800

Patch series "mm: drop redundant lru_add_drain in anon folio reuse paths",
v3.

We are doing a large number of redundant lru_add_drain() calls in both
wp_can_reuse_anon_folio() and do_swap_page(), leading to LRU lock
contention and unnecessary overhead.

In wp_can_reuse_anon_folio(), we can check the refcount against the
lru_cache before deciding to drain.  In do_swap_page(), the drain is now
entirely redundant after Kairui's work to route SYNC I/O through the
swapcache in the same way as ASYNC I/O.

Build the kernel within a 1 GB memcg using 20 threads with zRAM swap.  The
number of lru_add_drain() calls is reduced from 276,278 to 226,318, a
reduction of about 18%.

Build the kernel within an 800 MB memcg using 20 threads with zRAM swap. 
The number of lru_add_drain() calls is reduced from 778,950 to 541,149, a
reduction of 30.5%.


This patch (of 4):

There is a case where `folio_ref_count(folio) == 3` and
`!folio_test_swapcache(folio)`. In that case, both
`folio_ref_count(folio) > 3` and
`folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
false, causing an unnecessary local LRU drain.

During an Ubuntu boot, I observed over 5,000 redundant local LRU drains. 
For a kernel build with a minimal configuration, I observed more than
20,000 redundant drains.

Fix this by checking against: `1 + in_swapcache + in_lrucache` instead of
hardcoding `folio_ref_count(folio) > 3`.

[baohua@kernel.org: rename in_lru_cache to maybe_in_lru_cache]
  Link: https://lore.kernel.org/20260708145718.82690-1-baohua@kernel.org
Link: https://lore.kernel.org/20260701235955.36126-1-baohua@kernel.org
Link: https://lore.kernel.org/20260701235955.36126-2-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio
+++ a/mm/memory.c
@@ -4174,6 +4174,9 @@ static bool __wp_can_reuse_large_anon_fo
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
+	const bool maybe_in_lru_cache = !folio_test_lru(folio);
+	const bool in_swapcache = folio_test_swapcache(folio);
+
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
 		return __wp_can_reuse_large_anon_folio(folio, vma);
 
@@ -4184,15 +4187,16 @@ static bool wp_can_reuse_anon_folio(stru
 	 *
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
-	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
+	if (folio_test_ksm(folio) ||
+	    folio_ref_count(folio) > 1 + maybe_in_lru_cache + in_swapcache)
 		return false;
-	if (!folio_test_lru(folio))
+	if (maybe_in_lru_cache)
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
 		 */
 		lru_add_drain();
-	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
+	if (folio_ref_count(folio) > 1 + in_swapcache)
 		return false;
 	if (!folio_trylock(folio))
 		return false;
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

