Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BD7270EC3
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308945; cv=none; b=jRRFoy2izp303ZPwmW3MhozbitLY7Y5cgxdTHIzW98YEFrsvRoF8CthCxbpCPtTnxHqsuQYXAmKOtW3R4wUsuxBF7L4j3enm8Tvypkdr+wROj53KgMeQ64oTvmYgFuBqRpE4h/6Z+C54tKEhSYd/Y3IzLwwcOgNyPq12ebtVBNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308945; c=relaxed/simple;
	bh=Eza7POp6RtF8/mhfUin/KshVIk++Fb4SgG1jLCHanK0=;
	h=Date:To:From:Subject:Message-Id; b=M023o1YIvO4Whp1Hw5uNc5RQkmWA9PwoYAtlv/RVSZ9hooc+/varM3qmWGxJio1bg2TzktWTpXricjPzYpDjLf8o1PYAh4Yv3YZRjs2bP9q9w6/F7pQwuI6CRYLtobwC5R/HgChTMatSgSa4Clo6ARRyteHvIO6Nef3HGaXbI0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=du8Kbi/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="du8Kbi/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A3C116D0;
	Sat, 28 Feb 2026 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308944;
	bh=Eza7POp6RtF8/mhfUin/KshVIk++Fb4SgG1jLCHanK0=;
	h=Date:To:From:Subject:From;
	b=du8Kbi/LWuUXkgAB0D595uosrCcx3w0JFfuKjzRl90YSjIMYU9xRVv70ikLBVtbjr
	 ZN2bTOqg+V5e6ktHDUdM0zpBZUGlzK/vPwnUhnm++/7LkjhxiwlhaEHgbWsoPlePoo
	 Lsr/qSfY93kxU276uweu/C1C4UpeGx1KBTj2XfAY=
Date: Sat, 28 Feb 2026 12:02:24 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch added to mm-new branch
Message-Id: <20260228200224.DB3A3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a batched helper to clear the young flag for large folios
has been added to the -mm mm-new branch.  Its filename is
     mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: add a batched helper to clear the young flag for large folios
Date: Fri, 27 Feb 2026 17:44:38 +0800

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

Link: https://lkml.kernel.org/r/589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 include/linux/pgtable.h |   38 ++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |   16 +++++++++++-----
 2 files changed, 49 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios
+++ a/include/linux/pgtable.h
@@ -1103,6 +1103,44 @@ static inline int clear_flush_young_ptes
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
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
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
@@ -1822,13 +1822,13 @@ static inline int pmdp_clear_flush_young
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
 
@@ -1846,9 +1846,15 @@ static inline int pmdp_test_and_clear_yo
 
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

mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch

