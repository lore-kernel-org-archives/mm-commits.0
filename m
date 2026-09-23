Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E773403E1
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202761; cv=none; b=rpMLhZ4MHn+0CQYN612sVwRNFFV6JgdFrpKy//P+VoqYBjac+mfMfkK28dxn/LdH7jaGgT9fMC55RE1uudcj5VYXRkuEZFDv+n8JSqS/VLBwc6s+/D8xoIdDz7hVqFUZMG6UPWRCpmn2m1ylOA6uow/SN+2PuaoiwoYucehdqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202761; c=relaxed/simple;
	bh=NwiyLj5vfhXAdRKG6nC+UDC0JYgBRvgydJ/7CfOQeoI=;
	h=Date:To:From:Subject:Message-Id; b=gNQXszIbE1EFveTf0HKONhK4KTBNm+00upR5nnDc1Hv5iCZLTgNY4wzqKNBTeej4Cj3RLmaht1oqgOrlIpbUhnBgJ5GbyxK8hno6jmrynvlIaS2tW43hifreS5+EZxrm4WiMjTDPt4eeeoGwbA4pDX08h+QqKxcONy8VMLxOhi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtE7xv3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtE7xv3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1791F00893;
	Wed, 23 Sep 2026 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202758;
	bh=F1L9jFxIQZ1pJojyw57A5Z3VOPmYEhvGi73duKsaGY4=;
	h=Date:To:From:Subject;
	b=vtE7xv3hUVnzK/2M+W3HM4qfmIKYFTtYK9Kp7ykpvuFr2Yqt0bPsZVloY2GFSjBZo
	 uZKsLfJwl0n2bSVy1qcPUSyFBtwayPcygxoEBE9dXBUSwj2+jeKWEPnYh+KqcYyCtl
	 iRJrot96e3FHCImXAJWlqzNlGS5N67N2X2DYu6tY=
Date: Wed, 23 Sep 2026 15:32:38 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch added to mm-unstable branch
Message-Id: <20260923223238.6D1791F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move unmap and remap into the split helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch

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
Subject: mm/huge_memory: move unmap and remap into the split helpers
Date: Wed, 23 Sep 2026 23:32:39 +0200

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to be
remapped, so remap_page() is now only called for anon splits and the anon
check in remap_page() is redundant and can be removed.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-8-ba1b4ba72c6f@tencent.com
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

 mm/huge_memory.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-unmap-and-remap-into-the-split-helpers
+++ a/mm/huge_memory.c
@@ -3640,9 +3640,6 @@ static void remap_page(struct folio *fol
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -4016,15 +4013,23 @@ static int __folio_freeze_split_anon(str
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
+	const int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
+	bool need_remap = false;
 	int ret = 0;
 
+	if (folio_mapped(folio)) {
+		need_remap = true;
+		unmap_folio(folio);
+	}
+
 	local_irq_disable();
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
@@ -4073,7 +4078,13 @@ static int __folio_freeze_split_anon(str
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (need_remap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
@@ -4105,6 +4116,8 @@ static int __folio_freeze_split_file(str
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4189,7 +4202,6 @@ static int __folio_freeze_split_file(str
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
@@ -4230,7 +4242,6 @@ static int __folio_split(struct folio *f
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4318,8 +4329,6 @@ static int __folio_split(struct folio *f
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4327,11 +4336,6 @@ static int __folio_split(struct folio *f
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so
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

