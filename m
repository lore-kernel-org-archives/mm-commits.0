From: akpm@linux-foundation.org
Subject: + serial-keep-the-dtr-setting-for-serial-console.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:50:15 -0700
Message-ID: <200708201950.l7KJoFNc019863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbXHTTvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial: keep the DTR setting for serial console.
has been added to the -mm tree.  Its filename is
     serial-keep-the-dtr-setting-for-serial-console.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: keep the DTR setting for serial console.
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

with reverting "x86, serial: convert legacy COM ports to platform devices",
we will have the serial console before the port is probled again.

uart_add_one_port==>uart_configure_port==>set_mcttrl(port, 0) will clear
the DTR setting by uart_set_options().  then I will lose my output from
serial console again.

So try to keep DTR in uart_configure_port()

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-keep-the-dtr-setting-for-serial-console drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-keep-the-dtr-setting-for-serial-console
+++ a/drivers/serial/serial_core.c
@@ -2120,10 +2120,11 @@ uart_configure_port(struct uart_driver *
 
 		/*
 		 * Ensure that the modem control lines are de-activated.
+		 * keep the DTR setting that is set in uart_set_options()
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, 0);
+		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-keep-the-dtr-setting-for-serial-console.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
