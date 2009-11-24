From: akpm@linux-foundation.org
Subject: + gru-improve-gru-tlb-dropin-statistics.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:59:00 -0800
Message-ID: <200911241959.nAOJx019020130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801AbZKXT64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: improve GRU TLB dropin statistics
has been added to the -mm tree.  Its filename is
     gru-improve-gru-tlb-dropin-statistics.patch

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
Subject: gru: improve GRU TLB dropin statistics
From: Jack Steiner <steiner@sgi.com>

Update the TLB dropin statistics kept for each GRU context.  Count TLB
dropins separate from the misses - some misses do not result in a TLB
dropin.  Some of the diagnostics need both counts.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru.h       |   11 +++++++++++
 drivers/misc/sgi-gru/grufault.c  |    5 +++--
 drivers/misc/sgi-gru/grulib.h    |   13 ++-----------
 drivers/misc/sgi-gru/grutables.h |    2 +-
 4 files changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/misc/sgi-gru/gru.h~gru-improve-gru-tlb-dropin-statistics drivers/misc/sgi-gru/gru.h
--- a/drivers/misc/sgi-gru/gru.h~gru-improve-gru-tlb-dropin-statistics
+++ a/drivers/misc/sgi-gru/gru.h
@@ -53,6 +53,17 @@ struct gru_chiplet_info {
 	int	free_user_cbr;
 };
 
+/*
+ * Statictics kept for each context.
+ */
+struct gru_gseg_statistics {
+	unsigned long	fmm_tlbmiss;
+	unsigned long	upm_tlbmiss;
+	unsigned long	tlbdropin;
+	unsigned long	context_stolen;
+	unsigned long	reserved[10];
+};
+
 /* Flags for GRU options on the gru_create_context() call */
 /* Select one of the follow 4 options to specify how TLB misses are handled */
 #define GRU_OPT_MISS_DEFAULT	0x0000	/* Use default mode */
diff -puN drivers/misc/sgi-gru/grufault.c~gru-improve-gru-tlb-dropin-statistics drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-improve-gru-tlb-dropin-statistics
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -438,6 +438,7 @@ static int gru_try_dropin(struct gru_sta
 	}
 
 	gru_cb_set_istatus_active(cbk);
+	gts->ustats.tlbdropin++;
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
 	gru_dbg(grudev,
@@ -580,9 +581,9 @@ static irqreturn_t gru_intr(int chiplet,
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
 		 */
+		gts->ustats.fmm_tlbmiss++;
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
-			gts->ustats.fmm_tlbdropin++;
 			gru_try_dropin(gru, gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
@@ -624,7 +625,7 @@ static int gru_user_dropin(struct gru_th
 	struct gru_mm_struct *gms = gts->ts_gms;
 	int ret;
 
-	gts->ustats.upm_tlbdropin++;
+	gts->ustats.upm_tlbmiss++;
 	while (1) {
 		wait_event(gms->ms_wait_queue,
 			   atomic_read(&gms->ms_range_active) == 0);
diff -puN drivers/misc/sgi-gru/grulib.h~gru-improve-gru-tlb-dropin-statistics drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-improve-gru-tlb-dropin-statistics
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -63,18 +63,9 @@
 #define THREAD_POINTER(p, th)		(p + GRU_GSEG_PAGESIZE * (th))
 #define GSEG_START(cb)			((void *)((unsigned long)(cb) & ~(GRU_GSEG_PAGESIZE - 1)))
 
-/*
- * Statictics kept on a per-GTS basis.
- */
-struct gts_statistics {
-	unsigned long	fmm_tlbdropin;
-	unsigned long	upm_tlbdropin;
-	unsigned long	context_stolen;
-};
-
 struct gru_get_gseg_statistics_req {
-	unsigned long		gseg;
-	struct gts_statistics	stats;
+	unsigned long			gseg;
+	struct gru_gseg_statistics	stats;
 };
 
 /*
diff -puN drivers/misc/sgi-gru/grutables.h~gru-improve-gru-tlb-dropin-statistics drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-improve-gru-tlb-dropin-statistics
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -385,7 +385,7 @@ struct gru_thread_state {
 							  allocated CB */
 	int			ts_data_valid;	/* Indicates if ts_gdata has
 						   valid data */
-	struct gts_statistics	ustats;		/* User statistics */
+	struct gru_gseg_statistics ustats;	/* User statistics */
 	unsigned long		ts_gdata[0];	/* save area for GRU data (CB,
 						   DS, CBE) */
 };
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

