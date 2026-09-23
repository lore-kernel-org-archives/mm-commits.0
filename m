Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DF328373
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202193; cv=none; b=MbrzIitK+Tqx88iiU62k4d/sSIdWsRLRD14DRaZCUz+pZNQm0KJcVG95dCL2TUETP1CqrsFXeeCNxrntPbqrgKDCW/RfKh2QmswRLUDLYUzU3gyksjmVIRlZUKLZX27y9ZNrOenNU/DwYZtdDlEqli/185DU0omgnVdelzLElsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202193; c=relaxed/simple;
	bh=mL3SHUEcPjcXSq5zHosCtwmMobMJPvY4QIusEEY3N7Q=;
	h=Date:To:From:Subject:Message-Id; b=N2Ala/3nNUy2JBEMH3qsFnzD9wGEe8ncQIoFlQXc44JPk/A51NwU9uFbp5slj/NzvrfXXvj/A6dzMHgCxOyBf0ctgVwDIu/qMc0zi0DttGXK5UJou6bmMsdL8OWShWAxJGtFl+UHqv5Oz8wJVzQQ1pk2RA2O12P8zX5VRwOwNIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wp1Hy4e4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wp1Hy4e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680291F000FF;
	Wed, 23 Sep 2026 22:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202190;
	bh=lGu7iaUTwIu4ApgmlokzFOIaC/kn965Lq2LJEChVEfg=;
	h=Date:To:From:Subject;
	b=wp1Hy4e4phiH9dT6t9S1NiC2AeDphvX7dKQS40Rr8CqMfTs255K1uPGgV6mAVr7Ag
	 UQsOh802lCLmnZzRqbMJ2k0UTaM4rMRcOpuq5ql/elyT2gXFckZ18oJBZrODrW1mPE
	 xatYNstkZI0rUsJBBvJOkmBdmc4YMbwgxBjR2rPM=
Date: Wed, 23 Sep 2026 15:23:09 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch removed from -mm tree
Message-Id: <20260923222310.680291F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix off-by-one in swap cache replace sanity check
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap: fix off-by-one in swap cache replace sanity check
Date: Tue, 15 Sep 2026 01:14:42 +0800

Patch series "mm/huge_memory: clean up and decouple the anon and file
split helpers", v5.

The folio split path handles anon, page cache and swap cache folios in one
routine.  That mixing is what makes the swap cache split restrictions hard
to lift and to review.  We now support uniform split to order-0 only, and
no mappingless swap cache folios.  And it has left a fair number of dead
or redundant checks behind.

This series prepares for lifting those restrictions by cleaning up the
code first: split the routine into an anon and a file helper, and keep all
swap cache handling in the anon helper.  The file helper never sees a swap
cache folio, folio_check_splittable() rejects them up front.

Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
splitting (patch 12), this is a pure cleanup.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 over 600
runs on the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on the
same x86-64 box (interleaved runs across alternating reboots.  135 split
calls per run, 600 test runs):

Before: 68.52 us, stddev: 1.58
After:  67.38 us, stddev: 1.33

The patched kernel is slightly faster.  The stack usage and object size
change as the config and compiler change, but in general the stack usage
is reduced and object size is basically unchanged.


This patch (of 17):

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates the old
folio's range with "while (ci_off++ < ci_end)", so the loop body runs on
the already-incremented offset: the first entry is skipped and one entry
past the range is read.  For a folio split that entry belongs to the first
after-split folio and was just repointed by the replacement loop above, so
the check would warn spuriously whenever sub-folio orders differ from the
head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com
Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-1-39878b37dfb0@tencent.com
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check
+++ a/mm/swap_state.c
@@ -396,8 +396,9 @@ void __swap_cache_replace_folio(struct s
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

