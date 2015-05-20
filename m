From: akpm@linux-foundation.org
Subject: + mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
 added to -mm tree
Date: Wed, 20 May 2015 13:25:13 -0700
Message-ID: <555ceda9.facMZxlClehBbMkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbbETUZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 16:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, david@fromorbit.com, mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: remove unnecessary locking in oom_enable()
has been added to the -mm tree.  Its filename is
     mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch

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
Subject: mm: oom_kill: remove unnecessary locking in oom_enable()

Setting oom_killer_disabled to false is atomic, there is no need for
further synchronization with ongoing allocations trying to OOM-kill.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-remove-unnecessary-locking-in-oom_enable mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-remove-unnecessary-locking-in-oom_enable
+++ a/mm/oom_kill.c
@@ -488,9 +488,7 @@ bool oom_killer_disable(void)
  */
 void oom_killer_enable(void)
 {
-	down_write(&oom_sem);
 	oom_killer_disabled = false;
-	up_write(&oom_sem);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

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

