From: akpm@linux-foundation.org
Subject: - mtd-physmap-use-parse_mtd.patch removed from -mm tree
Date: Fri, 14 Nov 2008 14:25:38 -0800
Message-ID: <200811142225.mAEMPcrF024195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbYKNWZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 17:25:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, anemo@mba.ocn.ne.jp, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/physmap: use parse_mtd()
has been removed from the -mm tree.  Its filename was
     mtd-physmap-use-parse_mtd.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/physmap: use parse_mtd()
From: Mike Frysinger <vapier@gentoo.org>

Call parse_mtd() to handle partition/device registration rather than doing
it all ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~mtd-physmap-use-parse_mtd drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-physmap-use-parse_mtd
+++ a/drivers/mtd/maps/physmap.c
@@ -79,9 +79,6 @@ static int physmap_flash_remove(struct p
 }
 
 static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", "map_rom", NULL };
-#ifdef CONFIG_MTD_PARTITIONS
-static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
-#endif
 
 static int physmap_flash_probe(struct platform_device *dev)
 {
@@ -171,24 +168,8 @@ static int physmap_flash_probe(struct pl
 	if (err)
 		goto err_out;
 
-#ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
-	if (err > 0) {
-		add_mtd_partitions(info->cmtd, parts, err);
-		kfree(parts);
-		return 0;
-	}
-
-	if (physmap_data->nr_parts) {
-		printk(KERN_NOTICE "Using physmap partition information\n");
-		add_mtd_partitions(info->cmtd, physmap_data->parts,
-				   physmap_data->nr_parts);
-		return 0;
-	}
-#endif
