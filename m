From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file-fix.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:21:21 -0700
Message-ID: <20200603222121.DcvRr_YCL%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgFCWVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:21:23 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file-fix
has been removed from the -mm tree.  Its filename was
     mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file-fix.patch

This patch was dropped because it was folded into mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file-fix

fix it for local_lock changes

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file-fix
+++ a/mm/swap.c
@@ -435,15 +435,17 @@ EXPORT_SYMBOL(mark_page_accessed);
  */
 void lru_cache_add(struct page *page)
 {
-	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
+	struct pagevec *pvec;
 
 	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
 	get_page(page);
+	local_lock(&lru_pvecs.lock);
+	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
 	if (!pagevec_add(pvec, page) || PageCompound(page))
 		__pagevec_lru_add(pvec);
-	put_cpu_var(lru_add_pvec);
+	local_unlock(&lru_pvecs.lock);
 }
 EXPORT_SYMBOL(lru_cache_add);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
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
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
