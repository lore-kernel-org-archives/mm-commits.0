Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A030A57F726
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202201; cv=none; b=mSOGy7nEFTVYtTCAQzQBAaXqNSXNBrBQoyVuDSlOZ3ncrkOmOUUK68iAhOI8/vEHuhrN3buSQR6dZDiGmxSlngrDPp/Z2DavD1T29RgOMlqkzXl7gNW56qB2E3tmL3dpzLls3xk7mtzveADhdTVw6X6ziRNwD52azZ95xkkvz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202201; c=relaxed/simple;
	bh=Gd6aer2FbDUom4Wp+92AogIzgr/+HnmrJhEOHmlL/0U=;
	h=Date:To:From:Subject:Message-Id; b=NUflzWkSCygHM8wN7IVi8Y0Zz3wbBg1O8w9nfeo3nVJ8goQL5WWdbn/dMyNqj6G06wl+YNkydl7VTrYM6eGTvhQob57sAymvXXeoa0zPpza9zumHPwC4l2DAP6t+mheMRRaIJsID97oCsNUT9eWnmgPREwcVPrSh1qy1vPIkhLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mTB7U4FQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mTB7U4FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777091F000FF;
	Wed, 23 Sep 2026 22:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202200;
	bh=rWlz9FllOE2H47YcqNIIpVJFSdWbg7WqEs5em2L2v2w=;
	h=Date:To:From:Subject;
	b=mTB7U4FQ2cBZIQNjC/oBdc/7hvuG7iFst3rSdbmRPZzDcQl+bEOI8xQTFuXMk4eH2
	 GKq/m+p5BN3JPKnI4FWWWquBm3JjTmcilfmpFhAHipoyUHwjkQCeSYJKVMNspVqCJ6
	 3EvdguJlcb87AsSpxGVJDjIJpASggkB0uDaK1s3U=
Date: Wed, 23 Sep 2026 15:23:20 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch removed from -mm tree
Message-Id: <20260923222320.777091F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move the racy refcount check into unmap_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move the racy refcount check into unmap_folio()
Date: Tue, 15 Sep 2026 01:14:51 +0800

The check only exists to avoid the expensive PMD-splitting unmap of a
folio that cannot be split anyway.  Move it from __folio_split() into
unmap_folio(), right before the PMD split, so both the anon and file split
helpers get the early check without repeating it.

unmap_folio() now returns -EAGAIN if the check fails and the split helpers
propagate the error.  folio_split_unmapped() drops its own copy of the
check: it works on already unmapped folios and the definitive
folio_ref_freeze() in __folio_freeze_split_anon() still catches unexpected
references.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com
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

 mm/huge_memory.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio
+++ a/mm/huge_memory.c
@@ -3538,13 +3538,17 @@ void vma_adjust_trans_huge(struct vm_are
 		split_huge_pmd_if_needed(next, end);
 }
 
-static void unmap_folio(struct folio *folio)
+static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
 		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	/* Racy check if we can split the page, before we split PMDs */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
+		return -EAGAIN;
+
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
@@ -3559,6 +3563,8 @@ static void unmap_folio(struct folio *fo
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
 
 	try_to_unmap_flush();
+
+	return 0;
 }
 
 static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
@@ -4029,7 +4035,9 @@ static int __folio_freeze_split_anon(str
 
 	if (folio_mapped(folio)) {
 		need_remap = true;
-		unmap_folio(folio);
+		ret = unmap_folio(folio);
+		if (ret)
+			return ret;
 	}
 
 	local_irq_disable();
@@ -4123,7 +4131,9 @@ static int __folio_freeze_split_file(str
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	unmap_folio(folio);
+	ret = unmap_folio(folio);
+	if (ret)
+		return ret;
 
 	xas_lock_irq(xas);
 
@@ -4331,15 +4341,6 @@ static int __folio_split(struct folio *f
 		i_mmap_lock_read(mapping);
 	}
 
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4378,7 +4379,6 @@ static int __folio_split(struct folio *f
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
 	if (anon_vma) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
@@ -4426,9 +4426,6 @@ int folio_split_unmapped(struct folio *f
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

