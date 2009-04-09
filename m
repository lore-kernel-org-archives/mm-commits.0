From: akpm@linux-foundation.org
Subject: + gru-update-to-rev-09-of-gru-spec.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:46 -0700
Message-ID: <200904092237.n39Mbkr1032662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760830AbZDIWjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: update to rev 0.9 of gru spec
has been added to the -mm tree.  Its filename is
     gru-update-to-rev-09-of-gru-spec.patch

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
Subject: gru: update to rev 0.9 of gru spec
From: Jack Steiner <steiner@sgi.com>

Update GRU driver to the latest version of the GRU spec. This consists
of minor updates:
	- changes & additions to error status bits
	- new restriction on handling of TLB misses while in FMM mode
	- new field (not used by software) in TFH

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |   19 ++++++++++++-------
 drivers/misc/sgi-gru/grufault.c         |    8 ++++++--
 drivers/misc/sgi-gru/gruhandles.h       |    3 ++-
 drivers/misc/sgi-gru/grukservices.c     |    3 ++-
 drivers/misc/sgi-gru/gruprocfs.c        |    1 +
 drivers/misc/sgi-gru/grutables.h        |    1 +
 6 files changed, 24 insertions(+), 11 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -253,32 +253,37 @@ struct gru_instruction {
 #define CBE_CAUSE_HA_RESPONSE_FATAL		(1 << 13)
 #define CBE_CAUSE_HA_RESPONSE_NON_FATAL		(1 << 14)
 #define CBE_CAUSE_ADDRESS_SPACE_DECODE_ERROR	(1 << 15)
-#define CBE_CAUSE_RESPONSE_DATA_ERROR		(1 << 16)
-#define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 17)
+#define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 16)
+#define CBE_CAUSE_RA_RESPONSE_DATA_ERROR	(1 << 17)
+#define CBE_CAUSE_HA_RESPONSE_DATA_ERROR	(1 << 18)
 
 /* CBE cbrexecstatus bits */
 #define CBR_EXS_ABORT_OCC_BIT			0
 #define CBR_EXS_INT_OCC_BIT			1
 #define CBR_EXS_PENDING_BIT			2
 #define CBR_EXS_QUEUED_BIT			3
-#define CBR_EXS_TLBHW_BIT			4
+#define CBR_EXS_TLB_INVAL_BIT			4
 #define CBR_EXS_EXCEPTION_BIT			5
 
 #define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
 #define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
 #define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
 #define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_EXS_TLBHW				(1 << CBR_EXS_TLBHW_BIT)
+#define CBR_TLB_INVAL				(1 << CBR_EXS_TLB_INVAL_BIT)
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
 
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
  * in ecause, the exception is not retryable.
  */
-#define EXCEPTION_RETRY_BITS (CBE_CAUSE_RESPONSE_DATA_ERROR |		\
-			      CBE_CAUSE_RA_REQUEST_TIMEOUT |		\
+#define EXCEPTION_RETRY_BITS (CBE_CAUSE_EXECUTION_HW_ERROR |		\
 			      CBE_CAUSE_TLBHW_ERROR |			\
-			      CBE_CAUSE_HA_REQUEST_TIMEOUT)
+			      CBE_CAUSE_RA_REQUEST_TIMEOUT |		\
+			      CBE_CAUSE_RA_RESPONSE_NON_FATAL |		\
+			      CBE_CAUSE_HA_RESPONSE_NON_FATAL |		\
+			      CBE_CAUSE_RA_RESPONSE_DATA_ERROR |	\
+			      CBE_CAUSE_HA_RESPONSE_DATA_ERROR		\
+			      )
 
 /* Message queue head structure */
 union gru_mesqhead {
diff -puN drivers/misc/sgi-gru/grufault.c~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -339,8 +339,12 @@ static int gru_try_dropin(struct gru_thr
 	 * Might be a hardware race OR a stupid user. Ignore FMM because FMM
 	 * is a transient state.
 	 */
-	if (tfh->status != TFHSTATUS_EXCEPTION)
-		goto failnoexception;
+	if (tfh->status != TFHSTATUS_EXCEPTION) {
+		gru_flush_cache(tfh);
+		if (tfh->status != TFHSTATUS_EXCEPTION)
+			goto failnoexception;
+		STAT(tfh_stale_on_fault);
+	}
 	if (tfh->state == TFHSTATE_IDLE)
 		goto failidle;
 	if (tfh->state == TFHSTATE_MISS_FMM && cb)
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -255,7 +255,8 @@ struct gru_tlb_fault_handle {
 	unsigned int state:3;
 	unsigned int fill3:1;
 
-	unsigned int cause:7;
+	unsigned int cause:6;
+	unsigned int cb_int:1;
 	unsigned int fill4:1;
 
 	unsigned int indexway:12;	/* DW 0 - high 32 */
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -406,7 +406,8 @@ static int gru_retry_exception(void *cb)
 			return CBS_IDLE;
 
 		gru_get_cb_exception_detail(cb, &excdet);
-		if (excdet.ecause & ~EXCEPTION_RETRY_BITS)
+		if ((excdet.ecause & ~EXCEPTION_RETRY_BITS) ||
+				(excdet.cbrexecstatus & CBR_EXS_ABORT_OCC))
 			break;
 		if (retry-- == 0)
 			break;
diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -89,6 +89,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin_fail_fmm);
 	printstat(s, tlb_dropin_fail_no_exception);
 	printstat(s, tlb_dropin_fail_no_exception_war);
+	printstat(s, tfh_stale_on_fault);
 	printstat(s, mmu_invalidate_range);
 	printstat(s, mmu_invalidate_page);
 	printstat(s, mmu_clear_flush_young);
diff -puN drivers/misc/sgi-gru/grutables.h~gru-update-to-rev-09-of-gru-spec drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-update-to-rev-09-of-gru-spec
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -212,6 +212,7 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin_fail_fmm;
 	atomic_long_t tlb_dropin_fail_no_exception;
 	atomic_long_t tlb_dropin_fail_no_exception_war;
+	atomic_long_t tfh_stale_on_fault;
 	atomic_long_t mmu_invalidate_range;
 	atomic_long_t mmu_invalidate_page;
 	atomic_long_t mmu_clear_flush_young;
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

