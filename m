From: akpm@linux-foundation.org
Subject: [folded-merged]
 squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch removed from -mm
 tree
Date: Mon, 01 Jun 2020 21:13:45 -0700
Message-ID: <20200602041345.OXyuPwbNK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgFBENq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrien+dev@schischi.me, akpm@linux-foundation.org, drosen@google.com, groeck@chromium.org, hch@lst.de, mm-commits@vger.kernel.org, phillip@squashfs.org.uk, pliard@google.com, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
has been removed from the -mm tree.  Its filename was
     squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

This patch was dropped because it was folded into squashfs-migrate-from-ll_rw_block-usage-to-bio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-migrate-from-ll_rw_block-usage-to-bio-fix

fix build error reported by Randy

Link: http://lkml.kernel.org/r/319997c2-5fc8-f889-2ea3-d913308a7c1f@infradead.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Philippe Liard <pliard@google.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/decompressor_multi_percpu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/squashfs/decompressor_multi_percpu.c~squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
+++ a/fs/squashfs/decompressor_multi_percpu.c
@@ -72,14 +72,17 @@ void squashfs_decompressor_destroy(struc
 	}
 }
 
-int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
-	int b, int offset, int length, struct squashfs_page_actor *output)
+int squashfs_decompress(struct squashfs_sb_info *msblk, struct bio *bio,
+	int offset, int length, struct squashfs_page_actor *output)
 {
-	struct squashfs_stream __percpu *percpu =
-			(struct squashfs_stream __percpu *) msblk->stream;
-	struct squashfs_stream *stream = get_cpu_ptr(percpu);
-	int res = msblk->decompressor->decompress(msblk, stream->stream, bh, b,
-		offset, length, output);
+	struct squashfs_stream __percpu *percpu;
+	struct squashfs_stream *stream;
+	int res;
+
+	percpu = (struct squashfs_stream __percpu *)msblk->stream;
+	stream = get_cpu_ptr(percpu);
+	res = msblk->decompressor->decompress(msblk, stream->stream, bio,
+					      offset, length, output);
 	put_cpu_ptr(stream);
 
 	if (res < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix-fix.patch
mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch
mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix.patch
mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix-2.patch
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
