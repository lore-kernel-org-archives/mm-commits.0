From: akpm@linux-foundation.org
Subject: + dm-allow-offline-devices.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:48 -0700
Message-ID: <200705090054.l490smZr006377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968397AbXEIAzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andmike@us.ibm.com, agk@redhat.com


The patch titled
     dm: allow offline devices
has been added to the -mm tree.  Its filename is
     dm-allow-offline-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 4 deletions(-)

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

dm-allow-offline-devices.patch
