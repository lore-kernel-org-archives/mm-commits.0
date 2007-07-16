From: akpm@linux-foundation.org
Subject: - console-console-handover-to-preferred-console.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:30 -0700
Message-ID: <200707162048.l6GKmUF4001043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbXGPUsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     console: console handover to preferred console
has been removed from the -mm tree.  Its filename was
     console-console-handover-to-preferred-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: console: console handover to preferred console
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

for earlyprintk=ttyS0,9600 console=tty0 console=ttyS0,9600n8

the handover will happen from earlyser0 to tty0.  but what we want is to
hand over to ttyS0.

Later with serial-convert-early_uart-to-earlycon-for-8250.patch,

	console=tty0 console=uart8250,io,0x3f8,9600n8

will handover to ttyS0 instead of tty0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~console-console-handover-to-preferred-console kernel/printk.c
--- a/kernel/printk.c~console-console-handover-to-preferred-console
+++ a/kernel/printk.c
@@ -985,12 +985,15 @@ void register_console(struct console *co
 	if (!(console->flags & CON_ENABLED))
 		return;
 
-	if (bootconsole) {
+	if (bootconsole && (console->flags & CON_CONSDEV)) {
 		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
 		       bootconsole->name, bootconsole->index,
 		       console->name, console->index);
 		unregister_console(bootconsole);
 		console->flags &= ~CON_PRINTBUFFER;
+	} else {
+		printk(KERN_INFO "console [%s%d] enabled\n",
+		       console->name, console->index);
 	}
 
 	/*
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
