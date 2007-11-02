From: akpm@linux-foundation.org
Subject: + m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:14 -0700
Message-ID: <200711022135.lA2LZEPx011993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbXKBVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: use container_of() to access uart struct in Coldfire serial driver
has been added to the -mm tree.  Its filename is
     m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: use container_of() to access uart struct in Coldfire serial driver
From: Greg Ungerer <gerg@snapgear.com>

Use container_of() to get at uart struct field in port struct in ColdFire
serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mcf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/serial/mcf.c~m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver
+++ a/drivers/serial/mcf.c
@@ -69,7 +69,7 @@ static unsigned int mcf_tx_empty(struct 
 
 static unsigned int mcf_get_mctrl(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 	unsigned int sigs;
 
@@ -87,7 +87,7 @@ static unsigned int mcf_get_mctrl(struct
 
 static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -104,7 +104,7 @@ static void mcf_set_mctrl(struct uart_po
 
 static void mcf_start_tx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -117,7 +117,7 @@ static void mcf_start_tx(struct uart_por
 
 static void mcf_stop_tx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -130,7 +130,7 @@ static void mcf_stop_tx(struct uart_port
 
 static void mcf_stop_rx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -163,7 +163,7 @@ static void mcf_enable_ms(struct uart_po
 
 static int mcf_startup(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -189,7 +189,7 @@ static int mcf_startup(struct uart_port 
 
 static void mcf_shutdown(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -352,7 +352,7 @@ static void mcf_tx_chars(struct mcf_uart
 static irqreturn_t mcf_interrupt(int irq, void *data)
 {
 	struct uart_port *port = data;
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
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
