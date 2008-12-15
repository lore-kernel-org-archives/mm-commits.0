From: akpm@linux-foundation.org
Subject: - physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:11 -0800
Message-ID: <200812152002.mBFK2BDR030769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463AbYLOUCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     physmap: fix leak of memory returned by parse_mtd_partitions
has been removed from the -mm tree.  Its filename was
     physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: physmap: fix leak of memory returned by parse_mtd_partitions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The mtd partition parser returns an allocated pointer array of
mtd_partition.  The caller must free it.  The array is used only for
add_mtd_partitions(), so free it just after the call.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions
+++ a/drivers/mtd/maps/physmap.c
@@ -29,7 +29,6 @@ struct physmap_flash_info {
 	struct map_info		map[MAX_RESOURCES];
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
-	struct mtd_partition	*parts;
 #endif
 };
 
@@ -56,14 +55,10 @@ static int physmap_flash_remove(struct p
 	for (i = 0; i < MAX_RESOURCES; i++) {
 		if (info->mtd[i] != NULL) {
 #ifdef CONFIG_MTD_PARTITIONS
-			if (info->nr_parts) {
+			if (info->nr_parts || physmap_data->nr_parts)
 				del_mtd_partitions(info->mtd[i]);
-				kfree(info->parts);
-			} else if (physmap_data->nr_parts) {
-				del_mtd_partitions(info->mtd[i]);
-			} else {
+			else
 				del_mtd_device(info->mtd[i]);
-			}
 #else
 			del_mtd_device(info->mtd[i]);
 #endif
@@ -86,6 +81,9 @@ static int physmap_flash_probe(struct pl
 	int err = 0;
 	int i;
 	int devices_found = 0;
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts;
+#endif
 
 	physmap_data = dev->dev.platform_data;
 	if (physmap_data == NULL)
@@ -166,9 +164,10 @@ static int physmap_flash_probe(struct pl
 		goto err_out;
 
 #ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
+	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
 	if (err > 0) {
-		add_mtd_partitions(info->cmtd, info->parts, err);
+		add_mtd_partitions(info->cmtd, parts, err);
+		kfree(parts);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
physmap-make-map_info-customizable.patch
atmel_serial-might-lose-modem-status-change.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-add-rtc-tx4939-driver-v2.patch

