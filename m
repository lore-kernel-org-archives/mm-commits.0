From: akpm@linux-foundation.org
Subject: + gru-allow-users-to-specify-gru-chiplet-3.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:17 -0800
Message-ID: <200911241958.nAOJwIbG018314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932698AbZKXT6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: allow users to specify gru chiplet 3
has been added to the -mm tree.  Its filename is
     gru-allow-users-to-specify-gru-chiplet-3.patch

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
Subject: gru: allow users to specify gru chiplet 3
From: Jack Steiner <steiner@sgi.com>

This patch builds on the infrastructure introduced in the patches that
allow user specification of GRU blades & chiplets for context allocation.

This patch simplifies the algorithms for migrating GRU contexts between
blades.

No new functionality is introduced.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |    8 ++-----
 drivers/misc/sgi-gru/grumain.c   |   30 ++++++++---------------------
 drivers/misc/sgi-gru/grutables.h |    4 ---
 3 files changed, 13 insertions(+), 29 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-3 drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-3
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -362,7 +362,7 @@ static int gru_try_dropin(struct gru_thr
 
 	if (!(gts->ts_sizeavail & GRU_SIZEAVAIL(pageshift))) {
 		gts->ts_sizeavail |= GRU_SIZEAVAIL(pageshift);
-		if (atomic || !gru_update_cch(gts, 0)) {
+		if (atomic || !gru_update_cch(gts)) {
 			gts->ts_force_cch_reload = 1;
 			goto failupm;
 		}
@@ -553,14 +553,12 @@ int gru_handle_user_call_os(unsigned lon
 	 */
 	if (gts->ts_gru && gts->ts_force_cch_reload) {
 		gts->ts_force_cch_reload = 0;
-		gru_update_cch(gts, 0);
+		gru_update_cch(gts);
 	}
 
 	ret = -EAGAIN;
 	cbrnum = thread_cbr_number(gts, ucbnum);
-	if (gts->ts_force_unload) {
-		gru_unload_context(gts, 1);
-	} else if (gts->ts_gru) {
+	if (gts->ts_gru) {
 		tfh = get_tfh_by_index(gts->ts_gru, cbrnum);
 		cbk = get_gseg_base_address_cb(gts->ts_gru->gs_gru_base_vaddr,
 				gts->ts_ctxnum, ucbnum);
diff -puN drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-3 drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-3
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -551,7 +551,6 @@ void gru_unload_context(struct gru_threa
 
 	if (cch_deallocate(cch))
 		BUG();
-	gts->ts_force_unload = 0;	/* ts_force_unload locked by CCH lock */
 	unlock_cch_handle(cch);
 
 	gru_free_gru_context(gts);
@@ -624,11 +623,8 @@ void gru_load_context(struct gru_thread_
  * Update fields in an active CCH:
  * 	- retarget interrupts on local blade
  * 	- update sizeavail mask
- * 	- force a delayed context unload by clearing the CCH asids. This
- * 	  forces TLB misses for new GRU instructions. The context is unloaded
- * 	  when the next TLB miss occurs.
  */
-int gru_update_cch(struct gru_thread_state *gts, int force_unload)
+int gru_update_cch(struct gru_thread_state *gts)
 {
 	struct gru_context_configuration_handle *cch;
 	struct gru_state *gru = gts->ts_gru;
@@ -642,21 +638,13 @@ int gru_update_cch(struct gru_thread_sta
 			goto exit;
 		if (cch_interrupt(cch))
 			BUG();
-		if (!force_unload) {
-			for (i = 0; i < 8; i++)
-				cch->sizeavail[i] = gts->ts_sizeavail;
-			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
-			cch->tlb_int_select = gru_cpu_fault_map_id();
-			cch->tfm_fault_bit_enable =
-			  (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-			    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
-		} else {
-			for (i = 0; i < 8; i++)
-				cch->asid[i] = 0;
-			cch->tfm_fault_bit_enable = 0;
-			cch->tlb_int_enable = 0;
-			gts->ts_force_unload = 1;
-		}
+		for (i = 0; i < 8; i++)
+			cch->sizeavail[i] = gts->ts_sizeavail;
+		gts->ts_tlb_int_select = gru_cpu_fault_map_id();
+		cch->tlb_int_select = gru_cpu_fault_map_id();
+		cch->tfm_fault_bit_enable =
+		  (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+		    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		if (cch_start(cch))
 			BUG();
 		ret = 1;
@@ -681,7 +669,7 @@ static int gru_retarget_intr(struct gru_
 
 	gru_dbg(grudev, "retarget from %d to %d\n", gts->ts_tlb_int_select,
 		gru_cpu_fault_map_id());
-	return gru_update_cch(gts, 0);
+	return gru_update_cch(gts);
 }
 
 /*
diff -puN drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-3 drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-3
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -382,8 +382,6 @@ struct gru_thread_state {
 	char			ts_blade;	/* If >= 0, migrate context if
 						   ref from diferent blade */
 	char			ts_force_cch_reload;
-	char			ts_force_unload;/* force context to be unloaded
-						   after migration */
 	char			ts_cbr_idx[GRU_CBR_AU];/* CBR numbers of each
 							  allocated CB */
 	int			ts_data_valid;	/* Indicates if ts_gdata has
@@ -636,7 +634,7 @@ extern struct gru_state *gru_assign_gru_
 extern void gru_load_context(struct gru_thread_state *gts);
 extern void gru_steal_context(struct gru_thread_state *gts);
 extern void gru_unload_context(struct gru_thread_state *gts, int savestate);
-extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
+extern int gru_update_cch(struct gru_thread_state *gts);
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(void);
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

