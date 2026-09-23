Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176EC5803BD
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202206; cv=none; b=W9i6r3w6dMSNW7SVGQWFzgk4H4Vm01rc2i2Mr3aj3DekRBBxwWSkBJoT8+x6fwIZ/WtC/1wwmOylRZ+p0ezwRRJgc/GLf/HEoQPwFNPb/8a5iE7ZODDGvmln5u3c+L9PzhRo/M4nDa3o2ZYHtMzO9Ra2IaD/aK1bgvHr87RNEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202206; c=relaxed/simple;
	bh=3PekaLhfWKJp8wFrp40pA5t1fXrrcm8jlsvIvhx+xGg=;
	h=Date:To:From:Subject:Message-Id; b=DJz3X36rWdoVLud2BFIaTaB2I4oMVi/vSEfFRvlxBHaBfGyR0Ku2w39rS5vjC3l643jf0mPzZ4xHqH7jNIwgvQMv4rfDc+V7oCQBRSoDO+1msZA1rJ54HOuMAz2JHnHSQkyvRIE+i8TiVInrwdMVPof4xoVvbzD4LostdAkgfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEX/FU0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEX/FU0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36721F000FF;
	Wed, 23 Sep 2026 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202205;
	bh=uWTdSnE2ruYX2vWts1DWcZdYh6fNgvb1wG3rjxueFZ0=;
	h=Date:To:From:Subject;
	b=VEX/FU0luXPcwd37V5OTalvbrCD+7uR/3DqX1F/qgMdYL9J1P7lBM+N8UHGe9SpE+
	 1BSICqI4G/28DWXLdpmy6FFLOWsbg+MeZSafqv6EL4RQlB/gy6IJZFeLZnqvvKCoGU
	 scyrxveUpygLpGjEEi2Tmo0bDadDdA7yKH2QRxpw=
Date: Wed, 23 Sep 2026 15:23:24 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch removed from -mm tree
Message-Id: <20260923222324.E36721F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
Date: Tue, 15 Sep 2026 01:14:55 +0800

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.  Drop
it.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-14-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

 mm/huge_memory.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper
+++ a/mm/huge_memory.c
@@ -4133,8 +4133,7 @@ out_unlock:
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4228,9 +4227,7 @@ static int __folio_freeze_split_file(str
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4252,8 +4249,7 @@ static int __folio_freeze_split_file(str
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4279,9 +4275,7 @@ static int __folio_freeze_split_file(str
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
@@ -4361,7 +4355,7 @@ static int __folio_split(struct folio *f
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

