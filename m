From: akpm@linux-foundation.org
Subject: +
 userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch added to -mm tree
Date: Tue, 19 May 2015 14:38:55 -0700
Message-ID: <555bad6f.GPfAlfd0YFgCHMPB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbESVi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: solve the race between UFFDIO_COPY|ZEROPAGE and read
has been added to the -mm tree.  Its filename is
     userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: solve the race between UFFDIO_COPY|ZEROPAGE and read

Solve in-kernel the race between UFFDIO_COPY|ZEROPAGE and
userfaultfd_read if they are run on different threads simultaneously.

Until now qemu solved the race in userland: the race was explicitly
and intentionally left for userland to solve. However we can also
solve it in kernel.

Requiring all users to solve this race if they use two threads (one
for the background transfer and one for the userfault reads) isn't
very attractive from an API prospective, furthermore this allows to
remove a whole bunch of mutex and bitmap code from qemu, making it
faster. The cost of __get_user_pages_fast should be insignificant
considering it scales perfectly and the pagetables are already hot in
the CPU cache, compared to the overhead in userland to maintain those
structures.

Applying this patch is backwards compatible with respect to the
userfaultfd userland API, however reverting this change wouldn't be
backwards compatible anymore.

Without this patch qemu in the background transfer thread, has to read
the old state, and do UFFDIO_WAKE if old_state is missing but it
become REQUESTED by the time it tries to set it to RECEIVED (signaling
the other side received an userfault).

    vcpu                background_thr userfault_thr
    -----               -----          -----
    vcpu0 handle_mm_fault()

			postcopy_place_page
			read old_state -> MISSING
 			UFFDIO_COPY 0x7fb76a139000 (no wakeup, still pending)

    vcpu0 fault at 0x7fb76a139000 enters handle_userfault
    poll() is kicked

 					poll() -> POLLIN
 					read() -> 0x7fb76a139000
 					postcopy_pmi_change_state(MISSING, REQUESTED) -> REQUESTED

 			tmp_state = postcopy_pmi_change_state(old_state, RECEIVED) -> REQUESTED
			/* check that no userfault raced with UFFDIO_COPY */
			if (old_state == MISSING && tmp_state == REQUESTED)
				UFFDIO_WAKE from background thread

And a second case where a UFFDIO_WAKE would be needed is in the userfault thread:

    vcpu                background_thr userfault_thr
    -----               -----          -----
    vcpu0 handle_mm_fault()

			postcopy_place_page
			read old_state -> MISSING
 			UFFDIO_COPY 0x7fb76a139000 (no wakeup, still pending)
 			tmp_state = postcopy_pmi_change_state(old_state, RECEIVED) -> RECEIVED

    vcpu0 fault at 0x7fb76a139000 enters handle_userfault
    poll() is kicked

 					poll() -> POLLIN
 					read() -> 0x7fb76a139000

 					if (postcopy_pmi_change_state(MISSING, REQUESTED) == RECEIVED)
						UFFDIO_WAKE from userfault thread

This patch removes the need of both UFFDIO_WAKE and of the associated
per-page tristate as well.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   81 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 15 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read
+++ a/fs/userfaultfd.c
@@ -167,6 +167,67 @@ static inline struct uffd_msg userfault_
 }
 
 /*
+ * Verify the pagetables are still not ok after having reigstered into
+ * the fault_pending_wqh to avoid userland having to UFFDIO_WAKE any
+ * userfault that has already been resolved, if userfaultfd_read and
+ * UFFDIO_COPY|ZEROPAGE are being run simultaneously on two different
+ * threads.
+ */
+static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
+					 unsigned long address,
+					 unsigned long flags,
+					 unsigned long reason)
+{
+	struct mm_struct *mm = ctx->mm;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd, _pmd;
+	pte_t *pte;
+	bool ret = true;
+
+	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		goto out;
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		goto out;
+	pmd = pmd_offset(pud, address);
+	/*
+	 * READ_ONCE must function as a barrier with narrower scope
+	 * and it must be equivalent to:
+	 *	_pmd = *pmd; barrier();
+	 *
+	 * This is to deal with the instability (as in
+	 * pmd_trans_unstable) of the pmd.
+	 */
+	_pmd = READ_ONCE(*pmd);
+	if (!pmd_present(_pmd))
+		goto out;
+
+	ret = false;
+	if (pmd_trans_huge(_pmd))
+		goto out;
+
+	/*
+	 * the pmd is stable (as in !pmd_trans_unstable) so we can re-read it
+	 * and use the standard pte_offset_map() instead of parsing _pmd.
+	 */
+	pte = pte_offset_map(pmd, address);
+	/*
+	 * Lockless access: we're in a wait_event so it's ok if it
+	 * changes under us.
+	 */
+	if (pte_none(*pte))
+		ret = true;
+	pte_unmap(pte);
+
+out:
+	return ret;
+}
+
+/*
  * The locking rules involved in returning VM_FAULT_RETRY depending on
  * FAULT_FLAG_ALLOW_RETRY, FAULT_FLAG_RETRY_NOWAIT and
  * FAULT_FLAG_KILLABLE are not straightforward. The "Caution"
@@ -188,6 +249,7 @@ int handle_userfault(struct vm_area_stru
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
 	int ret;
+	bool must_wait;
 
 	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
@@ -247,9 +309,6 @@ int handle_userfault(struct vm_area_stru
 	/* take the reference before dropping the mmap_sem */
 	userfaultfd_ctx_get(ctx);
 
-	/* be gentle and immediately relinquish the mmap_sem */
-	up_read(&mm->mmap_sem);
-
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
 	uwq.msg = userfault_msg(address, flags, reason);
@@ -269,7 +328,10 @@ int handle_userfault(struct vm_area_stru
 	set_current_state(TASK_KILLABLE);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
-	if (likely(!ACCESS_ONCE(ctx->released) &&
+	must_wait = userfaultfd_must_wait(ctx, address, flags, reason);
+	up_read(&mm->mmap_sem);
+
+	if (likely(must_wait && !ACCESS_ONCE(ctx->released) &&
 		   !fatal_signal_pending(current))) {
 		wake_up_poll(&ctx->fd_wqh, POLLIN);
 		schedule();
@@ -860,17 +922,6 @@ out:
 }
 
 /*
- * userfaultfd_wake is needed in case an userfault is in flight by the
- * time a UFFDIO_COPY (or other ioctl variants) completes. The page
- * may be well get mapped and the page fault if repeated wouldn't lead
- * to a userfault anymore, but before scheduling in TASK_KILLABLE mode
- * handle_userfault() doesn't recheck the pagetables and it doesn't
- * serialize against UFFDO_COPY (or other ioctl variants). Ultimately
- * the knowledge of which pages are mapped is left to userland who is
- * responsible for handling the race between read() userfaults and
- * background UFFDIO_COPY (or other ioctl variants), if done by
- * separate concurrent threads.
- *
  * userfaultfd_wake may be used in combination with the
  * UFFDIO_*_MODE_DONTWAKE to wakeup userfaults in batches.
  */
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
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
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
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

