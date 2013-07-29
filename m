From: akpm@linux-foundation.org
Subject: + pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:27 -0700
Message-ID: <51f6f393.4GblCDRQTI5cnElL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3G2W62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:27 -0700


The patch titled
     Subject: pktcdvd: add struct pktcdvd_device * to pkt_dbg
has been added to the -mm tree.  Its filename is
     pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: pktcdvd: add struct pktcdvd_device * to pkt_dbg

Add pd->name to output for these debugging messages.

Remove normally compiled out pkt_dbg(2, ...) function entry tracing
equivalents as it's better done via the function tracer.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   90 +++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg
+++ a/drivers/block/pktcdvd.c
@@ -71,12 +71,13 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
-#define pkt_dbg(level, fmt, ...)				\
-do {								\
-	if (level == 2 && PACKET_DEBUG >= 2)			\
-		pr_notice("%s: " fmt, __func__, ##__VA_ARGS__);	\
-	else if (level == 1 && PACKET_DEBUG >= 1)		\
-		pr_notice(fmt, ##__VA_ARGS__);			\
+#define pkt_dbg(level, pd, fmt, ...)					\
+do {									\
+	if (level == 2 && PACKET_DEBUG >= 2)				\
+		pr_notice("%s: %s():" fmt,				\
+			  pd->name, __func__, ##__VA_ARGS__);		\
+	else if (level == 1 && PACKET_DEBUG >= 1)			\
+		pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__);		\
 } while (0)
 
 #define MAX_SPEED 0xffff
@@ -515,7 +516,7 @@ static void pkt_bio_finished(struct pktc
 {
 	BUG_ON(atomic_read(&pd->cdrw.pending_bios) <= 0);
 	if (atomic_dec_and_test(&pd->cdrw.pending_bios)) {
-		pkt_dbg(2, "queue empty\n");
+		pkt_dbg(2, pd, "queue empty\n");
 		atomic_set(&pd->iosched.attention, 1);
 		wake_up(&pd->wqueue);
 	}
@@ -866,7 +867,7 @@ static void pkt_iosched_process_queue(st
 				need_write_seek = 0;
 			if (need_write_seek && reads_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					pkt_dbg(2, "write, waiting\n");
+					pkt_dbg(2, pd, "write, waiting\n");
 					break;
 				}
 				pkt_flush_cache(pd);
@@ -875,7 +876,7 @@ static void pkt_iosched_process_queue(st
 		} else {
 			if (!reads_queued && writes_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					pkt_dbg(2, "read, waiting\n");
+					pkt_dbg(2, pd, "read, waiting\n");
 					break;
 				}
 				pd->iosched.writing = 1;
@@ -981,7 +982,7 @@ static void pkt_end_io_read(struct bio *
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	pkt_dbg(2, "bio=%p sec0=%llx sec=%llx err=%d\n",
+	pkt_dbg(2, pd, "bio=%p sec0=%llx sec=%llx err=%d\n",
 		bio, (unsigned long long)pkt->sector,
 		(unsigned long long)bio->bi_sector, err);
 
@@ -1000,7 +1001,7 @@ static void pkt_end_io_packet_write(stru
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	pkt_dbg(2, "id=%d, err=%d\n", pkt->id, err);
+	pkt_dbg(2, pd, "id=%d, err=%d\n", pkt->id, err);
 
 	pd->stats.pkt_ended++;
 
@@ -1042,7 +1043,7 @@ static void pkt_gather_data(struct pktcd
 	spin_unlock(&pkt->lock);
 
 	if (pkt->cache_valid) {
-		pkt_dbg(2, "zone %llx cached\n",
+		pkt_dbg(2, pd, "zone %llx cached\n",
 			(unsigned long long)pkt->sector);
 		goto out_account;
 	}
@@ -1065,7 +1066,7 @@ static void pkt_gather_data(struct pktcd
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
-		pkt_dbg(2, "Adding frame %d, page:%p offs:%d\n",
+		pkt_dbg(2, pd, "Adding frame %d, page:%p offs:%d\n",
 			f, pkt->pages[p], offset);
 		if (!bio_add_page(bio, pkt->pages[p], CD_FRAMESIZE, offset))
 			BUG();
@@ -1077,7 +1078,7 @@ static void pkt_gather_data(struct pktcd
 	}
 
 out_account:
-	pkt_dbg(2, "need %d frames for zone %llx\n",
+	pkt_dbg(2, pd, "need %d frames for zone %llx\n",
 		frames_read, (unsigned long long)pkt->sector);
 	pd->stats.pkt_started++;
 	pd->stats.secs_rg += frames_read * (CD_FRAMESIZE >> 9);
@@ -1178,7 +1179,7 @@ static inline void pkt_set_state(struct
 		"IDLE", "WAITING", "READ_WAIT", "WRITE_WAIT", "RECOVERY", "FINISHED"
 	};
 	enum packet_data_state old_state = pkt->state;
-	pkt_dbg(2, "pkt %2d : s=%6llx %s -> %s\n",
+	pkt_dbg(2, pd, "pkt %2d : s=%6llx %s -> %s\n",
 		pkt->id, (unsigned long long)pkt->sector,
 		state_name[old_state], state_name[state]);
 #endif
@@ -1198,12 +1199,10 @@ static int pkt_handle_queue(struct pktcd
 	struct rb_node *n;
 	int wakeup;
 
-	pkt_dbg(2, "\n");
-
 	atomic_set(&pd->scan_queue, 0);
 
 	if (list_empty(&pd->cdrw.pkt_free_list)) {
-		pkt_dbg(2, "no pkt\n");
+		pkt_dbg(2, pd, "no pkt\n");
 		return 0;
 	}
 
@@ -1240,7 +1239,7 @@ try_next_bio:
 	}
 	spin_unlock(&pd->lock);
 	if (!bio) {
-		pkt_dbg(2, "no bio\n");
+		pkt_dbg(2, pd, "no bio\n");
 		return 0;
 	}
 
@@ -1256,10 +1255,10 @@ try_next_bio:
 	 * to this packet.
 	 */
 	spin_lock(&pd->lock);
-	pkt_dbg(2, "looking for zone %llx\n", (unsigned long long)zone);
+	pkt_dbg(2, pd, "looking for zone %llx\n", (unsigned long long)zone);
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
-		pkt_dbg(2, "found zone=%llx\n",
+		pkt_dbg(2, pd, "found zone=%llx\n",
 			(unsigned long long)get_zone(bio->bi_sector, pd));
 		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
@@ -1312,7 +1311,7 @@ static void pkt_start_write(struct pktcd
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
 	}
-	pkt_dbg(2, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
+	pkt_dbg(2, pd, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
 
 	/*
 	 * Fill-in bvec with data from orig_bios.
@@ -1323,7 +1322,7 @@ static void pkt_start_write(struct pktcd
 	pkt_set_state(pkt, PACKET_WRITE_WAIT_STATE);
 	spin_unlock(&pkt->lock);
 
-	pkt_dbg(2, "Writing %d frames for zone %llx\n",
+	pkt_dbg(2, pd, "Writing %d frames for zone %llx\n",
 		pkt->write_size, (unsigned long long)pkt->sector);
 
 	if (test_bit(PACKET_MERGE_SEGS, &pd->flags) || (pkt->write_size < pkt->frames)) {
@@ -1355,7 +1354,7 @@ static void pkt_run_state_machine(struct
 {
 	int uptodate;
 
-	pkt_dbg(2, "pkt %d\n", pkt->id);
+	pkt_dbg(2, pd, "pkt %d\n", pkt->id);
 
 	for (;;) {
 		switch (pkt->state) {
@@ -1394,7 +1393,7 @@ static void pkt_run_state_machine(struct
 			if (pkt_start_recovery(pkt)) {
 				pkt_start_write(pd, pkt);
 			} else {
-				pkt_dbg(2, "No recovery possible\n");
+				pkt_dbg(2, pd, "No recovery possible\n");
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			}
 			break;
@@ -1415,8 +1414,6 @@ static void pkt_handle_packets(struct pk
 {
 	struct packet_data *pkt, *next;
 
-	pkt_dbg(2, "\n");
-
 	/*
 	 * Run state machine for active packets
 	 */
@@ -1498,7 +1495,7 @@ static int kcdrwd(void *foobar)
 			if (PACKET_DEBUG > 1) {
 				int states[PACKET_NUM_STATES];
 				pkt_count_states(pd, states);
-				pkt_dbg(2, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
+				pkt_dbg(2, pd, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
 					states[0], states[1], states[2],
 					states[3], states[4], states[5]);
 			}
@@ -1509,9 +1506,9 @@ static int kcdrwd(void *foobar)
 					min_sleep_time = pkt->sleep_time;
 			}
 
-			pkt_dbg(2, "sleeping\n");
+			pkt_dbg(2, pd, "sleeping\n");
 			residue = schedule_timeout(min_sleep_time);
-			pkt_dbg(2, "wake up\n");
+			pkt_dbg(2, pd, "wake up\n");
 
 			/* make swsusp happy with our thread */
 			try_to_freeze();
@@ -1808,7 +1805,7 @@ static int pkt_writable_disc(struct pktc
 		case 0x12: /* DVD-RAM */
 			return 1;
 		default:
-			pkt_dbg(2, "Wrong disc profile (%x)\n",
+			pkt_dbg(2, pd, "Wrong disc profile (%x)\n",
 				pd->mmc3_profile);
 			return 0;
 	}
@@ -2124,7 +2121,7 @@ static noinline_for_stack int pkt_perfor
 	struct request_sense sense;
 	int ret;
 
-	pkt_dbg(2, "Performing OPC\n");
+	pkt_dbg(2, pd, "Performing OPC\n");
 
 	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
 	cgc.sense = &sense;
@@ -2142,12 +2139,12 @@ static int pkt_open_write(struct pktcdvd
 	unsigned int write_speed, media_write_speed, read_speed;
 
 	if ((ret = pkt_probe_settings(pd))) {
-		pkt_dbg(2, "%s failed probe\n", pd->name);
+		pkt_dbg(2, pd, "failed probe\n");
 		return ret;
 	}
 
 	if ((ret = pkt_set_write_settings(pd))) {
-		pkt_dbg(1, "%s failed saving write settings\n", pd->name);
+		pkt_dbg(1, pd, "failed saving write settings\n");
 		return -EIO;
 	}
 
@@ -2159,26 +2156,26 @@ static int pkt_open_write(struct pktcdvd
 		case 0x13: /* DVD-RW */
 		case 0x1a: /* DVD+RW */
 		case 0x12: /* DVD-RAM */
-			pkt_dbg(1, "write speed %ukB/s\n", write_speed);
+			pkt_dbg(1, pd, "write speed %ukB/s\n", write_speed);
 			break;
 		default:
 			if ((ret = pkt_media_speed(pd, &media_write_speed)))
 				media_write_speed = 16;
 			write_speed = min(write_speed, media_write_speed * 177);
-			pkt_dbg(1, "write speed %ux\n", write_speed / 176);
+			pkt_dbg(1, pd, "write speed %ux\n", write_speed / 176);
 			break;
 	}
 	read_speed = write_speed;
 
 	if ((ret = pkt_set_speed(pd, write_speed, read_speed))) {
-		pkt_dbg(1, "%s couldn't set write speed\n", pd->name);
+		pkt_dbg(1, pd, "couldn't set write speed\n");
 		return -EIO;
 	}
 	pd->write_speed = write_speed;
 	pd->read_speed = read_speed;
 
 	if ((ret = pkt_perform_opc(pd))) {
-		pkt_dbg(1, "%s Optimum Power Calibration failed\n", pd->name);
+		pkt_dbg(1, pd, "Optimum Power Calibration failed\n");
 	}
 
 	return 0;
@@ -2255,7 +2252,7 @@ out:
 static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 {
 	if (flush && pkt_flush_cache(pd))
-		pkt_dbg(1, "%s not flushing cache\n", pd->name);
+		pkt_dbg(1, pd, "not flushing cache\n");
 
 	pkt_lock_door(pd, 0);
 
@@ -2277,8 +2274,6 @@ static int pkt_open(struct block_device
 	struct pktcdvd_device *pd = NULL;
 	int ret;
 
-	pkt_dbg(2, "entering\n");
-
 	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
 	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
@@ -2313,7 +2308,6 @@ static int pkt_open(struct block_device
 out_dec:
 	pd->refcnt--;
 out:
-	pkt_dbg(2, "failed (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
 	mutex_unlock(&pktcdvd_mutex);
 	return ret;
@@ -2394,7 +2388,7 @@ static void pkt_make_request(struct requ
 	blk_queue_bounce(q, &bio);
 
 	zone = get_zone(bio->bi_sector, pd);
-	pkt_dbg(2, "start = %6llx stop = %6llx\n",
+	pkt_dbg(2, pd, "start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
 
@@ -2649,7 +2643,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	}
 
 	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
-	pkt_dbg(1, "writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
+	pkt_dbg(1, pd, "writer mapped to %s\n", bdevname(bdev, b));
 	return 0;
 
 out_mem:
@@ -2664,7 +2658,7 @@ static int pkt_ioctl(struct block_device
 	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
 	int ret;
 
-	pkt_dbg(2, "cmd %x, dev %d:%d\n",
+	pkt_dbg(2, pd, "cmd %x, dev %d:%d\n",
 		cmd, MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
 	mutex_lock(&pktcdvd_mutex);
@@ -2689,7 +2683,7 @@ static int pkt_ioctl(struct block_device
 		break;
 
 	default:
-		pkt_dbg(2, "Unknown ioctl for %s (%x)\n", pd->name, cmd);
+		pkt_dbg(2, pd, "Unknown ioctl (%x)\n", cmd);
 		ret = -ENOTTY;
 	}
 	mutex_unlock(&pktcdvd_mutex);
@@ -2838,7 +2832,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		pkt_dbg(1, "dev not setup\n");
+		pkt_dbg(1, pd, "dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}
@@ -2858,7 +2852,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	blkdev_put(pd->bdev, FMODE_READ | FMODE_NDELAY);
 
 	remove_proc_entry(pd->name, pkt_proc);
-	pkt_dbg(1, "writer %s unmapped\n", pd->name);
+	pkt_dbg(1, pd, "writer unmapped\n");
 
 	del_gendisk(pd->disk);
 	blk_cleanup_queue(pd->disk->queue);
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
linux-next.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-gpio-vt8500-remove-file-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch

