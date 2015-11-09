From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:26 -0800
Message-ID: <5640f79a.+3XXct01ZmLHAm0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbKITo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: rename __GFP_WAIT to __GFP_RECLAIM
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: rename __GFP_WAIT to __GFP_RECLAIM

__GFP_WAIT was used to signal that the caller was in atomic context and
could not sleep.  Now it is possible to distinguish between true atomic
context and callers that are not willing to sleep.  The latter should
clear __GFP_DIRECT_RECLAIM so kswapd will still wake.  As clearing
__GFP_WAIT behaves differently, there is a risk that people will clear the
wrong flags.  This patch renames __GFP_WAIT to __GFP_RECLAIM to clearly
indicate what it does -- setting it allows all reclaim activity, clearing
them prevents it.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c                            |    4 ++--
 block/blk-mq.c                              |    2 +-
 block/scsi_ioctl.c                          |    6 +++---
 drivers/block/drbd/drbd_bitmap.c            |    2 +-
 drivers/block/mtip32xx/mtip32xx.c           |    2 +-
 drivers/block/paride/pd.c                   |    2 +-
 drivers/block/pktcdvd.c                     |    4 ++--
 drivers/gpu/drm/i915/i915_gem.c             |    2 +-
 drivers/ide/ide-atapi.c                     |    2 +-
 drivers/ide/ide-cd.c                        |    2 +-
 drivers/ide/ide-cd_ioctl.c                  |    2 +-
 drivers/ide/ide-devsets.c                   |    2 +-
 drivers/ide/ide-disk.c                      |    2 +-
 drivers/ide/ide-ioctls.c                    |    4 ++--
 drivers/ide/ide-park.c                      |    2 +-
 drivers/ide/ide-pm.c                        |    4 ++--
 drivers/ide/ide-tape.c                      |    4 ++--
 drivers/ide/ide-taskfile.c                  |    4 ++--
 drivers/infiniband/hw/qib/qib_init.c        |    2 +-
 drivers/misc/vmw_balloon.c                  |    2 +-
 drivers/nvme/host/pci.c                     |    6 ++++--
 drivers/scsi/scsi_error.c                   |    2 +-
 drivers/scsi/scsi_lib.c                     |    4 ++--
 drivers/staging/rdma/hfi1/init.c            |    2 +-
 drivers/staging/rdma/ipath/ipath_file_ops.c |    2 +-
 fs/cachefiles/internal.h                    |    2 +-
 fs/direct-io.c                              |    2 +-
 fs/nilfs2/mdt.h                             |    2 +-
 include/linux/gfp.h                         |   16 ++++++++--------
 kernel/power/swap.c                         |   16 ++++++++--------
 lib/percpu_ida.c                            |    2 +-
 mm/failslab.c                               |    8 ++++----
 mm/filemap.c                                |    2 +-
 mm/huge_memory.c                            |    2 +-
 mm/memcontrol.c                             |    2 +-
 mm/migrate.c                                |    2 +-
 mm/page_alloc.c                             |    9 +++++----
 security/integrity/ima/ima_crypto.c         |    2 +-
 38 files changed, 71 insertions(+), 68 deletions(-)

diff -puN block/blk-core.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim block/blk-core.c
--- a/block/blk-core.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/block/blk-core.c
@@ -638,7 +638,7 @@ int blk_queue_enter(struct request_queue
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
 
-		if (!(gfp & __GFP_WAIT))
+		if (!gfpflags_allow_blocking(gfp))
 			return -EBUSY;
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
@@ -2038,7 +2038,7 @@ void generic_make_request(struct bio *bi
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, __GFP_WAIT) == 0)) {
+		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
 
 			q->make_request_fn(q, bio);
 
diff -puN block/blk-mq.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim block/blk-mq.c
--- a/block/blk-mq.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/block/blk-mq.c
@@ -1186,7 +1186,7 @@ static struct request *blk_mq_map_reques
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q,
-				__GFP_WAIT|__GFP_HIGH, false, ctx, hctx);
+				__GFP_RECLAIM|__GFP_HIGH, false, ctx, hctx);
 		rq = __blk_mq_alloc_request(&alloc_data, rw);
 		ctx = alloc_data.ctx;
 		hctx = alloc_data.hctx;
diff -puN block/scsi_ioctl.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/block/scsi_ioctl.c
@@ -444,7 +444,7 @@ int sg_scsi_ioctl(struct request_queue *
 
 	}
 
-	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_RECLAIM);
 	if (IS_ERR(rq)) {
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
@@ -495,7 +495,7 @@ int sg_scsi_ioctl(struct request_queue *
 		break;
 	}
 
-	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
+	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_RECLAIM)) {
 		err = DRIVER_ERROR << 24;
 		goto error;
 	}
@@ -536,7 +536,7 @@ static int __blk_send_generic(struct req
 	struct request *rq;
 	int err;
 
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	rq = blk_get_request(q, WRITE, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	blk_rq_set_block_pc(rq);
diff -puN drivers/block/drbd/drbd_bitmap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -1007,7 +1007,7 @@ static void bm_page_io_async(struct drbd
 	bm_set_page_unchanged(b->bm_pages[page_nr]);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES) {
-		page = mempool_alloc(drbd_md_io_page_pool, __GFP_HIGHMEM|__GFP_WAIT);
+		page = mempool_alloc(drbd_md_io_page_pool, __GFP_HIGHMEM|__GFP_RECLAIM);
 		copy_highpage(page, b->bm_pages[page_nr]);
 		bm_store_page_idx(page, page_nr);
 	} else
diff -puN drivers/block/mtip32xx/mtip32xx.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -173,7 +173,7 @@ static struct mtip_cmd *mtip_get_int_com
 {
 	struct request *rq;
 
-	rq = blk_mq_alloc_request(dd->queue, 0, __GFP_WAIT, true);
+	rq = blk_mq_alloc_request(dd->queue, 0, __GFP_RECLAIM, true);
 	return blk_mq_rq_to_pdu(rq);
 }
 
diff -puN drivers/block/paride/pd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/block/paride/pd.c
@@ -723,7 +723,7 @@ static int pd_special_command(struct pd_
 	struct request *rq;
 	int err = 0;
 
-	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(disk->gd->queue, READ, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
diff -puN drivers/block/pktcdvd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/block/pktcdvd.c
@@ -704,14 +704,14 @@ static int pkt_generic_packet(struct pkt
 	int ret = 0;
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
-			     WRITE : READ, __GFP_WAIT);
+			     WRITE : READ, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	blk_rq_set_block_pc(rq);
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
-				      __GFP_WAIT);
+				      __GFP_RECLAIM);
 		if (ret)
 			goto out;
 	}
diff -puN drivers/gpu/drm/i915/i915_gem.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2216,7 +2216,7 @@ i915_gem_object_get_pages_gtt(struct drm
 	mapping = file_inode(obj->base.filp)->i_mapping;
 	gfp = mapping_gfp_mask(mapping);
 	gfp |= __GFP_NORETRY | __GFP_NOWARN;
-	gfp &= ~(__GFP_IO | __GFP_WAIT);
+	gfp &= ~(__GFP_IO | __GFP_RECLAIM);
 	sg = st->sgl;
 	st->nents = 0;
 	for (i = 0; i < page_count; i++) {
diff -puN drivers/ide/ide-atapi.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-atapi.c
--- a/drivers/ide/ide-atapi.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-atapi.c
@@ -92,7 +92,7 @@ int ide_queue_pc_tail(ide_drive_t *drive
 	struct request *rq;
 	int error;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = (char *)pc;
 
diff -puN drivers/ide/ide-cd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-cd.c
@@ -441,7 +441,7 @@ int ide_cd_queue_pc(ide_drive_t *drive,
 		struct request *rq;
 		int error;
 
-		rq = blk_get_request(drive->queue, write, __GFP_WAIT);
+		rq = blk_get_request(drive->queue, write, __GFP_RECLAIM);
 
 		memcpy(rq->cmd, cmd, BLK_MAX_CDB);
 		rq->cmd_type = REQ_TYPE_ATA_PC;
diff -puN drivers/ide/ide-cd_ioctl.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-cd_ioctl.c
--- a/drivers/ide/ide-cd_ioctl.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-cd_ioctl.c
@@ -303,7 +303,7 @@ int ide_cdrom_reset(struct cdrom_device_
 	struct request *rq;
 	int ret;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_flags = REQ_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
diff -puN drivers/ide/ide-devsets.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-devsets.c
--- a/drivers/ide/ide-devsets.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-devsets.c
@@ -165,7 +165,7 @@ int ide_devset_execute(ide_drive_t *driv
 	if (!(setting->flags & DS_SYNC))
 		return setting->set(drive, arg);
 
-	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq = blk_get_request(q, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_len = 5;
 	rq->cmd[0] = REQ_DEVSET_EXEC;
diff -puN drivers/ide/ide-disk.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-disk.c
@@ -477,7 +477,7 @@ static int set_multcount(ide_drive_t *dr
 	if (drive->special_flags & IDE_SFLAG_SET_MULTMODE)
 		return -EBUSY;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
diff -puN drivers/ide/ide-ioctls.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-ioctls.c
--- a/drivers/ide/ide-ioctls.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-ioctls.c
@@ -125,7 +125,7 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 	if (NULL == (void *) arg) {
 		struct request *rq;
 
-		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+		rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 		err = blk_execute_rq(drive->queue, NULL, rq, 0);
 		blk_put_request(rq);
@@ -221,7 +221,7 @@ static int generic_drive_reset(ide_drive
 	struct request *rq;
 	int ret = 0;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
diff -puN drivers/ide/ide-park.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-park.c
--- a/drivers/ide/ide-park.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-park.c
@@ -31,7 +31,7 @@ static void issue_park_cmd(ide_drive_t *
 	}
 	spin_unlock_irq(&hwif->lock);
 
-	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq = blk_get_request(q, READ, __GFP_RECLAIM);
 	rq->cmd[0] = REQ_PARK_HEADS;
 	rq->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
diff -puN drivers/ide/ide-pm.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-pm.c
--- a/drivers/ide/ide-pm.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-pm.c
@@ -18,7 +18,7 @@ int generic_ide_suspend(struct device *d
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_ATA_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
@@ -88,7 +88,7 @@ int generic_ide_resume(struct device *de
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_ATA_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->special = &rqpm;
diff -puN drivers/ide/ide-tape.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-tape.c
@@ -852,7 +852,7 @@ static int idetape_queue_rw_tail(ide_dri
 	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
 	BUG_ON(size < 0 || size % tape->blk_size);
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
@@ -860,7 +860,7 @@ static int idetape_queue_rw_tail(ide_dri
 
 	if (size) {
 		ret = blk_rq_map_kern(drive->queue, rq, tape->buf, size,
-				      __GFP_WAIT);
+				      __GFP_RECLAIM);
 		if (ret)
 			goto out_put;
 	}
diff -puN drivers/ide/ide-taskfile.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/ide/ide-taskfile.c
--- a/drivers/ide/ide-taskfile.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/ide/ide-taskfile.c
@@ -430,7 +430,7 @@ int ide_raw_taskfile(ide_drive_t *drive,
 	int error;
 	int rw = !(cmd->tf_flags & IDE_TFLAG_WRITE) ? READ : WRITE;
 
-	rq = blk_get_request(drive->queue, rw, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, rw, __GFP_RECLAIM);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	/*
@@ -441,7 +441,7 @@ int ide_raw_taskfile(ide_drive_t *drive,
 	 */
 	if (nsect) {
 		error = blk_rq_map_kern(drive->queue, rq, buf,
-					nsect * SECTOR_SIZE, __GFP_WAIT);
+					nsect * SECTOR_SIZE, __GFP_RECLAIM);
 		if (error)
 			goto put_req;
 	}
diff -puN drivers/infiniband/hw/qib/qib_init.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/infiniband/hw/qib/qib_init.c
--- a/drivers/infiniband/hw/qib/qib_init.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/infiniband/hw/qib/qib_init.c
@@ -1680,7 +1680,7 @@ int qib_setup_eagerbufs(struct qib_ctxtd
 	 * heavy filesystem activity makes these fail, and we can
 	 * use compound pages.
 	 */
-	gfp_flags = __GFP_WAIT | __GFP_IO | __GFP_COMP;
+	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
 
 	egrcnt = rcd->rcvegrcnt;
 	egroff = rcd->rcvegr_tid_base;
diff -puN drivers/misc/vmw_balloon.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/misc/vmw_balloon.c
@@ -75,7 +75,7 @@ MODULE_LICENSE("GPL");
 
 /*
  * Use __GFP_HIGHMEM to allow pages from HIGHMEM zone. We don't
- * allow wait (__GFP_WAIT) for NOSLEEP page allocations. Use
+ * allow wait (__GFP_RECLAIM) for NOSLEEP page allocations. Use
  * __GFP_NOWARN, to suppress page allocation failure warnings.
  */
 #define VMW_PAGE_ALLOC_NOSLEEP		(__GFP_HIGHMEM|__GFP_NOWARN)
diff -puN drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/nvme/host/pci.c
--- a/drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/nvme/host/pci.c
@@ -1025,11 +1025,13 @@ int __nvme_submit_sync_cmd(struct reques
 	req->special = (void *)0;
 
 	if (buffer && bufflen) {
-		ret = blk_rq_map_kern(q, req, buffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_kern(q, req, buffer, bufflen,
+				      __GFP_DIRECT_RECLAIM);
 		if (ret)
 			goto out;
 	} else if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
+				      __GFP_DIRECT_RECLAIM);
 		if (ret)
 			goto out;
 		bio = req->bio;
diff -puN drivers/scsi/scsi_error.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/scsi/scsi_error.c
@@ -1970,7 +1970,7 @@ static void scsi_eh_lock_door(struct scs
 	struct request *req;
 
 	/*
-	 * blk_get_request with GFP_KERNEL (__GFP_WAIT) sleeps until a
+	 * blk_get_request with GFP_KERNEL (__GFP_RECLAIM) sleeps until a
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
diff -puN drivers/scsi/scsi_lib.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/scsi/scsi_lib.c
@@ -222,13 +222,13 @@ int scsi_execute(struct scsi_device *sde
 	int write = (data_direction == DMA_TO_DEVICE);
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
 	if (IS_ERR(req))
 		return ret;
 	blk_rq_set_block_pc(req);
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
-					buffer, bufflen, __GFP_WAIT))
+					buffer, bufflen, __GFP_RECLAIM))
 		goto out;
 
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
diff -puN drivers/staging/rdma/hfi1/init.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/staging/rdma/hfi1/init.c
--- a/drivers/staging/rdma/hfi1/init.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/staging/rdma/hfi1/init.c
@@ -1560,7 +1560,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctx
 	 * heavy filesystem activity makes these fail, and we can
 	 * use compound pages.
 	 */
-	gfp_flags = __GFP_WAIT | __GFP_IO | __GFP_COMP;
+	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
 
 	/*
 	 * The minimum size of the eager buffers is a groups of MTU-sized
diff -puN drivers/staging/rdma/ipath/ipath_file_ops.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim drivers/staging/rdma/ipath/ipath_file_ops.c
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -905,7 +905,7 @@ static int ipath_create_user_egr(struct
 	 * heavy filesystem activity makes these fail, and we can
 	 * use compound pages.
 	 */
-	gfp_flags = __GFP_WAIT | __GFP_IO | __GFP_COMP;
+	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
 
 	egrcnt = dd->ipath_rcvegrcnt;
 	/* TID number offset for this port */
diff -puN fs/cachefiles/internal.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim fs/cachefiles/internal.h
--- a/fs/cachefiles/internal.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/fs/cachefiles/internal.h
@@ -30,7 +30,7 @@ extern unsigned cachefiles_debug;
 #define CACHEFILES_DEBUG_KLEAVE	2
 #define CACHEFILES_DEBUG_KDEBUG	4
 
-#define cachefiles_gfp (__GFP_WAIT | __GFP_NORETRY | __GFP_NOMEMALLOC)
+#define cachefiles_gfp (__GFP_RECLAIM | __GFP_NORETRY | __GFP_NOMEMALLOC)
 
 /*
  * node records
diff -puN fs/direct-io.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim fs/direct-io.c
--- a/fs/direct-io.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/fs/direct-io.c
@@ -361,7 +361,7 @@ dio_bio_alloc(struct dio *dio, struct di
 
 	/*
 	 * bio_alloc() is guaranteed to return a bio when called with
-	 * __GFP_WAIT and we request a valid number of vectors.
+	 * __GFP_RECLAIM and we request a valid number of vectors.
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
diff -puN fs/nilfs2/mdt.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/fs/nilfs2/mdt.h
@@ -72,7 +72,7 @@ static inline struct nilfs_mdt_info *NIL
 }
 
 /* Default GFP flags using highmem */
-#define NILFS_MDT_GFP      (__GFP_WAIT | __GFP_IO | __GFP_HIGHMEM)
+#define NILFS_MDT_GFP      (__GFP_RECLAIM | __GFP_IO | __GFP_HIGHMEM)
 
 int nilfs_mdt_get_block(struct inode *, unsigned long, int,
 			void (*init_block)(struct inode *,
diff -puN include/linux/gfp.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/include/linux/gfp.h
@@ -107,7 +107,7 @@ struct vm_area_struct;
  * can be cleared when the reclaiming of pages would cause unnecessary
  * disruption.
  */
-#define __GFP_WAIT ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
+#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
 #define __GFP_DIRECT_RECLAIM	((__force gfp_t)___GFP_DIRECT_RECLAIM) /* Caller can reclaim */
 #define __GFP_KSWAPD_RECLAIM	((__force gfp_t)___GFP_KSWAPD_RECLAIM) /* kswapd can wake */
 
@@ -126,12 +126,12 @@ struct vm_area_struct;
  */
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
-#define GFP_NOIO	(__GFP_WAIT)
-#define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
-#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
-#define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+#define GFP_NOIO	(__GFP_RECLAIM)
+#define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
+#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
+#define GFP_TEMPORARY	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | \
 			 __GFP_RECLAIMABLE)
-#define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_TRANSHUGE	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
@@ -143,12 +143,12 @@ struct vm_area_struct;
 #define GFP_MOVABLE_SHIFT 3
 
 /* Control page allocator reclaim behavior */
-#define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
+#define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
 
 /* Control slab gfp mask during early boot */
-#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))
+#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
 
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
diff -puN kernel/power/swap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim kernel/power/swap.c
--- a/kernel/power/swap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/kernel/power/swap.c
@@ -257,7 +257,7 @@ static int hib_submit_io(int rw, pgoff_t
 	struct bio *bio;
 	int error = 0;
 
-	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
+	bio = bio_alloc(__GFP_RECLAIM | __GFP_HIGH, 1);
 	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = hib_resume_bdev;
 
@@ -356,7 +356,7 @@ static int write_page(void *buf, sector_
 		return -ENOSPC;
 
 	if (hb) {
-		src = (void *)__get_free_page(__GFP_WAIT | __GFP_NOWARN |
+		src = (void *)__get_free_page(__GFP_RECLAIM | __GFP_NOWARN |
 		                              __GFP_NORETRY);
 		if (src) {
 			copy_page(src, buf);
@@ -364,7 +364,7 @@ static int write_page(void *buf, sector_
 			ret = hib_wait_io(hb); /* Free pages */
 			if (ret)
 				return ret;
-			src = (void *)__get_free_page(__GFP_WAIT |
+			src = (void *)__get_free_page(__GFP_RECLAIM |
 			                              __GFP_NOWARN |
 			                              __GFP_NORETRY);
 			if (src) {
@@ -672,7 +672,7 @@ static int save_image_lzo(struct swap_ma
 	nr_threads = num_online_cpus() - 1;
 	nr_threads = clamp_val(nr_threads, 1, LZO_THREADS);
 
-	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+	page = (void *)__get_free_page(__GFP_RECLAIM | __GFP_HIGH);
 	if (!page) {
 		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
 		ret = -ENOMEM;
@@ -975,7 +975,7 @@ static int get_swap_reader(struct swap_m
 		last = tmp;
 
 		tmp->map = (struct swap_map_page *)
-		           __get_free_page(__GFP_WAIT | __GFP_HIGH);
+			   __get_free_page(__GFP_RECLAIM | __GFP_HIGH);
 		if (!tmp->map) {
 			release_swap_reader(handle);
 			return -ENOMEM;
@@ -1242,9 +1242,9 @@ static int load_image_lzo(struct swap_ma
 
 	for (i = 0; i < read_pages; i++) {
 		page[i] = (void *)__get_free_page(i < LZO_CMP_PAGES ?
-		                                  __GFP_WAIT | __GFP_HIGH :
-		                                  __GFP_WAIT | __GFP_NOWARN |
-		                                  __GFP_NORETRY);
+						  __GFP_RECLAIM | __GFP_HIGH :
+						  __GFP_RECLAIM | __GFP_NOWARN |
+						  __GFP_NORETRY);
 
 		if (!page[i]) {
 			if (i < LZO_CMP_PAGES) {
diff -puN lib/percpu_ida.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim lib/percpu_ida.c
--- a/lib/percpu_ida.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/lib/percpu_ida.c
@@ -135,7 +135,7 @@ static inline unsigned alloc_local_tag(s
  * TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, of course).
  *
  * @gfp indicates whether or not to wait until a free id is available (it's not
- * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
+ * used for internal memory allocations); thus if passed __GFP_RECLAIM we may sleep
  * however long it takes until another thread frees an id (same semantics as a
  * mempool).
  *
diff -puN mm/failslab.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/failslab.c
--- a/mm/failslab.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/failslab.c
@@ -3,11 +3,11 @@
 
 static struct {
 	struct fault_attr attr;
-	bool ignore_gfp_wait;
+	bool ignore_gfp_reclaim;
 	bool cache_filter;
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
-	.ignore_gfp_wait = true,
+	.ignore_gfp_reclaim = true,
 	.cache_filter = false,
 };
 
@@ -16,7 +16,7 @@ bool should_failslab(size_t size, gfp_t
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
-        if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
+	if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))
 		return false;
 
 	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
@@ -42,7 +42,7 @@ static int __init failslab_debugfs_init(
 		return PTR_ERR(dir);
 
 	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				&failslab.ignore_gfp_wait))
+				&failslab.ignore_gfp_reclaim))
 		goto fail;
 	if (!debugfs_create_bool("cache-filter", mode, dir,
 				&failslab.cache_filter))
diff -puN mm/filemap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/filemap.c
--- a/mm/filemap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/filemap.c
@@ -2713,7 +2713,7 @@ EXPORT_SYMBOL(generic_file_write_iter);
  * page is known to the local caching routines.
  *
  * The @gfp_mask argument specifies whether I/O may be performed to release
- * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
+ * this page (__GFP_IO), and whether the call may block (__GFP_RECLAIM & __GFP_FS).
  *
  */
 int try_to_release_page(struct page *page, gfp_t gfp_mask)
diff -puN mm/huge_memory.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/huge_memory.c
--- a/mm/huge_memory.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/huge_memory.c
@@ -786,7 +786,7 @@ static int __do_huge_pmd_anonymous_page(
 
 static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
 {
-	return (GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT)) | extra_gfp;
+	return (GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_RECLAIM)) | extra_gfp;
 }
 
 /* Caller must hold page table lock. */
diff -puN mm/memcontrol.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/memcontrol.c
@@ -2120,7 +2120,7 @@ done_restock:
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_WAIT but let's always punt for simplicity and so that
+	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
 	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
 	 * not recorded as it most likely matches current's and won't
 	 * change in the meantime.  As high limit is checked again before
diff -puN mm/migrate.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/migrate.c
--- a/mm/migrate.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/migrate.c
@@ -1752,7 +1752,7 @@ int migrate_misplaced_transhuge_page(str
 		goto out_dropref;
 
 	new_page = alloc_pages_node(node,
-		(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_WAIT,
+		(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM,
 		HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_fail;
diff -puN mm/page_alloc.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/mm/page_alloc.c
@@ -2160,11 +2160,11 @@ static struct {
 	struct fault_attr attr;
 
 	bool ignore_gfp_highmem;
-	bool ignore_gfp_wait;
+	bool ignore_gfp_reclaim;
 	u32 min_order;
 } fail_page_alloc = {
 	.attr = FAULT_ATTR_INITIALIZER,
-	.ignore_gfp_wait = true,
+	.ignore_gfp_reclaim = true,
 	.ignore_gfp_highmem = true,
 	.min_order = 1,
 };
@@ -2183,7 +2183,8 @@ static bool should_fail_alloc_page(gfp_t
 		return false;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return false;
-	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_DIRECT_RECLAIM))
+	if (fail_page_alloc.ignore_gfp_reclaim &&
+			(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
 	return should_fail(&fail_page_alloc.attr, 1 << order);
@@ -2202,7 +2203,7 @@ static int __init fail_page_alloc_debugf
 		return PTR_ERR(dir);
 
 	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				&fail_page_alloc.ignore_gfp_wait))
+				&fail_page_alloc.ignore_gfp_reclaim))
 		goto fail;
 	if (!debugfs_create_bool("ignore-gfp-highmem", mode, dir,
 				&fail_page_alloc.ignore_gfp_highmem))
diff -puN security/integrity/ima/ima_crypto.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim security/integrity/ima/ima_crypto.c
--- a/security/integrity/ima/ima_crypto.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim
+++ a/security/integrity/ima/ima_crypto.c
@@ -126,7 +126,7 @@ static void *ima_alloc_pages(loff_t max_
 {
 	void *ptr;
 	int order = ima_maxorder;
-	gfp_t gfp_mask = __GFP_WAIT | __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t gfp_mask = __GFP_RECLAIM | __GFP_NOWARN | __GFP_NORETRY;
 
 	if (order)
 		order = min(get_order(max_size), order);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


