Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6536134
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716333559; cv=none; b=PIg5H0nOQZTT06vqkeMW2m/vy9y8Qv7lIi17PPW9DOPCDjogwIXz2vV33j24rZPpPAbq9b1MptuiMrczuQ+OlZneWSNsstzmjj5VTtJpH2wQx17yrZtoBuEVqow/RsLXWKsbggpRRjYA5U9iYxi8EPn1OphxfT3f/6i7lYHSQ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716333559; c=relaxed/simple;
	bh=J7ea1XgUx4liy//4ISp4JFcWn74BhpXl45eJFZgfgME=;
	h=Date:To:From:Subject:Message-Id; b=byhqTrn4nyl4ToEE6c9d+Yfqe2xy/JfN6t/DFhdWcqbbu7mKgNbACMnc4QImeemtnwBVYqb7QJ2lB4eZkx9Rwa1nGmPco+nvar/2Y9tjpJ0HDX1CpTJD2KviMfMQcchI7Z/LUXmvYeRfw3g48evJ3BU0VRaLiwZlBNaX3CP2Vi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zc8Cr3d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zc8Cr3d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66076C2BD11;
	Tue, 21 May 2024 23:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716333558;
	bh=J7ea1XgUx4liy//4ISp4JFcWn74BhpXl45eJFZgfgME=;
	h=Date:To:From:Subject:From;
	b=zc8Cr3d7mNIgylwaYxl0R0TLD2bTQlz4kn0vdJkQGscY58VXYVA/Gr5C4M/LmwNif
	 AAsJKR5rToRy2Ox5hHVQVyELZxVZH/uova5bhfR6YjI8fCq23ncYezqKCY6e5gHuaU
	 fTsTQUot1QKXE8X7fOJ9jc3GnKEABeRYEA5WHZg0=
Date: Tue, 21 May 2024 16:19:17 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20240521231918.66076C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
Date: Tue, 21 May 2024 12:02:44 +0800

When the user no longer requires the pages, they would use
madvise(MADV_FREE) to mark the pages as lazy free.  Subsequently, they
typically would not re-write to that memory again.

During memory reclaim, if we detect that the large folio and its PMD are
both still marked as clean and there are no unexpected references (such as
GUP), so we can just discard the memory lazily, improving the efficiency
of memory reclamation in this case.

On an Intel i5 CPU, reclaiming 1GiB of lazyfree THPs using
mem_cgroup_force_empty() results in the following runtimes in seconds
(shorter is better):

--------------------------------------------
|     Old       |      New       |  Change  |
--------------------------------------------
|   0.683426    |    0.049197    |  -92.80% |
--------------------------------------------

Link: https://lkml.kernel.org/r/20240521040244.48760-4-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++++
 mm/huge_memory.c        |   80 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c               |   41 +++++++++++++------
 3 files changed, 117 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/include/linux/huge_mm.h
@@ -411,6 +411,8 @@ static inline bool thp_migration_support
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio);
+bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
+			   pmd_t *pmdp, struct folio *folio);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -478,6 +480,13 @@ static inline void split_huge_pmd_locked
 					 unsigned long address, pmd_t *pmd,
 					 bool freeze, struct folio *folio) {}
 
+static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
+					 unsigned long addr, pmd_t *pmdp,
+					 struct folio *folio)
+{
+	return false;
+}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/mm/huge_memory.c
@@ -2687,6 +2687,86 @@ static void unmap_folio(struct folio *fo
 	try_to_unmap_flush();
 }
 
+static bool __discard_trans_pmd_locked(struct vm_area_struct *vma,
+				       unsigned long addr, pmd_t *pmdp,
+				       struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(folio_test_swapbacked(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
+	struct mm_struct *mm = vma->vm_mm;
+	int ref_count, map_count;
+	pmd_t orig_pmd = *pmdp;
+	struct page *page;
+
+	if (unlikely(!pmd_present(orig_pmd) || !pmd_trans_huge(orig_pmd)))
+		return false;
+
+	page = pmd_page(orig_pmd);
+	if (unlikely(page_folio(page) != folio))
+		return false;
+
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd)) {
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	orig_pmd = pmdp_huge_clear_flush(vma, addr, pmdp);
+
+	/*
+	 * Syncing against concurrent GUP-fast:
+	 * - clear PMD; barrier; read refcount
+	 * - inc refcount; barrier; read PMD
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for folio refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	/*
+	 * If the folio or its PMD is redirtied at this point, or if there
+	 * are unexpected references, we will give up to discard this folio
+	 * and remap it.
+	 *
+	 * The only folio refs must be one from isolation plus the rmap(s).
+	 */
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
+		folio_set_swapbacked(folio);
+
+	if (folio_test_swapbacked(folio) || ref_count != map_count + 1) {
+		set_pmd_at(mm, addr, pmdp, orig_pmd);
+		return false;
+	}
+
+	folio_remove_rmap_pmd(folio, page, vma);
+	zap_deposited_table(mm, pmdp);
+	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put(folio);
+
+	return true;
+}
+
+bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
+			   pmd_t *pmdp, struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_pmd_mappable(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE(!IS_ALIGNED(addr, HPAGE_PMD_SIZE));
+
+	if (folio_test_anon(folio) && !folio_test_swapbacked(folio))
+		return __discard_trans_pmd_locked(vma, addr, pmdp, folio);
+
+	return false;
+}
+
 static void remap_page(struct folio *folio, unsigned long nr)
 {
 	int i = 0;
--- a/mm/rmap.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/mm/rmap.c
@@ -1630,6 +1630,7 @@ static bool try_to_unmap_one(struct foli
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	bool pmd_mapped = false;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1677,18 +1678,26 @@ static bool try_to_unmap_one(struct foli
 			goto walk_done_err;
 		}
 
-		if (!pvmw.pte && (flags & TTU_SPLIT_HUGE_PMD)) {
-			/*
-			 * We temporarily have to drop the PTL and start once
-			 * again from that now-PTE-mapped page table.
-			 */
-			split_huge_pmd_locked(vma, range.start, pvmw.pmd, false,
-					      folio);
-			pvmw.pmd = NULL;
-			spin_unlock(pvmw.ptl);
-			pvmw.ptl = NULL;
-			flags &= ~TTU_SPLIT_HUGE_PMD;
-			continue;
+		if (!pvmw.pte) {
+			pmd_mapped = true;
+			if (unmap_huge_pmd_locked(vma, range.start, pvmw.pmd,
+						  folio))
+				goto walk_done;
+
+			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * We temporarily have to drop the PTL and start
+				 * once again from that now-PTE-mapped page
+				 * table.
+				 */
+				split_huge_pmd_locked(vma, range.start,
+						      pvmw.pmd, false, folio);
+				pvmw.pmd = NULL;
+				spin_unlock(pvmw.ptl);
+				pvmw.ptl = NULL;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				continue;
+			}
 		}
 
 		/* Unexpected PMD-mapped THP? */
@@ -1816,7 +1825,13 @@ static bool try_to_unmap_one(struct foli
 			 */
 			if (unlikely(folio_test_swapbacked(folio) !=
 					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+				/*
+				 * unmap_huge_pmd_locked() will unmark a
+				 * PMD-mapped folio as lazyfree if the folio or
+				 * its PMD was redirtied.
+				 */
+				if (!pmd_mapped)
+					WARN_ON_ONCE(1);
 				goto walk_done_err;
 			}
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

