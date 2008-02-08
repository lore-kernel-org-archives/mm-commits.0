From: akpm@linux-foundation.org
Subject: - 8250_gsc-coding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:54 -0800
Message-ID: <200802082012.m18KCZYr010214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbYBHUum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     8250_gsc: coding style
has been removed from the -mm tree.  Its filename was
     8250_gsc-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_gsc: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_gsc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/serial/8250_gsc.c~8250_gsc-coding-style drivers/serial/8250_gsc.c
--- a/drivers/serial/8250_gsc.c~8250_gsc-coding-style
+++ a/drivers/serial/8250_gsc.c
@@ -25,8 +25,7 @@
 
 #include "8250.h"
 
-static int __init 
-serial_init_chip(struct parisc_device *dev)
+static int __init serial_init_chip(struct parisc_device *dev)
 {
 	struct uart_port port;
 	unsigned long address;
@@ -38,18 +37,17 @@ serial_init_chip(struct parisc_device *d
 		 * what we have here is a missing parent device, so tell
 		 * the user what they're missing.
 		 */
-		if (parisc_parent(dev)->id.hw_type != HPHW_IOA) {
-			printk(KERN_INFO "Serial: device 0x%lx not configured.\n"
+		if (parisc_parent(dev)->id.hw_type != HPHW_IOA)
+			printk(KERN_INFO
+				"Serial: device 0x%lx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
 				dev->hpa.start);
-		}
 		return -ENODEV;
 	}
 
 	address = dev->hpa.start;
-	if (dev->id.sversion != 0x8d) {
+	if (dev->id.sversion != 0x8d)
 		address += 0x800;
-	}
 
 	memset(&port, 0, sizeof(port));
 	port.iotype	= UPIO_MEM;
@@ -63,11 +61,12 @@ serial_init_chip(struct parisc_device *d
 
 	err = serial8250_register_port(&port);
 	if (err < 0) {
-		printk(KERN_WARNING "serial8250_register_port returned error %d\n", err);
+		printk(KERN_WARNING
+			"serial8250_register_port returned error %d\n", err);
 		iounmap(port.membase);
 		return err;
 	}
-        
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
