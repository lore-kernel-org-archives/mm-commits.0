From: akpm@linux-foundation.org
Subject: + gru-preload-tlb-for-bcopy-instructions.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:42 -0800
Message-ID: <200911241958.nAOJwg8W019377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932757AbZKXT6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: preload tlb for bcopy instructions
has been added to the -mm tree.  Its filename is
     gru-preload-tlb-for-bcopy-instructions.patch

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
Subject: gru: preload tlb for bcopy instructions
From: Jack Steiner <steiner@sgi.com>

Add anticipatory TLB dropins for GRU TLB misses that occur on BCOPY
instructions that copy large amounts of data.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |   89 ++++++++++++++++++++++++--
 drivers/misc/sgi-gru/grufile.c      |    1 
 drivers/misc/sgi-gru/gruhandles.c   |   11 ++-
 drivers/misc/sgi-gru/gruhandles.h   |   20 +++++
 drivers/misc/sgi-gru/grukservices.c |    2 
 drivers/misc/sgi-gru/grulib.h       |    1 
 drivers/misc/sgi-gru/grumain.c      |    8 +-
 drivers/misc/sgi-gru/gruprocfs.c    |    4 -
 drivers/misc/sgi-gru/grutables.h    |    9 ++
 9 files changed, 129 insertions(+), 16 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -290,6 +290,61 @@ upm:
 
 
 /*
+ * Flush a CBE from cache. The CBE is clean in the cache. Dirty the
+ * CBE cacheline so that the line will be written back to home agent.
+ * Otherwise the line may be silently dropped. This has no impact
+ * except on performance.
+ */
+static void gru_flush_cache_cbe(struct gru_control_block_extended *cbe)
+{
+	if (unlikely(cbe)) {
+		cbe->cbrexecstatus = 0;         /* make CL dirty */
+		gru_flush_cache(cbe);
+	}
+}
+
+/*
+ * Preload the TLB with entries that may be required. Currently, preloading
+ * is implemented only for BCOPY. Preload  <tlb_preload_count> pages OR to
+ * the end of the bcopy tranfer, whichever is smaller.
+ */
+static void gru_preload_tlb(struct gru_state *gru,
+			struct gru_thread_state *gts, int atomic,
+			unsigned long fault_vaddr, int asid, int write,
+			unsigned char tlb_preload_count,
+			struct gru_tlb_fault_handle *tfh,
+			struct gru_control_block_extended *cbe)
+{
+	unsigned long vaddr = 0, gpa;
+	int ret, pageshift;
+
+	if (cbe->opccpy != OP_BCOPY)
+		return;
+
+	if (fault_vaddr == cbe->cbe_baddr0)
+		vaddr = fault_vaddr + GRU_CACHE_LINE_BYTES * cbe->cbe_src_cl - 1;
+	else if (fault_vaddr == cbe->cbe_baddr1)
+		vaddr = fault_vaddr + (1 << cbe->xtypecpy) * cbe->cbe_nelemcur - 1;
+
+	fault_vaddr &= PAGE_MASK;
+	vaddr &= PAGE_MASK;
+	vaddr = min(vaddr, fault_vaddr + tlb_preload_count * PAGE_SIZE);
+
+	while (vaddr > fault_vaddr) {
+		ret = gru_vtop(gts, vaddr, write, atomic, &gpa, &pageshift);
+		if (ret || tfh_write_only(tfh, gpa, GAA_RAM, vaddr, asid, write,
+					  GRU_PAGESIZE(pageshift)))
+			return;
+		gru_dbg(grudev,
+			"%s: gid %d, gts 0x%p, tfh 0x%p, vaddr 0x%lx, asid 0x%x, rw %d, ps %d, gpa 0x%lx\n",
+			atomic ? "atomic" : "non-atomic", gru->gs_gid, gts, tfh,
+			vaddr, asid, write, pageshift, gpa);
+		vaddr -= PAGE_SIZE;
+		STAT(tlb_preload_page);
+	}
+}
+
+/*
  * Drop a TLB entry into the GRU. The fault is described by info in an TFH.
  *	Input:
  *		cb    Address of user CBR. Null if not running in user context
@@ -303,6 +358,8 @@ static int gru_try_dropin(struct gru_thr
 			  struct gru_tlb_fault_handle *tfh,
 			  struct gru_instruction_bits *cbk)
 {
+	struct gru_control_block_extended *cbe = NULL;
+	unsigned char tlb_preload_count = gts->ts_tlb_preload_count;
 	int pageshift = 0, asid, write, ret, atomic = !cbk, indexway;
 	unsigned long gpa = 0, vaddr = 0;
 
@@ -314,6 +371,14 @@ static int gru_try_dropin(struct gru_thr
 	 */
 
 	/*
+	 * Prefetch the CBE if doing TLB preloading
+	 */
+	if (unlikely(tlb_preload_count)) {
+		cbe = gru_tfh_to_cbe(tfh);
+		prefetchw(cbe);
+	}
+
+	/*
 	 * Error if TFH state is IDLE or FMM mode & the user issuing a UPM call.
 	 * Might be a hardware race OR a stupid user. Ignore FMM because FMM
 	 * is a transient state.
@@ -359,6 +424,12 @@ static int gru_try_dropin(struct gru_thr
 			goto failupm;
 		}
 	}
+
+	if (unlikely(cbe) && pageshift == PAGE_SHIFT) {
+		gru_preload_tlb(gts->ts_gru, gts, atomic, vaddr, asid, write, tlb_preload_count, tfh, cbe);
+		gru_flush_cache_cbe(cbe);
+	}
+
 	gru_cb_set_istatus_active(cbk);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
@@ -378,11 +449,13 @@ failnoasid:
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
 	return -EAGAIN;
 
 failupm:
 	/* Atomic failure switch CBR to UPM */
 	tfh_user_polling_mode(tfh);
+	gru_flush_cache_cbe(cbe);
 	STAT(tlb_dropin_fail_upm);
 	gru_dbg(grudev, "FAILED upm tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
 	return 1;
@@ -390,6 +463,7 @@ failupm:
 failfmm:
 	/* FMM state on UPM call */
 	gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
 	STAT(tlb_dropin_fail_fmm);
 	gru_dbg(grudev, "FAILED fmm tfh: 0x%p, state %d\n", tfh, tfh->state);
 	return 0;
@@ -397,6 +471,7 @@ failfmm:
 failnoexception:
 	/* TFH status did not show exception pending */
 	gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
 	if (cbk)
 		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_no_exception);
@@ -407,6 +482,7 @@ failnoexception:
 failidle:
 	/* TFH state was idle  - no miss pending */
 	gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
 	if (cbk)
 		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_idle);
@@ -416,6 +492,7 @@ failidle:
 failinval:
 	/* All errors (atomic & non-atomic) switch CBR to EXCEPTION state */
 	tfh_exception(tfh);
+	gru_flush_cache_cbe(cbe);
 	STAT(tlb_dropin_fail_invalid);
 	gru_dbg(grudev, "FAILED inval tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
 	return -EFAULT;
@@ -426,6 +503,7 @@ failactive:
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
+	gru_flush_cache_cbe(cbe);
 	STAT(tlb_dropin_fail_range_active);
 	gru_dbg(grudev, "FAILED range active: tfh 0x%p, vaddr 0x%lx\n",
 		tfh, vaddr);
@@ -627,7 +705,7 @@ int gru_get_exception_detail(unsigned lo
 		excdet.exceptdet1 = cbe->idef3upd;
 		excdet.cbrstate = cbe->cbrstate;
 		excdet.cbrexecstatus = cbe->cbrexecstatus;
-		gru_flush_cache(cbe);
+		gru_flush_cache_cbe(cbe);
 		ret = 0;
 	} else {
 		ret = -EAGAIN;
@@ -770,9 +848,12 @@ int gru_set_context_option(unsigned long
 		return -EFAULT;
 	gru_dbg(grudev, "op %d, gseg 0x%lx, value1 0x%lx\n", req.op, req.gseg, req.val1);
 
-	gts = gru_alloc_locked_gts(req.gseg);
-	if (IS_ERR(gts))
-		return PTR_ERR(gts);
+	gts = gru_find_lock_gts(req.gseg);
+	if (!gts) {
+		gts = gru_alloc_locked_gts(req.gseg);
+		if (IS_ERR(gts))
+			return PTR_ERR(gts);
+	}
 
 	switch (req.op) {
 	case sco_blade_chiplet:
diff -puN drivers/misc/sgi-gru/grufile.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -152,6 +152,7 @@ static int gru_create_new_context(unsign
 		vdata->vd_dsr_au_count =
 		    GRU_DS_BYTES_TO_AU(req.data_segment_bytes);
 		vdata->vd_cbr_au_count = GRU_CB_COUNT_TO_AU(req.control_blocks);
+		vdata->vd_tlb_preload_count = req.tlb_preload_count;
 		ret = 0;
 	}
 	up_write(&current->mm->mmap_sem);
diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -165,17 +165,20 @@ int tgh_invalidate(struct gru_tlb_global
 	return wait_instruction_complete(tgh, tghop_invalidate);
 }
 
-void tfh_write_only(struct gru_tlb_fault_handle *tfh,
-				  unsigned long pfn, unsigned long vaddr,
-				  int asid, int dirty, int pagesize)
+int tfh_write_only(struct gru_tlb_fault_handle *tfh,
+				  unsigned long paddr, int gaa,
+				  unsigned long vaddr, int asid, int dirty,
+				  int pagesize)
 {
 	tfh->fillasid = asid;
 	tfh->fillvaddr = vaddr;
-	tfh->pfn = pfn;
+	tfh->pfn = paddr >> GRU_PADDR_SHIFT;
+	tfh->gaa = gaa;
 	tfh->dirty = dirty;
 	tfh->pagesize = pagesize;
 	tfh->opc = TFHOP_WRITE_ONLY;
 	start_instruction(tfh);
+	return wait_instruction_complete(tfh, tfhop_write_only);
 }
 
 void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -164,6 +164,16 @@ static inline void *gru_chiplet_vaddr(vo
 	return vaddr + GRU_SIZE * (2 * pnode  + chiplet);
 }
 
+static inline struct gru_control_block_extended *gru_tfh_to_cbe(
+					struct gru_tlb_fault_handle *tfh)
+{
+	unsigned long cbe;
+
+	cbe = (unsigned long)tfh - GRU_TFH_BASE + GRU_CBE_BASE;
+	return (struct gru_control_block_extended*)cbe;
+}
+
+
 
 
 /*
@@ -446,6 +456,12 @@ struct gru_control_block_extended {
 	unsigned int cbrexecstatus:8;
 };
 
+/* CBE fields for active BCOPY instructions */
+#define cbe_baddr0	idef1upd
+#define cbe_baddr1	idef3upd
+#define cbe_src_cl	idef6cpy
+#define cbe_nelemcur	idef5upd
+
 enum gru_cbr_state {
 	CBRSTATE_INACTIVE,
 	CBRSTATE_IDLE,
@@ -493,8 +509,8 @@ int cch_interrupt_sync(struct gru_contex
 int tgh_invalidate(struct gru_tlb_global_handle *tgh, unsigned long vaddr,
 	unsigned long vaddrmask, int asid, int pagesize, int global, int n,
 	unsigned short ctxbitmap);
-void tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long pfn,
-	unsigned long vaddr, int asid, int dirty, int pagesize);
+int tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
+	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
 void tfh_write_restart(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
 	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
 void tfh_restart(struct gru_tlb_fault_handle *tfh);
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -161,7 +161,7 @@ static void gru_load_kernel_context(stru
 	down_write(&bs->bs_kgts_sema);
 
 	if (!bs->bs_kgts) {
-		bs->bs_kgts = gru_alloc_gts(NULL, 0, 0, 0, 0);
+		bs->bs_kgts = gru_alloc_gts(NULL, 0, 0, 0, 0, 0);
 		bs->bs_kgts->ts_user_blade_id = blade_id;
 	}
 	kgts = bs->bs_kgts;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -86,6 +86,7 @@ struct gru_create_context_req {
 	unsigned int		control_blocks;
 	unsigned int		maximum_thread_count;
 	unsigned int		options;
+	unsigned char		tlb_preload_count;
 };
 
 /*
diff -puN drivers/misc/sgi-gru/grumain.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -316,7 +316,8 @@ static struct gru_thread_state *gru_find
  * Allocate a thread state structure.
  */
 struct gru_thread_state *gru_alloc_gts(struct vm_area_struct *vma,
-		int cbr_au_count, int dsr_au_count, int options, int tsid)
+		int cbr_au_count, int dsr_au_count,
+		unsigned char tlb_preload_count, int options, int tsid)
 {
 	struct gru_thread_state *gts;
 	struct gru_mm_struct *gms;
@@ -334,6 +335,7 @@ struct gru_thread_state *gru_alloc_gts(s
 	mutex_init(&gts->ts_ctxlock);
 	gts->ts_cbr_au_count = cbr_au_count;
 	gts->ts_dsr_au_count = dsr_au_count;
+	gts->ts_tlb_preload_count = tlb_preload_count;
 	gts->ts_user_options = options;
 	gts->ts_user_blade_id = -1;
 	gts->ts_user_chiplet_id = -1;
@@ -403,7 +405,9 @@ struct gru_thread_state *gru_alloc_threa
 	struct gru_vma_data *vdata = vma->vm_private_data;
 	struct gru_thread_state *gts, *ngts;
 
-	gts = gru_alloc_gts(vma, vdata->vd_cbr_au_count, vdata->vd_dsr_au_count,
+	gts = gru_alloc_gts(vma, vdata->vd_cbr_au_count,
+			    vdata->vd_dsr_au_count,
+			    vdata->vd_tlb_preload_count,
 			    vdata->vd_user_options, tsid);
 	if (IS_ERR(gts))
 		return gts;
diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -76,6 +76,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, check_context_retarget_intr);
 	printstat(s, check_context_unload);
 	printstat(s, tlb_dropin);
+	printstat(s, tlb_preload_page);
 	printstat(s, tlb_dropin_fail_no_asid);
 	printstat(s, tlb_dropin_fail_upm);
 	printstat(s, tlb_dropin_fail_invalid);
@@ -127,7 +128,8 @@ static int mcs_statistics_show(struct se
 	int op;
 	unsigned long total, count, max;
 	static char *id[] = {"cch_allocate", "cch_start", "cch_interrupt",
-		"cch_interrupt_sync", "cch_deallocate", "tgh_invalidate"};
+		"cch_interrupt_sync", "cch_deallocate", "tfh_write_only",
+		"tfh_write_restart", "tgh_invalidate"};
 
 	seq_printf(s, "%-20s%12s%12s%12s\n", "#id", "count", "aver-clks", "max-clks");
 	for (op = 0; op < mcsop_last; op++) {
diff -puN drivers/misc/sgi-gru/grutables.h~gru-preload-tlb-for-bcopy-instructions drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-preload-tlb-for-bcopy-instructions
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -202,6 +202,7 @@ struct gru_stats_s {
 	atomic_long_t check_context_retarget_intr;
 	atomic_long_t check_context_unload;
 	atomic_long_t tlb_dropin;
+	atomic_long_t tlb_preload_page;
 	atomic_long_t tlb_dropin_fail_no_asid;
 	atomic_long_t tlb_dropin_fail_upm;
 	atomic_long_t tlb_dropin_fail_invalid;
@@ -245,7 +246,8 @@ struct gru_stats_s {
 };
 
 enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
-	cchop_deallocate, tghop_invalidate, mcsop_last};
+	cchop_deallocate, tfhop_write_only, tfhop_write_restart,
+	tghop_invalidate, mcsop_last};
 
 struct mcs_op_statistic {
 	atomic_long_t	count;
@@ -335,6 +337,7 @@ struct gru_vma_data {
 	long			vd_user_options;/* misc user option flags */
 	int			vd_cbr_au_count;
 	int			vd_dsr_au_count;
+	unsigned char		vd_tlb_preload_count;
 };
 
 /*
@@ -350,6 +353,7 @@ struct gru_thread_state {
 	struct gru_state	*ts_gru;	/* GRU where the context is
 						   loaded */
 	struct gru_mm_struct	*ts_gms;	/* asid & ioproc struct */
+	unsigned char		ts_tlb_preload_count; /* TLB preload pages */
 	unsigned long		ts_cbr_map;	/* map of allocated CBRs */
 	unsigned long		ts_dsr_map;	/* map of allocated DATA
 						   resources */
@@ -661,7 +665,8 @@ extern int gru_proc_init(void);
 extern void gru_proc_exit(void);
 
 extern struct gru_thread_state *gru_alloc_gts(struct vm_area_struct *vma,
-		int cbr_au_count, int dsr_au_count, int options, int tsid);
+		int cbr_au_count, int dsr_au_count,
+		unsigned char tlb_preload_count, int options, int tsid);
 extern unsigned long gru_reserve_cb_resources(struct gru_state *gru,
 		int cbr_au_count, char *cbmap);
 extern unsigned long gru_reserve_ds_resources(struct gru_state *gru,
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
gru-initial-gru-based-on-blade-topology.patch
gru-add-comments-raised-in-previous-code-reviews.patch
gru-fix-istatus-race-in-gru-tlb-dropin.patch
gru-handle-blades-without-memory.patch
gru-allow-users-to-specify-gru-chiplet-1.patch
gru-allow-users-to-specify-gru-chiplet-2.patch
gru-allow-users-to-specify-gru-chiplet-3.patch
gru-fix-bug-in-module-unload.patch
gru-improve-messages-for-malfunctioning-grus.patch
gru-support-64-bit-gru-addresses.patch
gru-handle-failures-to-mmu_notifier_register.patch
gru-add-debug-option-for-cache-flushing.patch
gru-add-test-for-gru_copy_gpa.patch
gru-check-for-valid-vma.patch
gru-fix-prefetch-and-speculation-bugs.patch
gru-update-irq-infrastructure.patch
gru-add-additional-gru-statistics.patch
gru-expicitly-set-instruction-status-to-active.patch
gru-preload-tlb-for-bcopy-instructions.patch
gru-fix-bug-in-exception-handling.patch
gru-add-symbolic-names-for-gru-error-code.patch
gru-remove-stray-local_irq_enable.patch
gru-check-for-correct-gru-chiplet-assignment.patch
gru-update-gru-structures-to-match-latest-hardware-spec.patch
gru-fix-bug-in-allocation-of-kernel-contexts.patch
gru-add-hugepage-support.patch
gru-fix-gru-interrupt-race-at-deallocate.patch
gru-improve-gru-tlb-dropin-statistics.patch
gru-update-driver-version-number.patch

