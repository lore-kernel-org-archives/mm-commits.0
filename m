From: akpm@linux-foundation.org
Subject: + mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
 added to -mm tree
Date: Mon, 26 Jan 2015 12:04:11 -0800
Message-ID: <54c69dbb.9IbFgxgVUFfaIvqP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZUEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 15:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, gxt@mprc.pku.edu.cn, james.hogan@imgtec.com, linux@arm.linux.org.uk, nm@ti.com, tyler.baker@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix false-positive warning on exit due mm_nr_pmds(mm)
has been added to the -mm tree.  Its filename is
     mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch

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
Subject: mm: fix false-positive warning on exit due mm_nr_pmds(mm)

The problem is that we check nr_ptes/nr_pmds in exit_mmap() which happens
*before* pgd_free().  And if an arch does pte/pmd allocation in
pgd_alloc() and frees them in pgd_free() we see offset in counters by the
time of the checks.

We tried to workaround this by offsetting expected counter value according
to FIRST_USER_ADDRESS for both nr_pte and nr_pmd in exit_mmap().  But it
doesn't work in some cases:

1. ARM with LPAE enabled also has non-zero USER_PGTABLES_CEILING, but
   upper addresses occupied with huge pmd entries, so the trick with
   offsetting expected counter value will get really ugly: we will have
   to apply it nr_pmds, but not nr_ptes.

2. Metag has non-zero FIRST_USER_ADDRESS, but doesn't do allocation
   pte/pmd page tables allocation in pgd_alloc(), just setup a pgd entry
   which is allocated at boot and shared accross all processes.

The proposal is to move the check to check_mm() which happens *after*
pgd_free() and do proper accounting during pgd_alloc() and pgd_free()
which would bring counters to zero if nothing leaked.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Tyler Baker <tyler.baker@linaro.org>
Tested-by: Nishanth Menon <nm@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c       |    4 ++++
 arch/unicore32/mm/pgd.c |    3 +++
 kernel/fork.c           |    8 ++++++++
 mm/mmap.c               |    5 -----
 4 files changed, 15 insertions(+), 5 deletions(-)

diff -puN arch/arm/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm
+++ a/arch/arm/mm/pgd.c
@@ -97,6 +97,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 no_pte:
 	pmd_free(mm, new_pmd);
+	mm_dec_nr_pmds(mm);
 no_pmd:
 	pud_free(mm, new_pud);
 no_pud:
@@ -130,9 +131,11 @@ void pgd_free(struct mm_struct *mm, pgd_
 	pte = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free(mm, pte);
+	atomic_long_dec(&mm->nr_ptes);
 no_pmd:
 	pud_clear(pud);
 	pmd_free(mm, pmd);
+	mm_dec_nr_pmds(mm);
 no_pud:
 	pgd_clear(pgd);
 	pud_free(mm, pud);
@@ -152,6 +155,7 @@ no_pgd:
 		pmd = pmd_offset(pud, 0);
 		pud_clear(pud);
 		pmd_free(mm, pmd);
+		mm_dec_nr_pmds(mm);
 		pgd_clear(pgd);
 		pud_free(mm, pud);
 	}
diff -puN arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm arch/unicore32/mm/pgd.c
--- a/arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm
+++ a/arch/unicore32/mm/pgd.c
@@ -69,6 +69,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm
 
 no_pte:
 	pmd_free(mm, new_pmd);
+	mm_dec_nr_pmds(mm);
 no_pmd:
 	free_pages((unsigned long)new_pgd, 0);
 no_pgd:
@@ -96,7 +97,9 @@ void free_pgd_slow(struct mm_struct *mm,
 	pte = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free(mm, pte);
+	atomic_long_dec(&mm->nr_ptes);
 	pmd_free(mm, pmd);
+	mm_dec_nr_pmds(mm)
 free:
 	free_pages((unsigned long) pgd, 0);
 }
diff -puN kernel/fork.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm kernel/fork.c
--- a/kernel/fork.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm
+++ a/kernel/fork.c
@@ -606,6 +606,14 @@ static void check_mm(struct mm_struct *m
 			printk(KERN_ALERT "BUG: Bad rss-counter state "
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
+
+	if (atomic_long_read(&mm->nr_ptes))
+		pr_alert("BUG: non-zero nr_ptes on freeing mm: %ld",
+				atomic_long_read(&mm->nr_ptes));
+	if (mm_nr_pmds(mm))
+		pr_alert("BUG: non-zero nr_pmds on freeing mm: %ld",
+				mm_nr_pmds(mm));
+
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	VM_BUG_ON_MM(mm->pmd_huge_pte, mm);
 #endif
diff -puN mm/mmap.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm mm/mmap.c
--- a/mm/mmap.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm
+++ a/mm/mmap.c
@@ -2851,11 +2851,6 @@ void exit_mmap(struct mm_struct *mm)
 		vma = remove_vma(vma);
 	}
 	vm_unacct_memory(nr_accounted);
-
-	WARN_ON(atomic_long_read(&mm->nr_ptes) >
-			round_up(FIRST_USER_ADDRESS, PMD_SIZE) >> PMD_SHIFT);
-	WARN_ON(mm_nr_pmds(mm) >
-			round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers-fix.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch

