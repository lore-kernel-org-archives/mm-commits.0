From: akpm@linux-foundation.org
Subject: + dz-dont-panic-when-request_irq-fails.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:25:56 -0700
Message-ID: <200710192125.l9JLPuUv020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934007AbXJSV0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: don't panic() when request_irq() fails
has been added to the -mm tree.  Its filename is
     dz-dont-panic-when-request_irq-fails.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: don't panic() when request_irq() fails
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Well, panic() is a little bit undue if request_irq() fails; there is probably
no need to justify it any further.  Handle the case gracefully, by
unregistering the driver.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/serial/dz.c~dz-dont-panic-when-request_irq-fails drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-dont-panic-when-request_irq-fails
+++ a/drivers/serial/dz.c
@@ -794,18 +794,28 @@ static int __init dz_init(void)
 	dz_reset(&dz_ports[0]);
 #endif
 
-	if (request_irq(dz_ports[0].port.irq, dz_interrupt,
-			IRQF_DISABLED, "DZ", &dz_ports[0]))
-		panic("Unable to register DZ interrupt");
-
 	ret = uart_register_driver(&dz_reg);
 	if (ret != 0)
-		return ret;
+		goto out;
+
+	ret = request_irq(dz_ports[0].port.irq, dz_interrupt, IRQF_DISABLED,
+			  "DZ", &dz_ports[0]);
+	if (ret != 0) {
+		printk(KERN_ERR "dz: Cannot get IRQ %d!\n",
+		       dz_ports[0].port.irq);
+		goto out_unregister;
+	}
 
 	for (i = 0; i < DZ_NB_PORT; i++)
 		uart_add_one_port(&dz_reg, &dz_ports[i].port);
 
 	return ret;
+
+out_unregister:
+	uart_unregister_driver(&dz_reg);
+
+out:
+	return ret;
 }
 
 module_init(dz_init);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
