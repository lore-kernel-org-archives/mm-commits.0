From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-fix-inbound-doorbell-interrupt-handling.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:28:57 -0700
Message-ID: <20120820212858.BA9E45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54132 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2HTV3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:29:03 -0400
Received: by eaac1 with SMTP id c1so312674eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:28:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix inbound doorbell interrupt handling
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-inbound-doorbell-interrupt-handling.patch

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
Subject: rapidio/tsi721: fix inbound doorbell interrupt handling

Make sure that there is no doorbell messages left behind due to disabled
interrupts during inbound doorbell processing.

The most common case for this bug is loss of rionet JOIN messages in
systems with three or more rionet participants and MSI or MSI-X enabled. 
As result, requests for packet transfers may finish with "destination
unreachable" error message.

This patch is applicable to kernel versions starting from v3.2.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-inbound-doorbell-interrupt-handling drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-inbound-doorbell-interrupt-handling
+++ a/drivers/rapidio/devices/tsi721.c
@@ -435,6 +435,9 @@ static void tsi721_db_dpc(struct work_st
 				" info %4.4x\n", DBELL_SID(idb.bytes),
 				DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
 		}
+
+		wr_ptr = ioread32(priv->regs +
+				  TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
 	}
 
 	iowrite32(rd_ptr & (IDB_QSIZE - 1),
@@ -445,6 +448,10 @@ static void tsi721_db_dpc(struct work_st
 	regval |= TSI721_SR_CHINT_IDBQRCV;
 	iowrite32(regval,
 		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
+	if (wr_ptr != rd_ptr)
+		schedule_work(&priv->idb_work);
 }
 
 /**
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-inbound-doorbell-interrupt-handling.patch
rapidio-tsi721-fix-unused-variable-compiler-warning.patch

