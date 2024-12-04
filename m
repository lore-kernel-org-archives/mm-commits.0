Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBC923918D
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352793; cv=none; b=tWb7gdIcw7Rw2s+y51cRcNnf20OZPLA3Nv0QQQI60fjcqhS4IiFPCKy2piW3jGreLFyWdk1qGbx26ttr7SdujKgvCgGIjjQD+Y6Dua9CLEGH78izqCcBuY8sRiQABHw6A2cGnY4rHPXqn8Yw7niXEkU9sqSIrJgKHzY4Dxd6zwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352793; c=relaxed/simple;
	bh=HCNxFLINuCReeWI3zub0xLE+oW7q5Jm2K9xntutfEKw=;
	h=Date:To:From:Subject:Message-Id; b=mAdEMP2Xa74WdzGPWI8bQMW7ExwM5nK5zPGKksWmn9Hw4qMXphVc/BAymewhKEDXXFzcIHXn1zWZm6kZF7wZXh9SXvH3Z006vzw6/UvZYiCTxirlE5P4V1+b1p6jSJZIEwQs0pfJl/IgavAe/D5i+tXR7Kl8vpCI4mAOuAJJJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZmNROKkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZmNROKkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A239DC4CECD;
	Wed,  4 Dec 2024 22:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352792;
	bh=HCNxFLINuCReeWI3zub0xLE+oW7q5Jm2K9xntutfEKw=;
	h=Date:To:From:Subject:From;
	b=ZmNROKkAbZKQt68VLMZmWcc4C8ftTwQjETXOvkFJT2mHq/Fy8Mp5FgA/J6PcrXjAo
	 9xwmRjxH2yhqBuHUYAAbo4MpvpAupxZEyLSdJw9D2xBPpUrvhCw8tNkdwoHPUdrokF
	 75JZ3FIlzbUugJoR1RCjux+8XzljHWFGV5ByVgeQ=
Date: Wed, 04 Dec 2024 14:53:12 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch added to mm-unstable branch
Message-Id: <20241204225312.A239DC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)
Date: Wed, 4 Dec 2024 19:09:49 +0800

Now in order to pursue high performance, applications mostly use some
high-performance user-mode memory allocators, such as jemalloc or
tcmalloc.  These memory allocators use madvise(MADV_DONTNEED or MADV_FREE)
to release physical memory, but neither MADV_DONTNEED nor MADV_FREE will
release page table memory, which may cause huge page table memory usage.

The following are a memory usage snapshot of one process which actually
happened on our server:

        VIRT:  55t
        RES:   590g
        VmPTE: 110g

In this case, most of the page table entries are empty.  For such a PTE
page where all entries are empty, we can actually free it back to the
system for others to use.

As a first step, this commit aims to synchronously free the empty PTE
pages in madvise(MADV_DONTNEED) case.  We will detect and free empty PTE
pages in zap_pte_range(), and will add zap_details.reclaim_pt to exclude
cases other than madvise(MADV_DONTNEED).

Once an empty PTE is detected, we first try to hold the pmd lock within
the pte lock.  If successful, we clear the pmd entry directly (fast path).
Otherwise, we wait until the pte lock is released, then re-hold the pmd
and pte locks and loop PTRS_PER_PTE times to check pte_none() to re-detect
whether the PTE page is empty and free it (slow path).

For other cases such as madvise(MADV_FREE), consider scanning and freeing
empty PTE pages asynchronously in the future.

The following code snippet can show the effect of optimization:

        mmap 50G
        while (1) {
                for (; i < 1024 * 25; i++) {
                        touch 2M memory
                        madvise MADV_DONTNEED 2M
                }
        }

As we can see, the memory usage of VmPTE is reduced:

                        before                          after
VIRT                   50.0 GB                        50.0 GB
RES                     3.1 MB                         3.1 MB
VmPTE                102640 KB                         240 KB

Link: https://lkml.kernel.org/r/92aba2b319a734913f18ba41e7d86a265f0b84e2.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/Kconfig         |   15 +++++++++
 mm/Makefile        |    1 
 mm/internal.h      |   19 +++++++++++
 mm/madvise.c       |    7 +++-
 mm/memory.c        |   21 +++++++++++-
 mm/pt_reclaim.c    |   71 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 132 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/include/linux/mm.h
@@ -2319,6 +2319,7 @@ extern void pagefault_out_of_memory(void
 struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 	bool even_cows;			/* Zap COWed private pages too? */
+	bool reclaim_pt;		/* Need reclaim page tables? */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
 
--- a/mm/internal.h~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/mm/internal.h
@@ -1541,4 +1541,23 @@ int walk_page_range_mm(struct mm_struct
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
 
+/* pt_reclaim.c */
+bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
+void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
+	      pmd_t pmdval);
+void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
+		     struct mmu_gather *tlb);
+
+#ifdef CONFIG_PT_RECLAIM
+bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
+			   struct zap_details *details);
+#else
+static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
+					 struct zap_details *details)
+{
+	return false;
+}
+#endif /* CONFIG_PT_RECLAIM */
+
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/Kconfig~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/mm/Kconfig
@@ -1301,6 +1301,21 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
+config ARCH_SUPPORTS_PT_RECLAIM
+	def_bool n
+
+config PT_RECLAIM
+	bool "reclaim empty user page table pages"
+	default y
+	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
+	select MMU_GATHER_RCU_TABLE_FREE
+	help
+	  Try to reclaim empty user page table pages in paths other than munmap
+	  and exit_mmap path.
+
+	  Note: now only empty user PTE page table pages will be reclaimed.
+
+
 source "mm/damon/Kconfig"
 
 endmenu
--- a/mm/madvise.c~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/mm/madvise.c
@@ -851,7 +851,12 @@ static int madvise_free_single_vma(struc
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range_single(vma, start, end - start, NULL);
+	struct zap_details details = {
+		.reclaim_pt = true,
+		.even_cows = true,
+	};
+
+	zap_page_range_single(vma, start, end - start, &details);
 	return 0;
 }
 
--- a/mm/Makefile~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/mm/Makefile
@@ -146,3 +146,4 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
+obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
--- a/mm/memory.c~mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed
+++ a/mm/memory.c
@@ -1436,7 +1436,7 @@ copy_page_range(struct vm_area_struct *d
 static inline bool should_zap_cows(struct zap_details *details)
 {
 	/* By default, zap all pages */
-	if (!details)
+	if (!details || details->reclaim_pt)
 		return true;
 
 	/* Or, we zap COWed pages only if the caller wants to */
@@ -1710,12 +1710,15 @@ static unsigned long zap_pte_range(struc
 				struct zap_details *details)
 {
 	bool force_flush = false, force_break = false;
-	bool any_skipped = false;
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	pmd_t pmdval;
+	unsigned long start = addr;
+	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
+	bool direct_reclaim = false;
 	int nr;
 
 retry:
@@ -1728,17 +1731,24 @@ retry:
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	do {
+		bool any_skipped = false;
+
 		if (need_resched())
 			break;
 
 		nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
 				      &force_flush, &force_break, &any_skipped);
+		if (any_skipped)
+			can_reclaim_pt = false;
 		if (unlikely(force_break)) {
 			addr += nr * PAGE_SIZE;
 			break;
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
+	if (can_reclaim_pt && addr == end)
+		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
+
 	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
 
@@ -1765,6 +1775,13 @@ retry:
 		goto retry;
 	}
 
+	if (can_reclaim_pt) {
+		if (direct_reclaim)
+			free_pte(mm, start, tlb, pmdval);
+		else
+			try_to_free_pte(mm, pmd, start, tlb);
+	}
+
 	return addr;
 }
 
diff --git a/mm/pt_reclaim.c a/mm/pt_reclaim.c
new file mode 100644
--- /dev/null
+++ a/mm/pt_reclaim.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/hugetlb.h>
+#include <asm-generic/tlb.h>
+#include <asm/pgalloc.h>
+
+#include "internal.h"
+
+bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
+			   struct zap_details *details)
+{
+	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
+}
+
+bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+{
+	spinlock_t *pml = pmd_lockptr(mm, pmd);
+
+	if (!spin_trylock(pml))
+		return false;
+
+	*pmdval = pmdp_get_lockless(pmd);
+	pmd_clear(pmd);
+	spin_unlock(pml);
+
+	return true;
+}
+
+void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
+	      pmd_t pmdval)
+{
+	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+	mm_dec_nr_ptes(mm);
+}
+
+void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
+		     struct mmu_gather *tlb)
+{
+	pmd_t pmdval;
+	spinlock_t *pml, *ptl;
+	pte_t *start_pte, *pte;
+	int i;
+
+	pml = pmd_lock(mm, pmd);
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
+	if (!start_pte)
+		goto out_ptl;
+	if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
+	/* Check if it is empty PTE page */
+	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
+		if (!pte_none(ptep_get(pte)))
+			goto out_ptl;
+	}
+	pte_unmap(start_pte);
+
+	pmd_clear(pmd);
+
+	if (ptl != pml)
+		spin_unlock(ptl);
+	spin_unlock(pml);
+
+	free_pte(mm, addr, tlb, pmdval);
+
+	return;
+out_ptl:
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (ptl != pml)
+		spin_unlock(pml);
+}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

