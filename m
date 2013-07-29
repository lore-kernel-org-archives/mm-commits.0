From: akpm@linux-foundation.org
Subject: + pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
 added to -mm tree
Date: Mon, 29 Jul 2013 15:58:24 -0700
Message-ID: <51f6f390.ESkj+Ji5/xlUcZcr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3G2W6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-convert-zone-macro-to-static-function-get_zone.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:24 -0700


The patch titled
     Subject: pktcdvd: convert ZONE macro to static function get_zone()
has been added to the -mm tree.  Its filename is
     pktcdvd-convert-zone-macro-to-static-function-get_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-convert-zone-macro-to-static-function-get_zone.patch

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
Subject: pktcdvd: convert ZONE macro to static function get_zone()

Macros should be converted to functions where feasible to
verify arguments and the like.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-convert-zone-macro-to-static-function-get_zone drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-convert-zone-macro-to-static-function-get_zone
+++ a/drivers/block/pktcdvd.c
@@ -83,9 +83,6 @@
 
 #define MAX_SPEED 0xffff
 
-#define ZONE(sector, pd) (((sector) + (pd)->offset) & \
-			~(sector_t)((pd)->settings.size - 1))
-
 static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
@@ -103,7 +100,10 @@ static int pkt_setup_dev(dev_t dev, dev_
 static int pkt_remove_dev(dev_t pkt_dev);
 static int pkt_seq_show(struct seq_file *m, void *p);
 
-
+static sector_t get_zone(sector_t sector, struct pktcdvd_device *pd)
+{
+	return (sector + pd->offset) & ~(sector_t)(pd->settings.size - 1);
+}
 
 /*
  * create and register a pktcdvd kernel object.
@@ -1224,7 +1224,7 @@ static int pkt_handle_queue(struct pktcd
 	node = first_node;
 	while (node) {
 		bio = node->bio;
-		zone = ZONE(bio->bi_sector, pd);
+		zone = get_zone(bio->bi_sector, pd);
 		list_for_each_entry(p, &pd->cdrw.pkt_active_list, list) {
 			if (p->sector == zone) {
 				bio = NULL;
@@ -1264,8 +1264,8 @@ try_next_bio:
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
 		VPRINTK("pkt_handle_queue: found zone=%llx\n",
-			(unsigned long long)ZONE(bio->bi_sector, pd));
-		if (ZONE(bio->bi_sector, pd) != zone)
+			(unsigned long long)get_zone(bio->bi_sector, pd));
+		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
 		pkt_rbtree_erase(pd, node);
 		spin_lock(&pkt->lock);
@@ -2394,7 +2394,7 @@ static void pkt_make_request(struct requ
 
 	blk_queue_bounce(q, &bio);
 
-	zone = ZONE(bio->bi_sector, pd);
+	zone = get_zone(bio->bi_sector, pd);
 	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
@@ -2405,7 +2405,7 @@ static void pkt_make_request(struct requ
 		sector_t last_zone;
 		int first_sectors;
 
-		last_zone = ZONE(bio_end_sector(bio) - 1, pd);
+		last_zone = get_zone(bio_end_sector(bio) - 1, pd);
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
@@ -2500,7 +2500,7 @@ static int pkt_merge_bvec(struct request
 			  struct bio_vec *bvec)
 {
 	struct pktcdvd_device *pd = q->queuedata;
-	sector_t zone = ZONE(bmd->bi_sector, pd);
+	sector_t zone = get_zone(bmd->bi_sector, pd);
 	int used = ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
 	int remaining = (pd->settings.size << 9) - used;
 	int remaining2;
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

