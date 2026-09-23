Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C984D4349AA
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202768; cv=none; b=AtZwGZhmZxsybF3BGc9GB7w2bkOSfHjt0ZBYGdlKIe+e3QDrUCletyAiBJ/xCrXmvOz7n5wRau1mHg71cAZGXWb3Zg4mDiTN8x8mb0kZq9eLoYeTHjqbV5tuQEpzUU5lTaautBxIJ6rHw9RB4cXbt29tdQa1fTjea0/lws6q8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202768; c=relaxed/simple;
	bh=isVmqduPQt7I5nojrmXUGBqSf7u0mX3rPDiBvH1ZGQU=;
	h=Date:To:From:Subject:Message-Id; b=Dvvc05QCQKE7EmAlLLOSj4S/OxlQpcUgGRLkogsGMA/iPUOPtrUQYTG8FED0ldN+jwdX9KNvSZ2D/PzeIGHZgKi4zHYaZ6OZ0PftAH40NBScjph09w1A3X1rw++xki88BfVYV5ocH2aEU2K2DlzCXKCpffbFAgSsH8c5EXZoABA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJxiYp9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJxiYp9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C041F000FF;
	Wed, 23 Sep 2026 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202766;
	bh=64d0OOkrQiMpLbIJe3eNvXuf3Q2GDSzrDis/w6OEY5U=;
	h=Date:To:From:Subject;
	b=lJxiYp9vAUeuDX/VUYQ5IRSYVZQxcf8nTklF2D3F1/bwf1Wfz919YInJuLJsa1KkI
	 d9AEgRxiCUNyhZMooJdhgGmrYmQgugEGWev8kpBwGdAazUKSuVALk7wqokzawh7a8z
	 Y+E6nMEe9r2zkdbI/wcze+9SsPzDqbhXeY/uh3r8=
Date: Wed, 23 Sep 2026 15:32:45 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch added to mm-unstable branch
Message-Id: <20260923223246.35C041F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move anon_vma handling into the anon split helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch

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
Subject: mm/huge_memory: move anon_vma handling into the anon split helper
Date: Wed, 23 Sep 2026 23:32:43 +0200

Only anon split needs the anon_vma, and it only needs it to unmap and
remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
__folio_split() into the anon helper next to the folio_mapped() check that
already gates unmap_folio().

This makes the anon_vma conditional on folio_mapped(), which is a
behaviour change but should be fine.  folio_get_anon_vma() returns NULL
whenever !folio_mapped(), so an anon folio with folio_mapcount() == 0 used
to get -EBUSY from split_huge_page() and is now split instead.  A
realistic case is a THP that has been fully swapped out and is still in
the swap cache: swap PTEs do not contribute mapcount, so it is
!folio_mapped() but still alive.

That should be safe and right to have because:

- folio_ref_freeze() below still rejects a folio that picked up any
  reference, a mapping or a GUP pin, in the meantime.

- A parallel split is excluded by the folio lock.  The anon_vma
  write lock was added to serialize split in commit 062f1af2170a
  ("mm: thp: acquire the anon_vma rwsem for write during split"), when
  split_huge_page() did not hold the folio lock throughout. commit
  e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
  folio lock a caller requirement and added the folio_ref_freeze()
  scheme, so that has been covered ever since.

- Unmapped path is already exercised by folio_split_unmapped(),
  and the swap cache split already runs well for a partially
  swapped-out mapped THP.

- A !folio_mapped() folio cannot become mapped meanwhile: mapping it
  requires the folio lock.

For mapped folios the anon_vma write lock is now released before
__folio_split() unlocks the after-split sub-folios, where previously it
was held across that loop; that window is harmless as the sub-folios stay
folio-locked and referenced until it.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-12-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
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
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   57 +++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper
+++ a/mm/huge_memory.c
@@ -4032,16 +4032,37 @@ static int __folio_freeze_split_anon(str
 	struct swap_cluster_info *ci = NULL;
 	const int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
-	bool need_remap = false;
 	int ret = 0;
 
+	/*
+	 * Unmap/remap needs the anon_vma, so we first take a reference on
+	 * it to prevent it from disappearing, and lock it for write here,
+	 * letting unmap_folio() walk the rmap with TTU_RMAP_LOCKED.
+	 *
+	 * folio_mapped() is not stable here, but it can only change in
+	 * one direction while the folio is locked. The mapcount can drop
+	 * to zero at any time, zap_pte_range() takes no folio lock. It
+	 * cannot go up: swapin, migration and uffd move all lock the folio
+	 * before mapping it, and fork only copies PTEs that already exist.
+	 *
+	 * So if we see the folio mapped, the worst case is an empty rmap
+	 * walk. If we see it unmapped, it stays unmapped and needs neither
+	 * the reference nor the lock. Anything else needs a reference
+	 * first and folio_ref_freeze() below catches it.
+	 *
+	 * Note that entirely swapped-out THPs are unmapped but can be split.
+	 */
 	if (folio_mapped(folio)) {
-		need_remap = true;
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma)
+			return -EBUSY;
+		anon_vma_lock_write(anon_vma);
 		ret = unmap_folio(folio);
 		if (ret)
-			return ret;
+			goto out_unlock;
 	}
 
 	local_irq_disable();
@@ -4099,11 +4120,16 @@ static int __folio_freeze_split_anon(str
 		swap_cluster_unlock(ci);
 out_no_split:
 	local_irq_enable();
-	if (need_remap) {
+	if (anon_vma) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
+out_unlock:
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	return ret;
 }
@@ -4294,7 +4320,6 @@ static int __folio_split(struct folio *f
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4325,23 +4350,6 @@ static int __folio_split(struct folio *f
 	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
-	if (is_anon) {
-		/*
-		 * The caller does not necessarily hold an mmap_lock that would
-		 * prevent the anon_vma disappearing so we first we take a
-		 * reference to it and then lock the anon_vma for write. This
-		 * is similar to folio_lock_anon_vma_read except the write lock
-		 * is taken to serialise against parallel split or collapse
-		 * operations.
-		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
-		}
-		anon_vma_lock_write(anon_vma);
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4368,11 +4376,6 @@ static int __folio_split(struct folio *f
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	if (anon_vma) {
-		anon_vma_unlock_write(anon_vma);
-		put_anon_vma(anon_vma);
-	}
-out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
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

