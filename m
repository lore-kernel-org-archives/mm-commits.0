From: akpm@linux-foundation.org
Subject: + gru-fix-prefetch-and-speculation-bugs.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:33 -0800
Message-ID: <200911241958.nAOJwYY5019043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932740AbZKXT6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix prefetch and speculation bugs
has been added to the -mm tree.  Its filename is
     gru-fix-prefetch-and-speculation-bugs.patch

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
Subject: gru: fix prefetch and speculation bugs
From: Jack Steiner <steiner@sgi.com>

Fix several bugs related to prefetch, ordering & speculation:

	- GRU cch_allocate() instruction causes cacheable memory
	  to be created. Add a barriers to prevent speculation
	  from prefetching data before it exists.
	- Add memory barriers before cache-flush instructions to ensure
	  that previously stored data is included in the line flushed to memory.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |    1 +
 drivers/misc/sgi-gru/grufault.c         |    2 ++
 drivers/misc/sgi-gru/gruhandles.c       |   22 ++++++++++++++++++++--
 drivers/misc/sgi-gru/grukservices.c     |   10 ++++++----
 drivers/misc/sgi-gru/grumain.c          |    9 +++++++++
 5 files changed, 38 insertions(+), 6 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-fix-prefetch-and-speculation-bugs drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-fix-prefetch-and-speculation-bugs
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -325,6 +325,7 @@ static inline void gru_flush_cache(void 
 static inline void gru_start_instruction(struct gru_instruction *ins, int op32)
 {
 	gru_ordered_store_int(ins, op32);
+	mb();
 	gru_flush_cache(ins);
 }
 
diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-prefetch-and-speculation-bugs drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-prefetch-and-speculation-bugs
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -333,6 +333,7 @@ static int gru_try_dropin(struct gru_thr
 	 */
 	if (tfh->status != TFHSTATUS_EXCEPTION) {
 		gru_flush_cache(tfh);
+		sync_core();
 		if (tfh->status != TFHSTATUS_EXCEPTION)
 			goto failnoexception;
 		STAT(tfh_stale_on_fault);
@@ -599,6 +600,7 @@ int gru_get_exception_detail(unsigned lo
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
 		gru_flush_cache(cbe);	/* CBE not coherent */
+		sync_core();		/* make sure we are have current data */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-fix-prefetch-and-speculation-bugs drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-fix-prefetch-and-speculation-bugs
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -91,9 +91,18 @@ static int wait_instruction_complete(voi
 
 int cch_allocate(struct gru_context_configuration_handle *cch)
 {
+	int ret;
+
 	cch->opc = CCHOP_ALLOCATE;
 	start_instruction(cch);
-	return wait_instruction_complete(cch, cchop_allocate);
+	ret = wait_instruction_complete(cch, cchop_allocate);
+
+	/*
+	 * Stop speculation into the GSEG being mapped by the previous ALLOCATE.
+	 * The GSEG memory does not exist until the ALLOCATE completes.
+	 */
+	sync_core();
+	return ret;
 }
 
 int cch_start(struct gru_context_configuration_handle *cch)
@@ -112,9 +121,18 @@ int cch_interrupt(struct gru_context_con
 
 int cch_deallocate(struct gru_context_configuration_handle *cch)
 {
+	int ret;
+
 	cch->opc = CCHOP_DEALLOCATE;
 	start_instruction(cch);
-	return wait_instruction_complete(cch, cchop_deallocate);
+	ret = wait_instruction_complete(cch, cchop_deallocate);
+
+	/*
+	 * Stop speculation into the GSEG being unmapped by the previous
+	 * DEALLOCATE.
+	 */
+	sync_core();
+	return ret;
 }
 
 int cch_interrupt_sync(struct gru_context_configuration_handle
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-prefetch-and-speculation-bugs drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-prefetch-and-speculation-bugs
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -395,6 +395,7 @@ int gru_get_cb_exception_detail(void *cb
 	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
 	cbe = get_cbe(GRUBASE(cb), cbrnum);
 	gru_flush_cache(cbe);	/* CBE not coherent */
+	sync_core();
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
@@ -461,9 +462,10 @@ int gru_check_status_proc(void *cb)
 	int ret;
 
 	ret = gen->istatus;
-	if (ret != CBS_EXCEPTION)
-		return ret;
-	return gru_retry_exception(cb);
+	if (ret == CBS_EXCEPTION)
+		ret = gru_retry_exception(cb);
+	rmb();
+	return ret;
 
 }
 
@@ -475,7 +477,7 @@ int gru_wait_proc(void *cb)
 	ret = gru_wait_idle_or_exception(gen);
 	if (ret == CBS_EXCEPTION)
 		ret = gru_retry_exception(cb);
-
+	rmb();
 	return ret;
 }
 
diff -puN drivers/misc/sgi-gru/grumain.c~gru-fix-prefetch-and-speculation-bugs drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-fix-prefetch-and-speculation-bugs
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -499,6 +499,9 @@ static void gru_load_context_data(void *
 			memset(cbe + i * GRU_HANDLE_STRIDE, 0,
 						GRU_CACHE_LINE_BYTES);
 		}
+		/* Flush CBE to hide race in context restart */
+		mb();
+		gru_flush_cache(cbe + i * GRU_HANDLE_STRIDE);
 		cb += GRU_HANDLE_STRIDE;
 	}
 
@@ -519,6 +522,12 @@ static void gru_unload_context_data(void
 	cb = gseg + GRU_CB_BASE;
 	cbe = grubase + GRU_CBE_BASE;
 	length = hweight64(dsrmap) * GRU_DSR_AU_BYTES;
+
+	/* CBEs may not be coherent. Flush them from cache */
+	for_each_cbr_in_allocation_map(i, &cbrmap, scr)
+		gru_flush_cache(cbe + i * GRU_HANDLE_STRIDE);
+	mb();		/* Let the CL flush complete */
+
 	gru_prefetch_context(gseg, cb, cbe, cbrmap, length);
 
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {
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

