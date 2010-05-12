From: akpm@linux-foundation.org
Subject: [merged] mmc-atmel-mci-fix-in-debugfs-response-value-printing.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:20 -0400
Message-ID: <201005121759.o4CHxmpL011532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab0ELSDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:03:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: atmel-mci: fix in debugfs: response value printing
has been removed from the -mm tree.  Its filename was
     mmc-atmel-mci-fix-in-debugfs-response-value-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: atmel-mci: fix in debugfs: response value printing
From: Nicolas Ferre <nicolas.ferre@atmel.com>

In debugfs, printing of command response reports resp[2] twice: fix it to
resp[3].

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-fix-in-debugfs-response-value-printing drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-fix-in-debugfs-response-value-printing
+++ a/drivers/mmc/host/atmel-mci.c
@@ -266,7 +266,7 @@ static int atmci_req_show(struct seq_fil
 				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
 				cmd->opcode, cmd->arg, cmd->flags,
 				cmd->resp[0], cmd->resp[1], cmd->resp[2],
-				cmd->resp[2], cmd->error);
+				cmd->resp[3], cmd->error);
 		if (data)
 			seq_printf(s, "DATA %u / %u * %u flg %x err %d\n",
 				data->bytes_xfered, data->blocks,
@@ -276,7 +276,7 @@ static int atmci_req_show(struct seq_fil
 				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
 				stop->opcode, stop->arg, stop->flags,
 				stop->resp[0], stop->resp[1], stop->resp[2],
-				stop->resp[2], stop->error);
+				stop->resp[3], stop->error);
 	}
 
 	spin_unlock_bh(&slot->host->lock);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

