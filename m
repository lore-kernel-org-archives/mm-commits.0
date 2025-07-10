Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B559D28541A
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126269; cv=none; b=iyGeNaSR66vPr7cRc11yt5o7CWdKhCZFxPihp5STrgmrc93QrnBQ6sX4Kht9NCFg9ftZHMJXVQdTuFHQUlMnLDnIwl1g2xOiFBVzEAnUrhufRfdKudTfMvO1Hg2XoPHRsyf1DIXsm/b4G/BeCPT2P7pyu765OZzULKzICmnYbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126269; c=relaxed/simple;
	bh=WRUs32BN9Y/nJIpH6buHm2MJzmeAqDWiI1wVveS532A=;
	h=Date:To:From:Subject:Message-Id; b=IoltWvykucdZf9rkl00ETSkA06xg6WF2DPrxQ6O0TXvyN1TPQbIx5MG6U39yTSoKHrno6h9y+gurGczEK3xKErOnftYfRewB6vRdNu2VWBPELAeY5H154fkip2JemaTTETLrX2qrAqv+SKhohnclGdlpvQQDbJEy6ffQlzd7NGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wS93e9rI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wS93e9rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F251C4CEE3;
	Thu, 10 Jul 2025 05:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126269;
	bh=WRUs32BN9Y/nJIpH6buHm2MJzmeAqDWiI1wVveS532A=;
	h=Date:To:From:Subject:From;
	b=wS93e9rIQNrp6Fj+V7lA8JbdKiY8TMTWldkD15kE26kU9QDSz92XtGgZ1ptpu8gLa
	 DizYsJRnQt3Y3QszueoDocJGtJWOJ2R8eH1ox0HLu38svixHapz6zfrBJqxddGgl+y
	 I7YYJSd1K9oaZ/tjqieUDIvX/Yj5w/OisSIOYsGA=
Date: Wed, 09 Jul 2025 22:44:29 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,stefan.kristiansson@saunalahti.fi,shorne@gmail.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kernel@xen0n.name,jonas@southpole.se,jannh@google.com,david@redhat.com,chenhuacai@kernel.org,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch removed from -mm tree
Message-Id: <20250710054429.7F251C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: split walk_page_range_novma() into kernel/user parts
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/pagewalk: split walk_page_range_novma() into kernel/user parts
Date: Thu, 5 Jun 2025 14:51:04 +0100

walk_page_range_novma() is rather confusing - it supports two modes, one
used often, the other used only for debugging.

The first mode is the common case of traversal of kernel page tables,
which is what nearly all callers use this for.

Secondly it provides an unusual debugging interface that allows for the
traversal of page tables in a userland range of memory even for that
memory which is not described by a VMA.

It is far from certain that such page tables should even exist, but
perhaps this is precisely why it is useful as a debugging mechanism.

As a result, this is utilised by ptdump only.  Historically, things were
reversed - ptdump was the only user, and other parts of the kernel evolved
to use the kernel page table walking here.

Since we have some complicated and confusing locking rules for the novma
case, it makes sense to separate the two usages into their own functions.

Doing this also provide self-documentation as to the intent of the caller
- are they doing something rather unusual or are they simply doing a
standard kernel page table walk?

We therefore establish two separate functions - walk_page_range_debug()
for this single usage, and walk_kernel_page_table_range() for general
kernel page table walking.

The walk_page_range_debug() function is currently used to traverse both
userland and kernel mappings, so we maintain this and in the case of
kernel mappings being traversed, we have walk_page_range_debug() invoke
walk_kernel_page_table_range() internally.

We additionally make walk_page_range_debug() internal to mm.

Link: https://lkml.kernel.org/r/20250605135104.90720-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Barry Song <baohua@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/mm/pageattr.c |    2 
 arch/openrisc/kernel/dma.c   |    4 -
 arch/riscv/mm/pageattr.c     |    8 +--
 include/linux/pagewalk.h     |    7 +--
 mm/hugetlb_vmemmap.c         |    2 
 mm/internal.h                |    3 +
 mm/pagewalk.c                |   77 +++++++++++++++++++++++----------
 mm/ptdump.c                  |    3 -
 8 files changed, 71 insertions(+), 35 deletions(-)

--- a/arch/loongarch/mm/pageattr.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/loongarch/mm/pageattr.c
@@ -118,7 +118,7 @@ static int __set_memory(unsigned long ad
 		return 0;
 
 	mmap_write_lock(&init_mm);
-	ret = walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL, &masks);
+	ret = walk_kernel_page_table_range(start, end, &pageattr_ops, NULL, &masks);
 	mmap_write_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
--- a/arch/openrisc/kernel/dma.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/openrisc/kernel/dma.c
@@ -72,7 +72,7 @@ void *arch_dma_set_uncached(void *cpu_ad
 	 * them and setting the cache-inhibit bit.
 	 */
 	mmap_write_lock(&init_mm);
-	error = walk_page_range_novma(&init_mm, va, va + size,
+	error = walk_kernel_page_table_range(va, va + size,
 			&set_nocache_walk_ops, NULL, NULL);
 	mmap_write_unlock(&init_mm);
 
@@ -87,7 +87,7 @@ void arch_dma_clear_uncached(void *cpu_a
 
 	mmap_write_lock(&init_mm);
 	/* walk_page_range shouldn't be able to fail here */
-	WARN_ON(walk_page_range_novma(&init_mm, va, va + size,
+	WARN_ON(walk_kernel_page_table_range(va, va + size,
 			&clear_nocache_walk_ops, NULL, NULL));
 	mmap_write_unlock(&init_mm);
 }
--- a/arch/riscv/mm/pageattr.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/riscv/mm/pageattr.c
@@ -299,7 +299,7 @@ static int __set_memory(unsigned long ad
 			if (ret)
 				goto unlock;
 
-			ret = walk_page_range_novma(&init_mm, lm_start, lm_end,
+			ret = walk_kernel_page_table_range(lm_start, lm_end,
 						    &pageattr_ops, NULL, &masks);
 			if (ret)
 				goto unlock;
@@ -317,13 +317,13 @@ static int __set_memory(unsigned long ad
 		if (ret)
 			goto unlock;
 
-		ret = walk_page_range_novma(&init_mm, lm_start, lm_end,
+		ret = walk_kernel_page_table_range(lm_start, lm_end,
 					    &pageattr_ops, NULL, &masks);
 		if (ret)
 			goto unlock;
 	}
 
-	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
+	ret =  walk_kernel_page_table_range(start, end, &pageattr_ops, NULL,
 				     &masks);
 
 unlock:
@@ -335,7 +335,7 @@ unlock:
 	 */
 	flush_tlb_all();
 #else
-	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
+	ret =  walk_kernel_page_table_range(start, end, &pageattr_ops, NULL,
 				     &masks);
 
 	mmap_write_unlock(&init_mm);
--- a/include/linux/pagewalk.h~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/include/linux/pagewalk.h
@@ -129,10 +129,9 @@ struct mm_walk {
 int walk_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
-int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
-			  unsigned long end, const struct mm_walk_ops *ops,
-			  pgd_t *pgd,
-			  void *private);
+int walk_kernel_page_table_range(unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		pgd_t *pgd, void *private);
 int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, const struct mm_walk_ops *ops,
 			void *private);
--- a/mm/hugetlb_vmemmap.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/hugetlb_vmemmap.c
@@ -166,7 +166,7 @@ static int vmemmap_remap_range(unsigned
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
 	mmap_read_lock(&init_mm);
-	ret = walk_page_range_novma(&init_mm, start, end, &vmemmap_remap_ops,
+	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
 				    NULL, walk);
 	mmap_read_unlock(&init_mm);
 	if (ret)
--- a/mm/internal.h~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/internal.h
@@ -1604,6 +1604,9 @@ static inline void accept_page(struct pa
 int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
+			  unsigned long end, const struct mm_walk_ops *ops,
+			  pgd_t *pgd, void *private);
 
 /* pt_reclaim.c */
 bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
--- a/mm/pagewalk.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/pagewalk.c
@@ -585,8 +585,7 @@ int walk_page_range(struct mm_struct *mm
 }
 
 /**
- * walk_page_range_novma - walk a range of pagetables not backed by a vma
- * @mm:		mm_struct representing the target process of page table walk
+ * walk_kernel_page_table_range - walk a range of kernel pagetables.
  * @start:	start address of the virtual address range
  * @end:	end address of the virtual address range
  * @ops:	operation to call during the walk
@@ -596,17 +595,61 @@ int walk_page_range(struct mm_struct *mm
  * Similar to walk_page_range() but can walk any page tables even if they are
  * not backed by VMAs. Because 'unusual' entries may be walked this function
  * will also not lock the PTEs for the pte_entry() callback. This is useful for
- * walking the kernel pages tables or page tables for firmware.
+ * walking kernel pages tables or page tables for firmware.
  *
  * Note: Be careful to walk the kernel pages tables, the caller may be need to
  * take other effective approaches (mmap lock may be insufficient) to prevent
  * the intermediate kernel page tables belonging to the specified address range
  * from being freed (e.g. memory hot-remove).
  */
-int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
+int walk_kernel_page_table_range(unsigned long start, unsigned long end,
+		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
+{
+	struct mm_struct *mm = &init_mm;
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= mm,
+		.pgd		= pgd,
+		.private	= private,
+		.no_vma		= true
+	};
+
+	if (start >= end)
+		return -EINVAL;
+	if (!check_ops_valid(ops))
+		return -EINVAL;
+
+	/*
+	 * Kernel intermediate page tables are usually not freed, so the mmap
+	 * read lock is sufficient. But there are some exceptions.
+	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
+	 * to prevent the intermediate kernel pages tables belonging to the
+	 * specified address range from being freed. The caller should take
+	 * other actions to prevent this race.
+	 */
+	mmap_assert_locked(mm);
+
+	return walk_pgd_range(start, end, &walk);
+}
+
+/**
+ * walk_page_range_debug - walk a range of pagetables not backed by a vma
+ * @mm:		mm_struct representing the target process of page table walk
+ * @start:	start address of the virtual address range
+ * @end:	end address of the virtual address range
+ * @ops:	operation to call during the walk
+ * @pgd:	pgd to walk if different from mm->pgd
+ * @private:	private data for callbacks' usage
+ *
+ * Similar to walk_page_range() but can walk any page tables even if they are
+ * not backed by VMAs. Because 'unusual' entries may be walked this function
+ * will also not lock the PTEs for the pte_entry() callback.
+ *
+ * This is for debugging purposes ONLY.
+ */
+int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
-			  pgd_t *pgd,
-			  void *private)
+			  pgd_t *pgd, void *private)
 {
 	struct mm_walk walk = {
 		.ops		= ops,
@@ -616,34 +659,24 @@ int walk_page_range_novma(struct mm_stru
 		.no_vma		= true
 	};
 
+	/* For convenience, we allow traversal of kernel mappings. */
+	if (mm == &init_mm)
+		return walk_kernel_page_table_range(start, end, ops,
+						    pgd, private);
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 	if (!check_ops_valid(ops))
 		return -EINVAL;
 
 	/*
-	 * 1) For walking the user virtual address space:
-	 *
 	 * The mmap lock protects the page walker from changes to the page
 	 * tables during the walk.  However a read lock is insufficient to
 	 * protect those areas which don't have a VMA as munmap() detaches
 	 * the VMAs before downgrading to a read lock and actually tearing
 	 * down PTEs/page tables. In which case, the mmap write lock should
-	 * be hold.
-	 *
-	 * 2) For walking the kernel virtual address space:
-	 *
-	 * The kernel intermediate page tables usually do not be freed, so
-	 * the mmap map read lock is sufficient. But there are some exceptions.
-	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
-	 * to prevent the intermediate kernel pages tables belonging to the
-	 * specified address range from being freed. The caller should take
-	 * other actions to prevent this race.
+	 * be held.
 	 */
-	if (mm == &init_mm)
-		mmap_assert_locked(walk.mm);
-	else
-		mmap_assert_write_locked(walk.mm);
+	mmap_assert_write_locked(mm);
 
 	return walk_pgd_range(start, end, &walk);
 }
--- a/mm/ptdump.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/ptdump.c
@@ -4,6 +4,7 @@
 #include <linux/debugfs.h>
 #include <linux/ptdump.h>
 #include <linux/kasan.h>
+#include "internal.h"
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 /*
@@ -177,7 +178,7 @@ void ptdump_walk_pgd(struct ptdump_state
 
 	mmap_write_lock(mm);
 	while (range->start != range->end) {
-		walk_page_range_novma(mm, range->start, range->end,
+		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

