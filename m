From: akpm@linux-foundation.org
Subject: - gru-driver-minor-updates.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:27 -0700
Message-ID: <200810182320.m9INKRmk029769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbYJRXUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU driver: minor updates
has been removed from the -mm tree.  Its filename was
     gru-driver-minor-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU driver: minor updates
From: Jack Steiner <steiner@sgi.com>

A few minor updates for the GRU driver.
	- documentation changes found in code reviews
	- changes to #ifdefs to make them recognized by "unifdef"
	  (used in simulator testing)
	- change GRU context load/unload to prefetch data

[akpm@linux-foundation.org: fix typo in comment]
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru.h              |    4 +--
 drivers/misc/sgi-gru/gru_instructions.h |   10 ++++---
 drivers/misc/sgi-gru/grufault.c         |   11 +++-----
 drivers/misc/sgi-gru/grufile.c          |    8 +++++-
 drivers/misc/sgi-gru/gruhandles.h       |    5 ---
 drivers/misc/sgi-gru/grukservices.c     |    1 
 drivers/misc/sgi-gru/grumain.c          |   29 +++++++++++++---------
 7 files changed, 39 insertions(+), 29 deletions(-)

diff -puN drivers/misc/sgi-gru/gru.h~gru-driver-minor-updates drivers/misc/sgi-gru/gru.h
--- a/drivers/misc/sgi-gru/gru.h~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/gru.h
@@ -30,9 +30,9 @@
 /*
  * Size used to map GRU GSeg
  */
-#if defined CONFIG_IA64
+#if defined(CONFIG_IA64)
 #define GRU_GSEG_PAGESIZE	(256 * 1024UL)
-#elif defined CONFIG_X86_64
+#elif defined(CONFIG_X86_64)
 #define GRU_GSEG_PAGESIZE	(256 * 1024UL)		/* ZZZ 2MB ??? */
 #else
 #error "Unsupported architecture"
diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-driver-minor-updates drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -26,7 +26,7 @@
  * Architecture dependent functions
  */
 
-#if defined CONFIG_IA64
+#if defined(CONFIG_IA64)
 #include <linux/compiler.h>
 #include <asm/intrinsics.h>
 #define __flush_cache(p)		ia64_fc(p)
@@ -36,7 +36,7 @@
 			barrier();					\
 			*((volatile int *)(p)) = v; /* force st.rel */	\
 		} while (0)
-#elif defined CONFIG_X86_64
+#elif defined(CONFIG_X86_64)
 #define __flush_cache(p)		clflush(p)
 #define gru_ordered_store_int(p,v)					\
 		do {							\
@@ -299,6 +299,7 @@ static inline void gru_flush_cache(void 
 static inline void gru_start_instruction(struct gru_instruction *ins, int op32)
 {
 	gru_ordered_store_int(ins, op32);
+	gru_flush_cache(ins);
 }
 
 
@@ -604,8 +605,9 @@ static inline int gru_get_cb_substatus(v
 static inline int gru_check_status(void *cb)
 {
 	struct gru_control_block_status *cbs = (void *)cb;
-	int ret = cbs->istatus;
+	int ret;
 
+	ret = cbs->istatus;
 	if (ret == CBS_CALL_OS)
 		ret = gru_check_status_proc(cb);
 	return ret;
@@ -617,7 +619,7 @@ static inline int gru_check_status(void 
 static inline int gru_wait(void *cb)
 {
 	struct gru_control_block_status *cbs = (void *)cb;
-	int ret = cbs->istatus;;
+	int ret = cbs->istatus;
 
 	if (ret != CBS_IDLE)
 		ret = gru_wait_proc(cb);
diff -puN drivers/misc/sgi-gru/grufault.c~gru-driver-minor-updates drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -214,12 +214,14 @@ static int non_atomic_pte_lookup(struct 
 }
 
 /*
- *
  * atomic_pte_lookup
  *
  * Convert a user virtual address to a physical address
  * Only supports Intel large pages (2MB only) on x86_64.
  *	ZZZ - hugepage support is incomplete
+ *
+ * NOTE: mmap_sem is already held on entry to this function. This
+ * guarantees existence of the page tables.
  */
 static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
 	int write, unsigned long *paddr, int *pageshift)
@@ -229,9 +231,6 @@ static int atomic_pte_lookup(struct vm_a
 	pud_t *pudp;
 	pte_t pte;
 
-	WARN_ON(irqs_disabled());		/* ZZZ debug */
-
-	local_irq_disable();
 	pgdp = pgd_offset(vma->vm_mm, vaddr);
 	if (unlikely(pgd_none(*pgdp)))
 		goto err;
@@ -250,8 +249,6 @@ static int atomic_pte_lookup(struct vm_a
 #endif
 		pte = *pte_offset_kernel(pmdp, vaddr);
 
-	local_irq_enable();
-
 	if (unlikely(!pte_present(pte) ||
 		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
 		return 1;
@@ -324,6 +321,7 @@ static int gru_try_dropin(struct gru_thr
 	 * Atomic lookup is faster & usually works even if called in non-atomic
 	 * context.
 	 */
+	rmb();	/* Must/check ms_range_active before loading PTEs */
 	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &pageshift);
 	if (ret) {
 		if (!cb)
@@ -543,6 +541,7 @@ int gru_get_exception_detail(unsigned lo
 		ucbnum = get_cb_number((void *)excdet.cb);
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
+		prefetchw(cbe);		/* Harmless on hardware, required for emulator */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
diff -puN drivers/misc/sgi-gru/grufile.c~gru-driver-minor-updates drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -113,7 +113,7 @@ static int gru_file_mmap(struct file *fi
 		return -EPERM;
 
 	if (vma->vm_start & (GRU_GSEG_PAGESIZE - 1) ||
-			vma->vm_end & (GRU_GSEG_PAGESIZE - 1))
+	    			vma->vm_end & (GRU_GSEG_PAGESIZE - 1))
 		return -EINVAL;
 
 	vma->vm_flags |=
@@ -398,6 +398,12 @@ static int __init gru_init(void)
 	irq = get_base_irq();
 	for (chip = 0; chip < GRU_CHIPLETS_PER_BLADE; chip++) {
 		ret = request_irq(irq + chip, gru_intr, 0, id, NULL);
+		/* TODO: fix irq handling on x86. For now ignore failures because
+		 * interrupts are not required & not yet fully supported */
+		if (ret) {
+			printk("!!!WARNING: GRU ignoring request failure!!!\n");
+			ret = 0;
+		}
 		if (ret) {
 			printk(KERN_ERR "%s: request_irq failed\n",
 			       GRU_DRIVER_ID_STR);
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-driver-minor-updates drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -91,12 +91,7 @@
 #define GSEGPOFF(h) 		((h) & (GRU_SIZE - 1))
 
 /* Convert an arbitrary handle address to the beginning of the GRU segment */
-#ifndef __PLUGIN__
 #define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
-#else
-extern void *gmu_grubase(void *h);
-#define GRUBASE(h)		gmu_grubase(h)
-#endif
 
 /* General addressing macros. */
 static inline void *get_gseg_base_address(void *base, int ctxnum)
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-driver-minor-updates drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -122,6 +122,7 @@ int gru_get_cb_exception_detail(void *cb
 	struct gru_control_block_extended *cbe;
 
 	cbe = get_cbe(GRUBASE(cb), get_cb_number(cb));
+	prefetchw(cbe);         /* Harmless on hardware, required for emulator */
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
diff -puN drivers/misc/sgi-gru/grumain.c~gru-driver-minor-updates drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-driver-minor-updates
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -432,29 +432,35 @@ static inline long gru_copy_handle(void 
 	return GRU_HANDLE_BYTES;
 }
 
-/* rewrite in assembly & use lots of prefetch */
-static void gru_load_context_data(void *save, void *grubase, int ctxnum,
-				  unsigned long cbrmap, unsigned long dsrmap)
+static void gru_prefetch_context(void *gseg, void *cb, void *cbe, unsigned long cbrmap,
+				unsigned long length)
 {
-	void *gseg, *cb, *cbe;
-	unsigned long length;
 	int i, scr;
 
-	gseg = grubase + ctxnum * GRU_GSEG_STRIDE;
-	length = hweight64(dsrmap) * GRU_DSR_AU_BYTES;
 	prefetch_data(gseg + GRU_DS_BASE, length / GRU_CACHE_LINE_BYTES,
 		      GRU_CACHE_LINE_BYTES);
 
-	cb = gseg + GRU_CB_BASE;
-	cbe = grubase + GRU_CBE_BASE;
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {
 		prefetch_data(cb, 1, GRU_CACHE_LINE_BYTES);
 		prefetch_data(cbe + i * GRU_HANDLE_STRIDE, 1,
 			      GRU_CACHE_LINE_BYTES);
 		cb += GRU_HANDLE_STRIDE;
 	}
+}
+
+static void gru_load_context_data(void *save, void *grubase, int ctxnum,
+				  unsigned long cbrmap, unsigned long dsrmap)
+{
+	void *gseg, *cb, *cbe;
+	unsigned long length;
+	int i, scr;
 
+	gseg = grubase + ctxnum * GRU_GSEG_STRIDE;
 	cb = gseg + GRU_CB_BASE;
+	cbe = grubase + GRU_CBE_BASE;
+	length = hweight64(dsrmap) * GRU_DSR_AU_BYTES;
+	gru_prefetch_context(gseg, cb, cbe, cbrmap, length);
+
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {
 		save += gru_copy_handle(cb, save);
 		save += gru_copy_handle(cbe + i * GRU_HANDLE_STRIDE, save);
@@ -472,15 +478,16 @@ static void gru_unload_context_data(void
 	int i, scr;
 
 	gseg = grubase + ctxnum * GRU_GSEG_STRIDE;
