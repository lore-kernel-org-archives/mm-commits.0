From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3.patch added
 to -mm tree
Date: Mon, 08 Jun 2020 18:27:01 -0700
Message-ID: <20200609012701.689wXug68%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgFIB1C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 21:27:02 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, rppt@kernel.org


The patch titled
     Subject: mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3
has been added to the -mm tree.  Its filename is
     mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3

s/pmd_ptr_k/pmd_off_k/ in various places

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/kasan/8xx.c       |    4 ++--
 arch/powerpc/mm/kasan/book3s_32.c |    2 +-
 arch/powerpc/mm/nohash/8xx.c      |    2 +-
 arch/powerpc/mm/pgtable_32.c      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/nohash/8xx.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -74,7 +74,7 @@ static pte_t __init *early_hugepd_alloc_
 static int __ref __early_map_kernel_hugepage(unsigned long va, phys_addr_t pa,
 					     pgprot_t prot, int psize, bool new)
 {
-	pmd_t *pmdp = pmd_ptr_k(va);
+	pmd_t *pmdp = pmd_off_k(va);
 	pte_t *ptep;
 
 	if (WARN_ON(psize != MMU_PAGE_512K && psize != MMU_PAGE_8M))
--- a/arch/powerpc/mm/pgtable_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -40,7 +40,7 @@ notrace void __init early_ioremap_init(v
 {
 	unsigned long addr = ALIGN_DOWN(FIXADDR_START, PGDIR_SIZE);
 	pte_t *ptep = (pte_t *)early_fixmap_pagetable;
-	pmd_t *pmdp = pmd_ptr_k(addr);
+	pmd_t *pmdp = pmd_off_k(addr);
 
 	for (; (s32)(FIXADDR_TOP - addr) > 0;
 	     addr += PGDIR_SIZE, ptep += PTRS_PER_PTE, pmdp++)
--- a/arch/powerpc/mm/kasan/8xx.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3
+++ a/arch/powerpc/mm/kasan/8xx.c
@@ -10,7 +10,7 @@
 static int __init
 kasan_init_shadow_8M(unsigned long k_start, unsigned long k_end, void *block)
 {
-	pmd_t *pmd = pmd_ptr_k(k_start);
+	pmd_t *pmd = pmd_off_k(k_start);
 	unsigned long k_cur, k_next;
 
 	for (k_cur = k_start; k_cur != k_end; k_cur = k_next, pmd += 2, block += SZ_8M) {
@@ -59,7 +59,7 @@ int __init kasan_init_region(void *start
 		return ret;
 
 	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
--- a/arch/powerpc/mm/kasan/book3s_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3
+++ a/arch/powerpc/mm/kasan/book3s_32.c
@@ -46,7 +46,7 @@ int __init kasan_init_region(void *start
 	kasan_update_early_region(k_start, k_cur, __pte(0));
 
 	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-3.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
