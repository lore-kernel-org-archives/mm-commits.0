From: akpm@linux-foundation.org
Subject: [merged] icom-removing-unused-variables.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:25 -0700
Message-ID: <200903182248.n2IMmPWf020345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbZCRWvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     icom: remove unused variables
has been removed from the -mm tree.  Its filename was
     icom-removing-unused-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: icom: remove unused variables
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/serial/icom.c~icom-removing-unused-variables drivers/serial/icom.c
--- a/drivers/serial/icom.c~icom-removing-unused-variables
+++ a/drivers/serial/icom.c
@@ -1098,7 +1098,6 @@ static void icom_set_termios(struct uart
 {
 	int baud;
 	unsigned cflag, iflag;
-	int bits;
 	char new_config2;
 	char new_config3 = 0;
 	char tmp_byte;
@@ -1119,34 +1118,27 @@ static void icom_set_termios(struct uart
 	switch (cflag & CSIZE) {
 	case CS5:		/* 5 bits/char */
 		new_config2 |= ICOM_ACFG_5BPC;
-		bits = 7;
 		break;
 	case CS6:		/* 6 bits/char */
 		new_config2 |= ICOM_ACFG_6BPC;
-		bits = 8;
 		break;
 	case CS7:		/* 7 bits/char */
 		new_config2 |= ICOM_ACFG_7BPC;
-		bits = 9;
 		break;
 	case CS8:		/* 8 bits/char */
 		new_config2 |= ICOM_ACFG_8BPC;
-		bits = 10;
 		break;
 	default:
-		bits = 10;
 		break;
 	}
 	if (cflag & CSTOPB) {
 		/* 2 stop bits */
 		new_config2 |= ICOM_ACFG_2STOP_BIT;
-		bits++;
 	}
 	if (cflag & PARENB) {
 		/* parity bit enabled */
 		new_config2 |= ICOM_ACFG_PARITY_ENAB;
 		trace(ICOM_PORT, "PARENB", 0);
-		bits++;
 	}
 	if (cflag & PARODD) {
 		/* odd parity */
@@ -1322,7 +1314,6 @@ static struct uart_driver icom_uart_driv
 static int __devinit icom_init_ports(struct icom_adapter *icom_adapter)
 {
 	u32 subsystem_id = icom_adapter->subsystem_id;
-	int retval = 0;
 	int i;
 	struct icom_port *icom_port;
 
@@ -1368,7 +1359,7 @@ static int __devinit icom_init_ports(str
 		}
 	}
 
-	return retval;
+	return 0;
 }
 
 static void icom_port_active(struct icom_port *icom_port, struct icom_adapter *icom_adapter, int port_num)
@@ -1391,7 +1382,6 @@ static int __devinit icom_load_ports(str
 {
 	struct icom_port *icom_port;
 	int port_num;
-	int retval;
 
 	for (port_num = 0; port_num < icom_adapter->numb_ports; port_num++) {
 
@@ -1405,7 +1395,7 @@ static int __devinit icom_load_ports(str
 			icom_port->adapter = icom_adapter;
 
 			/* get port memory */
-			if ((retval = get_port_memory(icom_port)) != 0) {
+			if (get_port_memory(icom_port) != 0) {
 				dev_err(&icom_port->adapter->pci_dev->dev,
 					"Memory allocation for port FAILED\n");
 			}
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch
jsm-cleanup.patch
icom-converting-space-to-tabs.patch

