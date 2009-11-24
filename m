From: akpm@linux-foundation.org
Subject: + gru-check-for-correct-gru-chiplet-assignment.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:50 -0800
Message-ID: <200911241958.nAOJwo9L019715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932769AbZKXT6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: check for correct GRU chiplet assignment
has been added to the -mm tree.  Its filename is
     gru-check-for-correct-gru-chiplet-assignment.patch

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
Subject: gru: check for correct GRU chiplet assignment
From: Jack Steiner <steiner@sgi.com>

Simplify the code that checks for correct assignment of GRU contexts to
users.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |   44 +++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff -puN drivers/misc/sgi-gru/grumain.c~gru-check-for-correct-gru-chiplet-assignment drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-check-for-correct-gru-chiplet-assignment
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -53,12 +53,16 @@ struct device *grudev = &gru_device;
  */
 int gru_cpu_fault_map_id(void)
 {
+#ifdef CONFIG_IA64
+	return uv_blade_processor_id() % GRU_NUM_TFM;
+#else
 	int cpu = smp_processor_id();
 	int id, core;
 
 	core = uv_cpu_core_number(cpu);
 	id = core + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
 	return id;
+#endif
 }
 
 /*--------- ASID Management -------------------------------------------
@@ -699,15 +703,34 @@ static int gru_retarget_intr(struct gru_
 }
 
 /*
+ * Check if a GRU context is allowed to use a specific chiplet. By default
+ * a context is assigned to any blade-local chiplet. However, users can
+ * override this.
+ * 	Returns 1 if assignment allowed, 0 otherwise
+ */
+static int gru_check_chiplet_assignment(struct gru_state *gru,
+					struct gru_thread_state *gts)
+{
+	int blade_id;
+	int chiplet_id;
+
+	blade_id = gts->ts_user_blade_id;
+	if (blade_id < 0)
+		blade_id = uv_numa_blade_id();
+
+	chiplet_id = gts->ts_user_chiplet_id;
+	return gru->gs_blade_id == blade_id &&
+		(chiplet_id < 0 || chiplet_id == gru->gs_chiplet_id);
+}
+
+/*
  * Unload the gru context if it is not assigned to the correct blade or
  * chiplet. Misassignment can occur if the process migrates to a different
  * blade or if the user changes the selected blade/chiplet.
- * 	Return 0 if  context correct placed, otherwise 1
  */
 void gru_check_context_placement(struct gru_thread_state *gts)
 {
 	struct gru_state *gru;
-	int blade_id, chiplet_id;
 
 	/*
 	 * If the current task is the context owner, verify that the
@@ -718,13 +741,7 @@ void gru_check_context_placement(struct 
 	if (!gru || gts->ts_tgid_owner != current->tgid)
 		return;
 
-	blade_id = gts->ts_user_blade_id;
-	if (blade_id < 0)
-		blade_id = uv_numa_blade_id();
-
-	chiplet_id = gts->ts_user_chiplet_id;
-	if (gru->gs_blade_id != blade_id ||
-	    (chiplet_id >= 0 && chiplet_id != gru->gs_chiplet_id)) {
+	if (!gru_check_chiplet_assignment(gru, gts)) {
 		STAT(check_context_unload);
 		gru_unload_context(gts, 1);
 	} else if (gru_retarget_intr(gts)) {
@@ -768,9 +785,9 @@ void gru_steal_context(struct gru_thread
 	struct gru_state *gru, *gru0;
 	struct gru_thread_state *ngts = NULL;
 	int ctxnum, ctxnum0, flag = 0, cbr, dsr;
-	int blade_id = gts->ts_user_blade_id;
-	int chiplet_id = gts->ts_user_chiplet_id;
+	int blade_id;
 
+	blade_id = gts->ts_user_blade_id;
 	if (blade_id < 0)
 		blade_id = uv_numa_blade_id();
 	cbr = gts->ts_cbr_au_count;
@@ -788,7 +805,7 @@ void gru_steal_context(struct gru_thread
 	ctxnum0 = ctxnum;
 	gru0 = gru;
 	while (1) {
-		if (chiplet_id < 0 || chiplet_id == gru->gs_chiplet_id) {
+		if (gru_check_chiplet_assignment(gru, gts)) {
 			if (check_gru_resources(gru, cbr, dsr, GRU_NUM_CCH))
 				break;
 			spin_lock(&gru->gs_lock);
@@ -853,7 +870,6 @@ struct gru_state *gru_assign_gru_context
 	struct gru_state *gru, *grux;
 	int i, max_active_contexts;
 	int blade_id = gts->ts_user_blade_id;
-	int chiplet_id = gts->ts_user_chiplet_id;
 
 	if (blade_id < 0)
 		blade_id = uv_numa_blade_id();
@@ -861,7 +877,7 @@ again:
 	gru = NULL;
 	max_active_contexts = GRU_NUM_CCH;
 	for_each_gru_on_blade(grux, blade_id, i) {
-		if (chiplet_id >= 0 && chiplet_id != grux->gs_chiplet_id)
+		if (!gru_check_chiplet_assignment(grux, gts))
 			continue;
 		if (check_gru_resources(grux, gts->ts_cbr_au_count,
 					gts->ts_dsr_au_count,
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

