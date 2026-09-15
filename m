Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E912F9C37
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 00:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433120; cv=none; b=ZhFIs1rahUTigfWzHkdcONnZdGQl3jjiekqwFoxmkLjaveCpwkeYHAiNXjT1xZvXhVmdBkAIBkXJ9Y2UoDMTDIOCnkSNiTgn9MT7Vihz3mpkoEKW9+34XyGtCKxuzfk4BMqezCi3YTQ1ObKRJ4hOuTUySDbPeIZ4d7xc19vM86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433120; c=relaxed/simple;
	bh=zOSbVRjrVbTWtJDg7Q9Yyhfuze9cFGv+ourQJWi02r4=;
	h=Date:To:From:Subject:Message-Id; b=bU6cLMxdtCOOrHjzmXTfNeasOyJAslZ3U0DIZlGXI4m9PZfLwvyAAG/yt+Nygd3fr3U23S068uuHeG3cw+1YLwp1dCO6GHfZr+jUG6jtsG8chCpr0VEGvw0owvRazboG+Zrz6DSKVC+TSClWnHSOtfufVUcbcQyhOjSMh5NKQi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VcU4AKAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcU4AKAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9121F00898;
	Tue, 15 Sep 2026 00:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433117;
	bh=PMsGUR9y1NW0va5aENGUI64zwRSTQCwNrgcweE6QCn0=;
	h=Date:To:From:Subject;
	b=VcU4AKACAT7dPmBYROjkIWuFlxo7Fz2C69LjiC0ehlzVBpE7ENwZcjItf3+UTAAXo
	 K9cdQ0V/grORIszl/F82M9dHvE1AUF9g85AOpN/l+41ZmveNEWnaMXrA8okoshJ9y1
	 ZeOan1bb8Qqktxgyt7BoIBpH1Sjm9SeS9PPoJTrc=
Date: Mon, 14 Sep 2026 17:45:17 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch added to mm-new branch
Message-Id: <20260915004517.9F9121F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move anon_vma handling into the anon split helper
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Tue, 15 Sep 2026 01:14:53 +0800

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

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
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

 mm/huge_memory.c |   58 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper
+++ a/mm/huge_memory.c
@@ -4029,16 +4029,38 @@ static int __folio_freeze_split_anon(str
 	struct swap_cluster_info *ci = NULL;
 	int old_order = folio_order(folio);
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
+	 * Note a swapped-out THP counts as unmapped here as swap PTEs do
+	 * not contribute mapcount, and they are splittable.
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
@@ -4096,11 +4118,16 @@ static int __folio_freeze_split_anon(str
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
@@ -4295,7 +4322,6 @@ static int __folio_split(struct folio *f
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4326,23 +4352,6 @@ static int __folio_split(struct folio *f
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
@@ -4369,11 +4378,6 @@ static int __folio_split(struct folio *f
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

