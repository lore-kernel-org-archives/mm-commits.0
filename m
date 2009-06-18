From: akpm@linux-foundation.org
Subject: [merged] gru-collect-per-context-user-statistics.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:00 -0700
Message-ID: <200906182249.n5IMn0jE008137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbZFRW4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: collect per-context user statistics
has been removed from the -mm tree.  Its filename was
     gru-collect-per-context-user-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: collect per-context user statistics
From: Jack Steiner <steiner@sgi.com>

Collect GRU statistics for each user GRU context.  Statistics are kept for
TLB misses & content resource contention.  Add user request for retrieving
the statistics.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   27 +++++++++++++++++++++++++++
 drivers/misc/sgi-gru/grufile.c   |    3 +++
 drivers/misc/sgi-gru/grulib.h    |   18 ++++++++++++++++++
 drivers/misc/sgi-gru/grumain.c   |    1 +
 drivers/misc/sgi-gru/grutables.h |    3 +++
 5 files changed, 52 insertions(+)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-collect-per-context-user-statistics drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-collect-per-context-user-statistics
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -498,6 +498,7 @@ irqreturn_t gru_intr(int irq, void *dev_
 		 */
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
+			gts->ustats.fmm_tlbdropin++;
 			gru_try_dropin(gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
@@ -516,6 +517,7 @@ static int gru_user_dropin(struct gru_th
 	struct gru_mm_struct *gms = gts->ts_gms;
 	int ret;
 
+	gts->ustats.upm_tlbdropin++;
 	while (1) {
 		wait_event(gms->ms_wait_queue,
 			   atomic_read(&gms->ms_range_active) == 0);
@@ -719,6 +721,31 @@ int gru_user_flush_tlb(unsigned long arg
 }
 
 /*
+ * Fetch GSEG statisticss
+ */
+long gru_get_gseg_statistics(unsigned long arg)
+{
+	struct gru_thread_state *gts;
+	struct gru_get_gseg_statistics_req req;
+
+	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
+		return -EFAULT;
+
+	gts = gru_find_lock_gts(req.gseg);
+	if (gts) {
+		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
+		gru_unlock_gts(gts);
+	} else {
+		memset(&req.stats, 0, sizeof(gts->ustats));
+	}
+
+	if (copy_to_user((void __user *)arg, &req, sizeof(req)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
  * Register the current task as the user of the GSEG slice.
  * Needed for TLB fault interrupt targeting.
  */
diff -puN drivers/misc/sgi-gru/grufile.c~gru-collect-per-context-user-statistics drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-collect-per-context-user-statistics
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -251,6 +251,9 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_USER_CALL_OS:
 		err = gru_handle_user_call_os(arg);
 		break;
+	case GRU_GET_GSEG_STATISTICS:
+		err = gru_get_gseg_statistics(arg);
+		break;
 	case GRU_KTEST:
 		err = gru_ktest(arg);
 		break;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-collect-per-context-user-statistics drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-collect-per-context-user-statistics
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -50,6 +50,9 @@
 /* For dumpping GRU chiplet state */
 #define GRU_DUMP_CHIPLET_STATE		_IOWR(GRU_IOCTL_NUM, 11, void *)
 
+/* For getting gseg statistics */
+#define GRU_GET_GSEG_STATISTICS		_IOWR(GRU_IOCTL_NUM, 12, void *)
+
 /* For user TLB flushing (primarily for tests) */
 #define GRU_USER_FLUSH_TLB		_IOWR(GRU_IOCTL_NUM, 50, void *)
 
@@ -61,6 +64,21 @@
 
 #define CONTEXT_WINDOW_BYTES(th)        (GRU_GSEG_PAGESIZE * (th))
 #define THREAD_POINTER(p, th)		(p + GRU_GSEG_PAGESIZE * (th))
+#define GSEG_START(cb)			((void *)((unsigned long)(cb) & ~(GRU_GSEG_PAGESIZE - 1)))
+
+/*
+ * Statictics kept on a per-GTS basis.
+ */
+struct gts_statistics {
+	unsigned long	fmm_tlbdropin;
+	unsigned long	upm_tlbdropin;
+	unsigned long	context_stolen;
+};
+
+struct gru_get_gseg_statistics_req {
+	unsigned long		gseg;
+	struct gts_statistics	stats;
+};
 
 /*
  * Structure used to pass TLB flush parameters to the driver
diff -puN drivers/misc/sgi-gru/grumain.c~gru-collect-per-context-user-statistics drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-collect-per-context-user-statistics
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -744,6 +744,7 @@ void gru_steal_context(struct gru_thread
 	spin_unlock(&blade->bs_lock);
 
 	if (ngts) {
+		gts->ustats.context_stolen++;
 		ngts->ts_steal_jiffies = jiffies;
 		gru_unload_context(ngts, is_kernel_context(ngts) ? 0 : 1);
 		gts_stolen(ngts, blade);
diff -puN drivers/misc/sgi-gru/grutables.h~gru-collect-per-context-user-statistics drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-collect-per-context-user-statistics
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -148,6 +148,7 @@
 #include <linux/wait.h>
 #include <linux/mmu_notifier.h>
 #include "gru.h"
+#include "grulib.h"
 #include "gruhandles.h"
 
 extern struct gru_stats_s gru_stats;
@@ -388,6 +389,7 @@ struct gru_thread_state {
 							  allocated CB */
 	int			ts_data_valid;	/* Indicates if ts_gdata has
 						   valid data */
+	struct gts_statistics	ustats;		/* User statistics */
 	unsigned long		ts_gdata[0];	/* save area for GRU data (CB,
 						   DS, CBE) */
 };
@@ -641,6 +643,7 @@ extern void gru_tgh_flush_init(struct gr
 extern int gru_kservices_init(void);
 extern void gru_kservices_exit(void);
 extern int gru_dump_chiplet_request(unsigned long arg);
+extern long gru_get_gseg_statistics(unsigned long arg);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
 extern int gru_user_flush_tlb(unsigned long arg);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

