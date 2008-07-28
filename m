From: akpm@linux-foundation.org
Subject: - mtdpart-fix-a-division-by-zero-bug.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:33 -0700
Message-ID: <200807282111.m6SLBXxI027687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761230AbYG1VMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     mtdpart: fix a division by zero bug
has been removed from the -mm tree.  Its filename was
     mtdpart-fix-a-division-by-zero-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtdpart: fix a division by zero bug
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

When detecting a partition beyond the end of the device, skip most of the
initialisation, in particular those bits causing a division by zero.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdpart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/mtdpart.c~mtdpart-fix-a-division-by-zero-bug drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~mtdpart-fix-a-division-by-zero-bug
+++ a/drivers/mtd/mtdpart.c
@@ -411,11 +411,12 @@ static struct mtd_part *add_one_partitio
 
 	/* let's do some sanity checks */
 	if (slave->offset >= master->size) {
-			/* let's register it anyway to preserve ordering */
+		/* let's register it anyway to preserve ordering */
 		slave->offset = 0;
 		slave->mtd.size = 0;
 		printk(KERN_ERR"mtd: partition \"%s\" is out of reach -- disabled\n",
 			part->name);
+		goto out_register;
 	}
 	if (slave->offset + slave->mtd.size > master->size) {
 		slave->mtd.size = master->size - slave->offset;
@@ -475,6 +476,7 @@ static struct mtd_part *add_one_partitio
 		}
 	}
 
+out_register:
 	if (part->mtdp) {
 		/* store the object pointer (caller may or may not register it*/
 		*part->mtdp = &slave->mtd;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
gpio-fix-build-on-config_gpio_sysfs=n.patch
linux-next.patch
mtdpart-handle-remaining-checkpatch-findings.patch

