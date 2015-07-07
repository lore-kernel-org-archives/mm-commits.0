From: akpm@linux-foundation.org
Subject: + mm-defer-flush-of-writable-tlb-entries.patch added to -mm tree
Date: Tue, 07 Jul 2015 16:25:45 -0700
Message-ID: <559c5ff9.Hp7Z4xhVuDChwSEy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbbGGXZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 19:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, mingo@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: defer flush of writable TLB entries
has been added to the -mm tree.  Its filename is
     mm-defer-flush-of-writable-tlb-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-defer-flush-of-writable-tlb-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-defer-flush-of-writable-tlb-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: defer flush of writable TLB entries

If a PTE is unmapped and it's dirty then it was writable recently.  Due to
deferred TLB flushing, it's best to assume a writable TLB cache entry
exists.  With that assumption, the TLB must be flushed before any IO can
start or the page is freed to avoid lost writes or data corruption.  This
patch defers flushing of potentially writable TLBs as long as possible.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++++
 mm/internal.h         |    4 ++++
 mm/rmap.c             |   28 +++++++++++++++++++++-------
 mm/vmscan.c           |    7 ++++++-
 4 files changed, 38 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~mm-defer-flush-of-writable-tlb-entries include/linux/sched.h
--- a/include/linux/sched.h~mm-defer-flush-of-writable-tlb-entries
+++ a/include/linux/sched.h
@@ -1351,6 +1351,13 @@ struct tlbflush_unmap_batch {
 
 	/* True if any bit in cpumask is set */
 	bool flush_required;
+
+	/*
+	 * If true then the PTE was dirty when unmapped. The entry must be
+	 * flushed before IO is initiated or a stale TLB entry potentially
+	 * allows an update without redirtying the page.
+	 */
+	bool writable;
 };
 
 struct task_struct {
diff -puN mm/internal.h~mm-defer-flush-of-writable-tlb-entries mm/internal.h
--- a/mm/internal.h~mm-defer-flush-of-writable-tlb-entries
+++ a/mm/internal.h
@@ -431,10 +431,14 @@ struct tlbflush_unmap_batch;
 
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 void try_to_unmap_flush(void);
+void try_to_unmap_flush_dirty(void);
 #else
 static inline void try_to_unmap_flush(void)
 {
 }
+static inline void try_to_unmap_flush_dirty(void)
+{
+}
 
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/rmap.c~mm-defer-flush-of-writable-tlb-entries mm/rmap.c
--- a/mm/rmap.c~mm-defer-flush-of-writable-tlb-entries
+++ a/mm/rmap.c
@@ -625,16 +625,34 @@ void try_to_unmap_flush(void)
 	}
 	cpumask_clear(&tlb_ubc->cpumask);
 	tlb_ubc->flush_required = false;
+	tlb_ubc->writable = false;
 	put_cpu();
 }
 
+/* Flush iff there are potentially writable TLB entries that can race with IO */
+void try_to_unmap_flush_dirty(void)
+{
+	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
+
+	if (tlb_ubc->writable)
+		try_to_unmap_flush();
+}
+
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
-		struct page *page)
+		struct page *page, bool writable)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 
 	cpumask_or(&tlb_ubc->cpumask, &tlb_ubc->cpumask, mm_cpumask(mm));
 	tlb_ubc->flush_required = true;
+
+	/*
+	 * If the PTE was dirty then it's best to assume it's writable. The
+	 * caller must use try_to_unmap_flush_dirty() or try_to_unmap_flush()
+	 * before the page is queued for IO.
+	 */
+	if (writable)
+		tlb_ubc->writable = true;
 }
 
 /*
@@ -657,7 +675,7 @@ static bool should_defer_flush(struct mm
 }
 #else
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
-		struct page *page)
+		struct page *page, bool writable)
 {
 }
 
@@ -1314,11 +1332,7 @@ static int try_to_unmap_one(struct page
 		 */
 		pteval = ptep_get_and_clear(mm, address, pte);
 
-		/* Potentially writable TLBs must be flushed before IO */
-		if (pte_dirty(pteval))
-			flush_tlb_page(vma, address);
-		else
-			set_tlb_ubc_flush_pending(mm, page);
+		set_tlb_ubc_flush_pending(mm, page, pte_dirty(pteval));
 	} else {
 		pteval = ptep_clear_flush(vma, address, pte);
 	}
diff -puN mm/vmscan.c~mm-defer-flush-of-writable-tlb-entries mm/vmscan.c
--- a/mm/vmscan.c~mm-defer-flush-of-writable-tlb-entries
+++ a/mm/vmscan.c
@@ -1102,7 +1102,12 @@ static unsigned long shrink_page_list(st
 			if (!sc->may_writepage)
 				goto keep_locked;
 
-			/* Page is dirty, try to write it out here */
+			/*
+			 * Page is dirty. Flush the TLB if a writable entry
+			 * potentially exists to avoid CPU writes after IO
+			 * starts and then write it out here.
+			 */
+			try_to_unmap_flush_dirty();
 			switch (pageout(page, mapping, sc)) {
 			case PAGE_KEEP:
 				goto keep_locked;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-meminit-suppress-unused-memory-variable-warning.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch
mm-defer-flush-of-writable-tlb-entries.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

