From: akpm@linux-foundation.org
Subject: + parport_serial-use-the-pci-irq-if-offered.patch added to -mm tree
Date: Thu, 15 Jul 2010 11:40:30 -0700
Message-ID: <201007151840.o6FIeVHH012421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934111Ab0GOSk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 14:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fbriere@fbriere.net, alan@lxorguk.ukuu.org.uk


The patch titled
     parport_serial: use the PCI IRQ if offered
has been added to the -mm tree.  Its filename is
     parport_serial-use-the-pci-irq-if-offered.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: parport_serial: use the PCI IRQ if offered
=46rom: Fr=E9d=E9ric Bri=E8re <fbriere@fbriere.net>

Commit 51dcdfe ("parport: Use the PCI IRQ if offered") added IRQ suppor=
t
for PCI parallel port devices handled by parport_pc, but turned it off =
for
parport_serial, despite a printk() message to the contrary.

Signed-off-by: Fr=E9d=E9ric Bri=E8re <fbriere@fbriere.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_serial.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/parport/parport_serial.c~parport_serial-use-the-pci-i=
rq-if-offered drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport_serial-use-the-pci-irq-i=
f-offered
+++ a/drivers/parport/parport_serial.c
@@ -342,7 +342,6 @@ static int __devinit parport_register (s
 			dev_dbg(&dev->dev,
 		"PCI parallel port detected: I/O at %#lx(%#lx), IRQ %d\n",
 				io_lo, io_hi, irq);
-			irq =3D PARPORT_IRQ_NONE;
 		}
 		port =3D parport_pc_probe_port (io_lo, io_hi, irq,
 			      PARPORT_DMA_NONE, &dev->dev, IRQF_SHARED);
_

Patches currently in -mm which might be from fbriere@fbriere.net are

parport_serial-use-the-pci-irq-if-offered.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
