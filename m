From: akpm@linux-foundation.org
Subject: + physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:23:33 -0800
Message-ID: <200811142123.mAELNXtw025691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYKNVXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:23:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, vapier.adi@gmail.com


The patch titled
     physmap: fix leak of memory returned by parse_mtd_partitions
has been added to the -mm tree.  Its filename is
     physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch

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
@@ -30,7 +30,6 @@ struct physmap_flash_info {
 	struct resource		*res;
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
-	struct mtd_partition	*parts;
 #endif
 };
 
@@ -57,14 +56,10 @@ static int physmap_flash_remove(struct p
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
@@ -96,6 +91,9 @@ static int physmap_flash_probe(struct pl
 	int err = 0;
 	int i;
 	int devices_found = 0;
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts;
+#endif
 
 	physmap_data = dev->dev.platform_data;
 	if (physmap_data == NULL)
@@ -174,9 +172,10 @@ static int physmap_flash_probe(struct pl
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
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch

