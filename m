Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3663B0597
	for <mm-commits@vger.kernel.org>; Tue, 22 Sep 2026 03:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047607; cv=none; b=mbOCvK8wRK70MLr2uiUIgt1vbwmnLs/NMuw5FSnCiIydMUWrLOFm6+RKIPuGi3tMxuYQD8a89tef2Xn5UEzajJDL9iug6jlM8/22muvWAuY3DpPMsL7I8DakBbLQEuG6w1mfAQv23Lm4g4kZ870KC6E2fVSYL5CE1oD9YvJNSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047607; c=relaxed/simple;
	bh=d28RhmtS4w4KV4QUOaTskA1fJxXf4Twe+rxNRNUhPEc=;
	h=Date:To:From:Subject:Message-Id; b=tUwBM++I4GLSYgj2BV6Jo6S3jmKYNLykm56N9RC3Sg8Q6AJycgLzdWAEbfcK3bs1XgnkWnjRwFYvyycmVYzpKH5uuUKd1XQr0Q/IblBcK1GLyLj2PuCve4v6AzrkfOqrmcKl0dwsaq5CdC4l2hS8DUxceK5SZngFmZ7l84Yp/Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/BKzNXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/BKzNXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCD91F000FF;
	Tue, 22 Sep 2026 03:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790047602;
	bh=xEadHl5wM2LuMR8Ve8zZQrzwZJQ9GX/iwry7YLMN3JI=;
	h=Date:To:From:Subject;
	b=h/BKzNXdNIC44HL3pBMg2mc9lfCJHXWpiYm0Wi+N14Y9XJpDiRhs5xfcW2ugZUuXu
	 BcaQtFP/zZfx6wh+q6O8euOph9160QgyT0omCdofcB0B9IcO9LXCjSZ8lui+T8hQEA
	 +lFiwIssEV6ePKhEIVJlY859oDOleQMdw9914i4I=
Date: Mon, 21 Sep 2026 20:26:41 -0700
To: mm-commits@vger.kernel.org,hanzhijian1991@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typos-in-various-comments.patch added to mm-new branch
Message-Id: <20260922032642.7DCD91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typos in various comments
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-typos-in-various-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typos-in-various-comments.patch

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
From: Zhijian Han <hanzhijian1991@gmail.com>
Subject: mm: fix typos in various comments
Date: Tue, 22 Sep 2026 11:18:43 +0800

Fix spelling errors found by codespell in several mm source files:

- "aray" -> "array" in include/linux/mm.h
- "indiciate" -> "indicate" in include/linux/mm_types.h
- "aggresive" -> "aggressive" in include/linux/mm_types.h
- "progated" -> "propagated" in mm/huge_memory.c
- "Pressumably" -> "Presumably" in mm/hugetlb.c
- "fime" -> "time" in mm/hugetlb.c
- "farest" -> "farthest" in mm/list_lru.c
- "trivally" -> "trivially" in mm/madvise.c
- "atmost" -> "at most" in mm/memcontrol.c
- "splited" -> "split" in mm/memory-failure.c
- "appliable" -> "applicable" in mm/memory.c
- "incase" -> "in case" in mm/page_io.c
- "contigous" -> "contiguous" in mm/vmalloc.c
- "probablity" -> "probability" in mm/kfence/core.c
- "possesss" -> "possesses" in mm/util.c

No functional changes.

Link: https://lore.kernel.org/20260922031843.2857104-1-hanzhijian1991@gmail.com
Signed-off-by: Zhijian Han <hanzhijian1991@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 +-
 include/linux/mm_types.h |    4 ++--
 mm/huge_memory.c         |    2 +-
 mm/hugetlb.c             |    4 ++--
 mm/kfence/core.c         |    2 +-
 mm/list_lru.c            |    2 +-
 mm/madvise.c             |    2 +-
 mm/memcontrol.c          |    2 +-
 mm/memory-failure.c      |    2 +-
 mm/memory.c              |    2 +-
 mm/page_io.c             |    2 +-
 mm/util.c                |    2 +-
 mm/vmalloc.c             |    2 +-
 13 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-fix-typos-in-various-comments
+++ a/include/linux/mm.h
@@ -4794,7 +4794,7 @@ static inline void mmap_action_simple_io
  * @desc: The VMA descriptor for the VMA requiring kernel pags to be mapped.
  * @start: The virtual address from which to map them.
  * @pages: An array of struct page pointers describing the memory to map.
- * @nr_pages: The number of entries in the @pages aray.
+ * @nr_pages: The number of entries in the @pages array.
  */
 static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 		unsigned long start, struct page **pages,
--- a/include/linux/mm_types.h~mm-fix-typos-in-various-comments
+++ a/include/linux/mm_types.h
@@ -759,7 +759,7 @@ static inline struct anon_vma_name *anon
 /*
  * While __vma_enter_locked() is working to ensure are no read-locks held on a
  * VMA (either while acquiring a VMA write lock or marking a VMA detached) we
- * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
+ * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indicate to
  * vma_start_read() that the reference count should be left alone.
  *
  * See the comment describing vm_refcnt in vm_area_struct for details as to
@@ -2016,7 +2016,7 @@ enum {
 /*
  * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
  * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
- * a counter on its own. We're aggresive on this bit for now: even if the
+ * a counter on its own. We're aggressive on this bit for now: even if the
  * pinned pages were unpinned later on, we'll still keep this bit set for the
  * lifecycle of this mm, just for simplicity.
  */
--- a/mm/huge_memory.c~mm-fix-typos-in-various-comments
+++ a/mm/huge_memory.c
@@ -3416,7 +3416,7 @@ static void __split_huge_pmd_locked(stru
 				swp_entry = make_readable_device_private_entry(
 							page_to_pfn(page + i));
 			/*
-			 * Young and dirty bits are not progated via swp_entry
+			 * Young and dirty bits are not propagated via swp_entry
 			 */
 			entry = swp_entry_to_pte(swp_entry);
 			if (soft_dirty)
--- a/mm/hugetlb.c~mm-fix-typos-in-various-comments
+++ a/mm/hugetlb.c
@@ -5396,7 +5396,7 @@ void __unmap_hugepage_range(struct mmu_g
 			int rc = vma_needs_reservation(h, vma, address);
 
 			if (rc < 0)
-				/* Pressumably allocate_file_region_entries failed
+				/* Presumably allocate_file_region_entries failed
 				 * to allocate a file_region struct. Clear
 				 * hugetlb_restore_reserve so that global reserve
 				 * count will not be incremented by free_huge_folio.
@@ -5609,7 +5609,7 @@ retry_avoidcopy:
 	 * In order to determine where this is a COW on a MAP_PRIVATE mapping it
 	 * is enough to check whether the old_folio is anonymous. This means that
 	 * the reserve for this address was consumed. If reserves were used, a
-	 * partial faulted mapping at the fime of fork() could consume its reserves
+	 * partial faulted mapping at the time of fork() could consume its reserves
 	 * on COW instead of the full address range.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
--- a/mm/kfence/core.c~mm-fix-typos-in-various-comments
+++ a/mm/kfence/core.c
@@ -156,7 +156,7 @@ atomic_t kfence_allocation_gate = ATOMIC
  * allocations of the same source filling up the pool.
  *
  * Assuming a range of 15%-85% unique allocations in the pool at any point in
- * time, the below parameters provide a probablity of 0.02-0.33 for false
+ * time, the below parameters provide a probability of 0.02-0.33 for false
  * positive hits respectively:
  *
  *	P(alloc_traces) = (1 - e^(-HNUM * (alloc_traces / SIZE)) ^ HNUM
--- a/mm/list_lru.c~mm-fix-typos-in-various-comments
+++ a/mm/list_lru.c
@@ -587,7 +587,7 @@ static int __memcg_list_lru_alloc(struct
 	 */
 	do {
 		/*
-		 * Keep finding the farest parent that wasn't populated
+		 * Keep finding the farthest parent that wasn't populated
 		 * until found memcg itself.
 		 */
 		pos = memcg;
--- a/mm/madvise.c~mm-fix-typos-in-various-comments
+++ a/mm/madvise.c
@@ -1470,7 +1470,7 @@ static bool is_discard(int behavior)
  * We are restricted from madvise()'ing mseal()'d VMAs only in very particular
  * circumstances - discarding of data from read-only anonymous SEALED mappings.
  *
- * This is because users cannot trivally discard data from these VMAs, and may
+ * This is because users cannot trivially discard data from these VMAs, and may
  * only do so via an appropriate madvise() call.
  */
 static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
--- a/mm/memcontrol.c~mm-fix-typos-in-various-comments
+++ a/mm/memcontrol.c
@@ -741,7 +741,7 @@ static unsigned long *memcg_events_local
  *
  * 2) Flush the stats synchronously on reader side only when there are more than
  *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
- *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
+ *    will let stats be out of sync by at most (MEMCG_CHARGE_BATCH * nr_cpus) but
  *    only for 2 seconds due to (1).
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
--- a/mm/memory.c~mm-fix-typos-in-various-comments
+++ a/mm/memory.c
@@ -5165,7 +5165,7 @@ check_folio:
 	 * have changed, so sub pages might got charged to the wrong cgroup,
 	 * or even should be shmem. So we have to free it and fallback.
 	 * Nothing should have touched it, both anon and shmem checks if a
-	 * large folio is fully appliable before use.
+	 * large folio is fully applicable before use.
 	 *
 	 * This will be removed once we unify folio allocation in the swap cache
 	 * layer, where allocation of a folio stabilizes the swap entries.
--- a/mm/memory-failure.c~mm-fix-typos-in-various-comments
+++ a/mm/memory-failure.c
@@ -2560,7 +2560,7 @@ try_again:
 	/*
 	 * We're only intended to deal with the non-Compound page here.
 	 * The page cannot become compound pages again as folio has been
-	 * splited and extra refcnt is held.
+	 * split and extra refcnt is held.
 	 */
 	WARN_ON(folio_test_large(folio));
 
--- a/mm/page_io.c~mm-fix-typos-in-various-comments
+++ a/mm/page_io.c
@@ -135,7 +135,7 @@ static bool is_folio_zero_filled(struct
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		data = kmap_local_folio(folio, i * PAGE_SIZE);
 		/*
-		 * Check last word first, incase the page is zero-filled at
+		 * Check last word first, in case the page is zero-filled at
 		 * the start and has non-zero data at the end, which is common
 		 * in real-world workloads.
 		 */
--- a/mm/util.c~mm-fix-typos-in-various-comments
+++ a/mm/util.c
@@ -1252,7 +1252,7 @@ EXPORT_SYMBOL(__compat_vma_mmap);
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
  * existing VMA and execute any requested actions.
- * @file: The file which possesss an f_op->mmap_prepare() hook.
+ * @file: The file which possesses an f_op->mmap_prepare() hook.
  * @vma: The VMA to apply the .mmap_prepare() hook to.
  *
  * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
--- a/mm/vmalloc.c~mm-fix-typos-in-various-comments
+++ a/mm/vmalloc.c
@@ -3699,7 +3699,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	/*
 	 * Initially, attempt to have the page allocator give us large order
 	 * pages. Do not attempt allocating smaller than order chunks since
-	 * __vmap_pages_range() expects physically contigous pages of exactly
+	 * __vmap_pages_range() expects physically contiguous pages of exactly
 	 * order long chunks.
 	 */
 	while (large_order > order && nr_remaining) {
_

Patches currently in -mm which might be from hanzhijian1991@gmail.com are

mm-fix-typos-in-various-comments.patch

