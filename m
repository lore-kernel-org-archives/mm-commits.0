From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch added to -mm
 tree
Date: Thu, 21 May 2020 11:30:06 -0700
Message-ID: <20200521183006.JJtIVGylS%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgEUSaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 May 2020 14:30:07 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, James.Bottomley@HansenPartnership.com, lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: arch/parisc/include/asm/pgtable.h: remove unused `old_pte'
has been added to the -mm tree.  Its filename is
     arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch

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
Subject: arch/parisc/include/asm/pgtable.h: remove unused `old_pte'

parisc's set_pte_at() macro has set-but-not-used variable.

include/linux/pgtable.h: In function 'pte_clear_not_present_full':
arch/parisc/include/asm/pgtable.h:96:9: warning: variable 'old_pte' set but not used [-Wunused-but-set-variable]

Reported-by: kbuild test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h~arch-parisc-include-asm-pgtableh-remove-unused-old_pte
+++ a/arch/parisc/include/asm/pgtable.h
@@ -93,10 +93,8 @@ static inline void purge_tlb_entries(str
 
 #define set_pte_at(mm, addr, ptep, pteval)			\
 	do {							\
-		pte_t old_pte;					\
 		unsigned long flags;				\
 		spin_lock_irqsave(pgd_spinlock((mm)->pgd), flags);\
-		old_pte = *ptep;				\
 		set_pte(ptep, pteval);				\
 		purge_tlb_entries(mm, addr);			\
 		spin_unlock_irqrestore(pgd_spinlock((mm)->pgd), flags);\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
padata-initialize-earlier-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-rejects.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
