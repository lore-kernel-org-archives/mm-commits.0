From: akpm@linux-foundation.org
Subject: - memstick-use-fully-asynchronous-request-processing.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:04 -0700
Message-ID: <200807262114.m6QLE4JK019664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757521AbYGZVOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: use fully asynchronous request processing
has been removed from the -mm tree.  Its filename was
     memstick-use-fully-asynchronous-request-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: use fully asynchronous request processing
From: Alex Dubov <oakad@yahoo.com>

Instead of using a separate thread to pump requests from block layer queue
to memstick, do so inline, utilizing the callback design of the memstick.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |    7 
 drivers/memstick/core/mspro_block.c |  340 ++++++++++++--------------
 drivers/memstick/host/jmb38x_ms.c   |   35 +-
 drivers/memstick/host/tifm_ms.c     |   49 ++-
 4 files changed, 216 insertions(+), 215 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-use-fully-asynchronous-request-processing drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-use-fully-asynchronous-request-processing
+++ a/drivers/memstick/core/memstick.c
@@ -249,8 +249,11 @@ EXPORT_SYMBOL(memstick_next_req);
  */
 void memstick_new_req(struct memstick_host *host)
 {
-	host->retries = cmd_retries;
-	host->request(host);
+	if (host->card) {
+		host->retries = cmd_retries;
+		INIT_COMPLETION(host->card->mrq_complete);
+		host->request(host);
+	}
 }
 EXPORT_SYMBOL(memstick_new_req);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-use-fully-asynchronous-request-processing drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-use-fully-asynchronous-request-processing
+++ a/drivers/memstick/core/mspro_block.c
@@ -136,9 +136,8 @@ struct mspro_block_data {
 	unsigned int          caps;
 	struct gendisk        *disk;
 	struct request_queue  *queue;
+	struct request        *block_req;
 	spinlock_t            q_lock;
-	wait_queue_head_t     q_wait;
-	struct task_struct    *q_thread;
 
 	unsigned short        page_size;
 	unsigned short        cylinders;
@@ -147,9 +146,10 @@ struct mspro_block_data {
 
 	unsigned char         system;
 	unsigned char         read_only:1,
-			      active:1,
+			      eject:1,
 			      has_request:1,
-			      data_dir:1;
+			      data_dir:1,
+			      active:1;
 	unsigned char         transfer_cmd;
 
 	int                   (*mrq_handler)(struct memstick_dev *card,
@@ -160,12 +160,14 @@ struct mspro_block_data {
 	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
 	unsigned int          seg_count;
 	unsigned int          current_seg;
-	unsigned short        current_page;
+	unsigned int          current_page;
 };
 
 static DEFINE_IDR(mspro_block_disk_idr);
 static DEFINE_MUTEX(mspro_block_disk_lock);
 
+static int mspro_block_complete_req(struct memstick_dev *card, int error);
+
 /*** Block device ***/
 
 static int mspro_block_bd_open(struct inode *inode, struct file *filp)
@@ -197,8 +199,10 @@ static int mspro_block_disk_release(stru
 
 	mutex_lock(&mspro_block_disk_lock);
 
-	if (msb->usage_count) {
-		msb->usage_count--;
+	if (msb) {
+		if (msb->usage_count)
+			msb->usage_count--;
+
 		if (!msb->usage_count) {
 			kfree(msb);
 			disk->private_data = NULL;
@@ -523,11 +527,13 @@ static int h_mspro_block_req_init(struct
 static int h_mspro_block_default(struct memstick_dev *card,
 				 struct memstick_request **mrq)
 {
-	complete(&card->mrq_complete);
-	if (!(*mrq)->error)
-		return -EAGAIN;
-	else
-		return (*mrq)->error;
+	return mspro_block_complete_req(card, (*mrq)->error);
+}
+
+static int h_mspro_block_default_bad(struct memstick_dev *card,
+				     struct memstick_request **mrq)
+{
+	return -ENXIO;
 }
 
 static int h_mspro_block_get_ro(struct memstick_dev *card,
@@ -535,44 +541,30 @@ static int h_mspro_block_get_ro(struct m
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 
-	if ((*mrq)->error) {
-		complete(&card->mrq_complete);
-		return (*mrq)->error;
+	if (!(*mrq)->error) {
+		if ((*mrq)->data[offsetof(struct ms_status_register, status0)]
+		    & MEMSTICK_STATUS0_WP)
+			msb->read_only = 1;
+		else
+			msb->read_only = 0;
 	}
 
-	if ((*mrq)->data[offsetof(struct ms_status_register, status0)]
-	    & MEMSTICK_STATUS0_WP)
-		msb->read_only = 1;
-	else
-		msb->read_only = 0;
-
-	complete(&card->mrq_complete);
-	return -EAGAIN;
+	return mspro_block_complete_req(card, (*mrq)->error);
 }
 
 static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
 				      struct memstick_request **mrq)
 {
-	if ((*mrq)->error) {
-		complete(&card->mrq_complete);
-		return (*mrq)->error;
-	}
-
 	dev_dbg(&card->dev, "wait for ced: value %x\n", (*mrq)->data[0]);
 
-	if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
-		card->current_mrq.error = -EFAULT;
-		complete(&card->mrq_complete);
-		return card->current_mrq.error;
+	if (!(*mrq)->error) {
+		if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR))
+			(*mrq)->error = -EFAULT;
+		else if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
+			return 0;
 	}
 
-	if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
-		return 0;
-	else {
-		card->current_mrq.error = 0;
-		complete(&card->mrq_complete);
-		return -EAGAIN;
-	}
+	return mspro_block_complete_req(card, (*mrq)->error);
 }
 
 static int h_mspro_block_transfer_data(struct memstick_dev *card,
@@ -583,10 +575,8 @@ static int h_mspro_block_transfer_data(s
 	struct scatterlist t_sg = { 0 };
 	size_t t_offset;
 
-	if ((*mrq)->error) {
-		complete(&card->mrq_complete);
-		return (*mrq)->error;
-	}
+	if ((*mrq)->error)
+		return mspro_block_complete_req(card, (*mrq)->error);
 
 	switch ((*mrq)->tpc) {
 	case MS_TPC_WRITE_REG:
@@ -617,8 +607,8 @@ has_int_reg:
 
 			if (msb->current_seg == msb->seg_count) {
 				if (t_val & MEMSTICK_INT_CED) {
-					complete(&card->mrq_complete);
-					return -EAGAIN;
+					return mspro_block_complete_req(card,
+									0);
 				} else {
 					card->next_request
 						= h_mspro_block_wait_for_ced;
@@ -666,90 +656,120 @@ has_int_reg:
 
 /*** Data transfer ***/
 
-static void mspro_block_process_request(struct memstick_dev *card,
-					struct request *req)
+static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param;
-	int rc, chunk, cnt;
-	unsigned short page_count;
 	sector_t t_sec;
-	unsigned long flags;
+	unsigned int count;
+	struct mspro_param_register param;
 
-	do {
-		page_count = 0;
+try_again:
+	while (chunk) {
+		msb->current_page = 0;
 		msb->current_seg = 0;
-		msb->seg_count = blk_rq_map_sg(req->q, req, msb->req_sg);
+		msb->seg_count = blk_rq_map_sg(msb->block_req->q,
+					       msb->block_req,
+					       msb->req_sg);
+
+		if (!msb->seg_count) {
+			chunk = __blk_end_request(msb->block_req, -ENOMEM,
+					blk_rq_cur_bytes(msb->block_req));
+			continue;
+		}
 
-		if (msb->seg_count) {
-			msb->current_page = 0;
-			for (rc = 0; rc < msb->seg_count; rc++)
-				page_count += msb->req_sg[rc].length
-					      / msb->page_size;
-
-			t_sec = req->sector;
-			sector_div(t_sec, msb->page_size >> 9);
-			param.system = msb->system;
-			param.data_count = cpu_to_be16(page_count);
-			param.data_address = cpu_to_be32((uint32_t)t_sec);
-			param.tpc_param = 0;
-
-			msb->data_dir = rq_data_dir(req);
-			msb->transfer_cmd = msb->data_dir == READ
-					    ? MSPRO_CMD_READ_DATA
-					    : MSPRO_CMD_WRITE_DATA;
-
-			dev_dbg(&card->dev, "data transfer: cmd %x, "
-				"lba %x, count %x\n", msb->transfer_cmd,
-				be32_to_cpu(param.data_address),
-				page_count);
-
-			card->next_request = h_mspro_block_req_init;
-			msb->mrq_handler = h_mspro_block_transfer_data;
-			memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-					  &param, sizeof(param));
-			memstick_new_req(card->host);
-			wait_for_completion(&card->mrq_complete);
-			rc = card->current_mrq.error;
+		t_sec = msb->block_req->sector << 9;
+		sector_div(t_sec, msb->page_size);
 
-			if (rc || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
-				for (cnt = 0; cnt < msb->current_seg; cnt++)
-					page_count += msb->req_sg[cnt].length
-						      / msb->page_size;
+		count = msb->block_req->nr_sectors << 9;
+		count /= msb->page_size;
 
-				if (msb->current_page)
-					page_count += msb->current_page - 1;
+		param.system = msb->system;
+		param.data_count = cpu_to_be16(count);
+		param.data_address = cpu_to_be32((uint32_t)t_sec);
+		param.tpc_param = 0;
 
-				if (page_count && (msb->data_dir == READ))
-					rc = msb->page_size * page_count;
-				else
-					rc = -EIO;
-			} else
-				rc = msb->page_size * page_count;
-		} else
-			rc = -EFAULT;
+		msb->data_dir = rq_data_dir(msb->block_req);
+		msb->transfer_cmd = msb->data_dir == READ
+				    ? MSPRO_CMD_READ_DATA
+				    : MSPRO_CMD_WRITE_DATA;
+
+		dev_dbg(&card->dev, "data transfer: cmd %x, "
+			"lba %x, count %x\n", msb->transfer_cmd,
+			be32_to_cpu(param.data_address), count);
 
-		spin_lock_irqsave(&msb->q_lock, flags);
-		if (rc >= 0)
-			chunk = __blk_end_request(req, 0, rc);
-		else
-			chunk = __blk_end_request(req, rc, 0);
+		card->next_request = h_mspro_block_req_init;
+		msb->mrq_handler = h_mspro_block_transfer_data;
+		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
+				  &param, sizeof(param));
+		memstick_new_req(card->host);
+		return 0;
+	}
 
-		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
-		spin_unlock_irqrestore(&msb->q_lock, flags);
-	} while (chunk);
+	dev_dbg(&card->dev, "elv_next\n");
+	msb->block_req = elv_next_request(msb->queue);
+	if (!msb->block_req) {
+		dev_dbg(&card->dev, "issue end\n");
+		return -EAGAIN;
+	}
+
+	dev_dbg(&card->dev, "trying again\n");
+	chunk = 1;
+	goto try_again;
 }
 
-static int mspro_block_has_request(struct mspro_block_data *msb)
+static int mspro_block_complete_req(struct memstick_dev *card, int error)
 {
-	int rc = 0;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int chunk, cnt;
+	unsigned int t_len = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&msb->q_lock, flags);
-	if (kthread_should_stop() || msb->has_request)
-		rc = 1;
+	dev_dbg(&card->dev, "complete %d, %d\n", msb->has_request ? 1 : 0,
+		error);
+
+	if (msb->has_request) {
+		/* Nothing to do - not really an error */
+		if (error == -EAGAIN)
+			error = 0;
+
+		if (error || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
+			if (msb->data_dir == READ) {
+				for (cnt = 0; cnt < msb->current_seg; cnt++)
+					t_len += msb->req_sg[cnt].length
+						 / msb->page_size;
+
+					if (msb->current_page)
+						t_len += msb->current_page - 1;
+
+					t_len *= msb->page_size;
+			}
+		} else
+			t_len = msb->block_req->nr_sectors << 9;
+
+		dev_dbg(&card->dev, "transferred %x (%d)\n", t_len, error);
+
+		if (error && !t_len)
+			t_len = blk_rq_cur_bytes(msb->block_req);
+
+		chunk = __blk_end_request(msb->block_req, error, t_len);
+
+		error = mspro_block_issue_req(card, chunk);
+
+		if (!error)
+			goto out;
+		else
+			msb->has_request = 0;
+	} else {
+		if (!error)
+			error = -EAGAIN;
+	}
+
+	card->next_request = h_mspro_block_default_bad;
+	complete_all(&card->mrq_complete);
+out:
 	spin_unlock_irqrestore(&msb->q_lock, flags);
-	return rc;
+	return error;
 }
 
 static void mspro_block_stop(struct memstick_dev *card)
@@ -783,54 +803,37 @@ static void mspro_block_start(struct mem
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 }
 
-static int mspro_block_queue_thread(void *data)
+static int mspro_block_prepare_req(struct request_queue *q, struct request *req)
 {
-	struct memstick_dev *card = data;
-	struct memstick_host *host = card->host;
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct request *req;
-	unsigned long flags;
-
-	while (1) {
-		wait_event(msb->q_wait, mspro_block_has_request(msb));
-		dev_dbg(&card->dev, "thread iter\n");
+	if (!blk_fs_request(req) && !blk_pc_request(req)) {
+		blk_dump_rq_flags(req, "MSPro unsupported request");
+		return BLKPREP_KILL;
+	}
 
-		spin_lock_irqsave(&msb->q_lock, flags);
-		req = elv_next_request(msb->queue);
-		dev_dbg(&card->dev, "next req %p\n", req);
-		if (!req) {
-			msb->has_request = 0;
-			if (kthread_should_stop()) {
-				spin_unlock_irqrestore(&msb->q_lock, flags);
-				break;
-			}
-		} else
-			msb->has_request = 1;
-		spin_unlock_irqrestore(&msb->q_lock, flags);
+	req->cmd_flags |= REQ_DONTPREP;
 
-		if (req) {
-			mutex_lock(&host->lock);
-			mspro_block_process_request(card, req);
-			mutex_unlock(&host->lock);
-		}
-	}
-	dev_dbg(&card->dev, "thread finished\n");
-	return 0;
+	return BLKPREP_OK;
 }
 
-static void mspro_block_request(struct request_queue *q)
+static void mspro_block_submit_req(struct request_queue *q)
 {
 	struct memstick_dev *card = q->queuedata;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct request *req = NULL;
 
-	if (msb->q_thread) {
-		msb->has_request = 1;
-		wake_up_all(&msb->q_wait);
-	} else {
+	if (msb->has_request)
+		return;
+
+	if (msb->eject) {
 		while ((req = elv_next_request(q)) != NULL)
 			end_queued_request(req, -ENODEV);
+
+		return;
 	}
+
+	msb->has_request = 1;
+	if (mspro_block_issue_req(card, 0))
+		msb->has_request = 0;
 }
 
 /*** Initialization ***/
@@ -1200,16 +1203,14 @@ static int mspro_block_init_disk(struct 
 		goto out_release_id;
 	}
 
-	spin_lock_init(&msb->q_lock);
-	init_waitqueue_head(&msb->q_wait);
-
-	msb->queue = blk_init_queue(mspro_block_request, &msb->q_lock);
+	msb->queue = blk_init_queue(mspro_block_submit_req, &msb->q_lock);
 	if (!msb->queue) {
 		rc = -ENOMEM;
 		goto out_put_disk;
 	}
 
 	msb->queue->queuedata = card;
+	blk_queue_prep_rq(msb->queue, mspro_block_prepare_req);
 
 	blk_queue_bounce_limit(msb->queue, limit);
 	blk_queue_max_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
@@ -1235,14 +1236,8 @@ static int mspro_block_init_disk(struct 
 	capacity *= msb->page_size >> 9;
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
-	msb->q_thread = kthread_run(mspro_block_queue_thread, card,
-				    DRIVER_NAME"d");
-	if (IS_ERR(msb->q_thread))
-		goto out_put_disk;
 
-	mutex_unlock(&host->lock);
 	add_disk(msb->disk);
-	mutex_lock(&host->lock);
 	msb->active = 1;
 	return 0;
 
@@ -1290,6 +1285,7 @@ static int mspro_block_probe(struct mems
 		return -ENOMEM;
 	memstick_set_drvdata(card, msb);
 	msb->card = card;
+	spin_lock_init(&msb->q_lock);
 
 	rc = mspro_block_init_card(card);
 
@@ -1319,26 +1315,17 @@ out_free:
 static void mspro_block_remove(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct task_struct *q_thread = NULL;
 	unsigned long flags;
 
 	del_gendisk(msb->disk);
 	dev_dbg(&card->dev, "mspro block remove\n");
 	spin_lock_irqsave(&msb->q_lock, flags);
-	q_thread = msb->q_thread;
-	msb->q_thread = NULL;
-	msb->active = 0;
+	msb->eject = 1;
+	blk_start_queue(msb->queue);
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
-	if (q_thread) {
-		mutex_unlock(&card->host->lock);
-		kthread_stop(q_thread);
-		mutex_lock(&card->host->lock);
-	}
-
-	dev_dbg(&card->dev, "queue thread stopped\n");
-
 	blk_cleanup_queue(msb->queue);
+	msb->queue = NULL;
 
 	sysfs_remove_group(&card->dev.kobj, &msb->attr_group);
 
@@ -1355,19 +1342,13 @@ static void mspro_block_remove(struct me
 static int mspro_block_suspend(struct memstick_dev *card, pm_message_t state)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct task_struct *q_thread = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&msb->q_lock, flags);
-	q_thread = msb->q_thread;
-	msb->q_thread = NULL;
-	msb->active = 0;
 	blk_stop_queue(msb->queue);
+	msb->active = 0;
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
-	if (q_thread)
-		kthread_stop(q_thread);
-
 	return 0;
 }
 
@@ -1406,14 +1387,7 @@ static int mspro_block_resume(struct mem
 			if (memcmp(s_attr->data, r_attr->data, s_attr->size))
 				break;
 
-			memstick_set_drvdata(card, msb);
-			msb->q_thread = kthread_run(mspro_block_queue_thread,
-						    card, DRIVER_NAME"d");
-			if (IS_ERR(msb->q_thread))
-				msb->q_thread = NULL;
-			else
-				msb->active = 1;
-
+			msb->active = 1;
 			break;
 		}
 	}
diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-use-fully-asynchronous-request-processing drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-use-fully-asynchronous-request-processing
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -50,6 +50,7 @@ struct jmb38x_ms_host {
 	struct jmb38x_ms        *chip;
 	void __iomem            *addr;
 	spinlock_t              lock;
+	struct tasklet_struct   notify;
 	int                     id;
 	char                    host_id[32];
 	int                     irq;
@@ -590,25 +591,35 @@ static void jmb38x_ms_abort(unsigned lon
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_request(struct memstick_host *msh)
+static void jmb38x_ms_req_tasklet(unsigned long data)
 {
+	struct memstick_host *msh = (struct memstick_host *)data;
 	struct jmb38x_ms_host *host = memstick_priv(msh);
 	unsigned long flags;
 	int rc;
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (host->req) {
-		spin_unlock_irqrestore(&host->lock, flags);
-		BUG();
-		return;
+	if (!host->req) {
+		do {
+			rc = memstick_next_req(msh, &host->req);
+			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
+		} while (!rc && jmb38x_ms_issue_cmd(msh));
 	}
-
-	do {
-		rc = memstick_next_req(msh, &host->req);
-	} while (!rc && jmb38x_ms_issue_cmd(msh));
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
+static void jmb38x_ms_dummy_submit(struct memstick_host *msh)
+{
+	return;
+}
+
+static void jmb38x_ms_submit_req(struct memstick_host *msh)
+{
+	struct jmb38x_ms_host *host = memstick_priv(msh);
+
+	tasklet_schedule(&host->notify);
+}
+
 static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
 {
 	int cnt;
@@ -816,7 +827,9 @@ static struct memstick_host *jmb38x_ms_a
 		 host->id);
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
-	msh->request = jmb38x_ms_request;
+
+	tasklet_init(&host->notify, jmb38x_ms_req_tasklet, (unsigned long)msh);
+	msh->request = jmb38x_ms_submit_req;
 	msh->set_param = jmb38x_ms_set_param;
 
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
@@ -928,6 +941,8 @@ static void jmb38x_ms_remove(struct pci_
 
 		host = memstick_priv(jm->hosts[cnt]);
 
+		jm->hosts[cnt]->request = jmb38x_ms_dummy_submit;
+		tasklet_kill(&host->notify);
 		writel(0, host->addr + INT_SIGNAL_ENABLE);
 		writel(0, host->addr + INT_STATUS_ENABLE);
 		mmiowb();
diff -puN drivers/memstick/host/tifm_ms.c~memstick-use-fully-asynchronous-request-processing drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~memstick-use-fully-asynchronous-request-processing
+++ a/drivers/memstick/host/tifm_ms.c
@@ -71,6 +71,7 @@ struct tifm_ms {
 	struct tifm_dev         *dev;
 	struct timer_list       timer;
 	struct memstick_request *req;
+	struct tasklet_struct   notify;
 	unsigned int            mode_mask;
 	unsigned int            block_pos;
 	unsigned long           timeout_jiffies;
@@ -455,40 +456,45 @@ static void tifm_ms_card_event(struct ti
 	return;
 }
 
-static void tifm_ms_request(struct memstick_host *msh)
+static void tifm_ms_req_tasklet(unsigned long data)
 {
+	struct memstick_host *msh = (struct memstick_host *)data;
 	struct tifm_ms *host = memstick_priv(msh);
 	struct tifm_dev *sock = host->dev;
 	unsigned long flags;
 	int rc;
 
 	spin_lock_irqsave(&sock->lock, flags);
-	if (host->req) {
-		printk(KERN_ERR "%s : unfinished request detected\n",
-		       sock->dev.bus_id);
-		spin_unlock_irqrestore(&sock->lock, flags);
-		tifm_eject(host->dev);
-		return;
-	}
+	if (!host->req) {
+		if (host->eject) {
+			do {
+				rc = memstick_next_req(msh, &host->req);
+				if (!rc)
+					host->req->error = -ETIME;
+			} while (!rc);
+			spin_unlock_irqrestore(&sock->lock, flags);
+			return;
+		}
 
-	if (host->eject) {
 		do {
 			rc = memstick_next_req(msh, &host->req);
-			if (!rc)
-				host->req->error = -ETIME;
-		} while (!rc);
-		spin_unlock_irqrestore(&sock->lock, flags);
-		return;
+		} while (!rc && tifm_ms_issue_cmd(host));
 	}
-
-	do {
-		rc = memstick_next_req(msh, &host->req);
-	} while (!rc && tifm_ms_issue_cmd(host));
-
 	spin_unlock_irqrestore(&sock->lock, flags);
+}
+
+static void tifm_ms_dummy_submit(struct memstick_host *msh)
+{
 	return;
 }
 
+static void tifm_ms_submit_req(struct memstick_host *msh)
+{
+	struct tifm_ms *host = memstick_priv(msh);
+
+	tasklet_schedule(&host->notify);
+}
+
 static int tifm_ms_set_param(struct memstick_host *msh,
 			     enum memstick_param param,
 			     int value)
@@ -569,8 +575,9 @@ static int tifm_ms_probe(struct tifm_dev
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
 	setup_timer(&host->timer, tifm_ms_abort, (unsigned long)host);
+	tasklet_init(&host->notify, tifm_ms_req_tasklet, (unsigned long)msh);
 
-	msh->request = tifm_ms_request;
+	msh->request = tifm_ms_submit_req;
 	msh->set_param = tifm_ms_set_param;
 	sock->card_event = tifm_ms_card_event;
 	sock->data_event = tifm_ms_data_event;
@@ -592,6 +599,8 @@ static void tifm_ms_remove(struct tifm_d
 	int rc = 0;
 	unsigned long flags;
 
+	msh->request = tifm_ms_dummy_submit;
+	tasklet_kill(&host->notify);
 	spin_lock_irqsave(&sock->lock, flags);
 	host->eject = 1;
 	if (host->req) {
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch

