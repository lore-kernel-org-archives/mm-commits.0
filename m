Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135F28373
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202209; cv=none; b=j7sIjZsU0KuqWQIKEwjT0QhOyNKKM7VnJ8hjmctbaxkXbbm1ngcZsVcbBFe/vXtyzrieZDUT/edBGueiZqOPHPlpRcFMMPaKGBNaJN1VXDJw+UVwYZ7AV1g5RY7abP/q/12BadAzc0YrfvwDIZBTZGryKiAw80c+j3ElquLYJOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202209; c=relaxed/simple;
	bh=c6/0/tqDyTJTVVtIjyZHmInviM2w4H9YkFg+7Q+feGw=;
	h=Date:To:From:Subject:Message-Id; b=rp9IZfbnziYAElOgJHmaIvfMAEQrAI7am0U3xh3bnHzIAtobUlGf4Tg68Hf6tXrXDg6u8ZkiNrJFxwv74OaMD0HqSvcrW6UlLOJxH1/d95v5NPVaT7X+N1FecHs4Y5te2luMtxLmljmF8MlqSRGpKJTGe8vaIwhWmctou2LiYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9JxA7FH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9JxA7FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491441F00893;
	Wed, 23 Sep 2026 22:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202208;
	bh=M9UKafX6HOGGdyTyWKCZdkSBjLihkljReTnbsftqYI4=;
	h=Date:To:From:Subject;
	b=M9JxA7FHmAwSVAlfuBZJHTXBzzsds4O6ica6OlixejBjsAf9o6GMAmYtp8LyJaVvu
	 PwiX4wN8a/w54pjYXqxW4S9pihKI3VhJC/hR92SxoZRFkj3phmPmdvF/WQg1EcXygm
	 31PPpowZxereg+duT7YWmvq7LcWcfv7FQRKQcebI=
Date: Wed, 23 Sep 2026 15:23:27 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch removed from -mm tree
Message-Id: <20260923222328.491441F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
Date: Tue, 15 Sep 2026 01:14:58 +0800

The mapping parameter only served as a non-NULL check to detect whether
page cache entries need updating.  The xa_state pointer conveys exactly
the same information: the anon split helper passes NULL and the file split
helper passes &xas, which is non-NULL iff the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-17-39878b37dfb0@tencent.com
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

 mm/huge_memory.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio
+++ a/mm/huge_memory.c
@@ -3829,7 +3829,6 @@ static void __split_folio_to_order(struc
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3862,7 +3861,7 @@ static void __split_folio_to_order(struc
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3886,7 +3885,7 @@ static int __split_frozen_folio(struct f
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4086,8 +4085,7 @@ static int __folio_freeze_split_anon(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4223,8 +4221,7 @@ static int __folio_freeze_split_file(str
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

