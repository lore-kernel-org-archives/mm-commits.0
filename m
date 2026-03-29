Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F721FAC42
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744775; cv=none; b=JrPaiV/9unkFA/SWMTmtR8gU26u/6zJWyhzyXCxyP/ai4ax5vWmpmEsH5L1ZPj9jCcqLYsITbdsVBiXr+Wl4vMSMuU4/AUsdJHsVP+bZbq0Vy9MHiahHmu2O14m7ngzbtoRQYwVRX1eQ5ZnN/7hcWJbAKRyUsIVcoWK8A7tP65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744775; c=relaxed/simple;
	bh=S6AEKWQFtDiTdMsPhsOgy1h5AmflQ0itQn5ZI7y/4TI=;
	h=Date:To:From:Subject:Message-Id; b=KzgaxTPPpCGbX3+LzZQgXqJUxFs5HB46/PHi2yF3Y+GmWKpXkUXX2GmonEdZc283SWioEoku5Y0vv9L6mGM0Yr3Z1ss+z03WdeI3UHyo2ZWkHgWVAWuLWO3wRAo0ypID07kxv90vaImkktZZYblPfknq2NzP4Hghh884PqHPC04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMqCi1oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMqCi1oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82EDC4CEF7;
	Sun, 29 Mar 2026 00:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744774;
	bh=S6AEKWQFtDiTdMsPhsOgy1h5AmflQ0itQn5ZI7y/4TI=;
	h=Date:To:From:Subject:From;
	b=CMqCi1oC1yplfLRjr23H0quV8B1WgQK7rqdW88mPiajyT9Ey9zJaeQL2CFdsLCn5j
	 ngviCuDPk+hJ8Ul60qUuMTN3Rx7ZE1ZTaT1aRCVrk9H0wZAOVAi62GOOi0NwoEuKVZ
	 mwuQh7ryHmmoyI5+FBFe5qtQ2aTvDnR32Qu6FWjE=
Date: Sat, 28 Mar 2026 17:39:34 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,akpm@linux-foundation.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch removed from -mm tree
Message-Id: <20260329003934.C82EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a batched helper to clear the young flag for large folios
has been removed from the -mm tree.  Its filename was
     mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: add a batched helper to clear the young flag for large folios
Date: Fri, 6 Mar 2026 14:43:40 +0800

Currently, MGLRU will call ptep_test_and_clear_young_notify() to check and
clear the young flag for each PTE sequentially, which is inefficient for
large folios reclamation.

Moreover, on Arm64 architecture, which supports contiguous PTEs, the
Arm64- specific ptep_test_and_clear_young() already implements an
optimization to clear the young flags for PTEs within a contiguous range. 
However, this is not sufficient.  Similar to the Arm64 specific
clear_flush_young_ptes(), we can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range:
CONT_PTE_SIZE).

Thus, we can introduce a new batched helper: test_and_clear_young_ptes()
and its wrapper test_and_clear_young_ptes_notify() which are consistent
with the existing functions, to perform batched checking of the young
flags for large folios, which can help improve performance during large
folio reclamation when MGLRU is enabled.  And it will be overridden by the
architecture that implements a more efficient batch operation in the
following patches.

Link: https://lkml.kernel.org/r/23ec671bfcc06cd24ee0fbff8e329402742274a0.1772778858.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   37 +++++++++++++++++++++++++++++++++++++
 mm/internal.h           |   16 +++++++++++-----
 2 files changed, 48 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios
+++ a/include/linux/pgtable.h
@@ -1103,6 +1103,43 @@ static inline int clear_flush_young_ptes
 }
 #endif
 
+#ifndef test_and_clear_young_ptes
+/**
+ * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			       folio as old
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear access bit.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_test_and_clear_young().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ *
+ * Returns: whether any PTE was young.
+ */
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_test_and_clear_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
--- a/mm/internal.h~mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios
+++ a/mm/internal.h
@@ -1819,13 +1819,13 @@ static inline int pmdp_clear_flush_young
 	return young;
 }
 
-static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+static inline int test_and_clear_young_ptes_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	int young;
 
-	young = ptep_test_and_clear_young(vma, addr, ptep);
-	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
 	return young;
 }
 
@@ -1843,9 +1843,15 @@ static inline int pmdp_test_and_clear_yo
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define test_and_clear_young_ptes_notify	test_and_clear_young_ptes
 #define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
+}
+
 #endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

