From: akpm@linux-foundation.org
Subject: + drivers-parport-parport_pcc-fix-id-print-of-a-device.patch
 added to -mm tree
Date: Wed, 04 Dec 2013 14:24:32 -0800
Message-ID: <529faba0.muAn7W2IupgSrVin%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3LDWYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:24:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, lee.howard@mainpine.com, greg@kroah.com, bigeasy@linutronix.de

Subject: + drivers-parport-parport_pcc-fix-id-print-of-a-device.patch added to -mm tree
To: bigeasy@linutronix.de,greg@kroah.com,lee.howard@mainpine.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:24:32 -0800


The patch titled
     Subject: drivers/parport/parport_pc.c: fix id print of a device
has been added to the -mm tree.  Its filename is
     drivers-parport-parport_pcc-fix-id-print-of-a-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-parport-parport_pcc-fix-id-print-of-a-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-parport-parport_pcc-fix-id-print-of-a-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: drivers/parport/parport_pc.c: fix id print of a device

Since commit 7106b4e3 ("8250: Oxford Semiconductor Devices") the debug
print of the device id does no longer match the real device if it is
located in the "enum" behind oxsemi_pcie_pport.  The reason is that the
code assumes that each id contains one entry in the PCI table.  The fix is
to lookup the currently used id from the id-> parameter.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Howard <lee.howard@mainpine.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/parport/parport_pc.c~drivers-parport-parport_pcc-fix-id-print-of-a-device drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~drivers-parport-parport_pcc-fix-id-print-of-a-device
+++ a/drivers/parport/parport_pc.c
@@ -2827,16 +2827,12 @@ static int parport_pc_pci_probe(struct p
 		if (irq == IRQ_NONE) {
 			printk(KERN_DEBUG
 	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx)\n",
-				parport_pc_pci_tbl[i + last_sio].vendor,
-				parport_pc_pci_tbl[i + last_sio].device,
-				io_lo, io_hi);
+				id->vendor, id->device, io_lo, io_hi);
 			irq = PARPORT_IRQ_NONE;
 		} else {
 			printk(KERN_DEBUG
 	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx), IRQ %d\n",
-				parport_pc_pci_tbl[i + last_sio].vendor,
-				parport_pc_pci_tbl[i + last_sio].device,
-				io_lo, io_hi, irq);
+				id->vendor, id->device, io_lo, io_hi, irq);
 		}
 		data->ports[count] =
 			parport_pc_probe_port(io_lo, io_hi, irq,
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

drivers-parport-parport_pcc-fix-id-print-of-a-device.patch
drivers-parport-parport_pcc-remove-double-pci-id-for-netmos.patch
linux-next.patch

