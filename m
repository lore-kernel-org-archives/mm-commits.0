Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B429143738
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291682; cv=none; b=W4Fn3vX59yAtcJIrsFNg7xoSgMc0LlgnR8sdgOLz0dvVVsOTW4wVJ9Am6S87Z1IyYRDgMbIPHPaUSujDP93l3nhIaw91+xTA9/3BJ1sRaDmQ/+KkxMxs1l8JrYY4z4jb2QdZcIxTHgq20NviYlcMViZdIAx+AwO8IBfaowJx26Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291682; c=relaxed/simple;
	bh=BjIqr9Fi361mwe/X+Bzjf99xSsGjIYCpVGsDLQDOmig=;
	h=Date:To:From:Subject:Message-Id; b=eIMaKuHTOCEqb6KGjBxaGA7aLvCZiMR+B3XCjA4ngWMs2boKndFb1dnTucJjeRkBYIY5Qcig6umlfkpdvTG0QswqL1H0GD8vFcZJG1fEuN/Fn1iEKHMw0Bol/fAXnr2cIfCPFGG40vjGC0cg+OLdV516MbB9SRSoFWwjH2gbTP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XU+JN/IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XU+JN/IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F491C32789;
	Tue, 25 Jun 2024 05:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291682;
	bh=BjIqr9Fi361mwe/X+Bzjf99xSsGjIYCpVGsDLQDOmig=;
	h=Date:To:From:Subject:From;
	b=XU+JN/INxZBjJgcqMKgTlTpUxLBS14f3DRqTqJbVGxJQZUOr6f03S119o1o5yNkL6
	 CfqQ/sL+saTgtixT+3svqGnJUe81/z2aNL1Gs13HdxYCfPcdyNHp+jK9+Pxcjap96O
	 mE6QU/jA6TMut6YSyDHZXGen8wVjfDxo0FyySvrU=
Date: Mon, 24 Jun 2024 22:01:21 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch removed from -mm tree
Message-Id: <20240625050122.5F491C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
Date: Fri, 14 Jun 2024 09:51:38 +0800

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

[ioworker0@gmail.com: minor changes per David]
  Link: https://lkml.kernel.org/r/20240622100057.3352-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240614015138.31461-4-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 +++++
 mm/huge_memory.c        |   66 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c               |   26 +++++++++-----
 3 files changed, 91 insertions(+), 10 deletions(-)

--- a/include/linux/huge_mm.h~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/include/linux/huge_mm.h
@@ -430,6 +430,8 @@ static inline bool thp_migration_support
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio);
+bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
+			   pmd_t *pmdp, struct folio *folio);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -497,6 +499,13 @@ static inline void split_huge_pmd_locked
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
@@ -2689,6 +2689,72 @@ static void unmap_folio(struct folio *fo
 	try_to_unmap_flush();
 }
 
+static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
+					    unsigned long addr, pmd_t *pmdp,
+					    struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int ref_count, map_count;
+	pmd_t orig_pmd = *pmdp;
+	struct page *page;
+
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
+		return false;
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
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd) ||
+	    ref_count != map_count + 1) {
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
+		return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
+
+	return false;
+}
+
 static void remap_page(struct folio *folio, unsigned long nr)
 {
 	int i = 0;
--- a/mm/rmap.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/mm/rmap.c
@@ -1678,16 +1678,22 @@ static bool try_to_unmap_one(struct foli
 			goto walk_abort;
 		}
 
-		if (!pvmw.pte && (flags & TTU_SPLIT_HUGE_PMD)) {
-			/*
-			 * We temporarily have to drop the PTL and start once
-			 * again from that now-PTE-mapped page table.
-			 */
-			split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd,
-					      false, folio);
-			flags &= ~TTU_SPLIT_HUGE_PMD;
-			page_vma_mapped_walk_restart(&pvmw);
-			continue;
+		if (!pvmw.pte) {
+			if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd,
+						  folio))
+				goto walk_done;
+
+			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * We temporarily have to drop the PTL and
+				 * restart so we can process the PTE-mapped THP.
+				 */
+				split_huge_pmd_locked(vma, pvmw.address,
+						      pvmw.pmd, false, folio);
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
+			}
 		}
 
 		/* Unexpected PMD-mapped THP? */
_

Patches currently in -mm which might be from ioworker0@gmail.com are


