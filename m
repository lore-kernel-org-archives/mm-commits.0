From: akpm@linux-foundation.org
Subject: +
 mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch added to
 -mm tree
Date: Fri, 17 Jul 2015 13:25:28 -0700
Message-ID: <55a964b8.95mLqPKqDYGwOeTT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbGQUZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jul 2015 16:25:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, alexng@microsoft.com, dave.hansen@intel.com, fengguang.wu@intel.com, nicstange@gmail.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: allow early_pfn_to_nid to be used during runtime
has been added to the -mm tree.  Its filename is
     mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch

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
Subject: mm, meminit: allow early_pfn_to_nid to be used during runtime

early_pfn_to_nid historically was inherently not SMP safe but only used
during boot which is inherently single threaded or during hotplug which is
protected by a giant mutex.  With deferred memory initialisation there was
a thread-safe version introduced and the early_pfn_to_nid would trigger a
BUG_ON if used unsafely.  Memory hotplug hit that check.  This patch makes
early_pfn_to_nid introduces a lock to make it safe to use during hotplug.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Alex Ng <alexng@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime
+++ a/mm/page_alloc.c
@@ -981,21 +981,21 @@ static void __init __free_pages_boot_cor
 
 #if defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) || \
 	defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
-/* Only safe to use early in boot when initialisation is single-threaded */
+
 static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
 
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
+	static DEFINE_SPINLOCK(early_pfn_lock);
 	int nid;
 
-	/* The system will behave unpredictably otherwise */
-	BUG_ON(system_state != SYSTEM_BOOTING);
-
+	spin_lock(&early_pfn_lock);
 	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
-	if (nid >= 0)
-		return nid;
-	/* just returns 0 */
-	return 0;
+	if (nid < 0)
+		nid = 0;
+	spin_unlock(&early_pfn_lock);
+
+	return nid;
 }
 #endif
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-meminit-suppress-unused-memory-variable-warning.patch
mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch
mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch
mm-meminit-replace-rwsem-with-completion.patch
fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch
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
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
mm-defer-flush-of-writable-tlb-entries.patch
documentation-features-vm-add-feature-description-and-arch-support-status-for-batched-tlb-flush-after-unmap.patch
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
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

