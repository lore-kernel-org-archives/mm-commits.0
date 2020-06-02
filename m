From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch removed
 from -mm tree
Date: Mon, 01 Jun 2020 21:22:02 -0700
Message-ID: <20200602042202.Jz48lifAh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFBEWE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org


The patch titled
     Subject: mm-vmalloc-track-which-page-table-levels-were-modified-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch

This patch was dropped because it was folded into mm-vmalloc-track-which-page-table-levels-were-modified.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-track-which-page-table-levels-were-modified-fix

map_kernel_range_noflush() needs the arch_sync_kernel_mappings() call

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-track-which-page-table-levels-were-modified-fix
+++ a/mm/vmalloc.c
@@ -291,6 +291,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 int map_kernel_range_noflush(unsigned long addr, unsigned long size,
 			     pgprot_t prot, struct page **pages)
 {
+	unsigned long start = addr;
 	unsigned long end = addr + size;
 	unsigned long next;
 	pgd_t *pgd;
@@ -309,6 +310,9 @@ int map_kernel_range_noflush(unsigned lo
 			return err;
 	} while (pgd++, addr = next, addr != end);
 
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified.patch
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
