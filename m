Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D295A3403E1
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202750; cv=none; b=BJjBYDKUMtOutATygKlnlIxy734gzL79gf1DmRW2D1sEBpudHeIkBNWNGmIb3dNElU6NiGpbLO7cnYYWxs7FuoVnR2C7080sQgbu2YhuW4nEibY6YExYdEov4OtQLBPeDsKHyvJ2I7If8wKtB9v6xBoHdLP/HH7lvwtlcsF/Yjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202750; c=relaxed/simple;
	bh=JYaeSmOrz60kreIOlwy5rKM3sfLDxuUGESTeDzBVoeI=;
	h=Date:To:From:Subject:Message-Id; b=aPXw3ZPtyomrep1s3ngVs7egIaZmpQ9SS7VMDr0KBYJa5+ZFpwCQ5n/OoqDJIoxml8pjXarTz/yM1511yrsxtQGk4aJg3FhqrMUJvHDyWVxEDgNwB8G3jP2xsN8/XTOAKDwUeHbbXArxkpr/w2WrUQlL0AMHQS618UMbZehDc1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JwCAXG/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JwCAXG/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628611F000FF;
	Wed, 23 Sep 2026 22:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202746;
	bh=u5oOqZkKAOcPhDLE/QKitcgdsaPKCahEzEWT060dW1A=;
	h=Date:To:From:Subject;
	b=JwCAXG/vivxGAVJbD4fLJ3H0lcQOzQ0ec1UWoJI/t6cwarVqBbzrXycpTfLPVg5p6
	 aA1b0T4vXspjTno6kAJlelOO5GY737eyEo4D+/LFsc8jw0jWVz36lUPc6q8f5u9xrb
	 Q95KBWGNGb8ES0FQyG7EvPtMX3/iVFVXrC46NbXQ=
Date: Wed, 23 Sep 2026 15:32:25 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch added to mm-unstable branch
Message-Id: <20260923223226.628611F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
Date: Wed, 23 Sep 2026 23:32:33 +0200

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

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-2-ba1b4ba72c6f@tencent.com
Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
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
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
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

