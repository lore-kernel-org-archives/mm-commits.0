From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap-locking-api-convert-mmap_sem-comments-fix.patch removed from -mm tree
Date: Mon, 08 Jun 2020 20:18:32 -0700
Message-ID: <20200609031832.6J2z1ZNW7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDSf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-comments-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-comments-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-comments.patch

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
@@ -1134,11 +1134,11 @@ static inline pmd_t pmd_read_atomic(pmd_
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
@@ -1148,7 +1148,7 @@ static inline pmd_t pmd_read_atomic(pmd_
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

mmap-locking-api-convert-mmap_sem-comments.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
