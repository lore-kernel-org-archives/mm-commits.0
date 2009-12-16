From: akpm@linux-foundation.org
Subject: [merged] gru-add-additional-gru-statistics.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:45 -0800
Message-ID: <200912162040.nBGKejoe013672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965018AbZLPUks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add additional GRU statistics
has been removed from the -mm tree.  Its filename was
     gru-add-additional-gru-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add additional GRU statistics
From: Jack Steiner <steiner@sgi.com>

Add additional GRU statistics & debug messages.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |   18 ++++++++-----
 drivers/misc/sgi-gru/grufile.c      |    2 -
 drivers/misc/sgi-gru/gruhandles.c   |   11 +++++---
 drivers/misc/sgi-gru/grukservices.c |   35 +++++++++++++++++---------
 drivers/misc/sgi-gru/grumain.c      |   10 +++++--
 drivers/misc/sgi-gru/gruprocfs.c    |   25 +++++++++---------
 drivers/misc/sgi-gru/grutables.h    |   18 ++++++-------
 drivers/misc/sgi-gru/grutlbpurge.c  |    6 ++--
 8 files changed, 77 insertions(+), 48 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -303,7 +303,7 @@ static int gru_try_dropin(struct gru_thr
 			  struct gru_tlb_fault_handle *tfh,
 			  struct gru_instruction_bits *cbk)
 {
-	int pageshift = 0, asid, write, ret, atomic = !cbk;
+	int pageshift = 0, asid, write, ret, atomic = !cbk, indexway;
 	unsigned long gpa = 0, vaddr = 0;
 
 	/*
@@ -333,6 +333,7 @@ static int gru_try_dropin(struct gru_thr
 	write = (tfh->cause & TFHCAUSE_TLB_MOD) != 0;
 	vaddr = tfh->missvaddr;
 	asid = tfh->missasid;
+	indexway = tfh->indexway;
 	if (asid == 0)
 		goto failnoasid;
 
@@ -361,11 +362,12 @@ static int gru_try_dropin(struct gru_thr
 	gru_cb_set_istatus_active(cbk);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
-	STAT(tlb_dropin);
 	gru_dbg(grudev,
-		"%s: tfh 0x%p, vaddr 0x%lx, asid 0x%x, ps %d, gpa 0x%lx\n",
-		ret ? "non-atomic" : "atomic", tfh, vaddr, asid,
-		pageshift, gpa);
+		"%s: gid %d, gts 0x%p, tfh 0x%p, vaddr 0x%lx, asid 0x%x, indexway 0x%x,"
+		" rw %d, ps %d, gpa 0x%lx\n",
+		atomic ? "atomic" : "non-atomic", gts->ts_gru->gs_gid, gts, tfh, vaddr, asid,
+		indexway, write, pageshift, gpa);
+	STAT(tlb_dropin);
 	return 0;
 
 failnoasid:
@@ -460,12 +462,14 @@ static irqreturn_t gru_intr(int chiplet,
 		dmap.fault_bits[0], dmap.fault_bits[1]);
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
+		STAT(intr_cbr);
 		complete(gru->gs_blade->bs_async_wq);
 		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
 			gru->gs_gid, cbrnum, gru->gs_blade->bs_async_wq->done);
 	}
 
 	for_each_cbr_in_tfm(cbrnum, imap.fault_bits) {
+		STAT(intr_tfh);
 		tfh = get_tfh_by_index(gru, cbrnum);
 		prefetchw(tfh);	/* Helps on hdw, required for emulator */
 
@@ -551,7 +555,6 @@ int gru_handle_user_call_os(unsigned lon
 	int ucbnum, cbrnum, ret = -EINVAL;
 
 	STAT(call_os);
-	gru_dbg(grudev, "address 0x%lx\n", cb);
 
 	/* sanity check the cb pointer */
 	ucbnum = get_cb_number((void *)cb);
@@ -561,6 +564,7 @@ int gru_handle_user_call_os(unsigned lon
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
 		return -EINVAL;
+	gru_dbg(grudev, "address 0x%lx, gid %d, gts 0x%p\n", cb, gts->ts_gru ? gts->ts_gru->gs_gid : -1, gts);
 
 	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE)
 		goto exit;
@@ -603,11 +607,11 @@ int gru_get_exception_detail(unsigned lo
 	if (copy_from_user(&excdet, (void __user *)arg, sizeof(excdet)))
 		return -EFAULT;
 
-	gru_dbg(grudev, "address 0x%lx\n", excdet.cb);
 	gts = gru_find_lock_gts(excdet.cb);
 	if (!gts)
 		return -EINVAL;
 
+	gru_dbg(grudev, "address 0x%lx, gid %d, gts 0x%p\n", excdet.cb, gts->ts_gru ? gts->ts_gru->gs_gid : -1, gts);
 	ucbnum = get_cb_number((void *)excdet.cb);
 	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE) {
 		ret = -EINVAL;
diff -puN drivers/misc/sgi-gru/grufile.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -192,7 +192,7 @@ static long gru_file_unlocked_ioctl(stru
 {
 	int err = -EBADRQC;
 
-	gru_dbg(grudev, "file %p\n", file);
+	gru_dbg(grudev, "file %p, req 0x%x, 0x%lx\n", file, req, arg);
 
 	switch (req) {
 	case GRU_CREATE_CONTEXT:
diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -27,9 +27,11 @@
 #ifdef CONFIG_IA64
 #include <asm/processor.h>
 #define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
+#define CLKS2NSEC(c)		((c) *1000000000 / local_cpu_data->itc_freq)
 #else
 #include <asm/tsc.h>
 #define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
+#define CLKS2NSEC(c)		((c) * 1000000 / tsc_khz)
 #endif
 
 /* Extract the status field from a kernel handle */
@@ -39,10 +41,13 @@ struct mcs_op_statistic mcs_op_statistic
 
 static void update_mcs_stats(enum mcs_op op, unsigned long clks)
 {
+	unsigned long nsec;
+
+	nsec = CLKS2NSEC(clks);
 	atomic_long_inc(&mcs_op_statistics[op].count);
-	atomic_long_add(clks, &mcs_op_statistics[op].total);
-	if (mcs_op_statistics[op].max < clks)
-		mcs_op_statistics[op].max = clks;
+	atomic_long_add(nsec, &mcs_op_statistics[op].total);
+	if (mcs_op_statistics[op].max < nsec)
+		mcs_op_statistics[op].max = nsec;
 }
 
 static void start_instruction(void *h)
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -414,8 +414,8 @@ char *gru_get_cb_exception_detail_str(in
 	if (ret > 0 && gen->istatus == CBS_EXCEPTION) {
 		gru_get_cb_exception_detail(cb, &excdet);
 		snprintf(buf, size,
-			"GRU exception: cb %p, opc %d, exopc %d, ecause 0x%x,"
-			"excdet0 0x%lx, excdet1 0x%x",
+			"GRU:%d exception: cb %p, opc %d, exopc %d, ecause 0x%x,"
+			"excdet0 0x%lx, excdet1 0x%x", smp_processor_id(),
 			gen, excdet.opc, excdet.exopc, excdet.ecause,
 			excdet.exceptdet0, excdet.exceptdet1);
 	} else {
@@ -604,6 +604,8 @@ static int send_noop_message(void *cb, s
 				ret = MQE_UNEXPECTED_CB_ERR;
 			break;
 		case CBSS_PAGE_OVERFLOW:
+			STAT(mesq_noop_page_overflow);
+			/* fallthru */
 		default:
 			BUG();
 		}
@@ -745,6 +747,9 @@ static int send_message_failure(void *cb
 		STAT(mesq_send_put_nacked);
 		ret = send_message_put_nacked(cb, mqd, mesg, lines);
 		break;
+	case CBSS_PAGE_OVERFLOW:
+		STAT(mesq_page_overflow);
+		/* fallthru */
 	default:
 		BUG();
 	}
@@ -837,7 +842,6 @@ void *gru_get_next_message(struct gru_me
 	int present = mhdr->present;
 
 	/* skip NOOP messages */
-	STAT(mesq_receive);
 	while (present == MQS_NOOP) {
 		gru_free_message(mqd, mhdr);
 		mhdr = mq->next;
@@ -857,6 +861,7 @@ void *gru_get_next_message(struct gru_me
 	if (mhdr->lines == 2)
 		restore_present2(mhdr, mhdr->present2);
 
+	STAT(mesq_receive);
 	return mhdr;
 }
 EXPORT_SYMBOL_GPL(gru_get_next_message);
@@ -927,24 +932,24 @@ static int quicktest0(unsigned long arg)
 
 	gru_vload(cb, uv_gpa(&word0), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE) {
-		printk(KERN_DEBUG "GRU quicktest0: CBR failure 1\n");
+		printk(KERN_DEBUG "GRU:%d quicktest0: CBR failure 1\n", smp_processor_id());
 		goto done;
 	}
 
 	if (*p != MAGIC) {
-		printk(KERN_DEBUG "GRU: quicktest0 bad magic 0x%lx\n", *p);
+		printk(KERN_DEBUG "GRU:%d quicktest0 bad magic 0x%lx\n", smp_processor_id(), *p);
 		goto done;
 	}
 	gru_vstore(cb, uv_gpa(&word1), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE) {
-		printk(KERN_DEBUG "GRU quicktest0: CBR failure 2\n");
+		printk(KERN_DEBUG "GRU:%d quicktest0: CBR failure 2\n", smp_processor_id());
 		goto done;
 	}
 
 	if (word0 != word1 || word1 != MAGIC) {
 		printk(KERN_DEBUG
-		       "GRU quicktest0 err: found 0x%lx, expected 0x%lx\n",
-		     word1, MAGIC);
+		       "GRU:%d quicktest0 err: found 0x%lx, expected 0x%lx\n",
+		     smp_processor_id(), word1, MAGIC);
 		goto done;
 	}
 	ret = 0;
@@ -981,8 +986,11 @@ static int quicktest1(unsigned long arg)
 		if (ret)
 			break;
 	}
-	if (ret != MQE_QUEUE_FULL || i != 4)
+	if (ret != MQE_QUEUE_FULL || i != 4) {
+		printk(KERN_DEBUG "GRU:%d quicktest1: unexpect status %d, i %d\n",
+		       smp_processor_id(), ret, i);
 		goto done;
+	}
 
 	for (i = 0; i < 6; i++) {
 		m = gru_get_next_message(&mqd);
@@ -990,7 +998,12 @@ static int quicktest1(unsigned long arg)
 			break;
 		gru_free_message(&mqd, m);
 	}
-	ret = (i == 4) ? 0 : -EIO;
+	if (i != 4) {
+		printk(KERN_DEBUG "GRU:%d quicktest2: bad message, i %d, m %p, m8 %d\n",
+			smp_processor_id(), i, m, m ? m[8] : -1);
+		goto done;
+	}
+	ret = 0;
 
 done:
 	kfree(p);
@@ -1069,7 +1082,7 @@ static int quicktest3(unsigned long arg)
 	memset(buf1, get_cycles() & 255, sizeof(buf1));
 	gru_copy_gpa(uv_gpa(buf2), uv_gpa(buf1), BUFSIZE);
 	if (memcmp(buf1, buf2, BUFSIZE)) {
-		printk(KERN_DEBUG "GRU quicktest3 error\n");
+		printk(KERN_DEBUG "GRU:%d quicktest3 error\n", smp_processor_id());
 		ret = -EIO;
 	}
 	return ret;
diff -puN drivers/misc/sgi-gru/grumain.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -370,6 +370,7 @@ struct gru_vma_data *gru_alloc_vma_data(
 	if (!vdata)
 		return NULL;
 
+	STAT(vdata_alloc);
 	INIT_LIST_HEAD(&vdata->vd_head);
 	spin_lock_init(&vdata->vd_lock);
 	gru_dbg(grudev, "alloc vdata %p\n", vdata);
@@ -552,7 +553,8 @@ void gru_unload_context(struct gru_threa
 		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
-	gru_dbg(grudev, "gts %p\n", gts);
+	gru_dbg(grudev, "gts %p, cbrmap 0x%lx, dsrmap 0x%lx\n",
+		gts, gts->ts_cbr_map, gts->ts_dsr_map);
 	lock_cch_handle(cch);
 	if (cch_interrupt_sync(cch))
 		BUG();
@@ -583,9 +585,7 @@ void gru_load_context(struct gru_thread_
 	struct gru_context_configuration_handle *cch;
 	int i, err, asid, ctxnum = gts->ts_ctxnum;
 
-	gru_dbg(grudev, "gts %p\n", gts);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
-
 	lock_cch_handle(cch);
 	cch->tfm_fault_bit_enable =
 	    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
@@ -635,6 +635,10 @@ void gru_load_context(struct gru_thread_
 	if (cch_start(cch))
 		BUG();
 	unlock_cch_handle(cch);
+
+	gru_dbg(grudev, "gid %d, gts %p, cbrmap 0x%lx, dsrmap 0x%lx, tie %d, tis %d\n",
+		gts->ts_gru->gs_gid, gts, gts->ts_cbr_map, gts->ts_dsr_map,
+		(gts->ts_user_options == GRU_OPT_MISS_FMM_INTR), gts->ts_tlb_int_select);
 }
 
 /*
diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -36,8 +36,7 @@ static void printstat_val(struct seq_fil
 {
 	unsigned long val = atomic_long_read(v);
 
-	if (val)
-		seq_printf(s, "%16lu %s\n", val, id);
+	seq_printf(s, "%16lu %s\n", val, id);
 }
 
 static int statistics_show(struct seq_file *s, void *p)
@@ -46,7 +45,8 @@ static int statistics_show(struct seq_fi
 	printstat(s, vdata_free);
 	printstat(s, gts_alloc);
 	printstat(s, gts_free);
-	printstat(s, vdata_double_alloc);
+	printstat(s, gms_alloc);
+	printstat(s, gms_free);
 	printstat(s, gts_double_allocate);
 	printstat(s, assign_context);
 	printstat(s, assign_context_failed);
@@ -59,15 +59,15 @@ static int statistics_show(struct seq_fi
 	printstat(s, steal_kernel_context);
 	printstat(s, steal_context_failed);
 	printstat(s, nopfn);
-	printstat(s, break_cow);
 	printstat(s, asid_new);
 	printstat(s, asid_next);
 	printstat(s, asid_wrap);
 	printstat(s, asid_reuse);
 	printstat(s, intr);
+	printstat(s, intr_cbr);
+	printstat(s, intr_tfh);
 	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
-	printstat(s, call_os_check_for_bug);
 	printstat(s, call_os_wait_queue);
 	printstat(s, user_flush_tlb);
 	printstat(s, user_unload_context);
@@ -83,11 +83,9 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin_fail_idle);
 	printstat(s, tlb_dropin_fail_fmm);
 	printstat(s, tlb_dropin_fail_no_exception);
-	printstat(s, tlb_dropin_fail_no_exception_war);
 	printstat(s, tfh_stale_on_fault);
 	printstat(s, mmu_invalidate_range);
 	printstat(s, mmu_invalidate_page);
-	printstat(s, mmu_clear_flush_young);
 	printstat(s, flush_tlb);
 	printstat(s, flush_tlb_gru);
 	printstat(s, flush_tlb_gru_tgh);
@@ -104,7 +102,6 @@ static int statistics_show(struct seq_fi
 	printstat(s, mesq_send_qlimit_reached);
 	printstat(s, mesq_send_amo_nacked);
 	printstat(s, mesq_send_put_nacked);
-	printstat(s, mesq_qf_not_full);
 	printstat(s, mesq_qf_locked);
 	printstat(s, mesq_qf_noop_not_full);
 	printstat(s, mesq_qf_switch_head_failed);
@@ -114,6 +111,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, mesq_noop_qlimit_reached);
 	printstat(s, mesq_noop_amo_nacked);
 	printstat(s, mesq_noop_put_nacked);
+	printstat(s, mesq_noop_page_overflow);
 	return 0;
 }
 
@@ -131,6 +129,7 @@ static int mcs_statistics_show(struct se
 	static char *id[] = {"cch_allocate", "cch_start", "cch_interrupt",
 		"cch_interrupt_sync", "cch_deallocate", "tgh_invalidate"};
 
+	seq_printf(s, "%-20s%12s%12s%12s\n", "#id", "count", "aver-clks", "max-clks");
 	for (op = 0; op < mcsop_last; op++) {
 		count = atomic_long_read(&mcs_op_statistics[op].count);
 		total = atomic_long_read(&mcs_op_statistics[op].total);
@@ -150,6 +149,7 @@ static ssize_t mcs_statistics_write(stru
 
 static int options_show(struct seq_file *s, void *p)
 {
+	seq_printf(s, "#bitmask: 1=trace, 2=statistics\n");
 	seq_printf(s, "0x%lx\n", gru_options);
 	return 0;
 }
@@ -179,16 +179,17 @@ static int cch_seq_show(struct seq_file 
 	const char *mode[] = { "??", "UPM", "INTR", "OS_POLL" };
 
 	if (gid == 0)
-		seq_printf(file, "#%5s%5s%6s%9s%6s%8s%8s\n", "gid", "bid",
-			   "ctx#", "pid", "cbrs", "dsbytes", "mode");
+		seq_printf(file, "#%5s%5s%6s%7s%9s%6s%8s%8s\n", "gid", "bid",
+			   "ctx#", "asid", "pid", "cbrs", "dsbytes", "mode");
 	if (gru)
 		for (i = 0; i < GRU_NUM_CCH; i++) {
 			ts = gru->gs_gts[i];
 			if (!ts)
 				continue;
-			seq_printf(file, " %5d%5d%6d%9d%6d%8d%8s\n",
+			seq_printf(file, " %5d%5d%6d%7d%9d%6d%8d%8s\n",
 				   gru->gs_gid, gru->gs_blade_id, i,
-				   ts->ts_tgid_owner,
+				   is_kernel_context(ts) ? 0 : ts->ts_gms->ms_asids[gid].mt_asid,
+				   is_kernel_context(ts) ? 0 : ts->ts_tgid_owner,
 				   ts->ts_cbr_au_count * GRU_CBR_AU_SIZE,
 				   ts->ts_cbr_au_count * GRU_DSR_AU_BYTES,
 				   mode[ts->ts_user_options &
diff -puN drivers/misc/sgi-gru/grutables.h~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -171,7 +171,8 @@ struct gru_stats_s {
 	atomic_long_t vdata_free;
 	atomic_long_t gts_alloc;
 	atomic_long_t gts_free;
-	atomic_long_t vdata_double_alloc;
+	atomic_long_t gms_alloc;
+	atomic_long_t gms_free;
 	atomic_long_t gts_double_allocate;
 	atomic_long_t assign_context;
 	atomic_long_t assign_context_failed;
@@ -184,15 +185,15 @@ struct gru_stats_s {
 	atomic_long_t steal_kernel_context;
 	atomic_long_t steal_context_failed;
 	atomic_long_t nopfn;
-	atomic_long_t break_cow;
 	atomic_long_t asid_new;
 	atomic_long_t asid_next;
 	atomic_long_t asid_wrap;
 	atomic_long_t asid_reuse;
 	atomic_long_t intr;
+	atomic_long_t intr_cbr;
+	atomic_long_t intr_tfh;
 	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
-	atomic_long_t call_os_check_for_bug;
 	atomic_long_t call_os_wait_queue;
 	atomic_long_t user_flush_tlb;
 	atomic_long_t user_unload_context;
@@ -208,11 +209,9 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin_fail_idle;
 	atomic_long_t tlb_dropin_fail_fmm;
 	atomic_long_t tlb_dropin_fail_no_exception;
-	atomic_long_t tlb_dropin_fail_no_exception_war;
 	atomic_long_t tfh_stale_on_fault;
 	atomic_long_t mmu_invalidate_range;
 	atomic_long_t mmu_invalidate_page;
-	atomic_long_t mmu_clear_flush_young;
 	atomic_long_t flush_tlb;
 	atomic_long_t flush_tlb_gru;
 	atomic_long_t flush_tlb_gru_tgh;
@@ -231,7 +230,7 @@ struct gru_stats_s {
 	atomic_long_t mesq_send_qlimit_reached;
 	atomic_long_t mesq_send_amo_nacked;
 	atomic_long_t mesq_send_put_nacked;
-	atomic_long_t mesq_qf_not_full;
+	atomic_long_t mesq_page_overflow;
 	atomic_long_t mesq_qf_locked;
 	atomic_long_t mesq_qf_noop_not_full;
 	atomic_long_t mesq_qf_switch_head_failed;
@@ -241,6 +240,7 @@ struct gru_stats_s {
 	atomic_long_t mesq_noop_qlimit_reached;
 	atomic_long_t mesq_noop_amo_nacked;
 	atomic_long_t mesq_noop_put_nacked;
+	atomic_long_t mesq_noop_page_overflow;
 
 };
 
@@ -255,8 +255,8 @@ struct mcs_op_statistic {
 
 extern struct mcs_op_statistic mcs_op_statistics[mcsop_last];
 
-#define OPT_DPRINT	1
-#define OPT_STATS	2
+#define OPT_DPRINT		1
+#define OPT_STATS		2
 
 
 #define IRQ_GRU			110	/* Starting IRQ number for interrupts */
@@ -279,7 +279,7 @@ extern struct mcs_op_statistic mcs_op_st
 #define gru_dbg(dev, fmt, x...)						\
 	do {								\
 		if (gru_options & OPT_DPRINT)				\
-			dev_dbg(dev, "%s: " fmt, __func__, x);		\
+			printk(KERN_DEBUG "GRU:%d %s: " fmt, smp_processor_id(), __func__, x);\
 	} while (0)
 #else
 #define gru_dbg(x...)
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~gru-add-additional-gru-statistics drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~gru-add-additional-gru-statistics
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -184,8 +184,8 @@ void gru_flush_tlb_range(struct gru_mm_s
 			STAT(flush_tlb_gru_tgh);
 			asid = GRUASID(asid, start);
 			gru_dbg(grudev,
-	"  FLUSH gruid %d, asid 0x%x, num %ld, cbmap 0x%x\n",
-				gid, asid, num, asids->mt_ctxbitmap);
+	"  FLUSH gruid %d, asid 0x%x, vaddr 0x%lx, vamask 0x%x, num %ld, cbmap 0x%x\n",
+			      gid, asid, start, grupagesize, num, asids->mt_ctxbitmap);
 			tgh = get_lock_tgh_handle(gru);
 			tgh_invalidate(tgh, start, ~0, asid, grupagesize, 0,
 				       num - 1, asids->mt_ctxbitmap);
@@ -308,6 +308,7 @@ struct gru_mm_struct *gru_register_mmu_n
 	} else {
 		gms = kzalloc(sizeof(*gms), GFP_KERNEL);
 		if (gms) {
+			STAT(gms_alloc);
 			spin_lock_init(&gms->ms_asid_lock);
 			gms->ms_notifier.ops = &gru_mmuops;
 			atomic_set(&gms->ms_refcnt, 1);
@@ -333,6 +334,7 @@ void gru_drop_mmu_notifier(struct gru_mm
 		if (!gms->ms_released)
 			mmu_notifier_unregister(&gms->ms_notifier, current->mm);
 		kfree(gms);
+		STAT(gms_free);
 	}
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

