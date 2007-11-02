From: akpm@linux-foundation.org
Subject: + m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:16 -0700
Message-ID: <200711022135.lA2LZGpt011996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbXKBVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: cleanup port field access from uart struct in Coldfire serial driver
has been added to the -mm tree.  Its filename is
     m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
