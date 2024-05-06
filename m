Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD125757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957074; cv=none; b=fJNWI3Zqefz+ui1YIx8JZZnOnrqNvEEPqvCwNYfo+hgb/RQsS03WyEGomkp40MeTxDBCVYsf6UJlfUcppaOmrJc8EEU6Re83MtFxvoVPjdq/KRkkGACcvQSOG7amd7ILc6dmmyCwwiLq/2aWv3TuAsYCPRttqIv9xbf2jXnehzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957074; c=relaxed/simple;
	bh=De/d/s/rK5aJY0G1E6L+uu1OazPfPQ7Rj0Q5+XYUGhM=;
	h=Date:To:From:Subject:Message-Id; b=VcyAUJpAcRHgeQ1wsI0tEuZmEndP6Yp9M4VIYvGlIRacGzPClYCZecPZkreZzura/TIA1AjivXq3cQ3eKFLk0s2S/EzNlAzH4L23O/iczq+6xy74rm9nVGIp4ePbvUIax2SJAUKruNOupsmcjonLW9RHxQGMpiW6RKDVB5fiS7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPkpkXog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPkpkXog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E95C113CC;
	Mon,  6 May 2024 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957074;
	bh=De/d/s/rK5aJY0G1E6L+uu1OazPfPQ7Rj0Q5+XYUGhM=;
	h=Date:To:From:Subject:From;
	b=ZPkpkXogvfhYB0EyZLO7rFwB0Bb7rwGLXPcztDrqtBMmxBwn2UqrxOgl1sL6ca2Nj
	 oNd2Ud/ZAXTkGIwVFml7Mx2Aok9KtkUdAXcr2+fI2HytFWfgz2VxIIs6+XlwGKNRpW
	 Vkv+HI1N3C1JcIHafNQcGKHXD6JztsCfA3PsU4Dg=
Date: Sun, 05 May 2024 17:57:53 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch removed from -mm tree
Message-Id: <20240506005753.F3E95C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: introduce clear_young_dirty_ptes() batch helper
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/madvise: introduce clear_young_dirty_ptes() batch helper
Date: Thu, 18 Apr 2024 21:44:32 +0800

Patch series "mm/madvise: enhance lazyfreeing with mTHP in madvise_free",
v10.

This patchset adds support for lazyfreeing multi-size THP (mTHP) without
needing to first split the large folio via split_folio().  However, we
still need to split a large folio that is not fully mapped within the
target range.

If a large folio is locked or shared, or if we fail to split it, we just
leave it in place and advance to the next PTE in the range.  But note that
the behavior is changed; previously, any failure of this sort would cause
the entire operation to give up.  As large folios become more common,
sticking to the old way could result in wasted opportunities.

Performance Testing
===================

On an Intel I5 CPU, lazyfreeing a 1GiB VMA backed by PTE-mapped folios of
the same size results in the following runtimes for madvise(MADV_FREE) in
seconds (shorter is better):

Folio Size |   Old    |   New    | Change
------------------------------------------
      4KiB | 0.590251 | 0.590259 |    0%
     16KiB | 2.990447 | 0.185655 |  -94%
     32KiB | 2.547831 | 0.104870 |  -95%
     64KiB | 2.457796 | 0.052812 |  -97%
    128KiB | 2.281034 | 0.032777 |  -99%
    256KiB | 2.230387 | 0.017496 |  -99%
    512KiB | 2.189106 | 0.010781 |  -99%
   1024KiB | 2.183949 | 0.007753 |  -99%
   2048KiB | 0.002799 | 0.002804 |    0%


This patch (of 4):

This commit introduces clear_young_dirty_ptes() to replace mkold_ptes(). 
By doing so, we can use the same function for both use cases
(madvise_pageout and madvise_free), and it also provides the flexibility
to only clear the dirty flag in the future if needed.

Link: https://lkml.kernel.org/r/20240418134435.6092-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240418134435.6092-2-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    9 ++++
 include/linux/pgtable.h  |   74 ++++++++++++++++++++++---------------
 mm/madvise.c             |    3 +
 3 files changed, 55 insertions(+), 31 deletions(-)

--- a/include/linux/mm_types.h~mm-madvise-introduce-clear_young_dirty_ptes-batch-helper
+++ a/include/linux/mm_types.h
@@ -1368,6 +1368,15 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+/* Flags for clear_young_dirty_ptes(). */
+typedef int __bitwise cydp_t;
+
+/* Clear the access bit */
+#define CYDP_CLEAR_YOUNG		((__force cydp_t)BIT(0))
+
+/* Clear the dirty bit */
+#define CYDP_CLEAR_DIRTY		((__force cydp_t)BIT(1))
+
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
  * other. Here is what they mean, and how to use them:
--- a/include/linux/pgtable.h~mm-madvise-introduce-clear_young_dirty_ptes-batch-helper
+++ a/include/linux/pgtable.h
@@ -361,36 +361,6 @@ static inline int ptep_test_and_clear_yo
 }
 #endif
 
-#ifndef mkold_ptes
-/**
- * mkold_ptes - Mark PTEs that map consecutive pages of the same folio as old.
- * @vma: VMA the pages are mapped into.
- * @addr: Address the first page is mapped at.
- * @ptep: Page table pointer for the first entry.
- * @nr: Number of entries to mark old.
- *
- * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over ptep_test_and_clear_young().
- *
- * Note that PTE bits in the PTE range besides the PFN can differ. For example,
- * some PTEs might be write-protected.
- *
- * Context: The caller holds the page table lock.  The PTEs map consecutive
- * pages that belong to the same folio.  The PTEs are all in the same PMD.
- */
-static inline void mkold_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, unsigned int nr)
-{
-	for (;;) {
-		ptep_test_and_clear_young(vma, addr, ptep);
-		if (--nr == 0)
-			break;
-		ptep++;
-		addr += PAGE_SIZE;
-	}
-}
-#endif
-
 #ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
@@ -489,6 +459,50 @@ static inline pte_t ptep_get_and_clear(s
 }
 #endif
 
+#ifndef clear_young_dirty_ptes
+/**
+ * clear_young_dirty_ptes - Mark PTEs that map consecutive pages of the
+ *		same folio as old/clean.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to mark old/clean.
+ * @flags: Flags to modify the PTE batch semantics.
+ *
+ * May be overridden by the architecture; otherwise, implemented by
+ * get_and_clear/modify/set for each pte in the range.
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+					  unsigned int nr, cydp_t flags)
+{
+	pte_t pte;
+
+	for (;;) {
+		if (flags == CYDP_CLEAR_YOUNG)
+			ptep_test_and_clear_young(vma, addr, ptep);
+		else {
+			pte = ptep_get_and_clear(vma->vm_mm, addr, ptep);
+			if (flags & CYDP_CLEAR_YOUNG)
+				pte = pte_mkold(pte);
+			if (flags & CYDP_CLEAR_DIRTY)
+				pte = pte_mkclean(pte);
+			set_pte_at(vma->vm_mm, addr, ptep, pte);
+		}
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+#endif
+
 static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
--- a/mm/madvise.c~mm-madvise-introduce-clear_young_dirty_ptes-batch-helper
+++ a/mm/madvise.c
@@ -507,7 +507,8 @@ restart:
 			continue;
 
 		if (!pageout && pte_young(ptent)) {
-			mkold_ptes(vma, addr, pte, nr);
+			clear_young_dirty_ptes(vma, addr, pte, nr,
+					       CYDP_CLEAR_YOUNG);
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are


