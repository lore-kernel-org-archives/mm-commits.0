From: akpm@linux-foundation.org
Subject: + x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch added to -mm tree
Date: Tue, 20 Nov 2012 14:49:10 -0800
Message-ID: <20121120224910.C552C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38273 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2KTWtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 17:49:12 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so746323qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 14:49:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, hpa@zytor.com, mingo@redhat.com, rientjes@google.com, tglx@linutronix.de


The patch titled
     Subject: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to functions
has been added to the -mm tree.  Its filename is
     x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to functions


Converting macros to functions unhide type problems before changes will
be integrated and trigger problems on other architectures.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h    |   12 ++++++++++++
 arch/x86/include/asm/pgtable_32.h |    7 -------
 arch/x86/include/asm/pgtable_64.h |    3 ---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable.h
@@ -775,6 +775,18 @@ static inline void clone_pgd_range(pgd_t
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+/*
+ * The x86 doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+}
+static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd)
+{
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff -puN arch/x86/include/asm/pgtable_32.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -66,13 +66,6 @@ do {						\
 	__flush_tlb_one((vaddr));		\
 } while (0)
 
-/*
- * The i386 doesn't have any external MMU info: the kernel page
- * tables contain all the necessary information.
- */
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff -puN arch/x86/include/asm/pgtable_64.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -142,9 +142,6 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch

