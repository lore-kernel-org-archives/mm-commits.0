From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-drivers-serial.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:20 -0700
Message-ID: <200705090250.l492oK5K009341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969819AbXEICuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/serial
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-drivers-serial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/serial
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/cpm_uart/cpm_uart_core.c |   12 ++++++------
 drivers/serial/s3c2410.c                |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~spin_lock_unlocked-cleanup-in-drivers-serial drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~spin_lock_unlocked-cleanup-in-drivers-serial
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -934,7 +934,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SMC1_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SMC1].port.lock),
 		},
 		.flags = FLAG_SMC,
 		.tx_nrfifos = TX_NUM_FIFO,
@@ -948,7 +948,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SMC2_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SMC2].port.lock),
 		},
 		.flags = FLAG_SMC,
 		.tx_nrfifos = TX_NUM_FIFO,
@@ -965,7 +965,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SCC1_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC1].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -979,7 +979,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SCC2_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC2].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -993,7 +993,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SCC3_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC3].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -1007,7 +1007,7 @@ struct uart_cpm_port cpm_uart_ports[UART
 			.irq		= SCC4_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC4].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
diff -puN drivers/serial/s3c2410.c~spin_lock_unlocked-cleanup-in-drivers-serial drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~spin_lock_unlocked-cleanup-in-drivers-serial
+++ a/drivers/serial/s3c2410.c
@@ -957,7 +957,7 @@ static struct uart_driver s3c24xx_uart_d
 static struct s3c24xx_uart_port s3c24xx_serial_ports[NR_PORTS] = {
 	[0] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[0].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX0,
 			.uartclk	= 0,
@@ -969,7 +969,7 @@ static struct s3c24xx_uart_port s3c24xx_
 	},
 	[1] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[1].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX1,
 			.uartclk	= 0,
@@ -983,7 +983,7 @@ static struct s3c24xx_uart_port s3c24xx_
 
 	[2] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[2].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX2,
 			.uartclk	= 0,
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-ia64.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
