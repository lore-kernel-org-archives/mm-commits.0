From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2.patch removed
 from -mm tree
Date: Mon, 01 Jun 2020 21:16:28 -0700
Message-ID: <20200602041628.oFkynDer6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgFBEQa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chuck.lever@oracle.com, hch@lst.de, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, trond.myklebust@hammerspace.com


The patch titled
     Subject: mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2
has been removed from the -mm tree.  Its filename was
     mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2.patch

This patch was dropped because it was folded into mm-discard-nr_unstable_nfs-use-nr_writeback-instead.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2

fix printk warning

Cc: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Michal Hocko <mhocko@suse.com>	[mm]
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2
+++ a/drivers/base/node.c
@@ -439,7 +439,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(i.sharedram),
 		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
-		       nid, 0,
+		       nid, 0UL,
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 		       nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 		       nid, K(sreclaimable +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-discard-nr_unstable_nfs-use-nr_writeback-instead.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-ptdump-expand-type-of-val-in-note_page-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
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
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
