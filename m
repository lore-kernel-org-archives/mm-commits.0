From: akpm@linux-foundation.org
Subject: [merged] serial-fix-printk-format-specifiers-for-struct-uart_port-iobase.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:51 -0800
Message-ID: <200911131926.nADJQpWP029225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932187AbZKMT0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: fix printk format specifiers for struct uart_port::iobase
has been removed from the -mm tree.  Its filename was
     serial-fix-printk-format-specifiers-for-struct-uart_port-iobase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix printk format specifiers for struct uart_port::iobase
From: Lennert Buytenhek <buytenh@wantstofly.org>

struct uart_port::iobase is unsigned long, so use %lx as printk format
specifier.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/8250.c~serial-fix-printk-format-specifiers-for-struct-uart_port-iobase drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-fix-printk-format-specifiers-for-struct-uart_port-iobase
+++ a/drivers/serial/8250.c
@@ -1089,7 +1089,7 @@ static void autoconfig(struct uart_8250_
 	if (!up->port.iobase && !up->port.mapbase && !up->port.membase)
 		return;
 
-	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04x, 0x%p): ",
+	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04lx, 0x%p): ",
 		       serial_index(&up->port), up->port.iobase, up->port.membase);
 
 	/*
diff -puN drivers/serial/8250_pci.c~serial-fix-printk-format-specifiers-for-struct-uart_port-iobase drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-fix-printk-format-specifiers-for-struct-uart_port-iobase
+++ a/drivers/serial/8250_pci.c
@@ -2383,7 +2383,7 @@ pciserial_init_ports(struct pci_dev *dev
 			break;
 
 #ifdef SERIAL_DEBUG_PCI
-		printk(KERN_DEBUG "Setup PCI port: port %x, irq %d, type %d\n",
+		printk(KERN_DEBUG "Setup PCI port: port %lx, irq %d, type %d\n",
 		       serial_port.iobase, serial_port.irq, serial_port.iotype);
 #endif
 
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

linux-next.patch

