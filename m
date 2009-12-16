From: akpm@linux-foundation.org
Subject: [merged] gru-improve-gru-tlb-dropin-statistics.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:11 -0800
Message-ID: <200912162041.nBGKfB7N013715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965031AbZLPUlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: improve GRU TLB dropin statistics
has been removed from the -mm tree.  Its filename was
     gru-improve-gru-tlb-dropin-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

