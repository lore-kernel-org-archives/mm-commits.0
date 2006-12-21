From: akpm@osdl.org
Subject: - cciss-set-default-raid-level-when-reading-geometry-fails.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:37:05 -0800
Message-ID: <200612210037.kBL0b5K7011266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161104AbWLUAhK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: set default raid level when reading geometry fails
has been removed from the -mm tree.  Its filename was
     cciss-set-default-raid-level-when-reading-geometry-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: set default raid level when reading geometry fails
From: Mike Miller <mike.miller@hp.com>

Set a default raid level on a volume that either does not support reading the
geometry or reports an invalid geometry for whatever reason.  We were always
setting some values for heads and sectors but never set a raid level.  This
caused lots of problems on some buggy firmware.  Please consider this for
inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-set-default-raid-level-when-reading-geometry-fails drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-set-default-raid-level-when-reading-geometry-fails
+++ a/drivers/block/cciss.c
@@ -1907,6 +1907,7 @@ static void cciss_geometry_inquiry(int c
 			       "does not support reading geometry\n");
 			drv->heads = 255;
 			drv->sectors = 32;	// Sectors per track
+			drv->raid_level = RAID_UNKNOWN;
 		} else {
 			drv->heads = inq_buff->data_byte[6];
 			drv->sectors = inq_buff->data_byte[7];
_

Patches currently in -mm which might be from mike.miller@hp.com are

git-block.patch

