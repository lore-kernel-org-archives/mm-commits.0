From: akpm@linux-foundation.org
Subject: [merged] gru-handle-failures-to-mmu_notifier_register.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:31 -0800
Message-ID: <200912162040.nBGKeVie013649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935499AbZLPUke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: handle failures to mmu_notifier_register
has been removed from the -mm tree.  Its filename was
     gru-handle-failures-to-mmu_notifier_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: handle failures to mmu_notifier_register
From: Jack Steiner <steiner@sgi.com>

Under some conditions, mmu_notifier_register() will fail to register a
mmu_notifier.  Fix the GRU driver to correctly handle these failures.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c    |    6 +++---
 drivers/misc/sgi-gru/grumain.c     |   18 +++++++++++-------
 drivers/misc/sgi-gru/grutlbpurge.c |    8 +++++++-
 3 files changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-handle-failures-to-mmu_notifier_register drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-handle-failures-to-mmu_notifier_register
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -96,7 +96,7 @@ static struct gru_thread_state *gru_allo
 	vma = gru_find_vma(vaddr);
 	if (vma)
 		gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
-	if (gts) {
+	if (!IS_ERR(gts)) {
 		mutex_lock(&gts->ts_ctxlock);
 		downgrade_write(&mm->mmap_sem);
 	} else {
@@ -747,8 +747,8 @@ int gru_set_context_option(unsigned long
 	gru_dbg(grudev, "op %d, gseg 0x%lx, value1 0x%lx\n", req.op, req.gseg, req.val1);
 
 	gts = gru_alloc_locked_gts(req.gseg);
-	if (!gts)
-		return -EINVAL;
+	if (IS_ERR(gts))
+		return PTR_ERR(gts);
 
 	switch (req.op) {
 	case sco_blade_chiplet:
diff -puN drivers/misc/sgi-gru/grumain.c~gru-handle-failures-to-mmu_notifier_register drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-handle-failures-to-mmu_notifier_register
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/err.h>
 #include <asm/uv/uv_hub.h>
 #include "gru.h"
 #include "grutables.h"
@@ -286,7 +287,8 @@ static void gru_unload_mm_tracker(struct
 void gts_drop(struct gru_thread_state *gts)
 {
 	if (gts && atomic_dec_return(&gts->ts_refcnt) == 0) {
-		gru_drop_mmu_notifier(gts->ts_gms);
+		if (gts->ts_gms)
+			gru_drop_mmu_notifier(gts->ts_gms);
 		kfree(gts);
 		STAT(gts_free);
 	}
@@ -313,13 +315,14 @@ struct gru_thread_state *gru_alloc_gts(s
 		int cbr_au_count, int dsr_au_count, int options, int tsid)
 {
 	struct gru_thread_state *gts;
+	struct gru_mm_struct *gms;
 	int bytes;
 
 	bytes = DSR_BYTES(dsr_au_count) + CBR_BYTES(cbr_au_count);
 	bytes += sizeof(struct gru_thread_state);
 	gts = kmalloc(bytes, GFP_KERNEL);
 	if (!gts)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	STAT(gts_alloc);
 	memset(gts, 0, sizeof(struct gru_thread_state)); /* zero out header */
@@ -338,9 +341,10 @@ struct gru_thread_state *gru_alloc_gts(s
 	if (vma) {
 		gts->ts_mm = current->mm;
 		gts->ts_vma = vma;
-		gts->ts_gms = gru_register_mmu_notifier();
-		if (!gts->ts_gms)
+		gms = gru_register_mmu_notifier();
+		if (IS_ERR(gms))
 			goto err;
+		gts->ts_gms = gms;
 	}
 
 	gru_dbg(grudev, "alloc gts %p\n", gts);
@@ -348,7 +352,7 @@ struct gru_thread_state *gru_alloc_gts(s
 
 err:
 	gts_drop(gts);
-	return NULL;
+	return ERR_CAST(gms);
 }
 
 /*
@@ -396,8 +400,8 @@ struct gru_thread_state *gru_alloc_threa
 
 	gts = gru_alloc_gts(vma, vdata->vd_cbr_au_count, vdata->vd_dsr_au_count,
 			    vdata->vd_user_options, tsid);
-	if (!gts)
-		return NULL;
+	if (IS_ERR(gts))
+		return gts;
 
 	spin_lock(&vdata->vd_lock);
 	ngts = gru_find_current_gts_nolock(vdata, tsid);
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~gru-handle-failures-to-mmu_notifier_register drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~gru-handle-failures-to-mmu_notifier_register
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -299,6 +299,7 @@ struct gru_mm_struct *gru_register_mmu_n
 {
 	struct gru_mm_struct *gms;
 	struct mmu_notifier *mn;
+	int err;
 
 	mn = mmu_find_ops(current->mm, &gru_mmuops);
 	if (mn) {
@@ -311,12 +312,17 @@ struct gru_mm_struct *gru_register_mmu_n
 			gms->ms_notifier.ops = &gru_mmuops;
 			atomic_set(&gms->ms_refcnt, 1);
 			init_waitqueue_head(&gms->ms_wait_queue);
-			__mmu_notifier_register(&gms->ms_notifier, current->mm);
+			err = __mmu_notifier_register(&gms->ms_notifier, current->mm);
+			if (err)
+				goto error;
 		}
 	}
 	gru_dbg(grudev, "gms %p, refcnt %d\n", gms,
 		atomic_read(&gms->ms_refcnt));
 	return gms;
+error:
+	kfree(gms);
+	return ERR_PTR(err);
 }
 
 void gru_drop_mmu_notifier(struct gru_mm_struct *gms)
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

