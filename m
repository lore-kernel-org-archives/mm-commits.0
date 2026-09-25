Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D7D43BDC8
	for <mm-commits@vger.kernel.org>; Fri, 25 Sep 2026 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790374950; cv=none; b=NAljeyhxdA1JR0lLy8ti3umYUPnKDRLsl5qkXRuTUnR8bC7cEigfu99WMbWtaXjfQX3QLEt6Od3gCmuGaGtm/Pa4adImEvpJYaXrhMO3xpf6GxBP2Tc+WyRC22KH13KHiUwNJWUHHE6uM6mvA7uFEWYGqFrLq3cWHgYMNbF3jiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790374950; c=relaxed/simple;
	bh=iKVng5DgeYesqwiVXuw7LsLZC7QZwnzNinyzR4VVhXE=;
	h=Date:To:From:Subject:Message-Id; b=PDWl1YHWjQx+hNuNnNGZdF+m0yJ/yg44jfezLk1vUiVYi5Tg8sBJ238x/wRCmvNJRqmQ777s8VuYYSV50vefZ+FlQ8aHpbFe8Vwk5skaolIrvRyQ1CDXe6kaHMNKuyFbyfxXV5HGMMy750MFeCyymuMH1Ct2z27q9MEeiDB0h2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uqXwMYKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uqXwMYKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C63D1F0089B;
	Fri, 25 Sep 2026 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790374948;
	bh=A11Ei6ltt6kw7iGa6fOsHBRtFQ1WDJu0q5nlpVmQw9U=;
	h=Date:To:From:Subject;
	b=uqXwMYKF8JjhBzKN+q2BTRSX/8TQNBhz5s8od54PNe7fesYUHaOGiJXGRI//eSkXJ
	 DN2Bk1oI7NR4k61u3wRotpYTCbTR7ZY/mV1/ZiorgUxay3PDsBo5kfVf/tUqq/PlqI
	 0LFXK7eRWn6PHusBlyTWfFyKsLPJvSBuZofmU7hE=
Date: Fri, 25 Sep 2026 15:22:27 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch removed from -mm tree
Message-Id: <20260925222228.3C63D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
has been removed from the -mm tree.  Its filename was
     mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
Date: Tue, 22 Sep 2026 16:35:40 +0100

sun3 and coldfire are already supported, however motorola requires a
little more care.

Here, custom table removal logic is required, so
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is enabled for m68k-motorola.

Firstly as part of this change, the page table level must be communicated
to the underlying __tlb_remove_table() implementation.

Take advantage of the fact that page tables are aligned by more than
enough to permit setting TABLE_PTE or TABLE_PMD in the low bits of the
pointer, and store this there.

Then update __pte_free_tlb() and __pmd_free_tlb() to pass this through,
then have __tlb_remove_table() decode this and pass it to
free_pointer_table().

The page table freeing is performed via call_rcu(), so
free_pointer_table() now will be invoked from softirq context, and as such
may be re-entrant.

Introduce an irq save/restore spinlock to handle this, and hold it over
the time a given ptable entry is being referenced in both
get_pointer_table() and free_pointer_table().

In order to make things a little easier in this respect, separate out the
logic for adding a new ptable entry into add_pointer_table() and only hold
the lock during ptable entry insertion in this case.

Note that original list_add_tail(new, dp) added new prior to dp, which is
ptable_list[type].next, i.e.  after ptable_list[type].

The equivalent therefore is list_add(new, &ptable_list[type]), which adds
new after ptable_list[type], only without needing to make reference to dp.

Note that, as m68k-motorola specifies CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE,
it does not enable CONFIG_PT_RECLAIM.  This isn't meaningfully impactful.

With this applied, all of m68k implements
CONFIG_MMU_GATHER_RCU_TABLE_FREE.

This forms part of an overall effort to switch every architecture to this
mode.

Link: https://lore.kernel.org/20260922-rcu-pagetable-freeing-v4-9-fe1ad1f1e303@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Guo Ren <guoren@kernel.org>
Cc: Brian Cain <bcain@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Simon Schuster <schuster.simon@siemens-energy.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 arch/m68k/Kconfig                        |    3 
 arch/m68k/include/asm/motorola_pgalloc.h |    9 -
 arch/m68k/mm/motorola.c                  |  121 +++++++++++++--------
 3 files changed, 86 insertions(+), 47 deletions(-)

--- a/arch/m68k/include/asm/motorola_pgalloc.h~mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -17,6 +17,7 @@ enum m68k_table_types {
 extern void init_pointer_table(void *table, int type);
 extern void *get_pointer_table(struct mm_struct *mm, int type);
 extern int free_pointer_table(void *table, int type);
+extern void __tlb_remove_table(void *table);
 
 /*
  * Allocate and free page tables. The xxx_kernel() versions are
@@ -47,7 +48,7 @@ static inline void pte_free(struct mm_st
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
-	free_pointer_table(pgtable, TABLE_PTE);
+	tlb_remove_table(tlb, (void *)((unsigned long)pgtable | TABLE_PTE));
 }
 
 
@@ -61,10 +62,10 @@ static inline int pmd_free(struct mm_str
 	return free_pointer_table(pmd, TABLE_PMD);
 }
 
-static inline int __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
-				 unsigned long address)
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
+				  unsigned long address)
 {
-	return free_pointer_table(pmd, TABLE_PMD);
+	tlb_remove_table(tlb, (void *)((unsigned long)pmd | TABLE_PMD));
 }
 
 
--- a/arch/m68k/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola
+++ a/arch/m68k/Kconfig
@@ -29,6 +29,7 @@ config M68K
 	select HAVE_ARCH_LIBGCC_H
 	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_TLB_REMOVE_TABLE if MMU_MOTOROLA
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !CPU_HAS_NO_UNALIGNED
@@ -36,7 +37,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
--- a/arch/m68k/mm/motorola.c~mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola
+++ a/arch/m68k/mm/motorola.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/gfp.h>
+#include <linux/cleanup.h>
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
@@ -103,6 +104,8 @@ static struct list_head ptable_list[3] =
 	LIST_HEAD_INIT(ptable_list[2]),
 };
 
+static DEFINE_SPINLOCK(ptable_lock);
+
 #define PD_PTABLE(ptdesc) ((ptable_desc *)&(virt_to_ptdesc((void *)(ptdesc))->pt_list))
 #define PD_PTDESC(ptable) (list_entry(ptable, struct ptdesc, pt_list))
 #define PD_MARKBITS(dp) (*(unsigned int *)&PD_PTDESC(dp)->pt_index)
@@ -139,52 +142,66 @@ void __init init_pointer_table(void *tab
 	return;
 }
 
+/*
+ * For a pointer table for a user process address space, a
+ * table is taken from a ptdesc allocated for the purpose.  Each
+ * ptdesc can hold 8 pointer tables.  The ptdesc is remapped in
+ * virtual address space to be noncacheable.
+ */
+static void *add_pointer_table(struct mm_struct *mm, int type)
+{
+	struct ptdesc *ptdesc;
+	ptable_desc *new;
+	void *pt_addr;
+
+	ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!ptdesc)
+		return NULL;
+
+	pt_addr = ptdesc_address(ptdesc);
+
+	switch (type) {
+	case TABLE_PTE:
+		/*
+		 * m68k doesn't have SPLIT_PTE_PTLOCKS for not having
+		 * SMP.
+		 */
+		pagetable_pte_ctor(mm, ptdesc);
+		break;
+	case TABLE_PMD:
+		pagetable_pmd_ctor(mm, ptdesc);
+		break;
+	case TABLE_PGD:
+		pagetable_pgd_ctor(ptdesc);
+		break;
+	}
+
+	mmu_page_ctor(pt_addr);
+
+	new = PD_PTABLE(pt_addr);
+
+	PD_MARKBITS(new) = ptable_mask(type) - 1;
+	scoped_guard(spinlock_irqsave, &ptable_lock)
+		list_add(new, &ptable_list[type]);
+
+	return (pmd_t *)pt_addr;
+}
+
 void *get_pointer_table(struct mm_struct *mm, int type)
 {
-	ptable_desc *dp = ptable_list[type].next;
-	unsigned int mask = list_empty(&ptable_list[type]) ? 0 : PD_MARKBITS(dp);
 	unsigned int tmp, off;
+	unsigned long mask;
+	unsigned long flags;
+	ptable_desc *dp;
+	void *ret;
 
-	/*
-	 * For a pointer table for a user process address space, a
-	 * table is taken from a ptdesc allocated for the purpose.  Each
-	 * ptdesc can hold 8 pointer tables.  The ptdesc is remapped in
-	 * virtual address space to be noncacheable.
-	 */
-	if (mask == 0) {
-		struct ptdesc *ptdesc;
-		ptable_desc *new;
-		void *pt_addr;
-
-		ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
-		if (!ptdesc)
-			return NULL;
-
-		pt_addr = ptdesc_address(ptdesc);
-
-		switch (type) {
-		case TABLE_PTE:
-			/*
-			 * m68k doesn't have SPLIT_PTE_PTLOCKS for not having
-			 * SMP.
-			 */
-			pagetable_pte_ctor(mm, ptdesc);
-			break;
-		case TABLE_PMD:
-			pagetable_pmd_ctor(mm, ptdesc);
-			break;
-		case TABLE_PGD:
-			pagetable_pgd_ctor(ptdesc);
-			break;
-		}
-
-		mmu_page_ctor(pt_addr);
-
-		new = PD_PTABLE(pt_addr);
-		PD_MARKBITS(new) = ptable_mask(type) - 1;
-		list_add_tail(new, dp);
+	spin_lock_irqsave(&ptable_lock, flags);
+	dp = ptable_list[type].next;
+	mask = list_empty(&ptable_list[type]) ? 0 : PD_MARKBITS(dp);
 
-		return (pmd_t *)pt_addr;
+	if (mask == 0) {
+		spin_unlock_irqrestore(&ptable_lock, flags);
+		return add_pointer_table(mm, type);
 	}
 
 	for (tmp = 1, off = 0; (mask & tmp) == 0; tmp <<= 1, off += ptable_size(type))
@@ -194,7 +211,10 @@ void *get_pointer_table(struct mm_struct
 		/* move to end of list */
 		list_move_tail(dp, &ptable_list[type]);
 	}
-	return ptdesc_address(PD_PTDESC(dp)) + off;
+
+	ret = ptdesc_address(PD_PTDESC(dp)) + off;
+	spin_unlock_irqrestore(&ptable_lock, flags);
+	return ret;
 }
 
 int free_pointer_table(void *table, int type)
@@ -203,6 +223,9 @@ int free_pointer_table(void *table, int
 	unsigned long ptable = (unsigned long)table;
 	unsigned long pt_addr = ptable & PAGE_MASK;
 	unsigned int mask = 1U << ((ptable - pt_addr)/ptable_size(type));
+	unsigned long flags;
+
+	spin_lock_irqsave(&ptable_lock, flags);
 
 	dp = PD_PTABLE(pt_addr);
 	if (PD_MARKBITS (dp) & mask)
@@ -213,6 +236,8 @@ int free_pointer_table(void *table, int
 	if (PD_MARKBITS(dp) == ptable_mask(type)) {
 		/* all tables in ptdesc are free, free ptdesc */
 		list_del(dp);
+		spin_unlock_irqrestore(&ptable_lock, flags);
+
 		mmu_page_dtor((void *)pt_addr);
 		pagetable_dtor_free(virt_to_ptdesc((void *)pt_addr));
 		return 1;
@@ -223,9 +248,21 @@ int free_pointer_table(void *table, int
 		 */
 		list_move(dp, &ptable_list[type]);
 	}
+
+	spin_unlock_irqrestore(&ptable_lock, flags);
 	return 0;
 }
 
+void __tlb_remove_table(void *table)
+{
+	/* The bottom 2 bits are used to encode page table type. */
+	const unsigned long encoded = (unsigned long)table;
+	void *addr = (void *)(encoded & ~3UL);
+	const int type = encoded & 3;
+
+	free_pointer_table(addr, type);
+}
+
 /* size of memory already mapped in head.S */
 extern __initdata unsigned long m68k_init_mapped_size;
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
a.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

