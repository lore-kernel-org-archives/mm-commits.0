From: akpm@linux-foundation.org
Subject: + sgi-gru-asid-context-management-bug-fixes.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:25:06 -0800
Message-ID: <200901280025.n0S0P6Td004778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbZA1AZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     sgi-gru: aSID (context management) bug fixes
has been added to the -mm tree.  Its filename is
     sgi-gru-asid-context-management-bug-fixes.patch

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
Subject: sgi-gru: aSID (context management) bug fixes
From: Jack Steiner <steiner@sgi.com>

This patch fixes bugs related to ASID (context id) management in the GRU
driver.  These changes are all internal to the SGI GRU driver and have no
effect on the base kernel.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    1 +
 drivers/misc/sgi-gru/grumain.c |   13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-asid-context-management-bug-fixes drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-asid-context-management-bug-fixes
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -286,6 +286,7 @@ static void gru_init_chiplet(struct gru_
 	gru->gs_blade_id = bid;
 	gru->gs_cbr_map = (GRU_CBR_AU == 64) ? ~0 : (1UL << GRU_CBR_AU) - 1;
 	gru->gs_dsr_map = (1UL << GRU_DSR_AU) - 1;
+	gru->gs_asid_limit = MAX_ASID;
 	gru_tgh_flush_init(gru);
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
diff -puN drivers/misc/sgi-gru/grumain.c~sgi-gru-asid-context-management-bug-fixes drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~sgi-gru-asid-context-management-bug-fixes
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -79,7 +79,6 @@ static int gru_wrap_asid(struct gru_stat
 	gru_dbg(grudev, "gid %d\n", gru->gs_gid);
 	STAT(asid_wrap);
 	gru->gs_asid_gen++;
-	gru_flush_all_tlb(gru);
 	return MIN_ASID;
 }
 
@@ -93,6 +92,7 @@ static int gru_reset_asid_limit(struct g
 	limit = MAX_ASID;
 	if (asid >= limit)
 		asid = gru_wrap_asid(gru);
+	gru_flush_all_tlb(gru);
 	gid = gru->gs_gid;
 again:
 	for (i = 0; i < GRU_NUM_CCH; i++) {
@@ -131,12 +131,10 @@ static int gru_assign_asid(struct gru_st
 {
 	int asid;
 
-	spin_lock(&gru->gs_asid_lock);
 	gru->gs_asid += ASID_INC;
 	asid = gru->gs_asid;
 	if (asid >= gru->gs_asid_limit)
 		asid = gru_reset_asid_limit(gru, asid);
-	spin_unlock(&gru->gs_asid_lock);
 
 	gru_dbg(grudev, "gid %d, asid 0x%x\n", gru->gs_gid, asid);
 	return asid;
@@ -227,7 +225,9 @@ static int gru_load_mm_tracker(struct gr
 	spin_lock(&gms->ms_asid_lock);
 	asid = asids->mt_asid;
 
-	if (asid == 0 || asids->mt_asid_gen != gru->gs_asid_gen) {
+	spin_lock(&gru->gs_asid_lock);
+	if (asid == 0 || (asids->mt_ctxbitmap == 0 && asids->mt_asid_gen !=
+			  gru->gs_asid_gen)) {
 		asid = gru_assign_asid(gru);
 		asids->mt_asid = asid;
 		asids->mt_asid_gen = gru->gs_asid_gen;
@@ -235,6 +235,7 @@ static int gru_load_mm_tracker(struct gr
 	} else {
 		STAT(asid_reuse);
 	}
+	spin_unlock(&gru->gs_asid_lock);
 
 	BUG_ON(asids->mt_ctxbitmap & ctxbitmap);
 	asids->mt_ctxbitmap |= ctxbitmap;
@@ -259,10 +260,12 @@ static void gru_unload_mm_tracker(struct
 	asids = &gms->ms_asids[gru->gs_gid];
 	ctxbitmap = (1 << gts->ts_ctxnum);
 	spin_lock(&gms->ms_asid_lock);
+	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
 	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
+	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
 }
 
@@ -412,6 +415,7 @@ static void gru_free_gru_context(struct 
 	__clear_bit(gts->ts_ctxnum, &gru->gs_context_map);
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_gru = NULL;
+	gts->ts_blade = -1;
 	spin_unlock(&gru->gs_lock);
 
 	gts_drop(gts);
@@ -731,6 +735,7 @@ again:
 		}
 		reserve_gru_resources(gru, gts);
 		gts->ts_gru = gru;
+		gts->ts_blade = gru->gs_blade_id;
 		gts->ts_ctxnum =
 		    find_first_zero_bit(&gru->gs_context_map, GRU_NUM_CCH);
 		BUG_ON(gts->ts_ctxnum == GRU_NUM_CCH);
_

Patches currently in -mm which might be from steiner@sgi.com are

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

