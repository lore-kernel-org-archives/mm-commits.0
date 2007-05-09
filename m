From: akpm@linux-foundation.org
Subject: - dm-allow-offline-devices.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:44 -0700
Message-ID: <200705092148.l49Lmiot002622@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759360AbXEIVsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andmike@us.ibm.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: allow offline devices
has been removed from the -mm tree.  Its filename was
     dm-allow-offline-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: allow offline devices
From: Mike Anderson <andmike@us.ibm.com>

Allow check_device_area to succeed if a device has an i_size of zero.  This
addresses an issue seen on DASD devices setting up a multipath table for paths
in online and offline state.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-table.c~dm-allow-offline-devices drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-allow-offline-devices
+++ a/drivers/md/dm-table.c
@@ -425,13 +425,15 @@ static void close_dev(struct dm_dev *d, 
 }
 
 /*
- * If possible (ie. blk_size[major] is set), this checks an area
- * of a destination device is valid.
+ * If possible, this checks an area of a destination device is valid.
  */
 static int check_device_area(struct dm_dev *dd, sector_t start, sector_t len)
 {
-	sector_t dev_size;
-	dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+
+	if (!dev_size)
+		return 1;
+
 	return ((start < dev_size) && (len <= (dev_size - start)));
 }
 
_

Patches currently in -mm which might be from andmike@us.ibm.com are

origin.patch
