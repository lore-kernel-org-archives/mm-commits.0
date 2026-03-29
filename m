Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982F8218AB9
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744769; cv=none; b=FwZvv+YXVB2hVZ5gteNWWneE9Hdy2eDm5eQwy6ad2qV9YwHqqLTC7rKVG1lRmukcNvZeEsOBCbPn5Ea2r/5JL+Fkv5xibWFF/FOG0t0egC7q87GlAYUBHVCr2i9Zob+ypmCFwf+bxv9TzQUJcy5gQeWjZmnQ3AEu6WMJGIAXS2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744769; c=relaxed/simple;
	bh=hbq/3xhOxE0zEc/WIOXlOKhp3XkU8v8YeZ+sBwZrCwQ=;
	h=Date:To:From:Subject:Message-Id; b=lYB3CHvdqCUxpuZiN5P8N9O2nRNJsOOfWCZMFdEUZZ5abk6pu4Jz42NMjwC+jPQqlrRVAwmvKMoQhKLEBbz3/uVLTIoCZYbJexY3LPBcqbOiGCDec+YO7vJ6r7TUct1bkCUz/fDW6x2o0rydKbggu+5o++/j5kG8FRezUX49CMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q8J7ytOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q8J7ytOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70275C4CEF7;
	Sun, 29 Mar 2026 00:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744769;
	bh=hbq/3xhOxE0zEc/WIOXlOKhp3XkU8v8YeZ+sBwZrCwQ=;
	h=Date:To:From:Subject:From;
	b=Q8J7ytOYjhW4dCN7EXgjWPVwGhkos/ZCgkvriO5/afrh54V+WbofsokJF8qgDVJIS
	 08rKhoNBg1Ji6lAu0UQIT7kEj5w5vAjApYXAY8QWbBbx5WdanbxV8wqoKqIhNMrbLT
	 bFGPDJ8a3nUj92XyrtX3DfAicfrzo6Yt+GDt0/OA=
Date: Sat, 28 Mar 2026 17:39:28 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-inline-helper-functions-instead-of-ugly-macros.patch removed from -mm tree
Message-Id: <20260329003929.70275C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use inline helper functions instead of ugly macros
has been removed from the -mm tree.  Its filename was
     mm-use-inline-helper-functions-instead-of-ugly-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: use inline helper functions instead of ugly macros
Date: Fri, 6 Mar 2026 14:43:37 +0800

Patch series "support batched checking of the young flag for MGLRU", v3.

This is a follow-up to the previous work [1], to support batched checking
of the young flag for MGLRU.

Similarly, batched checking of young flag for large folios can improve
performance during large-folio reclamation when MGLRU is enabled.  I
observed noticeable performance improvements (see patch 5) on an Arm64
machine that supports contiguous PTEs.  All mm-selftests are passed.

Patch 1 - 3: cleanup patches.
Patch 4: add a new generic batched PTE helper: test_and_clear_young_ptes().
Patch 5: support batched young flag checking for MGLRU.
Patch 6: implement the Arm64 arch-specific test_and_clear_young_ptes().


This patch (of 6):

People have already complained that these *_clear_young_notify() related
macros are very ugly, so let's use inline helpers to make them more
readable.

In addition, we cannot implement these inline helper functions in the
mmu_notifier.h file, because some arch-specific files will include the
mmu_notifier.h, which introduces header compilation dependencies and
causes build errors (e.g., arch/arm64/include/asm/tlbflush.h).  Moreover,
since these functions are only used in the mm, implementing these inline
helpers in the mm/internal.h header seems reasonable.

Link: https://lkml.kernel.org/r/cover.1772778858.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/ea14af84e7967ccebb25082c28a8669d6da8fe57.1772778858.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/ [1]
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   54 ---------------------------------
 mm/internal.h                |   52 +++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 54 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-use-inline-helper-functions-instead-of-ugly-macros
+++ a/include/linux/mmu_notifier.h
@@ -516,55 +516,6 @@ static inline void mmu_notifier_range_in
 	range->owner = owner;
 }
 
-#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	unsigned int ___nr = __nr;					\
-	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
-	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
-						  ___address,		\
-						  ___address +		\
-						  ___nr * PAGE_SIZE);	\
-	__young;							\
-})
-
-#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
-	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
-						  ___address,		\
-						  ___address +		\
-							PMD_SIZE);	\
-	__young;							\
-})
-
-#define ptep_clear_young_notify(__vma, __address, __ptep)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = ptep_test_and_clear_young(___vma, ___address, __ptep);\
-	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
-					    ___address + PAGE_SIZE);	\
-	__young;							\
-})
-
-#define pmdp_clear_young_notify(__vma, __address, __pmdp)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = pmdp_test_and_clear_young(___vma, ___address, __pmdp);\
-	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
-					    ___address + PMD_SIZE);	\
-	__young;							\
-})
-
 #else /* CONFIG_MMU_NOTIFIER */
 
 struct mmu_notifier_range {
@@ -652,11 +603,6 @@ static inline void mmu_notifier_subscrip
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define clear_flush_young_ptes_notify clear_flush_young_ptes
-#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
-#define ptep_clear_young_notify ptep_test_and_clear_young
-#define pmdp_clear_young_notify pmdp_test_and_clear_young
-
 static inline void mmu_notifier_synchronize(void)
 {
 }
--- a/mm/internal.h~mm-use-inline-helper-functions-instead-of-ugly-macros
+++ a/mm/internal.h
@@ -11,6 +11,7 @@
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_notifier.h>
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
@@ -1796,4 +1797,55 @@ static inline int io_remap_pfn_range_com
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+#ifdef CONFIG_MMU_NOTIFIER
+static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	int young;
+
+	young = clear_flush_young_ptes(vma, addr, ptep, nr);
+	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
+						addr + nr * PAGE_SIZE);
+	return young;
+}
+
+static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	int young;
+
+	young = pmdp_clear_flush_young(vma, addr, pmdp);
+	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
+	return young;
+}
+
+static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+	int young;
+
+	young = ptep_test_and_clear_young(vma, addr, ptep);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	return young;
+}
+
+static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	int young;
+
+	young = pmdp_test_and_clear_young(vma, addr, pmdp);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
+	return young;
+}
+
+#else /* CONFIG_MMU_NOTIFIER */
+
+#define clear_flush_young_ptes_notify	clear_flush_young_ptes
+#define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
+#define ptep_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+
+#endif /* CONFIG_MMU_NOTIFIER */
+
 #endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

