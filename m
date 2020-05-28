From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch added to
 -mm tree
Date: Wed, 27 May 2020 17:45:06 -0700
Message-ID: <20200528004506.k87fLmWT-%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgE1ApI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:45:08 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-use-non-set_fs-based-maccess-routines-x86-use-non-set_fs-based-maccess-routines
has been added to the -mm tree.  Its filename is
     x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch

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
Subject: x86-use-non-set_fs-based-maccess-routines-x86-use-non-set_fs-based-maccess-routines

WARNING: Macros with flow control statements should be avoided
#30: FILE: arch/x86/include/asm/uaccess.h:528:
+#define __get_kernel_nofault(dst, src, type, err_label)			\
+do {									\
+        int __kr_err;							\
+									\
+	__get_user_size(*((type *)dst), (__force type __user *)src,	\
+			sizeof(type), __kr_err);			\
+        if (unlikely(__kr_err))						\
+		goto err_label;						\
+} while (0)

ERROR: code indent should use tabs where possible
#32: FILE: arch/x86/include/asm/uaccess.h:530:
+        int __kr_err;^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#32: FILE: arch/x86/include/asm/uaccess.h:530:
+        int __kr_err;^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#36: FILE: arch/x86/include/asm/uaccess.h:534:
+        if (unlikely(__kr_err))^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#36: FILE: arch/x86/include/asm/uaccess.h:534:
+        if (unlikely(__kr_err))^I^I^I^I^I^I\$

total: 2 errors, 3 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/x86-use-non-set_fs-based-maccess-routines.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/uaccess.h~x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes
+++ a/arch/x86/include/asm/uaccess.h
@@ -527,11 +527,11 @@ do {									\
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-        int __kr_err;							\
+	int __kr_err;							\
 									\
 	__get_user_size(*((type *)dst), (__force type __user *)src,	\
 			sizeof(type), __kr_err);			\
-        if (unlikely(__kr_err))						\
+	if (unlikely(__kr_err))						\
 		goto err_label;						\
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-vm_bug_onpageslab-from-page_mapcount-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
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
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
