From: akpm@linux-foundation.org
Subject: - spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:27 -0700
Message-ID: <200707211025.l6LAPRx2011996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbXGUKfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: make sure context are scheduled again after spu_acquire_saved
has been removed from the -mm tree.  Its filename was
     spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spufs: make sure context are scheduled again after spu_acquire_saved
From: Christoph Hellwig <hch@lst.de>

Currently a process is removed from the physical spu when spu_acquire_saved is
saved but never put back.  This patch adds a new spu_release_saved that is to
be paired with spu_acquire_saved and put the process back if it has been in
RUNNABLE state before.

Niether Jeremy not be are entirely happy about this exact patch because it
adds another spu_activate call outside of the owner thread, but I feel this is
the best short-term fix we can come up with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/context.c  |   18 ++++++-
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 
 arch/powerpc/platforms/cell/spufs/file.c     |   42 ++++++++---------
 arch/powerpc/platforms/cell/spufs/spufs.h    |    5 ++
 4 files changed, 44 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/context.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved arch/powerpc/platforms/cell/spufs/context.c
--- a/arch/powerpc/platforms/cell/spufs/context.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved
+++ a/arch/powerpc/platforms/cell/spufs/context.c
@@ -168,8 +168,24 @@ int spu_acquire_runnable(struct spu_cont
 void spu_acquire_saved(struct spu_context *ctx)
 {
 	spu_acquire(ctx);
-	if (ctx->state != SPU_STATE_SAVED)
+	if (ctx->state != SPU_STATE_SAVED) {
+		set_bit(SPU_SCHED_WAS_ACTIVE, &ctx->sched_flags);
 		spu_deactivate(ctx);
+	}
+}
+
+/**
+ * spu_release_saved - unlock spu context and return it to the runqueue
+ * @ctx:	context to unlock
+ */
+void spu_release_saved(struct spu_context *ctx)
+{
+	BUG_ON(ctx->state != SPU_STATE_SAVED);
+
+	if (test_and_clear_bit(SPU_SCHED_WAS_ACTIVE, &ctx->sched_flags))
+		spu_activate(ctx, 0);
+
+	spu_release(ctx);
 }
 
 void spu_set_profile_private_kref(struct spu_context *ctx,
diff -puN arch/powerpc/platforms/cell/spufs/coredump.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved arch/powerpc/platforms/cell/spufs/coredump.c
--- a/arch/powerpc/platforms/cell/spufs/coredump.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved
+++ a/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -226,7 +226,7 @@ static void spufs_arch_write_notes(struc
 		spu_acquire_saved(ctx_info->ctx);
 		for (j = 0; j < spufs_coredump_num_notes; j++)
 			spufs_arch_write_note(ctx_info, j, file);
-		spu_release(ctx_info->ctx);
+		spu_release_saved(ctx_info->ctx);
 		list_del(&ctx_info->list);
 		kfree(ctx_info);
 	}
diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -370,7 +370,7 @@ spufs_regs_read(struct file *file, char 
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_regs_read(ctx, buffer, size, pos);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 
@@ -392,7 +392,7 @@ spufs_regs_write(struct file *file, cons
 	ret = copy_from_user(lscsa->gprs + *pos - size,
 			     buffer, size) ? -EFAULT : size;
 
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 
@@ -421,7 +421,7 @@ spufs_fpcr_read(struct file *file, char 
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_fpcr_read(ctx, buffer, size, pos);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 
@@ -443,7 +443,7 @@ spufs_fpcr_write(struct file *file, cons
 	ret = copy_from_user((char *)&lscsa->fpcr + *pos - size,
 			     buffer, size) ? -EFAULT : size;
 
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 
@@ -868,7 +868,7 @@ static ssize_t spufs_signal1_read(struct
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_signal1_read(ctx, buf, len, pos);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -999,7 +999,7 @@ static ssize_t spufs_signal2_read(struct
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_signal2_read(ctx, buf, len, pos);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -1626,7 +1626,7 @@ static void spufs_decr_set(void *data, u
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	spu_acquire_saved(ctx);
 	lscsa->decr.slot[0] = (u32) val;
-	spu_release(ctx);
+	spu_release_saved(ctx);
 }
 
 static u64 __spufs_decr_get(void *data)
@@ -1642,7 +1642,7 @@ static u64 spufs_decr_get(void *data)
 	u64 ret;
 	spu_acquire_saved(ctx);
 	ret = __spufs_decr_get(data);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 DEFINE_SIMPLE_ATTRIBUTE(spufs_decr_ops, spufs_decr_get, spufs_decr_set,
@@ -1654,7 +1654,7 @@ static void spufs_decr_status_set(void *
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	spu_acquire_saved(ctx);
 	lscsa->decr_status.slot[0] = (u32) val;
-	spu_release(ctx);
+	spu_release_saved(ctx);
 }
 
 static u64 __spufs_decr_status_get(void *data)
@@ -1670,7 +1670,7 @@ static u64 spufs_decr_status_get(void *d
 	u64 ret;
 	spu_acquire_saved(ctx);
 	ret = __spufs_decr_status_get(data);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 DEFINE_SIMPLE_ATTRIBUTE(spufs_decr_status_ops, spufs_decr_status_get,
@@ -1682,7 +1682,7 @@ static void spufs_event_mask_set(void *d
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	spu_acquire_saved(ctx);
 	lscsa->event_mask.slot[0] = (u32) val;
-	spu_release(ctx);
+	spu_release_saved(ctx);
 }
 
 static u64 __spufs_event_mask_get(void *data)
@@ -1698,7 +1698,7 @@ static u64 spufs_event_mask_get(void *da
 	u64 ret;
 	spu_acquire_saved(ctx);
 	ret = __spufs_event_mask_get(data);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 DEFINE_SIMPLE_ATTRIBUTE(spufs_event_mask_ops, spufs_event_mask_get,
@@ -1722,7 +1722,7 @@ static u64 spufs_event_status_get(void *
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_event_status_get(data);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 DEFINE_SIMPLE_ATTRIBUTE(spufs_event_status_ops, spufs_event_status_get,
@@ -1734,7 +1734,7 @@ static void spufs_srr0_set(void *data, u
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	spu_acquire_saved(ctx);
 	lscsa->srr0.slot[0] = (u32) val;
-	spu_release(ctx);
+	spu_release_saved(ctx);
 }
 
 static u64 spufs_srr0_get(void *data)
@@ -1744,7 +1744,7 @@ static u64 spufs_srr0_get(void *data)
 	u64 ret;
 	spu_acquire_saved(ctx);
 	ret = lscsa->srr0.slot[0];
-	spu_release(ctx);
+	spu_release_saved(ctx);
 	return ret;
 }
 DEFINE_SIMPLE_ATTRIBUTE(spufs_srr0_ops, spufs_srr0_get, spufs_srr0_set,
@@ -1800,7 +1800,7 @@ static u64 spufs_lslr_get(void *data)
 
 	spu_acquire_saved(ctx);
 	ret = __spufs_lslr_get(data);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -1864,7 +1864,7 @@ static ssize_t spufs_mbox_info_read(stru
 	spin_lock(&ctx->csa.register_lock);
 	ret = __spufs_mbox_info_read(ctx, buf, len, pos);
 	spin_unlock(&ctx->csa.register_lock);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -1902,7 +1902,7 @@ static ssize_t spufs_ibox_info_read(stru
 	spin_lock(&ctx->csa.register_lock);
 	ret = __spufs_ibox_info_read(ctx, buf, len, pos);
 	spin_unlock(&ctx->csa.register_lock);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -1943,7 +1943,7 @@ static ssize_t spufs_wbox_info_read(stru
 	spin_lock(&ctx->csa.register_lock);
 	ret = __spufs_wbox_info_read(ctx, buf, len, pos);
 	spin_unlock(&ctx->csa.register_lock);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -1993,7 +1993,7 @@ static ssize_t spufs_dma_info_read(struc
 	spin_lock(&ctx->csa.register_lock);
 	ret = __spufs_dma_info_read(ctx, buf, len, pos);
 	spin_unlock(&ctx->csa.register_lock);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
@@ -2044,7 +2044,7 @@ static ssize_t spufs_proxydma_info_read(
 	spin_lock(&ctx->csa.register_lock);
 	ret = __spufs_proxydma_info_read(ctx, buf, len, pos);
 	spin_unlock(&ctx->csa.register_lock);
-	spu_release(ctx);
+	spu_release_saved(ctx);
 
 	return ret;
 }
diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved arch/powerpc/platforms/cell/spufs/spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -45,6 +45,10 @@ enum {
 	SPU_SCHED_NOTIFY_ACTIVE,
 };
 
+enum {
+	SPU_SCHED_WAS_ACTIVE,	/* was active upon spu_acquire_saved()  */
+};
+
 struct spu_context {
 	struct spu *spu;		  /* pointer to a physical SPU */
 	struct spu_state csa;		  /* SPU context save area. */
@@ -221,6 +225,7 @@ void spu_unmap_mappings(struct spu_conte
 void spu_forget(struct spu_context *ctx);
 int spu_acquire_runnable(struct spu_context *ctx, unsigned long flags);
 void spu_acquire_saved(struct spu_context *ctx);
+void spu_release_saved(struct spu_context *ctx);
 
 int spu_activate(struct spu_context *ctx, unsigned long flags);
 void spu_deactivate(struct spu_context *ctx);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
coda-remove-coda_store-coda_release-upcalls.patch
remove-handle_mm_fault-export.patch
