From: akpm@linux-foundation.org
Subject: + mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:51:57 -0800
Message-ID: <200901302151.n0ULpvsp028838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbZA3VwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, matthias@kaehlcke.net


The patch titled
     mtd: physmap: fix wrong free and del_mtd_{partition,device}
has been added to the -mm tree.  Its filename is
     mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch

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
Subject: mtd: physmap: fix wrong free and del_mtd_{partition,device}
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit 176bf2e0f10ecf1d20a97db3bd5bb2e6ba0b5668 ("physmap: fix leak of
memory returned by parse_mtd_partitions") deals with a memory leak and
frees the pointer array of mtd_partition after the call to
add_mtd_partitions().  the problem is that mtd_table[x]->name still points
to the freed memory.

Aldo physmap_flash_remove() should call del_mtd_partitions() or
del_mtd_device() only once.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Reported-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Tested-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   38 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice
+++ a/drivers/mtd/maps/physmap.c
@@ -29,6 +29,7 @@ struct physmap_flash_info {
 	struct map_info		map[MAX_RESOURCES];
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
+	struct mtd_partition	*parts;
 #endif
 };
 
@@ -45,25 +46,26 @@ static int physmap_flash_remove(struct p
 
 	physmap_data = dev->dev.platform_data;
 
-#ifdef CONFIG_MTD_CONCAT
-	if (info->cmtd != info->mtd[0]) {
+#ifdef CONFIG_MTD_PARTITIONS
+	if (info->nr_parts) {
+		del_mtd_partitions(info->cmtd);
+		kfree(info->parts);
+	} else if (physmap_data->nr_parts)
+		del_mtd_partitions(info->cmtd);
+	else
 		del_mtd_device(info->cmtd);
+#else
+	del_mtd_device(info->cmtd);
+#endif
+
+#ifdef CONFIG_MTD_CONCAT
+	if (info->cmtd != info->mtd[0])
 		mtd_concat_destroy(info->cmtd);
-	}
 #endif
 
 	for (i = 0; i < MAX_RESOURCES; i++) {
-		if (info->mtd[i] != NULL) {
-#ifdef CONFIG_MTD_PARTITIONS
-			if (info->nr_parts || physmap_data->nr_parts)
-				del_mtd_partitions(info->mtd[i]);
-			else
-				del_mtd_device(info->mtd[i]);
-#else
-			del_mtd_device(info->mtd[i]);
-#endif
+		if (info->mtd[i] != NULL)
 			map_destroy(info->mtd[i]);
-		}
 	}
 	return 0;
 }
@@ -86,9 +88,6 @@ static int physmap_flash_probe(struct pl
 	int err = 0;
 	int i;
 	int devices_found = 0;
-#ifdef CONFIG_MTD_PARTITIONS
-	struct mtd_partition *parts;
-#endif
 
 	physmap_data = dev->dev.platform_data;
 	if (physmap_data == NULL)
@@ -167,10 +166,11 @@ static int physmap_flash_probe(struct pl
 		goto err_out;
 
 #ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
+	err = parse_mtd_partitions(info->cmtd, part_probe_types,
+				&info->parts, 0);
 	if (err > 0) {
-		add_mtd_partitions(info->cmtd, parts, err);
-		kfree(parts);
+		add_mtd_partitions(info->cmtd, info->parts, err);
+		info->nr_parts = err;
 		return 0;
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-rbtx4939-add-mtd-support-fix.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver.patch
mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch
atmel_serial-might-lose-modem-status-change.patch

