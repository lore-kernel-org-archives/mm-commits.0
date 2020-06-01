From: akpm@linux-foundation.org
Subject: +
 mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 01 Jun 2020 16:43:42 -0700
Message-ID: <20200601234342.bzuqPdjj_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgFAXno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 19:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, neilb@suse.de


The patch titled
     Subject: mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch

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
Subject: mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes

WARNING: 'deamon' may be misspelled - perhaps 'daemon'?
#26: 
of the deamon writing to the "final" bdi.

WARNING: Block comments use a trailing */ on a separate line
#117: FILE: include/linux/sched.h:1488:
+						 * I am cleaning dirty pages from some other bdi. */

WARNING: labels should not be indented
#171: FILE: mm/page-writeback.c:1658:
+		free_running:

total: 0 errors, 3 warnings, 145 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-replace-pf_less_throttle-with-pf_local_throttle.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/page-writeback.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h~mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes
+++ a/include/linux/sched.h
@@ -1484,7 +1484,7 @@ extern struct pid *cad_pid;
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
-#define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only agasint the bdi I write to,
+#define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
--- a/mm/page-writeback.c~mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes
+++ a/mm/page-writeback.c
@@ -1655,7 +1655,7 @@ static void balance_dirty_pages(struct b
 			unsigned long intv;
 			unsigned long m_intv;
 
-		free_running:
+free_running:
 			intv = dirty_poll_interval(dirty, thresh);
 			m_intv = ULONG_MAX;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ptdump-expand-type-of-val-in-note_page-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix-fix.patch
mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch
mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix.patch
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
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
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
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
