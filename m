From: akpm@linux-foundation.org
Subject: - x86-add-workaround-for-bug-in-asus-a7v600-bios-rev-1005.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:43 -0700
Message-ID: <200806081949.m58JnhqM017705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684AbYFHTuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: int-e@gmx.de, alan@redhat.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     x86: add workaround for bug in ASUS A7V600 BIOS (rev 1005)
has been removed from the -mm tree.  Its filename was
     x86-add-workaround-for-bug-in-asus-a7v600-bios-rev-1005.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add workaround for bug in ASUS A7V600 BIOS (rev 1005)
From: Bertram Felgenhauer <int-e@gmx.de>

This BIOS claims the VIA 8237 south bridge to be compatible with VIA 586,
which it is not.

Without this patch, I get the following warning while booting,
among others,

| PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
| ------------[ cut here ]------------
| WARNING: at arch/x86/pci/irq.c:265 pirq_via586_get+0x4a/0x60()
| Modules linked in:
| Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00015-g1ec7d99 #1
|  [<c0119fd4>] warn_on_slowpath+0x54/0x70
|  [<c02246e0>] ? vt_console_print+0x210/0x2b0
|  [<c02244d0>] ? vt_console_print+0x0/0x2b0
|  [<c011a413>] ? __call_console_drivers+0x43/0x60
|  [<c011a482>] ? _call_console_drivers+0x52/0x80
|  [<c011aa89>] ? release_console_sem+0x1c9/0x200
|  [<c0291d21>] ? raw_pci_read+0x41/0x70
|  [<c0291e8f>] ? pci_read+0x2f/0x40
|  [<c029151a>] pirq_via586_get+0x4a/0x60
|  [<c02914d0>] ? pirq_via586_get+0x0/0x60
|  [<c029178d>] pcibios_lookup_irq+0x15d/0x430
|  [<c03b895a>] pcibios_irq_init+0x17a/0x3e0
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c03a6763>] kernel_init+0x73/0x250
|  [<c03b87e0>] ? pcibios_irq_init+0x0/0x3e0
|  [<c0114d00>] ? schedule_tail+0x10/0x40
|  [<c0102dee>] ? ret_from_fork+0x6/0x1c
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c010324b>] kernel_thread_helper+0x7/0x1c
|  =======================
| ---[ end trace 4eaa2a86a8e2da22 ]---

and IRQ trouble later,

| irq 10: nobody cared (try booting with the "irqpoll" option)

Now that's an VIA 8237 chip, so pirq_via586_get shouldn't be called
at all; adding this workaround to via_router_probe() fixes the
problem for me.

Amazingly I have a 2.6.23.8 kernel that somehow works fine ... I'll
never understand why.

Signed-off-by: Bertram Felgenhauer <int-e@gmx.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/pci/irq.c~x86-add-workaround-for-bug-in-asus-a7v600-bios-rev-1005 arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-add-workaround-for-bug-in-asus-a7v600-bios-rev-1005
+++ a/arch/x86/pci/irq.c
@@ -646,6 +646,13 @@ static __init int via_router_probe(struc
 			 */
 			device = PCI_DEVICE_ID_VIA_8235;
 			break;
+		case PCI_DEVICE_ID_VIA_8237:
+			/**
+			 * Asus a7v600 bios wrongly reports 8237
+			 * as 586-compatible
+			 */
+			device = PCI_DEVICE_ID_VIA_8237;
+			break;
 		}
 	}
 
_

Patches currently in -mm which might be from int-e@gmx.de are

origin.patch

