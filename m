Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4706A46EF65
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788902208; cv=none; b=nKEiAaUoju1k+VjW/lECSI3s6hEdrHpc0c95b3tm6BVolyWNMlUsbPRl5RxyFiHh4DSv2e5yshaW4RwHfssX4TvraCosqTE9PnTgn1tHc/25gfvvF9XWPKrzqUaM4DTWbz9MenfIJMeL6zauCMwtDtZ3IR6jbVhk/4v8DinDhYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788902208; c=relaxed/simple;
	bh=RmNwDS7t+/bEECr5PbyClAgIMkRCpM/Kp9hGcIosUJM=;
	h=Date:To:From:Subject:Message-Id; b=sktgD6+rFkygxNSW5TZMsHhdxvvXdqFnBaerxSK0I70IB5imsnaNpglNVzRHdKQ3pxhjWDZfLtaNqU7ZNMASkaH1VrhAOwMA/X0GcXZuV3dU5hBNcX1tmg5tWcfLwN4FRCMxoRqEoIX2DdgbI8T73/yWvThEwRb/z1ntO8FdeUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eso8UeGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eso8UeGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24771F00A3D;
	Tue,  8 Sep 2026 21:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788902205;
	bh=HQU9ZMzMH7d6x7QN40SnhlbJDjLY3BiI+bnx7jETxso=;
	h=Date:To:From:Subject;
	b=eso8UeGmvNRinDdw8/F42fWuc58jk9+NYu5f+I+9AYVJmhH8wO+KTB2tlRJr/VYf5
	 rBUzFVKJdvV/aUWafkCZ2T5azMSRZGREcrZbJ8yc8OsbJSB4Ks97f1FtgPV/HLpnEG
	 118LULIgmky+5TEzGMxzGFEcRidL072EV526cx70=
Date: Tue, 08 Sep 2026 14:16:45 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch added to mm-new branch
Message-Id: <20260908211645.C24771F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
has been added to the -mm mm-new branch.  Its filename is
     mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
Date: Tue, 08 Sep 2026 13:32:19 +0100

Careful handling is required for sparc32 which implements page tables as
part of a shared backing page.

To support this, a custom __tlb_remove_table() function is required, as
specified by CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE.

This allows __pte_free_tlb() and __pmd_free_tlb() to specify which page
table level is being freed, which is transmitted to __tlb_remove_table()
through setting the lowest bit of the page table to 1 for a PMD and 0 for
a PTE (the page tables are 256-byte aligned so this is safe to do).

Next, since the page table freeing is done via RCU callback, and thus
might be executed in softirq context, update the spin locks to IRQ
save/restore.

Then, in __tlb_remove_table(), figure out whether to free a PMD page table
via free_pmd_fast() or a PTE via the newly introduced __pte_free()
function, using the lower bit encoded in __pte_free_tlb() or
__pmd_free_tlb() to determine which to call.

As part of this change use this spin lock rather than mm->page_table_lock
for all shared page table exclusion, as RCU freeing means that page tables
can be freed from soft IRQ context so both don't have an mm and also
mm->page_table_lock is not IRQ-safe.

Note that the specification of CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE disables
CONFIG_PT_RECLAIM for sparc32, which mirrors sparc64.

This forms part of an overall effort to switch every architecture to this
mode, and with it complete, means every architecture now supports
CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Link: https://lore.kernel.org/20260908-rcu-pagetable-freeing-v2-10-1f60b64e878e@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig                  |    2 +
 arch/sparc/include/asm/pgalloc_32.h |    7 ++++-
 arch/sparc/lib/bitext.c             |   14 +++++------
 arch/sparc/mm/srmmu.c               |   32 +++++++++++++++++++++-----
 4 files changed, 41 insertions(+), 14 deletions(-)

--- a/arch/sparc/include/asm/pgalloc_32.h~mm-enable-mmu_gather_rcu_table_free-for-sparc32
+++ a/arch/sparc/include/asm/pgalloc_32.h
@@ -48,7 +48,9 @@ static inline void free_pmd_fast(pmd_t *
 }
 
 #define pmd_free(mm, pmd)		free_pmd_fast(pmd)
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+
+#define __pmd_free_tlb(tlb, pmd, addr)					\
+	tlb_remove_table((tlb), (void *)((unsigned long)(pmd) | 1UL))
 
 #define pmd_populate(mm, pmd, pte)	pmd_set(pmd, pte)
 
@@ -72,6 +74,7 @@ static inline void free_pte_fast(pte_t *
 #define pte_free_kernel(mm, pte)	free_pte_fast(pte)
 
 void pte_free(struct mm_struct * mm, pgtable_t pte);
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+void __tlb_remove_table(void *table);
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_table((tlb), (void *)(pte))
 
 #endif /* _SPARC_PGALLOC_H */
--- a/arch/sparc/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-sparc32
+++ a/arch/sparc/Kconfig
@@ -64,6 +64,8 @@ config SPARC32
 	select HAVE_UID16
 	select HAVE_PAGE_SIZE_4KB
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select OLD_SIGACTION
 	select ZONE_DMA
 
--- a/arch/sparc/lib/bitext.c~mm-enable-mmu_gather_rcu_table_free-for-sparc32
+++ a/arch/sparc/lib/bitext.c
@@ -22,8 +22,6 @@
  * @align: requested alignment
  *
  * Returns offset in the map or -1 if out of space.
- *
- * Not safe to call from an interrupt (uses spin_lock).
  */
 int bit_map_string_get(struct bit_map *t, int len, int align)
 {
@@ -31,6 +29,7 @@ int bit_map_string_get(struct bit_map *t
 	int off_new;
 	int align1;
 	int i, color;
+	unsigned long flags;
 
 	if (t->num_colors) {
 		/* align is overloaded to be the page color */
@@ -50,7 +49,7 @@ int bit_map_string_get(struct bit_map *t
 		BUG();
 	color &= align1;
 
-	spin_lock(&t->lock);
+	spin_lock_irqsave(&t->lock, flags);
 	if (len < t->last_size)
 		offset = t->first_free;
 	else
@@ -64,7 +63,7 @@ int bit_map_string_get(struct bit_map *t
 		if (offset >= t->size)
 			offset = 0;
 		if (count + len > t->size) {
-			spin_unlock(&t->lock);
+			spin_unlock_irqrestore(&t->lock, flags);
 /* P3 */ printk(KERN_ERR
   "bitmap out: size %d used %d off %d len %d align %d count %d\n",
   t->size, t->used, offset, len, align, count);
@@ -90,7 +89,7 @@ int bit_map_string_get(struct bit_map *t
 					t->last_off = 0;
 				t->used += len;
 				t->last_size = len;
-				spin_unlock(&t->lock);
+				spin_unlock_irqrestore(&t->lock, flags);
 				return offset;
 			}
 		}
@@ -103,10 +102,11 @@ int bit_map_string_get(struct bit_map *t
 void bit_map_clear(struct bit_map *t, int offset, int len)
 {
 	int i;
+	unsigned long flags;
 
 	if (t->used < len)
 		BUG();		/* Much too late to do any good, but alas... */
-	spin_lock(&t->lock);
+	spin_lock_irqsave(&t->lock, flags);
 	for (i = 0; i < len; i++) {
 		if (test_bit(offset + i, t->map) == 0)
 			BUG();
@@ -115,7 +115,7 @@ void bit_map_clear(struct bit_map *t, in
 	if (offset < t->first_free)
 		t->first_free = offset;
 	t->used -= len;
-	spin_unlock(&t->lock);
+	spin_unlock_irqrestore(&t->lock, flags);
 }
 
 void bit_map_init(struct bit_map *t, unsigned long *map, int size)
--- a/arch/sparc/mm/srmmu.c~mm-enable-mmu_gather_rcu_table_free-for-sparc32
+++ a/arch/sparc/mm/srmmu.c
@@ -340,38 +340,60 @@ pgd_t *get_pgd_fast(void)
  * Alignments up to the page size are the same for physical and virtual
  * addresses of the nocache area.
  */
+
+static DEFINE_SPINLOCK(pte_page_lock);
+
 pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
+	unsigned long flags;
 	pte_t *ptep;
 	struct page *page;
 
 	if (!(ptep = pte_alloc_one_kernel(mm)))
 		return NULL;
 	page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> PAGE_SHIFT);
-	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pte_page_lock, flags);
 	if (page_ref_inc_return(page) == 2 &&
 			!pagetable_pte_ctor(mm, page_ptdesc(page))) {
 		page_ref_dec(page);
 		ptep = NULL;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock_irqrestore(&pte_page_lock, flags);
 
 	return ptep;
 }
 
-void pte_free(struct mm_struct *mm, pgtable_t ptep)
+static void __pte_free(pgtable_t ptep)
 {
 	struct page *page;
+	unsigned long flags;
 
 	page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> PAGE_SHIFT);
-	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pte_page_lock, flags);
 	if (page_ref_dec_return(page) == 1)
 		pagetable_dtor(page_ptdesc(page));
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock_irqrestore(&pte_page_lock, flags);
 
 	srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
 }
 
+void pte_free(struct mm_struct *mm, pgtable_t ptep)
+{
+	__pte_free(ptep);
+}
+
+void __tlb_remove_table(void *table)
+{
+	const unsigned long encoded = (unsigned long)table;
+	const unsigned long addr = encoded & ~1UL;
+	const bool is_pmd = encoded & 1;
+
+	if (is_pmd)
+		free_pmd_fast((pmd_t *)addr);
+	else
+		__pte_free((pgtable_t)addr);
+}
+
 /* context handling - a dynamically sized pool is used */
 #define NO_CONTEXT	-1
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch

