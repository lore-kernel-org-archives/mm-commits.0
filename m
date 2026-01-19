Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303892DA768
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768861300; cv=none; b=WlkwTQVqqrT1J73fR6Nial22AGYGhHrFY4vrmRqbMW1DF2fbuGOVDISAiBFycH3OCx/+UHL5kbRF4tIAcFolXvxu003Dxz7CgayxHtOgYEdQ4VdCAz8JSDVF2UHsqYbjPhnXkxhO4n+XzDoL9wr5ApXX1zTqVg+mhpStNUV+kDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768861300; c=relaxed/simple;
	bh=NbfmCRvEzuRTr8Kqn9LLA2lykPBIi2LDreE7sKD3voE=;
	h=Date:To:From:Subject:Message-Id; b=LvSWt3oO6/p5Q/tUqttZxutRpNjKgYPwx1IlhT3aUxuzWdgiUO9X1MYioodnKWrxVx813D0X9kTGOhYZgMmgpDeyKV+ggpE+Wwgn5oLCTC1MU12rV/R/Twcrx0R2FTKLpLEjNzLX/kv+RJPmXza1EwUpCfMhwHWw+TYw2kNhDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dyv0pUV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dyv0pUV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C59BC2BC86;
	Mon, 19 Jan 2026 22:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768861297;
	bh=NbfmCRvEzuRTr8Kqn9LLA2lykPBIi2LDreE7sKD3voE=;
	h=Date:To:From:Subject:From;
	b=Dyv0pUV6VqXSZilEdL9cq9Xwcmroz9DYVeZcSCBRSUEx14vmgYDKb5HyP89YqBEjH
	 lxchbA7h65L3B9a6AAh0D8c+twk+KioTEhSnJQR9Q34m0Kvc3+8YSxY6USKwYfNA8d
	 PqfwxgZ6uxKQ81mf5N1xjVOpwUldjBMqiOZYwxRg=
Date: Mon, 19 Jan 2026 14:21:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-pte-table-reclaim-code-to-memoryc.patch added to mm-unstable branch
Message-Id: <20260119222137.9C59BC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move pte table reclaim code to memory.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-pte-table-reclaim-code-to-memoryc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-pte-table-reclaim-code-to-memoryc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm: move pte table reclaim code to memory.c
Date: Mon, 19 Jan 2026 23:07:07 +0100

Some cleanups for PT table reclaim code, triggered by a false-positive
warning we might start to see soon after we unlocked pt-reclaim on
architectures besides x86-64.


This patch (of 2):

The pte-table reclaim code is only called from memory.c, while zapping
pages, and it better also stays that way in the long run.  If we ever have
to call it from other files, we should expose proper high-level helpers
for zapping if the existing helpers are not good enough.

So, let's move the code over (it's not a lot) and slightly clean it up a
bit by:
- Renaming the functions.
- Dropping the "Check if it is empty PTE page" comment, which is now
  self-explaining given the function name.
- Making zap_pte_table_if_empty() return whether zapping worked so the
  caller can free it.
- Adding a comment in pte_table_reclaim_possible().
- Inlining free_pte() in the last remaining user.
- In zap_empty_pte_table(), switch from pmdp_get_lcokless() to
  pmd_clear(), we are holding the PMD PT lock.

By moving the code over, compilers can also easily figure out when
zap_empty_pte_table() does not initialize the pmdval variable, avoiding
false-positive warnings about the variable possibly not being initialized.

Link: https://lkml.kernel.org/r/20260119220708.3438514-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260119220708.3438514-2-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS     |    1 
 mm/Makefile     |    1 
 mm/internal.h   |   18 -----------
 mm/memory.c     |   68 +++++++++++++++++++++++++++++++++++++++----
 mm/pt_reclaim.c |   72 ----------------------------------------------
 5 files changed, 62 insertions(+), 98 deletions(-)

--- a/MAINTAINERS~mm-move-pte-table-reclaim-code-to-memoryc
+++ a/MAINTAINERS
@@ -16685,7 +16685,6 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	mm/pt_reclaim.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
--- a/mm/internal.h~mm-move-pte-table-reclaim-code-to-memoryc
+++ a/mm/internal.h
@@ -1743,24 +1743,6 @@ int walk_page_range_debug(struct mm_stru
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd, void *private);
 
-/* pt_reclaim.c */
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval);
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb);
-
-#ifdef CONFIG_PT_RECLAIM
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details);
-#else
-static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-					 struct zap_details *details)
-{
-	return false;
-}
-#endif /* CONFIG_PT_RECLAIM */
-
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
--- a/mm/Makefile~mm-move-pte-table-reclaim-code-to-memoryc
+++ a/mm/Makefile
@@ -146,5 +146,4 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
-obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
--- a/mm/memory.c~mm-move-pte-table-reclaim-code-to-memoryc
+++ a/mm/memory.c
@@ -1821,11 +1821,68 @@ static inline int do_zap_pte_range(struc
 	return nr;
 }
 
+static bool pte_table_reclaim_possible(unsigned long start, unsigned long end,
+		struct zap_details *details)
+{
+	if (!IS_ENABLED(CONFIG_PT_RECLAIM))
+		return false;
+	/* Only zap if we are allowed to and cover the full page table. */
+	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
+}
+
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+{
+	spinlock_t *pml = pmd_lockptr(mm, pmd);
+
+	if (!spin_trylock(pml))
+		return false;
+
+	*pmdval = pmdp_get(pmd);
+	pmd_clear(pmd);
+	spin_unlock(pml);
+	return true;
+}
+
+static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
+		unsigned long addr, pmd_t *pmdval)
+{
+	spinlock_t *pml, *ptl = NULL;
+	pte_t *start_pte, *pte;
+	int i;
+
+	pml = pmd_lock(mm, pmd);
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, pmdval, &ptl);
+	if (!start_pte)
+		goto out_ptl;
+	if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
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
+	return true;
+out_ptl:
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (ptl != pml)
+		spin_unlock(pml);
+	return false;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
 {
+	bool can_reclaim_pt = pte_table_reclaim_possible(addr, end, details);
 	bool force_flush = false, force_break = false;
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
@@ -1834,7 +1891,6 @@ static unsigned long zap_pte_range(struc
 	pte_t *pte;
 	pmd_t pmdval;
 	unsigned long start = addr;
-	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
 	bool direct_reclaim = true;
 	int nr;
 
@@ -1875,7 +1931,7 @@ retry:
 	 * from being repopulated by another thread.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
 	lazy_mmu_mode_disable();
@@ -1904,10 +1960,10 @@ retry:
 	}
 
 	if (can_reclaim_pt) {
-		if (direct_reclaim)
-			free_pte(mm, start, tlb, pmdval);
-		else
-			try_to_free_pte(mm, pmd, start, tlb);
+		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			mm_dec_nr_ptes(mm);
+		}
 	}
 
 	return addr;
diff --git a/mm/pt_reclaim.c a/mm/pt_reclaim.c
deleted file mode 100644
--- a/mm/pt_reclaim.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/hugetlb.h>
-#include <linux/pgalloc.h>
-
-#include <asm/tlb.h>
-
-#include "internal.h"
-
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details)
-{
-	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
-}
-
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
-{
-	spinlock_t *pml = pmd_lockptr(mm, pmd);
-
-	if (!spin_trylock(pml))
-		return false;
-
-	*pmdval = pmdp_get_lockless(pmd);
-	pmd_clear(pmd);
-	spin_unlock(pml);
-
-	return true;
-}
-
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval)
-{
-	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
-	mm_dec_nr_ptes(mm);
-}
-
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb)
-{
-	pmd_t pmdval;
-	spinlock_t *pml, *ptl = NULL;
-	pte_t *start_pte, *pte;
-	int i;
-
-	pml = pmd_lock(mm, pmd);
-	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
-	if (!start_pte)
-		goto out_ptl;
-	if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-	/* Check if it is empty PTE page */
-	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
-		if (!pte_none(ptep_get(pte)))
-			goto out_ptl;
-	}
-	pte_unmap(start_pte);
-
-	pmd_clear(pmd);
-
-	if (ptl != pml)
-		spin_unlock(ptl);
-	spin_unlock(pml);
-
-	free_pte(mm, addr, tlb, pmdval);
-
-	return;
-out_ptl:
-	if (start_pte)
-		pte_unmap_unlock(start_pte, ptl);
-	if (ptl != pml)
-		spin_unlock(pml);
-}
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch
vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch
vmw_balloon-remove-vmballoon_compaction_init.patch
powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch
mm-balloon_compaction-centralize-basic-page-migration-handling.patch
mm-balloon_compaction-centralize-adjust_managed_page_count-handling.patch
vmw_balloon-stop-using-the-balloon_dev_info-lock.patch
mm-balloon_compaction-use-a-device-independent-balloon-list-lock.patch
mm-balloon_compaction-remove-dependency-on-page-lock.patch
mm-balloon_compaction-make-balloon_mops-static.patch
mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch
drivers-virtio-virtio_balloon-stop-using-balloon_page_push-pop.patch
mm-balloon_compaction-remove-balloon_page_push-pop.patch
mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc.patch
mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch
mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch
mm-balloon_compaction-remove-extern-from-functions.patch
mm-vmscan-drop-inclusion-of-balloon_compactionh.patch
mm-rename-balloon_compactionch-to-balloonch.patch
mm-kconfig-make-balloon_compaction-depend-on-migration.patch
mm-rename-config_balloon_compaction-to-config_balloon_migration.patch
mm-rename-config_memory_balloon-config_balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon-fix.patch

