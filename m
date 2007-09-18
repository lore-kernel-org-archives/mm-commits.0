From: akpm@linux-foundation.org
Subject: - scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch removed from -mm tree
Date: Tue, 18 Sep 2007 11:46:16 -0700
Message-ID: <200709181846.l8IIkGX7017999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbXIRSrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 14:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ed.lin@promise.com, James.Bottomley@steeleye.com, jeff@garzik.org, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     scsi: use lock per host instead of per device for shared queue tag host
has been removed from the -mm tree.  Its filename was
     scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: scsi: use lock per host instead of per device for shared queue tag host
From: "Ed Lin" <ed.lin@promise.com>

The block layer uses lock to protect request queue.  Every scsi device has
a unique request queue, and queue lock is the default lock in struct
request_queue.  This is good for normal cases.  But for a host with shared
queue tag (e.g.  stex controllers), a queue lock per device means the
shared queue tag is not protected when multiple devices are accessed at a
same time.  This patch is a simple fix for this situation by introducing a
host queue lock to protect shared queue tag.  Without this patch we will
see various kernel panics (including the BUG() and kernel errors in
blk_queue_start_tag and blk_queue_end_tag of ll_rw_blk.c) when accessing
another in smp kernels).

Signed-off-by: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c  |    2 +-
 drivers/scsi/stex.c      |    2 ++
 include/scsi/scsi_host.h |    3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/drivers/scsi/scsi_lib.c
@@ -1665,7 +1665,7 @@ struct request_queue *__scsi_alloc_queue
 {
 	struct request_queue *q;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue(request_fn, shost->req_q_lock);
 	if (!q)
 		return NULL;
 
diff -puN drivers/scsi/stex.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host drivers/scsi/stex.c
--- a/drivers/scsi/stex.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/drivers/scsi/stex.c
@@ -1235,6 +1235,8 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
+	spin_lock_init(&host->__req_q_lock);
+	host->req_q_lock = &host->__req_q_lock;
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
diff -puN include/scsi/scsi_host.h~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/include/scsi/scsi_host.h
@@ -523,6 +523,9 @@ struct Scsi_Host {
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
+	spinlock_t		__req_q_lock;
+	spinlock_t		*req_q_lock;/* protect shared block queue tag */
+
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
 	struct list_head	eh_cmd_q;
_

Patches currently in -mm which might be from ed.lin@promise.com are

scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch
