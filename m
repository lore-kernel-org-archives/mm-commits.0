From: akpm@linux-foundation.org
Subject: [merged] dm-table-pass-devices-data-start-to-blk_stack_limits-in-bytes.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:28:18 -0700
Message-ID: <200907011728.n61HSIBw003223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbZGAR2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, elendil@planet.nl, jean.luc.coulon@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     dm table: pass device's data start to blk_stack_limits() in bytes
has been removed from the -mm tree.  Its filename was
     dm-table-pass-devices-data-start-to-blk_stack_limits-in-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm table: pass device's data start to blk_stack_limits() in bytes
From: Mike Snitzer <snitzer@redhat.com>

The offset passed to blk_stack_limits() must be in bytes not sectors. 
Fixes false warnings like the following: device-mapper: table: 254:1:
target device sda6 is misaligned

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13641

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-table.c~dm-table-pass-devices-data-start-to-blk_stack_limits-in-bytes drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-table-pass-devices-data-start-to-blk_stack_limits-in-bytes
+++ a/drivers/md/dm-table.c
@@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_targe
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start) < 0)
+	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
 		DMWARN("%s: target device %s is misaligned",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 
_

Patches currently in -mm which might be from snitzer@redhat.com are

origin.patch
linux-next.patch

