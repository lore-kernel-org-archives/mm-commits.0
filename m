From: akpm@linux-foundation.org
Subject: + gru-fix-gru-interrupt-race-at-deallocate.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:58 -0800
Message-ID: <200911241958.nAOJwwWt019994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932795AbZKXT6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix GRU interrupt race at deallocate
has been added to the -mm tree.  Its filename is
     gru-fix-gru-interrupt-race-at-deallocate.patch

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
Subject: gru: fix GRU interrupt race at deallocate
From: Jack Steiner <steiner@sgi.com>

Fix a race where an interrupt could be received for a GRU context that has
been deallocated.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   24 +++++++++++++++++-------
 drivers/misc/sgi-gru/gruprocfs.c |    1 +
 drivers/misc/sgi-gru/grutables.h |    1 +
 3 files changed, 19 insertions(+), 7 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-gru-interrupt-race-at-deallocate drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-gru-interrupt-race-at-deallocate
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -360,7 +360,8 @@ static void gru_preload_tlb(struct gru_s
  * 		< 0 = error code
  *
  */
-static int gru_try_dropin(struct gru_thread_state *gts,
+static int gru_try_dropin(struct gru_state *gru,
+			  struct gru_thread_state *gts,
 			  struct gru_tlb_fault_handle *tfh,
 			  struct gru_instruction_bits *cbk)
 {
@@ -432,7 +433,7 @@ static int gru_try_dropin(struct gru_thr
 	}
 
 	if (unlikely(cbe) && pageshift == PAGE_SHIFT) {
-		gru_preload_tlb(gts->ts_gru, gts, atomic, vaddr, asid, write, tlb_preload_count, tfh, cbe);
+		gru_preload_tlb(gru, gts, atomic, vaddr, asid, write, tlb_preload_count, tfh, cbe);
 		gru_flush_cache_cbe(cbe);
 	}
 
@@ -442,7 +443,7 @@ static int gru_try_dropin(struct gru_thr
 	gru_dbg(grudev,
 		"%s: gid %d, gts 0x%p, tfh 0x%p, vaddr 0x%lx, asid 0x%x, indexway 0x%x,"
 		" rw %d, ps %d, gpa 0x%lx\n",
-		atomic ? "atomic" : "non-atomic", gts->ts_gru->gs_gid, gts, tfh, vaddr, asid,
+		atomic ? "atomic" : "non-atomic", gru->gs_gid, gts, tfh, vaddr, asid,
 		indexway, write, pageshift, gpa);
 	STAT(tlb_dropin);
 	return 0;
@@ -528,6 +529,7 @@ static irqreturn_t gru_intr(int chiplet,
 	struct gru_tlb_fault_map imap, dmap;
 	struct gru_thread_state *gts;
 	struct gru_tlb_fault_handle *tfh = NULL;
+	struct completion *cmp;
 	int cbrnum, ctxnum;
 
 	STAT(intr);
@@ -547,9 +549,11 @@ static irqreturn_t gru_intr(int chiplet,
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		STAT(intr_cbr);
-		complete(gru->gs_blade->bs_async_wq);
+		cmp = gru->gs_blade->bs_async_wq;
+		if (cmp)
+			complete(cmp);
 		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
-			gru->gs_gid, cbrnum, gru->gs_blade->bs_async_wq->done);
+			gru->gs_gid, cbrnum, cmp ? cmp->done : -1);
 	}
 
 	for_each_cbr_in_tfm(cbrnum, imap.fault_bits) {
@@ -566,6 +570,12 @@ static irqreturn_t gru_intr(int chiplet,
 		ctxnum = tfh->ctxnum;
 		gts = gru->gs_gts[ctxnum];
 
+		/* Spurious interrupts can cause this. Ignore. */
+		if (!gts) {
+			STAT(intr_spurious);
+			continue;
+		}
+
 		/*
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
@@ -573,7 +583,7 @@ static irqreturn_t gru_intr(int chiplet,
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
 			gts->ustats.fmm_tlbdropin++;
-			gru_try_dropin(gts, tfh, NULL);
+			gru_try_dropin(gru, gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
 			tfh_user_polling_mode(tfh);
@@ -619,7 +629,7 @@ static int gru_user_dropin(struct gru_th
 		wait_event(gms->ms_wait_queue,
 			   atomic_read(&gms->ms_range_active) == 0);
 		prefetchw(tfh);	/* Helps on hdw, required for emulator */
-		ret = gru_try_dropin(gts, tfh, cb);
+		ret = gru_try_dropin(gts->ts_gru, gts, tfh, cb);
 		if (ret <= 0)
 			return ret;
 		STAT(call_os_wait_queue);
diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-fix-gru-interrupt-race-at-deallocate drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-fix-gru-interrupt-race-at-deallocate
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -66,6 +66,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, intr);
 	printstat(s, intr_cbr);
 	printstat(s, intr_tfh);
+	printstat(s, intr_spurious);
 	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
 	printstat(s, call_os_wait_queue);
diff -puN drivers/misc/sgi-gru/grutables.h~gru-fix-gru-interrupt-race-at-deallocate drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-fix-gru-interrupt-race-at-deallocate
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -192,6 +192,7 @@ struct gru_stats_s {
 	atomic_long_t intr;
 	atomic_long_t intr_cbr;
 	atomic_long_t intr_tfh;
+	atomic_long_t intr_spurious;
 	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
 	atomic_long_t call_os_wait_queue;
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

