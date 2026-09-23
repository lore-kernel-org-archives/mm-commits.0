Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBBE28373
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202205; cv=none; b=LixUDBkiUgOkr3APVSwvyThewOr9ryITq8BveTOZz3dMTmL2Ujp1UgXm3Xa2Xe/Bmjbh20WyoqKEFsDXa4oDdrCHY4/Kl0jRgFfTeTGy0OD/w+ZZUHq3kRO4QeAqHNlKBrHC9FJG6EpeHZraBwk3PBDiZnprgndqRBiM0g4VdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202205; c=relaxed/simple;
	bh=qKpLmob4UagOZuseyCoq5L9cJaeRh2Wa67J4u0wOCjo=;
	h=Date:To:From:Subject:Message-Id; b=OT8xpKTcA6bpGbvylM4m8TIRsT0FamRaM64tx66IKcbZTvLHzdpQD8GFcQAoxE0YZZ0FjEeS0YTYYJYAJgFZdDb0KttWlz1N6AxXldSXe8mglbbHiQAB/j7iXMAv0AiBNW4ro+1Oy9zWSKBE76jsAOsuhY2nJltr1ewJbVZZVoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=akwUFpYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="akwUFpYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D641F00893;
	Wed, 23 Sep 2026 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202203;
	bh=z5tVWlHAxDnqE3ifE2IxvyO/TvMxDD3u/dUfr6S2bKE=;
	h=Date:To:From:Subject;
	b=akwUFpYhl3tDHbo81O4ze9N0SV547o17KKp59MJgxZiMVAFfizuepBSCCudgmYbcL
	 FWcssxSzstOROEyXhaus58wAD1tx0dsn71EDvZtzeyUkX05SlWYy9Fam2LooKuUpdZ
	 fJet/6Z10+cFVHqoBzMouP0HfEjmtDB4oOr6Qk0A=
Date: Wed, 23 Sep 2026 15:23:23 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch removed from -mm tree
Message-Id: <20260923222323.C5D641F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move memcg switch into the file split helper
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move memcg switch into the file split helper
Date: Tue, 15 Sep 2026 01:14:54 +0800

The xarray node allocations in __folio_freeze_split_file() need to be
charged to the folio's memcg, so move the memcg switch from
__folio_split() into the helper.

The anon split helper and the after-split folio freeing perform no
chargeable allocations, so no memcg handling is left in __folio_split(). 
Rename its out_no_memcg label to out.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-13-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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

 mm/huge_memory.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-memcg-switch-into-the-file-split-helper
+++ a/mm/huge_memory.c
@@ -4139,6 +4139,7 @@ static int __folio_freeze_split_file(str
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4151,9 +4152,18 @@ static int __folio_freeze_split_file(str
 	if (new_order < min_order)
 		return -EINVAL;
 
+	/*
+	 * Switch to folio's memcg as xarray node allocation can happen and
+	 * needs to charge to it.
+	 */
+	memcg = get_mem_cgroup_from_folio(folio);
+	old_memcg = set_active_memcg(memcg);
+
 	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
-	if (!filemap_release_folio(folio, gfp))
-		return -EBUSY;
+	if (!filemap_release_folio(folio, gfp)) {
+		ret = -EBUSY;
+		goto fail_free;
+	}
 
 	mapping_set_update(&xas, mapping);
 
@@ -4289,6 +4299,9 @@ fail_mmap_unlock:
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4320,7 +4333,6 @@ static int __folio_split(struct folio *f
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4330,27 +4342,20 @@ static int __folio_split(struct folio *f
 
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	if (new_order >= old_order) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		goto out_no_memcg;
+		goto out;
 	}
 
-	/*
-	 * switch to folio's memcg as xarray node allocation can happen and
-	 * needs to charge to it.
-	 */
-	memcg = get_mem_cgroup_from_folio(folio);
-	old_memcg = set_active_memcg(memcg);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4377,10 +4382,7 @@ static int __folio_split(struct folio *f
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	/* restore to caller's old_memcg */
-	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
-out_no_memcg:
+out:
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

