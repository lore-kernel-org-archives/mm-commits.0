From: akpm@linux-foundation.org
Subject: [merged] gru-change-context-load-and-unload.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:34 -0700
Message-ID: <200906182248.n5IMmYY1007649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZFRWyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: change context load and unload
has been removed from the -mm tree.  Its filename was
     gru-change-context-load-and-unload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: change context load and unload
From: Jack Steiner <steiner@sgi.com>

Remove "static" from the functions for loading/unloading GRU contexts. 
These functions will be called from other GRU files.  Fix bug in unlocking
gru context.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |    4 ++--
 drivers/misc/sgi-gru/grumain.c   |   10 +++++-----
 drivers/misc/sgi-gru/grutables.h |    4 ++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-change-context-load-and-unload drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-change-context-load-and-unload
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -558,8 +558,8 @@ int gru_handle_user_call_os(unsigned lon
 	 * CCH may contain stale data if ts_force_cch_reload is set.
 	 */
 	if (gts->ts_gru && gts->ts_force_cch_reload) {
-		gru_update_cch(gts, 0);
 		gts->ts_force_cch_reload = 0;
+		gru_update_cch(gts, 0);
 	}
 
 	ret = -EAGAIN;
@@ -644,7 +644,7 @@ static int gru_unload_all_contexts(void)
 			if (gts && mutex_trylock(&gts->ts_ctxlock)) {
 				spin_unlock(&gru->gs_lock);
 				gru_unload_context(gts, 1);
-				gru_unlock_gts(gts);
+				mutex_unlock(&gts->ts_ctxlock);
 				spin_lock(&gru->gs_lock);
 			}
 		}
diff -puN drivers/misc/sgi-gru/grumain.c~gru-change-context-load-and-unload drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-change-context-load-and-unload
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -533,7 +533,7 @@ void gru_unload_context(struct gru_threa
  * Load a GRU context by copying it from the thread data structure in memory
  * to the GRU.
  */
-static void gru_load_context(struct gru_thread_state *gts)
+void gru_load_context(struct gru_thread_state *gts)
 {
 	struct gru_state *gru = gts->ts_gru;
 	struct gru_context_configuration_handle *cch;
@@ -600,8 +600,8 @@ int gru_update_cch(struct gru_thread_sta
 			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 			cch->tlb_int_select = gru_cpu_fault_map_id();
 			cch->tfm_fault_bit_enable =
-	    		    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-	     		    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
+				(gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+				|| gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
@@ -645,7 +645,7 @@ static int gru_retarget_intr(struct gru_
 #define next_gru(b, g)	(((g) < &(b)->bs_grus[GRU_CHIPLETS_PER_BLADE - 1]) ?  \
 				 ((g)+1) : &(b)->bs_grus[0])
 
-static void gru_steal_context(struct gru_thread_state *gts, int blade_id)
+void gru_steal_context(struct gru_thread_state *gts, int blade_id)
 {
 	struct gru_blade_state *blade;
 	struct gru_state *gru, *gru0;
@@ -711,7 +711,7 @@ static void gru_steal_context(struct gru
 /*
  * Scan the GRUs on the local blade & assign a GRU context.
  */
-static struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
+struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
 						int blade)
 {
 	struct gru_state *gru, *grux;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-change-context-load-and-unload drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-change-context-load-and-unload
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -611,6 +611,10 @@ extern struct gru_thread_state *gru_find
 				*vma, int tsid);
 extern struct gru_thread_state *gru_alloc_thread_state(struct vm_area_struct
 				*vma, int tsid);
+extern struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
+		int blade);
+extern void gru_load_context(struct gru_thread_state *gts);
+extern void gru_steal_context(struct gru_thread_state *gts, int blade_id);
 extern void gru_unload_context(struct gru_thread_state *gts, int savestate);
 extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
 extern void gts_drop(struct gru_thread_state *gts);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

