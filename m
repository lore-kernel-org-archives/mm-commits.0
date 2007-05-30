From: akpm@linux-foundation.org
Subject: + console-console-handover-to-preferred-console.patch added to -mm tree
Date: Wed, 30 May 2007 11:59:35 -0700
Message-ID: <200705301859.l4UIxZQ9002208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754853AbXE3S7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     console: console handover to preferred console
has been added to the -mm tree.  Its filename is
     console-console-handover-to-preferred-console.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: console: console handover to preferred console
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

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

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
