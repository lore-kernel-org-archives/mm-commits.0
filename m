From: akpm@linux-foundation.org
Subject: + mtd-physmap-fix-null-pointer-dereference-in-error-path.patch added to -mm tree
Date: Fri, 06 Mar 2009 13:39:36 -0800
Message-ID: <200903062139.n26LdaOW001831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbZCFVl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 16:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, philipp.zabel@gmail.com, rjw@sisk.pl


The patch titled
     mtd: physmap: fix NULL pointer dereference in error path
has been added to the -mm tree.  Its filename is
     mtd-physmap-fix-null-pointer-dereference-in-error-path.patch

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

mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver-v2.patch
mtd-physmap-fix-null-pointer-dereference-in-error-path.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

