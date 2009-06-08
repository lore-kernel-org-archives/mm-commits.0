From: akpm@linux-foundation.org
Subject: + gru-add-user-request-to-specify-gru-slice.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:28 -0700
Message-ID: <200906082311.n58NBSkl031147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249AbZFHXL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: add user request to specify gru slice
has been added to the -mm tree.  Its filename is
     gru-add-user-request-to-specify-gru-slice.patch

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
Subject: gru: add user request to specify gru slice
From: Jack Steiner <steiner@sgi.com>

Add a user request to specify the gru instruction slice parameter for user
contexts.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |    4 ++++
 drivers/misc/sgi-gru/grulib.h    |    2 +-
 drivers/misc/sgi-gru/grumain.c   |    7 +++++++
 drivers/misc/sgi-gru/grutables.h |    1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-user-request-to-specify-gru-slice drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-user-request-to-specify-gru-slice
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -769,6 +769,10 @@ int gru_set_context_option(unsigned long
  		/* Register the current task as the GSEG owner */
 		gts->ts_tgid_owner = current->tgid;
 		break;
+	case sco_cch_req_slice:
+ 		/* Set the CCH slice option */
+		gts->ts_cch_req_slice = req.val1 & 3;
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff -puN drivers/misc/sgi-gru/grulib.h~gru-add-user-request-to-specify-gru-slice drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-add-user-request-to-specify-gru-slice
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -98,7 +98,7 @@ struct gru_unload_context_req {
 /*
  * Structure used to set context options
  */
-enum {sco_gseg_owner};
+enum {sco_gseg_owner, sco_cch_req_slice};
 struct gru_set_context_option_req {
 	unsigned long	gseg;
 	int		op;
diff -puN drivers/misc/sgi-gru/grumain.c~gru-add-user-request-to-specify-gru-slice drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-add-user-request-to-specify-gru-slice
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -321,6 +321,7 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_tsid = tsid;
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_tlb_int_select = -1;
+	gts->ts_cch_req_slice = -1;
 	gts->ts_sizeavail = GRU_SIZEAVAIL(PAGE_SHIFT);
 	if (vma) {
 		gts->ts_mm = current->mm;
@@ -566,6 +567,12 @@ void gru_load_context(struct gru_thread_
 		gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 		cch->tlb_int_select = gts->ts_tlb_int_select;
 	}
+	if (gts->ts_cch_req_slice >= 0) {
+		cch->req_slice_set_enable = 1;
+		cch->req_slice = gts->ts_cch_req_slice;
+	} else {
+		cch->req_slice_set_enable =0;
+	}
 	cch->tfm_done_bit_enable = 0;
 	cch->dsr_allocation_map = gts->ts_dsr_map;
 	cch->cbr_allocation_map = gts->ts_cbr_map;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-add-user-request-to-specify-gru-slice drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-add-user-request-to-specify-gru-slice
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -380,6 +380,7 @@ struct gru_thread_state {
 						   required for contest */
 	unsigned char		ts_cbr_au_count;/* Number of CBR resources
 						   required for contest */
+	char			ts_cch_req_slice;/* CCH packet slice */
 	char			ts_blade;	/* If >= 0, migrate context if
 						   ref from diferent blade */
 	char			ts_force_cch_reload;
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

