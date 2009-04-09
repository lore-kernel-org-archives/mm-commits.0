From: akpm@linux-foundation.org
Subject: + gru-support-cch_allocate-for-kernel-threads.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:30 -0700
Message-ID: <200904092237.n39MbUwE032542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933757AbZDIWjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: support cch_allocate for kernel threads
has been added to the -mm tree.  Its filename is
     gru-support-cch_allocate-for-kernel-threads.patch

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
Subject: gru: support cch_allocate for kernel threads
From: Jack Steiner <steiner@sgi.com>

Change the interface to cch_allocate so that it can be used to allocate
GRU contexts for kernel threads.  Kernel threads use the GRU in unmapped
mode and do not require ASIDs for the GRU TLB.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.c   |   14 ++------------
 drivers/misc/sgi-gru/gruhandles.h   |    4 +---
 drivers/misc/sgi-gru/grukservices.c |    5 ++++-
 drivers/misc/sgi-gru/grumain.c      |   15 +++++++++++----
 4 files changed, 18 insertions(+), 20 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-support-cch_allocate-for-kernel-threads drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-support-cch_allocate-for-kernel-threads
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -72,18 +72,8 @@ static int wait_instruction_complete(voi
 	return status;
 }
 
-int cch_allocate(struct gru_context_configuration_handle *cch,
-		int asidval, int sizeavail, unsigned long cbrmap,
-		unsigned long dsrmap)
-{
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = (asidval++);
-		cch->sizeavail[i] = sizeavail;
-	}
-	cch->dsr_allocation_map = dsrmap;
-	cch->cbr_allocation_map = cbrmap;
+int cch_allocate(struct gru_context_configuration_handle *cch)
+{
 	cch->opc = CCHOP_ALLOCATE;
 	start_instruction(cch);
 	return wait_instruction_complete(cch, cchop_allocate);
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-support-cch_allocate-for-kernel-threads drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-support-cch_allocate-for-kernel-threads
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -480,9 +480,7 @@ enum gru_cbr_state {
 /* minimum TLB purge count to ensure a full purge */
 #define GRUMAXINVAL		1024UL
 
-int cch_allocate(struct gru_context_configuration_handle *cch,
-       int asidval, int sizeavail, unsigned long cbrmap, unsigned long dsrmap);
-
+int cch_allocate(struct gru_context_configuration_handle *cch);
 int cch_start(struct gru_context_configuration_handle *cch);
 int cch_interrupt(struct gru_context_configuration_handle *cch);
 int cch_deallocate(struct gru_context_configuration_handle *cch);
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-support-cch_allocate-for-kernel-threads drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-support-cch_allocate-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -672,7 +672,10 @@ int gru_kservices_init(struct gru_state 
 	cch->tlb_int_enable = 0;
 	cch->tfm_done_bit_enable = 0;
 	cch->unmap_enable = 1;
-	err = cch_allocate(cch, 0, 0, cbr_map, dsr_map);
+	cch->dsr_allocation_map = dsr_map;
+	cch->cbr_allocation_map = cbr_map;
+
+	err = cch_allocate(cch);
 	if (err) {
 		gru_dbg(grudev,
 			"Unable to allocate kernel CCH: gid %d, err %d\n",
diff -puN drivers/misc/sgi-gru/grumain.c~gru-support-cch_allocate-for-kernel-threads drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-support-cch_allocate-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -537,13 +537,12 @@ void gru_load_context(struct gru_thread_
 {
 	struct gru_state *gru = gts->ts_gru;
 	struct gru_context_configuration_handle *cch;
-	int err, asid, ctxnum = gts->ts_ctxnum;
+	int i, err, asid, ctxnum = gts->ts_ctxnum;
 
 	gru_dbg(grudev, "gts %p\n", gts);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	lock_cch_handle(cch);
-	asid = gru_load_mm_tracker(gru, gts);
 	cch->tfm_fault_bit_enable =
 	    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
 	     || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
@@ -553,8 +552,16 @@ void gru_load_context(struct gru_thread_
 		cch->tlb_int_select = gts->ts_tlb_int_select;
 	}
 	cch->tfm_done_bit_enable = 0;
-	err = cch_allocate(cch, asid, gts->ts_sizeavail, gts->ts_cbr_map,
-				gts->ts_dsr_map);
+	cch->dsr_allocation_map = gts->ts_dsr_map;
+	cch->cbr_allocation_map = gts->ts_cbr_map;
+	asid = gru_load_mm_tracker(gru, gts);
+	cch->unmap_enable = 0;
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = asid + i;
+		cch->sizeavail[i] = gts->ts_sizeavail;
+	}
+
+	err = cch_allocate(cch);
 	if (err) {
 		gru_dbg(grudev,
 			"err %d: cch %p, gts %p, cbr 0x%lx, dsr 0x%lx\n",
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-update-gru-kernel-self-tests.patch
gru-update-to-rev-09-of-gru-spec.patch

