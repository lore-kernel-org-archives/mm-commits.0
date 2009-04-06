From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-misc-gru-cleanup.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:23 -0700
Message-ID: <200904061937.n36JbN88012887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZDFT6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: misc GRU cleanup
has been removed from the -mm tree.  Its filename was
     sgi-gru-misc-gru-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: misc GRU cleanup
From: Jack Steiner <steiner@sgi.com>

Misc trivial GRU drivers fixes:
	- fix long lines
	- eliminate extra whitespace
	- eliminate compiler warning
	- better validation of invalidate user parameters
	- bug fix for GRU TLB flush (not the cpu TLB flush)

These changes are all internal to the SGI GRU driver and have no effect
on the base kernel.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |   22 ++++++++++---------
 drivers/misc/sgi-gru/grufault.c         |   19 ++++++++++------
 drivers/misc/sgi-gru/grufile.c          |   25 +++++++++++++---------
 drivers/misc/sgi-gru/gruhandles.h       |    2 -
 drivers/misc/sgi-gru/grukservices.c     |    4 +--
 drivers/misc/sgi-gru/grumain.c          |    6 ++---
 drivers/misc/sgi-gru/grutables.h        |   15 +++++++------
 drivers/misc/sgi-gru/grutlbpurge.c      |    5 +---
 8 files changed, 55 insertions(+), 43 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -19,8 +19,11 @@
 #ifndef __GRU_INSTRUCTIONS_H__
 #define __GRU_INSTRUCTIONS_H__
 
-#define gru_flush_cache_hook(p)
-#define gru_emulator_wait_hook(p, w)
+extern int gru_check_status_proc(void *cb);
+extern int gru_wait_proc(void *cb);
+extern void gru_wait_abort_proc(void *cb);
+
+
 
 /*
  * Architecture dependent functions
@@ -29,16 +32,16 @@
 #if defined(CONFIG_IA64)
 #include <linux/compiler.h>
 #include <asm/intrinsics.h>
-#define __flush_cache(p)		ia64_fc(p)
+#define __flush_cache(p)		ia64_fc((unsigned long)p)
 /* Use volatile on IA64 to ensure ordering via st4.rel */
-#define gru_ordered_store_int(p,v)					\
+#define gru_ordered_store_int(p, v)					\
 		do {							\
 			barrier();					\
 			*((volatile int *)(p)) = v; /* force st.rel */	\
 		} while (0)
 #elif defined(CONFIG_X86_64)
 #define __flush_cache(p)		clflush(p)
-#define gru_ordered_store_int(p,v)					\
+#define gru_ordered_store_int(p, v)					\
 		do {							\
 			barrier();					\
 			*(int *)p = v;					\
@@ -558,20 +561,19 @@ extern int gru_get_cb_exception_detail(v
 
 #define GRU_EXC_STR_SIZE		256
 
-extern int gru_check_status_proc(void *cb);
-extern int gru_wait_proc(void *cb);
-extern void gru_wait_abort_proc(void *cb);
 
 /*
  * Control block definition for checking status
  */
 struct gru_control_block_status {
 	unsigned int	icmd		:1;
-	unsigned int	unused1		:31;
+	unsigned int	ima		:3;
+	unsigned int	reserved0	:4;
+	unsigned int	unused1		:24;
 	unsigned int	unused2		:24;
 	unsigned int	istatus		:2;
 	unsigned int	isubstatus	:4;
-	unsigned int	inused3		:2;
+	unsigned int	unused3		:2;
 };
 
 /* Get CB status */
diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -368,6 +368,7 @@ failupm:
 
 failfmm:
 	/* FMM state on UPM call */
+	gru_flush_cache(tfh);
 	STAT(tlb_dropin_fail_fmm);
 	gru_dbg(grudev, "FAILED fmm tfh: 0x%p, state %d\n", tfh, tfh->state);
 	return 0;
@@ -497,10 +498,8 @@ int gru_handle_user_call_os(unsigned lon
 	if (!gts)
 		return -EINVAL;
 
-	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE) {
-		ret = -EINVAL;
+	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE)
 		goto exit;
-	}
 
 	/*
 	 * If force_unload is set, the UPM TLB fault is phony. The task
@@ -508,6 +507,10 @@ int gru_handle_user_call_os(unsigned lon
 	 * unload the context. The task will page fault and assign a new
 	 * context.
 	 */
+	if (gts->ts_tgid_owner == current->tgid && gts->ts_blade >= 0 &&
+				gts->ts_blade != uv_numa_blade_id())
+		gts->ts_force_unload = 1;
+
 	ret = -EAGAIN;
 	cbrnum = thread_cbr_number(gts, ucbnum);
 	if (gts->ts_force_unload) {
@@ -541,11 +544,13 @@ int gru_get_exception_detail(unsigned lo
 	if (!gts)
 		return -EINVAL;
 
-	if (gts->ts_gru) {
-		ucbnum = get_cb_number((void *)excdet.cb);
+	ucbnum = get_cb_number((void *)excdet.cb);
+	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE) {
+		ret = -EINVAL;
+	} else if (gts->ts_gru) {
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
-		prefetchw(cbe);		/* Harmless on hardware, required for emulator */
+		prefetchw(cbe);/* Harmless on hardware, required for emulator */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
@@ -609,7 +614,7 @@ int gru_user_flush_tlb(unsigned long arg
 	if (!gts)
 		return -EINVAL;
 
-	gru_flush_tlb_range(gts->ts_gms, req.vaddr, req.vaddr + req.len);
+	gru_flush_tlb_range(gts->ts_gms, req.vaddr, req.len);
 	gru_unlock_gts(gts);
 
 	return 0;
diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -45,7 +45,8 @@
 #include <asm/uv/uv_mmrs.h>
 
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
-unsigned long gru_start_paddr, gru_end_paddr __read_mostly;
+unsigned long gru_start_paddr __read_mostly;
+unsigned long gru_end_paddr __read_mostly;
 struct gru_stats_s gru_stats;
 
 /* Guaranteed user available resources on each node */
@@ -101,7 +102,7 @@ static int gru_file_mmap(struct file *fi
 		return -EPERM;
 
 	if (vma->vm_start & (GRU_GSEG_PAGESIZE - 1) ||
-	    			vma->vm_end & (GRU_GSEG_PAGESIZE - 1))
+				vma->vm_end & (GRU_GSEG_PAGESIZE - 1))
 		return -EINVAL;
 
 	vma->vm_flags |=
@@ -295,7 +296,7 @@ static int gru_init_tables(unsigned long
 	for_each_online_node(nid) {
 		bid = uv_node_to_blade_id(nid);
 		pnode = uv_node_to_pnode(nid);
-		if (gru_base[bid])
+		if (bid < 0 || gru_base[bid])
 			continue;
 		page = alloc_pages_node(nid, GFP_KERNEL, order);
 		if (!page)
@@ -308,11 +309,11 @@ static int gru_init_tables(unsigned long
 		dsrbytes = 0;
 		cbrs = 0;
 		for (gru = gru_base[bid]->bs_grus, chip = 0;
-		     		chip < GRU_CHIPLETS_PER_BLADE;
+				chip < GRU_CHIPLETS_PER_BLADE;
 				chip++, gru++) {
 			paddr = gru_chiplet_paddr(gru_base_paddr, pnode, chip);
 			vaddr = gru_chiplet_vaddr(gru_base_vaddr, pnode, chip);
-			gru_init_chiplet(gru, paddr, vaddr, bid, nid, chip);
+			gru_init_chiplet(gru, paddr, vaddr, nid, bid, chip);
 			n = hweight64(gru->gs_cbr_map) * GRU_CBR_AU_SIZE;
 			cbrs = max(cbrs, n);
 			n = hweight64(gru->gs_dsr_map) * GRU_DSR_AU_BYTES;
@@ -370,26 +371,26 @@ static int __init gru_init(void)
 	void *gru_start_vaddr;
 
 	if (!is_uv_system())
-		return 0;
+		return -ENODEV;
 
 #if defined CONFIG_IA64
 	gru_start_paddr = 0xd000000000UL; /* ZZZZZZZZZZZZZZZZZZZ fixme */
 #else
 	gru_start_paddr = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR) &
 				0x7fffffffffffUL;
-
 #endif
 	gru_start_vaddr = __va(gru_start_paddr);
-	gru_end_paddr = gru_start_paddr + MAX_NUMNODES * GRU_SIZE;
+	gru_end_paddr = gru_start_paddr + GRU_MAX_BLADES * GRU_SIZE;
 	printk(KERN_INFO "GRU space: 0x%lx - 0x%lx\n",
 	       gru_start_paddr, gru_end_paddr);
 	irq = get_base_irq();
 	for (chip = 0; chip < GRU_CHIPLETS_PER_BLADE; chip++) {
 		ret = request_irq(irq + chip, gru_intr, 0, id, NULL);
-		/* TODO: fix irq handling on x86. For now ignore failures because
+		/* TODO: fix irq handling on x86. For now ignore failure because
 		 * interrupts are not required & not yet fully supported */
 		if (ret) {
-			printk("!!!WARNING: GRU ignoring request failure!!!\n");
+			printk(KERN_WARNING
+			       "!!!WARNING: GRU ignoring request failure!!!\n");
 			ret = 0;
 		}
 		if (ret) {
@@ -469,7 +470,11 @@ struct vm_operations_struct gru_vm_ops =
 	.fault		= gru_fault,
 };
 
+#ifndef MODULE
 fs_initcall(gru_init);
+#else
+module_init(gru_init);
+#endif
 module_exit(gru_exit);
 
 module_param(gru_options, ulong, 0644);
diff -puN drivers/misc/sgi-gru/gruhandles.h~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -489,7 +489,7 @@ enum gru_cbr_state {
  * 	 64m			26	8
  * 	...
  */
-#define GRU_PAGESIZE(sh)	((((sh) > 20 ? (sh) + 2: (sh)) >> 1) - 6)
+#define GRU_PAGESIZE(sh)	((((sh) > 20 ? (sh) + 2 : (sh)) >> 1) - 6)
 #define GRU_SIZEAVAIL(sh)	(1UL << GRU_PAGESIZE(sh))
 
 /* minimum TLB purge count to ensure a full purge */
diff -puN drivers/misc/sgi-gru/grukservices.c~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -122,7 +122,7 @@ int gru_get_cb_exception_detail(void *cb
 	struct gru_control_block_extended *cbe;
 
 	cbe = get_cbe(GRUBASE(cb), get_cb_number(cb));
-	prefetchw(cbe);         /* Harmless on hardware, required for emulator */
+	prefetchw(cbe);	/* Harmless on hardware, required for emulator */
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
@@ -437,7 +437,7 @@ static int send_message_failure(void *cb
 		break;
 	case CBSS_PUT_NACKED:
 		STAT(mesq_send_put_nacked);
-		m =mq + (gru_get_amo_value_head(cb) << 6);
+		m = mq + (gru_get_amo_value_head(cb) << 6);
 		gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
 		if (gru_wait(cb) == CBS_IDLE)
 			ret = MQE_OK;
diff -puN drivers/misc/sgi-gru/grumain.c~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -432,8 +432,8 @@ static inline long gru_copy_handle(void 
 	return GRU_HANDLE_BYTES;
 }
 
-static void gru_prefetch_context(void *gseg, void *cb, void *cbe, unsigned long cbrmap,
-				unsigned long length)
+static void gru_prefetch_context(void *gseg, void *cb, void *cbe,
+				unsigned long cbrmap, unsigned long length)
 {
 	int i, scr;
 
@@ -773,8 +773,8 @@ int gru_fault(struct vm_area_struct *vma
 		return VM_FAULT_SIGBUS;
 
 again:
-	preempt_disable();
 	mutex_lock(&gts->ts_ctxlock);
+	preempt_disable();
 	if (gts->ts_gru) {
 		if (gts->ts_gru->gs_blade_id != uv_numa_blade_id()) {
 			STAT(migrated_nopfn_unload);
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -278,13 +278,12 @@ struct gru_stats_s {
 /* Generate a GRU asid value from a GRU base asid & a virtual address. */
 #if defined CONFIG_IA64
 #define VADDR_HI_BIT		64
-#define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
 #elif defined CONFIG_X86_64
 #define VADDR_HI_BIT		48
-#define GRUREGION(addr)		(0)		/* ZZZ could do better */
 #else
 #error "Unsupported architecture"
 #endif
+#define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
 #define GRUASID(asid, addr)	((asid) + GRUREGION(addr))
 
 /*------------------------------------------------------------------------------
@@ -297,12 +296,12 @@ struct gru_state;
  * This structure is pointed to from the mmstruct via the notifier pointer.
  * There is one of these per address space.
  */
-struct gru_mm_tracker {
-	unsigned int		mt_asid_gen;	/* ASID wrap count */
-	int			mt_asid;	/* current base ASID for gru */
-	unsigned short		mt_ctxbitmap;	/* bitmap of contexts using
+struct gru_mm_tracker {				/* pack to reduce size */
+	unsigned int		mt_asid_gen:24;	/* ASID wrap count */
+	unsigned int		mt_asid:24;	/* current base ASID for gru */
+	unsigned short		mt_ctxbitmap:16;/* bitmap of contexts using
 						   asid */
-};
+} __attribute__ ((packed));
 
 struct gru_mm_struct {
 	struct mmu_notifier	ms_notifier;
@@ -359,6 +358,8 @@ struct gru_thread_state {
 						   required for contest */
 	unsigned char		ts_cbr_au_count;/* Number of CBR resources
 						   required for contest */
+	char			ts_blade;	/* If >= 0, migrate context if
+						   ref from diferent blade */
 	char			ts_force_unload;/* force context to be unloaded
 						   after migration */
 	char			ts_cbr_idx[GRU_CBR_AU];/* CBR numbers of each
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~sgi-gru-misc-gru-cleanup drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~sgi-gru-misc-gru-cleanup
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -187,7 +187,7 @@ void gru_flush_tlb_range(struct gru_mm_s
 	"  FLUSH gruid %d, asid 0x%x, num %ld, cbmap 0x%x\n",
 				gid, asid, num, asids->mt_ctxbitmap);
 			tgh = get_lock_tgh_handle(gru);
-			tgh_invalidate(tgh, start, 0, asid, grupagesize, 0,
+			tgh_invalidate(tgh, start, ~0, asid, grupagesize, 0,
 				       num - 1, asids->mt_ctxbitmap);
 			get_unlock_tgh_handle(tgh);
 		} else {
@@ -212,9 +212,8 @@ void gru_flush_all_tlb(struct gru_state 
 
 	gru_dbg(grudev, "gru %p, gid %d\n", gru, gru->gs_gid);
 	tgh = get_lock_tgh_handle(gru);
-	tgh_invalidate(tgh, 0, ~0, 0, 1, 1, GRUMAXINVAL - 1, 0);
+	tgh_invalidate(tgh, 0, ~0, 0, 1, 1, GRUMAXINVAL - 1, 0xffff);
 	get_unlock_tgh_handle(tgh);
-	preempt_enable();
 }
 
 /*
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

