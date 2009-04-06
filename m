From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-improvements-to-gru-debug-messages-statistics.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:25 -0700
Message-ID: <200904061937.n36JbPCt012904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZDFTzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: improvements to GRU debug messages & statistics
has been removed from the -mm tree.  Its filename was
     sgi-gru-improvements-to-gru-debug-messages-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: improvements to GRU debug messages & statistics
From: Jack Steiner <steiner@sgi.com>

Improvements to GRU debug messages & statistics.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |    5 ++
 drivers/misc/sgi-gru/grufile.c      |    2 -
 drivers/misc/sgi-gru/grukservices.c |    4 +-
 drivers/misc/sgi-gru/grumain.c      |   48 ++++++++++++++------------
 drivers/misc/sgi-gru/gruprocfs.c    |    2 +
 drivers/misc/sgi-gru/grutables.h    |    2 +
 drivers/misc/sgi-gru/grutlbpurge.c  |    2 -
 7 files changed, 38 insertions(+), 27 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -449,6 +449,7 @@ irqreturn_t gru_intr(int irq, void *dev_
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
 			tfh_user_polling_mode(tfh);
+			STAT(intr_mm_lock_failed);
 		}
 	}
 	return IRQ_HANDLED;
@@ -508,8 +509,10 @@ int gru_handle_user_call_os(unsigned lon
 	 * context.
 	 */
 	if (gts->ts_tgid_owner == current->tgid && gts->ts_blade >= 0 &&
-				gts->ts_blade != uv_numa_blade_id())
+				gts->ts_blade != uv_numa_blade_id()) {
+		STAT(call_os_offnode_reference);
 		gts->ts_force_unload = 1;
+	}
 
 	ret = -EAGAIN;
 	cbrnum = thread_cbr_number(gts, ucbnum);
diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -275,7 +275,7 @@ static void gru_init_chiplet(struct gru_
 	gru->gs_cbr_map = (GRU_CBR_AU == 64) ? ~0 : (1UL << GRU_CBR_AU) - 1;
 	gru->gs_dsr_map = (1UL << GRU_DSR_AU) - 1;
 	gru_tgh_flush_init(gru);
-	gru_dbg(grudev, "bid %d, nid %d, gru %x, vaddr %p (0x%lx)\n",
+	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
 		gru->gs_gru_base_paddr);
 	gru_kservices_init(gru);
diff -puN drivers/misc/sgi-gru/grukservices.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -663,12 +663,12 @@ int gru_kservices_init(struct gru_state 
 	err = cch_allocate(cch, 0, cbr_map, dsr_map);
 	if (err) {
 		gru_dbg(grudev,
-			"Unable to allocate kernel CCH: gru %d, err %d\n",
+			"Unable to allocate kernel CCH: gid %d, err %d\n",
 			gru->gs_gid, err);
 		BUG();
 	}
 	if (cch_start(cch)) {
-		gru_dbg(grudev, "Unable to start kernel CCH: gru %d, err %d\n",
+		gru_dbg(grudev, "Unable to start kernel CCH: gid %d, err %d\n",
 			gru->gs_gid, err);
 		BUG();
 	}
diff -puN drivers/misc/sgi-gru/grumain.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -76,7 +76,7 @@ int gru_cpu_fault_map_id(void)
 /* Hit the asid limit. Start over */
 static int gru_wrap_asid(struct gru_state *gru)
 {
-	gru_dbg(grudev, "gru %p\n", gru);
+	gru_dbg(grudev, "gid %d\n", gru->gs_gid);
 	STAT(asid_wrap);
 	gru->gs_asid_gen++;
 	gru_flush_all_tlb(gru);
@@ -88,7 +88,7 @@ static int gru_reset_asid_limit(struct g
 {
 	int i, gid, inuse_asid, limit;
 
-	gru_dbg(grudev, "gru %p, asid 0x%x\n", gru, asid);
+	gru_dbg(grudev, "gid %d, asid 0x%x\n", gru->gs_gid, asid);
 	STAT(asid_next);
 	limit = MAX_ASID;
 	if (asid >= limit)
@@ -99,8 +99,9 @@ again:
 		if (!gru->gs_gts[i])
 			continue;
 		inuse_asid = gru->gs_gts[i]->ts_gms->ms_asids[gid].mt_asid;
-		gru_dbg(grudev, "gru %p, inuse_asid 0x%x, cxtnum %d, gts %p\n",
-			gru, inuse_asid, i, gru->gs_gts[i]);
+		gru_dbg(grudev, "gid %d, gts %p, gms %p, inuse 0x%x, cxt %d\n",
+			gru->gs_gid, gru->gs_gts[i], gru->gs_gts[i]->ts_gms,
+			inuse_asid, i);
 		if (inuse_asid == asid) {
 			asid += ASID_INC;
 			if (asid >= limit) {
@@ -120,8 +121,8 @@ again:
 	}
 	gru->gs_asid_limit = limit;
 	gru->gs_asid = asid;
-	gru_dbg(grudev, "gru %p, new asid 0x%x, new_limit 0x%x\n", gru, asid,
-		limit);
+	gru_dbg(grudev, "gid %d, new asid 0x%x, new_limit 0x%x\n", gru->gs_gid,
+					asid, limit);
 	return asid;
 }
 
@@ -137,7 +138,7 @@ static int gru_assign_asid(struct gru_st
 		asid = gru_reset_asid_limit(gru, asid);
 	spin_unlock(&gru->gs_asid_lock);
 
-	gru_dbg(grudev, "gru %p, asid 0x%x\n", gru, asid);
+	gru_dbg(grudev, "gid %d, asid 0x%x\n", gru->gs_gid, asid);
 	return asid;
 }
 
@@ -215,11 +216,12 @@ static int check_gru_resources(struct gr
  * TLB manangment requires tracking all GRU chiplets that have loaded a GSEG
  * context.
  */
-static int gru_load_mm_tracker(struct gru_state *gru, struct gru_mm_struct *gms,
-			       int ctxnum)
+static int gru_load_mm_tracker(struct gru_state *gru,
+					struct gru_thread_state *gts)
 {
+	struct gru_mm_struct *gms = gts->ts_gms;
 	struct gru_mm_tracker *asids = &gms->ms_asids[gru->gs_gid];
-	unsigned short ctxbitmap = (1 << ctxnum);
+	unsigned short ctxbitmap = (1 << gts->ts_ctxnum);
 	int asid;
 
 	spin_lock(&gms->ms_asid_lock);
@@ -241,24 +243,26 @@ static int gru_load_mm_tracker(struct gr
 	spin_unlock(&gms->ms_asid_lock);
 
 	gru_dbg(grudev,
-		"gru %x, gms %p, ctxnum 0x%d, asid 0x%x, asidmap 0x%lx\n",
-		gru->gs_gid, gms, ctxnum, asid, gms->ms_asidmap[0]);
+		"gid %d, gts %p, gms %p, ctxnum %d, asid 0x%x, asidmap 0x%lx\n",
+		gru->gs_gid, gts, gms, gts->ts_ctxnum, asid,
+		gms->ms_asidmap[0]);
 	return asid;
 }
 
 static void gru_unload_mm_tracker(struct gru_state *gru,
-				  struct gru_mm_struct *gms, int ctxnum)
+					struct gru_thread_state *gts)
 {
+	struct gru_mm_struct *gms = gts->ts_gms;
 	struct gru_mm_tracker *asids;
 	unsigned short ctxbitmap;
 
 	asids = &gms->ms_asids[gru->gs_gid];
-	ctxbitmap = (1 << ctxnum);
+	ctxbitmap = (1 << gts->ts_ctxnum);
 	spin_lock(&gms->ms_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gru %x, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
-		gru->gs_gid, gms, ctxnum, gms->ms_asidmap[0]);
+	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
+		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
 	spin_unlock(&gms->ms_asid_lock);
 }
 
@@ -399,7 +403,7 @@ static void gru_free_gru_context(struct 
 	struct gru_state *gru;
 
 	gru = gts->ts_gru;
-	gru_dbg(grudev, "gts %p, gru %p\n", gts, gru);
+	gru_dbg(grudev, "gts %p, gid %d\n", gts, gru->gs_gid);
 
 	spin_lock(&gru->gs_lock);
 	gru->gs_gts[gts->ts_ctxnum] = NULL;
@@ -500,12 +504,12 @@ void gru_unload_context(struct gru_threa
 	zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
+	gru_dbg(grudev, "gts %p\n", gts);
 	lock_cch_handle(cch);
 	if (cch_interrupt_sync(cch))
 		BUG();
-	gru_dbg(grudev, "gts %p\n", gts);
 
-	gru_unload_mm_tracker(gru, gts->ts_gms, gts->ts_ctxnum);
+	gru_unload_mm_tracker(gru, gts);
 	if (savestate)
 		gru_unload_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr,
 					ctxnum, gts->ts_cbr_map,
@@ -534,7 +538,7 @@ static void gru_load_context(struct gru_
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	lock_cch_handle(cch);
-	asid = gru_load_mm_tracker(gru, gts->ts_gms, gts->ts_ctxnum);
+	asid = gru_load_mm_tracker(gru, gts);
 	cch->tfm_fault_bit_enable =
 	    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
 	     || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
@@ -688,7 +692,7 @@ static void gru_steal_context(struct gru
 		STAT(steal_context_failed);
 	}
 	gru_dbg(grudev,
-		"stole gru %x, ctxnum %d from gts %p. Need cb %d, ds %d;"
+		"stole gid %d, ctxnum %d from gts %p. Need cb %d, ds %d;"
 		" avail cb %ld, ds %ld\n",
 		gru->gs_gid, ctxnum, ngts, cbr, dsr, hweight64(gru->gs_cbr_map),
 		hweight64(gru->gs_dsr_map));
@@ -737,7 +741,7 @@ again:
 
 		STAT(assign_context);
 		gru_dbg(grudev,
-			"gseg %p, gts %p, gru %x, ctx %d, cbr %d, dsr %d\n",
+			"gseg %p, gts %p, gid %d, ctx %d, cbr %d, dsr %d\n",
 			gseg_virtual_address(gts->ts_gru, gts->ts_ctxnum), gts,
 			gts->ts_gru->gs_gid, gts->ts_ctxnum,
 			gts->ts_cbr_au_count, gts->ts_dsr_au_count);
diff -puN drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -62,7 +62,9 @@ static int statistics_show(struct seq_fi
 	printstat(s, asid_wrap);
 	printstat(s, asid_reuse);
 	printstat(s, intr);
+	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
+	printstat(s, call_os_offnode_reference);
 	printstat(s, call_os_check_for_bug);
 	printstat(s, call_os_wait_queue);
 	printstat(s, user_flush_tlb);
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -184,7 +184,9 @@ struct gru_stats_s {
 	atomic_long_t asid_wrap;
 	atomic_long_t asid_reuse;
 	atomic_long_t intr;
+	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
+	atomic_long_t call_os_offnode_reference;
 	atomic_long_t call_os_check_for_bug;
 	atomic_long_t call_os_wait_queue;
 	atomic_long_t user_flush_tlb;
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~sgi-gru-improvements-to-gru-debug-messages-statistics drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~sgi-gru-improvements-to-gru-debug-messages-statistics
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -210,7 +210,7 @@ void gru_flush_all_tlb(struct gru_state 
 {
 	struct gru_tlb_global_handle *tgh;
 
-	gru_dbg(grudev, "gru %p, gid %d\n", gru, gru->gs_gid);
+	gru_dbg(grudev, "gid %d\n", gru->gs_gid);
 	tgh = get_lock_tgh_handle(gru);
 	tgh_invalidate(tgh, 0, ~0, 0, 1, 1, GRUMAXINVAL - 1, 0xffff);
 	get_unlock_tgh_handle(tgh);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

