From: akpm@osdl.org
Subject: - cciss-change-cciss_open-for-consistency.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:33 -0800
Message-ID: <200612072300.kB7N0Xx7029650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51281 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163733AbWLGXAu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: change cciss_open for consistency
has been removed from the -mm tree.  Its filename was
     cciss-change-cciss_open-for-consistency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: change cciss_open for consistency
From: Mike Miller <mike.miller@hp.com>

Change our open to test for drv->heads like we do in other places in the
driver.  Mostly for consistency.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-change-cciss_open-for-consistency drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-change-cciss_open-for-consistency
+++ a/drivers/block/cciss.c
@@ -494,7 +494,7 @@ static int cciss_open(struct inode *inod
 	 * but I'm already using way to many device nodes to claim another one
 	 * for "raw controller".
 	 */
-	if (drv->nr_blocks == 0) {
+	if (drv->heads == 0) {
 		if (iminor(inode) != 0) {	/* not node 0? */
 			/* if not node 0 make sure it is a partition = 0 */
 			if (iminor(inode) & 0x0f) {
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

