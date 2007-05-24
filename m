From: akpm@linux-foundation.org
Subject: - serial-set-dtr-in-uart-for-kernel-serial-console.patch removed from -mm tree
Date: Thu, 24 May 2007 02:06:43 -0700
Message-ID: <200705240906.l4O96ksB022982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbXEXJHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 05:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: set DTR in uart for kernel serial console
has been removed from the -mm tree.  Its filename was
     serial-set-dtr-in-uart-for-kernel-serial-console.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: serial: set DTR in uart for kernel serial console
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Some UARTs on other side need host uart DTR is set, otherwise will not
receive char from the host that kernel is runing during kernel boot stage.

BTW: earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/serial/8250.c~serial-set-dtr-in-uart-for-kernel-serial-console drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-set-dtr-in-uart-for-kernel-serial-console
+++ a/drivers/serial/8250.c
@@ -2397,6 +2397,12 @@ static void __init serial8250_isa_init_p
 		up->mcr_force = ALPHA_KLUDGE_MCR;
 
 		up->port.ops = &serial8250_pops;
+
+		/*
+		 * Some uarts on other side don't support no flow control.  So
+		 * we set DTR in host uart to make them happy  --- YHLU
+		 */
+		up->port.mctrl |= TIOCM_DTR;
 	}
 
 	for (i = 0, up = serial8250_ports;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
