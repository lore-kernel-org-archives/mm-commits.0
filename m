From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch added
 to -mm tree
Date: Wed, 27 May 2020 18:02:00 -0700
Message-ID: <20200528010200.xDWQV6lnl%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgE1BCB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 21:02:01 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: maccess-always-use-strict-semantics-for-probe_kernel_read-fix
has been added to the -mm tree.  Its filename is
     maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch

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
Subject: maccess-always-use-strict-semantics-for-probe_kernel_read-fix

update "maccess: always use strict semantics for probe_kernel_read"
(http://lkml.kernel.org/r/20200331165454.12263-1-vbabka@suse.cz) for
"mm, dump_page(): do not crash with invalid mapping pointer"
(http://lkml.kernel.org/r/20200331165454.12263-1-vbabka@suse.cz).

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/debug.c~maccess-always-use-strict-semantics-for-probe_kernel_read-fix
+++ a/mm/debug.c
@@ -120,9 +120,9 @@ void __dump_page(struct page *page, cons
 		 * mapping can be invalid pointer and we don't want to crash
 		 * accessing it, so probe everything depending on it carefully
 		 */
-		if (probe_kernel_read_strict(&host, &mapping->host,
-						sizeof(struct inode *)) ||
-		    probe_kernel_read_strict(&a_ops, &mapping->a_ops,
+		if (probe_kernel_read(&host, &mapping->host,
+					sizeof(struct inode *)) ||
+		    probe_kernel_read(&a_ops, &mapping->a_ops,
 				sizeof(struct address_space_operations *))) {
 			pr_warn("failed to read mapping->host or a_ops, mapping not a valid kernel address?\n");
 			goto out_mapping;
@@ -133,7 +133,7 @@ void __dump_page(struct page *page, cons
 			goto out_mapping;
 		}
 
-		if (probe_kernel_read_strict(&dentry_first,
+		if (probe_kernel_read(&dentry_first,
 			&host->i_dentry.first, sizeof(struct hlist_node *))) {
 			pr_warn("mapping->a_ops:%ps with invalid mapping->host inode address %px\n",
 				a_ops, host);
@@ -146,7 +146,7 @@ void __dump_page(struct page *page, cons
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
-		if (probe_kernel_read_strict(&dentry, dentry_ptr,
+		if (probe_kernel_read(&dentry, dentry_ptr,
 							sizeof(struct dentry))) {
 			pr_warn("mapping->aops:%ps with invalid mapping->host->i_dentry.first %px\n",
 				a_ops, dentry_ptr);
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
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
