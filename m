From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fix-false-positive-vm_bug_on-on-rt.patch added to -mm tree
Date: Tue, 02 Jun 2015 14:12:18 -0700
Message-ID: <556e1c32.I8wrlG5ForMnY2oi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbFBVMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 17:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, nando@ccrma.Stanford.EDU, rostedt@goodmis.org, tglx@linutronix.de, williams@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix false-positive VM_BUG_ON() on -rt
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-false-positive-vm_bug_on-on-rt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-false-positive-vm_bug_on-on-rt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-false-positive-vm_bug_on-on-rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix false-positive VM_BUG_ON() on -rt

On -rt, the VM_BUG_ON(!irqs_disabled()) triggers inside the memcg swapout
path because the spin_lock_irq(&mapping->tree_lock) in the caller doesn't
actually disable the hardware interrupts - which is fine, because on -rt
the tophalves run in process context and so we are still safe from
preemption while updating the statistics.

Remove the VM_BUG_ON() but keep the comment of what we rely on.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Clark Williams <williams@redhat.com>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-false-positive-vm_bug_on-on-rt mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-false-positive-vm_bug_on-on-rt
+++ a/mm/memcontrol.c
@@ -5835,9 +5835,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
 
-	/* XXX: caller holds IRQ-safe mapping->tree_lock */
-	VM_BUG_ON(!irqs_disabled());
-
+	/* Caller disabled preemption with mapping->tree_lock */
 	mem_cgroup_charge_statistics(memcg, page, -1);
 	memcg_check_events(memcg, page);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-do-not-call-reclaim-if-__gfp_wait.patch
mm-memcontrol-fix-false-positive-vm_bug_on-on-rt.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
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
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
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
radix-tree-replace-preallocated-node-array-with-linked-list.patch

