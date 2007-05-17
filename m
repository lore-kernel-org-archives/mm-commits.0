From: akpm@linux-foundation.org
Subject: + serial-set-dtr-in-uart-for-kernel-serial-console.patch added to -mm tree
Date: Thu, 17 May 2007 11:33:52 -0700
Message-ID: <200705171833.l4HIXrh9030072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbXEQSiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial: set DTR in uart for kernel serial console
has been added to the -mm tree.  Its filename is
     serial-set-dtr-in-uart-for-kernel-serial-console.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/serial/8250.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/serial/8250.c~serial-set-dtr-in-uart-for-kernel-serial-console drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-set-dtr-in-uart-for-kernel-serial-console
+++ a/drivers/serial/8250.c
@@ -2397,6 +2397,11 @@ static void __init serial8250_isa_init_p
 		up->mcr_force = ALPHA_KLUDGE_MCR;
 
 		up->port.ops = &serial8250_pops;
+
+		/* some uarts on other side don't support no flow control. So we set
+		 * DTR in host uart to make them happy  --- YHLU
+		 */
+		up->port.mctrl |= TIOCM_DTR;
 	}
 
 	for (i = 0, up = serial8250_ports;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-set-dtr-in-uart-for-kernel-serial-console.patch
