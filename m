From: akpm@linux-foundation.org
Subject: [merged] gru-change-resource-assignment-for-kernel-threads.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:38 -0700
Message-ID: <200906182248.n5IMmcLW007708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758122AbZFRWtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: change resource assignment for kernel threads
has been removed from the -mm tree.  Its filename was
     gru-change-resource-assignment-for-kernel-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: change resource assignment for kernel threads
From: Jack Steiner <steiner@sgi.com>

Change the way GRU resources are assigned for kernel threads.  GRU
contexts for kernel threads are now allocated on demand and can be stolen
by user processes when idle.  This allows MPI jobs to use ALL of the GRU
resources when the kernel is not using them.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.c   |    5 
 drivers/misc/sgi-gru/grukdump.c     |    2 
 drivers/misc/sgi-gru/grukservices.c |  201 +++++++++++++++-----------
 drivers/misc/sgi-gru/grumain.c      |   55 +++++--
 drivers/misc/sgi-gru/gruprocfs.c    |    9 -
 drivers/misc/sgi-gru/grutables.h    |   17 +-
 6 files changed, 184 insertions(+), 105 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -57,7 +57,7 @@ static void start_instruction(void *h)
 static int wait_instruction_complete(void *h, enum mcs_op opc)
 {
 	int status;
-	cycles_t start_time = get_cycles();
+	unsigned long start_time = get_cycles();
 
 	while (1) {
 		cpu_relax();
@@ -65,7 +65,8 @@ static int wait_instruction_complete(voi
 		if (status != CCHSTATUS_ACTIVE)
 			break;
 		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
-			panic("GRU %p is malfunctioning\n", h);
+			panic("GRU %p is malfunctioning: start %ld, end %ld\n",
+			      h, start_time, (unsigned long)get_cycles());
 	}
 	if (gru_options & OPT_STATS)
 		update_mcs_stats(opc, get_cycles() - start_time);
diff -puN drivers/misc/sgi-gru/grukdump.c~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -131,7 +131,7 @@ static int gru_dump_context(struct gru_s
 
 	if (cch_locked || !lock_cch) {
 		gts = gru->gs_gts[ctxnum];
-		if (gts) {
+		if (gts && gts->ts_vma) {
 			hdr.pid = gts->ts_tgid_owner;
 			hdr.vaddr = gts->ts_vma->vm_start;
 		}
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -31,6 +31,7 @@
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
+#include <linux/delay.h>
 #include "gru.h"
 #include "grulib.h"
 #include "grutables.h"
@@ -45,18 +46,17 @@
  * resources. This will likely be replaced when we better understand the
  * kernel/user requirements.
  *
- * At boot time, the kernel permanently reserves a fixed number of
- * CBRs/DSRs for each cpu to use. The resources are all taken from
- * the GRU chiplet 1 on the blade. This leaves the full set of resources
- * of chiplet 0 available to be allocated to a single user.
+ * Blade percpu resources reserved for kernel use. These resources are
+ * reserved whenever the the kernel context for the blade is loaded. Note
+ * that the kernel context is not guaranteed to be always available. It is
+ * loaded on demand & can be stolen by a user if the user demand exceeds the
+ * kernel demand. The kernel can always reload the kernel context but
+ * a SLEEP may be required!!!.
  */
-
-/* Blade percpu resources PERMANENTLY reserved for kernel use */
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
 #define GRU_NUM_KERNEL_DSR_CL	(GRU_NUM_KERNEL_DSR_BYTES /		\
 					GRU_CACHE_LINE_BYTES)
-#define KERNEL_CTXNUM           15
 
 /* GRU instruction attributes for all instructions */
 #define IMA			IMA_CB_DELAY
@@ -98,6 +98,88 @@ struct message_header {
 
 #define HSTATUS(mq, h)	((mq) + offsetof(struct message_queue, hstatus[h]))
 
+/*
+ * Allocate a kernel context (GTS) for the specified blade.
+ * 	- protected by writelock on bs_kgts_sema.
+ */
+static void gru_alloc_kernel_context(struct gru_blade_state *bs, int blade_id)
+{
+	int cbr_au_count, dsr_au_count, ncpus;
+
+	ncpus = uv_blade_nr_possible_cpus(blade_id);
+	cbr_au_count = GRU_CB_COUNT_TO_AU(GRU_NUM_KERNEL_CBR * ncpus);
+	dsr_au_count = GRU_DS_BYTES_TO_AU(GRU_NUM_KERNEL_DSR_BYTES * ncpus);
+	bs->bs_kgts = gru_alloc_gts(NULL, cbr_au_count, dsr_au_count, 0, 0);
+}
+
+/*
+ * Reload the blade's kernel context into a GRU chiplet. Called holding
+ * the bs_kgts_sema for READ. Will steal user contexts if necessary.
+ */
+static void gru_load_kernel_context(struct gru_blade_state *bs, int blade_id)
+{
+	struct gru_state *gru;
+	struct gru_thread_state *kgts;
+	void *vaddr;
+	int ctxnum;
+
+	up_read(&bs->bs_kgts_sema);
+	down_write(&bs->bs_kgts_sema);
+
+	if (!bs->bs_kgts)
+		gru_alloc_kernel_context(bs, blade_id);
+	kgts = bs->bs_kgts;
+
+	if (!kgts->ts_gru) {
+		STAT(load_kernel_context);
+		while (!gru_assign_gru_context(kgts, blade_id)) {
+			msleep(1);
+			gru_steal_context(kgts, blade_id);
+		}
+		gru_load_context(kgts);
+		gru = bs->bs_kgts->ts_gru;
+		vaddr = gru->gs_gru_base_vaddr;
+		ctxnum = kgts->ts_ctxnum;
+		bs->kernel_cb = get_gseg_base_address_cb(vaddr, ctxnum, 0);
+		bs->kernel_dsr = get_gseg_base_address_ds(vaddr, ctxnum, 0);
+	}
+	downgrade_write(&bs->bs_kgts_sema);
+}
+
+/*
+ * Lock & load the kernel context for the specified blade.
+ */
+static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
+{
+	struct gru_blade_state *bs;
+
+	STAT(lock_kernel_context);
+	bs = gru_base[blade_id];
+
+	down_read(&bs->bs_kgts_sema);
+	if (!bs->bs_kgts || !bs->bs_kgts->ts_gru)
+		gru_load_kernel_context(bs, blade_id);
+	return bs;
+
+}
+
+/*
+ * Unlock the kernel context for the specified blade. Context is not
+ * unloaded but may be stolen before next use.
+ */
+static void gru_unlock_kernel_context(int blade_id)
+{
+	struct gru_blade_state *bs;
+
+	bs = gru_base[blade_id];
+	up_read(&bs->bs_kgts_sema);
+	STAT(unlock_kernel_context);
+}
+
+/*
+ * Reserve & get pointers to the DSR/CBRs reserved for the current cpu.
+ * 	- returns with preemption disabled
+ */
 static int gru_get_cpu_resources(int dsr_bytes, void **cb, void **dsr)
 {
 	struct gru_blade_state *bs;
@@ -105,18 +187,23 @@ static int gru_get_cpu_resources(int dsr
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
 	preempt_disable();
-	bs = gru_base[uv_numa_blade_id()];
+	bs = gru_lock_kernel_context(uv_numa_blade_id());
 	lcpu = uv_blade_processor_id();
 	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
 	*dsr = bs->kernel_dsr + lcpu * GRU_NUM_KERNEL_DSR_BYTES;
 	return 0;
 }
 
+/*
+ * Free the current cpus reserved DSR/CBR resources.
+ */
 static void gru_free_cpu_resources(void *cb, void *dsr)
 {
+	gru_unlock_kernel_context(uv_numa_blade_id());
 	preempt_enable();
 }
 
+/*----------------------------------------------------------------------*/
 int gru_get_cb_exception_detail(void *cb,
 		struct control_block_extended_exc_detail *excdet)
 {
@@ -597,34 +684,36 @@ EXPORT_SYMBOL_GPL(gru_copy_gpa);
 
 /* ------------------- KERNEL QUICKTESTS RUN AT STARTUP ----------------*/
 /* 	Temp - will delete after we gain confidence in the GRU		*/
-static __cacheline_aligned unsigned long word0;
-static __cacheline_aligned unsigned long word1;
 
-static int quicktest(struct gru_state *gru)
+int quicktest(void)
 {
+	unsigned long word0;
+	unsigned long word1;
 	void *cb;
-	void *ds;
+	void *dsr;
 	unsigned long *p;
 
-	cb = get_gseg_base_address_cb(gru->gs_gru_base_vaddr, KERNEL_CTXNUM, 0);
-	ds = get_gseg_base_address_ds(gru->gs_gru_base_vaddr, KERNEL_CTXNUM, 0);
-	p = ds;
+	if (gru_get_cpu_resources(GRU_CACHE_LINE_BYTES, &cb, &dsr))
+		return MQE_BUG_NO_RESOURCES;
+	p = dsr;
 	word0 = MAGIC;
+	word1 = 0;
 
-	gru_vload(cb, uv_gpa(&word0), 0, XTYPE_DW, 1, 1, IMA);
+	gru_vload(cb, uv_gpa(&word0), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		BUG();
 
-	if (*(unsigned long *)ds != MAGIC)
+	if (*p != MAGIC)
 		BUG();
-	gru_vstore(cb, uv_gpa(&word1), 0, XTYPE_DW, 1, 1, IMA);
+	gru_vstore(cb, uv_gpa(&word1), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		BUG();
+	gru_free_cpu_resources(cb, dsr);
 
-	if (word0 != word1 || word0 != MAGIC) {
+	if (word0 != word1 || word1 != MAGIC) {
 		printk
-		    ("GRU quicktest err: gid %d, found 0x%lx, expected 0x%lx\n",
-		     gru->gs_gid, word1, MAGIC);
+		    ("GRU quicktest err: found 0x%lx, expected 0x%lx\n",
+		     word1, MAGIC);
 		BUG();		/* ZZZ should not be fatal */
 	}
 
@@ -635,80 +724,30 @@ static int quicktest(struct gru_state *g
 int gru_kservices_init(struct gru_state *gru)
 {
 	struct gru_blade_state *bs;
-	struct gru_context_configuration_handle *cch;
-	unsigned long cbr_map, dsr_map;
-	int err, num, cpus_possible;
-
-	/*
-	 * Currently, resources are reserved ONLY on the second chiplet
-	 * on each blade. This leaves ALL resources on chiplet 0 available
-	 * for user code.
-	 */
+
 	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[1])
+	if (gru != &bs->bs_grus[0])
 		return 0;
 
-	cpus_possible = uv_blade_nr_possible_cpus(gru->gs_blade_id);
-
-	num = GRU_NUM_KERNEL_CBR * cpus_possible;
-	cbr_map = gru_reserve_cb_resources(gru, GRU_CB_COUNT_TO_AU(num), NULL);
-	gru->gs_reserved_cbrs += num;
-
-	num = GRU_NUM_KERNEL_DSR_BYTES * cpus_possible;
-	dsr_map = gru_reserve_ds_resources(gru, GRU_DS_BYTES_TO_AU(num), NULL);
-	gru->gs_reserved_dsr_bytes += num;
-
-	gru->gs_active_contexts++;
-	__set_bit(KERNEL_CTXNUM, &gru->gs_context_map);
-	cch = get_cch(gru->gs_gru_base_vaddr, KERNEL_CTXNUM);
-
-	bs->kernel_cb = get_gseg_base_address_cb(gru->gs_gru_base_vaddr,
-					KERNEL_CTXNUM, 0);
-	bs->kernel_dsr = get_gseg_base_address_ds(gru->gs_gru_base_vaddr,
-					KERNEL_CTXNUM, 0);
-
-	lock_cch_handle(cch);
-	cch->tfm_fault_bit_enable = 0;
-	cch->tlb_int_enable = 0;
-	cch->tfm_done_bit_enable = 0;
-	cch->unmap_enable = 1;
-	cch->dsr_allocation_map = dsr_map;
-	cch->cbr_allocation_map = cbr_map;
-
-	err = cch_allocate(cch);
-	if (err) {
-		gru_dbg(grudev,
-			"Unable to allocate kernel CCH: gid %d, err %d\n",
-			gru->gs_gid, err);
-		BUG();
-	}
-	if (cch_start(cch)) {
-		gru_dbg(grudev, "Unable to start kernel CCH: gid %d, err %d\n",
-			gru->gs_gid, err);
-		BUG();
-	}
-	unlock_cch_handle(cch);
+	init_rwsem(&bs->bs_kgts_sema);
 
 	if (gru_options & GRU_QUICKLOOK)
-		quicktest(gru);
+		quicktest();
 	return 0;
 }
 
 void gru_kservices_exit(struct gru_state *gru)
 {
-	struct gru_context_configuration_handle *cch;
 	struct gru_blade_state *bs;
+	struct gru_thread_state *kgts;
 
 	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[1])
+	if (gru != &bs->bs_grus[0])
 		return;
 
-	cch = get_cch(gru->gs_gru_base_vaddr, KERNEL_CTXNUM);
-	lock_cch_handle(cch);
-	if (cch_interrupt_sync(cch))
-		BUG();
-	if (cch_deallocate(cch))
-		BUG();
-	unlock_cch_handle(cch);
+	kgts = bs->bs_kgts;
+	if (kgts && kgts->ts_gru)
+		gru_unload_context(kgts, 0);
+	kfree(kgts);
 }
 
diff -puN drivers/misc/sgi-gru/grumain.c~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -96,7 +96,7 @@ static int gru_reset_asid_limit(struct g
 	gid = gru->gs_gid;
 again:
 	for (i = 0; i < GRU_NUM_CCH; i++) {
-		if (!gru->gs_gts[i])
+		if (!gru->gs_gts[i] || is_kernel_context(gru->gs_gts[i]))
 			continue;
 		inuse_asid = gru->gs_gts[i]->ts_gms->ms_asids[gid].mt_asid;
 		gru_dbg(grudev, "gid %d, gts %p, gms %p, inuse 0x%x, cxt %d\n",
@@ -506,7 +506,8 @@ void gru_unload_context(struct gru_threa
 	struct gru_context_configuration_handle *cch;
 	int ctxnum = gts->ts_ctxnum;
 
-	zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
+	if (!is_kernel_context(gts))
+		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	gru_dbg(grudev, "gts %p\n", gts);
@@ -514,7 +515,8 @@ void gru_unload_context(struct gru_threa
 	if (cch_interrupt_sync(cch))
 		BUG();
 
-	gru_unload_mm_tracker(gru, gts);
+	if (!is_kernel_context(gts))
+		gru_unload_mm_tracker(gru, gts);
 	if (savestate)
 		gru_unload_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr,
 					ctxnum, gts->ts_cbr_map,
@@ -526,7 +528,6 @@ void gru_unload_context(struct gru_threa
 	unlock_cch_handle(cch);
 
 	gru_free_gru_context(gts);
-	STAT(unload_context);
 }
 
 /*
@@ -554,11 +555,16 @@ void gru_load_context(struct gru_thread_
 	cch->tfm_done_bit_enable = 0;
 	cch->dsr_allocation_map = gts->ts_dsr_map;
 	cch->cbr_allocation_map = gts->ts_cbr_map;
-	asid = gru_load_mm_tracker(gru, gts);
-	cch->unmap_enable = 0;
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = asid + i;
-		cch->sizeavail[i] = gts->ts_sizeavail;
+
+	if (is_kernel_context(gts)) {
+		cch->unmap_enable = 1;
+	} else {
+		cch->unmap_enable = 0;
+		asid = gru_load_mm_tracker(gru, gts);
+		for (i = 0; i < 8; i++) {
+			cch->asid[i] = asid + i;
+			cch->sizeavail[i] = gts->ts_sizeavail;
+		}
 	}
 
 	err = cch_allocate(cch);
@@ -575,8 +581,6 @@ void gru_load_context(struct gru_thread_
 	if (cch_start(cch))
 		BUG();
 	unlock_cch_handle(cch);
-
-	STAT(load_context);
 }
 
 /*
@@ -652,6 +656,27 @@ static int gru_retarget_intr(struct gru_
 #define next_gru(b, g)	(((g) < &(b)->bs_grus[GRU_CHIPLETS_PER_BLADE - 1]) ?  \
 				 ((g)+1) : &(b)->bs_grus[0])
 
+static int is_gts_stealable(struct gru_thread_state *gts,
+		struct gru_blade_state *bs)
+{
+	if (is_kernel_context(gts))
+		return down_write_trylock(&bs->bs_kgts_sema);
+	else
+		return mutex_trylock(&gts->ts_ctxlock);
+}
+
+static void gts_stolen(struct gru_thread_state *gts,
+		struct gru_blade_state *bs)
+{
+	if (is_kernel_context(gts)) {
+		up_write(&bs->bs_kgts_sema);
+		STAT(steal_kernel_context);
+	} else {
+		mutex_unlock(&gts->ts_ctxlock);
+		STAT(steal_user_context);
+	}
+}
+
 void gru_steal_context(struct gru_thread_state *gts, int blade_id)
 {
 	struct gru_blade_state *blade;
@@ -685,7 +710,7 @@ void gru_steal_context(struct gru_thread
 			 * success are high. If trylock fails, try to steal a
 			 * different GSEG.
 			 */
-			if (ngts && mutex_trylock(&ngts->ts_ctxlock))
+			if (ngts && is_gts_stealable(ngts, blade))
 				break;
 			ngts = NULL;
 			flag = 1;
@@ -701,10 +726,9 @@ void gru_steal_context(struct gru_thread
 	spin_unlock(&blade->bs_lock);
 
 	if (ngts) {
-		STAT(steal_context);
 		ngts->ts_steal_jiffies = jiffies;
-		gru_unload_context(ngts, 1);
-		mutex_unlock(&ngts->ts_ctxlock);
+		gru_unload_context(ngts, is_kernel_context(ngts) ? 0 : 1);
+		gts_stolen(ngts, blade);
 	} else {
 		STAT(steal_context_failed);
 	}
@@ -810,6 +834,7 @@ again:
 	}
 
 	if (!gts->ts_gru) {
+		STAT(load_user_context);
 		if (!gru_assign_gru_context(gts, blade_id)) {
 			preempt_enable();
 			mutex_unlock(&gts->ts_ctxlock);
diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -51,9 +51,12 @@ static int statistics_show(struct seq_fi
 	printstat(s, assign_context);
 	printstat(s, assign_context_failed);
 	printstat(s, free_context);
-	printstat(s, load_context);
-	printstat(s, unload_context);
-	printstat(s, steal_context);
+	printstat(s, load_user_context);
+	printstat(s, load_kernel_context);
+	printstat(s, lock_kernel_context);
+	printstat(s, unlock_kernel_context);
+	printstat(s, steal_user_context);
+	printstat(s, steal_kernel_context);
 	printstat(s, steal_context_failed);
 	printstat(s, nopfn);
 	printstat(s, break_cow);
diff -puN drivers/misc/sgi-gru/grutables.h~gru-change-resource-assignment-for-kernel-threads drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-change-resource-assignment-for-kernel-threads
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -174,9 +174,12 @@ struct gru_stats_s {
 	atomic_long_t assign_context;
 	atomic_long_t assign_context_failed;
 	atomic_long_t free_context;
-	atomic_long_t load_context;
-	atomic_long_t unload_context;
-	atomic_long_t steal_context;
+	atomic_long_t load_user_context;
+	atomic_long_t load_kernel_context;
+	atomic_long_t lock_kernel_context;
+	atomic_long_t unlock_kernel_context;
+	atomic_long_t steal_user_context;
+	atomic_long_t steal_kernel_context;
 	atomic_long_t steal_context_failed;
 	atomic_long_t nopfn;
 	atomic_long_t break_cow;
@@ -454,6 +457,9 @@ struct gru_blade_state {
 							   reserved cb */
 	void			*kernel_dsr;		/* First kernel
 							   reserved DSR */
+	struct rw_semaphore	bs_kgts_sema;		/* lock for kgts */
+	struct gru_thread_state *bs_kgts;		/* GTS for kernel use */
+
 	/* ---- the following are protected by the bs_lock spinlock ---- */
 	spinlock_t		bs_lock;		/* lock used for
 							   stealing contexts */
@@ -597,6 +603,11 @@ static inline void unlock_tgh_handle(str
 	__unlock_handle(tgh);
 }
 
+static inline int is_kernel_context(struct gru_thread_state *gts)
+{
+	return !gts->ts_mm;
+}
+
 /*-----------------------------------------------------------------------------
  * Function prototypes & externs
  */
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

