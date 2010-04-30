From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-fix-in-debugfs-response-value-printing.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:29:35 -0700
Message-ID: <201004301929.o3UJTZsg007368__34388.7311792516$1272655907$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab0D3T34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:29:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: atmel-mci: fix in debugfs: response value printing
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-fix-in-debugfs-response-value-printing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mmc-atmel-mci-fix-two-parameters-swapped.patch
mmc-atmel-mci-prevent-kernel-oops-while-removing-card.patch
mmc-atmel-mci-remove-data-error-interrupt-after-xfer.patch
mmc-atmel-mci-fix-in-debugfs-response-value-printing.patch
linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

