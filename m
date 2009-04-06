From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-support-multiple-pagesizes-in-gru.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:43 -0700
Message-ID: <200904061937.n36Jbhbt013038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZDFTyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:54:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: support multiple pagesizes in GRU
has been removed from the -mm tree.  Its filename was
     sgi-gru-support-multiple-pagesizes-in-gru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: support multiple pagesizes in GRU
From: Jack Steiner <steiner@sgi.com>

Add multiple pagesize support to the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |   15 +++++++++++
 drivers/misc/sgi-gru/gruhandles.c   |   34 +++-----------------------
 drivers/misc/sgi-gru/gruhandles.h   |    2 -
 drivers/misc/sgi-gru/grukservices.c |    2 -
 drivers/misc/sgi-gru/grumain.c      |   17 ++++++++-----
 drivers/misc/sgi-gru/grutables.h    |    3 ++
 6 files changed, 35 insertions(+), 38 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -360,6 +360,13 @@ static int gru_try_dropin(struct gru_thr
 	if (ret == -2)
 		goto failupm;
 
+	if (!(gts->ts_sizeavail & GRU_SIZEAVAIL(pageshift))) {
+		gts->ts_sizeavail |= GRU_SIZEAVAIL(pageshift);
+		if (atomic || !gru_update_cch(gts, 0)) {
+			gts->ts_force_cch_reload = 1;
+			goto failupm;
+		}
+	}
 	gru_cb_set_istatus_active(cb);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
@@ -535,6 +542,14 @@ int gru_handle_user_call_os(unsigned lon
 		gts->ts_force_unload = 1;
 	}
 
+	/*
+	 * CCH may contain stale data if ts_force_cch_reload is set.
+	 */
+	if (gts->ts_gru && gts->ts_force_cch_reload) {
+		gru_update_cch(gts, 0);
+		gts->ts_force_cch_reload = 0;
+	}
+
 	ret = -EAGAIN;
 	cbrnum = thread_cbr_number(gts, ucbnum);
 	if (gts->ts_force_unload) {
diff -puN drivers/misc/sgi-gru/gruhandles.c~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -72,42 +72,16 @@ static int wait_instruction_complete(voi
 	return status;
 }
 
-#if defined CONFIG_IA64
-static void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
+int cch_allocate(struct gru_context_configuration_handle *cch,
+		int asidval, int sizeavail, unsigned long cbrmap,
+		unsigned long dsrmap)
 {
 	int i;
 
 	for (i = 0; i < 8; i++) {
 		cch->asid[i] = (asidval++);
-#if 0
-		/* ZZZ hugepages not supported yet */
-		if (i == RGN_HPAGE)
-			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
-		else
-#endif
-			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
+		cch->sizeavail[i] = sizeavail;
 	}
-}
-#elif defined CONFIG_X86_64
-static void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
-{
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = asidval++;
-		cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT) |
-			GRU_SIZEAVAIL(21);
-	}
-}
-#endif
-
-int cch_allocate(struct gru_context_configuration_handle *cch,
-			       int asidval, unsigned long cbrmap,
-			       unsigned long dsrmap)
-{
-	cch_allocate_set_asids(cch, asidval);
 	cch->dsr_allocation_map = dsrmap;
 	cch->cbr_allocation_map = cbrmap;
 	cch->opc = CCHOP_ALLOCATE;
diff -puN drivers/misc/sgi-gru/gruhandles.h~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -496,7 +496,7 @@ enum gru_cbr_state {
 #define GRUMAXINVAL		1024UL
 
 int cch_allocate(struct gru_context_configuration_handle *cch,
-       int asidval, unsigned long cbrmap, unsigned long dsrmap);
+       int asidval, int sizeavail, unsigned long cbrmap, unsigned long dsrmap);
 
 int cch_start(struct gru_context_configuration_handle *cch);
 int cch_interrupt(struct gru_context_configuration_handle *cch);
diff -puN drivers/misc/sgi-gru/grukservices.c~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -672,7 +672,7 @@ int gru_kservices_init(struct gru_state 
 	cch->tlb_int_enable = 0;
 	cch->tfm_done_bit_enable = 0;
 	cch->unmap_enable = 1;
-	err = cch_allocate(cch, 0, cbr_map, dsr_map);
+	err = cch_allocate(cch, 0, 0, cbr_map, dsr_map);
 	if (err) {
 		gru_dbg(grudev,
 			"Unable to allocate kernel CCH: gid %d, err %d\n",
diff -puN drivers/misc/sgi-gru/grumain.c~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -326,6 +326,7 @@ static struct gru_thread_state *gru_allo
 	gts->ts_vma = vma;
 	gts->ts_tlb_int_select = -1;
 	gts->ts_gms = gru_register_mmu_notifier();
+	gts->ts_sizeavail = GRU_SIZEAVAIL(PAGE_SHIFT);
 	if (!gts->ts_gms)
 		goto err;
 
@@ -552,7 +553,8 @@ static void gru_load_context(struct gru_
 		cch->tlb_int_select = gts->ts_tlb_int_select;
 	}
 	cch->tfm_done_bit_enable = 0;
-	err = cch_allocate(cch, asid, gts->ts_cbr_map, gts->ts_dsr_map);
+	err = cch_allocate(cch, asid, gts->ts_sizeavail, gts->ts_cbr_map,
+				gts->ts_dsr_map);
 	if (err) {
 		gru_dbg(grudev,
 			"err %d: cch %p, gts %p, cbr 0x%lx, dsr 0x%lx\n",
@@ -573,11 +575,12 @@ static void gru_load_context(struct gru_
 /*
  * Update fields in an active CCH:
  * 	- retarget interrupts on local blade
+ * 	- update sizeavail mask
  * 	- force a delayed context unload by clearing the CCH asids. This
  * 	  forces TLB misses for new GRU instructions. The context is unloaded
  * 	  when the next TLB miss occurs.
  */
-static int gru_update_cch(struct gru_thread_state *gts, int int_select)
+int gru_update_cch(struct gru_thread_state *gts, int force_unload)
 {
 	struct gru_context_configuration_handle *cch;
 	struct gru_state *gru = gts->ts_gru;
@@ -591,9 +594,11 @@ static int gru_update_cch(struct gru_thr
 			goto exit;
 		if (cch_interrupt(cch))
 			BUG();
-		if (int_select >= 0) {
-			gts->ts_tlb_int_select = int_select;
-			cch->tlb_int_select = int_select;
+		if (!force_unload) {
+			for (i = 0; i < 8; i++)
+				cch->sizeavail[i] = gts->ts_sizeavail;
+			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
+			cch->tlb_int_select = gru_cpu_fault_map_id();
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
@@ -625,7 +630,7 @@ static int gru_retarget_intr(struct gru_
 
 	gru_dbg(grudev, "retarget from %d to %d\n", gts->ts_tlb_int_select,
 		gru_cpu_fault_map_id());
-	return gru_update_cch(gts, gru_cpu_fault_map_id());
+	return gru_update_cch(gts, 0);
 }
 
 
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-support-multiple-pagesizes-in-gru drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-support-multiple-pagesizes-in-gru
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -361,6 +361,7 @@ struct gru_thread_state {
 	long			ts_user_options;/* misc user option flags */
 	pid_t			ts_tgid_owner;	/* task that is using the
 						   context - for migration */
+	unsigned short		ts_sizeavail;	/* Pagesizes in use */
 	int			ts_tsid;	/* thread that owns the
 						   structure */
 	int			ts_tlb_int_select;/* target cpu if interrupts
@@ -374,6 +375,7 @@ struct gru_thread_state {
 						   required for contest */
 	char			ts_blade;	/* If >= 0, migrate context if
 						   ref from diferent blade */
+	char			ts_force_cch_reload;
 	char			ts_force_unload;/* force context to be unloaded
 						   after migration */
 	char			ts_cbr_idx[GRU_CBR_AU];/* CBR numbers of each
@@ -597,6 +599,7 @@ extern struct gru_thread_state *gru_find
 extern struct gru_thread_state *gru_alloc_thread_state(struct vm_area_struct
 				*vma, int tsid);
 extern void gru_unload_context(struct gru_thread_state *gts, int savestate);
+extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(struct gru_state *gru);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

