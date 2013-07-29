From: akpm@linux-foundation.org
Subject: +
 pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:29 -0700
Message-ID: <51f6f395.J5nZ41L1d9DQ2que%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3G2W6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, andy.shevchenko@gmail.com, joe@perches.com

Subject: + pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch added to -mm tree
To: joe@perches.com,andy.shevchenko@gmail.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:29 -0700


The patch titled
     Subject: pktcdvd: add struct pktcdvd_device.name to pr_err logging where possible
has been added to the -mm tree.  Its filename is
     pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch

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
Subject: pktcdvd: add struct pktcdvd_device.name to pr_err logging where possible

Add a new pkt_err macro to prefix the name to the logging output.  Convert
pr_err where there is a non-null struct pktcdvd_device.

Includes improvements from Andy Shevchenko.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   44 ++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible
+++ a/drivers/block/pktcdvd.c
@@ -71,6 +71,9 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
+#define pkt_err(pd, fmt, ...)						\
+	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
+
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
 	if (level == 2 && PACKET_DEBUG >= 2)				\
@@ -938,7 +941,7 @@ static int pkt_set_segment_merging(struc
 		set_bit(PACKET_MERGE_SEGS, &pd->flags);
 		return 0;
 	} else {
-		pr_err("cdrom max_phys_segments too small\n");
+		pkt_err(pd, "cdrom max_phys_segments too small\n");
 		return -EIO;
 	}
 }
@@ -1743,7 +1746,7 @@ static noinline_for_stack int pkt_set_wr
 		/*
 		 * paranoia
 		 */
-		pr_err("write mode wrong %d\n", wp->data_block_type);
+		pkt_err(pd, "write mode wrong %d\n", wp->data_block_type);
 		return 1;
 	}
 	wp->packet_size = cpu_to_be32(pd->settings.size >> 2);
@@ -1787,7 +1790,7 @@ static int pkt_writable_track(struct pkt
 	if (ti->rt == 1 && ti->blank == 0)
 		return 1;
 
-	pr_err("bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
+	pkt_err(pd, "bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
 	return 0;
 }
 
@@ -1820,7 +1823,7 @@ static int pkt_writable_disc(struct pktc
 	}
 
 	if (di->disc_type != 0x20 && di->disc_type != 0) {
-		pr_err("wrong disc type (%x)\n", di->disc_type);
+		pkt_err(pd, "wrong disc type (%x)\n", di->disc_type);
 		return 0;
 	}
 
@@ -1830,7 +1833,7 @@ static int pkt_writable_disc(struct pktc
 	}
 
 	if (di->border_status == PACKET_SESSION_RESERVED) {
-		pr_err("can't write to last track (reserved)\n");
+		pkt_err(pd, "can't write to last track (reserved)\n");
 		return 0;
 	}
 
@@ -1855,7 +1858,7 @@ static noinline_for_stack int pkt_probe_
 	memset(&ti, 0, sizeof(track_information));
 
 	if ((ret = pkt_get_disc_info(pd, &di))) {
-		pr_err("failed get_disc\n");
+		pkt_err(pd, "failed get_disc\n");
 		return ret;
 	}
 
@@ -1866,12 +1869,12 @@ static noinline_for_stack int pkt_probe_
 
 	track = 1; /* (di.last_track_msb << 8) | di.last_track_lsb; */
 	if ((ret = pkt_get_track_info(pd, track, 1, &ti))) {
-		pr_err("failed get_track\n");
+		pkt_err(pd, "failed get_track\n");
 		return ret;
 	}
 
 	if (!pkt_writable_track(pd, &ti)) {
-		pr_err("can't write to this track\n");
+		pkt_err(pd, "can't write to this track\n");
 		return -EROFS;
 	}
 
@@ -1885,7 +1888,7 @@ static noinline_for_stack int pkt_probe_
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
-		pr_err("packet size is too big\n");
+		pkt_err(pd, "packet size is too big\n");
 		return -EROFS;
 	}
 	pd->settings.fp = ti.fp;
@@ -1927,7 +1930,7 @@ static noinline_for_stack int pkt_probe_
 			pd->settings.block_mode = PACKET_BLOCK_MODE2;
 			break;
 		default:
-			pr_err("unknown data mode\n");
+			pkt_err(pd, "unknown data mode\n");
 			return -EROFS;
 	}
 	return 0;
@@ -1961,7 +1964,7 @@ static noinline_for_stack int pkt_write_
 	cgc.buflen = cgc.cmd[8] = 2 + ((buf[0] << 8) | (buf[1] & 0xff));
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
-		pr_err("write caching control failed\n");
+		pkt_err(pd, "write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
 		pr_notice("enabled write caching on %s\n", pd->name);
@@ -2200,7 +2203,7 @@ static int pkt_open_dev(struct pktcdvd_d
 		goto out;
 
 	if ((ret = pkt_get_last_written(pd, &lba))) {
-		pr_err("pkt_get_last_written failed\n");
+		pkt_err(pd, "pkt_get_last_written failed\n");
 		goto out_putdev;
 	}
 
@@ -2230,7 +2233,7 @@ static int pkt_open_dev(struct pktcdvd_d
 
 	if (write) {
 		if (!pkt_grow_pktlist(pd, CONFIG_CDROM_PKTCDVD_BUFFERS)) {
-			pr_err("not enough memory for buffers\n");
+			pkt_err(pd, "not enough memory for buffers\n");
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
@@ -2352,8 +2355,8 @@ static void pkt_make_request(struct requ
 
 	pd = q->queuedata;
 	if (!pd) {
-		pr_err("%s incorrect request queue\n",
-		       bdevname(bio->bi_bdev, b));
+		pkt_err(pd, "%s incorrect request queue\n",
+			bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2381,7 +2384,7 @@ static void pkt_make_request(struct requ
 	}
 
 	if (!bio->bi_size || (bio->bi_size % CD_FRAMESIZE)) {
-		pr_err("wrong bio size\n");
+		pkt_err(pd, "wrong bio size\n");
 		goto end_io;
 	}
 
@@ -2602,7 +2605,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
-		pr_err("recursive setup not allowed\n");
+		pkt_err(pd, "recursive setup not allowed\n");
 		return -EBUSY;
 	}
 	for (i = 0; i < MAX_WRITERS; i++) {
@@ -2610,11 +2613,12 @@ static int pkt_new_dev(struct pktcdvd_de
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			pr_err("%s already setup\n", bdevname(pd2->bdev, b));
+			pkt_err(pd, "%s already setup\n",
+				bdevname(pd2->bdev, b));
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
-			pr_err("can't chain pktcdvd devices\n");
+			pkt_err(pd, "can't chain pktcdvd devices\n");
 			return -EBUSY;
 		}
 	}
@@ -2637,7 +2641,7 @@ static int pkt_new_dev(struct pktcdvd_de
 	atomic_set(&pd->cdrw.pending_bios, 0);
 	pd->cdrw.thread = kthread_run(kcdrwd, pd, "%s", pd->name);
 	if (IS_ERR(pd->cdrw.thread)) {
-		pr_err("can't start kernel thread\n");
+		pkt_err(pd, "can't start kernel thread\n");
 		ret = -ENOMEM;
 		goto out_mem;
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

