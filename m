Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A640855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917823; cv=none; b=o69HwOdp8vkyvP9hIxqaMzOCF9bAdSiQcrLE5/2j5pcm+FEpp56HGgWVntT9ezHlQnjIUAbV4NtusWIEJt/z0CyJfad+rvcrr724TB3rG4NE/ZDicRTTUBUPPt1m+uuZBYMB9pmIi90S6XBSYWnqOWaw3NeQEeXfeNeobgPsvnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917823; c=relaxed/simple;
	bh=DmaOb0ik3Zmurmz6TzUumMOHP5SCWAec5eDTXTrC8C4=;
	h=Date:To:From:Subject:Message-Id; b=QvvrskEoAZtwgyhcVUSJAhVgFU12KrdZC8r7U7+mrevJDQPB0K4kxjHtfoaxfvGjZn22FiEqpf0TDIIFvfuRIdD4vUs4hs98uXHdYBJ3bwG3o6aDj6WOFcQvHf65MA7lCzrfGjhDiXya7CHM/X2+8SkV+D3KIoyz7C156uTMzXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JyxOuq5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JyxOuq5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37D8C4CEF7;
	Tue, 31 Mar 2026 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917822;
	bh=DmaOb0ik3Zmurmz6TzUumMOHP5SCWAec5eDTXTrC8C4=;
	h=Date:To:From:Subject:From;
	b=JyxOuq5lcLoSxUU/GAPZHBiULVkUB9P+wvDSKIuPjpHB8bxUHlbTbfTHh6BfwQbgo
	 ufmKk4JLyhopnTZqrYNqrXInm9hWiOtnu8V3nGHOSZCSJWBXB+46eP7Twl/yTs7uHb
	 t1wqNkuatbGMkVhLUZJ2WzWSC1PAAUdIrRMQphGI=
Date: Mon, 30 Mar 2026 17:43:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch removed from -mm tree
Message-Id: <20260331004342.D37D8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
Date: Fri, 20 Mar 2026 18:07:20 +0000

There's no need to use the ancient approach of returning an integer here,
just return a boolean.

Also update flush_needed to be a boolean, similarly.

Also add a kdoc comment describing the function.

No functional change intended.

Link: https://lkml.kernel.org/r/132274566cd49d2960a2294c36dd2450593dfc55.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |   23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc
+++ a/include/linux/huge_mm.h
@@ -27,8 +27,8 @@ static inline void huge_pud_set_accessed
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
-		 unsigned long addr);
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		  unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
 		 unsigned long addr);
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
--- a/mm/huge_memory.c~mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc
+++ a/mm/huge_memory.c
@@ -2402,11 +2402,20 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+/**
+ * zap_huge_pmd - Zap a huge THP which is of PMD size.
+ * @tlb: The MMU gather TLB state associated with the operation.
+ * @vma: The VMA containing the range to zap.
+ * @pmd: A pointer to the leaf PMD entry.
+ * @addr: The virtual address for the range to zap.
+ *
+ * Returns: %true on success, %false otherwise.
+ */
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	int flush_needed = 1;
+	bool flush_needed = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2414,7 +2423,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
-		return 0;
+		return false;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
 	 * when calling pmdp_huge_get_and_clear. So do the
@@ -2429,13 +2438,13 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 
 	if (pmd_present(orig_pmd)) {
@@ -2449,7 +2458,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = 0;
+		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2483,7 +2492,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 
-	return 1;
+	return true;
 }
 
 #ifndef pmd_move_must_withdraw
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

