From: akpm@linux-foundation.org
Subject: - m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:43 -0800
Message-ID: <200802012229.m11MThbj001819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbYBAWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use container_of() to access uart struct in Coldfire serial driver
has been removed from the -mm tree.  Its filename was
     m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
