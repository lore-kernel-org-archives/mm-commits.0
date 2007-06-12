From: akpm@linux-foundation.org
Subject: + serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:15:19 -0700
Message-ID: <200706122115.l5CLFJiR021328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbXFLVPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 17:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial-convert-early_uart-to-earlycon-for-8250 ia64 fix
has been added to the -mm tree.  Its filename is
     serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial-convert-early_uart-to-earlycon-for-8250 ia64 fix
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

ia64: add extra preferred console for HCDP serial console

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/pcdp.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-ia64-fix drivers/firmware/pcdp.c
--- a/drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-ia64-fix
+++ a/drivers/firmware/pcdp.c
@@ -42,6 +42,7 @@ setup_serial_console(struct pcdp_uart *u
 		}
 	}
 
+	add_preferred_console("uart", 8250, &options[9]);
 	return setup_early_serial8250_console(options);
 #else
 	return -ENODEV;
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-assert-dtr-for-serial-console-devices.patch
