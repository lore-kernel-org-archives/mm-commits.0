From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-fix-bug-in-inbound-doorbell-handler.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:25 -0800
Message-ID: <20120306193525.81480A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:32865 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965251Ab2CFTf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix queue wrapping bug in inbound doorbell handler
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-bug-in-inbound-doorbell-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix queue wrapping bug in inbound doorbell handler

Fix a bug that causes a kernel panic when the number of received doorbells
is larger than number of entries in the inbound doorbell queue (current
default value = 512).

Another possible indication for this bug is large number of spurious
doorbells reported by tsi721 driver after reaching the queue size maximum.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>		[3.2.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-bug-in-inbound-doorbell-handler drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-bug-in-inbound-doorbell-handler
+++ a/drivers/rapidio/devices/tsi721.c
@@ -410,13 +410,14 @@ static void tsi721_db_dpc(struct work_st
 	 */
 	mport = priv->mport;
 
-	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE));
-	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
+	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE)) % IDB_QSIZE;
 
 	while (wr_ptr != rd_ptr) {
 		idb_entry = (u64 *)(priv->idb_base +
 					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
 		rd_ptr++;
+		rd_ptr %= IDB_QSIZE;
 		idb.msg = *idb_entry;
 		*idb_entry = 0;
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

