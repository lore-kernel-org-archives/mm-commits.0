From: akpm@linux-foundation.org
Subject: + gru-change-context-load-and-unload.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:28 -0700
Message-ID: <200904092237.n39MbSdx032539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762640AbZDIWjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: change context load and unload
has been added to the -mm tree.  Its filename is
     gru-change-context-load-and-unload.patch

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

