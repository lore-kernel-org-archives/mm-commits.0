From: akpm@linux-foundation.org
Subject: + mtd-physmap-use-parse_mtd.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:41:29 -0800
Message-ID: <200811142141.mAELfT3r002371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbYKNVle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, anemo@mba.ocn.ne.jp, dwmw2@infradead.org


The patch titled
     mtd/physmap: use parse_mtd()
has been added to the -mm tree.  Its filename is
     mtd-physmap-use-parse_mtd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
