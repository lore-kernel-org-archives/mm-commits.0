From: akpm@linux-foundation.org
Subject: + pktcdvd-convert-printk-to-pr_level.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:25 -0700
Message-ID: <51f6f391.owqRWGw+NvBxmxEo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3G2W60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, dan.carpenter@oracle.com, andy.shevchenko@gmail.com, joe@perches.com

Subject: + pktcdvd-convert-printk-to-pr_level.patch added to -mm tree
To: joe@perches.com,andy.shevchenko@gmail.com,dan.carpenter@oracle.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:25 -0700


The patch titled
     Subject: pktcdvd: convert printk to pr_<level>
has been added to the -mm tree.  Its filename is
     pktcdvd-convert-printk-to-pr_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-convert-printk-to-pr_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-convert-printk-to-pr_level.patch

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
Subject: pktcdvd: convert printk to pr_<level>

Use a more current logging style and add messages levels to the logging
messages.

Simplify pkt_dump_sense by using %*ph and adding a simple function to emit
the sense string.

Includes improvements from Andy Shevchenko and Dan Carpenter.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |  122 +++++++++++++++++++-------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-convert-printk-to-pr_level drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-convert-printk-to-pr_level
+++ a/drivers/block/pktcdvd.c
@@ -44,6 +44,8 @@
  *
  *************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pktcdvd.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -424,7 +426,7 @@ static int pkt_sysfs_init(void)
 	if (ret) {
 		kfree(class_pktcdvd);
 		class_pktcdvd = NULL;
-		printk(DRIVER_NAME": failed to create class pktcdvd\n");
+		pr_err("failed to create class pktcdvd\n");
 		return ret;
 	}
 	return 0;
@@ -734,36 +736,32 @@ out:
 	return ret;
 }
 
+static const char *sense_key_string(__u8 index)
+{
+	static const char * const info[] = {
+		"No sense", "Recovered error", "Not ready",
+		"Medium error", "Hardware error", "Illegal request",
+		"Unit attention", "Data protect", "Blank check",
+	};
+
+	return index < ARRAY_SIZE(info) ? info[index] : "INVALID";
+}
+
 /*
  * A generic sense dump / resolve mechanism should be implemented across
  * all ATAPI + SCSI devices.
  */
 static void pkt_dump_sense(struct packet_command *cgc)
 {
-	static char *info[9] = { "No sense", "Recovered error", "Not ready",
-				 "Medium error", "Hardware error", "Illegal request",
-				 "Unit attention", "Data protect", "Blank check" };
-	int i;
 	struct request_sense *sense = cgc->sense;
 
-	printk(DRIVER_NAME":");
-	for (i = 0; i < CDROM_PACKET_SIZE; i++)
-		printk(" %02x", cgc->cmd[i]);
-	printk(" - ");
-
-	if (sense == NULL) {
-		printk("no sense\n");
-		return;
-	}
-
-	printk("sense %02x.%02x.%02x", sense->sense_key, sense->asc, sense->ascq);
-
-	if (sense->sense_key > 8) {
-		printk(" (INVALID)\n");
-		return;
-	}
-
-	printk(" (%s)\n", info[sense->sense_key]);
+	if (sense)
+		pr_err("%*ph - sense %02x.%02x.%02x (%s)\n",
+		       CDROM_PACKET_SIZE, cgc->cmd,
+		       sense->sense_key, sense->asc, sense->ascq,
+		       sense_key_string(sense->sense_key));
+	else
+		pr_err("%*ph - no sense\n", CDROM_PACKET_SIZE, cgc->cmd);
 }
 
 /*
@@ -943,7 +941,7 @@ static int pkt_set_segment_merging(struc
 		set_bit(PACKET_MERGE_SEGS, &pd->flags);
 		return 0;
 	} else {
-		printk(DRIVER_NAME": cdrom max_phys_segments too small\n");
+		pr_err("cdrom max_phys_segments too small\n");
 		return -EIO;
 	}
 }
@@ -1563,9 +1561,10 @@ work_to_do:
 
 static void pkt_print_settings(struct pktcdvd_device *pd)
 {
-	printk(DRIVER_NAME": %s packets, ", pd->settings.fp ? "Fixed" : "Variable");
-	printk("%u blocks, ", pd->settings.size >> 2);
-	printk("Mode-%c disc\n", pd->settings.block_mode == 8 ? '1' : '2');
+	pr_info("%s packets, %u blocks, Mode-%c disc\n",
+		pd->settings.fp ? "Fixed" : "Variable",
+		pd->settings.size >> 2,
+		pd->settings.block_mode == 8 ? '1' : '2');
 }
 
 static int pkt_mode_sense(struct pktcdvd_device *pd, struct packet_command *cgc, int page_code, int page_control)
@@ -1749,7 +1748,7 @@ static noinline_for_stack int pkt_set_wr
 		/*
 		 * paranoia
 		 */
-		printk(DRIVER_NAME": write mode wrong %d\n", wp->data_block_type);
+		pr_err("write mode wrong %d\n", wp->data_block_type);
 		return 1;
 	}
 	wp->packet_size = cpu_to_be32(pd->settings.size >> 2);
@@ -1793,7 +1792,7 @@ static int pkt_writable_track(struct pkt
 	if (ti->rt == 1 && ti->blank == 0)
 		return 1;
 
-	printk(DRIVER_NAME": bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
+	pr_err("bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
 	return 0;
 }
 
@@ -1820,22 +1819,22 @@ static int pkt_writable_disc(struct pktc
 	 * but i'm not sure, should we leave this to user apps? probably.
 	 */
 	if (di->disc_type == 0xff) {
-		printk(DRIVER_NAME": Unknown disc. No track?\n");
+		pr_notice("unknown disc - no track?\n");
 		return 0;
 	}
 
 	if (di->disc_type != 0x20 && di->disc_type != 0) {
-		printk(DRIVER_NAME": Wrong disc type (%x)\n", di->disc_type);
+		pr_err("wrong disc type (%x)\n", di->disc_type);
 		return 0;
 	}
 
 	if (di->erasable == 0) {
-		printk(DRIVER_NAME": Disc not erasable\n");
+		pr_notice("disc not erasable\n");
 		return 0;
 	}
 
 	if (di->border_status == PACKET_SESSION_RESERVED) {
-		printk(DRIVER_NAME": Can't write to last track (reserved)\n");
+		pr_err("can't write to last track (reserved)\n");
 		return 0;
 	}
 
@@ -1860,7 +1859,7 @@ static noinline_for_stack int pkt_probe_
 	memset(&ti, 0, sizeof(track_information));
 
 	if ((ret = pkt_get_disc_info(pd, &di))) {
-		printk("failed get_disc\n");
+		pr_err("failed get_disc\n");
 		return ret;
 	}
 
@@ -1871,12 +1870,12 @@ static noinline_for_stack int pkt_probe_
 
 	track = 1; /* (di.last_track_msb << 8) | di.last_track_lsb; */
 	if ((ret = pkt_get_track_info(pd, track, 1, &ti))) {
-		printk(DRIVER_NAME": failed get_track\n");
+		pr_err("failed get_track\n");
 		return ret;
 	}
 
 	if (!pkt_writable_track(pd, &ti)) {
-		printk(DRIVER_NAME": can't write to this track\n");
+		pr_err("can't write to this track\n");
 		return -EROFS;
 	}
 
@@ -1886,11 +1885,11 @@ static noinline_for_stack int pkt_probe_
 	 */
 	pd->settings.size = be32_to_cpu(ti.fixed_packet_size) << 2;
 	if (pd->settings.size == 0) {
-		printk(DRIVER_NAME": detected zero packet size!\n");
+		pr_notice("detected zero packet size!\n");
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
-		printk(DRIVER_NAME": packet size is too big\n");
+		pr_err("packet size is too big\n");
 		return -EROFS;
 	}
 	pd->settings.fp = ti.fp;
@@ -1932,7 +1931,7 @@ static noinline_for_stack int pkt_probe_
 			pd->settings.block_mode = PACKET_BLOCK_MODE2;
 			break;
 		default:
-			printk(DRIVER_NAME": unknown data mode\n");
+			pr_err("unknown data mode\n");
 			return -EROFS;
 	}
 	return 0;
@@ -1966,10 +1965,10 @@ static noinline_for_stack int pkt_write_
 	cgc.buflen = cgc.cmd[8] = 2 + ((buf[0] << 8) | (buf[1] & 0xff));
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
-		printk(DRIVER_NAME": write caching control failed\n");
+		pr_err("write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
-		printk(DRIVER_NAME": enabled write caching on %s\n", pd->name);
+		pr_notice("enabled write caching on %s\n", pd->name);
 	return ret;
 }
 
@@ -2084,11 +2083,11 @@ static noinline_for_stack int pkt_media_
 	}
 
 	if (!(buf[6] & 0x40)) {
-		printk(DRIVER_NAME": Disc type is not CD-RW\n");
+		pr_notice("disc type is not CD-RW\n");
 		return 1;
 	}
 	if (!(buf[6] & 0x4)) {
-		printk(DRIVER_NAME": A1 values on media are not valid, maybe not CDRW?\n");
+		pr_notice("A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
 
@@ -2108,14 +2107,14 @@ static noinline_for_stack int pkt_media_
 			*speed = us_clv_to_speed[sp];
 			break;
 		default:
-			printk(DRIVER_NAME": Unknown disc sub-type %d\n",st);
+			pr_notice("unknown disc sub-type %d\n", st);
 			return 1;
 	}
 	if (*speed) {
-		printk(DRIVER_NAME": Max. media speed: %d\n",*speed);
+		pr_info("maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
-		printk(DRIVER_NAME": Unknown speed %d for sub-type %d\n",sp,st);
+		pr_notice("unknown speed %d for sub-type %d\n", sp, st);
 		return 1;
 	}
 }
@@ -2205,7 +2204,7 @@ static int pkt_open_dev(struct pktcdvd_d
 		goto out;
 
 	if ((ret = pkt_get_last_written(pd, &lba))) {
-		printk(DRIVER_NAME": pkt_get_last_written failed\n");
+		pr_err("pkt_get_last_written failed\n");
 		goto out_putdev;
 	}
 
@@ -2235,11 +2234,11 @@ static int pkt_open_dev(struct pktcdvd_d
 
 	if (write) {
 		if (!pkt_grow_pktlist(pd, CONFIG_CDROM_PKTCDVD_BUFFERS)) {
-			printk(DRIVER_NAME": not enough memory for buffers\n");
+			pr_err("not enough memory for buffers\n");
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
-		printk(DRIVER_NAME": %lukB available on disc\n", lba << 1);
+		pr_info("%lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
@@ -2360,7 +2359,8 @@ static void pkt_make_request(struct requ
 
 	pd = q->queuedata;
 	if (!pd) {
-		printk(DRIVER_NAME": %s incorrect request queue\n", bdevname(bio->bi_bdev, b));
+		pr_err("%s incorrect request queue\n",
+		       bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2382,13 +2382,13 @@ static void pkt_make_request(struct requ
 	}
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
-		printk(DRIVER_NAME": WRITE for ro device %s (%llu)\n",
-			pd->name, (unsigned long long)bio->bi_sector);
+		pr_notice("WRITE for ro device %s (%llu)\n",
+			  pd->name, (unsigned long long)bio->bi_sector);
 		goto end_io;
 	}
 
 	if (!bio->bi_size || (bio->bi_size % CD_FRAMESIZE)) {
-		printk(DRIVER_NAME": wrong bio size\n");
+		pr_err("wrong bio size\n");
 		goto end_io;
 	}
 
@@ -2609,7 +2609,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
-		printk(DRIVER_NAME": Recursive setup not allowed\n");
+		pr_err("recursive setup not allowed\n");
 		return -EBUSY;
 	}
 	for (i = 0; i < MAX_WRITERS; i++) {
@@ -2617,11 +2617,11 @@ static int pkt_new_dev(struct pktcdvd_de
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			printk(DRIVER_NAME": %s already setup\n", bdevname(pd2->bdev, b));
+			pr_err("%s already setup\n", bdevname(pd2->bdev, b));
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
-			printk(DRIVER_NAME": Can't chain pktcdvd devices\n");
+			pr_err("can't chain pktcdvd devices\n");
 			return -EBUSY;
 		}
 	}
@@ -2644,7 +2644,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	atomic_set(&pd->cdrw.pending_bios, 0);
 	pd->cdrw.thread = kthread_run(kcdrwd, pd, "%s", pd->name);
 	if (IS_ERR(pd->cdrw.thread)) {
-		printk(DRIVER_NAME": can't start kernel thread\n");
+		pr_err("can't start kernel thread\n");
 		ret = -ENOMEM;
 		goto out_mem;
 	}
@@ -2743,7 +2743,7 @@ static int pkt_setup_dev(dev_t dev, dev_
 		if (!pkt_devs[idx])
 			break;
 	if (idx == MAX_WRITERS) {
-		printk(DRIVER_NAME": max %d writers supported\n", MAX_WRITERS);
+		pr_err("max %d writers supported\n", MAX_WRITERS);
 		ret = -EBUSY;
 		goto out_mutex;
 	}
@@ -2818,7 +2818,7 @@ out_mem:
 	kfree(pd);
 out_mutex:
 	mutex_unlock(&ctl_mutex);
-	printk(DRIVER_NAME": setup of pktcdvd device failed\n");
+	pr_err("setup of pktcdvd device failed\n");
 	return ret;
 }
 
@@ -2969,7 +2969,7 @@ static int __init pkt_init(void)
 
 	ret = register_blkdev(pktdev_major, DRIVER_NAME);
 	if (ret < 0) {
-		printk(DRIVER_NAME": Unable to register block device\n");
+		pr_err("unable to register block device\n");
 		goto out2;
 	}
 	if (!pktdev_major)
@@ -2983,7 +2983,7 @@ static int __init pkt_init(void)
 
 	ret = misc_register(&pkt_misc);
 	if (ret) {
-		printk(DRIVER_NAME": Unable to register misc device\n");
+		pr_err("unable to register misc device\n");
 		goto out_misc;
 	}
 
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

