From: akpm@linux-foundation.org
Subject: - m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:45 -0800
Message-ID: <200802012229.m11MTjGI001822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261AbYBAWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: cleanup port field access from uart struct in Coldfire serial driver
has been removed from the -mm tree.  Its filename was
     m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: cleanup port field access from uart struct in Coldfire serial driver
From: Greg Ungerer <gerg@snapgear.com>

Use port field instead of silly struct/pointer casting to get at port struct
from local uart struct in ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mcf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/mcf.c~m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver
+++ a/drivers/serial/mcf.c
@@ -273,7 +273,7 @@ static void mcf_set_termios(struct uart_
 
 static void mcf_rx_chars(struct mcf_uart *pp)
 {
-	struct uart_port *port = (struct uart_port *) pp;
+	struct uart_port *port = &pp->port;
 	unsigned char status, ch, flag;
 
 	while ((status = readb(port->membase + MCFUART_USR)) & MCFUART_USR_RXREADY) {
@@ -319,7 +319,7 @@ static void mcf_rx_chars(struct mcf_uart
 
 static void mcf_tx_chars(struct mcf_uart *pp)
 {
-	struct uart_port *port = (struct uart_port *) pp;
+	struct uart_port *port = &pp->port;
 	struct circ_buf *xmit = &port->info->xmit;
 
 	if (port->x_char) {
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
