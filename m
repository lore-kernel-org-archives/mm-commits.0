From: akpm@linux-foundation.org
Subject: + dm-fix-null-pointer-exception.patch added to -mm tree
Date: Mon, 08 Sep 2008 17:22:48 -0700
Message-ID: <200809090022.m890Mnmq017673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYIIAXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 20:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raspl@linux.vnet.ibm.com, agk@redhat.com


The patch titled
     dm: fix null pointer exception
has been added to the -mm tree.  Its filename is
     dm-fix-null-pointer-exception.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -934,7 +934,8 @@ int dm_table_any_congested(struct dm_tab
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
-		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+		if (q)
+			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 	}
 
 	return r;
@@ -948,7 +949,8 @@ void dm_table_unplug_all(struct dm_table
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
 
-		blk_unplug(q);
+		if (q)
+			blk_unplug(q);
 	}
 }
 
_

Patches currently in -mm which might be from raspl@linux.vnet.ibm.com are

dm-fix-null-pointer-exception.patch

