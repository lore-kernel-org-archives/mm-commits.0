Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D68469845
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202775; cv=none; b=Y2IKv0WQkv2/vD2uP68IX2eyQ0TTN3aqKGL8UcIYyr1yz3TAKxA8ZTAyNwMcgQZd13SRSFxkPD8D4R1OJ4q0Fj75VSibjympdUDvhgDjjJJ2PBHoePU/WShIVTn7RJnMuYUjA5ojQfK1ZOeJ4DuKCrlO7/7TxI5cKRsRW/jBwUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202775; c=relaxed/simple;
	bh=fF9p8pcfSvWK+wsNiT3sXcxdpiVXd5sfZ7Ou8HvXAQ8=;
	h=Date:To:From:Subject:Message-Id; b=P4I2hlvtS6kQrPM0BjCgicHGDUg4w8QX+DqTUuKhQE0y8H0aueTu92LfvgbXKBIGYLiedW8FVoQ3vxgFCUOvXUqJVfUYNGiEwKT7b82w71J4ecs3nsh2gMqy9D5p8FfmbmZgMKGiPI4p91aSLYclGrz6hqLA7VtkdYwdb9lOlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2JyoTfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2JyoTfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DAC1F000FF;
	Wed, 23 Sep 2026 22:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202774;
	bh=aUkir04YoNgBeKr5kV6i2BIRlZbGf5LabVrhQ6dYpbE=;
	h=Date:To:From:Subject;
	b=t2JyoTfkAjykdJNln9HuENSg4fZQLmgP4wyqPB9mfwuh4fkbC4Wz5IgDza26ew4wr
	 wHzVPOHklPaAit4P0z8uMftQBhiKzvYBn6PM2UVsasxW5tBPtxGg9T1VfUp7V1ZleP
	 gtM0LR6x03Q6hEpSvUgW7rv/Ypc7ZAZruj7CkZPk=
Date: Wed, 23 Sep 2026 15:32:53 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch added to mm-unstable branch
Message-Id: <20260923223253.E8DAC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: count only swap cache refs in anon folio split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch

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
Subject: mm/huge_memory: count only swap cache refs in anon folio split
Date: Wed, 23 Sep 2026 23:32:47 +0200

Only __folio_freeze_split_anon() sees anon folios and swap cache folios
now.  The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop the
anon check so the helper counts what its name says.  The file split helper
now uses folio_nr_pages() directly.

No feature change.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-16-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split
+++ a/mm/huge_memory.c
@@ -3997,10 +3997,10 @@ int folio_check_splittable(struct folio
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
@@ -4067,7 +4067,7 @@ static int __folio_freeze_split_anon(str
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4104,7 +4104,7 @@ static int __folio_freeze_split_anon(str
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4112,7 +4112,7 @@ static int __folio_freeze_split_anon(str
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4138,6 +4138,7 @@ static int __folio_freeze_split_file(str
 		unsigned int new_order, struct page *split_at,
 		struct list_head *list, enum split_type split_type)
 {
+	const long old_nr_pages = folio_nr_pages(folio);
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
@@ -4211,22 +4212,16 @@ static int __folio_freeze_split_file(str
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
@@ -4250,7 +4245,7 @@ static int __folio_freeze_split_file(str
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4277,7 +4272,7 @@ static int __folio_freeze_split_file(str
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
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

