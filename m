From: akpm@linux-foundation.org
Subject: - dm-fix-null-pointer-exception.patch removed from -mm tree
Date: Tue, 07 Oct 2008 13:35:39 -0700
Message-ID: <200810072035.m97KZdse031950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062AbYJGUha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 16:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raspl@linux.vnet.ibm.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: fix null pointer exception
has been removed from the -mm tree.  Its filename was
     dm-fix-null-pointer-exception.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm: fix null pointer exception
From: Stefan Raspl <raspl@linux.vnet.ibm.com>

needs a changelog.

Signed-off-by: Stefan Raspl <raspl@linux.vnet.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-table.c~dm-fix-null-pointer-exception drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-fix-null-pointer-exception
+++ a/drivers/md/dm-table.c
@@ -941,7 +941,8 @@ int dm_table_any_congested(struct dm_tab
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
-		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+		if (q)
+			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 	}
 
 	return r;
@@ -955,7 +956,8 @@ void dm_table_unplug_all(struct dm_table
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
 
-		blk_unplug(q);
+		if (q)
+			blk_unplug(q);
 	}
 }
 
_

Patches currently in -mm which might be from raspl@linux.vnet.ibm.com are

git-scsi.patch
dm-fix-null-pointer-exception.patch

