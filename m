Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA95803B7
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202208; cv=none; b=Kv7Dhv/TM3KrpSEZAsKFVMDznpQwY9IRWKPxydgEOPjMZGgUTyv/JvkDs772sfbGUSsqD+Aj0iBZFj6378XiZKWH9kY6fXsTW5US88YquUUSy+HEtl004HvNmGq19SjK4dEE9i5HIwN2BOwV0iwRyH4lexEFqpImnx8LCpKL6b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202208; c=relaxed/simple;
	bh=fsXslVHW2WquA20j9KEVa2+ybvHRlzylKu2BbUC2z7o=;
	h=Date:To:From:Subject:Message-Id; b=Cw3D2/tJ5Pzuu/DoAeE+EgkIJ0CJkRHrBkVCBBsW8VyYqiizF1b/DMoEfOGgxMp0a9Oc7mHPAYW2PXedUZyuDDHJs9oKmRZd0hnjvO42yX4/R5KiAnpGZysPBbl3ZLUWI8uF8kaU+5W4FO5BCHxc4bq5k3anVAhAcEsezzuYZcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jBbELjR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jBbELjR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6B41F000FF;
	Wed, 23 Sep 2026 22:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202207;
	bh=v/iDdh6z4vFISi3OE7hFwnIS4vfUhsXmZTZVm4ZhxGc=;
	h=Date:To:From:Subject;
	b=jBbELjR6fi+Ldw3HEh2AxW65FBHhnKFUT+w0+Pv79i+GqKWKRHN6/kB2DTkCDNt4m
	 6fYveyHtNaAYdkGnVoe+j2Px3Vgzq11WDOIQbB8gS8VpbFvJw1Y4pmxeofMjygCaly
	 lJq8hYkiCT35utvr7660uh6qSOXzz0RHI/vKjSmE=
Date: Wed, 23 Sep 2026 15:23:26 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch removed from -mm tree
Message-Id: <20260923222327.2C6B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: count only swap cache refs in anon folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: count only swap cache refs in anon folio split
Date: Tue, 15 Sep 2026 01:14:57 +0800

Only __folio_freeze_split_anon() sees anon folios and swap cache folios
now.  The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop the
anon check so the helper counts what its name says.  The file split helper
now uses folio_nr_pages() directly.

No feature change.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-16-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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

 mm/huge_memory.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split
+++ a/mm/huge_memory.c
@@ -3993,10 +3993,10 @@ int folio_check_splittable(struct folio
 	return 0;
 }
 
-/* Number of folio references from the pagecache or the swapcache. */
-static unsigned int folio_cache_ref_count(const struct folio *folio)
+/* Number of folio references from the swapcache. */
+static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 {
-	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+	if (!folio_test_swapcache(folio))
 		return 0;
 	return folio_nr_pages(folio);
 }
@@ -4064,7 +4064,7 @@ static int __folio_freeze_split_anon(str
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4101,7 +4101,7 @@ static int __folio_freeze_split_anon(str
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4109,7 +4109,7 @@ static int __folio_freeze_split_anon(str
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4138,6 +4138,7 @@ static int __folio_freeze_split_file(str
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4208,22 +4209,16 @@ static int __folio_freeze_split_file(str
 		goto fail;
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, old_nr_pages + 1)) {
 		ret = -EAGAIN;
 		goto fail;
 	}
 
-	if (folio_test_pmd_mappable(folio) &&
-	    new_order < HPAGE_PMD_ORDER) {
-		int nr = folio_nr_pages(folio);
-
-		if (folio_test_swapbacked(folio)) {
-			lruvec_stat_mod_folio(folio,
-					NR_SHMEM_THPS, -nr);
-		} else {
-			lruvec_stat_mod_folio(folio,
-					NR_FILE_THPS, -nr);
-		}
+	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -4247,7 +4242,7 @@ static int __folio_freeze_split_file(str
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4274,7 +4269,7 @@ static int __folio_freeze_split_file(str
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

