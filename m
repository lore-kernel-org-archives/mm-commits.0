From: akpm@osdl.org
Subject: - pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:20 -0800
Message-ID: <200612082000.kB8K0KMo001728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426208AbWLHUAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balagi@justmail.de, jens.axboe@oracle.com, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: bio write congestion using congestion_wait()
has been removed from the -mm tree.  Its filename was
     pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pktcdvd: bio write congestion using congestion_wait()
From: "Thomas Maier" <balagi@justmail.de>

This adds a bio write queue congestion control to the pktcdvd driver with
fixed on/off marks.  It prevents that the driver consumes a unlimited
amount of write requests.

[akpm@osdl.org: sync with congestion_wait() renaming]
Signed-off-by: Thomas Maier <balagi@justmail.de>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/pktcdvd.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/pktcdvd.h |    9 +++++++++
 2 files changed, 41 insertions(+)

diff -puN drivers/block/pktcdvd.c~pktcdvd-bio-write-congestion-using-blk_congestion_wait drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-bio-write-congestion-using-blk_congestion_wait
+++ a/drivers/block/pktcdvd.c
@@ -84,6 +84,8 @@
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
 static int pktdev_major;
+static int write_congestion_on  = PKT_WRITE_CONGESTION_ON;
+static int write_congestion_off = PKT_WRITE_CONGESTION_OFF;
 static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
 static mempool_t *psd_pool;
 
@@ -894,6 +896,7 @@ static int pkt_handle_queue(struct pktcd
 	sector_t zone = 0; /* Suppress gcc warning */
 	struct pkt_rb_node *node, *first_node;
 	struct rb_node *n;
+	int wakeup;
 
 	VPRINTK("handle_queue\n");
 
@@ -966,7 +969,13 @@ try_next_bio:
 		pkt->write_size += bio->bi_size / CD_FRAMESIZE;
 		spin_unlock(&pkt->lock);
 	}
+	/* check write congestion marks, and if bio_queue_size is
+	   below, wake up any waiters */
+	wakeup = (pd->write_congestion_on > 0
+	 		&& pd->bio_queue_size <= pd->write_congestion_off);
 	spin_unlock(&pd->lock);
+	if (wakeup)
+		blk_clear_queue_congested(pd->disk->queue, WRITE);
 
 	pkt->sleep_time = max(PACKET_WAIT_TIME, 1);
 	pkt_set_state(pkt, PACKET_WAITING_STATE);
@@ -2179,6 +2188,23 @@ static int pkt_make_request(request_queu
 	}
 	spin_unlock(&pd->cdrw.active_list_lock);
 
+ 	/*
+	 * Test if there is enough room left in the bio work queue
+	 * (queue size >= congestion on mark).
+	 * If not, wait till the work queue size is below the congestion off mark.
+	 */
+	spin_lock(&pd->lock);
+	if (pd->write_congestion_on > 0
+	    && pd->bio_queue_size >= pd->write_congestion_on) {
+		blk_set_queue_congested(q, WRITE);
+		do {
+			spin_unlock(&pd->lock);
+			congestion_wait(WRITE, HZ);
+			spin_lock(&pd->lock);
+		} while(pd->bio_queue_size > pd->write_congestion_off);
+	}
+	spin_unlock(&pd->lock);
+
 	/*
 	 * No matching packet found. Store the bio in the work queue.
 	 */
@@ -2298,6 +2324,9 @@ static int pkt_seq_show(struct seq_file 
 	seq_printf(m, "\tstate:\t\t\ti:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
 		   states[0], states[1], states[2], states[3], states[4], states[5]);
 
+	seq_printf(m, "\twrite congestion marks:\toff=%d on=%d\n",
+			pd->write_congestion_off,
+			pd->write_congestion_on);
 	return 0;
 }
 
@@ -2474,6 +2503,9 @@ static int pkt_setup_dev(dev_t dev, dev_
 	init_waitqueue_head(&pd->wqueue);
 	pd->bio_queue = RB_ROOT;
 
+	pd->write_congestion_on  = write_congestion_on;
+	pd->write_congestion_off = write_congestion_off;
+
 	disk = alloc_disk(1);
 	if (!disk)
 		goto out_mem;
diff -puN include/linux/pktcdvd.h~pktcdvd-bio-write-congestion-using-blk_congestion_wait include/linux/pktcdvd.h
--- a/include/linux/pktcdvd.h~pktcdvd-bio-write-congestion-using-blk_congestion_wait
+++ a/include/linux/pktcdvd.h
@@ -112,6 +112,12 @@ struct pkt_ctrl_command {
 #include <linux/completion.h>
 #include <linux/cdrom.h>
 
+
+/* default bio write queue congestion marks */
+#define PKT_WRITE_CONGESTION_ON    10000
+#define PKT_WRITE_CONGESTION_OFF   9000
+
+
 struct packet_settings
 {
 	__u32			size;		/* packet size in (512 byte) sectors */
@@ -271,6 +277,9 @@ struct pktcdvd_device
 
 	struct packet_iosched   iosched;
 	struct gendisk		*disk;
+
+	int			write_congestion_off;
+	int			write_congestion_on;
 };
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from balagi@justmail.de are

origin.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
pktcdvd-add-sysfs-and-debugfs-interface.patch

