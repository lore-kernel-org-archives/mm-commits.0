Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4D5803B4
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202197; cv=none; b=VNTb6NhXvD4BQx9PCrZ9ejUBU12j6I2ezUIHG3E3clP/1vIg1X9xguuqCjRWo8K1Sc0VXpiUEgcH5tBk2R1P+8rjCbpFM3PSTemFyAFO4FV3tAvz3ueMQ+Jdz2O3130QPQZAKkFIGpNeRS3b8lqCxhNAkjDvgiTH15ZXqRa7px4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202197; c=relaxed/simple;
	bh=RSpYZOBvJsa+hNPLFL4qz+RJgFs3HRt7Y0fLXoGswDg=;
	h=Date:To:From:Subject:Message-Id; b=SPECl3g/0BLwaoJbSgNNCjo86zQLAfq/V954mvojIa14+B7rc9yqXWIjcbWo+odskoZVAWfq2Ibe8yHH0vGdXUcqEMweBNJBGX6v845Dnqb2Zvq1zIGqFB5635Ox7jKhAWK7JHF+3vPIyUn2f03oS6EWDrABa8FhULG31pppInU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uw3DVpTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uw3DVpTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF62D1F000FF;
	Wed, 23 Sep 2026 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202196;
	bh=nUeNUTMKTLBcbYVBSaJO330mPDL+M0MCXxHywrt07Xg=;
	h=Date:To:From:Subject;
	b=Uw3DVpTY5AKqSGhNsnI1xe1b1XsPzMDVSNZ9Ta5zCe/HMUo9zVaEee0JE/8PUhVRO
	 rD5bVcloTEPqVeqxkoxbXEjCdz9XI+G459hK1aLf+uDg5OtbnQFFDM2dAELbVFs2hp
	 ILycQF2r4G4Qj5kn5hNFCvvqInqyScmjvOmuBUz8=
Date: Wed, 23 Sep 2026 15:23:15 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch removed from -mm tree
Message-Id: <20260923222315.EF62D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: consolidate irq and locking for folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: consolidate irq and locking for folio split
Date: Tue, 15 Sep 2026 01:14:47 +0800

Let each split helper handle its own locking instead of relying on the
caller, so both helpers manage their own irq and locking state.  This lets
__folio_split() drop its local irq handling and fail label, preparing for
further cleanup.

The file path now uses xas_lock_irq() instead of local_irq_disable() with
xas_lock().  The two are equivalent on non-RT, and TRANSPARENT_HUGEPAGE
cannot be enabled on RT anyway.  This conversion also buys consistency:
every other place in mm/ that freezes a folio while it is still reachable
through the page cache already takes the lock this way.  This was actually
the last plain xas_lock() on mapping->i_pages left in mm.  If we are going
to support RT, spinning on frozen folio refs could be a problem, but it
already exists in many places and should be fixed generically.

The anon helper keeps a single local_irq_disable() as before, because it
has to cover several plain spinlocks at once.

The dropped xas_reset() was a no-op as the xa_state is not walked before
the xas_load() under the lock.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-6-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
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

 mm/huge_memory.c |   58 ++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-consolidate-irq-and-locking-for-folio-split
+++ a/mm/huge_memory.c
@@ -4020,8 +4020,12 @@ static int __folio_freeze_split_anon(str
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+	local_irq_disable();
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		local_irq_enable();
 		return -EAGAIN;
+	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
 	folio_unqueue_deferred_split(folio);
@@ -4069,6 +4073,7 @@ static int __folio_freeze_split_anon(str
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4087,8 +4092,21 @@ static int __folio_freeze_split_file(str
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
-		return -EAGAIN;
+	xas_lock_irq(xas);
+
+	/*
+	 * Check if the folio is present in page cache.
+	 * We assume all tail are present too, if folio is there.
+	 */
+	if (xas_load(xas) != folio) {
+		ret = -EAGAIN;
+		goto fail;
+	}
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		ret = -EAGAIN;
+		goto fail;
+	}
 
 	if (folio_test_pmd_mappable(folio) &&
 	    new_order < HPAGE_PMD_ORDER) {
@@ -4160,6 +4178,8 @@ static int __folio_freeze_split_file(str
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4299,32 +4319,13 @@ static int __folio_split(struct folio *f
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (is_anon) {
+	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
-	} else {
-		/*
-		 * Check if the folio is present in page cache.
-		 * We assume all tail are present too, if folio is there.
-		 */
-		xas_lock(&xas);
-		xas_reset(&xas);
-		if (xas_load(&xas) != folio) {
-			ret = -EAGAIN;
-			goto fail;
-		}
+	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type, end,
 						&nr_shmem_dropped);
-	}
-
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
 
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4408,8 +4409,6 @@ out_no_memcg:
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4418,11 +4417,8 @@ int folio_split_unmapped(struct folio *f
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
-					false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_anon(folio, new_order, &folio->page,
+					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
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

