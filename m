From: akpm@linux-foundation.org
Subject: + pktcdvd-consolidate-dprintk-and-vprintk-macros.patch added to
 -mm tree
Date: Mon, 29 Jul 2013 15:58:26 -0700
Message-ID: <51f6f392.vxKr+xKYBNmvha6A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3G2W61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-consolidate-dprintk-and-vprintk-macros.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:26 -0700


The patch titled
     Subject: pktcdvd: consolidate DPRINTK and VPRINTK macros
has been added to the -mm tree.  Its filename is
     pktcdvd-consolidate-dprintk-and-vprintk-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-consolidate-dprintk-and-vprintk-macros.patch

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
Subject: pktcdvd: consolidate DPRINTK and VPRINTK macros

Use the more common pkt_dbg(level, fmt, ...) form.

These messages are emitted at KERN_NOTICE.

Always emit function name with pkt_dbg(2, ...) uses and remove the
sometimes abbreviated embedded function name.

This form always verifies the format and arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |  107 ++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-consolidate-dprintk-and-vprintk-macros drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-consolidate-dprintk-and-vprintk-macros
+++ a/drivers/block/pktcdvd.c
@@ -71,17 +71,13 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
-#if PACKET_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_NOTICE fmt, ##args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
-#if PACKET_DEBUG > 1
-#define VPRINTK(fmt, args...) printk(KERN_NOTICE fmt, ##args)
-#else
-#define VPRINTK(fmt, args...)
-#endif
+#define pkt_dbg(level, fmt, ...)				\
+do {								\
+	if (level == 2 && PACKET_DEBUG >= 2)			\
+		pr_notice("%s: " fmt, __func__, ##__VA_ARGS__);	\
+	else if (level == 1 && PACKET_DEBUG >= 1)		\
+		pr_notice(fmt, ##__VA_ARGS__);			\
+} while (0)
 
 #define MAX_SPEED 0xffff
 
@@ -519,7 +515,7 @@ static void pkt_bio_finished(struct pktc
 {
 	BUG_ON(atomic_read(&pd->cdrw.pending_bios) <= 0);
 	if (atomic_dec_and_test(&pd->cdrw.pending_bios)) {
-		VPRINTK(DRIVER_NAME": queue empty\n");
+		pkt_dbg(2, "queue empty\n");
 		atomic_set(&pd->iosched.attention, 1);
 		wake_up(&pd->wqueue);
 	}
@@ -870,7 +866,7 @@ static void pkt_iosched_process_queue(st
 				need_write_seek = 0;
 			if (need_write_seek && reads_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					VPRINTK(DRIVER_NAME": write, waiting\n");
+					pkt_dbg(2, "write, waiting\n");
 					break;
 				}
 				pkt_flush_cache(pd);
@@ -879,7 +875,7 @@ static void pkt_iosched_process_queue(st
 		} else {
 			if (!reads_queued && writes_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					VPRINTK(DRIVER_NAME": read, waiting\n");
+					pkt_dbg(2, "read, waiting\n");
 					break;
 				}
 				pd->iosched.writing = 1;
@@ -985,8 +981,9 @@ static void pkt_end_io_read(struct bio *
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
-		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
+	pkt_dbg(2, "bio=%p sec0=%llx sec=%llx err=%d\n",
+		bio, (unsigned long long)pkt->sector,
+		(unsigned long long)bio->bi_sector, err);
 
 	if (err)
 		atomic_inc(&pkt->io_errors);
@@ -1003,7 +1000,7 @@ static void pkt_end_io_packet_write(stru
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
+	pkt_dbg(2, "id=%d, err=%d\n", pkt->id, err);
 
 	pd->stats.pkt_ended++;
 
@@ -1045,7 +1042,7 @@ static void pkt_gather_data(struct pktcd
 	spin_unlock(&pkt->lock);
 
 	if (pkt->cache_valid) {
-		VPRINTK("pkt_gather_data: zone %llx cached\n",
+		pkt_dbg(2, "zone %llx cached\n",
 			(unsigned long long)pkt->sector);
 		goto out_account;
 	}
@@ -1068,7 +1065,7 @@ static void pkt_gather_data(struct pktcd
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
-		VPRINTK("pkt_gather_data: Adding frame %d, page:%p offs:%d\n",
+		pkt_dbg(2, "Adding frame %d, page:%p offs:%d\n",
 			f, pkt->pages[p], offset);
 		if (!bio_add_page(bio, pkt->pages[p], CD_FRAMESIZE, offset))
 			BUG();
@@ -1080,7 +1077,7 @@ static void pkt_gather_data(struct pktcd
 	}
 
 out_account:
-	VPRINTK("pkt_gather_data: need %d frames for zone %llx\n",
+	pkt_dbg(2, "need %d frames for zone %llx\n",
 		frames_read, (unsigned long long)pkt->sector);
 	pd->stats.pkt_started++;
 	pd->stats.secs_rg += frames_read * (CD_FRAMESIZE >> 9);
@@ -1181,7 +1178,8 @@ static inline void pkt_set_state(struct
 		"IDLE", "WAITING", "READ_WAIT", "WRITE_WAIT", "RECOVERY", "FINISHED"
 	};
 	enum packet_data_state old_state = pkt->state;
-	VPRINTK("pkt %2d : s=%6llx %s -> %s\n", pkt->id, (unsigned long long)pkt->sector,
+	pkt_dbg(2, "pkt %2d : s=%6llx %s -> %s\n",
+		pkt->id, (unsigned long long)pkt->sector,
 		state_name[old_state], state_name[state]);
 #endif
 	pkt->state = state;
@@ -1200,12 +1198,12 @@ static int pkt_handle_queue(struct pktcd
 	struct rb_node *n;
 	int wakeup;
 
-	VPRINTK("handle_queue\n");
+	pkt_dbg(2, "\n");
 
 	atomic_set(&pd->scan_queue, 0);
 
 	if (list_empty(&pd->cdrw.pkt_free_list)) {
-		VPRINTK("handle_queue: no pkt\n");
+		pkt_dbg(2, "no pkt\n");
 		return 0;
 	}
 
@@ -1242,7 +1240,7 @@ try_next_bio:
 	}
 	spin_unlock(&pd->lock);
 	if (!bio) {
-		VPRINTK("handle_queue: no bio\n");
+		pkt_dbg(2, "no bio\n");
 		return 0;
 	}
 
@@ -1258,10 +1256,10 @@ try_next_bio:
 	 * to this packet.
 	 */
 	spin_lock(&pd->lock);
-	VPRINTK("pkt_handle_queue: looking for zone %llx\n", (unsigned long long)zone);
+	pkt_dbg(2, "looking for zone %llx\n", (unsigned long long)zone);
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
-		VPRINTK("pkt_handle_queue: found zone=%llx\n",
+		pkt_dbg(2, "found zone=%llx\n",
 			(unsigned long long)get_zone(bio->bi_sector, pd));
 		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
@@ -1314,7 +1312,7 @@ static void pkt_start_write(struct pktcd
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
 	}
-	VPRINTK(DRIVER_NAME": vcnt=%d\n", pkt->w_bio->bi_vcnt);
+	pkt_dbg(2, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
 
 	/*
 	 * Fill-in bvec with data from orig_bios.
@@ -1325,7 +1323,7 @@ static void pkt_start_write(struct pktcd
 	pkt_set_state(pkt, PACKET_WRITE_WAIT_STATE);
 	spin_unlock(&pkt->lock);
 
-	VPRINTK("pkt_start_write: Writing %d frames for zone %llx\n",
+	pkt_dbg(2, "Writing %d frames for zone %llx\n",
 		pkt->write_size, (unsigned long long)pkt->sector);
 
 	if (test_bit(PACKET_MERGE_SEGS, &pd->flags) || (pkt->write_size < pkt->frames)) {
@@ -1357,7 +1355,7 @@ static void pkt_run_state_machine(struct
 {
 	int uptodate;
 
-	VPRINTK("run_state_machine: pkt %d\n", pkt->id);
+	pkt_dbg(2, "pkt %d\n", pkt->id);
 
 	for (;;) {
 		switch (pkt->state) {
@@ -1396,7 +1394,7 @@ static void pkt_run_state_machine(struct
 			if (pkt_start_recovery(pkt)) {
 				pkt_start_write(pd, pkt);
 			} else {
-				VPRINTK("No recovery possible\n");
+				pkt_dbg(2, "No recovery possible\n");
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			}
 			break;
@@ -1417,7 +1415,7 @@ static void pkt_handle_packets(struct pk
 {
 	struct packet_data *pkt, *next;
 
-	VPRINTK("pkt_handle_packets\n");
+	pkt_dbg(2, "\n");
 
 	/*
 	 * Run state machine for active packets
@@ -1500,9 +1498,9 @@ static int kcdrwd(void *foobar)
 			if (PACKET_DEBUG > 1) {
 				int states[PACKET_NUM_STATES];
 				pkt_count_states(pd, states);
-				VPRINTK("kcdrwd: i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
-					states[0], states[1], states[2], states[3],
-					states[4], states[5]);
+				pkt_dbg(2, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
+					states[0], states[1], states[2],
+					states[3], states[4], states[5]);
 			}
 
 			min_sleep_time = MAX_SCHEDULE_TIMEOUT;
@@ -1511,9 +1509,9 @@ static int kcdrwd(void *foobar)
 					min_sleep_time = pkt->sleep_time;
 			}
 
-			VPRINTK("kcdrwd: sleeping\n");
+			pkt_dbg(2, "sleeping\n");
 			residue = schedule_timeout(min_sleep_time);
-			VPRINTK("kcdrwd: wake up\n");
+			pkt_dbg(2, "wake up\n");
 
 			/* make swsusp happy with our thread */
 			try_to_freeze();
@@ -1810,7 +1808,8 @@ static int pkt_writable_disc(struct pktc
 		case 0x12: /* DVD-RAM */
 			return 1;
 		default:
-			VPRINTK(DRIVER_NAME": Wrong disc profile (%x)\n", pd->mmc3_profile);
+			pkt_dbg(2, "Wrong disc profile (%x)\n",
+				pd->mmc3_profile);
 			return 0;
 	}
 
@@ -2125,7 +2124,7 @@ static noinline_for_stack int pkt_perfor
 	struct request_sense sense;
 	int ret;
 
-	VPRINTK(DRIVER_NAME": Performing OPC\n");
+	pkt_dbg(2, "Performing OPC\n");
 
 	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
 	cgc.sense = &sense;
@@ -2143,12 +2142,12 @@ static int pkt_open_write(struct pktcdvd
 	unsigned int write_speed, media_write_speed, read_speed;
 
 	if ((ret = pkt_probe_settings(pd))) {
-		VPRINTK(DRIVER_NAME": %s failed probe\n", pd->name);
+		pkt_dbg(2, "%s failed probe\n", pd->name);
 		return ret;
 	}
 
 	if ((ret = pkt_set_write_settings(pd))) {
-		DPRINTK(DRIVER_NAME": %s failed saving write settings\n", pd->name);
+		pkt_dbg(1, "%s failed saving write settings\n", pd->name);
 		return -EIO;
 	}
 
@@ -2160,26 +2159,26 @@ static int pkt_open_write(struct pktcdvd
 		case 0x13: /* DVD-RW */
 		case 0x1a: /* DVD+RW */
 		case 0x12: /* DVD-RAM */
-			DPRINTK(DRIVER_NAME": write speed %ukB/s\n", write_speed);
+			pkt_dbg(1, "write speed %ukB/s\n", write_speed);
 			break;
 		default:
 			if ((ret = pkt_media_speed(pd, &media_write_speed)))
 				media_write_speed = 16;
 			write_speed = min(write_speed, media_write_speed * 177);
-			DPRINTK(DRIVER_NAME": write speed %ux\n", write_speed / 176);
+			pkt_dbg(1, "write speed %ux\n", write_speed / 176);
 			break;
 	}
 	read_speed = write_speed;
 
 	if ((ret = pkt_set_speed(pd, write_speed, read_speed))) {
-		DPRINTK(DRIVER_NAME": %s couldn't set write speed\n", pd->name);
+		pkt_dbg(1, "%s couldn't set write speed\n", pd->name);
 		return -EIO;
 	}
 	pd->write_speed = write_speed;
 	pd->read_speed = read_speed;
 
 	if ((ret = pkt_perform_opc(pd))) {
-		DPRINTK(DRIVER_NAME": %s Optimum Power Calibration failed\n", pd->name);
+		pkt_dbg(1, "%s Optimum Power Calibration failed\n", pd->name);
 	}
 
 	return 0;
@@ -2256,7 +2255,7 @@ out:
 static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 {
 	if (flush && pkt_flush_cache(pd))
-		DPRINTK(DRIVER_NAME": %s not flushing cache\n", pd->name);
+		pkt_dbg(1, "%s not flushing cache\n", pd->name);
 
 	pkt_lock_door(pd, 0);
 
@@ -2278,7 +2277,7 @@ static int pkt_open(struct block_device
 	struct pktcdvd_device *pd = NULL;
 	int ret;
 
-	VPRINTK(DRIVER_NAME": entering open\n");
+	pkt_dbg(2, "entering\n");
 
 	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
@@ -2314,7 +2313,7 @@ static int pkt_open(struct block_device
 out_dec:
 	pd->refcnt--;
 out:
-	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
+	pkt_dbg(2, "failed (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
 	mutex_unlock(&pktcdvd_mutex);
 	return ret;
@@ -2395,7 +2394,7 @@ static void pkt_make_request(struct requ
 	blk_queue_bounce(q, &bio);
 
 	zone = get_zone(bio->bi_sector, pd);
-	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
+	pkt_dbg(2, "start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
 
@@ -2650,7 +2649,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	}
 
 	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
-	DPRINTK(DRIVER_NAME": writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
+	pkt_dbg(1, "writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
 	return 0;
 
 out_mem:
@@ -2665,8 +2664,8 @@ static int pkt_ioctl(struct block_device
 	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
 	int ret;
 
-	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd,
-		MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+	pkt_dbg(2, "cmd %x, dev %d:%d\n",
+		cmd, MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
 	mutex_lock(&pktcdvd_mutex);
 	switch (cmd) {
@@ -2690,7 +2689,7 @@ static int pkt_ioctl(struct block_device
 		break;
 
 	default:
-		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
+		pkt_dbg(2, "Unknown ioctl for %s (%x)\n", pd->name, cmd);
 		ret = -ENOTTY;
 	}
 	mutex_unlock(&pktcdvd_mutex);
@@ -2839,7 +2838,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		DPRINTK(DRIVER_NAME": dev not setup\n");
+		pkt_dbg(1, "dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}
@@ -2859,7 +2858,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	blkdev_put(pd->bdev, FMODE_READ | FMODE_NDELAY);
 
 	remove_proc_entry(pd->name, pkt_proc);
-	DPRINTK(DRIVER_NAME": writer %s unmapped\n", pd->name);
+	pkt_dbg(1, "writer %s unmapped\n", pd->name);
 
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

