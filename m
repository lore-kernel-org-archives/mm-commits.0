Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8AD3B7742
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202193; cv=none; b=RV8bQ/RcJosGYfcxmzLruPVOUfy5ePW/8/R8gCQXGvlI+sbab4VAMyikMJk+Ny+N3LVlSD0arVNAG7GnyF/CGVjPzf8f1d1qTEIzPRsJnAwRo9BrQxIg5lLNJ0rWsXgiOOSEssX7Daoj2eXaj9t2cIum1jXb/cC19paKvgGopJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202193; c=relaxed/simple;
	bh=WGuakq4rLtM79q3TgVnetgfz7tia48xpl/8ZaYy9Slc=;
	h=Date:To:From:Subject:Message-Id; b=uSZqcEwlO6bgE4e6ittPMMaDxtKW3+OzoHpFxYW/vS+9yiktvSzYF+0usVuK0JYHgsoaztRaN2nBjNL9bX64AUZB6hBcMYMHRybvKco2JwkmpxqkjtJGb6Y1UHe25bcG5LyB2uSgTGhQzBU/AssxtZzhgICrenUCh961FKRrYaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gt8D/knL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gt8D/knL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746901F00893;
	Wed, 23 Sep 2026 22:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202191;
	bh=TzFvT5sb9h58Nb0yCZbVsyd7J5n9U+9Poxfsgfu05JM=;
	h=Date:To:From:Subject;
	b=gt8D/knLIZqEZdsvT4xxmuw25xz0Typlj+0ItIvqHe8cXN45wXYB03SHUQ+pPItCq
	 gS5wp6ZuLT9X5uRS9U6eMnphhngl7tGYqX0eEUxxBLFAYAbFC/hiEYBlU52pEVNi0C
	 IDolVgJDaaG/03kzXNeedmWKoEJcK7U6ip+oo0eY=
Date: Wed, 23 Sep 2026 15:23:11 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch removed from -mm tree
Message-Id: <20260923222311.746901F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
Date: Tue, 15 Sep 2026 01:14:43 +0800

A folio in the swap cache cannot be split if it has a mapping (shmem). 
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen and
the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented.  It rejects
the split and returns -EINVAL without unfreezing the folio or restoring
the counters.

That error path is buggy, if it is ever taken.  It leaves the folio frozen
and stuck, skews the counters, and fires the VM_WARN_ON_ONCE_FOLIO for a
state that is actually legitimate.

Check for this case up front in folio_check_splittable and return -EBUSY
before any state is modified, so the split routine always backs out
cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining about.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-2-39878b37dfb0@tencent.com
Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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

 mm/huge_memory.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping
+++ a/mm/huge_memory.c
@@ -3933,6 +3933,9 @@ static int __split_unmapped_folio(struct
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3941,11 +3944,11 @@ int folio_check_splittable(struct folio
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3956,7 +3959,7 @@ int folio_check_splittable(struct folio
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -3965,6 +3968,15 @@ int folio_check_splittable(struct folio
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -4037,14 +4049,8 @@ static int __folio_freeze_and_split_unma
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
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

