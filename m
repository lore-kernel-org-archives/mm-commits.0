From: akpm@linux-foundation.org
Subject: - cciss-fix-for-2tb-support-again.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:59:30 -0800
Message-ID: <200703060059.l260xV2s006941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbXCFBCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix for 2TB support (again)
has been removed from the -mm tree.  Its filename was
     cciss-fix-for-2tb-support-again.patch

This patch was dropped because it was folded into cciss-fix-for-2tb-support.patch

------------------------------------------------------
Subject: cciss: fix for 2TB support (again)
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch changes the constant 0xFFFFFFFF to 0xFFFFFFFFULL to prevent sign extension.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-for-2tb-support-again drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-for-2tb-support-again
+++ a/drivers/block/cciss.c
@@ -1303,7 +1303,7 @@ static void cciss_update_drive_info(int 
 
   	/* if read_capacity returns all F's this volume is >2TB in size */
   	/* so we switch to 16-byte CDB's for all read/write ops */
-  	if (total_size == 0xFFFFFFFF) {
+  	if (total_size == 0xFFFFFFFFULL) {
 		cciss_read_capacity_16(ctlr, drv_index, 1,
 		&total_size, &block_size);
 		h->cciss_read = CCISS_READ_16;
@@ -3123,7 +3123,7 @@ static void cciss_getgeometry(int cntl_n
 
 		/* If read_capacity returns all F's the logical is >2TB */
 		/* so we switch to 16-byte CDBs for all read/write ops */
-		if(total_size == 0xFFFFFFFF) {
+		if(total_size == 0xFFFFFFFFULL) {
 			cciss_read_capacity_16(cntl_num, i, 0,
 			&total_size, &block_size);
 			hba[cntl_num]->cciss_read = CCISS_READ_16;
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-fix-for-2tb-support.patch
cciss-fix-for-2tb-support-again.patch
cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch
