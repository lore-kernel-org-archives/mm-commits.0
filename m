Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DE208CA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976877; cv=none; b=cYAklsF4QxXBzccOvSn+aPlckMAkiT6w+rSkGvmRPOXXXH+cYGGeBWFH+A9cj/RiMnv8Bz+LFJn8AX5nrx/c1ASyuK0O8OBX2B0MJeKTyMEdtOwa0699EEm5l53OwC9EKzW3+afC7/uwsHN/mVvyDm6ZQv9dV+NIDY5YRk//HHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976877; c=relaxed/simple;
	bh=giE1Jsj5YGgw8OCQvIWeRfqofAtvx6qLmfdwJfzYWSc=;
	h=Date:To:From:Subject:Message-Id; b=a1BXNm+7LdtAvqTQaloxXNe49rTPf6NMygmJ5LKZ2qeurKyTiwWRjGwTVRFJTVv1nZUGmy4ASQ0K3qoONFGgAk/2N7kcSvH2Nzw9l2zAdlUFCEIR93EeYsBdDvp2MQi+IG9RCbztuT5CbEqMkEHQCKBg1tWOLhimw48DdSHUX/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euUjb1ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euUjb1ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5646DC4CEE3;
	Sun, 20 Jul 2025 02:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976877;
	bh=giE1Jsj5YGgw8OCQvIWeRfqofAtvx6qLmfdwJfzYWSc=;
	h=Date:To:From:Subject:From;
	b=euUjb1ON0m5aQQQlXB8dJoN63ZBGLe7Jixb/iRlKtwXNfQ1iyTzKwYlQ9ZL9PO3+3
	 7usrQmcthiN0gVLcx2WDCFMnTzaB2CNWkAofCWHgEnfOddIIKHMau8/BTDqeqasRYc
	 NAvYBobW3vLXPym0vE2zB7I7aX4dJI71pQUI08UE=
Date: Sat, 19 Jul 2025 19:01:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,osalvador@suse.de,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,byungchul@sk.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-fpb_ignore_-into-fpb_respect_.patch removed from -mm tree
Message-Id: <20250720020117.5646DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert FPB_IGNORE_* into FPB_RESPECT_*
has been removed from the -mm tree.  Its filename was
     mm-convert-fpb_ignore_-into-fpb_respect_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: convert FPB_IGNORE_* into FPB_RESPECT_*
Date: Wed, 2 Jul 2025 12:49:23 +0200

Patch series "mm: folio_pte_batch() improvements", v2.

Ever since we added folio_pte_batch() for fork() + munmap() purposes, a
lot more users appeared (and more are being proposed), and more
functionality was added.

Most of the users only need basic functionality, and could benefit from a
non-inlined version.

So let's clean up folio_pte_batch() and split it into a basic
folio_pte_batch() (no flags) and a more advanced folio_pte_batch_ext(). 
Using either variant will now look much cleaner.

This series will likely conflict with some changes in some (old+new)
folio_pte_batch() users, but conflicts should be trivial to resolve.


This patch (of 4):

Respecting these PTE bits is the exception, so let's invert the meaning.

With this change, most callers don't have to pass any flags.  This is a
preparation for splitting folio_pte_batch() into a non-inlined variant
that doesn't consume any flags.

Long-term, we want folio_pte_batch() to probably ignore most common PTE
bits (e.g., write/dirty/young/soft-dirty) that are not relevant for most
page table walkers: uffd-wp and protnone might be bits to consider in the
future.  Only walkers that care about them can opt-in to respect them.

No functional change intended.

Link: https://lkml.kernel.org/r/20250702104926.212243-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   16 ++++++++--------
 mm/madvise.c   |    3 +--
 mm/memory.c    |   11 +++++------
 mm/mempolicy.c |    4 +---
 mm/mlock.c     |    3 +--
 mm/mremap.c    |    3 +--
 mm/rmap.c      |    3 +--
 7 files changed, 18 insertions(+), 25 deletions(-)

--- a/mm/internal.h~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/internal.h
@@ -202,17 +202,17 @@ static inline void vma_close(struct vm_a
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
-/* Compare PTEs after pte_mkclean(), ignoring the dirty bit. */
-#define FPB_IGNORE_DIRTY		((__force fpb_t)BIT(0))
+/* Compare PTEs respecting the dirty bit. */
+#define FPB_RESPECT_DIRTY		((__force fpb_t)BIT(0))
 
-/* Compare PTEs after pte_clear_soft_dirty(), ignoring the soft-dirty bit. */
-#define FPB_IGNORE_SOFT_DIRTY		((__force fpb_t)BIT(1))
+/* Compare PTEs respecting the soft-dirty bit. */
+#define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
 
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
-	if (flags & FPB_IGNORE_DIRTY)
+	if (!(flags & FPB_RESPECT_DIRTY))
 		pte = pte_mkclean(pte);
-	if (likely(flags & FPB_IGNORE_SOFT_DIRTY))
+	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
 		pte = pte_clear_soft_dirty(pte);
 	return pte_wrprotect(pte_mkold(pte));
 }
@@ -236,8 +236,8 @@ static inline pte_t __pte_batch_clear_ig
  * pages of the same large folio.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
- * the accessed bit, writable bit, dirty bit (with FPB_IGNORE_DIRTY) and
- * soft-dirty bit (with FPB_IGNORE_SOFT_DIRTY).
+ * the accessed bit, writable bit, dirty bit (unless FPB_RESPECT_DIRTY is set)
+ * and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
  *
  * start_ptep must map any page of the folio. max_nr must be at least one and
  * must be limited by the caller so scanning cannot exceed a single page table.
--- a/mm/madvise.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/madvise.c
@@ -346,10 +346,9 @@ static inline int madvise_folio_pte_batc
 					  pte_t pte, bool *any_young,
 					  bool *any_dirty)
 {
-	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	int max_nr = (end - addr) / PAGE_SIZE;
 
-	return folio_pte_batch(folio, addr, ptep, pte, max_nr, fpb_flags, NULL,
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr, 0, NULL,
 			       any_young, any_dirty);
 }
 
--- a/mm/memory.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/memory.c
@@ -990,10 +990,10 @@ copy_present_ptes(struct vm_area_struct
 	 * by keeping the batching logic separate.
 	 */
 	if (unlikely(!*prealloc && folio_test_large(folio) && max_nr != 1)) {
-		if (src_vma->vm_flags & VM_SHARED)
-			flags |= FPB_IGNORE_DIRTY;
-		if (!vma_soft_dirty_enabled(src_vma))
-			flags |= FPB_IGNORE_SOFT_DIRTY;
+		if (!(src_vma->vm_flags & VM_SHARED))
+			flags |= FPB_RESPECT_DIRTY;
+		if (vma_soft_dirty_enabled(src_vma))
+			flags |= FPB_RESPECT_SOFT_DIRTY;
 
 		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags,
 				     &any_writable, NULL, NULL);
@@ -1535,7 +1535,6 @@ static inline int zap_present_ptes(struc
 		struct zap_details *details, int *rss, bool *force_flush,
 		bool *force_break, bool *any_skipped)
 {
-	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio;
 	struct page *page;
@@ -1565,7 +1564,7 @@ static inline int zap_present_ptes(struc
 	 * by keeping the batching logic separate.
 	 */
 	if (unlikely(folio_test_large(folio) && max_nr != 1)) {
-		nr = folio_pte_batch(folio, addr, pte, ptent, max_nr, fpb_flags,
+		nr = folio_pte_batch(folio, addr, pte, ptent, max_nr, 0,
 				     NULL, NULL, NULL);
 
 		zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, nr,
--- a/mm/mempolicy.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/mempolicy.c
@@ -675,7 +675,6 @@ static void queue_folios_pmd(pmd_t *pmd,
 static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
-	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct vm_area_struct *vma = walk->vma;
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -713,8 +712,7 @@ static int queue_folios_pte_range(pmd_t
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, addr, pte, ptent,
-					     max_nr, fpb_flags,
-					     NULL, NULL, NULL);
+					     max_nr, 0, NULL, NULL, NULL);
 		/*
 		 * vm_normal_folio() filters out zero pages, but there might
 		 * still be reserved folios to skip, perhaps in a VDSO.
--- a/mm/mlock.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/mlock.c
@@ -307,14 +307,13 @@ void munlock_folio(struct folio *folio)
 static inline unsigned int folio_mlock_step(struct folio *folio,
 		pte_t *pte, unsigned long addr, unsigned long end)
 {
-	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	unsigned int count = (end - addr) >> PAGE_SHIFT;
 	pte_t ptent = ptep_get(pte);
 
 	if (!folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, addr, pte, ptent, count, fpb_flags, NULL,
+	return folio_pte_batch(folio, addr, pte, ptent, count, 0, NULL,
 			       NULL, NULL);
 }
 
--- a/mm/mremap.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/mremap.c
@@ -173,7 +173,6 @@ static pte_t move_soft_dirty_pte(pte_t p
 static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
 		pte_t *ptep, pte_t pte, int max_nr)
 {
-	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct folio *folio;
 
 	if (max_nr == 1)
@@ -183,7 +182,7 @@ static int mremap_folio_pte_batch(struct
 	if (!folio || !folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, addr, ptep, pte, max_nr, flags, NULL,
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr, 0, NULL,
 			       NULL, NULL);
 }
 
--- a/mm/rmap.c~mm-convert-fpb_ignore_-into-fpb_respect_
+++ a/mm/rmap.c
@@ -1849,7 +1849,6 @@ static inline unsigned int folio_unmap_p
 			struct page_vma_mapped_walk *pvmw,
 			enum ttu_flags flags, pte_t pte)
 {
-	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	unsigned long end_addr, addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
 	unsigned int max_nr;
@@ -1869,7 +1868,7 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
-	return folio_pte_batch(folio, addr, pvmw->pte, pte, max_nr, fpb_flags,
+	return folio_pte_batch(folio, addr, pvmw->pte, pte, max_nr, 0,
 			       NULL, NULL, NULL);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

