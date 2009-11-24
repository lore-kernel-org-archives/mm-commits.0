From: akpm@linux-foundation.org
Subject: + gru-fix-istatus-race-in-gru-tlb-dropin.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:08 -0800
Message-ID: <200911241958.nAOJw9Mg017965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499AbZKXT6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix istatus race in GRU tlb dropin
has been added to the -mm tree.  Its filename is
     gru-fix-istatus-race-in-gru-tlb-dropin.patch

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
Subject: gru: fix istatus race in GRU tlb dropin
From: Jack Steiner <steiner@sgi.com>

TLB dropins require updates to the CBR instruction istatus field.  This is
needed to resolve race conditions in the chip.

The code currently uses the user address of the CBR.  This works but opens
up additional endcases related to stealing of contexts and accessing the
CBR from tasks that do not have access to the user address space.  (Some
of this non-user task access is debug code that is not currently being
pushed to the community).

User CBRs are also directly accessible using the kernel mapping of the
CBR.  Change the TLB dropin code to use the the kernel mapping of the CBR.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   53 ++++++++++++------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-istatus-race-in-gru-tlb-dropin drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-istatus-race-in-gru-tlb-dropin
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -122,22 +122,11 @@ static void gru_unlock_gts(struct gru_th
  * is necessary to prevent the user from seeing a stale cb.istatus that will
  * change as soon as the TFH restart is complete. Races may cause an
  * occasional failure to clear the cb.istatus, but that is ok.
- *
- * If the cb address is not valid (should not happen, but...), nothing
- * bad will happen.. The get_user()/put_user() will fail but there
- * are no bad side-effects.
- */
-static void gru_cb_set_istatus_active(unsigned long __user *cb)
-{
-	union {
-		struct gru_instruction_bits bits;
-		unsigned long dw;
-	} u;
-
-	if (cb) {
-		get_user(u.dw, cb);
-		u.bits.istatus = CBS_ACTIVE;
-		put_user(u.dw, cb);
+ */
+static void gru_cb_set_istatus_active(struct gru_instruction_bits *cbk)
+{
+	if (cbk) {
+		cbk->istatus = CBS_ACTIVE;
 	}
 }
 
@@ -322,9 +311,9 @@ upm:
  */
 static int gru_try_dropin(struct gru_thread_state *gts,
 			  struct gru_tlb_fault_handle *tfh,
-			  unsigned long __user *cb)
+			  struct gru_instruction_bits *cbk)
 {
-	int pageshift = 0, asid, write, ret, atomic = !cb;
+	int pageshift = 0, asid, write, ret, atomic = !cbk;
 	unsigned long gpa = 0, vaddr = 0;
 
 	/*
@@ -347,7 +336,7 @@ static int gru_try_dropin(struct gru_thr
 	}
 	if (tfh->state == TFHSTATE_IDLE)
 		goto failidle;
-	if (tfh->state == TFHSTATE_MISS_FMM && cb)
+	if (tfh->state == TFHSTATE_MISS_FMM && cbk)
 		goto failfmm;
 
 	write = (tfh->cause & TFHCAUSE_TLB_MOD) != 0;
@@ -378,7 +367,7 @@ static int gru_try_dropin(struct gru_thr
 			goto failupm;
 		}
 	}
-	gru_cb_set_istatus_active(cb);
+	gru_cb_set_istatus_active(cbk);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
 	STAT(tlb_dropin);
@@ -392,7 +381,7 @@ failnoasid:
 	/* No asid (delayed unload). */
 	STAT(tlb_dropin_fail_no_asid);
 	gru_dbg(grudev, "FAILED no_asid tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
-	if (!cb)
+	if (!cbk)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
@@ -415,17 +404,18 @@ failfmm:
 failnoexception:
 	/* TFH status did not show exception pending */
 	gru_flush_cache(tfh);
-	if (cb)
-		gru_flush_cache(cb);
+	if (cbk)
+		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_no_exception);
-	gru_dbg(grudev, "FAILED non-exception tfh: 0x%p, status %d, state %d\n", tfh, tfh->status, tfh->state);
+	gru_dbg(grudev, "FAILED non-exception tfh: 0x%p, status %d, state %d\n",
+		tfh, tfh->status, tfh->state);
 	return 0;
 
 failidle:
 	/* TFH state was idle  - no miss pending */
 	gru_flush_cache(tfh);
-	if (cb)
-		gru_flush_cache(cb);
+	if (cbk)
+		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_idle);
 	gru_dbg(grudev, "FAILED idle tfh: 0x%p, state %d\n", tfh, tfh->state);
 	return 0;
@@ -439,7 +429,7 @@ failinval:
 
 failactive:
 	/* Range invalidate active. Switch to UPM iff atomic */
-	if (!cb)
+	if (!cbk)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
@@ -512,7 +502,7 @@ irqreturn_t gru_intr(int irq, void *dev_
 
 static int gru_user_dropin(struct gru_thread_state *gts,
 			   struct gru_tlb_fault_handle *tfh,
-			   unsigned long __user *cb)
+			   void *cb)
 {
 	struct gru_mm_struct *gms = gts->ts_gms;
 	int ret;
@@ -538,7 +528,7 @@ int gru_handle_user_call_os(unsigned lon
 {
 	struct gru_tlb_fault_handle *tfh;
 	struct gru_thread_state *gts;
-	unsigned long __user *cbp;
+	void *cbk;
 	int ucbnum, cbrnum, ret = -EINVAL;
 
 	STAT(call_os);
@@ -548,7 +538,6 @@ int gru_handle_user_call_os(unsigned lon
 	ucbnum = get_cb_number((void *)cb);
 	if ((cb & (GRU_HANDLE_STRIDE - 1)) || ucbnum >= GRU_NUM_CB)
 		return -EINVAL;
-	cbp = (unsigned long *)cb;
 
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
@@ -583,7 +572,9 @@ int gru_handle_user_call_os(unsigned lon
 		gru_unload_context(gts, 1);
 	} else if (gts->ts_gru) {
 		tfh = get_tfh_by_index(gts->ts_gru, cbrnum);
-		ret = gru_user_dropin(gts, tfh, cbp);
+		cbk = get_gseg_base_address_cb(gts->ts_gru->gs_gru_base_vaddr,
+				gts->ts_ctxnum, ucbnum);
+		ret = gru_user_dropin(gts, tfh, cbk);
 	}
 exit:
 	gru_unlock_gts(gts);
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

