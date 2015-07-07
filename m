From: akpm@linux-foundation.org
Subject: + mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch added
 to -mm tree
Date: Tue, 07 Jul 2015 16:25:47 -0700
Message-ID: <559c5ffb.WpsLOHwNUYKcXtMU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbbGGXZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 19:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, mingo@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: increase SWAP_CLUSTER_MAX to batch TLB flushes
has been added to the -mm tree.  Its filename is
     mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

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
Subject: mm: increase SWAP_CLUSTER_MAX to batch TLB flushes

Pages that are unmapped for reclaim must be flushed before being freed to
avoid corruption due to a page being freed and reallocated while a stale
TLB entry exists.  When reclaiming mapped pages, the requires one IPI per
SWAP_CLUSTER_MAX.  This patch increases SWAP_CLUSTER_MAX to 256 so more
pages can be flushed with a single IPI.  This number was selected because
it reduced IPIs for TLB shootdowns by 40% on a workload that is dominated
by mapped pages.

Note that it is expected that doubling SWAP_CLUSTER_MAX would not always
halve the IPIs as it is workload dependent.  Reclaim efficiency was not
100% on this workload which was picked for being IPI-intensive and was
closer to 35%.  More importantly, reclaim does not always isolate in
SWAP_CLUSTER_MAX pages.  The LRU lists for a zone may be small, the
priority can be low and even when reclaiming a lot of pages, the last
isolation may not be exactly SWAP_CLUSTER_MAX.

There are a few potential issues with increasing SWAP_CLUSTER_MAX.

1. LRU lock hold times increase slightly because more pages are being
   isolated.
2. There are slight timing changes due to more pages having to be
   processed before they are freed. There is a slight risk that more
   pages than are necessary get reclaimed.
3. There is a risk that too_many_isolated checks will be easier to
   trigger resulting in a HZ/10 stall.
4. The rotation rate of active->inactive is slightly faster but there
   should be fewer rotations before the lists get balanced so it
   shouldn't matter.
5. More pages are reclaimed in a single pass if zone_reclaim_mode is
   active but that thing sucks hard when it's enabled no matter what
6. More pages are isolated for compaction so page hold times there
   are longer while they are being copied

It's unlikely any of these will be problems but worth keeping in mind if
there are any reclaim-related bug reports in the near future.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes include/linux/swap.h
--- a/include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes
+++ a/include/linux/swap.h
@@ -154,7 +154,7 @@ enum {
 	SWP_SCANNING	= (1 << 10),	/* refcount in scan_swap_map */
 };
 
-#define SWAP_CLUSTER_MAX 32UL
+#define SWAP_CLUSTER_MAX 256UL
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /*
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

