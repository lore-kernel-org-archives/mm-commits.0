From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-locking-api-convert-mmap_sem-comments-fix.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:25:32 -0700
Message-ID: <20200521032532.iyPBjF47z%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgEUDZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:25:34 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-comments-fix
has been added to the -mm tree.  Its filename is
     mmap-locking-api-convert-mmap_sem-comments-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-convert-mmap_sem-comments-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-convert-mmap_sem-comments-fix.patch

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
Subject: mmap-locking-api-convert-mmap_sem-comments-fix

fix up linux-next leftovers

Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |    2 +-
 include/linux/pgtable.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments-fix
+++ a/arch/powerpc/mm/fault.c
@@ -138,7 +138,7 @@ static noinline int bad_access_pkey(stru
 	 * 2. T1   : set AMR to deny access to pkey=4, touches, page
 	 * 3. T1   : faults...
 	 * 4.    T2: mprotect_key(foo, PAGE_SIZE, pkey=5);
-	 * 5. T1   : enters fault handler, takes mmap_sem, etc...
+	 * 5. T1   : enters fault handler, takes mmap_lock, etc...
 	 * 6. T1   : reaches here, sees vma_pkey(vma)=5, when we really
 	 *	     faulted on a pte with its pkey=4.
 	 */
--- a/include/linux/pgtable.h~mmap-locking-api-convert-mmap_sem-comments-fix
+++ a/include/linux/pgtable.h
@@ -1101,11 +1101,11 @@ static inline pmd_t pmd_read_atomic(pmd_
 #endif
 /*
  * This function is meant to be used by sites walking pagetables with
- * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
+ * the mmap_lock held in read mode to protect against MADV_DONTNEED and
  * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
  * into a null pmd and the transhuge page fault can convert a null pmd
  * into an hugepmd or into a regular pmd (if the hugepage allocation
- * fails). While holding the mmap_sem in read mode the pmd becomes
+ * fails). While holding the mmap_lock in read mode the pmd becomes
  * stable and stops changing under us only if it's not null and not a
  * transhuge pmd. When those races occurs and this function makes a
  * difference vs the standard pmd_none_or_clear_bad, the result is
@@ -1115,7 +1115,7 @@ static inline pmd_t pmd_read_atomic(pmd_
  *
  * For 32bit kernels with a 64bit large pmd_t this automatically takes
  * care of reading the pmd atomically to avoid SMP race conditions
- * against pmd_populate() when the mmap_sem is hold for reading by the
+ * against pmd_populate() when the mmap_lock is hold for reading by the
  * caller (a special atomic read not done by "gcc" as in the generic
  * version above, is also needed when THP is disabled because the page
  * fault can populate the pmd from under us).
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
