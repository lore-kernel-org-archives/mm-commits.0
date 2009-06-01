From: akpm@linux-foundation.org
Subject: [merged] icom-fixing-a-if-clause-spaghetti.patch removed from -mm tree
Date: Mon, 01 Jun 2009 12:57:14 -0700
Message-ID: <200906011957.n51JvEaA021642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbZFAT5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 15:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     icom: clean up an `if' clause
has been removed from the -mm tree.  Its filename was
     icom-fixing-a-if-clause-spaghetti.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: icom: clean up an `if' clause
From: Breno Leitao <leitao@linux.vnet.ibm.com>

adapter->version can only be ADAPTER_V2 or ADAPTER_V1.  So, that OR
operand in the "if" clause is nonsense and can be removed.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/icom.c~icom-fixing-a-if-clause-spaghetti drivers/serial/icom.c
--- a/drivers/serial/icom.c~icom-fixing-a-if-clause-spaghetti
+++ a/drivers/serial/icom.c
@@ -413,7 +413,7 @@ static void load_code(struct icom_port *
 	release_firmware(fw);
 
 	/* Set Hardware level */
-	if ((icom_port->adapter->version | ADAPTER_V2) == ADAPTER_V2)
+	if (icom_port->adapter->version == ADAPTER_V2)
 		writeb(V2_HARDWARE, &(icom_port->dram->misc_flags));
 
 	/* Start the processor in Adapter */
@@ -866,7 +866,7 @@ static irqreturn_t icom_interrupt(int ir
 	/* find icom_port for this interrupt */
 	icom_adapter = (struct icom_adapter *) dev_id;
 
-	if ((icom_adapter->version | ADAPTER_V2) == ADAPTER_V2) {
+	if (icom_adapter->version == ADAPTER_V2) {
 		int_reg = icom_adapter->base_addr + 0x8024;
 
 		adapter_interrupts = readl(int_reg);
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch
icom-converting-space-to-tabs.patch
icom-fix-compile-errors-when-defining-icom_trace.patch

