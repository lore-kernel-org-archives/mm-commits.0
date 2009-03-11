From: akpm@linux-foundation.org
Subject: [merged] mtd-physmap-fix-null-pointer-dereference-in-error-path.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:43 -0700
Message-ID: <200903111809.n2BI9hj5019984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbZCKSNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, philipp.zabel@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     mtd: physmap: fix NULL pointer dereference in error path
has been removed from the -mm tree.  Its filename was
     mtd-physmap-fix-null-pointer-dereference-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: physmap: fix NULL pointer dereference in error path
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit e480814f138cd5d78a8efe397756ba6b6518fdb6 ("[MTD] [MAPS] physmap:
fix wrong free and del_mtd_{partition,device}") introduces a NULL pointer
dereference in physmap_flash_remove when called from the error path in
physmap_flash_probe (if map_probe failed).

Call del_mtd_{partition,device} only if info->cmtd was not NULL.

Reported-by: pHilipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~mtd-physmap-fix-null-pointer-dereference-in-error-path drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-physmap-fix-null-pointer-dereference-in-error-path
+++ a/drivers/mtd/maps/physmap.c
@@ -46,16 +46,19 @@ static int physmap_flash_remove(struct p
 
 	physmap_data = dev->dev.platform_data;
 
+	if (info->cmtd) {
 #ifdef CONFIG_MTD_PARTITIONS
-	if (info->nr_parts) {
-		del_mtd_partitions(info->cmtd);
-		kfree(info->parts);
-	} else if (physmap_data->nr_parts)
-		del_mtd_partitions(info->cmtd);
-	else
-		del_mtd_device(info->cmtd);
+		if (info->nr_parts || physmap_data->nr_parts)
+			del_mtd_partitions(info->cmtd);
+		else
+			del_mtd_device(info->cmtd);
 #else
-	del_mtd_device(info->cmtd);
+		del_mtd_device(info->cmtd);
+#endif
+	}
+#ifdef CONFIG_MTD_PARTITIONS
+	if (info->nr_parts)
+		kfree(info->parts);
 #endif
 
 #ifdef CONFIG_MTD_CONCAT
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver-v2.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

