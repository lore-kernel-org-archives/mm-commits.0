From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch removed from
 -mm tree
Date: Mon, 01 Jun 2020 21:14:14 -0700
Message-ID: <20200602041414.50mDQhP0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgFBEOQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, dongli.zhang@oracle.com, iamjoonsoo.kim@lge.com, joe.jin@oracle.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch

This patch was dropped because it was folded into mm-slub-fix-corrupted-freechain-in-deactivate_slab.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix

fix build with CONFIG_SLAB_DEBUG=n

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/mm/slub.c~mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix
+++ a/mm/slub.c
@@ -679,6 +679,20 @@ static void slab_fix(struct kmem_cache *
 	va_end(args);
 }
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
+	    !check_valid_pointer(s, page, nextfree)) {
+		object_err(s, page, freelist, "Freechain corrupt");
+		freelist = NULL;
+		slab_fix(s, "Isolate corrupted freechain");
+		return true;
+	}
+
+	return false;
+}
+
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
@@ -1410,6 +1424,11 @@ static inline void inc_slabs_node(struct
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	return false;
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -2093,19 +2112,13 @@ static void deactivate_slab(struct kmem_
 		void *prior;
 		unsigned long counters;
 
-		if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-		    !check_valid_pointer(s, page, nextfree)) {
-			/*
-			 * If 'nextfree' is invalid, it is possible that
-			 * the object at 'freelist' is already corrupted.
-			 * Therefore, all objects starting at 'freelist'
-			 * are isolated.
-			 */
-			object_err(s, page, freelist, "Freechain corrupt");
-			freelist = NULL;
-			slab_fix(s, "Isolate corrupted freechain");
+		/*
+		 * If 'nextfree' is invalid, it is possible that the object at
+		 * 'freelist' is already corrupted.  So isolate all objects
+		 * starting at 'freelist'.
+		 */
+		if (freelist_corrupted(s, page, freelist, nextfree))
 			break;
-		}
 
 		do {
 			prior = page->freelist;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab.patch
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
