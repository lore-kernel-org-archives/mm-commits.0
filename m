From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-fix-bug-in-inbound-doorbell-handler.patch added to -mm tree
Date: Mon, 05 Mar 2012 12:37:21 -0800
Message-ID: <20120305203721.AA269A0313@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57087 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030187Ab2CEUhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Mar 2012 15:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, chul.kim@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix bug in inbound doorbell handler
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-bug-in-inbound-doorbell-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix bug in inbound doorbell handler

Fixes queue wrapping bug in Inbound Doorbell handling routine.

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
Subject: Subject: rapidio/tsi721: fix bug in inbound doorbell handler

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-bug-in-inbound-doorbell-handler.patch

