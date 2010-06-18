From: akpm@linux-foundation.org
Subject: + gcc-46-mm-fix-unused-but-set-warnings.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:37 -0700
Message-ID: <201006182331.o5INVbCs029553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab0FRXbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     gcc-4.6: mm: fix unused but set warnings
has been added to the -mm tree.  Its filename is
     gcc-46-mm-fix-unused-but-set-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcc-4.6: mm: fix unused but set warnings
From: Andi Kleen <andi@firstfloor.org>

No real bugs, just some dead code and some fixups.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h |    4 ++--
 include/linux/highmem.h           |    6 +++++-
 include/linux/mmdebug.h           |    2 +-
 mm/filemap.c                      |    2 --
 mm/memory.c                       |    2 --
 mm/slab.c                         |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/pgtable_64.h~gcc-46-mm-fix-unused-but-set-warnings arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~gcc-46-mm-fix-unused-but-set-warnings
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -126,8 +126,8 @@ static inline int pgd_large(pgd_t pgd) {
 /* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) /* NOP */
-#define pte_unmap_nested(pte) /* NOP */
+#define pte_unmap(pte) ((void)(pte))/* NOP */
+#define pte_unmap_nested(pte) ((void)(pte)) /* NOP */
 
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
 
diff -puN include/linux/highmem.h~gcc-46-mm-fix-unused-but-set-warnings include/linux/highmem.h
--- a/include/linux/highmem.h~gcc-46-mm-fix-unused-but-set-warnings
+++ a/include/linux/highmem.h
@@ -73,7 +73,11 @@ static inline void *kmap_atomic(struct p
 }
 #define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
 
-#define kunmap_atomic_notypecheck(addr, idx)	do { pagefault_enable(); } while (0)
+static inline void kunmap_atomic_notypecheck(void *addr, enum km_type idx)
+{
+	pagefault_enable();
+}
+
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
diff -puN include/linux/mmdebug.h~gcc-46-mm-fix-unused-but-set-warnings include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~gcc-46-mm-fix-unused-but-set-warnings
+++ a/include/linux/mmdebug.h
@@ -4,7 +4,7 @@
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #else
-#define VM_BUG_ON(cond) do { } while (0)
+#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
diff -puN mm/filemap.c~gcc-46-mm-fix-unused-but-set-warnings mm/filemap.c
--- a/mm/filemap.c~gcc-46-mm-fix-unused-but-set-warnings
+++ a/mm/filemap.c
@@ -2239,14 +2239,12 @@ static ssize_t generic_perform_write(str
 
 	do {
 		struct page *page;
-		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
-		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
 						iov_iter_count(i));
 
diff -puN mm/memory.c~gcc-46-mm-fix-unused-but-set-warnings mm/memory.c
--- a/mm/memory.c~gcc-46-mm-fix-unused-but-set-warnings
+++ a/mm/memory.c
@@ -307,7 +307,6 @@ void free_pgd_range(struct mmu_gather *t
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start;
 
 	/*
 	 * The next few lines have given us lots of grief...
@@ -351,7 +350,6 @@ void free_pgd_range(struct mmu_gather *t
 	if (addr > end - 1)
 		return;
 
-	start = addr;
 	pgd = pgd_offset(tlb->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
diff -puN mm/slab.c~gcc-46-mm-fix-unused-but-set-warnings mm/slab.c
--- a/mm/slab.c~gcc-46-mm-fix-unused-but-set-warnings
+++ a/mm/slab.c
@@ -395,7 +395,7 @@ static void kmem_list3_init(struct kmem_
 #define	STATS_DEC_ACTIVE(x)	do { } while (0)
 #define	STATS_INC_ALLOCED(x)	do { } while (0)
 #define	STATS_INC_GROWN(x)	do { } while (0)
-#define	STATS_ADD_REAPED(x,y)	do { } while (0)
+#define	STATS_ADD_REAPED(x,y)	do { (void)(y); } while (0)
 #define	STATS_SET_HIGH(x)	do { } while (0)
 #define	STATS_INC_ERR(x)	do { } while (0)
 #define	STATS_INC_NODEALLOCS(x)	do { } while (0)
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

