From: akpm@linux-foundation.org
Subject: +
 arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch added to
 -mm tree
Date: Thu, 07 May 2020 13:53:23 -0700
Message-ID: <20200507205323.e0Fo_zqyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGUxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch

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
Subject: arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#289: FILE: arch/nds32/mm/highmem.c:35:
+EXPORT_SYMBOL(kmap_atomic_high);

total: 0 errors, 1 warnings, 353 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/arch-kmap_atomic-consolidate-duplicate-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/highmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/nds32/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes
+++ a/arch/nds32/mm/highmem.c
@@ -31,7 +31,6 @@ void *kmap_atomic_high(struct page *page
 	__nds32__isb();
 	return (void *)vaddr;
 }
-
 EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
@@ -48,5 +47,4 @@ void __kunmap_atomic(void *kvaddr)
 	pagefault_enable();
 	preempt_enable();
 }
-
 EXPORT_SYMBOL(__kunmap_atomic);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
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
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch
