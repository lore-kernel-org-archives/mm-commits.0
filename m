From: akpm@linux-foundation.org
Subject: + gru-fix-bug-in-allocation-of-kernel-contexts.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:54 -0800
Message-ID: <200911241958.nAOJwsTI019887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782AbZKXT6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix bug in allocation of kernel contexts
has been added to the -mm tree.  Its filename is
     gru-fix-bug-in-allocation-of-kernel-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix bug in allocation of kernel contexts
From: Jack Steiner <steiner@sgi.com>

Fix a bug in the assignment of GRU contexts used for kernel functions.  If
a sleep occurs on the wait for a semaphore, the thread could switch cpus
and allocate resources on the wrong blade.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-allocation-of-kernel-contexts drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-allocation-of-kernel-contexts
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -221,13 +221,21 @@ static int gru_free_kernel_contexts(void
 static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
 {
 	struct gru_blade_state *bs;
+	int bid;
 
 	STAT(lock_kernel_context);
-	bs = gru_base[blade_id];
+again:
+	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
+	bs = gru_base[bid];
 
+	/* Handle the case where migration occured while waiting for the sema */
 	down_read(&bs->bs_kgts_sema);
+	if (blade_id < 0 && bid != uv_numa_blade_id()) {
+		up_read(&bs->bs_kgts_sema);
+		goto again;
+	}
 	if (!bs->bs_kgts || !bs->bs_kgts->ts_gru)
-		gru_load_kernel_context(bs, blade_id);
+		gru_load_kernel_context(bs, bid);
 	return bs;
 
 }
@@ -256,7 +264,7 @@ static int gru_get_cpu_resources(int dsr
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
 	preempt_disable();
-	bs = gru_lock_kernel_context(uv_numa_blade_id());
+	bs = gru_lock_kernel_context(-1);
 	lcpu = uv_blade_processor_id();
 	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
 	*dsr = bs->kernel_dsr + lcpu * GRU_NUM_KERNEL_DSR_BYTES;
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
gru-initial-gru-based-on-blade-topology.patch
gru-add-comments-raised-in-previous-code-reviews.patch
gru-fix-istatus-race-in-gru-tlb-dropin.patch
gru-handle-blades-without-memory.patch
gru-allow-users-to-specify-gru-chiplet-1.patch
gru-allow-users-to-specify-gru-chiplet-2.patch
gru-allow-users-to-specify-gru-chiplet-3.patch
gru-fix-bug-in-module-unload.patch
gru-improve-messages-for-malfunctioning-grus.patch
gru-support-64-bit-gru-addresses.patch
gru-handle-failures-to-mmu_notifier_register.patch
gru-add-debug-option-for-cache-flushing.patch
gru-add-test-for-gru_copy_gpa.patch
gru-check-for-valid-vma.patch
gru-fix-prefetch-and-speculation-bugs.patch
gru-update-irq-infrastructure.patch
gru-add-additional-gru-statistics.patch
gru-expicitly-set-instruction-status-to-active.patch
gru-preload-tlb-for-bcopy-instructions.patch
gru-fix-bug-in-exception-handling.patch
gru-add-symbolic-names-for-gru-error-code.patch
gru-remove-stray-local_irq_enable.patch
gru-check-for-correct-gru-chiplet-assignment.patch
gru-update-gru-structures-to-match-latest-hardware-spec.patch
gru-fix-bug-in-allocation-of-kernel-contexts.patch
gru-add-hugepage-support.patch
gru-fix-gru-interrupt-race-at-deallocate.patch
gru-improve-gru-tlb-dropin-statistics.patch
gru-update-driver-version-number.patch

