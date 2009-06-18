From: akpm@linux-foundation.org
Subject: [merged] gru-check-context-state-on-reload.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:44 -0700
Message-ID: <200906182248.n5IMmit2007817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbZFRWzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: check context state on reload
has been removed from the -mm tree.  Its filename was
     gru-check-context-state-on-reload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: check context state on reload
From: Jack Steiner <steiner@sgi.com>

Check whether the gru state being loaded into a gru is from a new context
or a previously unloaded context.  If new, simply zero out the hardware
context; if unloaded and valid, reload the old state.

This change is primarily for reloading kernel contexts where the previous
is not required to be saved.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c   |   32 ++++++++++++++++++++---------
 drivers/misc/sgi-gru/grutables.h |    2 +
 2 files changed, 25 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grumain.c~gru-check-context-state-on-reload drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-check-context-state-on-reload
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -307,11 +307,12 @@ struct gru_thread_state *gru_alloc_gts(s
 
 	bytes = DSR_BYTES(dsr_au_count) + CBR_BYTES(cbr_au_count);
 	bytes += sizeof(struct gru_thread_state);
-	gts = kzalloc(bytes, GFP_KERNEL);
+	gts = kmalloc(bytes, GFP_KERNEL);
 	if (!gts)
 		return NULL;
 
 	STAT(gts_alloc);
+	memset(gts, 0, sizeof(struct gru_thread_state)); /* zero out header */
 	atomic_set(&gts->ts_refcnt, 1);
 	mutex_init(&gts->ts_ctxlock);
 	gts->ts_cbr_au_count = cbr_au_count;
@@ -458,7 +459,8 @@ static void gru_prefetch_context(void *g
 }
 
 static void gru_load_context_data(void *save, void *grubase, int ctxnum,
-				  unsigned long cbrmap, unsigned long dsrmap)
+				  unsigned long cbrmap, unsigned long dsrmap,
+				  int data_valid)
 {
 	void *gseg, *cb, *cbe;
 	unsigned long length;
@@ -471,12 +473,22 @@ static void gru_load_context_data(void *
 	gru_prefetch_context(gseg, cb, cbe, cbrmap, length);
 
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {
-		save += gru_copy_handle(cb, save);
-		save += gru_copy_handle(cbe + i * GRU_HANDLE_STRIDE, save);
+		if (data_valid) {
+			save += gru_copy_handle(cb, save);
+			save += gru_copy_handle(cbe + i * GRU_HANDLE_STRIDE,
+						save);
+		} else {
+			memset(cb, 0, GRU_CACHE_LINE_BYTES);
+			memset(cbe + i * GRU_HANDLE_STRIDE, 0,
+						GRU_CACHE_LINE_BYTES);
+		}
 		cb += GRU_HANDLE_STRIDE;
 	}
 
-	memcpy(gseg + GRU_DS_BASE, save, length);
+	if (data_valid)
+		memcpy(gseg + GRU_DS_BASE, save, length);
+	else
+		memset(gseg + GRU_DS_BASE, 0, length);
 }
 
 static void gru_unload_context_data(void *save, void *grubase, int ctxnum,
@@ -517,10 +529,12 @@ void gru_unload_context(struct gru_threa
 
 	if (!is_kernel_context(gts))
 		gru_unload_mm_tracker(gru, gts);
-	if (savestate)
+	if (savestate) {
 		gru_unload_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr,
 					ctxnum, gts->ts_cbr_map,
 					gts->ts_dsr_map);
+		gts->ts_data_valid = 1;
+	}
 
 	if (cch_deallocate(cch))
 		BUG();
@@ -576,7 +590,7 @@ void gru_load_context(struct gru_thread_
 	}
 
 	gru_load_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr, ctxnum,
-			      gts->ts_cbr_map, gts->ts_dsr_map);
+			gts->ts_cbr_map, gts->ts_dsr_map, gts->ts_data_valid);
 
 	if (cch_start(cch))
 		BUG();
@@ -611,8 +625,8 @@ int gru_update_cch(struct gru_thread_sta
 			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 			cch->tlb_int_select = gru_cpu_fault_map_id();
 			cch->tfm_fault_bit_enable =
-				(gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-				|| gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
+			  (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+			    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-check-context-state-on-reload drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-check-context-state-on-reload
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -385,6 +385,8 @@ struct gru_thread_state {
 						   after migration */
 	char			ts_cbr_idx[GRU_CBR_AU];/* CBR numbers of each
 							  allocated CB */
+	int			ts_data_valid;	/* Indicates if ts_gdata has
+						   valid data */
 	unsigned long		ts_gdata[0];	/* save area for GRU data (CB,
 						   DS, CBE) */
 };
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

