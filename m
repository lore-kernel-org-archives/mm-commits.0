Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8A1111BF
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749000840; cv=none; b=ntIh/4TLc/WusFJSZXKupFEWKycm6njxFg0ZKqWvo4ijvKTSgfmsgtPH9WJVTv00WCu9vD3IFMbYyA6idl+WSdKsDMh2UsLoWYEQ+LBNC3MlBD1WTpU04OYVcJqAhroV96+1N+pRHE0JaTx3tyv8lwBNT2KiY1o9u8xzwlTZxy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749000840; c=relaxed/simple;
	bh=z6b9Ldrmx904bhr7+sKjOHKyiBCRVwFEBzIJRT2ewr0=;
	h=Date:To:From:Subject:Message-Id; b=UqxYa1WQjT0KOE3QZRC7Cn4VqQsCZlzO5pRpkyywsV0kc3AOUhlXq88XaeRu8tCO59IdSsbrs6cNgapBQAMTsCANzqvRg8A9DbAjapIpNigmhQX2oIj/AaFy7Jhtw7JhjpGHFFymoE9uiHvQwxwHNrKwlCKzASzGPOQLuxcabiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i4JrAYVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i4JrAYVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F635C4CEED;
	Wed,  4 Jun 2025 01:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749000839;
	bh=z6b9Ldrmx904bhr7+sKjOHKyiBCRVwFEBzIJRT2ewr0=;
	h=Date:To:From:Subject:From;
	b=i4JrAYVWc9Udxjv5gvspji6rkm5E8/kX8n3ZMFe72y3Ig5ArPtk3soe0tPFu8/+nm
	 qU37Z0B1FKqzZgu0K/lCkHrtBKdEnjtIHpesqGBJGaFR4IL7rGtUdZJTyYiZ84VdWg
	 /xcO79XnWH286M4bPDGJq8lTE7G3sbuXcnVGG2ZY=
Date: Tue, 03 Jun 2025 18:33:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stefan.kristiansson@saunalahti.fi,shorne@gmail.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kernel@xen0n.name,jonas@southpole.se,jannh@google.com,david@redhat.com,chenhuacai@kernel.org,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch added to mm-new branch
Message-Id: <20250604013359.9F635C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: split walk_page_range_novma() into kernel/user parts
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/pagewalk: split walk_page_range_novma() into kernel/user parts
Date: Tue, 3 Jun 2025 20:22:13 +0100

walk_page_range_novma() is rather confusing - it supports two modes, one
used often, the other used only for debugging.

The first mode is the common case of traversal of kernel page tables,
which is what nearly all callers use this for.

Secondly it provides an unusual debugging interface that allows for the
traversal of page tables in a userland range of memory even for that
memory which is not described by a VMA.

This is highly unusual and it is far from certain that such page tables
should even exist, but perhaps this is precisely why it is useful as a
debugging mechanism.

As a result, this is utilised by ptdump only.  Historically, things were
reversed - ptdump was the only user, and other parts of the kernel evolved
to use the kernel page table walking here.

Since we have some complicated and confusing locking rules for the novma
case, it makes sense to separate the two usages into their own functions.

Doing this also provide self-documentation as to the intent of the caller
- are they doing something rather unusual or are they simply doing a
standard kernel page table walk?

We therefore maintain walk_page_range_novma() for this single usage, and
document the function as such.

Note that ptdump uses the precise same function for kernel walking as a
convenience, so we permit this but make it very explicit by having
walk_page_range_novma() invoke walk_page_range_kernel() in this case.

We introduce walk_page_range_kernel() for the far more common case of
kernel page table traversal.

While it would result in less churn to keep the function signature the
same for the kernel version, it doesn't make sense to pass an mm_struct in
the kernel case (it's always &init_mm), so we must modify the signature
accordingly.

Link: https://lkml.kernel.org/r/20250603192213.182931-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/mm/pageattr.c |    2 
 arch/openrisc/kernel/dma.c   |    4 -
 arch/riscv/mm/pageattr.c     |    8 +-
 include/linux/pagewalk.h     |    3 +
 mm/hugetlb_vmemmap.c         |    2 
 mm/pagewalk.c                |   96 ++++++++++++++++++++++-----------
 6 files changed, 75 insertions(+), 40 deletions(-)

--- a/arch/loongarch/mm/pageattr.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/loongarch/mm/pageattr.c
@@ -118,7 +118,7 @@ static int __set_memory(unsigned long ad
 		return 0;
 
 	mmap_write_lock(&init_mm);
-	ret = walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL, &masks);
+	ret = walk_page_range_kernel(start, end, &pageattr_ops, NULL, &masks);
 	mmap_write_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
--- a/arch/openrisc/kernel/dma.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/openrisc/kernel/dma.c
@@ -72,7 +72,7 @@ void *arch_dma_set_uncached(void *cpu_ad
 	 * them and setting the cache-inhibit bit.
 	 */
 	mmap_write_lock(&init_mm);
-	error = walk_page_range_novma(&init_mm, va, va + size,
+	error = walk_page_range_kernel(va, va + size,
 			&set_nocache_walk_ops, NULL, NULL);
 	mmap_write_unlock(&init_mm);
 
@@ -87,7 +87,7 @@ void arch_dma_clear_uncached(void *cpu_a
 
 	mmap_write_lock(&init_mm);
 	/* walk_page_range shouldn't be able to fail here */
-	WARN_ON(walk_page_range_novma(&init_mm, va, va + size,
+	WARN_ON(walk_page_range_kernel(va, va + size,
 			&clear_nocache_walk_ops, NULL, NULL));
 	mmap_write_unlock(&init_mm);
 }
--- a/arch/riscv/mm/pageattr.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/arch/riscv/mm/pageattr.c
@@ -299,7 +299,7 @@ static int __set_memory(unsigned long ad
 			if (ret)
 				goto unlock;
 
-			ret = walk_page_range_novma(&init_mm, lm_start, lm_end,
+			ret = walk_page_range_kernel(lm_start, lm_end,
 						    &pageattr_ops, NULL, &masks);
 			if (ret)
 				goto unlock;
@@ -317,13 +317,13 @@ static int __set_memory(unsigned long ad
 		if (ret)
 			goto unlock;
 
-		ret = walk_page_range_novma(&init_mm, lm_start, lm_end,
+		ret = walk_page_range_kernel(lm_start, lm_end,
 					    &pageattr_ops, NULL, &masks);
 		if (ret)
 			goto unlock;
 	}
 
-	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
+	ret =  walk_page_range_kernel(start, end, &pageattr_ops, NULL,
 				     &masks);
 
 unlock:
@@ -335,7 +335,7 @@ unlock:
 	 */
 	flush_tlb_all();
 #else
-	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
+	ret =  walk_page_range_kernel(start, end, &pageattr_ops, NULL,
 				     &masks);
 
 	mmap_write_unlock(&init_mm);
--- a/include/linux/pagewalk.h~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/include/linux/pagewalk.h
@@ -129,6 +129,9 @@ struct mm_walk {
 int walk_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_kernel(unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		pgd_t *pgd, void *private);
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd,
--- a/mm/hugetlb_vmemmap.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/hugetlb_vmemmap.c
@@ -166,7 +166,7 @@ static int vmemmap_remap_range(unsigned
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
 	mmap_read_lock(&init_mm);
-	ret = walk_page_range_novma(&init_mm, start, end, &vmemmap_remap_ops,
+	ret = walk_page_range_kernel(start, end, &vmemmap_remap_ops,
 				    NULL, walk);
 	mmap_read_unlock(&init_mm);
 	if (ret)
--- a/mm/pagewalk.c~mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts
+++ a/mm/pagewalk.c
@@ -584,9 +584,28 @@ int walk_page_range(struct mm_struct *mm
 	return walk_page_range_mm(mm, start, end, ops, private);
 }
 
+static int __walk_page_range_novma(struct mm_struct *mm, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		pgd_t *pgd, void *private)
+{
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= mm,
+		.pgd		= pgd,
+		.private	= private,
+		.no_vma		= true
+	};
+
+	if (start >= end || !walk.mm)
+		return -EINVAL;
+	if (!check_ops_valid(ops))
+		return -EINVAL;
+
+	return walk_pgd_range(start, end, &walk);
+}
+
 /**
- * walk_page_range_novma - walk a range of pagetables not backed by a vma
- * @mm:		mm_struct representing the target process of page table walk
+ * walk_page_range_kernel - walk a range of kernel pagetables.
  * @start:	start address of the virtual address range
  * @end:	end address of the virtual address range
  * @ops:	operation to call during the walk
@@ -596,56 +615,69 @@ int walk_page_range(struct mm_struct *mm
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
+int walk_page_range_kernel(unsigned long start, unsigned long end,
+		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
+{
+	struct mm_struct *mm = &init_mm;
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
+	return __walk_page_range_novma(mm, start, end, ops, pgd, private);
+}
+
+/**
+ * walk_page_range_novma - walk a range of pagetables not backed by a vma
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
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd,
 			  void *private)
 {
-	struct mm_walk walk = {
-		.ops		= ops,
-		.mm		= mm,
-		.pgd		= pgd,
-		.private	= private,
-		.no_vma		= true
-	};
-
-	if (start >= end || !walk.mm)
-		return -EINVAL;
-	if (!check_ops_valid(ops))
-		return -EINVAL;
+	/*
+	 * For convenience, we allow this function to also traverse kernel
+	 * mappings.
+	 */
+	if (mm == &init_mm)
+		return walk_page_range_kernel(start, end, ops, pgd, private);
 
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
 
-	return walk_pgd_range(start, end, &walk);
+	return __walk_page_range_novma(mm, start, end, ops, pgd, private);
 }
 
 int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

