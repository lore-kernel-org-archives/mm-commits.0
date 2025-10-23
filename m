Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A44334D4EE
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250473; cv=none; b=m5cRBujvM+LkC7X+EIpdzqpIt/mplF0VjajCrkZa6ssROau6QEnsBWVDSBv7T9m7NThNksG/Izix0NFN4an5gZcBuPJPQIkOIlH4AiFGqzzw2DsFHSvDn20ugWaL7VavESRisLJOMLiCAO/BLb1L8XkEGsHs9581daZln/aBGms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250473; c=relaxed/simple;
	bh=xCW9ABZKHZRTkQPeT9IAqvnJQXQJV0cMCZeswNPA06k=;
	h=Date:To:From:Subject:Message-Id; b=oEmTioJsq5VqzXCIOxpn+CSgaBAAFnJP8rmml+DDzmly3Z2rhpoj0Kvb3bYLXW+9TsSUTmt+Mcpc5UPbWF+Wbikh8mmZ9riL6UbGO1VjThbo1o1HSQQqOxxLq8tSe5R42YqmY814VH+cA6wdNhpZ8a5LfEE0jXCAJ+1+eY5ywm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hIs888YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hIs888YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6C7C4CEE7;
	Thu, 23 Oct 2025 20:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250473;
	bh=xCW9ABZKHZRTkQPeT9IAqvnJQXQJV0cMCZeswNPA06k=;
	h=Date:To:From:Subject:From;
	b=hIs888YAdKuSNmo3mX/5XG99qWogb6HTxw9tlKB0vCZcsOz1eEsjdljwIDcVQdNK+
	 5hfecTF5B2CtRwXfpbpsCFoTfZHNnS++aXkJaCotGhCptPSSob7RpJY+/kmHEFkiNF
	 Fp2oM9gvjf1PyGYWTxw4ySNmaQHjQhO8ah+KrucI=
Date: Thu, 23 Oct 2025 13:14:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-convert-to-folio_can_map_prot_numa.patch added to mm-unstable branch
Message-Id: <20251023201433.2A6C7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: convert to folio_can_map_prot_numa()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-convert-to-folio_can_map_prot_numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-convert-to-folio_can_map_prot_numa.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: convert to folio_can_map_prot_numa()
Date: Thu, 23 Oct 2025 19:37:36 +0800

The prot_numa_skip() naming is not good since it updates the folio access
time except checking whether to skip prot NUMA, so rename it to
folio_can_map_prot_numa(), and cleanup it a bit, remove ret by directly
return value instead of goto style.

Adding a new helper vma_is_single_threaded_private() to check whether it's
a single threaded private VMA, and make folio_can_map_prot_numa() a
non-static function so that they could be reused in change_huge_pmd(),
since folio_can_map_prot_numa() will be shared in different paths, let's
move it near change_prot_numa() in mempolicy.c.

Link: https://lkml.kernel.org/r/20251023113737.3572790-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   20 ++++++++++++++
 mm/mempolicy.c |   61 ++++++++++++++++++++++++++++++++++++++++++
 mm/mprotect.c  |   67 +++--------------------------------------------
 3 files changed, 86 insertions(+), 62 deletions(-)

--- a/mm/internal.h~mm-mprotect-convert-to-folio_can_map_prot_numa
+++ a/mm/internal.h
@@ -1381,6 +1381,26 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHARED)
+		return false;
+
+	return atomic_read(&vma->vm_mm->mm_users) == 1;
+}
+
+#ifdef CONFIG_NUMA_BALANCING
+bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		bool is_private_single_threaded);
+
+#else
+static inline bool folio_can_map_prot_numa(struct folio *folio,
+		struct vm_area_struct *vma, bool is_private_single_threaded)
+{
+	return false;
+}
+#endif
+
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
--- a/mm/mempolicy.c~mm-mprotect-convert-to-folio_can_map_prot_numa
+++ a/mm/mempolicy.c
@@ -85,6 +85,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/numa_balancing.h>
+#include <linux/sched/sysctl.h>
 #include <linux/sched/task.h>
 #include <linux/nodemask.h>
 #include <linux/cpuset.h>
@@ -99,6 +100,7 @@
 #include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/memory-tiers.h>
 #include <linux/migrate.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
@@ -803,6 +805,65 @@ unlock:
 }
 
 #ifdef CONFIG_NUMA_BALANCING
+/**
+ * folio_can_map_prot_numa() - check whether the folio can map prot numa
+ * @folio: The folio whose mapping considered for being made NUMA hintable
+ * @vma: The VMA that the folio belongs to.
+ * @is_private_single_threaded: Is this a single-threaded private VMA or not
+ *
+ * This function checks to see if the folio actually indicates that
+ * we need to make the mapping one which causes a NUMA hinting fault,
+ * as there are cases where it's simply unnecessary, and the folio's
+ * access time is adjusted for memory tiering if prot numa needed.
+ *
+ * Return: True if the mapping of the folio needs to be changed, false otherwise.
+ */
+bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		bool is_private_single_threaded)
+{
+	int nid;
+
+	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+		return false;
+
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		return false;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
+		return false;
+
+	/*
+	 * While migration can move some dirty folios,
+	 * it cannot move them all from MIGRATE_ASYNC
+	 * context.
+	 */
+	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
+		return false;
+
+	/*
+	 * Don't mess with PTEs if folio is already on the node
+	 * a single-threaded process is running on.
+	 */
+	nid = folio_nid(folio);
+	if (is_private_single_threaded && (nid == numa_node_id()))
+		return false;
+
+	/*
+	 * Skip scanning top tier node if normal numa
+	 * balancing is disabled
+	 */
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+	    node_is_toptier(nid))
+		return false;
+
+	if (folio_use_access_time(folio))
+		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
+
+	return true;
+}
+
 /*
  * This is used to mark a range of virtual addresses to be inaccessible.
  * These are later cleared by a NUMA hinting fault. Depending on these
--- a/mm/mprotect.c~mm-mprotect-convert-to-folio_can_map_prot_numa
+++ a/mm/mprotect.c
@@ -29,9 +29,7 @@
 #include <linux/uaccess.h>
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
-#include <linux/sched/sysctl.h>
 #include <linux/userfaultfd_k.h>
-#include <linux/memory-tiers.h>
 #include <uapi/linux/mman.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -118,60 +116,6 @@ static int mprotect_folio_pte_batch(stru
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
-		struct folio *folio)
-{
-	bool ret = true;
-	bool toptier;
-	int nid;
-
-	if (!folio)
-		goto skip;
-
-	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
-		goto skip;
-
-	/* Also skip shared copy-on-write folios */
-	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
-		goto skip;
-
-	/* Folios are pinned and can't be migrated */
-	if (folio_maybe_dma_pinned(folio))
-		goto skip;
-
-	/*
-	 * While migration can move some dirty pages,
-	 * it cannot move them all from MIGRATE_ASYNC
-	 * context.
-	 */
-	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto skip;
-
-	/*
-	 * Don't mess with PTEs if page is already on the node
-	 * a single-threaded process is running on.
-	 */
-	nid = folio_nid(folio);
-	if (target_node == nid)
-		goto skip;
-
-	toptier = node_is_toptier(nid);
-
-	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
-	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		goto skip;
-
-	ret = false;
-	if (folio_use_access_time(folio))
-		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
-
-skip:
-	return ret;
-}
-
 /* Set nr_ptes number of ptes, starting from idx */
 static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
 		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
@@ -274,7 +218,7 @@ static long change_pte_range(struct mmu_
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	long pages = 0;
-	int target_node = NUMA_NO_NODE;
+	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
@@ -285,10 +229,8 @@ static long change_pte_range(struct mmu_
 	if (!pte)
 		return -EAGAIN;
 
-	/* Get target node for single threaded private VMAs */
-	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
-	    atomic_read(&vma->vm_mm->mm_users) == 1)
-		target_node = numa_node_id();
+	if (prot_numa)
+		is_private_single_threaded = vma_is_single_threaded_private(vma);
 
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
@@ -315,7 +257,8 @@ static long change_pte_range(struct mmu_
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa &&
-			    prot_numa_skip(vma, target_node, folio)) {
+			    !folio_can_map_prot_numa(folio, vma,
+						is_private_single_threaded)) {
 
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-mprotect-convert-to-folio_can_map_prot_numa.patch
mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

